unit streaming_class_lib;

interface
uses Classes,sysutils;

type

TstreamingClass=class(TComponent)
  protected
    procedure   GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    function    GetChildOwner: TComponent; override;
    procedure   SetOwner( aComponent: TComponent );
  public
    constructor Create(owner: TComponent; _name: TComponentName); overload; virtual;
    constructor LoadFromFile(filename: string); virtual;  //неужели до меня дошло?
    procedure SaveToFile(filename: string);
    procedure SaveBinaryToFile(filename: string);
    procedure LoadBinaryFromFile(filename: string);
    function SaveToString: string;
    procedure LoadFromString(text: string);
    function CreateFromString(text: string): TComponent;
  end;

implementation

constructor TstreamingClass.Create(owner: TComponent;_name: TComponentName);
begin
  inherited Create(owner);
  name:=_name;
end;

procedure TstreamingClass.SetOwner(aComponent: TComponent);
begin
  if aComponent.Owner<>nil then
    aComponent.Owner.RemoveComponent( aComponent );
  InsertComponent( aComponent );
end;

function TstreamingClass.GetChildOwner: TComponent;
begin
  Result := self;
end;

procedure TstreamingClass.GetChildren(Proc: TGetChildProc; Root: TComponent);
var
  i : Integer;
begin
  inherited;
  for i := 0 to ComponentCount-1 do
    Proc( Components[i] );
end;

procedure TstreamingClass.SaveToFile(filename: string);
var
  BinStream: TMemoryStream;
  FileStream: TFileStream;
begin
  BinStream := TMemoryStream.Create;
  try
    FileStream := TFileStream.Create(filename,fmCreate);
    try
      BinStream.WriteComponent(Self);
      BinStream.Seek(0, soFromBeginning);
      ObjectBinaryToText(BinStream, FileStream);
    finally
      FileStream.Free;

    end;
  finally
    BinStream.Free
  end;

end;

function TstreamingClass.SaveToString: string;
var BinStream: TMemoryStream;
    StrStream: TStringStream;
    s: string;
begin
  BinStream:=TMemoryStream.Create;
  StrStream:=TStringStream.Create(s);
  BinStream.WriteComponent(Self);
  BinStream.Seek(0,soFromBeginning);
  ObjectBinaryToText(BinStream,StrStream);
  StrStream.Seek(0,soFromBeginning);
  SaveToString:=StrStream.DataString;
  StrStream.Free;
  BinStream.Free;
end;

constructor TstreamingClass.LoadFromFile(filename: string);
var
  FileStream: TFileStream;
  BinStream: TMemoryStream;
begin
  FileStream := TFileStream.Create(filename, fmOpenRead	);
  try
    BinStream := TMemoryStream.Create;
    try
      ObjectTextToBinary(FileStream, BinStream);
      BinStream.Seek(0, soFromBeginning);
      BinStream.ReadComponent(self);
    finally
      BinStream.Free;
    end;
  finally
    FileStream.Free;
  end;
end;

procedure TstreamingClass.LoadFromString(text: string);
var
  StrStream: TStringStream;
  BinStream: TMemoryStream;
begin
  BinStream:=TMemoryStream.Create;
  StrStream:=TStringStream.Create(text);
  ObjectTextToBinary(StrStream,BinStream);
  BinStream.Seek(0, soFromBeginning);
  BinStream.ReadComponent(Self);
  BinStream.Free;
  StrStream.Free;
end;

function TstreamingClass.CreateFromString(text: string): TComponent;
var
  StrStream: TStringStream;
  BinStream: TMemoryStream;
begin
  BinStream:=TMemoryStream.Create;
  StrStream:=TStringStream.Create(text);
  ObjectTextToBinary(StrStream,BinStream);
  BinStream.Seek(0, soFromBeginning);
  Result:=BinStream.ReadComponent(nil);
  BinStream.Free;
  StrStream.Free;
end;


procedure TstreamingClass.SaveBinaryToFile(filename: string);
var FileStream: TFileStream;
begin
  FileStream:=nil;
  try
  FileStream:=TFileStream.Create(filename,fmCreate);
  FileStream.WriteComponent(Self);
  finally
  FileStream.Free;
  end;
end;

procedure TstreamingClass.LoadBinaryFromFile(filename: string);
var FileStream: TFileStream;
begin
  try
  FileStream:=TFileStream.Create(filename,fmOpenRead);
  FileStream.Seek(0, soFromBeginning);
  FileStream.ReadComponent(self);
  finally
  FileStream.Free;
  end;
end;



end.
