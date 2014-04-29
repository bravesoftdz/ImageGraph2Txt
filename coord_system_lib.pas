unit coord_system_lib;

interface
uses ExtCtrls,graphics,table_func_lib,streaming_class_lib,classes;
type
    Tcoord_system=class(TStreamingClass)
    private
      fpix_x0,fpix_y0,fpix_xmax,fpix_ymax :Integer;
      //координаты начала коорд и точек на осях соотв.
      dat_x0,dat_y0,dat_xmax,dat_ymax :Real;
      //те же точки но в единицах указаных на осях
      fzero_picked,fxmax_picked,fymax_picked: Boolean;
      fRawData: table_func; //промежуточная, запоминающая коорд. в пикселях
      fLineColor: TColor;
      function get_nonzero: Boolean;
      function get_status: Boolean;
      //выбраны ли данные точки?

      procedure change_x0(x: Real);
      procedure change_y0(y: Real);
      procedure change_xmax(x: Real);
      procedure change_ymax(y: Real);

      procedure change_pix_x0(x: Integer);
      procedure change_pix_y0(y: Integer);
      procedure change_pix_xmax(x: Integer);
      procedure change_pix_ymax(y: Integer);

    public
      image: TImage;
      t: table_func;  //выходная, которая в файл пойдет
      flog_Xaxis,flog_Yaxis :boolean;
      fswapXY: boolean;


      procedure reprocess_output;
      function set_axis(X: Integer; Y:Integer): Boolean;

      function coords_enabled: Boolean;
      function data_enabled: Boolean;

      procedure invert_bool(var adr: boolean);

      property nonzero: Boolean read get_nonzero;
      property status: Boolean read get_status;
      procedure draw;
      function AddPoint(X,Y: Real): boolean;
      function DeletePoint(X: Real): boolean;
      procedure Clear;
      procedure ClearAxes;
      procedure ClearAllPoints;
      function X_pix2axis(X: Integer) :Real;
      function Y_pix2axis(Y: Integer) :Real;
      function X_axis2pix(X: Real) :Integer;
      function Y_axis2pix(Y: Real) :Integer;

      procedure LoadDataPoints(new_data: table_func);

      constructor Create(owner: TComponent); override;
      procedure AfterConstruction; override;
      destructor Destroy; override;
    published
      property x0: Real read dat_x0 write change_x0;
      property y0: Real read dat_y0 write change_y0;
      property xmax: Real read dat_xmax write change_xmax;
      property ymax: Real read dat_ymax write change_ymax;

      property pix_x0: Integer read fpix_x0 write change_pix_x0;
      property pix_y0: Integer read fpix_y0 write change_pix_y0;
      property pix_xmax: Integer read fpix_xmax write change_pix_xmax;
      property pix_ymax: Integer read fpix_ymax write change_pix_ymax;

      property zero_picked: Boolean read fzero_picked write fzero_picked;
      property xmax_picked: Boolean read fxmax_picked write fxmax_picked;
      property ymax_picked: Boolean read fymax_picked write fymax_picked;

      property log_xaxis: boolean read flog_Xaxis write flog_Xaxis;
      property log_Yaxis: boolean read flog_Yaxis write flog_Yaxis;
      property swapXY: boolean read fswapXY write fswapXY;

      property LineColor: TColor read fLineColor write fLineColor default clBlack;

      property raw_data: table_func read fRawData write fRawData;
    end;


implementation

uses imagegraph2txt_data;

constructor Tcoord_system.Create(owner: TComponent);
begin
  inherited Create(owner);
  dat_xmax:=10;
  dat_ymax:=10;
  t:=table_func.Create;
  raw_data:=table_func.Create;
  raw_data.Tolerance:=0.01;
  LineColor:=clBlack;
  SetSubComponent(true);
end;

procedure TCoord_system.AfterConstruction;
begin
  if data_enabled then reprocess_output;
end;

destructor Tcoord_system.Destroy;
begin
  t.Free;
  raw_data.Free;
  inherited Destroy;
end;

procedure Tcoord_system.Clear;
begin
  clearAxes;
  t.Clear;
end;
procedure Tcoord_system.clearAxes;
begin
  zero_picked:=false;
  xmax_picked:=false;
  ymax_picked:=false;
end;


function Tcoord_system.get_nonzero: Boolean;
begin
  get_nonzero:=zero_picked or xmax_picked or ymax_picked;
end;

function Tcoord_system.get_status: Boolean;
begin
  get_status:=zero_picked and xmax_picked and ymax_picked;
end;

function TCoord_system.coords_enabled: Boolean;
begin
  Result:=get_status and (dat_xmax<>dat_x0) and (dat_ymax<>dat_y0);
end;

function TCoord_system.data_enabled: Boolean;
begin
  Result:=coords_enabled and raw_data.enabled;
end;

function Tcoord_system.set_axis(X:Integer; Y:Integer): Boolean;
begin
  if zero_picked then begin
    if abs(X-pix_X0)>abs(Y-pix_Y0) then begin
      pix_Xmax:=X;
      xmax_picked:=true;
      end
    else begin
      if Y=pix_Y0 then begin
        set_axis:=false;
        exit;
      end;
     pix_Ymax:=Y;
     ymax_picked:=true;
    end;
  end;
  set_axis:=status;
  draw;
end;
procedure Tcoord_system.draw;
var scale: Real;
  x0_scaled,y0_scaled,xmax_scaled,ymax_scaled: Integer;
