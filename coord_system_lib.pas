unit coord_system_lib;

interface
uses ExtCtrls,graphics,table_func_lib;
type
    coord_system=class
    private
      pix_x0,pix_y0,pix_xmax,pix_ymax :Integer;
      //координаты начала коорд и точек на осях соотв.
      dat_x0,dat_y0,dat_xmax,dat_ymax :Real;
      //те же точки но в единицах указаных на осях
      zero_picked,xmax_picked,ymax_picked: Boolean;
      function get_nonzero: Boolean;
      function get_status: Boolean;
      //выбраны ли данные точки?



    public
      image: TImage;
      t: table_func;  //выходная, которая в файл пойдет
      raw_data: table_func; //промежуточная, запоминающая коорд. в пикселях
      log_Xaxis,log_Yaxis :boolean;
      swapXY: boolean;

      line_color: TColor;
      procedure reprocess_output;
      procedure set_zero(X: Integer; Y:Integer);
      function set_axis(X: Integer; Y:Integer): Boolean;

      function change_x0(var x: Real): boolean;
      function change_y0(var y: Real): boolean;
      function change_xmax(var x: Real): boolean;
      function change_ymax(var y: Real): boolean;

      property x0: Real read dat_x0;
      property y0: Real read dat_y0;
      property xmax: Real read dat_xmax;
      property ymax: Real read dat_ymax;

      procedure invert_bool(var adr: boolean);

      property nonzero: Boolean read get_nonzero;
      property status: Boolean read get_status;
      procedure draw;
      function AddPoint(X: Integer; Y:Integer): boolean;
      function DeletePoint(X: Integer): boolean;
      procedure Clear;
      procedure ClearAxes;
      procedure ClearAllPoints;
      function X_pix2axis(X: Integer) :Real;
      function Y_pix2axis(Y: Integer) :Real;
      function X_axis2pix(X: Real) :Integer;
      function Y_axis2pix(Y: Real) :Integer;

      constructor Create;
      destructor Destroy; override;
    end;


implementation
constructor coord_system.Create;
begin
  inherited Create;
  dat_xmax:=10;
  dat_ymax:=10;
  t:=table_func.Create;
  raw_data:=table_func.Create;
  line_color:=clBlack;
end;

destructor coord_system.Destroy;
begin
  t.Free;
  raw_data.Free;
  inherited Destroy;
end;

procedure coord_system.Clear;
begin
  zero_picked:=false;
  xmax_picked:=false;
  ymax_picked:=false;
  t.Clear;
end;
procedure coord_system.clearAxes;
begin
  zero_picked:=false;
  xmax_picked:=false;
  ymax_picked:=false;
end;


function coord_system.get_nonzero: Boolean;
begin
  get_nonzero:=zero_picked or xmax_picked or ymax_picked;
end;

function coord_system.get_status: Boolean;
begin
  get_status:=zero_picked and xmax_picked and ymax_picked;
end;

procedure coord_system.set_zero(X:Integer; Y:Integer);
begin
  pix_X0:=X;
  pix_Y0:=Y;
  zero_picked:=true;
  draw;
end;

function coord_system.set_axis(X:Integer; Y:Integer): Boolean;
begin
  if zero_picked then begin
    if abs(X-pix_X0)>abs(Y-pix_Y0) then begin
      pix_Xmax:=X;
      xmax_picked:=true;
      end
    else begin
     pix_Ymax:=Y;
     ymax_picked:=true;
    end;
  end;
  set_axis:=status;
  draw;
end;
procedure coord_system.draw;
begin
  image.Canvas.Pen.Width:=3;
  image.Canvas.Brush.Color:=clBlack;
  image.Canvas.Pen.Color:=clBlack;
  image.Canvas.Pen.Style:=psSolid;
  image.Canvas.Pen.Mode:=pmCopy;
  if zero_picked then image.Canvas.Ellipse(pix_x0-4,pix_Y0-4,pix_X0+4,pix_Y0+4);
  if xmax_picked then begin
    image.Canvas.MoveTo(pix_x0,pix_y0);
    image.Canvas.LineTo(pix_Xmax,pix_y0);
    image.Canvas.Ellipse(pix_xmax-4,pix_y0-4,pix_xmax+4,pix_y0+4);
  end;
  if ymax_picked then begin
    image.Canvas.MoveTo(pix_x0,pix_y0);
    image.Canvas.LineTo(pix_x0,pix_Ymax);
    image.Canvas.Ellipse(pix_x0-4,pix_ymax-4,pix_x0+4,pix_ymax+4);
  end;

