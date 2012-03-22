unit Unit1;
//версия 0.04
//исправлен глюк, что при обнулении точек обнуляются и подписи осей, даже если соотв. текст написан в полях.


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, table_func_lib, ExtCtrls, ExtDlgs, StdCtrls,coord_system_lib,
  TeEngine, Series, TeeProcs, Chart,Clipbrd, ComCtrls,math, Buttons,GraphicEx;

type
  TForm1 = class(TForm)
    OpenPictureDialog1: TOpenPictureDialog;
    Timer1: TTimer;
    ScrollBox1: TScrollBox;
    Image1: TImage;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Button1: TButton;
    btn_clipboard: TButton;
    CheckBox1: TCheckBox;
    btnCrop: TButton;
    TabSheet2: TTabSheet;
    txtX0: TLabeledEdit;
    txtY0: TLabeledEdit;
    txtXmax: TLabeledEdit;
    txtYmax: TLabeledEdit;
    chkSwapXY: TCheckBox;
    chkXLog: TCheckBox;
    chkYLog: TCheckBox;
    TabSheet3: TTabSheet;
    StatusBar1: TStatusBar;
    btnSaveBmp: TButton;
    ColorBox1: TColorBox;
    Label2: TLabel;
    Button2: TButton;
    btnResetPoints: TButton;
    ComboBox1: TComboBox;
    Label1: TLabel;
    lblPage1: TLabel;
    lblPage2: TLabel;
    SaveTxt: TSaveDialog;
    Button4: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SaveDialog1: TSaveDialog;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    Memo1: TMemo;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure txtX0Change(Sender: TObject);
    procedure txtY0Change(Sender: TObject);
    procedure txtXmaxChange(Sender: TObject);
    procedure txtYmaxChange(Sender: TObject);
    procedure btnResetPointsClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure chkYLogClick(Sender: TObject);
    procedure chkXLogClick(Sender: TObject);
    procedure chkSwapXYClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btn_clipboardClick(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnCropClick(Sender: TObject);
    procedure btnSaveBmpClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ColorBox1Change(Sender: TObject);
    procedure TabSheet2Enter(Sender: TObject);
    procedure TabSheet1Enter(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure TabSheet3Enter(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
    procedure LabeledEdit2Change(Sender: TObject);
    procedure LabeledEdit3Change(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  Form1: TForm1;
  state: Integer;
  (* 0 - изображение не выбрано
  1 - выбрано, хотим обрезать
  2 - выбрана область, которую надо оставить

  3 - отмечаем начало координат
  4 - отмечаем хар. точки на осях
  5 - построение самого графика
  *)
  c: coord_system;
  pic: TPicture;
  btmp: TBitmap; //текущее изображение
  mouse_down: boolean;
  start_P: TPoint;
  cur_P: TPoint;
implementation

{$R *.dfm}

procedure kill_selection;
//убрать выделение
begin
  with form1.image1.Canvas do begin
      Pen.Mode:=pmNotXor;
      pen.Style:=psDot;
      pen.Width:=1;
      brush.Color:=clWhite;
      Rectangle(start_P.X,start_P.Y,cur_P.X,cur_P.Y);
  end;
  state:=1;
  form1.btnCrop.Enabled:=false;
end;


procedure reset_picture;
begin
  with form1 do begin
    image1.Picture.Bitmap.Assign(btmp);
    image1.Proportional:=checkbox1.Checked;
    if image1.Proportional then begin
      image1.Height:=ScrollBox1.ClientHeight;
      image1.Width:=scrollbox1.ClientWidth;
      Scrollbox1.VertScrollBar.Range:=image1.height;
      scrollbox1.HorzScrollBar.Range:=image1.width;
    end
    else begin
      image1.height:=image1.picture.Height;
      image1.width:=image1.picture.Width;
      Scrollbox1.VertScrollBar.Range:=image1.height;
      scrollbox1.HorzScrollBar.Range:=image1.width;
    end;
    image1.Refresh;
  end;
end;
procedure repaint_graph;
var i,xt,yt,xmin,xmax: Integer;
begin
  reset_picture;
  c.draw;
  if (c.t.enabled) and (c.status) then begin
    if c.swapXY then begin
      yt:=round(c.Y_axis2pix(c.t.xmax));
      xt:=round(c.X_axis2pix(c.t[c.t.xmax]));
      form1.Image1.Canvas.Pen.Width:=2;
      form1.Image1.Canvas.Pen.Color:=c.line_color;
      form1.Image1.Canvas.MoveTo(xt,yt);
      xmin:=yt;
      xmax:=round(c.Y_axis2pix(c.t.xmin));
      for i:=xmin to xmax do begin
        form1.Image1.Canvas.lineto(c.X_axis2pix(c.t[c.Y_pix2axis(i)]),i);
      end;
    end
    else begin
      xt:=round(c.X_axis2pix(c.t.xmin));
      yt:=round(c.Y_axis2pix(c.t[c.t.xmin]));
      form1.Image1.Canvas.Pen.Width:=2;
      form1.Image1.Canvas.Pen.Color:=c.line_color;
      form1.Image1.Canvas.MoveTo(xt,yt);
      xmin:=xt;
      xmax:=round(c.X_axis2pix(c.t.xmax));
      for i:=xmin to xmax do begin
        form1.Image1.Canvas.lineto(i,c.Y_axis2pix(c.t[c.X_pix2axis(i)]));
      end;
    end;
  end;
end;



procedure TForm1.Button1Click(Sender: TObject);
begin
  if openpicturedialog1.Execute then begin
//    pic.LoadFromFile(openpicturedialog1.FileName);
//    btmp.Canvas.Draw(0,0,pic.Graphic);
    image1.Picture.LoadFromFile(openpicturedialog1.FileName);
    btmp.width:=0;
    btmp.height:=0;

    btmp.height:=image1.Picture.Height;
    btmp.Width:=image1.Picture.Width;
    btmp.Canvas.Draw(0,0,image1.Picture.Graphic);
//    btmp.Canvas.CopyRect(image1.ClientRect,image1.Canvas,image1.ClientRect);
//    btmp.Assign(image1.Picture.Bitmap);
    reset_picture;
    state:=1;
    c.Clear;
    lblPage1.Caption:='';
    lblPage2.Caption:='';
    StatusBar1.Panels[0].Text:='Вырезать прямоугольный участок';
  end;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  kill_selection;
  reset_picture;
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Case state of
  1: begin
    mouse_down:=True;
    start_P:=Point(X,Y);
    cur_P:=start_P;
    end;
  2: begin
    //снимаем старое выделение, потом по-новой
    kill_selection;
    start_P:=Point(X,Y);
    cur_P:=start_P;
    mouse_down:=true;
    end;
  3: begin c.set_zero(X,Y); state:=4; statusbar1.Panels[0].Text:='Отметьте точки на осях'; end;
  4: begin
   if c.set_axis(X,Y) then begin
    state:=5;
    statusbar1.Panels[0].Text:='Построение графика';
    SpeedButton1.Down:=true;
    end;
   end;
  5: begin
    c.AddPoint(X,Y);
    repaint_graph;
   end;
    
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
state:=0;
c:=coord_system.Create;
c.image:=image1;
btmp:=TBitmap.Create;
pic:=TPicture.Create;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
c.Free;
btmp.Free;
pic.Free;
end;

procedure TForm1.txtX0Change(Sender: TObject);
var x: Extended;
begin
  if TryStrToFloat(txtx0.text,x) then begin
    c.x0:=x;
    repaint_graph;
    
  end;
end;

procedure TForm1.txtY0Change(Sender: TObject);
var y: Extended;
begin
  if TryStrToFloat(txty0.Text,y) then begin
    c.y0:=y;
    repaint_graph;
  end;
end;

procedure TForm1.txtXmaxChange(Sender: TObject);
var x: Extended;
begin
  if TryStrToFloat(txtXmax.Text,x) then begin
    c.xmax:=x;
    repaint_graph;
  end;
end;

procedure TForm1.txtYmaxChange(Sender: TObject);
var y: Extended;
begin
  if TryStrToFloat(txtYmax.Text,y) then begin
    c.ymax:=y;
    repaint_graph;
  end;
end;

procedure TForm1.btnResetPointsClick(Sender: TObject);
begin
  c.t.Clear;
  c.t.title:=LabeledEdit1.Text;
  c.t.Xname:=LabeledEdit2.Text;
  c.t.Yname:=LabeledEdit3.Text;
  c.t.description:=Memo1.Text;
  repaint_graph;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if SaveTxt.Execute then
    c.t.SaveToFile(SaveTxt.FileName);
end;

procedure TForm1.chkYLogClick(Sender: TObject);
begin
  c.log_Yaxis:=chkYLog.Checked;
  repaint_graph;
end;

procedure TForm1.chkXLogClick(Sender: TObject);
begin
  c.log_Xaxis:=chkXLog.Checked;
  repaint_graph;
end;

procedure TForm1.chkSwapXYClick(Sender: TObject);
begin
  c.swapXY:=chkSwapXY.Checked;
  repaint_graph;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  chkSwapXYClick(Form1);
  chkXLogClick(Form1);
  chkYLogClick(Form1);
  txtYMaxChange(Form1);
  txtY0Change(Form1);
  txtX0Change(Form1);
  txtXMaxChange(Form1);
  Form1.WindowState:=wsMaximized;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  btn_clipboard.Enabled:=Clipboard.HasFormat(CF_BITMAP);
end;

procedure TForm1.btn_clipboardClick(Sender: TObject);
begin
  btmp.Assign(Clipboard);
  reset_picture;
  c.Clear;
  lblPage1.Caption:='';
  lblPage2.Caption:='';
  state:=1;
  StatusBar1.Panels[0].Text:='Вырезать прямоугольный участок';
end;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var ax,ay,dx,dy: Real;
    precx,precy: Integer;
    str: string;
begin
  With statusbar1.Panels[0] do begin
    Case state of
    0: Text:='Изображение не выбрано';
    1..2: Text:='Вырезать прямоугольную область';
    3: Text:='Отметьте начало координат';
    4: Text:='Отметьте точки на осях';
    5:  begin
        Text:='Построение графика';
        //без всяких заморочек с точностью
        //statusBar1.Panels[1].Text:=Format('Координаты (%g,%g)',[c.X_pix2axis(X),c.Y_pix2axis(Y)]);
        //посложнее: мы не хотим показывать лишних "хвостов"
        ax:=c.X_pix2axis(X);
        ay:=c.Y_pix2axis(Y);
        dx:=log10(abs((c.X_pix2axis(X+1)-c.X_pix2axis(X-1))/2));
        if dx>0 then dx:=0;
        dy:=log10(abs((c.Y_pix2axis(Y+1)-c.Y_pix2axis(Y-1))/2));
        if dy>0 then dy:=0;
        if ax=0 then precx:=1 else
          precx:=Ceil(log10(abs(ax))-dx);
        if ay=0 then precy:=1 else
          precy:=Ceil(log10(abs(ay))-dy);
        str:='Координаты (%.'+IntToStr(precx)+'g ; %.'+IntToStr(precy)+'g)';
        statusbar1.Panels[1].Text:=Format(str,[ax,ay]);

        end;
    end;
  end;
  if mouse_down then begin
    with image1.Canvas do begin
      kill_selection;
      cur_P:=Point(X,Y);
      Rectangle(start_P.X,start_P.Y,cur_P.X,cur_P.Y);
    end;
  end;
end;

procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  tmp: integer;
  begin
  mouse_down:=false;
  if state=1 then
    if (abs(start_P.X-cur_P.X)>10) and (abs(start_P.Y-cur_P.Y)>10) then begin
      state:=2;
      btnCrop.Enabled:=true;
      if (Start_P.X>cur_P.X) then begin
        tmp:=start_P.X;
        start_P.X:=cur_P.X;
        cur_P.X:=tmp;
      end;
      if (Start_P.Y>cur_P.Y) then begin
        tmp:=start_P.Y;
        start_P.Y:=cur_P.Y;
        cur_P.Y:=tmp;
      end;
    end
    else
      kill_selection;
end;

procedure TForm1.btnCropClick(Sender: TObject);
var
src,dest: TRect;
begin
//сначала убьем рамочку
kill_selection;


src:=Rect(start_P,cur_P);
dest:=Rect(0,0,cur_P.X-start_P.X,cur_P.Y-start_P.Y);
btmp.Height:=cur_P.Y-start_P.Y;
btmp.Width:=cur_P.X-start_P.X;
btmp.Canvas.CopyRect(dest,image1.Canvas,src);
reset_picture;
c.Clear;
lblPage1.Caption:='';
lblPage2.Caption:='';
end;

procedure TForm1.btnSaveBmpClick(Sender: TObject);
begin
  if SaveDialog1.Execute then begin
    image1.Picture.SaveToFile(savedialog1.FileName);
//    btmp.
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  state:=3;
  c.ClearAxes;
  repaint_graph;
  Button4.Down:=true;
end;

procedure TForm1.ColorBox1Change(Sender: TObject);
begin
  c.line_color:=ColorBox1.Selected;
  repaint_graph;
end;

procedure TForm1.TabSheet2Enter(Sender: TObject);
begin
  repaint_graph;
  StatusBar1.Panels[0].Text:='';
  if c.t.enabled then
    lblPage2.Caption:='При редактировании в этой вкладке точки графика могут исказиться';

end;

procedure TForm1.TabSheet1Enter(Sender: TObject);
begin
  if c.nonzero then begin
    lblPage1.Caption:='При редактировании изображения в этой вкладке оси и точки обнулятся!';
    state:=1;
    reset_picture;
  end;    
  StatusBar1.Panels[0].Text:='Вырезать прямоугольный участок';
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  c.t.order:=StrToInt(ComboBox1.Text);
  repaint_graph;
end;

procedure TForm1.TabSheet3Enter(Sender: TObject);
begin
  state:=5;
  repaint_graph;
end;

procedure TForm1.LabeledEdit1Change(Sender: TObject);
begin
  c.t.title:=LabeledEdit1.Text;
end;

procedure TForm1.LabeledEdit2Change(Sender: TObject);
begin
  c.t.Xname:=LabeledEdit2.Text;
end;

procedure TForm1.LabeledEdit3Change(Sender: TObject);
begin
  c.t.Yname:=LabeledEdit3.Text;
end;

procedure TForm1.Memo1Change(Sender: TObject);
begin
  c.t.description:=Memo1.Text;
end;

end.
