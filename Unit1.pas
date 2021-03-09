unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  IdAuthentication{?}, mmsystem, ShellAPI, Jpeg, PNGImage, Vcl.ExtCtrls, Config,
  RegularExpressions, TlHelp32, Vcl.Clipbrd;

type

  TFleToDestination = record
    fileName : string;
    dest : string;
  end;

  TFilesToSend = class(TObject)
     list : array of TFleToDestination;
     count : integer;
     ready : boolean;


    public
      procedure Add( fileName, dest : string);
      function Get() : TFleToDestination;
      function Empty() : boolean;
    protected
    private
end;

  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Timer1: TTimer;
    Button2: TButton;
    storeImagesCheckbox: TCheckBox;
    launchRustOnStartupCheckbox: TCheckBox;
    launchRustOnStartupAndConnectToServerCheckbox: TCheckBox;
    rustServerEdit: TEdit;
    closeStashPicTimer: TTimer;
    closeStashPicOnRustCloseCheckbox: TCheckBox;
    usiEdit: TEdit;
    regenerateButton: TButton;
    copyToBufferButton: TButton;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure SendPic();
    procedure Button2Click(Sender: TObject);
    procedure storeImagesCheckboxClick(Sender: TObject);
    procedure launchRustOnStartupCheckboxClick(Sender: TObject);
    procedure launchRustOnStartupAndConnectToServerCheckboxClick(
      Sender: TObject);
    procedure rustServerEditChange(Sender: TObject);
    procedure closeStashPicOnRustCloseCheckboxClick(Sender: TObject);
    procedure closeStashPicTimerTimer(Sender: TObject);
    procedure regenerateButtonClick(Sender: TObject);
    procedure copyToBufferButtonClick(Sender: TObject);
  private
  procedure WMHotkey( var msg: TWMHotkey ); message WM_HOTKEY;
  function GetScreenShot(area, quality, fileType:integer):string;
    { Private declarations }
  public
    { Public declarations }
  end;

const
  SCREEN_ALL_AREA = 0;
  SCREEN_CENTER_AREA = 1;
  SCREEN_STASH_AREA = 2;

  JPG_FILE = 0;
  PNG_FILE = 1;

  MAX_ALLOWED_IMAGE_WIDTH = 1920;
  MAX_ALLOWED_IMAGE_HEIGHT = 1080;

var
  Form1: TForm1;
  fTS : TFilesToSend;
  baseDir : string;
  stashPic, mapPartPic : string;
  cfg : TConfig;
  rustHasBeenLaunched : boolean = false;

implementation
uses SendFileToServer;
{$R *.dfm}




procedure TFilesToSend.Add(fileName, dest : string);
begin
  count := Length(list)+1;
  SetLength(list, count);
  list[High(list)].fileName := fileName;
  list[High(list)].dest := dest;
end;

function TFilesToSend.Get() : TFleToDestination;
var i:integer;
    res : TFleToDestination;
begin
  if count = 0 then Exit(res);

  res := list[0];
  for i:= 1 to High(list) do
  begin
    list[i-1] := list[i];
  end;
  count := count - 1;
  SetLength(list, count);
  Exit(res);
end;

function TFilesToSend.Empty() : boolean;
begin
  if count > 0 then Exit(false) else Exit(true);
end;

function processCount(exeFileName: string): integer;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  Result := 0;
  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeFileName))) then inc(Result);
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

procedure TForm1.SendPic();
var a : TSendFileToServer;
begin
if (not fts.Empty) and (fts.ready) then
a := TSendFileToServer.Create();
end;


procedure TForm1.storeImagesCheckboxClick(Sender: TObject);
begin
cfg.storeImages := storeImagesCheckbox.Checked;
cfg.save;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
SendPic;
end;



procedure TForm1.Button2Click(Sender: TObject);
begin
ShellExecute(0,'open',PChar('steam://connect/149.202.65.76:28015'),nil,nil, SW_SHOWNORMAL);
end;

procedure TForm1.closeStashPicOnRustCloseCheckboxClick(Sender: TObject);
begin
  cfg.closeStashPicOnRustClose := closeStashPicOnRustCloseCheckbox.Checked;
  closeStashPicTimer.Enabled := closeStashPicOnRustCloseCheckbox.Checked;
  cfg.save;
end;

procedure TForm1.closeStashPicTimerTimer(Sender: TObject);
var rustRunning : boolean;
begin
if (processCount('rustclient.exe') > 0) then rustRunning := true;
if rustRunning then rustHasBeenLaunched := true;
if (rustHasBeenLaunched and not rustRunning) then Application.Terminate;
end;

