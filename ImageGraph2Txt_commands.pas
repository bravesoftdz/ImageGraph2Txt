unit ImageGraph2Txt_commands;

interface

uses command_class_lib,coord_system_lib,sysUtils,table_func_lib,classes,graphics,pngimage,streaming_class_lib;

type
  TChangeBoolFunc=procedure(var adr: Boolean) of object;

  TAddPointCommand=class(THashedCommand)
  private
    _x,_y: Real; //точка, которую мы и хотели добавить
    fxprev,fyprev: Real; //точка, которую мы затерли, добавляя свою
    fPointExisted: Boolean; //а была ли точка?
    procedure ReadPoint(reader: TReader);
    procedure WritePoint(writer: TWriter);
    procedure ReadLastPoint(reader: TReader);
    procedure WriteLastPoint(writer: TWriter);
  protected
    procedure DefineProperties(filer: TFiler); override;
  public
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(X,Y: Real); reintroduce; overload;
    function Execute: boolean; override;
    function Undo: boolean; override;
    function caption: string; override;
  end;

  TLoadPointsCommand=class(TAbstractCommand)
  private
    fbackup: table_func;
  public
    constructor Create(owner: TComponent); overload; override;
    constructor New(table: table_func); reintroduce; overload;
    destructor Destroy; override;
    function Execute: boolean; override;
    function Undo: boolean; override;
    function Caption: string; override;
  published
    property backup: table_func read fbackup write fbackup;
  end;

  TClearPointsCommand=class(TLoadPointsCommand)
  public
    constructor Create(owner: TComponent); overload; override;
    constructor Create; reintroduce; overload;
    function Caption: string; override;
  end;

  TLoadImageCommand=class(TAbstractCommand) //загрузка изображения взамен существующего
  private
    fbackup: TPngObject;
  public
    constructor Create(owner: TComponent); overload; override;
    constructor New(btmp: TBitmap); reintroduce; overload;
    destructor Destroy; override;
    function Execute: boolean; override;
    function Undo: boolean; override;
    function Caption: string; override;
    function EqualsByAnyOtherName(what: TStreamingClass):boolean; override;
  published
    property backup: TPngObject read fbackup write fbackup;
  end;

  TCropImageCommand=class(TAbstractCommand)
  private
    fLeft,fRight,fTop,fBottom: Integer;
    fBackupLeft: TPngObject;
    fBackUpRight: TPngObject;
    fBackUpTop: TPngObject;
    fBackUpBottom: TPngObject;
    fdone: Boolean;
  public
    constructor Create(owner: TComponent); overload; override;
    constructor Create(Left,Top,Right,Bottom: Integer); reintroduce; overload;
    destructor Destroy; override;
    function Execute: boolean; override;
    function Undo: boolean; override;
    function Caption: string; override;
  published
    property Left: Integer read fLeft write fLeft;
    property Right: Integer read fRight write fRight;
    property Top: Integer read fTop write fTop;
    property Bottom: Integer read fBottom write fBottom;
    property Done: Boolean read fdone write fdone;
    property BackUpLeft: TPngObject read fBackUpLeft write fBackUpLeft;
    property BackUpRight: TPngObject read fBackUpRight write fBackUpRight;
    property BackUpTop: TPngObject read fBackUpTop write fBackUpTop;
    property BackUpBottom: TPngObject read fBackUpBottom write fBackUpBottom;
  end;

  TSetZeroCommand=class(TAbstractCommand)
  private
    fx,fy: Integer;
    fbackupx,fbackupy: Integer;
    fbackupZeroPicked: Boolean;
    fdone: Boolean;
  public
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(x0,y0: Integer); reintroduce; overload;

    function Execute: boolean; override;
    function Undo: boolean; override;
    function Caption: string; override;
  published
    property x: Integer read fx write fx;
    property y: Integer read fy write fy;
    property backupZeroPicked: Boolean read fbackupZeroPicked write fBackupZeroPicked;
    property backupx: Integer read fbackupx write fbackupy stored fBackupZeroPicked;
    property backupy: Integer read fbackupy write fbackupy stored fBackupZeroPicked;
    property done: Boolean read fdone write fdone;
  end;

  TSetAxisCommand=class(TAbstractCommand)
  private
    fXY,fPickedBackup: Boolean;
    fx,fy,fbackup: Integer;
    fdone: Boolean;
  public
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(x,y: Integer); reintroduce; overload;

    function Execute: boolean; override;
    function Undo: boolean; override;
    function Caption: string; override;
  published
    property XY: boolean read fXY write fXY;
    property X: Integer read fx write fx;
    property Y: Integer read fy write fy;
    property PickedBackup: Boolean read fPickedBackup write fPickedBackup;
    property backup: Integer read fbackup write fbackup stored fPickedBackup;
    property done: Boolean read fdone write fdone;
  end;



