unit FormPreferences;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TfrmPrefs = class(TForm)
    rdSaveType: TRadioGroup;
    chkSaveWithUndo: TCheckBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrefs: TfrmPrefs;

implementation

{$R *.dfm}

end.
