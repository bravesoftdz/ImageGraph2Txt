program ImageGraph2txt;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  coord_system_lib in 'coord_system_lib.pas',
  GraphicEx in '..\GraphicEx\GraphicEx.pas',
  MZLib in '..\GraphicEx\MZLib.pas',
  GraphicColor in '..\GraphicEx\GraphicColor.pas',
  GraphicCompression in '..\GraphicEx\GraphicCompression.pas',
  GraphicStrings in '..\GraphicEx\GraphicStrings.pas',
  JPG in '..\GraphicEx\JPG.pas',
  table_func_lib in 'table_func_lib.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'image graph to text';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
