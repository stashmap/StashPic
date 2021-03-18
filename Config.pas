unit Config;

interface

uses Winapi.Windows, Registry, SysUtils;

type
  TConfig = class(TObject)

    usi : string;
    storeImages : boolean;
    launchRustOnStartup : boolean;
    launchRustOnStartupAndConnectToServer : boolean;
    rustServerAddress : string;
    closeStashPicOnRustClose : boolean;
    serverAddress : string;
    scale : real;

    hotkeyCaptureFullscreen : string;
    hotkeyCaptureFullscreenCode : string;
    hotkeyCaptureRectangleCenter : string;
    hotkeyCaptureRectangleCenterCode : string;
    hotkeyCaptureStashArea : string;
    hotkeyCaptureStashAreaCode : string;
    hotkeyCaptureFullscreenMapPart : string;
    hotkeyCaptureFullscreenMapPartCode : string;
    picsFolder : string;
    automaticUpdate : boolean;
    updateToken : string;
    tab : string;
    formTop : integer;
    formLeft : integer;


    const key = 'Software\StashPic\';
    picsFolderDefault = '\pics';
    procedure load();
    procedure save();
    procedure init(baseDir : string);
    function newUsi():string;
  end;
implementation


procedure TConfig.load();
var reg : TRegistry;
begin
  reg := TRegistry.Create(KEY_READ);
  reg.OpenKey(key, False);
  usi := reg.ReadString('usi');
  storeImages := reg.ReadBool('storeImages');
  picsFolder := reg.ReadString('picsFolder');
  launchRustOnStartup := reg.ReadBool('launchRustOnStartup');
  launchRustOnStartupAndConnectToServer := reg.ReadBool('launchRustOnStartupAndConnectToServer');
  rustServerAddress := reg.ReadString('rustServer');
  closeStashPicOnRustClose := reg.ReadBool('closeStashPicOnRustClose');
  serverAddress := reg.ReadString('serverAddress');
  scale := reg.ReadFloat('scale');
  hotkeyCaptureFullscreen := reg.ReadString('hotkeyCaptureFullscreen');
  hotkeyCaptureFullscreenCode := reg.ReadString('hotkeyCaptureFullscreenCode');
  hotkeyCaptureRectangleCenter := reg.ReadString('hotkeyCaptureRectangleCenter');
  hotkeyCaptureRectangleCenterCode := reg.ReadString('hotkeyCaptureRectangleCenterCode');
  hotkeyCaptureStashArea := reg.ReadString('hotkeyCaptureStashArea');
  hotkeyCaptureStashAreaCode := reg.ReadString('hotkeyCaptureStashAreaCode');
  hotkeyCaptureFullscreenMapPart := reg.ReadString('hotkeyCaptureFullscreenMapPart');
  hotkeyCaptureFullscreenMapPartCode := reg.ReadString('hotkeyCaptureFullscreenMapPartCode');
  automaticUpdate := reg.ReadBool('automaticUpdate');
  updateToken := reg.ReadString('updateToken');
  tab := reg.ReadString('tab');
  formLeft := reg.ReadInteger('formLeft');
  formTop := reg.ReadInteger('formTop');
  reg.CloseKey();
  reg.Free;
end;

procedure TConfig.save();
var reg : TRegistry;
begin
  reg := TRegistry.Create(KEY_WRITE);
  reg.OpenKey(key, False);
  reg.WriteString('usi', usi);
  reg.WriteBool('storeImages', storeImages);
  reg.WriteString('picsFolder', picsFolder);
  reg.WriteBool('launchRustOnStartup', launchRustOnStartup);
  reg.WriteBool('launchRustOnStartupAndConnectToServer', launchRustOnStartupAndConnectToServer);
  reg.WriteString('rustServer', rustServerAddress);
  reg.WriteBool('closeStashPicOnRustClose', closeStashPicOnRustClose);
  reg.WriteString('serverAddress', serverAddress);
  reg.WriteFloat('scale', scale);
  reg.WriteString('hotkeyCaptureFullscreen', hotkeyCaptureFullscreen);
  reg.WriteString('hotkeyCaptureFullscreenCode', hotkeyCaptureFullscreenCode);
  reg.WriteString('hotkeyCaptureRectangleCenter', hotkeyCaptureRectangleCenter);
  reg.WriteString('hotkeyCaptureRectangleCenterCode', hotkeyCaptureRectangleCenterCode);
  reg.WriteString('hotkeyCaptureStashArea', hotkeyCaptureStashArea);
  reg.WriteString('hotkeyCaptureStashAreaCode', hotkeyCaptureStashAreaCode);
  reg.WriteString('hotkeyCaptureFullscreenMapPart', hotkeyCaptureFullscreenMapPart);
  reg.WriteString('hotkeyCaptureFullscreenMapPartCode', hotkeyCaptureFullscreenMapPartCode);
  reg.WriteBool('automaticUpdate', automaticUpdate);
  reg.WriteString('updateToken', updateToken);
  reg.WriteString('tab', tab);
  reg.WriteInteger ('formLeft', formLeft);
  reg.WriteInteger('formTop', formTop);
  reg.CloseKey();
  reg.Free;
end;

procedure TConfig.init(baseDir : string);
var reg : TRegistry;
begin
  reg := TRegistry.Create(KEY_READ);
  if (reg.KeyExists(key)) then exit;
  reg.Access := KEY_WRITE;
  if (not reg.OpenKey(key,True)) then halt;
  usi := newUsi();
  storeImages := true;
  picsFolder := baseDir + picsFolderDefault;
  launchRustOnStartup := false;
  launchRustOnStartupAndConnectToServer := false;
  rustServerAddress := '';
  closeStashPicOnRustClose := false;
  serverAddress := 'http://stashmap.net/map/add/picLoad';
  scale := 1;
  hotkeyCaptureFullscreen := 'Alt + 1';
  hotkeyCaptureFullscreenCode := '010049';
  hotkeyCaptureRectangleCenter := 'Alt + 2';
  hotkeyCaptureRectangleCenterCode := '010050';
  hotkeyCaptureStashArea := 'Alt + 3';
  hotkeyCaptureStashAreaCode := '010051';
  hotkeyCaptureFullscreenMapPart := 'Alt + 4';
  hotkeyCaptureFullscreenMapPartCode := '010052';
  automaticUpdate := true;
  updateToken := '';
  formLeft := 300;
  formTop := 200;
  tab := 'settings';
  save();
end;

function TConfig.newUsi():string;
var usi, chars : string;
  i : integer;
begin
  chars := '0123456789abcde0123456789fghijklm0123456789nopqrst0123456789uvwxyz0123456789';
  randomize;
  usi := '';
  for i := 1 to 15 do usi := usi + chars[Random(length(chars))+1];
  Result := usi;
end;

end.

