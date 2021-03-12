object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 770
  ClientWidth = 483
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
  object usiLabel: TLabel
    Left = 40
    Top = 373
    Width = 52
    Height = 13
    Caption = 'Sender ID:'
  end
  object scaleLable: TLabel
    Left = 40
    Top = 458
    Width = 126
    Height = 13
    Caption = 'Rust user interface scale :'
  end
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
    Width = 392
    Height = 129
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object Button2: TButton
    Left = 121
    Top = 16
    Width = 75
    Height = 26
    Caption = 'Button 2'
    TabOrder = 2
  end
  object storeImagesCheckbox: TCheckBox
    Left = 40
    Top = 247
    Width = 97
    Height = 17
    Caption = 'Store images'
    TabOrder = 3
    OnClick = storeImagesCheckboxClick
  end
  object launchRustOnStartupCheckbox: TCheckBox
    Left = 40
    Top = 279
    Width = 126
    Height = 17
    Caption = 'Run Rust on startup'
    TabOrder = 4
    OnClick = launchRustOnStartupCheckboxClick
  end
  object launchRustOnStartupAndConnectToServerCheckbox: TCheckBox
    Left = 40
    Top = 311
    Width = 209
    Height = 17
    Caption = 'Run Rust on startup and connect to :'
    TabOrder = 5
    OnClick = launchRustOnStartupAndConnectToServerCheckboxClick
  end
  object rustServerEdit: TEdit
    Left = 239
    Top = 309
    Width = 193
    Height = 21
    Hint = 'Incorrect address1'
    Color = clWhite
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    TextHint = '255.255.255.255:65535'
    OnChange = rustServerEditChange
  end
  object closeStashPicOnRustCloseCheckbox: TCheckBox
    Left = 40
    Top = 342
    Width = 217
    Height = 17
    Caption = 'Close the application when closing Rust'
    TabOrder = 7
    OnClick = closeStashPicOnRustCloseCheckboxClick
  end
  object usiEdit: TEdit
    Left = 40
    Top = 392
    Width = 193
    Height = 21
    ReadOnly = True
    TabOrder = 8
    Text = 'usiEdit'
  end
  object regenerateButton: TButton
    Left = 40
    Top = 419
    Width = 81
    Height = 25
    Caption = 'Regenerate'
    TabOrder = 9
    OnClick = regenerateButtonClick
  end
  object copyToBufferButton: TButton
    Left = 127
    Top = 419
    Width = 106
    Height = 25
    Caption = 'Copy to clipboard'
    TabOrder = 10
    OnClick = copyToBufferButtonClick
  end
  object scaleBar: TTrackBar
    Left = 40
    Top = 477
    Width = 150
    Height = 45
    Max = 100
    Min = 50
    Position = 50
    TabOrder = 11
    TickMarks = tmBoth
    TickStyle = tsNone
    OnChange = scaleBarChange
  end
  object GroupBox1: TGroupBox
    Left = 40
    Top = 528
    Width = 392
    Height = 153
    Caption = 'Hotkeys'
    TabOrder = 12
    object Label1: TLabel
      Left = 9
      Top = 24
      Width = 88
      Height = 13
      Caption = 'Capture fullscreen'
    end
    object Label2: TLabel
      Left = 9
      Top = 56
      Width = 121
      Height = 13
      Caption = 'Capture center rectangle'
    end
    object Label3: TLabel
      Left = 9
      Top = 88
      Width = 93
      Height = 13
      Caption = 'Capture stash area'
    end
    object Label4: TLabel
      Left = 9
      Top = 120
      Width = 148
      Height = 13
      Caption = 'Capture fullscreen as map part'
    end
    object editHotkey1Button: TButton
      Left = 256
      Top = 17
      Width = 121
      Height = 25
      Caption = 'editHotkey1Button'
      TabOrder = 0
      OnClick = editHotkey1ButtonClick
    end
    object editHotkey2Button: TButton
      Left = 256
      Top = 48
      Width = 121
      Height = 25
      Caption = 'editHotkey2Button'
      TabOrder = 1
      OnClick = editHotkey2ButtonClick
    end
    object editHotkey3Button: TButton
      Left = 256
      Top = 79
      Width = 121
      Height = 25
      Caption = 'editHotkey3Button'
      TabOrder = 2
      OnClick = editHotkey3ButtonClick
    end
    object editHotkey4Button: TButton
      Left = 256
      Top = 110
      Width = 121
      Height = 25
      Caption = 'editHotkey4Button'
      TabOrder = 3
      OnClick = editHotkey4ButtonClick
    end
  end
  object Timer1: TTimer
    Interval = 50
    OnTimer = Timer1Timer
    Left = 296
    Top = 256
  end
  object closeStashPicTimer: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = closeStashPicTimerTimer
    Left = 376
    Top = 256
  end
end