procedure TForm1.copyToBufferButtonClick(Sender: TObject);
begin
ClipBoard.AsText := usiEdit.Text;
copyToBufferButton.Caption := 'Copied!';
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
UnRegisterHotkey( Handle, 1 );
UnRegisterHotkey( Handle, 2 );
UnRegisterHotkey( Handle, 3 );
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  if processCount(ExtractFileName(Application.ExeName)) > 1 then Application.Terminate;

  cfg := TConfig.Create;
  cfg.init;
  cfg.load;
  storeImagesCheckbox.Checked := cfg.storeImages;
  launchRustOnStartupCheckbox.Checked := cfg.launchRustOnStartup;
  launchRustOnStartupAndConnectToServerCheckbox.Checked := cfg.launchRustOnStartupAndConnectToServer;
  rustServerEdit.Text := cfg.rustServerAddress;
  if launchRustOnStartupCheckbox.Checked then
  begin
    launchRustOnStartupAndConnectToServerCheckbox.Enabled := true;
    rustServerEdit.Enabled := true;
  end
  else
  begin
    launchRustOnStartupAndConnectToServerCheckbox.Enabled := false;
    rustServerEdit.Enabled := false;
  end;
  closeStashPicOnRustCloseCheckbox.Checked := cfg.closeStashPicOnRustClose;
  if closeStashPicOnRustCloseCheckbox.Checked then closeStashPicTimer.Enabled := true;


  baseDir :=  ExtractFileDir(Application.ExeName);
  if (not DirectoryExists(baseDir + cfg.picsFolder)) then CreateDir(baseDir + cfg.picsFolder);

  usiEdit.Text := cfg.usi;

  stashPic := 'stash_picture';
  mapPartPic := 'map_part_picture';
  fts := TFilesToSend.Create;
  fts.ready := true;
  if not RegisterHotkey(Handle, 1, MOD_ALT, 49) then //1
    ShowMessage('Unable to assign WIN+V as hotkey.');

  if not RegisterHotkey(Handle, 2, MOD_ALT, 50) then //2
    ShowMessage('Unable to assign WIN+V as hotkey.');

  if not RegisterHotkey(Handle, 3, MOD_ALT, 51) then //3
    ShowMessage('Unable to assign WIN+V as hotkey.');

  if not RegisterHotkey(Handle, 4, MOD_ALT, 52) then //4
    ShowMessage('Unable to assign WIN+V as hotkey.');

  if (cfg.launchRustOnStartupAndConnectToServer) then
  begin
    ShellExecute(0,'open',PChar('steam://connect/'+cfg.rustServerAddress),nil,nil, SW_SHOWNORMAL);
  end
  else begin
    if cfg.launchRustOnStartup then ShellExecute(0,'open',PChar('steam://rungameid/252490'),nil,nil, SW_SHOWNORMAL);
  end;

end;

procedure TForm1.WMHotkey( var msg: TWMHotkey );
begin
  if msg.hotkey = 1 then
  begin
    fts.Add(GetScreenShot(SCREEN_ALL_AREA, 50, JPG_FILE), stashPic);
    PlaySoundA('media/shutter.wav',0, SND_ASYNC);
  end;
  if msg.hotkey = 2 then
  begin
    fts.Add(GetScreenShot(SCREEN_CENTER_AREA, 60, JPG_FILE), stashPic);
    PlaySoundA('media/shutter.wav',0, SND_ASYNC);
  end;
  if msg.hotkey = 3 then
  begin
    fts.Add(GetScreenShot(SCREEN_STASH_AREA, 90, JPG_FILE), stashPic);
    PlaySoundA('media/shutter.wav',0, SND_ASYNC);
  end;
  if msg.hotkey = 4 then
  begin
    fts.Add(GetScreenShot(SCREEN_ALL_AREA, 1, PNG_FILE), mapPartPic);
    PlaySoundA('media/shutter.wav',0, SND_ASYNC);
  end;
end;

function TForm1.GetScreenShot(area, quality, fileType : integer):string;
var
  w,h,x,y: integer;
  DC: HDC;
  hWin: Cardinal;
  r: TRect;
  tmpBmp: TBitmap;
  jpg: TJpegImage;
  png : TPNGImage;
  fileName: string;
  currentMonthFolder : string;