implementation

uses imagegraph2txt_data,types;
(*
                  AddPoint
                                        *)
constructor TAddPointCommand.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fImageIndex:=11;
  fPointExisted:=false;
end;

constructor TAddPointCommand.Create(X,Y: Real);
begin
  Create(nil);
  _x:=X;
  _y:=Y;
end;

function TAddPointCommand.Execute: boolean;
var data: TImageGraph2TxtDocument;
begin
  data:=FindOwner as TImageGraph2TxtDocument;
  if data.coord.raw_data.FindPoint(_x,fXPrev,fYPrev) then
    fPointExisted:=true;
  Result:=(data.coord.addpoint(_x,_y)) and (inherited Execute);
end;

function TAddPointCommand.Undo: boolean;
begin
  Result:=(FindOwner as TImageGraph2TxtDocument).coord.deletepoint(_x);
  if Result and fPointExisted then
    (FindOwner as TImageGraph2TxtDocument).coord.AddPoint(fXPrev,fYPrev);
  Result:=Result and (inherited Undo);
end;

function TAddPointCommand.caption: string;
begin
  Result:='Добавить ('+IntToStr(Round(_x))+';'+IntToStr(Round(_y))+')';
end;

procedure TAddPointCommand.DefineProperties(filer: TFiler);
begin
  inherited DefineProperties(filer);
  filer.DefineProperty('point',ReadPoint,WritePoint,true); //и снова не будем жадничать
  filer.DefineProperty('PrevPoint',ReadLastPoint,WriteLastPoint,fPointExisted);
end;

procedure TAddPointCommand.ReadPoint(reader: TReader);
begin
  reader.ReadListBegin;
  _x:=reader.ReadFloat;
  _y:=reader.ReadFloat;
  reader.ReadListEnd;
end;

procedure TAddPointCommand.ReadLastPoint(reader: TReader);
begin
  reader.ReadListBegin;
  fxprev:=reader.ReadFloat;
  fyprev:=reader.ReadFloat;
  reader.ReadListEnd;
  fPointExisted:=true;
end;

procedure TAddPointCommand.WritePoint(writer: TWriter);
begin
  writer.WriteListBegin;
  writer.writeFloat(_x);
  writer.writeFloat(_y);
  writer.WriteListEnd;
end;

procedure TAddPointCommand.WriteLastPoint(writer: TWriter);
begin
  writer.WriteListBegin;
  writer.WriteFloat(fxprev);
  writer.WriteFloat(fyprev);
  writer.WriteListEnd;
end;

(*
          TLoadPointsCommand
                                      *)
constructor TLoadPointsCommand.Create(owner: TCOmponent);
begin
  inherited Create(owner);
  fbackup:=table_func.Create(self);
  fImageIndex:=1;
end;

constructor TLoadPointsCommand.New(table: table_func);
begin
  Create(nil);
  fbackup.assign(table);
end;

destructor TLoadPointsCommand.Destroy;
begin
  fbackup.Free;
  inherited Destroy;
end;

function TLoadPointsCommand.Execute: boolean;
var coord: TCoord_System;
    temp: table_func;
begin
  coord:=(FindOwner as TImageGraph2TxtDocument).coord;
  temp:=table_func.Create(nil);
  temp.assign(coord.raw_data);
  coord.LoadDataPoints(fbackup);
  fbackup.assign(temp);
  Result:=true;
  temp.Free;
end;

function TLoadPointsCommand.Undo: boolean;
var coord: TCoord_System;
    temp: table_func;
begin
  coord:=(FindOwner as TImageGraph2TxtDocument).coord;
  temp:=table_func.Create(nil);
  temp.assign(coord.t);
  coord.raw_data.assign(fbackup);
  fbackup.assign(temp);
  Result:=true;
  temp.Free;
end;

function TLoadPointsCommand.Caption: string;
begin
  Result:='Загрузка точек данных';
end;


(*
            ClearPoints
                                      *)

constructor TClearPointsCommand.Create(owner: TComponent);
begin
  inherited Create(owner);
  fImageIndex:=14;
