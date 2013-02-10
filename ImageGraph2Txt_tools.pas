unit ImageGraph2Txt_tools;

interface

uses Controls,Classes;

type

TTool=class(TComponent)
private
  fButtonName: string;
public
  constructor Create(owner: TComponent;aButtonName: string); reintroduce;
  procedure Select; virtual; abstract;
  procedure Unselect; virtual; abstract;
  procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X,Y: Integer); virtual; abstract;
  procedure MouseMove(Shift: TShiftState; X,Y: Integer); virtual; abstract;
  procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual; abstract;
  procedure SetStatusPanel(text: string);
published
  property ButtonName: string read fButtonName write fButtonName;
end;

TAddPointTool=class(TTool)
public
  procedure Select; override;
  procedure Unselect; override;
  procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X,Y: Integer); override;
  procedure MouseMove(Shift: TShiftState; X,Y: Integer); override;
  procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X,Y: Integer); override;
end;

TAddAxisToolState=(sSetZero,sSetAxisPoint);
TAddAxisTool=class(TTool)
private
  fstate: TAddAxisToolState;
  procedure ChangeState(astate: TAddAxisToolState);
public
  procedure Select; override;
  procedure Unselect; override;
  procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X,Y: Integer); override;
  procedure MouseMove(Shift: TShiftState; X,Y: Integer); override;
  procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X,Y: Integer); override;
published
  property state: TAddAxisToolState read fstate write fstate;
end;

TCropTool=class(TTool)
public
  procedure Select; override;
  procedure Unselect; override;
  procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X,Y: Integer); override;
  procedure MouseMove(Shift: TShiftState; X,Y: Integer); override;
  procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X,Y: Integer); override;
end;

implementation

uses ImageGraph2Txt_commands,ImageGraph2Txt_data;
(*
            TTool
                            *)
constructor TTool.Create(owner: TComponent; aButtonName: string);
begin
  inherited Create(owner);
  name:='tool';
  fButtonName:=aButtonName;
end;

procedure TTool.SetStatusPanel(text: string);
var data: TImageGraph2TxtDocument;
begin
  if (owner<>nil) then begin
    data:=owner as TImageGraph2TxtDocument;
    if data.StatusPanel<>nil then
      data.StatusPanel.Text:=text;
  end;
end;

(*
            TAddPointTool
                                  *)
procedure TAddPointTool.Select;
begin
  SetStatusPanel('Добавить точки данных');
end;

procedure TAddPointTool.Unselect;
begin
  SetStatusPanel('');
end;

procedure TAddPointTool.MouseDown(Button: TMouseButton; Shift: TShiftState; X,Y: Integer);
var data: TImageGraph2TxtDocument;
begin
  Assert(owner<>nil);
  data:=owner as TImageGraph2TxtDocument;
  data.DispatchCommand(TAddPointCommand.Create(X/data.scale,Y/data.scale));
end;

procedure TAddPointTool.MouseMove(Shift: TShiftState; X,Y: Integer);
begin

end;

procedure TAddPointTool.MouseUp(Button: TMouseButton; Shift: TShiftState; X,Y: Integer);
begin

end;

(*
            TAddAxisTool
                                        *)

procedure TAddAxisTool.ChangeState(astate: TAddAxisToolState);
begin
  state:=aState;
  case state of
    sSetZero: SetStatusPanel('Отметьте начало координат');
    sSetAxisPoint: SetStatusPanel('Отметьте точки на осях координат');
  end;
end;

procedure TAddAxisTool.Select;
begin
  ChangeState(state);
end;

procedure TAddAxisTool.Unselect;
begin
  SetStatusPanel('');
end;

procedure TAddAxisTool.MouseDown(button: TMouseButton;shift: TShiftState; X,Y: Integer);
var data:TImageGraph2TxtDocument;
begin
  data:=owner as TImageGraph2TxtDocument;
  if state=sSetZero then begin
    data.coord.xmax_picked:=false;
    data.coord.ymax_picked:=false;
    data.DispatchCommand(TSetZeroCommand.Create(X,Y));
    if data.coord.zero_picked then begin
      ChangeState(sSetAxisPoint);
    end;
  end
  else begin
    data.DispatchCommand(TSetAxisCommand.Create(X,Y));
    if (data.coord.xmax_picked) and (data.coord.ymax_picked) then ChangeState(sSetZero);
  end;
end;

procedure TAddAxisTool.MouseUp(button: TMouseButton; shift: TShiftState; X,Y: Integer);
begin

end;

procedure TAddAxisTool.MouseMove(Shift: TShiftState; X,Y: Integer);
begin

end;

(*
      TCropTool
                      *)
procedure TCropTool.Select;
begin
  SetStatusPanel('Выделите прямоугольную область');
end;

procedure TCropTool.Unselect;
begin
  SetStatusPanel('');
end;

procedure TCropTool.MouseDown(button: TMouseButton;shift: TShiftState; X,Y: Integer);
begin

end;

procedure TCropTool.MouseUp(button: TMouseButton; shift: TShiftState; X,Y: Integer);
begin

end;

procedure TCropTool.MouseMove(Shift: TShiftState; X,Y: Integer);
begin

end;



initialization
RegisterClasses([TTool,TAddPointTool, TAddAxisTool, TCropTool]);

end.