begin
  scale:=(Owner as TImageGraph2TxtDocument).scale;
  x0_scaled:=Round(pix_x0*scale);
  y0_scaled:=Round(pix_y0*scale);
  xmax_scaled:=Round(pix_xmax*scale);
  ymax_scaled:=Round(pix_ymax*scale);
  if Assigned(image) then begin
    image.Canvas.Pen.Width:=3;
    image.Canvas.Brush.Color:=clBlack;
    image.Canvas.Pen.Color:=clBlack;
    image.Canvas.Pen.Style:=psSolid;
    image.Canvas.Pen.Mode:=pmCopy;
    if zero_picked then begin
      image.Canvas.Ellipse(x0_scaled-4,Y0_scaled-4,X0_scaled+4,Y0_scaled+4);
      if xmax_picked then begin
        image.Canvas.MoveTo(x0_scaled,y0_scaled);
        image.Canvas.LineTo(Xmax_scaled,y0_scaled);
        image.Canvas.Ellipse(xmax_scaled-4,y0_scaled-4,xmax_scaled+4,y0_scaled+4);
      end;
      if ymax_picked then begin
        image.Canvas.MoveTo(x0_scaled,y0_scaled);
        image.Canvas.LineTo(x0_scaled,Ymax_scaled);
        image.Canvas.Ellipse(x0_scaled-4,ymax_scaled-4,x0_scaled+4,ymax_scaled+4);
      end;
    end;
  end;

end;

function Tcoord_system.X_axis2pix(X: Real) :Integer;
begin
  if log_XAxis then
    X_axis2pix:=pix_x0+Round((ln(X)-ln(dat_x0))*(pix_xmax-pix_x0)/(ln(dat_xmax)-ln(dat_x0)))
  else
    X_axis2pix:=pix_x0+Round((X-dat_x0)*(pix_xmax-pix_x0)/(dat_xmax-dat_x0));
end;

function Tcoord_system.Y_axis2pix(Y: Real) :Integer;
begin
  if log_YAxis then
    Y_axis2pix:=pix_y0+Round((ln(Y)-ln(dat_y0))*(pix_ymax-pix_y0)/(ln(dat_ymax)-ln(dat_y0)))
  else
    Y_axis2pix:=pix_y0+Round((Y-dat_y0)*(pix_ymax-pix_y0)/(dat_ymax-dat_y0));
end;

function Tcoord_system.X_pix2axis(X: Integer) :Real;
begin
  if log_XAxis then
    X_pix2axis:=dat_x0*exp((ln(dat_xmax)-ln(dat_x0))/(pix_xmax-pix_x0)*(X-pix_x0))
  else
    X_pix2axis:=dat_x0+(dat_xmax-dat_x0)/(pix_xmax-pix_x0)*(X-pix_x0);
end;

function Tcoord_system.Y_pix2axis(Y: Integer) :Real;
begin
  if log_YAxis then
    Y_pix2axis:=dat_y0*exp((ln(dat_ymax)-ln(dat_y0))/(pix_ymax-pix_y0)*(Y-pix_y0))
  else
    Y_pix2axis:=dat_y0+(dat_ymax-dat_y0)/(pix_ymax-pix_y0)*(Y-pix_y0);
end;

function Tcoord_system.AddPoint(X,Y: Real): boolean;
begin
  result:=raw_data.addpoint(X,Y);
  if result then reprocess_output;
(*
  if result then begin
    if swapXY then t.addpoint(Y_pix2axis(Y),X_pix2axis(X))
    else t.addpoint(X_pix2axis(X),Y_pix2axis(Y));
  end;
*)
end;

function Tcoord_system.DeletePoint(X: Real): Boolean;
begin
  result:=raw_data.deletepoint(X);
  if result then reprocess_output;
end;

procedure Tcoord_system.change_x0(x: Real);
begin
  dat_x0:=x;
  reprocess_output;
end;

procedure Tcoord_system.change_y0(y: Real);
begin
  dat_y0:=y;
  reprocess_output;
end;

procedure Tcoord_system.change_xmax(x: Real);
begin
  dat_xmax:=x;
  reprocess_output;
end;

procedure Tcoord_system.change_ymax(y: Real);
begin
  dat_ymax:=y;
  reprocess_output;
end;

procedure Tcoord_system.change_pix_x0(x: Integer);
begin
  fpix_x0:=x;
  reprocess_output;
end;

procedure Tcoord_system.change_pix_y0(y: Integer);
begin
  fpix_y0:=y;
  reprocess_output;
end;

procedure Tcoord_system.change_pix_xmax(x: Integer);
begin
  fpix_xmax:=x;
  reprocess_output;
end;

procedure Tcoord_system.change_pix_ymax(y: Integer);
begin
  fpix_ymax:=y;
  reprocess_output;
end;

procedure Tcoord_system.reprocess_output;
var i,L: Integer;
begin
//  if not (csLoading in self.ComponentState) and enabled then begin
  if not raw_data.enabled then t.Clear;
  if data_enabled then begin
    t.Clear;
    t.order:=raw_data.order;
    L:=raw_data.count-1;
    if swapXY then for i:=0 to L do t.addpoint(Y_pix2axis(Round(raw_data.Y[i])),X_pix2axis(Round(raw_data.X[i])))
    else for i:=0 to L do t.addpoint(X_pix2axis(Round(raw_data.X[i])),Y_pix2axis(Round(raw_data.Y[i])));
  end;
end;

procedure Tcoord_system.invert_bool(var adr: boolean);
begin
  adr:=not adr;
  reprocess_output;
end;

procedure Tcoord_system.ClearAllPoints;
begin
  raw_data.ClearPoints;
  t.ClearPoints;
end;

procedure TCoord_system.LoadDataPoints(new_data: table_func);
var i: Integer;
begin
  t.assign(new_data);
  raw_data.Clear;
  for i:=0 to t.count-1 do
    raw_data.addpoint(X_axis2pix(t.X[i]),Y_axis2pix(t.Y[i]));
end;

end.