begin
  hWin := 0;
  //active window
  hWin := GetForegroundWindow;
  dc := GetWindowDC(hWin);
  GetWindowRect(hWin,r);
  w := r.Right - r.Left;
  h := r.Bottom - r.Top;

  tmpBmp := TBitmap.Create;
  try

  case area of
    SCREEN_ALL_AREA:
      begin
        tmpBmp.Width := w;
        tmpBmp.Height := h;
        x:=0;
        y:=0;
      end;
    SCREEN_CENTER_AREA:
      begin
        tmpBmp.Width := round(w*0.5);
        tmpBmp.Height := round(h*0.5);
        x:=round(w*0.25);
        y:=round(h*0.25);
      end;
    SCREEN_STASH_AREA:
      begin
        tmpBmp.Width := round(w*0.2901);
        tmpBmp.Height := round(h*0.0851);
        x:=round(w*0.6536);
        y:=round(h*0.7639);
      end;
  end;

  BitBlt(tmpBmp.Canvas.Handle,0,0,tmpBmp.Width,tmpBmp.Height,dc,x,y,SRCCOPY);
  if (area = SCREEN_ALL_AREA) AND (tmpBmp.Width > MAX_ALLOWED_IMAGE_WIDTH) then
  begin
    PlaySoundA('tada.wav',0, SND_ASYNC);
    tmpBmp.Canvas.StretchDraw( Rect(0, 0, MAX_ALLOWED_IMAGE_WIDTH, MAX_ALLOWED_IMAGE_HEIGHT), tmpBmp);
    tmpBmp.SetSize(MAX_ALLOWED_IMAGE_WIDTH, MAX_ALLOWED_IMAGE_HEIGHT);
  end;

  case fileType of
    JPG_FILE:
      begin
        jpg := TJPEGImage.Create;
        jpg.Assign(tmpBmp);
        jpg.CompressionQuality := quality;
        jpg.Compress;

        if cfg.storeImages then begin
          currentMonthFolder := '\' + FormatDateTime('YYYY-mm',Now);
          if (not DirectoryExists(baseDir + cfg.picsFolder + currentMonthFolder)) then CreateDir(baseDir + cfg.picsFolder + currentMonthFolder);
          fileName := baseDir + cfg.picsFolder + currentMonthFolder + '\' + FormatDateTime('YYYY-mm-dd hh-nn-ss.zzz', Now)+'.jpg';
        end
        else
        begin
          fileName := baseDir + cfg.picsFolder + '\' + FormatDateTime('YYYY-mm-dd hh-nn-ss.zzz', Now)+'.jpg';
        end;

        jpg.SaveToFile(fileName);
        jpg.Free;

      end;
    PNG_FILE:
      begin
        png := TPNGImage.Create;
        png.Assign(tmpBmp);

        if cfg.storeImages then begin
          currentMonthFolder := '\' + FormatDateTime('YYYY-mm',Now);
          if (not DirectoryExists(baseDir + cfg.picsFolder + currentMonthFolder)) then CreateDir(baseDir + cfg.picsFolder + currentMonthFolder);
          fileName := baseDir + cfg.picsFolder + currentMonthFolder + '\' + FormatDateTime('YYYY-mm-dd hh-nn-ss.zzz', Now)+'.png';
        end
        else
        begin
          fileName := baseDir + cfg.picsFolder + '\' + FormatDateTime('YYYY-mm-dd hh-nn-ss.zzz', Now)+'.png';
        end;

        png.CompressionLevel := quality;
        png.SaveToFile(fileName);
        png.Free;

      end;
  end;



  finally
    ReleaseDC(hWin,DC);
    FreeAndNil(tmpBmp);
  end;  //try-finally
  Result := fileName;
end;

procedure TForm1.launchRustOnStartupAndConnectToServerCheckboxClick(
  Sender: TObject);
begin
cfg.launchRustOnStartupAndConnectToServer := launchRustOnStartupAndConnectToServerCheckbox.Checked;
cfg.save;

end;

procedure TForm1.launchRustOnStartupCheckboxClick(Sender: TObject);
begin
cfg.launchRustOnStartup := launchRustOnStartupCheckbox.Checked;
cfg.save;
  if launchRustOnStartupCheckbox.Checked then
  begin
    launchRustOnStartupAndConnectToServerCheckbox.Enabled := true;
    rustServerEdit.Enabled := true;
  end
  else
  begin
    launchRustOnStartupAndConnectToServerCheckbox.Enabled := false;
    rustServerEdit.Enabled := false;
    rustServerEdit.Color := clWhite;
    launchRustOnStartupAndConnectToServerCheckbox.Checked := false;
    cfg.launchRustOnStartupAndConnectToServer := false;
    cfg.save;
  end;

end;

procedure TForm1.regenerateButtonClick(Sender: TObject);
var
  buttonSelected : Integer;
begin
  buttonSelected := MessageDlg('Are you sure you want to regenerate the sender ID?',mtConfirmation, mbYesNo, 0);
  if buttonSelected = mrYes then
  begin
    cfg.usi := cfg.newUsi;
    cfg.save;
    usiEdit.Text := cfg.usi;
    copyToBufferButton.Caption := 'Copy to clipboard';
  end;
end;

procedure TForm1.rustServerEditChange(Sender: TObject);
var match:TMatch;
    ipPortRegExp : String;
begin

try
  ipPortRegExp := '\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?):\d{2,5}\b';
  if TRegEx.IsMatch(rustServerEdit.Text, ipPortRegExp) then
  begin
    rustServerEdit.Color := clMoneyGreen;
    rustServerEdit.Hint := 'Correct server IP:Port';
    match := TRegEx.Match(rustServerEdit.Text, ipPortRegExp);
    cfg.rustServerAddress := match.Value;
    cfg.save;
    rustServerEdit.Text := match.Value;
  end
  else
  begin
    rustServerEdit.Color := clSilver;
    rustServerEdit.Hint := 'Incorrect server IP:Port';
  end
  except
    on E: Exception do
      Caption := E.ClassName + ': ' + E.Message;
  end;

end;






end.
