unit command_class_lib;

interface
uses streaming_class_lib;
type
  TAbstractCommand=class(TStreamingClass)  //чтобы историю изменений можно было хранить вместе со всем остальным
    public
      function Execute: Boolean; virtual; abstract;
      function Undo: boolean; virtual; abstract;
      function caption: string; virtual; abstract;

    end;
  TCommandList=class(TStreamingClass) //список для undo/redo и даже для сохранения данных в файл
    private
      current: Integer; //наше данное положение - куда добавлять команду. Т.е по умолчанию - 0
    public
      commands: array of TAbstractCommand;
      procedure Add(command: TAbstractCommand);
      procedure Undo;
      procedure Redo;
      function UndoEnabled: Boolean;
      function RedoEnabled: Boolean;
      destructor Destroy; override;
      property cur: Integer read current;
      procedure Clear;
    end;
implementation

procedure TCommandList.Add(command: TAbstractCommand);
var i,L:Integer;
begin
  L:=Length(commands)-1;
  for i:=current to L do
    commands[i].Free;
  SetLength(commands,current+1);
  commands[current]:=command; //запихнули новую
  inc(current);
end;

procedure TCommandList.Undo;
begin
  if UndoEnabled then begin
    dec(current);
    commands[current].Undo;
  end;
end;

procedure TCommandList.Redo;
begin
  if RedoEnabled then begin
    commands[current].Execute;
    inc(current);
  end;
end;

function TCommandList.UndoEnabled: boolean;
begin
  Result:=(current>0);
end;

function TCommandList.RedoEnabled: boolean;
begin
  Result:=(current<Length(commands));
end;

destructor TCommandList.Destroy;
begin
  Clear;
  inherited Destroy;
end;

procedure TCommandList.Clear;
var i: Integer;
begin
  for i:=0 to Length(commands)-1 do
    commands[i].Free;
  current:=0;
  SetLength(commands,0);
end;

end.
