program StashPic;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  SendFileToServer in 'SendFileToServer.pas',
  filesToSend in 'filesToSend.pas',
  Config in 'Config.pas',
  editHotkey in 'editHotkey.pas' {editHotkeyForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TeditHotkeyForm, editHotkeyForm);
  Application.Run;
end.
