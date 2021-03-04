unit filesToSend;

interface

type

  TFilesToSend = class(TObject)
    list : array of string;
    count : integer;

  private
    { Private declarations }
  public
    procedure Add(var fileName : string);
    function Get() : string;
    { Public declarations }
  end;

implementation

procedure TFilesToSend.Add(var fileName : string);
begin
  count := Length(list)+1;
  SetLength(list, count);
  list[High(list)] := fileName;
end;

function TFilesToSend.Get() : string;
var i:integer;
    res : string;
begin
  if count = 0 then Exit('');

  res := list[0];
  for i:= 1 to High(list) do
  begin
    list[i-1] := list[i];
  end;
  count := count - 1;
  SetLength(list, count);
  Exit(res);
end;

end.
