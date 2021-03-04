unit SendFileToServer;

interface

uses
  System.Classes, IdMultipartFormData, System.SysUtils, IdHTTP;

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
  response: string; //переменная для возращения HTML кода страницы
  formData: TIdMultiPartFormDataStream; //для передачи информации
  idHTTP : TIdHTTP;
  FileDestination : TFleToDestination;
begin
  IdHTTP := TIdHTTP.Create;

  fts.ready := false;
  formData := TIdMultiPartFormDataStream.Create;
  FileDestination := fts.get;
  if FileDestination.fileName = '' then exit;
  formData.AddFile('fileToUpload', FileDestination.fileName, 'application/octet-stream');
  formData.AddFormField('usi', '1292429972');
  formData.AddFormField('destination', FileDestination.dest);
  response := IdHTTP.Post('http://rustmap.hostenko.com/map/add/picLoad', formData);
  form1.memo1.Lines.Add(response);
  IdHTTP.Destroy;
  fts.ready := true;
end;

end.
