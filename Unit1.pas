unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  IdAuthentication{?}, mmsystem, ShellAPI, Jpeg, PNGImage, Vcl.ExtCtrls, Config,
  RegularExpressions, TlHelp32, Vcl.Clipbrd, Vcl.ComCtrls, IdMultipartFormData,
  IdHTTP, System.ImageList, Vcl.ImgList;
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
    Timer1: TTimer;
    closeStashPicTimer: TTimer;
    buttonPanel: TPanel;
    settingsImage: TImage;
    hotkeysImage: TImage;
    rustImage: TImage;
    aboutImage: TImage;
    settingsImageList: TImageList;
    hotkeysImageList: TImageList;
    hotkeysPanel: TPanel;
    aboutImageList: TImageList;
    rustImageList: TImageList;
    settingsPanel: TPanel;
    rustPanel: TPanel;
    aboutPanel: TPanel;
    usiLabel: TLabel;
    scaleLable: TLabel;
    usiEdit: TEdit;
    regenerateButton: TButton;
    copyToBufferButton: TButton;
    scaleBar: TTrackBar;
    selectFolderButton: TButton;
    openFolderButton: TButton;
    storeImagesCheckbox: TCheckBox;
    Label1: TLabel;
    editHotkey1Button: TButton;
    editHotkey2Button: TButton;
    Label2: TLabel;
    Label3: TLabel;
    editHotkey3Button: TButton;
    editHotkey4Button: TButton;
    Label4: TLabel;
    launchRustOnStartupCheckbox: TCheckBox;
    launchRustOnStartupAndConnectToServerCheckbox: TCheckBox;
    closeStashPicOnRustCloseCheckbox: TCheckBox;
    rustServerEdit: TEdit;
    connectToServerButton: TButton;
    logMemo: TMemo;
    autoUpdateCheckBox: TCheckBox;
    updateTokenLabel: TLabel;
    updateTokenEdit: TEdit;
    updateButton: TButton;
    appNameLabel: TLabel;
    runRustButton: TButton;
    sourceLabel: TLabel;
    discordLabel: TLabel;
    mailLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Reset();
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure SendPic();
    procedure storeImagesCheckboxClick(Sender: TObject);
    procedure launchRustOnStartupCheckboxClick(Sender: TObject);
    procedure launchRustOnStartupAndConnectToServerCheckboxClick(
      Sender: TObject);
    procedure rustServerEditChange(Sender: TObject);
    procedure closeStashPicOnRustCloseCheckboxClick(Sender: TObject);
    procedure closeStashPicTimerTimer(Sender: TObject);
    procedure regenerateButtonClick(Sender: TObject);
    procedure copyToBufferButtonClick(Sender: TObject);
    procedure scaleBarChange(Sender: TObject);
    procedure editHotkey1ButtonClick(Sender: TObject);
    procedure editHotkey2ButtonClick(Sender: TObject);
    procedure editHotkey3ButtonClick(Sender: TObject);
    procedure editHotkey4ButtonClick(Sender: TObject);
    function registerHotkeyByCode(hotkeyNumber : integer; hotkeyCodeStr : string):boolean;
    procedure selectFolderButtonClick(Sender: TObject);
    procedure openFolderButtonClick(Sender: TObject);
    procedure updateTokenEditChange(Sender: TObject);
    procedure updateButtonClick(Sender: TObject);
    procedure settingsImageClick(Sender: TObject);
    procedure settingsImageMouseEnter(Sender: TObject);
    procedure settingsImageMouseLeave(Sender: TObject);
    procedure hotkeysImageClick(Sender: TObject);
    procedure hotkeysImageMouseLeave(Sender: TObject);
    procedure rustImageClick(Sender: TObject);
    procedure rustImageMouseEnter(Sender: TObject);
    procedure rustImageMouseLeave(Sender: TObject);
    procedure hotkeysImageMouseEnter(Sender: TObject);
    procedure aboutImageClick(Sender: TObject);
    procedure aboutImageMouseEnter(Sender: TObject);
    procedure aboutImageMouseLeave(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure connectToServerButtonClick(Sender: TObject);
    procedure runRustButtonClick(Sender: TObject);
    procedure sourceLabelClick(Sender: TObject);
    procedure discordLabelClick(Sender: TObject);
  private
  procedure WMHotkey( var msg: TWMHotkey ); message WM_HOTKEY;
  function GetScreenShot(area, quality, fileType:integer):string;
    { Private declarations }
  public
    { Public declarations }
  end;

const
  VERSION = '1.0.0.0';

  SCREEN_ALL_AREA = 0;
  SCREEN_CENTER_AREA = 1;
  SCREEN_STASH_AREA = 2;

  JPG_FILE = 0;
  PNG_FILE = 1;

  MAX_ALLOWED_IMAGE_WIDTH = 1920;
  MAX_ALLOWED_IMAGE_HEIGHT = 1080;

  REST = 0;
  HOVER = 1;
  PRESSED = 2;

var
  Form1: TForm1;
  fTS : TFilesToSend;
  baseDir : string;
  stashPic, mapPartPic : string;
  cfg : TConfig;
  rustHasBeenLaunched : boolean = false;
  hotkeyCodeString : string;
  hotkeyAsString : string;

  settingsPressed : boolean = false;
  hotkeysPressed : boolean = false;
  rustPressed : boolean = false;
  aboutPressed : boolean = false;

implementation
uses SendFileToServer, editHotkey;
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
begin
  if (not fts.Empty) and (fts.ready) then
  TSendFileToServer.Create();
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

procedure TForm1.updateButtonClick(Sender: TObject);
begin
  ShellExecute(0, 'open', Pchar( baseDir + '\Update.exe'), nil, nil, SW_SHOWNORMAL) ;
  Application.Terminate;
end;

procedure TForm1.updateTokenEditChange(Sender: TObject);
begin
  cfg.updateToken := updateTokenEdit.Text;
  cfg.save;
end;

procedure TForm1.scaleBarChange(Sender: TObject);
begin
  scaleLable.Caption := 'Rust user interface scale : ' + floattostr(scaleBar.Position/100);
  cfg.scale := scaleBar.Position/100;
  cfg.save;
end;

procedure TForm1.selectFolderButtonClick(Sender: TObject);
var
  OpenDialog: TFileOpenDialog;
begin
  OpenDialog := TFileOpenDialog.Create(Form1);
  try
    OpenDialog.Options := OpenDialog.Options + [fdoPickFolders];
    OpenDialog.DefaultFolder := cfg.picsFolder;
    if not OpenDialog.Execute then Abort;
    cfg.picsFolder := OpenDialog.FileName;
    cfg.save;
  finally
    OpenDialog.Free;
  end;
end;

function TForm1.registerHotkeyByCode(hotkeyNumber : integer; hotkeyCodeStr : string):boolean;
var Modifiers: UINT;
    key : Cardinal;
begin
  Modifiers := 0;
  if (hotkeyCodeStr[1] = '1') then Modifiers := Modifiers OR MOD_CONTROL;
  if (hotkeyCodeStr[2] = '1') then Modifiers := Modifiers OR MOD_ALT;
  if (hotkeyCodeStr[3] = '1') then Modifiers := Modifiers OR MOD_SHIFT;
  key := StrToInt(Copy(hotkeyCodeStr,4,3));
  Result := RegisterHotKey(Handle, hotkeyNumber, Modifiers, Key);
end;

procedure TForm1.editHotkey1ButtonClick(Sender: TObject);
begin
  hotkeyCodeString := cfg.hotkeyCaptureFullscreenCode;
  editHotkeyForm.ShowModal;
  if hotkeyAsString = '' then exit;
  UnRegisterHotkey(Handle, 1);
  if (registerHotkeyByCode(1, hotkeyCodeString)) then
  begin
    editHotkey1Button.Caption := hotkeyAsString;
    cfg.hotkeyCaptureFullscreen := hotkeyAsString;
    cfg.hotkeyCaptureFullscreenCode := hotkeyCodeString;
    cfg.save;
  end
  else
  begin
    ShowMessage('Unable to assign '+hotkeyAsString+' as hotkey.');
    registerHotkeyByCode(1, cfg.hotkeyCaptureFullscreenCode);
  end;
end;

procedure TForm1.editHotkey2ButtonClick(Sender: TObject);
begin
  hotkeyCodeString := cfg.hotkeyCaptureRectangleCenterCode;
  editHotkeyForm.ShowModal;
  if hotkeyAsString = '' then exit;
  UnRegisterHotkey(Handle, 2);
  if (registerHotkeyByCode(2, hotkeyCodeString)) then
  begin
    editHotkey2Button.Caption := hotkeyAsString;
    cfg.hotkeyCaptureRectangleCenter := hotkeyAsString;
    cfg.hotkeyCaptureRectangleCenterCode := hotkeyCodeString;
    cfg.save;
  end
  else
  begin
    ShowMessage('Unable to assign '+hotkeyAsString+' as hotkey.');
    registerHotkeyByCode(2, cfg.hotkeyCaptureRectangleCenterCode);
  end;


end;

procedure TForm1.editHotkey3ButtonClick(Sender: TObject);
begin
  hotkeyCodeString := cfg.hotkeyCaptureStashAreaCode;
  editHotkeyForm.ShowModal;
  if hotkeyAsString = '' then exit;
  UnRegisterHotkey(Handle, 3);
  if (registerHotkeyByCode(3, hotkeyCodeString)) then
  begin
    editHotkey3Button.Caption := hotkeyAsString;
    cfg.hotkeyCaptureStashArea := hotkeyAsString;
    cfg.hotkeyCaptureStashAreaCode := hotkeyCodeString;
    cfg.save;
  end
  else
  begin
    ShowMessage('Unable to assign '+hotkeyAsString+' as hotkey.');
    registerHotkeyByCode(3, cfg.hotkeyCaptureStashAreaCode );
  end;
end;

procedure TForm1.editHotkey4ButtonClick(Sender: TObject);
begin
  hotkeyCodeString := cfg.hotkeyCaptureFullscreenMapPartCode;
  editHotkeyForm.ShowModal;
  if hotkeyAsString = '' then exit;
  UnRegisterHotkey(Handle, 4);
  if (registerHotkeyByCode(4, hotkeyCodeString)) then
  begin
    editHotkey4Button.Caption := hotkeyAsString;
    cfg.hotkeyCaptureFullscreenMapPart := hotkeyAsString;
    cfg.hotkeyCaptureFullscreenMapPartCode := hotkeyCodeString;
    cfg.save;
  end
  else
  begin
    ShowMessage('Unable to assign '+hotkeyAsString+' as hotkey.');
    registerHotkeyByCode(4, cfg.hotkeyCaptureFullscreenMapPartCode );
  end;
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
  rustRunning := false;
  if (processCount('rustclient.exe') > 0) then rustRunning := true;
  if rustRunning then rustHasBeenLaunched := true;
  if (rustHasBeenLaunched and not rustRunning) then Application.Terminate;
end;

procedure TForm1.copyToBufferButtonClick(Sender: TObject);
begin
  ClipBoard.AsText := usiEdit.Text;
  copyToBufferButton.Caption := 'Copied!';
end;

procedure TForm1.discordLabelClick(Sender: TObject);
begin
  ShellExecute(0,'open',PChar('https://discord.gg/HmSgK9BT'),nil,nil, SW_SHOWNORMAL);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  UnRegisterHotkey( Handle, 1 );
  UnRegisterHotkey( Handle, 2 );
  UnRegisterHotkey( Handle, 3 );
  UnRegisterHotkey( Handle, 4 );
end;

procedure TForm1.Reset();
begin
  settingsPanel.Visible := false;
  settingsPressed := false;
  settingsImage.Picture := nil;
  settingsImagelist.GetBitmap(REST, settingsImage.Picture.Bitmap);

  hotkeysPanel.Visible := false;
  hotkeysPressed := false;
  hotkeysImage.Picture := nil;
  hotkeysImageList.GetBitmap(REST, hotkeysImage.Picture.Bitmap);

  rustPanel.Visible := false;
  rustPressed := false;
  rustImage.Picture := nil;
  rustImageList.GetBitmap(REST, rustImage.Picture.Bitmap);

  aboutPanel.Visible := false;
  aboutPressed := false;
  aboutImage.Picture := nil;
  aboutImageList.GetBitmap(REST, aboutImage.Picture.Bitmap);
end;


procedure TForm1.FormCreate(Sender: TObject);
var formData: TIdMultiPartFormDataStream;
    idHTTP : TIdHTTP;
    s : string;
begin
  if processCount(ExtractFileName(Application.ExeName)) > 1 then Application.Terminate;

  baseDir := ExtractFileDir(Application.ExeName);
  cfg := TConfig.Create;
  cfg.init(baseDir);
  cfg.load;

  if (not DirectoryExists(cfg.picsFolder)) then CreateDir(cfg.picsFolder);

  storeImagesCheckbox.Checked := cfg.storeImages;
  launchRustOnStartupCheckbox.Checked := cfg.launchRustOnStartup;
  launchRustOnStartupAndConnectToServerCheckbox.Checked := cfg.launchRustOnStartupAndConnectToServer;
  rustServerEdit.Text := cfg.rustServerAddress;
  launchRustOnStartupAndConnectToServerCheckbox.Enabled := launchRustOnStartupCheckbox.Checked;
  closeStashPicOnRustCloseCheckbox.Checked := cfg.closeStashPicOnRustClose;
  if closeStashPicOnRustCloseCheckbox.Checked then closeStashPicTimer.Enabled := true;

  usiEdit.Text := cfg.usi;
  scaleLable.Caption := 'Rust user interface scale : ' + floattostr(cfg.scale);
  scaleBar.Position := round(cfg.scale*100);

  editHotkey1Button.Caption := cfg.hotkeyCaptureFullscreen;
  editHotkey2Button.Caption := cfg.hotkeyCaptureRectangleCenter;
  editHotkey3Button.Caption := cfg.hotkeyCaptureStashArea;
  editHotkey4Button.Caption := cfg.hotkeyCaptureFullscreenMapPart;

  autoUpdateCheckBox.Checked := cfg.automaticUpdate;
  updateTokenEdit.Text := cfg.updateToken;

  if cfg.automaticUpdate then
  begin
    IdHTTP := TIdHTTP.Create;
    formData := TIdMultiPartFormDataStream.Create;
    formData.AddFormField('version', VERSION);
    formData.AddFormField('updateToken', cfg.updateToken);
    if IdHTTP.Post('http://stashmap.net/stashpic/update/check', formData) = 'new_version_available' then
    begin
      ShellExecute(0, 'open', Pchar( baseDir + '\Update.exe'), nil, nil, SW_SHOWNORMAL) ;
      Application.Terminate;
    end;
    IdHTTP.Destroy;
    formData.Destroy;
  end;



  stashPic := 'stash_picture';
  mapPartPic := 'map_part_picture';
  fts := TFilesToSend.Create;
  fts.ready := true;
  if not registerHotkeyByCode(1, cfg.hotkeyCaptureFullscreenCode) then
    ShowMessage('Unable to assign '+cfg.hotkeyCaptureFullscreen+' as hotkey.');

  if not registerHotkeyByCode(2, cfg.hotkeyCaptureRectangleCenterCode) then
    ShowMessage('Unable to assign '+cfg.hotkeyCaptureRectangleCenter+' as hotkey.');

  if not registerHotkeyByCode(3, cfg.hotkeyCaptureStashAreaCode) then
    ShowMessage('Unable to assign '+cfg.hotkeyCaptureStashArea+' as hotkey.');

  if not registerHotkeyByCode(4, cfg.hotkeyCaptureFullscreenMapPartCode) then
    ShowMessage('Unable to assign '+cfg.hotkeyCaptureFullscreenMapPart+' as hotkey.');

  if (cfg.launchRustOnStartupAndConnectToServer) then
  begin
    ShellExecute(0,'open',PChar('steam://connect/'+cfg.rustServerAddress),nil,nil, SW_SHOWNORMAL);
  end
  else
  begin
    if cfg.launchRustOnStartup then ShellExecute(0,'open',PChar('steam://rungameid/252490'),nil,nil, SW_SHOWNORMAL);
  end;

  reset;
  if cfg.tab = 'settings' then
  begin
    settingsPressed := true;
    settingsPanel.Visible := true;
    settingsImage.Picture := nil;
    settingsImagelist.GetBitmap(PRESSED, settingsImage.Picture.Bitmap);
  end;
  if cfg.tab = 'hotkeys' then
  begin
    hotkeysPressed := true;
    hotkeysPanel.Visible := true;
    hotkeysImage.Picture := nil;
    hotkeysImagelist.GetBitmap(PRESSED, hotkeysImage.Picture.Bitmap);
  end;
  if cfg.tab = 'rust' then
  begin
    rustPressed := true;
    rustPanel.Visible := true;
    rustImage.Picture := nil;
    rustImagelist.GetBitmap(PRESSED, rustImage.Picture.Bitmap);
  end;
  if cfg.tab = 'about' then
  begin
    aboutPressed := true;
    aboutPanel.Visible := true;
    aboutImage.Picture := nil;
    aboutImagelist.GetBitmap(PRESSED, aboutImage.Picture.Bitmap);
    logMemo.ScrollBars := ssVertical; // Bugfix for -> Project raised exception class EOSerror with message 'System Error. Code: 1400" on app exit.
  end;

  s := VERSION;
  System.Delete(s, LastDelimiter('.',VERSION), 10 );
  appNameLabel.Caption := 'StashPic ' + s;
  Form1.Top := cfg.formTop;
  Form1.Left := cfg.formLeft;
  Form1.AutoSize := true;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  cfg.formTop := Form1.Top;
  cfg.formLeft := Form1.Left;
  cfg.save;
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

function getTopLeftXofStashAreaUsingScale(scale:real):real;
begin
  Result := (0.2492+0.0776*scale)/0.5;
end;

function getTopLeftYofStashAreaUsingScale(scale:real):real;
begin
  Result := (0.49905-0.1171*scale)/0.5;
end;

function getWidthofStashAreaUsingScale(scale:real):real;
begin
  Result := (0.00185+0.1432*scale)/0.5;
end;

function getHeightofStashAreaUsingScale(scale:real):real;
begin
  Result := (0.00285+0.039699*scale)/0.5;
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
  x:=0;
  y:=0;


  tmpBmp := TBitmap.Create;
  try

  case area of
    SCREEN_ALL_AREA:
      begin
        tmpBmp.Width := w;
        tmpBmp.Height := h;
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
        tmpBmp.Width := round(w*getWidthofStashAreaUsingScale(cfg.scale));
        tmpBmp.Height := round(h*getHeightofStashAreaUsingScale(cfg.scale));
        x:=round(w*getTopLeftXofStashAreaUsingScale(cfg.scale));
        y:=round(h*getTopLeftYofStashAreaUsingScale(cfg.scale));
      end;
  end;

  BitBlt(tmpBmp.Canvas.Handle,0,0,tmpBmp.Width,tmpBmp.Height,dc,x,y,SRCCOPY);
  if (area = SCREEN_ALL_AREA) AND (tmpBmp.Width > MAX_ALLOWED_IMAGE_WIDTH) then
  begin
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
          if (not DirectoryExists(cfg.picsFolder + currentMonthFolder)) then CreateDir(cfg.picsFolder + currentMonthFolder);
          fileName := cfg.picsFolder + currentMonthFolder + '\' + FormatDateTime('YYYY-mm-dd hh-nn-ss.zzz', Now)+'.jpg';
        end
        else
        begin
          fileName := baseDir + '\' + FormatDateTime('YYYY-mm-dd hh-nn-ss.zzz', Now)+'.jpg';
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
          if (not DirectoryExists(cfg.picsFolder + currentMonthFolder)) then CreateDir(cfg.picsFolder + currentMonthFolder);
          fileName := cfg.picsFolder + currentMonthFolder + '\' + FormatDateTime('YYYY-mm-dd hh-nn-ss.zzz', Now)+'.png';
        end
        else
        begin
          fileName := baseDir + '\' + FormatDateTime('YYYY-mm-dd hh-nn-ss.zzz', Now)+'.png';
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
  end
  else
  begin
    launchRustOnStartupAndConnectToServerCheckbox.Enabled := false;
    launchRustOnStartupAndConnectToServerCheckbox.Checked := false;
    cfg.launchRustOnStartupAndConnectToServer := false;
    cfg.save;
  end;

end;

procedure TForm1.openFolderButtonClick(Sender: TObject);
begin
  ShellExecute(Application.Handle, PChar('explore'), PChar(cfg.picsFolder), nil, nil, SW_SHOWNORMAL);
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

procedure TForm1.settingsImageClick(Sender: TObject);
begin
  cfg.tab := 'settings';
  cfg.save;
  Reset;
  settingsPressed := true;
  settingsPanel.Visible := true;
  settingsImage.Picture := nil;
  settingsImagelist.GetBitmap(PRESSED, settingsImage.Picture.Bitmap);
end;

procedure TForm1.settingsImageMouseEnter(Sender: TObject);
begin
  if settingsPressed then exit;
  settingsImage.Picture := nil;
  settingsImagelist.GetBitmap(HOVER, settingsImage.Picture.Bitmap);
end;

procedure TForm1.settingsImageMouseLeave(Sender: TObject);
begin
  if settingsPressed then exit;
  settingsImage.Picture := nil;
  settingsImagelist.GetBitmap(REST, settingsImage.Picture.Bitmap);
end;

procedure TForm1.sourceLabelClick(Sender: TObject);
begin
    ShellExecute(0,'open',PChar('https://github.com/stashmap/StashPic'),nil,nil, SW_SHOWNORMAL);
end;

procedure TForm1.hotkeysImageClick(Sender: TObject);
begin
  cfg.tab := 'hotkeys';
  cfg.save;
  Reset;
  hotkeysPressed := true;
  hotkeysPanel.Visible := true;
  hotkeysImage.Picture := nil;
  hotkeysImagelist.GetBitmap(PRESSED, hotkeysImage.Picture.Bitmap);
end;

procedure TForm1.hotkeysImageMouseEnter(Sender: TObject);
begin
  if hotkeysPressed then exit;
  hotkeysImage.Picture := nil;
  hotkeysImagelist.GetBitmap(HOVER, hotkeysImage.Picture.Bitmap);
end;

procedure TForm1.hotkeysImageMouseLeave(Sender: TObject);
begin
  if hotkeysPressed then exit;
  hotkeysImage.Picture := nil;
  hotkeysImagelist.GetBitmap(REST, hotkeysImage.Picture.Bitmap);
end;

procedure TForm1.rustImageClick(Sender: TObject);
begin
  cfg.tab := 'rust';
  cfg.save;
  Reset;
  rustPressed := true;
  rustPanel.Visible := true;
  rustImage.Picture := nil;
  rustImagelist.GetBitmap(PRESSED, rustImage.Picture.Bitmap);
end;

procedure TForm1.rustImageMouseEnter(Sender: TObject);
begin
  if rustPressed then exit;
  rustImage.Picture := nil;
  rustImagelist.GetBitmap(HOVER, rustImage.Picture.Bitmap);
end;

procedure TForm1.rustImageMouseLeave(Sender: TObject);
begin
  if rustPressed then exit;
  rustImage.Picture := nil;
  rustImagelist.GetBitmap(REST, rustImage.Picture.Bitmap);
end;

procedure TForm1.aboutImageClick(Sender: TObject);
begin
  cfg.tab := 'about';
  cfg.save;
  Reset;
  aboutPressed := true;
  aboutPanel.Visible := true;
  aboutImage.Picture := nil;
  aboutImagelist.GetBitmap(PRESSED, aboutImage.Picture.Bitmap);
  logMemo.ScrollBars := ssVertical; // Bugfix for -> Project raised exception class EOSerror with message 'System Error. Code: 1400" on app exit
end;

procedure TForm1.aboutImageMouseEnter(Sender: TObject);
begin
  if aboutPressed then exit;
  aboutImage.Picture := nil;
  aboutImagelist.GetBitmap(HOVER, aboutImage.Picture.Bitmap);
end;

procedure TForm1.aboutImageMouseLeave(Sender: TObject);
begin
  if aboutPressed then exit;
  aboutImage.Picture := nil;
  aboutImagelist.GetBitmap(REST, aboutImage.Picture.Bitmap);
end;

procedure TForm1.runRustButtonClick(Sender: TObject);
begin
  ShellExecute(0,'open',PChar('steam://rungameid/252490'),nil,nil, SW_SHOWNORMAL);
end;

procedure TForm1.connectToServerButtonClick(Sender: TObject);
begin
  ShellExecute(0,'open',PChar('steam://connect/'+cfg.rustServerAddress),nil,nil, SW_SHOWNORMAL);
end;

end.