end;

constructor TClearPointsCommand.Create;
begin
  Create(nil);
end;

function TClearPointsCommand.Caption: string;
begin
  result:='Удаление точек данных';
end;

(*
          TLoadImageCommand
                                          *)
constructor TLoadImageCommand.Create(owner: TComponent);
begin
  inherited Create(owner);
  fbackup:=TPngObject.CreateBlank(color_RGB,8,0,0);
  fbackup.Filters:=[pfNone,pfSub,pfUp,pfAverage,pfPaeth];
  fImageIndex:=1;
end;

constructor TLoadImageCommand.New(btmp: TBitmap);
begin
  Create(nil);
  fbackup.Assign(btmp);
end;

destructor TLoadImageCommand.Destroy;
begin
  fbackup.Free;
  inherited Destroy;
end;

function TLoadImageCommand.Execute: Boolean;
var img: TPngObject;
    tmp: TPngObject;
begin
   (FindOwner as TImageGraph2TxtDocument).scaled:=false;
    img:=(FindOwner as TImagegraph2txtDocument).Btmp;
    tmp:=TPngObject.Create;
    tmp.Assign(img);
    img.Assign(fbackup);
    fbackup.Assign(tmp);
    tmp.Free;
    result:=true;
end;

function TLoadImageCommand.Undo: Boolean;
var img,tmp: TPngObject;
begin
    (FindOwner as TImageGraph2TxtDocument).scaled:=false;
    img:=(FindOwner as TImagegraph2txtDocument).Btmp;
    tmp:=TPngObject.Create;
    tmp.Assign(img);
    img.Assign(fbackup);
    fbackup.Assign(tmp);
    tmp.Free;
    result:=true;
end;

function TLoadImageCommand.Caption: string;
begin
  Result:='Загрузить изображение';
end;

function TLoadImageCommand.EqualsByAnyOtherName(what: TStreamingClass): boolean;
var t: TPngObject;
    j: Integer;
begin
  Result:=false;
  if what is TLoadImageCommand then begin
    t:=TLoadImageCommand(what).fbackup;
    Result:=true;
    for j:=0 to fbackup.Height-1 do begin
      if not CompareMem(fbackup.Scanline[j],t.Scanline[j],fbackup.Width) then begin
        result:=false;
        break;
      end;
    end;
  end;

end;
(*
          TCropImageCommand
                                    *)

constructor TCropImageCommand.Create(owner: TComponent);
begin
  inherited Create(owner);
  fBackUpRight:=TPngObject.CreateBlank(color_RGB,8,0,0);
  fBackUpRight.Filters:=[pfNone,pfSub,pfUp,pfAverage,pfPaeth];
  fBackUpLeft:=TPngObject.CreateBlank(color_RGB,8,0,0);
  fBackUpLeft.Filters:=[pfNone,pfSub,pfUp,pfAverage,pfPaeth];
  fBackUpBottom:=TPngObject.CreateBlank(color_RGB,8,0,0);
  fBackUpBottom.Filters:=[pfNone,pfSub,pfUp,pfAverage,pfPaeth];
  fBackUpTop:=TPngObject.CreateBlank(color_RGB,8,0,0);
  fBackUpTop.Filters:=[pfNone,pfSub,pfUp,pfAverage,pfPaeth];
  fImageIndex:=9;
end;

constructor TCropImageCommand.Create(Left,Top,Right,Bottom: Integer);
begin
  Create(nil);
  fLeft:=Left;
  fRight:=Right;
  fTop:=Top;
  fBottom:=Bottom;
  done:=false;
end;

destructor TCropImageCommand.Destroy;
begin
  fBackUpLeft.Free;
  fBackUpRight.Free;
  fBackUpTop.Free;
  fBackUpBottom.Free;
  inherited Destroy;
end;

function TCropImageCommand.Caption: string;
begin
  Result:='Crop ('+IntToStr(Left)+';'+IntToStr(Top)+') to ('+IntToStr(Right)+';'+IntToStr(Bottom)+')';
end;

function TCropImageCommand.Execute: boolean;
var src,dest: TRect;
    img,tmp: TPngObject;
