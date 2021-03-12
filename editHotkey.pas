unit editHotkey;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Generics.Collections;

type
  TeditHotkeyForm = class(TForm)
    ctrlCheckBox: TCheckBox;
    altCheckBox: TCheckBox;
    shiftCheckBox: TCheckBox;
    keyComboBox: TComboBox;
    okButton: TButton;
    cancelButton: TButton;
    procedure okButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cancelButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  editHotkeyForm: TeditHotkeyForm;

  keysName : array[0..100] of string;
  keysCode : array[0..100] of string;
  keysCount : integer;


implementation
uses unit1;
{$R *.dfm}

procedure TeditHotkeyForm.cancelButtonClick(Sender: TObject);
begin
  editHotkeyForm.Close;
end;

procedure TeditHotkeyForm.FormCreate(Sender: TObject);
var j:integer;
begin
  keysCount := 0;
  keysName[keysCount] := 'Print Screen';
  keysCode[keysCount] := '044';
  inc(keysCount);
  keysName[keysCount] := 'Insert';
  keysCode[keysCount] := '045';
  inc(keysCount);
  keysName[keysCount] := 'Delete';
  keysCode[keysCount] := '046';
  inc(keysCount);
  keysName[keysCount] := 'Home';
  keysCode[keysCount] := '036';
  inc(keysCount);
  keysName[keysCount] := 'End';
  keysCode[keysCount] := '035';
  inc(keysCount);
  keysName[keysCount] := 'Page Up';
  keysCode[keysCount] := '033';
  inc(keysCount);
  keysName[keysCount] := 'Page Down';
  keysCode[keysCount] := '034';
  inc(keysCount);
  keysName[keysCount] := 'Space';
  keysCode[keysCount] := '032';
  inc(keysCount);
  keysName[keysCount] := 'Backspace';
  keysCode[keysCount] := '008';
  inc(keysCount);
  keysName[keysCount] := 'Left';
  keysCode[keysCount] := '037';
  inc(keysCount);
  keysName[keysCount] := 'Up';
  keysCode[keysCount] := '038';
  inc(keysCount);
  keysName[keysCount] := 'Right';
  keysCode[keysCount] := '039';
  inc(keysCount);
  keysName[keysCount] := 'Down';
  keysCode[keysCount] := '040';
  inc(keysCount);
  keysName[keysCount] := 'A';
  keysCode[keysCount] := '065';
  inc(keysCount);
  keysName[keysCount] := 'B';
  keysCode[keysCount] := '066';
  inc(keysCount);
  keysName[keysCount] := 'C';
  keysCode[keysCount] := '067';
  inc(keysCount);
  keysName[keysCount] := 'D';
  keysCode[keysCount] := '068';
  inc(keysCount);
  keysName[keysCount] := 'E';
  keysCode[keysCount] := '069';
  inc(keysCount);
  keysName[keysCount] := 'F';
  keysCode[keysCount] := '070';
  inc(keysCount);
  keysName[keysCount] := 'G';
  keysCode[keysCount] := '071';
  inc(keysCount);
  keysName[keysCount] := 'H';
  keysCode[keysCount] := '072';
  inc(keysCount);
  keysName[keysCount] := 'I';
  keysCode[keysCount] := '073';
  inc(keysCount);
  keysName[keysCount] := 'J';
  keysCode[keysCount] := '074';
  inc(keysCount);
  keysName[keysCount] := 'K';
  keysCode[keysCount] := '075';
  inc(keysCount);
  keysName[keysCount] := 'L';
  keysCode[keysCount] := '076';
  inc(keysCount);
  keysName[keysCount] := 'M';
  keysCode[keysCount] := '077';
  inc(keysCount);
  keysName[keysCount] := 'N';
  keysCode[keysCount] := '078';
  inc(keysCount);
  keysName[keysCount] := 'O';
  keysCode[keysCount] := '079';
  inc(keysCount);
  keysName[keysCount] := 'P';
  keysCode[keysCount] := '080';
  inc(keysCount);
  keysName[keysCount] := 'Q';
  keysCode[keysCount] := '081';
  inc(keysCount);
  keysName[keysCount] := 'R';
  keysCode[keysCount] := '082';
  inc(keysCount);
  keysName[keysCount] := 'S';
  keysCode[keysCount] := '083';
  inc(keysCount);
  keysName[keysCount] := 'T';
  keysCode[keysCount] := '084';
  inc(keysCount);
  keysName[keysCount] := 'U';
  keysCode[keysCount] := '085';
  inc(keysCount);
  keysName[keysCount] := 'V';
  keysCode[keysCount] := '086';
  inc(keysCount);
  keysName[keysCount] := 'W';
  keysCode[keysCount] := '087';
  inc(keysCount);
  keysName[keysCount] := 'X';
  keysCode[keysCount] := '088';
  inc(keysCount);
  keysName[keysCount] := 'Y';
  keysCode[keysCount] := '089';
  inc(keysCount);
  keysName[keysCount] := 'Z';
  keysCode[keysCount] := '090';
  inc(keysCount);
  keysName[keysCount] := '0';
  keysCode[keysCount] := '048';
  inc(keysCount);
  keysName[keysCount] := '1';
  keysCode[keysCount] := '049';
  inc(keysCount);
  keysName[keysCount] := '2';
  keysCode[keysCount] := '050';
  inc(keysCount);
  keysName[keysCount] := '3';
  keysCode[keysCount] := '051';
  inc(keysCount);
  keysName[keysCount] := '4';
  keysCode[keysCount] := '052';
  inc(keysCount);
  keysName[keysCount] := '5';
  keysCode[keysCount] := '053';
  inc(keysCount);
  keysName[keysCount] := '6';
  keysCode[keysCount] := '054';
  inc(keysCount);
  keysName[keysCount] := '7';
  keysCode[keysCount] := '055';
  inc(keysCount);
  keysName[keysCount] := '8';
  keysCode[keysCount] := '056';
  inc(keysCount);
  keysName[keysCount] := '9';
  keysCode[keysCount] := '057';
  inc(keysCount);
  keysName[keysCount] := 'Num Pad 0';
  keysCode[keysCount] := '096';
  inc(keysCount);
  keysName[keysCount] := 'Num Pad 1';
  keysCode[keysCount] := '097';
  inc(keysCount);
  keysName[keysCount] := 'Num Pad 2';
  keysCode[keysCount] := '098';
  inc(keysCount);
  keysName[keysCount] := 'Num Pad 3';
  keysCode[keysCount] := '099';
  inc(keysCount);
  keysName[keysCount] := 'Num Pad 4';
  keysCode[keysCount] := '100';
  inc(keysCount);
  keysName[keysCount] := 'Num Pad 5';
  keysCode[keysCount] := '101';
  inc(keysCount);
  keysName[keysCount] := 'Num Pad 6';
  keysCode[keysCount] := '102';
  inc(keysCount);
  keysName[keysCount] := 'Num Pad 7';
  keysCode[keysCount] := '103';
  inc(keysCount);
  keysName[keysCount] := 'Num Pad 8';
  keysCode[keysCount] := '104';
  inc(keysCount);
  keysName[keysCount] := 'Num Pad 9';
  keysCode[keysCount] := '105';
  inc(keysCount);
  keysName[keysCount] := '/';
  keysCode[keysCount] := '111';
  inc(keysCount);
  keysName[keysCount] := '*';
  keysCode[keysCount] := '106';
  inc(keysCount);
  keysName[keysCount] := '-';
  keysCode[keysCount] := '109';
  inc(keysCount);
  keysName[keysCount] := '+';
  keysCode[keysCount] := '107';
  inc(keysCount);
  keysName[keysCount] := 'F1';
  keysCode[keysCount] := '112';
  inc(keysCount);
  keysName[keysCount] := 'F2';
  keysCode[keysCount] := '113';
  inc(keysCount);
  keysName[keysCount] := 'F3';
  keysCode[keysCount] := '114';
  inc(keysCount);
  keysName[keysCount] := 'F4';
  keysCode[keysCount] := '115';
  inc(keysCount);
  keysName[keysCount] := 'F5';
  keysCode[keysCount] := '116';
  inc(keysCount);
  keysName[keysCount] := 'F6';
  keysCode[keysCount] := '117';
  inc(keysCount);
  keysName[keysCount] := 'F7';
  keysCode[keysCount] := '118';
  inc(keysCount);
  keysName[keysCount] := 'F8';
  keysCode[keysCount] := '119';
  inc(keysCount);
  keysName[keysCount] := 'F9';
  keysCode[keysCount] := '120';
  inc(keysCount);
  keysName[keysCount] := 'F10';
  keysCode[keysCount] := '121';
  inc(keysCount);
  keysName[keysCount] := 'F11';
  keysCode[keysCount] := '122';
  inc(keysCount);
  keysName[keysCount] := 'F12';
  keysCode[keysCount] := '123';

  for j := 0 to keysCount do keyComboBox.Items.Add(keysName[j]);

  keyComboBox.ItemIndex := 0;
  keyComboBox.DropDownCount := round(keysCount*0.6);
