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
  ImageGraph2Txt_commands in 'ImageGraph2Txt_commands.pas',
  command_class_lib in '..\lib\command_class_lib.pas',
  streaming_class_lib in '..\lib\streaming_class_lib.pas',
  imagegraph2txt_data in 'imagegraph2txt_data.pas',
  table_func_lib in '..\lib\table_func_lib.pas',
  StreamIO in '..\lib\StreamIO.pas',
  simple_parser_lib in '..\lib\simple_parser_lib.pas',
  pngextra in '..\pngimage\pngextra.pas',
  pngimage in '..\pngimage\pngimage.pas',
  pnglang in '..\pngimage\pnglang.pas',
  zlibpas in '..\pngimage\zlibpas.pas',
  FormPreferences in 'FormPreferences.pas' {frmPrefs},
  ImageGraph2Txt_tools in 'ImageGraph2Txt_tools.pas',
  family_of_curves_lib in '..\lib\family_of_curves_lib.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'image graph to text';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrmPrefs, frmPrefs);
  Application.Run;
end.