begin
  if done then result:=false
  else begin
    (FindOwner as TImageGraph2TxtDocument).scaled:=false;
    img:=(FindOwner as TImageGraph2TxtDocument).Btmp;

    //для начала ограничим границы обрезки размерами изображения
    if fLeft<0 then fLeft:=0;
    if fRight>img.Width then fRight:=img.Width-1;
    if fTop<0 then fTop:=0;
    if fBottom>img.Height then fBottom:=img.Height-1; 

    //бекапим верхушку
    fBackupTop.Resize(img.Width,fTop);
    src:=Rect(0,0,img.Width,fTop);
    fBackUpTop.Canvas.CopyRect(src,img.Canvas,src);
    //теперь левый край
    fBackUpLeft.Resize(fLeft,fBottom-fTop);
    src:=Rect(0,fTop,fLeft,fBottom);
    dest:=Rect(0,0,fLeft,fBackUpLeft.Height);
    fBackUpLeft.Canvas.CopyRect(dest,img.Canvas,src);
    //теперь правый край
    fBackUpRight.Resize(img.Width-fRight,fBottom-fTop);
    src:=Rect(fRight,fTop,img.Width,fBottom);
    dest:=Rect(0,0,fBackUpRight.Width,fBackUpRight.Height);
    fBackUpRight.Canvas.CopyRect(dest,img.Canvas,src);
    //и еще низ
    fBackUpBottom.Resize(img.Width,img.Height-fBottom);
    src:=Rect(0,fBottom,img.Width,img.Height);
    dest:=Rect(0,0,fBackUpBottom.Width,fBackUpBottom.Height);
    fBackUpBottom.Canvas.CopyRect(dest,img.Canvas,src);
    //и наконец, сама картинка
    tmp:=TPngObject.CreateBlank(color_RGB,8,fRight-fLeft,fBottom-fTop);
    src:=Rect(fLeft,fTop,fRight,fBottom);
    dest:=Rect(0,0,tmp.Width,tmp.Height);
    tmp.Canvas.CopyRect(dest,img.Canvas,src);
    img.Assign(tmp);
    tmp.Free;
    with (FindOwner as TImageGraph2TxtDocument).coord do begin
    //сдвигаем координатные оси
      pix_x0:=pix_x0-fLeft;
      pix_xmax:=pix_xmax-fLeft;
      pix_y0:=pix_y0-fTop;
      pix_ymax:=pix_ymax-fTop;
      //сдвинем точки данных
      raw_data.Add(-fTop);
      raw_data.Shift(-fLeft);
    end;



    done:=true;
    result:=true;
  end;

end;

function TCropImageCommand.Undo: boolean;
var tmp,img: TPngObject;
    src,dest: TRect;
begin
  if done then begin
    (FindOwner as TImageGraph2TxtDocument).scaled:=false;
    //инициализируем
    tmp:=TPngObject.CreateBlank(color_RGB,8,fBackUpTop.Width,fBackUpTop.Height+fBackUpLeft.Height+fBackUpBottom.Height);
    //приклеиваем верхушку
    src:=Rect(0,0,fBackUpTop.Width,fBackUpTop.Height);
    dest:=src;
    tmp.Canvas.CopyRect(dest,fBackUpTop.Canvas,src);
    fBackUpTop.CreateBlank(color_RGB,8,0,0);
    //теперь левый обрезок
    src:=Rect(0,0,fBackUpLeft.Width,fBackUpLeft.height);
    dest:=Rect(0,fTop,fLeft,fBottom);
    tmp.Canvas.CopyRect(dest,fBackUpLeft.Canvas,src);
    fBackUpLeft.CreateBlank(color_RGB,8,0,0);
    //возращаем на место центр
    img:=(FindOwner as TImageGraph2TxtDocument).Btmp;
    src:=Rect(0,0,img.Width,img.Height);
    dest:=Rect(fLeft,fTop,fRight,fBottom);
    tmp.Canvas.CopyRect(dest,img.Canvas,src);
    //правый обрезок
    src:=Rect(0,0,fBackUpRight.Width,fBackUpRight.Height);
    dest:=Rect(fRight,fTop,tmp.Width,fBottom);
    tmp.Canvas.CopyRect(dest,fBackUpRight.Canvas,src);
    fBackUpRight.CreateBlank(color_RGB,8,0,0);
    //нижний обрезок
    src:=Rect(0,0,fBackUpBottom.Width,fBackUpBottom.Height);
    dest:=Rect(0,fBottom,tmp.Width,tmp.Height);
    tmp.Canvas.CopyRect(dest,fBackUpBottom.Canvas,src);
    fBackUpBottom.CreateBlank(color_rgb,8,0,0);
    //запихиваем картину на место и удаляем временные переменные
    img.Assign(tmp);
    tmp.Free;
    with (FindOwner as TImageGraph2TxtDocument).coord do begin
    //возращаем на место координатные оси
      pix_x0:=pix_x0+fLeft;
      pix_xmax:=pix_xmax+fLeft;
      pix_y0:=pix_y0+fTop;
      pix_ymax:=pix_ymax+fTop;
    // возращаем на место точки данных
      raw_data.Add(fTop);
      raw_data.Shift(fLeft);
    end;
    done:=false;
    result:=true;
  end
  else result:=false;
