unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, table_func_lib, ExtCtrls, ExtDlgs, StdCtrls,coord_system_lib,
  TeEngine, Series, TeeProcs, Chart,Clipbrd, ComCtrls,math, Buttons,GraphicEx,command_class_lib,
  imageGraph2Txt_Commands, XPMan, ImgList, ToolWin, streaming_class_lib,imagegraph2txt_data,pngimage,
  Menus,FormPreferences,ImageGraph2Txt_tools,family_of_curves_lib,formHistory;

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
    menuUndoList: TPopupMenu;
    menuRedoList: TPopupMenu;
    btnDataToClipbrd: TButton;
    N3: TMenuItem;
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
    procedure btnRedoClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure menuNewProjectClick(Sender: TObject);
    procedure menuOpenProjectClick(Sender: TObject);
    procedure gui_refresh(Sender: TObject);
    procedure menuSaveProjectClick(Sender: TObject);
    procedure menuSaveProjectAsClick(Sender: TObject);
    procedure MenuPreferencesClick(Sender: TObject);
    procedure menuZoomActualSizeClick(Sender: TObject);
    procedure menuZoomFitToPageClick(Sender: TObject);
    procedure menuZoomPlusClick(Sender: TObject);
    procedure menuZoomMinusClick(Sender: TObject);
    procedure menuUndoClick(Sender: TObject);
    procedure menuRedoClick(Sender: TObject);
    procedure menuLoadImageClick(Sender: TObject);
    procedure menuPasteClick(Sender: TObject);
    procedure menuSaveImageAsClick(Sender: TObject);
    procedure menuClearDataPointsClick(Sender: TObject);
    procedure menuSaveDataPointsClick(Sender: TObject);
    procedure btnUndoClick(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure btnSaveProjectClick(Sender: TObject);
    procedure btnOpenProjectClick(Sender: TObject);
    procedure btnSaveProjectAsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAddPointsToolClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure menuCropToolClick(Sender: TObject);
    procedure menuAddAxesToolClick(Sender: TObject);
    procedure menuAddPointsToolClick(Sender: TObject);
    procedure btnCropToolClick(Sender: TObject);
    procedure btnAddAxesToolClick(Sender: TObject);
    procedure btnPasteClick(Sender: TObject);
    procedure btnZoomInClick(Sender: TObject);
    procedure btnZoomOutClick(Sender: TObject);
    procedure menuUndoListPopup(Sender: TObject);
    procedure ProcessUndoMenu(Sender: TObject);
    procedure menuRedoListPopup(Sender: TObject);
    procedure ProcessRedoMenu(Sender: TObject);
    procedure btnDataToClipbrdClick(Sender: TObject);
    procedure N3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  pic: TPicture;
//  mouse_down: boolean;
//  start_P: TPoint;
//  cur_P: TPoint;

  data: TImageGraph2TxtDocument;
  default_dir: string;
const CurProjectFileName: string='current_project.txt';
implementation

{$R *.dfm}


procedure refresh_undo_gui;
begin
  with Form1 do begin

    menuNewProject.Enabled:=not data.isEmpty;
    btnNew.Enabled:=menuNewProject.Enabled;

    menuSaveProject.Enabled:=data.Changed;
    btnSaveProject.Enabled:=menuSaveProject.Enabled;

    menuUndo.Enabled:=data.UndoTree.UndoEnabled;
    menuRedo.Enabled:=data.UndoTree.RedoEnabled;

    btnUndo.Enabled:=menuUndo.Enabled;
    btnRedo.Enabled:=menuRedo.Enabled;

    txtX0.Text:=FloatToStr(data.coord.x0);
    txtY0.Text:=FloatToStr(data.coord.y0);
    txtXmax.Text:=FloatToStr(data.coord.xmax);
    txtYmax.Text:=FloatToStr(data.coord.ymax);
    chkXLog.Checked:=data.coord.log_Xaxis;
    chkYLog.Checked:=data.coord.log_Yaxis;
    chkSwapXY.Checked:=data.coord.swapXY;
    colorBox1.Selected:=data.coord.LineColor;
    Combobox1.ItemIndex:=data.coord.raw_data.order;
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
  if Assigned(data.tool) then data.tool.Select;
end;

procedure TForm1.gui_refresh(sender: TObject);
begin
  refresh_undo_gui;
  repaint_graph;
end;

procedure make_connections;
var item: TMenuItem;
begin
  data.onDocumentChange:=form1.gui_refresh;
  data.coord.image:=form1.Image1;
  data.StatusPanel:=form1.StatusBar1.Panels[0];
  if Assigned(data.tool) then begin
    item:=Form1.FindComponent(data.tool.ButtonName) as TMenuItem;
    item.Click;
  end
  else begin
    data.tool:=TAddPointTool.Create(data,form1.menuAddPointsTool.Name);
    form1.menuAddPointsTool.Click;
  end;
  form1.gui_refresh(data);
end;

procedure Load_project(FileName: string);
var tmp: TImageGraph2TxtDocument;
begin
  tmp:=TImageGraph2TxtDocument.LoadFromFile(FileName);
  //если все в порядке (не выгрузилось), то сменим указатели
  data.Free;
  data:=tmp;
  //таким образом, если проект не загрузился, предыдущий не потеряется.
  //и попытка освободить несуществующий объект тоже не будет предпринята
  make_connections;
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

data:=TImageGraph2TxtDocument.Create(nil);
make_connections;

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
  refresh_undo_gui;
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
  if data.coord.coords_enabled then begin //а что нам жадничать
  //если есть что показать - покажем
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
    str:='Координаты (%.'+IntToStr(precx)+'g ; %.'+IntToStr(precy)+'g)';
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


procedure TForm1.btnUndoClick(Sender: TObject);
begin
  menuUndoClick(nil);
end;

procedure TForm1.btnRedoClick(Sender: TObject);
begin
  menuRedoClick(nil);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  if Savetxt.Execute then begin
//    data.SaveWithUndo:=false;
    if Savetxt.FilterIndex=1 then data.saveFormat:=fCyr
    else data.saveFormat:=fBinary;
    data.SaveToFile(savetxt.FileName);
  end;
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

procedure TForm1.menuNewProjectClick(Sender: TObject);
begin
  if (not data.Changed) or (Application.MessageBox('Все действия и история изменений будут потеряны. Продолжить?','Новый проект',MB_YesNo)=IDYes) then begin
    data.Free;
    data:=TImageGraph2TxtDocument.Create(nil);
    make_connections;
  end;
end;

procedure TForm1.menuOpenProjectClick(Sender: TObject);
begin
  if (not data.Changed) or (Application.MessageBox('Все несохраненные действия и история изменений будут потеряны. Продолжить?','Открыть проект',MB_YesNo)=IDYes) then
    if OpenDialog1.Execute then
      Load_Project(OpenDialog1.FileName);
end;

procedure TForm1.menuSaveProjectClick(Sender: TObject);
begin
  if data.FileName='' then menuSaveProjectAsClick(Sender)
  else begin
    data.Save;
    refresh_undo_gui;
  end;
end;

procedure TForm1.menuSaveProjectAsClick(Sender: TObject);
begin
  if SaveTxt.Execute then begin
    data.FileName:=SaveTxt.FileName;
    data.Save;
    refresh_undo_gui;
  end;
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

procedure TForm1.menuUndoClick(Sender: TObject);
begin
  data.Undo;
end;

procedure TForm1.menuRedoClick(Sender: TObject);
begin
  data.redo;
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

//    state:=1;
//    StatusBar1.Panels[0].Text:='Вырезать прямоугольный участок';
  end;
end;

procedure TForm1.menuPasteClick(Sender: TObject);
var btmp: TBitmap;
begin
  btmp:=TBitmap.Create;
  btmp.Assign(Clipboard);
  data.DispatchCommand(TLoadImageCommand.New(btmp));
//  state:=1;
  StatusBar1.Panels[0].Text:='Вырезать прямоугольный участок';
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

procedure TForm1.btnNewClick(Sender: TObject);
begin
  menuNewProjectClick(Sender);
end;

procedure TForm1.btnSaveProjectClick(Sender: TObject);
begin
  menuSaveProjectClick(Sender);
end;

procedure TForm1.btnOpenProjectClick(Sender: TObject);
begin
  menuOpenProjectClick(Sender);
end;

procedure TForm1.btnSaveProjectAsClick(Sender: TObject);
begin
  menuSaveProjectAsClick(Sender);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
pic.Free;
data.Free;

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
  data.SaveToFile(CurProjectFileName);
end;

procedure TForm1.menuCropToolClick(Sender: TObject);
begin
  menuCropTool.Checked:=true;
  btnCropTool.Down:=true;
  if not (data.tool is TCropTool) then begin
    data.tool.Unselect;
    data.tool.Free;
    data.tool:=TCropTool.Create(data,menuCropTool.Name);
    data.tool.Select;
  end;
end;

procedure TForm1.menuAddAxesToolClick(Sender: TObject);
begin
  menuAddAxesTool.Checked:=true;
  btnAddAxesTool.Down:=true;
  if not (data.tool is TAddAxisTool) then begin
    data.tool.Unselect;
    data.tool.Free;
    data.tool:=TAddAxisTool.Create(data,menuAddAxesTool.Name);
    data.tool.Select;
  end;
end;

procedure TForm1.menuAddPointsToolClick(Sender: TObject);
begin
  menuAddPointsTool.Checked:=true;
  btnAddPointsTool.Down:=true;
  if not (data.tool is TAddPointTool) then begin
    data.tool.Unselect;
    data.tool.Free;
    data.tool:=TAddPointTool.Create(data,menuAddPointsTool.Name);
    data.tool.Select;
  end;
end;

procedure TForm1.btnCropToolClick(Sender: TObject);
begin
  menuCropTool.Click;
end;

procedure TForm1.btnAddAxesToolClick(Sender: TObject);
begin
  menuAddAxesTool.Click;
end;

procedure TForm1.btnPasteClick(Sender: TObject);
begin
  menuPaste.Click;
end;

procedure TForm1.btnZoomInClick(Sender: TObject);
begin
  menuZoomPlus.Click;
end;

procedure TForm1.btnZoomOutClick(Sender: TObject);
begin
  menuZoomMinus.Click;
end;


procedure TForm1.ProcessUndoMenu(Sender: TObject);
var i,j: Integer;
begin
(*
  j:=(Sender as TMenuItem).Tag;//номер выбранной команды в списке undo
  for i:=data.UndoList.current-1 downto j do data.Undo;
  *)
end;

procedure TForm1.ProcessRedoMenu(Sender: TObject);
var i,j: Integer;
begin
(*
  j:=(Sender as TMenuItem).Tag; //номер выбранной команды в списке undo
  for i:=data.UndoList.current to j do data.Redo;
  *)
end;

procedure TForm1.menuUndoListPopup(Sender: TObject);
var item: TMenuItem;
    i,j: Integer;
begin
  menuUndoList.Items.Clear;
  j:=0;
(*
  for i:=data.UndoList.current-1 downto 0 do begin
    item:=TMenuItem.Create(nil);
    item.Caption:=(data.UndoList.components[i] as TAbstractCommand).caption;
    item.Tag:=i;
    item.OnClick:=ProcessUndoMenu;

    menuUndoList.Items.Insert(j,item);
    inc(j);
  end;
  *)
end;

procedure TForm1.menuRedoListPopup(Sender: TObject);
var item: TMenuItem;
    i,j: Integer;
begin
  menuRedoList.Items.Clear;
  j:=0;
(*
  for i:=data.UndoList.current to data.UndoList.count-1 do begin
    item:=TMenuItem.Create(nil);
    item.Caption:=(data.UndoList.components[i] as TAbstractCommand).caption;
    item.Tag:=i;
    item.OnClick:=ProcessRedoMenu;

    menuRedoList.Items.Insert(j,item);
    inc(j);
  end;
  *)
end;

procedure TForm1.btnDataToClipbrdClick(Sender: TObject);
begin
  Clipboard.AsText:=data.coord.t.AsTabbedText;
end;

procedure TForm1.N3Click(Sender: TObject);
begin
  frmHistory.Show;
end;

end.

