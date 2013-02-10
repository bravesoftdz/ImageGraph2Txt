object frmPrefs: TfrmPrefs
  Left = 207
  Top = 113
  Width = 367
  Height = 180
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object rdSaveType: TRadioGroup
    Left = 8
    Top = 8
    Width = 345
    Height = 57
    Caption = #1060#1086#1088#1084#1072#1090' '#1092#1072#1081#1083#1072' '#1087#1088#1086#1077#1082#1090#1072
    ItemIndex = 2
    Items.Strings = (
      #1044#1074#1086#1080#1095#1085#1099#1081
      #1058#1077#1082#1089#1090#1086#1074#1099#1081', '#1079#1072#1084#1077#1085#1072' '#1082#1080#1088#1080#1083#1083#1080#1094#1099' '#1085#1072' '#1089#1087#1077#1094#1089#1080#1084#1074#1086#1083#1099' (#1040 '#1080' '#1090'.'#1076')'
      #1058#1077#1082#1089#1090#1086#1074#1099#1081', '#1089' '#1082#1080#1088#1080#1083#1083#1080#1094#1077#1081)
    TabOrder = 0
  end
  object chkSaveWithUndo: TCheckBox
    Left = 8
    Top = 72
    Width = 265
    Height = 17
    Caption = #1057#1086#1093#1088#1072#1085#1103#1090#1100' '#1080#1089#1090#1086#1088#1080#1102' '#1080#1079#1084#1077#1085#1080#1081' '#1074' '#1092#1072#1081#1083' '#1087#1088#1086#1077#1082#1090#1072
    Checked = True
    State = cbChecked
    TabOrder = 1
  end
  object BitBtn1: TBitBtn
    Left = 24
    Top = 112
    Width = 81
    Height = 25
    TabOrder = 2
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 264
    Top = 112
    Width = 81
    Height = 25
    TabOrder = 3
    Kind = bkCancel
  end
end