end;

procedure TeditHotkeyForm.FormShow(Sender: TObject);
var key : string;
    j:integer;
begin
  hotkeyAsString := '';

  if (hotkeyCodeString[1] = '1') then ctrlCheckBox.Checked := true else ctrlCheckBox.Checked := false;
  if (hotkeyCodeString[2] = '1') then altCheckBox.Checked := true else altCheckBox.Checked := false;
  if (hotkeyCodeString[3] = '1') then shiftCheckBox.Checked := true else shiftCheckBox.Checked :=false;
  key := Copy(hotkeyCodeString,4,3);
  for j := 0 to keysCount do
  if keysCode[j] = key then
  begin
    keyComboBox.ItemIndex := j;
    break;
  end;

end;

procedure TeditHotkeyForm.okButtonClick(Sender: TObject);
var ctrl,alt,shift,key : string;
  hotkeyParts : array of string;
begin
  if ctrlCheckBox.Checked then ctrl := '1' else ctrl := '0';
  if altCheckBox.Checked then alt := '1' else alt := '0';
  if shiftCheckBox.Checked then shift := '1' else shift := '0';

  key := keysCode[keyComboBox.ItemIndex];
  hotkeyCodeString := ctrl+alt+shift+key;

  if ctrlCheckBox.Checked then
  begin
    setLength(hotkeyParts, Length(hotkeyParts)+1);
    hotkeyParts[Length(hotkeyParts)-1] := 'Ctrl';
  end;

  if altCheckBox.Checked then
  begin
    setLength(hotkeyParts, Length(hotkeyParts)+1);
    hotkeyParts[Length(hotkeyParts)-1] := 'Alt';
  end;

  if shiftCheckBox.Checked then
  begin
    setLength(hotkeyParts, Length(hotkeyParts)+1);
    hotkeyParts[Length(hotkeyParts)-1] := 'Shift';
  end;

  setLength(hotkeyParts, Length(hotkeyParts)+1);
  hotkeyParts[Length(hotkeyParts)-1] := keyComboBox.Text;

  hotkeyAsString := String.Join(' + ', hotkeyParts);
  editHotkeyForm.Close;
end;

end.
