object editHotkeyForm: TeditHotkeyForm
  Left = 0
  Top = 0
  Caption = 'Edit Hotkey'
  ClientHeight = 122
  ClientWidth = 387
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ctrlCheckBox: TCheckBox
    Left = 32
    Top = 32
    Width = 41
    Height = 17
    Caption = 'Ctrl'
    TabOrder = 0
  end
  object altCheckBox: TCheckBox
    Left = 96
    Top = 32
    Width = 41
    Height = 17
    Caption = 'Alt'
    TabOrder = 1
  end
  object shiftCheckBox: TCheckBox
    Left = 152
    Top = 32
    Width = 49
    Height = 17
    Caption = 'Shift'
    TabOrder = 2
  end
  object keyComboBox: TComboBox
    Left = 207
    Top = 30
    Width = 145
    Height = 21
    TabOrder = 3
    Text = 'keyComboBox'
  end
  object okButton: TButton
    Left = 32
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 4
    OnClick = okButtonClick
  end
  object cancelButton: TButton
    Left = 277
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 5
    OnClick = cancelButtonClick
  end
end
