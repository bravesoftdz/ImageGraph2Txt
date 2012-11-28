unit ImageGraph2Txt_commands;

interface

uses command_class_lib,coord_system_lib,sysUtils,table_func_lib,classes;

type
  TChangeBoolFunc=procedure(var adr: Boolean) of object;

  TAddPointCommand=class(TAbstractCommand)
  private
    _x,_y: Integer; //точка, которую мы и хотели добавить
    procedure ReadPoint(reader: TReader);
    procedure WritePoint(writer: TWriter);
  protected
    procedure DefineProperties(filer: TFiler); override;
  public
    constructor Create(X,Y: Integer); reintroduce; overload;
    function Execute: boolean; override;
    function Undo: boolean; override;
    function caption: string; override;
  end;

  TChangeBoolCommand=class(TAbstractCommand)
  private
    adr: ^Boolean;
    val: Boolean;
    _name: string;
    _func: TChangeBoolFunc;
  public
    constructor Create(var addr: Boolean;func: TChangeBoolFunc;value: Boolean;name: string); reintroduce; overload;
    function Execute: boolean; override;
    function Undo: boolean; override;
    function caption: string; override;
  end;

  TClearPointsCommand=class(TAbstractCommand)
  private
    backup_storage: table_func;
    _adr: Tcoord_system;
  public
    constructor Create(adr: Tcoord_system); reintroduce; overload;
    function Execute: boolean; override;
    function Undo: boolean; override;
    function Caption: string; override;
  end;

implementation

uses imagegraph2txt_document_class;
(*
                  AddPoint
                                        *)
constructor TAddPointCommand.Create(X,Y: Integer);
begin
  inherited Create(nil);
  _x:=X;
  _y:=Y;
end;

function TAddPointCommand.Execute: boolean;
begin
  Result:=(FindOwner as TImageGraph2TxtDocument).coord.addpoint(_x,_y);
end;

function TAddPointCommand.Undo: boolean;
begin
  Result:=(FindOwner as TImageGraph2TxtDocument).coord.deletepoint(_x);
end;

function TAddPointCommand.caption: string;
begin
  Result:='Добавить ('+IntToStr(_x)+';'+IntToStr(_y)+')';
end;

procedure TAddPointCommand.DefineProperties(filer: TFiler);
begin
  filer.DefineProperty('point',ReadPoint,WritePoint,true); //и снова не будем жадничать
end;

procedure TAddPointCommand.ReadPoint(reader: TReader);
begin
  reader.ReadListBegin;
  _x:=reader.ReadInteger;
  _y:=reader.ReadInteger;
  reader.ReadListEnd;
end;

procedure TAddPointCommand.WritePoint(writer: TWriter);
begin
  writer.WriteListBegin;
  writer.writeInteger(_x);
  writer.writeInteger(_y);
  writer.WriteListEnd;
end;

(*
              ChangeBool
                                          *)
constructor TChangeBoolCommand.Create(var addr: Boolean; func: TChangeBoolFunc; value: boolean;name: string);
begin
  inherited Create(nil);
  adr:=@addr;
  val:=value;
  if val then _name:='Включить '+name
  else _name:='Сбросить '+name;
  _func:=func;
end;

function TChangeBoolCommand.Execute: boolean;
begin
  Result:=((adr^) xor val);
  if Result then begin
    _func(adr^);
    val:=not val;
  end;
end;

function TChangeBoolCommand.Undo: boolean;
begin
  Result:=execute;
end;

function TChangeBoolCommand.caption: string;
begin
  Result:=_name;
end;

(*
            ClearPoints
                                      *)
constructor TClearPointsCommand.Create(adr: Tcoord_system);
begin
  inherited Create(nil);
  _adr:=adr;
  backup_storage:=table_func.Create(self);
end;

function TClearPointsCommand.Execute: boolean;
begin
  backup_storage.assign(_adr.raw_data);
  _adr.ClearAllPoints;
  Result:=true;
end;

function TClearPointsCommand.Undo: boolean;
begin
  _adr.raw_data.assign(backup_storage);
  _adr.reprocess_output;
  Result:=true;
end;

function TClearPointsCommand.Caption: string;
begin
  result:='Удаление точек данных';
end;

initialization

RegisterClasses([TAddPointCommand]);

end.
