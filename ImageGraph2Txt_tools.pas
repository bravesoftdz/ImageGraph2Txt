unit ImageGraph2Txt_tools;

interface

uses Controls,Classes,types;

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

TCropToolState=(sSizeTopLeft,sSizeTopRight,sSizeBottomLeft,sSizeBottomRight,sSizeTop,sSizeBottom,sSizeLeft,sSizeRight,sCrop,sDeselect);
TCropTool=class(TTool)
private
  fselected: Boolean; //есть ли уже выбранная для обрезки область?
  mouse_down: Boolean; //держится ли нажатой кнопка мыши?
  fstartx,fstarty,fcurx,fcury: Integer; //4 координаты
  fstate: TCropToolState;
  procedure Kill_selection;
  procedure reset_selection;
  procedure set_state(astate: TCropToolState);
  function scale: Real;
  property state: TCropToolState read fstate write set_state;
public
  procedure Select; override;
  procedure Unselect; override;
  procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X,Y: Integer); override;
  procedure MouseMove(Shift: TShiftState; X,Y: Integer); override;
  procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X,Y: Integer); override;
published
  property startx: Integer read fstartx write fstartx stored fselected;
  property starty: Integer read fstarty write fstarty stored fselected;
  property curx: Integer read fcurx write fcurx stored fselected;
  property cury: Integer read fcury write fcury stored fselected;
  property selected: Boolean read fselected write fselected;
end;

implementation

uses ImageGraph2Txt_commands,ImageGraph2Txt_data,graphics,ExtCtrls;

const sensitivity:Integer=5;
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
    s: Real;
begin
  data:=owner as TImageGraph2TxtDocument;
  s:=data.scale;
  if state=sSetZero then begin
    data.coord.xmax_picked:=false;
    data.coord.ymax_picked:=false;
    data.DispatchCommand(TSetZeroCommand.Create(Round(X/s),Round(Y/s)));
    if data.coord.zero_picked then begin
      ChangeState(sSetAxisPoint);
    end;
  end
  else begin
    data.DispatchCommand(TSetAxisCommand.Create(Round(X/s),Round(Y/s)));
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

function TCropTool.scale: Real;
begin
  Result:=(owner as tImageGraph2TxtDocument).scale;
end;

procedure TCropTool.Kill_selection;
var canv: TCanvas;
begin
  canv:=(owner as TImageGraph2TxtDocument).coord.image.Canvas;
  with Canv do begin
    Pen.Mode:=pmNotXor;
    pen.Style:=psDot;
    pen.Width:=1;
    pen.Color:=clBlack;
    brush.Color:=clWhite;
    Rectangle(Round(startX*scale),Round(startY*scale),Round(curX*scale),Round(curY*scale));
  end;
end;

procedure TCropTool.reset_selection;
begin
    SetStatusPanel('Выделите прямоугольную область');
    startx:=0;
    starty:=0;
    curx:=0;
    cury:=0;
    selected:=false;
end;

procedure TCropTool.Select;
begin
  if selected then begin
    kill_selection;
  end
  else begin
    reset_selection;
  end;
end;

procedure TCropTool.Unselect;
begin
  if selected then kill_selection;
  SetStatusPanel('');
  (owner as TImageGraph2TxtDocument).coord.image.Cursor:=crCross;
end;

procedure TCropTool.MouseDown(button: TMouseButton;shift: TShiftState; X,Y: Integer);
var data:TImageGraph2TxtDocument;
begin
  mouse_down:=true;
  data:=owner as TImageGraph2TxtDocument;
  if selected then begin
    //скорее всего, снимаем выделение
    case state of
      sDeselect: begin
        kill_selection;
        reset_selection;
      end;
      sCrop: begin
        selected:=false;
        data.DispatchCommand(TCropImageCommand.Create(Round(startx),Round(starty),Round(curx),Round(cury)));
        reset_selection;
        startx:=Round(X/scale);
        starty:=Round(Y/scale);
        curx:=startx;
        curY:=starty;
      end;
    end;
  end
  else begin
    //рамочки пока еще нет, отмечаем первую точку
    startx:=Round(X/scale);
    starty:=Round(Y/scale);
    curx:=startX;
    cury:=startY;
  end;
