unit imagegraph2txt_document_class;

interface

uses command_class_lib,graphics,classes,coord_system_lib;

type

TImageGraph2TxtDocument=class(TAbstractDocument)
private
  fBtmp: TBitmap;
  fCoord: TCoord_System;
  procedure setBtmp(abtmp: TBitmap);
public
  constructor Create(owner: TComponent=nil); override;
  destructor Destroy; override;
published
  property coord: TCoord_System read fCoord write fCoord;
  property Btmp: TBitmap read fBtmp write setBtmp;
end;

implementation

constructor TImageGraph2TxtDocument.Create(owner: TComponent);
begin
  inherited Create(owner);
  fBtmp:=TBitmap.Create;
  fCoord:=TCoord_System.Create(nil);
end;

destructor TImageGraph2TxtDocument.Destroy;
begin
  fBtmp.Free;
  fCoord.Free;
  inherited Destroy;
end;

procedure TImageGraph2TxtDocument.setBtmp(abtmp: TBitmap);
begin
  fBtmp.Assign(abtmp);
end;

end.
