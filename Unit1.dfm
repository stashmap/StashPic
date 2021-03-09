object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 616
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 40
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
  end
  object Memo1: TMemo
    Left = 40
    Top = 104
    Width = 505
    Height = 249
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object Button2: TButton
    Left = 40
    Top = 47
    Width = 265
    Height = 26
    Caption = 'Launch Rust and connect to Cobalt'
    TabOrder = 2
    OnClick = Button2Click
  end
  object storeImagesCheckbox: TCheckBox
    Left = 40
    Top = 359
    Width = 97
    Height = 17
    Caption = 'Store images'
    TabOrder = 3
    OnClick = storeImagesCheckboxClick
  end
  object launchRustOnStartupCheckbox: TCheckBox
    Left = 40
    Top = 391
    Width = 193
    Height = 17
    Caption = 'Run Rust on application startup'
    TabOrder = 4
    OnClick = launchRustOnStartupCheckboxClick
  end
  object launchRustOnStartupAndConnectToServerCheckbox: TCheckBox
    Left = 40
    Top = 423
    Width = 313
    Height = 17
    Caption = 'Run Rust on application startup and connect to the server :'
    TabOrder = 5
    OnClick = launchRustOnStartupAndConnectToServerCheckboxClick
  end
  object rustServerEdit: TEdit
    Left = 352
    Top = 421
    Width = 193
    Height = 21
    Hint = 'Incorrect address1'
    Color = clWhite
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    TextHint = '255.255.255.255:28015'
    OnChange = rustServerEditChange
  end
  object closeStashPicOnRustCloseCheckbox: TCheckBox
    Left = 40
    Top = 454
    Width = 217
    Height = 17
    Caption = 'Close the application when closing Rust'
    TabOrder = 7
    OnClick = closeStashPicOnRustCloseCheckboxClick
  end
  object Timer1: TTimer
    Interval = 50
    OnTimer = Timer1Timer
    Left = 176
    Top = 8
  end
  object closeStashPicTimer: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = closeStashPicTimerTimer
    Left = 448
    Top = 24
  end
end
