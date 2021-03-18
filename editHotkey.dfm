object editHotkeyForm: TeditHotkeyForm
  Left = 0
  Top = 0
  Caption = 'Edit Hotkey'
  ClientHeight = 84
  ClientWidth = 338
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
    Left = 16
    Top = 10
    Width = 48
    Height = 17
    Caption = 'Ctrl'
    TabOrder = 0
  end
  object altCheckBox: TCheckBox
    Left = 70
    Top = 10
    Width = 48
    Height = 17
    Caption = 'Alt'
    TabOrder = 1
  end
  object shiftCheckBox: TCheckBox
    Left = 124
    Top = 10
    Width = 48
    Height = 17
    Caption = 'Shift'
    TabOrder = 2
  end
  object keyComboBox: TComboBox
    Left = 178
    Top = 8
    Width = 145
    Height = 21
    TabOrder = 3
    Text = 'keyComboBox'
  end
  object okButton: TButton
    Left = 16
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 4
    OnClick = okButtonClick
  end
  object cancelButton: TButton
    Left = 248
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 5
    OnClick = cancelButtonClick
  end
end
