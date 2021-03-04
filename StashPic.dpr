program StashPic;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  SendFileToServer in 'SendFileToServer.pas',
  filesToSend in 'filesToSend.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