end;

(*
            TSetZeroCommand
                                    *)
constructor TSetZeroCommand.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fImageIndex:=10;
end;

constructor TSetZeroCommand.Create(x0,y0: Integer);
begin
  Create(nil);
  fx:=x0;
  fy:=y0;
  done:=false;
end;

function TSetZeroCommand.Execute: Boolean;
var coord: TCoord_system;
begin
  if done then result:=false
  else begin
    coord:=(FindOwner as TImageGraph2TxtDocument).coord;
    if (coord.zero_picked) and (coord.pix_x0=fx) and (coord.pix_y0=fy) then result:=false
    else begin
      fbackupZeroPicked:=coord.zero_picked;
      fbackupx:=coord.pix_x0;
      fbackupy:=coord.pix_y0;
      coord.pix_x0:=fx;
      coord.pix_y0:=fy;
      coord.zero_picked:=true;
      done:=true;
      result:=true;
    end;
  end;
end;

function TSetZeroCommand.Undo: Boolean;
var coord: TCoord_System;
begin
  if done then begin
    coord:=(FindOwner as TImageGraph2TxtDocument).coord;
    coord.zero_picked:=fbackupZeroPicked;
    coord.pix_x0:=fbackupx;
    coord.pix_y0:=fbackupy;
    fBackUpZeroPicked:=false;
    fbackupx:=0;
    fbackupy:=0;
    done:=false;
    result:=true;
  end
  else result:=false;
end;

function TSetZeroCommand.Caption: string;
begin
  Result:='Set zero to ('+IntToStr(fx)+';'+IntToStr(fy)+')';
end;

(*
          TSetAxisCommand
                                      *)
constructor TSetAxisCommand.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fImageIndex:=10;
end;

constructor TSetAxisCommand.Create(x,y: Integer);
begin
  Create(nil);
  fx:=x;
  fy:=y;
  fdone:=false;
end;

function TSetAxisCommand.Execute: boolean;
var coord: TCoord_system;
begin
  if done then result:=false
  else begin
    coord:=(FindOwner as TImageGraph2Txtdocument).coord;
    if coord.zero_picked then begin
      if abs(fx-coord.pix_X0)>abs(fy-coord.pix_Y0) then begin
        fXY:=true;
        fPickedBackUp:=coord.xmax_picked;
        fBackup:=coord.pix_xmax;

        coord.pix_Xmax:=fX;
        coord.xmax_picked:=true;
        done:=true;
        result:=true;
      end
      else begin
        if fy=coord.pix_Y0 then result:=false
        else begin
          fXY:=false;
          fPickedBackUp:=coord.ymax_picked;
          fBackup:=coord.pix_ymax;

          coord.pix_ymax:=fy;
          coord.ymax_picked:=true;
          done:=true;
          result:=true;
        end;
      end;
    end
    else result:=false;
  end;
end;

function TSetAxisCommand.Undo: boolean;
var coord: TCoord_system;
begin
  if done then begin
    coord:=(FindOwner as TImageGraph2Txtdocument).coord;
    if fXY then begin
      coord.xmax_picked:=fPickedBackup;
      coord.pix_xmax:=fBackup;
    end
    else begin
      coord.ymax_picked:=fPickedBackup;
      coord.pix_ymax:=fBackUp;
    end;
    fPickedBackup:=false;
    fBackUp:=0;
    done:=false;
    result:=true;
  end
  else result:=false;
end;

function TSetAxisCommand.Caption: string;
begin
  Result:='Set axis point to ('+IntToStr(fx)+';'+IntToStr(fy)+')';
end;



initialization

RegisterClasses([TAddPointCommand,TClearPointsCommand,TLoadImageCommand,TCropImageCommand,TSetZeroCommand,TSetAxisCommand,TLoadPointsCommand]);

end.
