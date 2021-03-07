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

    const key = 'Software\StashPic\';
    picsFolder = '/pics';
    procedure load();
    procedure save();
    procedure init();
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
  launchRustOnStartup := reg.ReadBool('launchRustOnStartup');
  launchRustOnStartupAndConnectToServer := reg.ReadBool('launchRustOnStartupAndConnectToServer');
  rustServerAddress := reg.ReadString('rustServer');
  closeStashPicOnRustClose := reg.ReadBool('closeStashPicOnRustClose');
  serverAddress := reg.ReadString('serverAddress');
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
  reg.WriteBool('launchRustOnStartup', launchRustOnStartup);
  reg.WriteBool('launchRustOnStartupAndConnectToServer', launchRustOnStartupAndConnectToServer);
  reg.WriteString('rustServer', rustServerAddress);
  reg.WriteBool('closeStashPicOnRustClose', closeStashPicOnRustClose);
  reg.WriteString('serverAddress', serverAddress);
  reg.CloseKey();
  reg.Free;
end;

procedure TConfig.init();
var reg : TRegistry;
begin
  reg := TRegistry.Create(KEY_READ);
  if (reg.KeyExists(key)) then exit;
  reg.Access := KEY_WRITE;
  if (not reg.OpenKey(key,True)) then halt;
  usi := newUsi();
  storeImages := true;
  launchRustOnStartup := false;
  launchRustOnStartupAndConnectToServer := false;
  rustServerAddress := '';
  closeStashPicOnRustClose := false;
  serverAddress := 'http://rustmap.hostenko.com/map/add/picLoad';
  save();
end;

function TConfig.newUsi():string;
var usi : string;
  i : integer;
begin
  randomize;
  usi := '';
  for i := 1 to 10 do usi := usi + IntToStr( random(10) );
  Result := usi;
end;

end.