end;

function coord_system.X_axis2pix(X: Real) :Integer;
begin
  if log_XAxis then
    X_axis2pix:=pix_x0+Round((ln(X)-ln(dat_x0))*(pix_xmax-pix_x0)/(ln(dat_xmax)-ln(dat_x0)))
  else
    X_axis2pix:=pix_x0+Round((X-dat_x0)*(pix_xmax-pix_x0)/(dat_xmax-dat_x0));
end;

function coord_system.Y_axis2pix(Y: Real) :Integer;
begin
  if log_YAxis then
    Y_axis2pix:=pix_y0+Round((ln(Y)-ln(dat_y0))*(pix_ymax-pix_y0)/(ln(dat_ymax)-ln(dat_y0)))
  else
    Y_axis2pix:=pix_y0+Round((Y-dat_y0)*(pix_ymax-pix_y0)/(dat_ymax-dat_y0));
end;

function coord_system.X_pix2axis(X: Integer) :Real;
begin
  if log_XAxis then
    X_pix2axis:=dat_x0*exp((ln(dat_xmax)-ln(dat_x0))/(pix_xmax-pix_x0)*(X-pix_x0))
  else
    X_pix2axis:=dat_x0+(dat_xmax-dat_x0)/(pix_xmax-pix_x0)*(X-pix_x0);
end;

function coord_system.Y_pix2axis(Y: Integer) :Real;
begin
  if log_YAxis then
    Y_pix2axis:=dat_y0*exp((ln(dat_ymax)-ln(dat_y0))/(pix_ymax-pix_y0)*(Y-pix_y0))
  else
    Y_pix2axis:=dat_y0+(dat_ymax-dat_y0)/(pix_ymax-pix_y0)*(Y-pix_y0);
end;

function coord_system.AddPoint(X: Integer; Y:Integer): boolean;
begin
  result:=raw_data.addpoint(X,Y);
  if result then begin
    if swapXY then t.addpoint(Y_pix2axis(Y),X_pix2axis(X))
    else t.addpoint(X_pix2axis(X),Y_pix2axis(Y));
  end;
end;

function coord_system.DeletePoint(X: Integer): Boolean;
begin
  result:=raw_data.deletepoint(X);
  if result then reprocess_output;
end;

function coord_system.change_x0(var x: Real): boolean;
var tmp: Real;
begin
  Result:=(dat_x0<>x);
  if Result then begin
    tmp:=dat_x0;
    dat_x0:=x;
    x:=tmp;
    reprocess_output;
  end;
end;

function coord_system.change_y0(var y: Real): boolean;
var tmp: Real;
begin
  Result:=(dat_y0<>y);
  if Result then begin
    tmp:=dat_y0;
    dat_y0:=y;
    y:=tmp;
    reprocess_output;
  end;
end;

function coord_system.change_xmax(var x: Real): boolean;
var tmp: Real;
begin
  Result:=(dat_xmax<>x);
  if Result then begin
    tmp:=dat_xmax;
    dat_xmax:=x;
    x:=tmp;
    reprocess_output;
  end;
end;

function coord_system.change_ymax(var y: Real): boolean;
var tmp: Real;
begin
  Result:=(dat_ymax<>y);
  if Result then begin
    tmp:=dat_ymax;
    dat_ymax:=y;
    y:=tmp;
    reprocess_output;
  end;
end;

procedure coord_system.reprocess_output;
var i,L: Integer;
begin
  t.Clear;
  L:=raw_data.count-1;
  if swapXY then for i:=0 to L do t.addpoint(Y_pix2axis(Round(raw_data.Y[i])),X_pix2axis(Round(raw_data.X[i])))
  else for i:=0 to L do t.addpoint(X_pix2axis(Round(raw_data.X[i])),Y_pix2axis(Round(raw_data.Y[i])));
end;

procedure coord_system.invert_bool(var adr: boolean);
begin
  adr:=not adr;
  reprocess_output;
end;

procedure coord_system.ClearAllPoints;
begin
  raw_data.Clear;
  t.Clear;
end;

end.
