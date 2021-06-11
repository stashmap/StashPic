unit SendFileToServer;

interface

uses
  System.Classes, IdMultipartFormData, System.SysUtils, IdHTTP, mmsystem;

type
  TSendFileToServer = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
  end;

implementation
uses unit1;

{ SendFileToServer }

procedure TSendFileToServer.Execute;
var
  response: string;
  formData: TIdMultiPartFormDataStream;
  idHTTP : TIdHTTP;
  FileDestination : TFleToDestination;
begin
  IdHTTP := TIdHTTP.Create;

  fts.ready := false;
  formData := TIdMultiPartFormDataStream.Create;
  FileDestination := fts.get;
  if FileDestination.fileName = '' then exit;
  formData.AddFile('fileToUpload', FileDestination.fileName, 'application/octet-stream');
  formData.AddFormField('usi', cfg.usi);
  formData.AddFormField('destination', inttostr(FileDestination.dest));
  response := IdHTTP.Post('http://stashmap.net/map/add/picLoad', formData);
  if response <> 'OK' then PlaySoundA('media/error.wav',0, SND_ASYNC);
  form1.logMemo.Lines.Add('Sending '+ ExtractFileName(FileDestination.fileName) +' file - ' + response);
  IdHTTP.Destroy;
  formData.Destroy;
  if not cfg.storeImages then System.SysUtils.DeleteFile(FileDestination.fileName);
  fts.ready := true;
end;

end.
