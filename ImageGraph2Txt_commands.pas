unit ImageGraph2Txt_commands;

interface

uses command_class_lib,coord_system_lib,sysUtils,table_func_lib,classes;

type
  TchangeFloatFunc=function(var X: Real): boolean of object;
  TChangeBoolFunc=procedure(var adr: Boolean) of object;

  TAddPointCommand=class(TAbstractCommand)
  private
    _t: Tcoord_system; //ссылка на таблицу, куда добавляем
    _x,_y: Integer; //точка, которую мы и хотели добавить
  public
    constructor Create(t: Tcoord_system;X,Y: Integer);
//    destructor Destroy; override;
    function Execute: boolean; override;
    function Undo: boolean; override;
    function caption: string; override;
  end;
  TChangeFloatCommand=class(TAbstractCommand)
  private
    _execute_func: TChangeFloatFunc;
    _func: TchangeFloatFunc;
    _x: Real;
    _name: string;
    procedure readTitle(reader: TReader);
    procedure writeTitle(writer: TWriter);
  protected
    procedure DefineProperties(filer: TFiler); override;
  public
    constructor Create(func: TchangeFloatFunc;X: Real;name: string);
    function Execute: boolean; override;
    function Undo: boolean; override;
    function caption: string; override;
  published
    function change_float(var x: Real): Boolean;
    property func: TChangeFloatFunc read _execute_func write _execute_func;
  end;

  TChangeBoolCommand=class(TAbstractCommand)
  private
    adr: ^Boolean;
    val: Boolean;
    _name: string;
    _func: TChangeBoolFunc;
  public
    constructor Create(var addr: Boolean;func: TChangeBoolFunc;value: Boolean;name: string);
    function Execute: boolean; override;
    function Undo: boolean; override;
    function caption: string; override;
  end;

  TClearPointsCommand=class(TAbstractCommand)
  private
    backup_storage: table_func;
    _adr: Tcoord_system;
  public
    constructor Create(adr: Tcoord_system);
    function Execute: boolean; override;
    function Undo: boolean; override;
    function Caption: string; override;
  end;

  TButtonClickCommand=class(TAbstractCommand)
  private
    _onclick: TNotifyEvent;
  public
    constructor Create(event: TNotifyEvent);
    function Execute: boolean; override;
    function Caption: string; override;
  published
    procedure Foobar(sender: TObject);
    property onclick: TNotifyEvent read _onclick write _onclick;
  end;

implementation
(*
                  AddPoint
                                        *)
constructor TAddPointCommand.Create(t: Tcoord_system; X,Y: Integer);
begin
  inherited Create(nil);
  _t:=t;
  _x:=X;
  _y:=Y;
end;

function TAddPointCommand.Execute: boolean;
begin
  Result:=_t.addpoint(_x,_y);
end;

function TAddPointCommand.Undo: boolean;
begin
  Result:=_t.deletepoint(_x);
end;

function TAddPointCommand.caption: string;
begin
  Result:='Добавить ('+IntToStr(_x)+';'+IntToStr(_y)+')';
end;

(*
                  ChangeFloat
                                        *)
constructor TChangeFloatCommand.Create(func: TChangeFloatFunc;X: Real; name: string);
begin
  inherited Create(nil);
  _func:=func;
  _x:=X;
  _name:='Изменить '+name+' на '+FloatToStr(_x);
  _execute_func:=Change_float;
end;

function TChangeFloatCommand.Execute: boolean;
begin
  Result:=_func(_x);
end;

function TChangeFloatCommand.Undo: boolean;
begin
  Result:=_func(_x);
end;

function TChangeFloatCommand.caption: string;
begin
  Result:=_name;
end;

procedure TChangeFloatCommand.DefineProperties(filer: TFiler);
begin
  inherited;
  filer.DefineProperty('title',readTitle,writeTitle,(_name<>''));
end;

procedure TChangeFloatCommand.readTitle(reader: TReader);
begin
  _name:=reader.ReadString;
end;

procedure TChangeFloatCommand.writeTitle(writer: TWriter);
begin
  writer.WriteString(_name);
end;

function TChangeFloatCommand.change_float(var x: Real): Boolean;
begin
  result:=false;
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


(*
        TButtonClickCommand
                                  *)

constructor TButtonClickCommand.Create(event: TNotifyEvent);
begin
  inherited Create(nil);
  _onclick:=event;
end;

function TButtonClickCommand.Execute: boolean;
begin
  result:=true;
end;

function TButtonClickCommand.Caption: string;
begin
  result:='Кнопка нажата';
end;

procedure TButtonClickCommand.Foobar(sender: TObject);
begin

end;


end.
