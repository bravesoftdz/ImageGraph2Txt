unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, table_func_lib, ExtCtrls, ExtDlgs, StdCtrls,coord_system_lib,
  TeEngine, Series, TeeProcs, Chart,Clipbrd, ComCtrls,math, Buttons,GraphicEx,command_class_lib,
  imageGraph2Txt_Commands, XPMan, ImgList, ToolWin, streaming_class_lib,imagegraph2txt_data,pngimage,
  Menus,FormPreferences,ImageGraph2Txt_tools,family_of_curves_lib,
  abstract_document_actions, ActnList;

type
  TForm1 = class(TForm)
    OpenPictureDialog1: TOpenPictureDialog;
    Timer1: TTimer;
    ScrollBox1: TScrollBox;
    Image1: TImage;
    PageControl1: TPageControl;
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
    ColorBox1: TColorBox;
    Label2: TLabel;
    Button2: TButton;
    btnResetPoints: TButton;
    ComboBox1: TComboBox;
    Label1: TLabel;
    lblPage2: TLabel;
    SaveTxt: TSaveDialog;
    SaveDialog1: TSaveDialog;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    Memo1: TMemo;
    Label3: TLabel;
    OpenDialog1: TOpenDialog;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    menuNewProject: TMenuItem;
    menuOpenProject: TMenuItem;
    menuSaveProject: TMenuItem;
    menuSaveProjectAs: TMenuItem;
    N6: TMenuItem;
    menuLoadImage: TMenuItem;
    menuPaste: TMenuItem;
    menuSaveImageAs: TMenuItem;
    N15: TMenuItem;
    menuUndo: TMenuItem;
    menuRedo: TMenuItem;
    MenuPreferences: TMenuItem;
    N20: TMenuItem;
    menuClearDataPoints: TMenuItem;
    menuSaveDataPoints: TMenuItem;
    N14: TMenuItem;
    menuZoomActualSize: TMenuItem;
    menuZoomFitToPage: TMenuItem;
    menuZoomPlus: TMenuItem;
    menuZoomMinus: TMenuItem;
    ToolBar1: TToolBar;
    ImageList1: TImageList;
    btnNew: TToolButton;
    btnOpenProject: TToolButton;
    btnSaveProject: TToolButton;
    btnSaveProjectAs: TToolButton;
    ToolButton3: TToolButton;
    btnAddPointsTool: TToolButton;
    btnAddAxesTool: TToolButton;
    N2: TMenuItem;
    menuCropTool: TMenuItem;
    menuAddAxesTool: TMenuItem;
    menuAddPointsTool: TMenuItem;
    btnCropTool: TToolButton;
    ToolButton1: TToolButton;
    btnZoomIn: TToolButton;
    btnZoomOut: TToolButton;
    btnPaste: TToolButton;
    btnUndo: TToolButton;
    btnRedo: TToolButton;
    ToolButton2: TToolButton;
    btnDataToClipbrd: TButton;
    N3: TMenuItem;
    UndoPopup1: TUndoPopup;
    RedoPopup1: TRedoPopup;
    Button1: TButton;
    menuLoadDataPoints: TMenuItem;
    AbstractDocumentActionList1: TAbstractDocumentActionList;
    NewProjectAction1: TNewProjectAction;
    NewProjectAction2: TNewProjectAction;
    OpenProjectAction1: TOpenProjectAction;
    SaveProjectAction1: TSaveProjectAction;
    SaveProjectAsAction1: TSaveProjectAsAction;
    DocUndoAction1: TDocUndoAction;
    DocRedoAction1: TDocRedoAction;
    DocShowHistoryAction1: TDocShowHistoryAction;
    AddPointTool1: TAddPointTool;
    AddAxisTool1: TAddAxisTool;
    CropTool1: TCropTool;
    procedure btnLoadImageClick(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
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
    procedure btnSaveBmpClick(Sender: TObject);
    procedure ColorBox1Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
    procedure LabeledEdit2Change(Sender: TObject);
    procedure LabeledEdit3Change(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure gui_refresh(Sender: TObject);
    procedure MenuPreferencesClick(Sender: TObject);
    procedure menuZoomActualSizeClick(Sender: TObject);
    procedure menuZoomFitToPageClick(Sender: TObject);
    procedure menuZoomPlusClick(Sender: TObject);
    procedure menuZoomMinusClick(Sender: TObject);
    procedure menuLoadImageClick(Sender: TObject);
    procedure menuPasteClick(Sender: TObject);
    procedure menuSaveImageAsClick(Sender: TObject);
    procedure menuClearDataPointsClick(Sender: TObject);
    procedure menuSaveDataPointsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAddPointsToolClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnZoomInClick(Sender: TObject);
    procedure btnZoomOutClick(Sender: TObject);
    procedure btnDataToClipbrdClick(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure MakeConnections(Sender: TObject);
    procedure menuLoadDataPointsClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  pic: TPicture;

  data: TImageGraph2TxtDocument;
  default_dir: string;
const CurProjectFileName: string='current_project.txt';
implementation

{$R *.dfm}


procedure refresh_undo_gui;
begin
  with Form1 do begin
    txtX0.Text:=FloatToStr(data.coord.x0);
    txtY0.Text:=FloatToStr(data.coord.y0);
    txtXmax.Text:=FloatToStr(data.coord.xmax);
    txtYmax.Text:=FloatToStr(data.coord.ymax);
    chkXLog.Checked:=data.coord.log_Xaxis;
    chkYLog.Checked:=data.coord.log_Yaxis;
    chkSwapXY.Checked:=data.coord.swapXY;
    colorBox1.Selected:=data.coord.LineColor;
    Combobox1.ItemIndex:=data.coord.raw_data.order;

    if (data.Tool is TAddAxisTool) and (TAddAxisTool(data.Tool)).KillMePls then
      AddPointTool1.Execute;
  end;
end;

procedure reset_picture;
begin
  with form1 do begin
    data.ScaledBtmp.AssignTo(image1.Picture.Bitmap);

    Scrollbox1.VertScrollBar.Range:=image1.height;
    scrollbox1.HorzScrollBar.Range:=image1.width;
  end;
end;

procedure repaint_graph;
var i,xt,yt,xmin,xmax: Integer;
    scale: Real;
begin
  scale:=Data.scale;
  reset_picture;
  data.coord.reprocess_output;
  data.coord.draw;
  if data.coord.data_enabled then begin
      form1.Image1.Canvas.Pen.Width:=2;
      form1.Image1.Canvas.Pen.Color:=data.coord.LineColor;
    if data.coord.swapXY then begin
      yt:=round(data.coord.Y_axis2pix(data.coord.t.xmax)*scale);
      xmax:=round(data.coord.Y_axis2pix(data.coord.t.xmin)*scale);
      if xmax>yt then begin
        xt:=round(data.coord.X_axis2pix(data.coord.t[data.coord.t.xmax])*scale);
        xmin:=yt;
      end
      else begin
        xt:=round(data.coord.X_axis2pix(data.coord.t[data.coord.t.xmin])*scale);
        xmin:=xmax;
        xmax:=yt;
      end;
      form1.Image1.Canvas.MoveTo(xt,yt);
      for i:=xmin to xmax do begin
        form1.Image1.Canvas.lineto(Round(data.coord.X_axis2pix(data.coord.t[data.coord.Y_pix2axis(Round(i/scale))])*scale),i);
      end;
    end
    else begin
      xt:=round(data.coord.X_axis2pix(data.coord.t.xmin)*scale);
      xmax:=round(data.coord.X_axis2pix(data.coord.t.xmax)*scale);
      if xmax>xt then begin
        yt:=round(data.coord.Y_axis2pix(data.coord.t[data.coord.t.xmin])*scale);
        xmin:=xt;
      end
      else begin
        yt:=round(data.coord.Y_axis2pix(data.coord.t[data.coord.t.xmax])*scale);
        xmin:=xmax;
        xmax:=xt;
      end;
      form1.Image1.Canvas.MoveTo(xmin,yt);
      for i:=xmin to xmax do begin
        form1.Image1.Canvas.lineto(i,Round(data.coord.Y_axis2pix(data.coord.t[data.coord.X_pix2axis(Round(i/scale))])*scale));
      end;
    end;
  end;
//  if Assigned(data.tool) then data.tool.Select;
end;

procedure TForm1.gui_refresh(sender: TObject);
begin
  refresh_undo_gui;
  repaint_graph;
end;

procedure TForm1.MakeConnections(Sender: TObject);
var i: Integer;
begin
  data.coord.image:=form1.Image1;
  data.StatusPanel:=form1.StatusBar1.Panels[0];
  form1.gui_refresh(data);
  if Assigned(data.tool) then begin
    for i:=0 to AbstractDocumentActionList1.ActionCount-1 do
      if AbstractDocumentActionList1.Actions[i].ClassType=data.Tool.ClassType then begin
        data.Tool.Select;
        AbstractDocumentActionList1.Actions[i].Assign(data.Tool);
        AbstractDocumentActionList1.Actions[i].Execute;
        break;
      end;
  end;
end;

procedure Load_project(FileName: string);
var tmp: TImageGraph2TxtDocument;
begin
  tmp:=TImageGraph2TxtDocument.LoadFromFile(FileName);

  data.Release;
  data:=tmp;

  data.FileName:='';
  data.onDocumentChange:=form1.gui_refresh;
  data.onLoad:=form1.MakeConnections;
end;

procedure TForm1.btnLoadImageClick(Sender: TObject);
begin
  menuLoadImageClick(nil);
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(data.tool) then
    data.tool.MouseDown(Button,Shift,X,Y);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
default_dir:=GetCurrentDir;

pic:=TPicture.Create;

AbstractDocumentActionList1.doc:=@data;

data:=TImageGraph2TxtDocument.Create(nil);
data.onLoad:=MakeConnections;
data.onDocumentChange:=gui_refresh;
data.DoLoad;
end;

procedure TForm1.txtX0Change(Sender: TObject);
var x: Extended;
begin
  if TryStrToFloat(txtx0.text,x) then
      data.DispatchCommand(TChangeFloatProperty.Create('coord.X0',x));
end;

procedure TForm1.txtY0Change(Sender: TObject);
var y: Extended;
begin
  if TryStrToFloat(txty0.Text,y) then
    data.DispatchCommand(TChangeFloatProperty.Create('coord.Y0',y));
end;

procedure TForm1.txtXmaxChange(Sender: TObject);
var x: Extended;
begin
  if TryStrToFloat(txtXmax.Text,x) then
    data.DispatchCommand(TChangeFloatProperty.Create('coord.Xmax',x));
end;

procedure TForm1.txtYmaxChange(Sender: TObject);
var y: Extended;
begin
  if TryStrToFloat(txtYmax.Text,y) then
    data.DispatchCommand(TChangeFloatProperty.Create('coord.Ymax',y));
end;

procedure TForm1.btnResetPointsClick(Sender: TObject);
begin
  menuClearDataPointsClick(nil);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  menuSaveDataPointsClick(nil);
end;

procedure TForm1.chkYLogClick(Sender: TObject);
begin
  data.DispatchCommand(TChangeBoolProperty.Create('coord.log_yaxis',chkYLog.Checked));
end;

procedure TForm1.chkXLogClick(Sender: TObject);
begin
  data.DispatchCommand(TChangeBoolProperty.Create('coord.log_Xaxis',chkXLog.Checked));
end;

procedure TForm1.chkSwapXYClick(Sender: TObject);
begin
  data.DispatchCommand(TChangeBoolProperty.Create('coord.swapXY',chkSwapXY.Checked));
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  if FileExists(CurProjectFilename) then Load_Project(CurProjectFilename);
  Form1.WindowState:=wsMaximized;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  menuPaste.Enabled:=Clipboard.HasFormat(CF_BITMAP);
  btnPaste.Enabled:=menuPaste.Enabled;
end;

procedure TForm1.btn_clipboardClick(Sender: TObject);
begin
  menuPasteClick(nil);
end;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var ax,ay,dx,dy: Real;
    precx,precy: Integer;
    str: string;
begin
  if data.coord.coords_enabled then begin //� ��� ��� ���������
  //���� ���� ��� �������� - �������
    ax:=data.coord.X_pix2axis(Round(X/data.Scale));
    ay:=data.coord.Y_pix2axis(Round(Y/data.scale));
    dx:=log10(abs((data.coord.X_pix2axis(X+1)-data.coord.X_pix2axis(X-1))/2));
    if dx>0 then dx:=0;
    dy:=log10(abs((data.coord.Y_pix2axis(Y+1)-data.coord.Y_pix2axis(Y-1))/2));
    if dy>0 then dy:=0;
    if ax=0 then precx:=1 else
      precx:=Ceil(log10(abs(ax))-dx);
    if precx<1 then precx:=1;
    if ay=0 then precy:=1 else
      precy:=Ceil(log10(abs(ay))-dy);
    if precy<1 then precy:=1;
    str:='���������� (%.'+IntToStr(precx)+'g ; %.'+IntToStr(precy)+'g)';
    statusbar1.Panels[1].Text:=Format(str,[ax,ay]);
  end;
  if assigned(data.tool) then
    data.tool.MouseMove(Shift,X,Y);
end;

procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

  if assigned(data.tool) then
    data.tool.MouseUp(Button,Shift,X,Y);
end;

procedure TForm1.btnSaveBmpClick(Sender: TObject);
begin
  menuSaveImageAsClick(nil);
end;

procedure TForm1.ColorBox1Change(Sender: TObject);
begin
  data.DispatchCommand(TChangeIntegerProperty.Create('coord.LineColor',ColorBox1.Selected,'LineColor='+ColorToString(ColorBox1.Selected)));
  repaint_graph;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  data.DispatchCommand(TChangeIntegerProperty.Create('coord.raw_data.order',StrToInt(ComboBox1.Text),'Order='+ComboBox1.Text));
  repaint_graph;
end;

procedure TForm1.LabeledEdit1Change(Sender: TObject);
begin
  data.coord.t.title:=LabeledEdit1.Text;
end;

procedure TForm1.LabeledEdit2Change(Sender: TObject);
begin
  data.coord.t.Xname:=LabeledEdit2.Text;
end;

procedure TForm1.LabeledEdit3Change(Sender: TObject);
begin
  data.coord.t.Yname:=LabeledEdit3.Text;
end;

procedure TForm1.Memo1Change(Sender: TObject);
begin
  data.coord.t.description:=Memo1.Lines;
end;

procedure TForm1.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if Shift=[] then with ScrollBox1.VertScrollBar do
    Position:=Position+increment
  else if Shift=[ssShift] then with ScrollBox1.HorzScrollBar do
    Position:=Position+increment
  else if Shift=[ssCtrl] then begin
    data.scale:=data.scale*0.9;
//    kill_selection;
    reset_picture;
    repaint_graph;
  end;
  Handled:=true;
end;

procedure TForm1.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if Shift=[] then with ScrollBox1.VertScrollBar do
    Position:=Position-increment
  else if Shift=[ssShift] then with ScrollBox1.HorzScrollBar do
    Position:=Position-increment
  else if Shift=[ssCtrl] then begin
    data.scale:=data.scale*1.1;
//    kill_selection;
    reset_picture;
    repaint_graph;
  end;

  Handled:=true;
end;

procedure TForm1.MenuPreferencesClick(Sender: TObject);
begin
  with frmPrefs do begin
    chkSaveWithUndo.Checked:=data.SaveWithUndo;
    rdSaveType.ItemIndex:=Ord(data.SaveType);
    if ShowModal=mrOk then begin
      data.SaveWithUndo:=chkSaveWithUndo.Checked;
      data.SaveType:=StreamingClassSaveFormat(rdSaveType.ItemIndex);
    end;
  end;
end;

procedure TForm1.menuZoomActualSizeClick(Sender: TObject);
begin
//  kill_selection;
  data.Scaled:=false;
  reset_picture;
  repaint_graph;
end;

procedure TForm1.menuZoomFitToPageClick(Sender: TObject);
begin
//  kill_selection;
  data.Scaled:=true;
  data.SetSize(ScrollBox1.ClientWidth,ScrollBox1.ClientHeight);
  reset_picture;
  repaint_graph;
end;

procedure TForm1.menuZoomPlusClick(Sender: TObject);
begin
//  kill_selection;
  data.scale:=data.scale*sqrt(2);
  reset_picture;
  repaint_graph;
end;

procedure TForm1.menuZoomMinusClick(Sender: TObject);
begin
//  kill_selection;
  data.scale:=data.scale/sqrt(2);
  reset_picture;
  repaint_graph;
end;

procedure TForm1.menuLoadImageClick(Sender: TObject);
var btmp: TBitmap;
begin
  if openpicturedialog1.Execute then begin
    image1.Picture.LoadFromFile(openpicturedialog1.FileName);
    btmp:=TBitmap.Create;
    btmp.height:=image1.Picture.Height;
    btmp.Width:=image1.Picture.Width;
    btmp.Canvas.Draw(0,0,image1.Picture.Graphic);
    data.DispatchCommand(TLoadImageCommand.New(btmp));
    btmp.Free;
  end;
end;

procedure TForm1.menuPasteClick(Sender: TObject);
var btmp: TBitmap;
begin
  btmp:=TBitmap.Create;
  btmp.Assign(Clipboard);
  data.DispatchCommand(TLoadImageCommand.New(btmp));
  btmp.Free;
end;

procedure TForm1.menuSaveImageAsClick(Sender: TObject);
var png: TPngObject;
begin
  if SaveDialog1.Execute then begin
    if SaveDialog1.FilterIndex=2 then begin
      png:=TPngObject.Create;
      png.Filters:=[pfNone,pfSub,pfUp,pfAverage,pfPaeth];
      png.Assign(image1.Picture.Bitmap);
      png.SaveToFile(saveDialog1.FileName);
      png.Free;
    end
    else image1.Picture.SaveToFile(savedialog1.FileName);
  end;
end;

procedure TForm1.menuClearDataPointsClick(Sender: TObject);
begin
  data.DispatchCommand(TClearPointsCommand.Create);
end;

procedure TForm1.menuSaveDataPointsClick(Sender: TObject);
begin
  if SaveTxt.Execute then
    data.coord.t.SaveToTextFile(SaveTxt.FileName);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
pic.Free;
data.Release;

end;

procedure TForm1.btnAddPointsToolClick(Sender: TObject);
begin
  menuAddPointsTool.Click;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SetCurrentDir(default_dir);
  data.SaveType:=fCyr;
  data.SaveWithUndo:=true;
  data.FileName:=CurProjectFileName;
  data.Save;
//  data.SaveToFile(CurProjectFileName);
end;

procedure TForm1.btnZoomInClick(Sender: TObject);
begin
  menuZoomPlus.Click;
end;

procedure TForm1.btnZoomOutClick(Sender: TObject);
begin
  menuZoomMinus.Click;
end;


procedure TForm1.btnDataToClipbrdClick(Sender: TObject);
begin
  Clipboard.AsText:=data.coord.t.AsTabbedText;
end;

procedure TForm1.N3Click(Sender: TObject);
begin
  AbstractDocumentActionList1.ShowHistory;  
end;

procedure TForm1.menuLoadDataPointsClick(Sender: TObject);
var t: table_func;
begin
  if OpenDialog1.Execute then begin
    t:=table_func.Create;
    t.LoadFromTextFile(OpenDialog1.FileName);
    data.DispatchCommand(TLoadPointsCommand.New(t));
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  menuLoadDataPoints.Click;
end;

end.

