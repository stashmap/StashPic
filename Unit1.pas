unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  IdAuthentication{?}, mmsystem, ShellAPI, Jpeg, PNGImage, Vcl.ExtCtrls, Config;

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
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure SendPic();
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure storeImagesCheckboxClick(Sender: TObject);
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

var
  Form1: TForm1;
  fTS : TFilesToSend;
  fileName, baseDir : string;
  stashPic, mapPartPic : string;
  cfg : TConfig;

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

procedure TForm1.Button1Click(Sender: TObject);
begin
ShellExecute(0,'open',PChar('steam://rungameid/252490'),nil,nil, SW_SHOWNORMAL);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
ShellExecute(0,'open',PChar('steam://connect/149.202.65.76:28015'),nil,nil, SW_SHOWNORMAL);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
UnRegisterHotkey( Handle, 1 );
UnRegisterHotkey( Handle, 2 );
UnRegisterHotkey( Handle, 3 );
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
//ShellExecute(0,'open',PChar('steam://rungameid/252490'),nil,nil, SW_SHOWNORMAL);
cfg := TConfig.Create;
cfg.init;
cfg.load;
storeImagesCheckbox.Checked := cfg.storeImages;

baseDir :=  ExtractFileDir(Application.ExeName);
if (not DirectoryExists(baseDir + cfg.picsFolder)) then CreateDir(baseDir + cfg.picsFolder);


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

procedure CropBitmap(InBitmap : TBitmap; X, Y, W, H :Integer);
begin
  BitBlt(InBitmap.Canvas.Handle, 0, 0, W, H, InBitmap.Canvas.Handle, X, Y, SRCCOPY);
  InBitmap.Width :=W;
  InBitmap.Height:=H;
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

//        CropBitmap(tmpBmp, round(tmpBmp.Width*0.25), round(tmpBmp.Height*0.25), round(tmpBmp.Width*0.5), round(tmpBmp.Height*0.5));
      end;
    SCREEN_STASH_AREA:
      begin
        tmpBmp.Width := round(w*0.2901);
        tmpBmp.Height := round(h*0.0851);
        x:=round(w*0.6536);
        y:=round(h*0.7639);
//        CropBitmap(tmpBmp, round(tmpBmp.Width*0.6536), round(tmpBmp.Height*0.7639), round(tmpBmp.Width*0.2901), round(tmpBmp.Height*0.0851));
      end;
  end;

    BitBlt(tmpBmp.Canvas.Handle,0,0,tmpBmp.Width,tmpBmp.Height,dc,x,y,SRCCOPY);

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

end.
