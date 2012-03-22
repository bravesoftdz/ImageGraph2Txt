object Form1: TForm1
  Left = 323
  Top = 248
  Width = 579
  Height = 257
  Caption = 'graph2txt v. 0.04'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    571
    223)
  PixelsPerInch = 96
  TextHeight = 13
  object ScrollBox1: TScrollBox
    Left = 8
    Top = 8
    Width = 558
    Height = 46
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    DesignSize = (
      554
      42)
    object Image1: TImage
      Left = 0
      Top = 0
      Width = 558
      Height = 46
      Cursor = crCross
      Anchors = [akLeft, akTop, akRight, akBottom]
      OnMouseDown = Image1MouseDown
      OnMouseMove = Image1MouseMove
      OnMouseUp = Image1MouseUp
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 61
    Width = 565
    Height = 137
    ActivePage = TabSheet1
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1103
      OnEnter = TabSheet1Enter
      DesignSize = (
        557
        109)
      object lblPage1: TLabel
        Left = 376
        Top = 8
        Width = 345
        Height = 97
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -24
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Button1: TButton
        Left = 0
        Top = 4
        Width = 113
        Height = 25
        Caption = #1048#1079' '#1092#1072#1081#1083#1072
        TabOrder = 0
        OnClick = Button1Click
      end
      object btn_clipboard: TButton
        Left = 0
        Top = 36
        Width = 113
        Height = 25
        Caption = #1048#1079' '#1073#1091#1092#1077#1088#1072' '#1086#1073#1084#1077#1085#1072
        Enabled = False
        TabOrder = 1
        OnClick = btn_clipboardClick
      end
      object CheckBox1: TCheckBox
        Left = 128
        Top = 12
        Width = 121
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = #1059#1084#1077#1089#1090#1080#1090#1100' '#1074' '#1101#1082#1088#1072#1085
        TabOrder = 2
        Visible = False
        OnClick = CheckBox1Click
      end
      object btnCrop: TButton
        Left = 128
        Top = 36
        Width = 113
        Height = 25
        Caption = #1054#1073#1088#1077#1079#1072#1090#1100
        Enabled = False
        TabOrder = 3
        OnClick = btnCropClick
      end
      object btnSaveBmp: TButton
        Left = 256
        Top = 36
        Width = 113
        Height = 25
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1082#1072#1082
        TabOrder = 4
        OnClick = btnSaveBmpClick
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1042#1099#1073#1086#1088' '#1082#1086#1086#1088#1076#1080#1085#1072#1090
      ImageIndex = 1
      OnEnter = TabSheet2Enter
      object lblPage2: TLabel
        Left = 392
        Top = 8
        Width = 305
        Height = 97
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -24
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object Button4: TSpeedButton
        Left = 0
        Top = 8
        Width = 89
        Height = 25
        GroupIndex = 1
        Caption = #1054#1090#1084#1077#1090#1080#1090#1100' '#1086#1089#1080
        OnClick = Button4Click
      end
      object SpeedButton1: TSpeedButton
        Left = 0
        Top = 40
        Width = 89
        Height = 25
        GroupIndex = 1
        Visible = False
      end
      object txtX0: TLabeledEdit
        Left = 184
        Top = 8
        Width = 65
        Height = 21
        EditLabel.Width = 78
        EditLabel.Height = 13
        EditLabel.Caption = 'X '#1085#1072#1095#1072#1083#1072' '#1082#1086#1086#1088#1076
        LabelPosition = lpLeft
        TabOrder = 0
        Text = '0'
        OnChange = txtX0Change
      end
      object txtY0: TLabeledEdit
        Left = 184
        Top = 32
        Width = 65
        Height = 21
        EditLabel.Width = 78
        EditLabel.Height = 13
        EditLabel.Caption = 'Y '#1085#1072#1095#1072#1083#1072' '#1082#1086#1086#1088#1076
        LabelPosition = lpLeft
        TabOrder = 1
        Text = '0'
        OnChange = txtY0Change
      end
      object txtXmax: TLabeledEdit
        Left = 184
        Top = 56
        Width = 65
        Height = 21
        EditLabel.Width = 74
        EditLabel.Height = 13
        EditLabel.Caption = 'X '#1090#1086#1095#1082#1080' '#1085#1072' '#1086#1089#1080
        LabelPosition = lpLeft
        TabOrder = 2
        Text = '10'
        OnChange = txtXmaxChange
      end
      object txtYmax: TLabeledEdit
        Left = 184
        Top = 80
        Width = 65
        Height = 21
        EditLabel.Width = 74
        EditLabel.Height = 13
        EditLabel.Caption = 'Y '#1090#1086#1095#1082#1080' '#1085#1072' '#1086#1089#1080
        LabelPosition = lpLeft
        TabOrder = 3
        Text = '10'
        OnChange = txtYmaxChange
      end
      object chkSwapXY: TCheckBox
        Left = 272
        Top = 36
        Width = 105
        Height = 17
        Caption = #1055#1086#1084#1077#1085#1103#1090#1100' X<->Y'
        TabOrder = 4
        OnClick = chkSwapXYClick
      end
      object chkXLog: TCheckBox
        Left = 272
        Top = 60
        Width = 73
        Height = 17
        Caption = #1051#1086#1075'. X'
        TabOrder = 5
        OnClick = chkXLogClick
      end
      object chkYLog: TCheckBox
        Left = 272
        Top = 84
        Width = 73
        Height = 17
        Caption = #1051#1086#1075'. Y'
        TabOrder = 6
        OnClick = chkYLogClick
      end
    end
    object TabSheet3: TTabSheet
      Caption = #1058#1088#1072#1089#1089#1080#1088#1086#1074#1082#1072' '#1075#1088#1072#1092#1080#1082#1072
      ImageIndex = 2
      OnEnter = TabSheet3Enter
      object Label2: TLabel
        Left = 0
        Top = 8
        Width = 56
        Height = 13
        Caption = #1094#1074#1077#1090' '#1083#1080#1085#1080#1080
      end
      object Label1: TLabel
        Left = 160
        Top = 8
        Width = 118
        Height = 13
        Caption = #1055#1086#1088#1103#1076#1086#1082' '#1080#1085#1090#1077#1088#1087#1086#1083#1103#1094#1080#1080
      end
      object Label3: TLabel
        Left = 392
        Top = 8
        Width = 50
        Height = 13
        Caption = #1054#1087#1080#1089#1072#1085#1080#1077
      end
      object ColorBox1: TColorBox
        Left = 64
        Top = 8
        Width = 89
        Height = 22
        Style = [cbStandardColors, cbExtendedColors, cbPrettyNames]
        ItemHeight = 16
        TabOrder = 0
        OnChange = ColorBox1Change
      end
      object Button2: TButton
        Left = 0
        Top = 68
        Width = 113
        Height = 25
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
        TabOrder = 1
        OnClick = Button2Click
      end
      object btnResetPoints: TButton
        Left = 0
        Top = 40
        Width = 113
        Height = 25
        Caption = #1054#1073#1085#1091#1083#1080#1090#1100
        TabOrder = 2
        OnClick = btnResetPointsClick
      end
      object ComboBox1: TComboBox
        Left = 280
        Top = 8
        Width = 105
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 2
        TabOrder = 3
        Text = '3'
        OnChange = ComboBox1Change
        Items.Strings = (
          '0'
          '1'
          '3')
      end
      object LabeledEdit1: TLabeledEdit
        Left = 280
        Top = 40
        Width = 89
        Height = 21
        EditLabel.Width = 96
        EditLabel.Height = 13
        EditLabel.Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1075#1088#1072#1092#1080#1082#1072
        LabelPosition = lpLeft
        TabOrder = 4
        OnChange = LabeledEdit1Change
      end
      object LabeledEdit2: TLabeledEdit
        Left = 280
        Top = 64
        Width = 89
        Height = 21
        EditLabel.Width = 75
        EditLabel.Height = 13
        EditLabel.Caption = #1055#1086#1076#1087#1080#1089#1100' '#1086#1089#1080' X'
        LabelPosition = lpLeft
        TabOrder = 5
        OnChange = LabeledEdit2Change
      end
      object LabeledEdit3: TLabeledEdit
        Left = 280
        Top = 88
        Width = 89
        Height = 21
        EditLabel.Width = 75
        EditLabel.Height = 13
        EditLabel.Caption = #1055#1086#1076#1087#1080#1089#1100' '#1086#1089#1080' Y'
        LabelPosition = lpLeft
        TabOrder = 6
        OnChange = LabeledEdit3Change
      end
      object Memo1: TMemo
        Left = 392
        Top = 32
        Width = 161
        Height = 73
        TabOrder = 7
        OnChange = Memo1Change
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 197
    Width = 571
    Height = 26
    Panels = <
      item
        Text = #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077' '#1085#1077' '#1074#1099#1073#1088#1072#1085#1086
        Width = 200
      end
      item
        Width = 50
      end>
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Left = 24
    Top = 440
  end
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 480
    Top = 656
  end
  object SaveTxt: TSaveDialog
    DefaultExt = 'txt'
    Filter = 'Text file|*.txt|Data file|*.dat|All files|*.*'
    Left = 520
    Top = 656
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'bmp'
    Filter = 'BMP file|*.bmp|All files|*.*'
    Left = 132
    Top = 118
  end
end
