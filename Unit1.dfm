object Form1: TForm1
  Left = 441
  Top = 152
  Width = 526
  Height = 322
  Caption = 'IDEA '#1063#1091#1081#1082#1086' '#1040'. '#1075#1088'. 451002'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 120
    Top = 8
    Width = 4
    Height = 16
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbl2: TLabel
    Left = 120
    Top = 48
    Width = 4
    Height = 16
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object btn1: TButton
    Left = 16
    Top = 240
    Width = 75
    Height = 25
    Caption = 'Run'
    TabOrder = 0
    OnClick = btn1Click
  end
  object mmo1: TMemo
    Left = 16
    Top = 136
    Width = 233
    Height = 89
    TabOrder = 1
  end
  object rb1: TRadioButton
    Left = 16
    Top = 104
    Width = 113
    Height = 17
    Caption = 'Encryption'
    TabOrder = 2
  end
  object rb2: TRadioButton
    Left = 152
    Top = 104
    Width = 113
    Height = 17
    Caption = 'Decryption'
    TabOrder = 3
  end
  object btn2: TButton
    Left = 16
    Top = 8
    Width = 89
    Height = 25
    Caption = 'Open Text File'
    TabOrder = 4
    OnClick = btn2Click
  end
  object btn3: TButton
    Left = 16
    Top = 48
    Width = 89
    Height = 25
    Caption = 'Open Key File'
    TabOrder = 5
    OnClick = btn3Click
  end
  object xpmnfst1: TXPManifest
    Left = 464
    Top = 40
  end
end
