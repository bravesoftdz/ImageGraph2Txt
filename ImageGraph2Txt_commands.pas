unit ImageGraph2Txt_commands;

interface

uses command_class_lib,coord_system_lib,sysUtils;

type
  TchangeFloatFunc=function(var X: Real): boolean of object;
  TChangeBoolFunc=procedure(var adr: Boolean) of object;

  TAddPointCommand=class(TAbstractCommand)
  private
    _t: coord_system; //ссылка на таблицу, куда добавляем
    _x,_y: Integer; //точка, которую мы и хотели добавить
  public
    constructor Create(t: coord_system;X,Y: Integer);
//    destructor Destroy; override;
    function Execute: boolean; override;
    function Undo: boolean; override;
    function caption: string; override;
  end;

  TChangeFloatCommand=class(TAbstractCommand)
  private
    _func: TchangeFloatFunc;
    _x: Real;
    _name: string;
  public
    constructor Create(func: TchangeFloatFunc;X: Real;name: string);
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
    constructor Create(var addr: Boolean;func: TChangeBoolFunc;value: Boolean;name: string);
    function Execute: boolean; override;
    function Undo: boolean; override;
    function caption: string; override;
  end;

implementation
(*
                  AddPoint
                                        *)
constructor TAddPointCommand.Create(t: coord_system; X,Y: Integer);
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

end.
