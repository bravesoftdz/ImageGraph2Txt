unit imagegraph2txt_data;

interface

uses command_class_lib,graphics,classes,coord_system_lib,pngimage,
streaming_class_lib,ImageGraph2Txt_tools,ComCtrls;

type

TImageGraph2TxtDocument=class(TAbstractDocument)
private
  fBtmp: TPngObject;
  fScaledBtmp: TPngObject;
  fCoord: TCoord_System;
  fscaled: Boolean;
  fscale: Real;
  procedure setBtmp(abtmp: TPngObject);
  procedure set_scaled(value: Boolean);
  procedure set_scale(value: Real);
  function get_scaled_btmp: TPngObject;
public
  StatusPanel: TStatusPanel;

  procedure SetSize(X,Y: Integer);
  constructor Create(owner: TComponent=nil); override;

  destructor Destroy; override;
  property Scaled: Boolean read fscaled write set_scaled;
  property ScaledBtmp: TPngObject read get_scaled_btmp;
  property scale: Real read fscale write set_scale;
published
  tool: TTool;
  property enableSaveWithUndo: Boolean read SaveWithUndo write SaveWithUndo;
  property SaveType: StreamingClassSaveFormat read SaveFormat write SaveFormat;
  property coord: TCoord_System read fCoord write fCoord;
  property Btmp: TPngObject read fBtmp write setBtmp;

end;

implementation

constructor TImageGraph2TxtDocument.Create(owner: TComponent);
begin
  inherited Create(owner);
  fBtmp:=TPngObject.CreateBlank(Color_RGB,8,0,0);
  fBtmp.Filters:=[pfNone,pfSub,pfUp,pfAverage,pfPaeth];
  fCoord:=TCoord_System.Create(self);
  fScaledBtmp:=TPngObject.CreateBlank(Color_RGB,8,0,0);
  fScale:=1;

  tool:=nil;
end;

destructor TImageGraph2TxtDocument.Destroy;
begin
  fBtmp.Free;
  fCoord.Free;
  fScaledBtmp.Free;
  inherited Destroy;
end;

procedure TImageGraph2TxtDocument.setBtmp(abtmp: TPngObject);
begin
  fBtmp.Assign(abtmp);
end;

procedure TImageGraph2TxtDocument.SetSize(X,Y: Integer);
begin
  if Scaled then begin
    if (Btmp.Height>0) and (Btmp.Width>0) then
      if X*Btmp.Height<Y*Btmp.Width then Scale:=X/btmp.Width
      else Scale:=Y/btmp.Height;
  end;
end;

function TImageGraph2TxtDocument.get_scaled_btmp: TPngObject;
begin
  if scaled then Result:=fScaledBtmp else Result:=fBtmp;
end;

procedure TImageGraph2TxtDocument.set_scaled(value: Boolean);
begin
  fscaled:=value;
  if not fscaled then begin
    fScaledBtmp.Resize(0,0);
    fscale:=1;
  end;
end;

procedure TImageGraph2TxtDocument.set_scale(value: Real);
var X,Y: Integer;
begin
  Scaled:=(value<>1);
  if Scaled then begin
    fScale:=value;
    X:=Round(btmp.Width*fscale);
    Y:=Round(btmp.Height*fscale);
    fScaledBtmp.Resize(X,Y);
    fScaledBtmp.Canvas.CopyRect(Rect(0,0,X,Y),Btmp.Canvas,Rect(0,0,Btmp.Width,Btmp.Height));
  end
  else

end;



end.