end;

procedure TCropTool.MouseUp(button: TMouseButton; shift: TShiftState; X,Y: Integer);
var tmp: integer;
begin
  mouse_down:=false;
  if selected then begin


  end
  else begin
    if (abs(startX-curX)>10) and (abs(startY-curY)>10) then begin
      if (StartX>curX) then begin
        tmp:=startX;
        startX:=curX;
        curX:=tmp;
      end;
      if (StartY>curY) then begin
        tmp:=startY;
        startY:=curY;
        curY:=tmp;
      end;
      selected:=true;
    end
    else kill_selection;
  end;
end;

procedure TCropTool.set_state(astate: TCropToolState);
var img: TImage;
    s: string;
begin
  img:=(owner as TImageGraph2TxtDocument).coord.image;
  fstate:=astate;
  s:='Изменение размера рамки';
  with img do begin
    case astate of
      sSizeTopLeft,sSizeBottomRight: Cursor:=crSizeNWSE;
      sSizeBottomLeft,sSizeTopRight: Cursor:=crSizeNESW;
      sSizeLeft,sSizeRight: Cursor:=crSizeWE;
      sSizeTop,sSizeBottom: Cursor:=crSizeNS;
      sCrop:
        begin
        Cursor:=crHandPoint;
        s:='Обрезать по рамке';
        end;
      sDeselect:
        begin
        Cursor:=crCross;
        s:='Снять выделение';
        end;
    end;
  end;
  SetStatusPanel(s);
end;

procedure TCropTool.MouseMove(Shift: TShiftState; X,Y: Integer);
var img: TImage;
    xsc,ysc: Integer;
begin
img:=(owner as TImageGraph2TxtDocument).coord.image;
xsc:=Round(X/scale);
ysc:=Round(Y/scale);
if selected then begin
  //проверяем, как мы расположены отн. рамочки
  if mouse_down then begin
    kill_selection;
    case state of
      sSizeTopLeft: begin
        startx:=Xsc;
        starty:=Ysc;
      end;
      sSizeBottomLeft: begin
        startx:=Xsc;
        cury:=Ysc;
      end;
      sSizeLeft: startx:=Xsc;
      sSizeTopRight: begin
        curX:=Xsc;
        startY:=Ysc;
      end;
      sSizeBottomRight: begin
        curX:=Xsc;
        curY:=Ysc;
      end;
      sSizeRight: curX:=Xsc;
      sSizeTop: starty:=Ysc;
      sSizeBottom: cury:=Ysc;
    end;
    img.canvas.Rectangle(Round(startX*scale),Round(startY*scale),Round(curX*scale),Round(curY*scale));
  end
  else begin
    if (Xsc<curx+sensitivity) and (Xsc>startx-sensitivity) and (Ysc<cury+sensitivity) and (Ysc>starty-sensitivity) then begin

      if abs(Xsc-startx)<=sensitivity then
        if abs(Ysc-starty)<=sensitivity then state:=sSizeTopLeft
        else if abs(Ysc-curY)<=sensitivity then state:=sSizeBottomLeft
          else state:=sSizeLeft
      else if abs(Xsc-curx)<=sensitivity then
        if abs(Ysc-starty)<=sensitivity then state:=sSizeTopRight
          else if abs(Ysc-curY)<=sensitivity then state:=sSizeBottomRight
            else state:=sSizeRight
        else if abs(Ysc-startY)<=sensitivity then state:=sSizeTop
          else if abs(Ysc-curY)<=sensitivity then state:=sSizeBottom
            else state:=sCrop
    end
    else state:=sDeselect;
  end;
end
else begin
  if mouse_down then begin
    kill_selection; //стираем старую рамочку, если таковая имелась
    curX:=Xsc;
    curY:=Ysc;
    img.canvas.Rectangle(Round(startX*scale),Round(startY*scale),Round(curX*scale),Round(curY*scale));
  end;
end;

end;



initialization
RegisterClasses([TTool,TAddPointTool, TAddAxisTool, TCropTool]);

end.
