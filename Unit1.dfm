object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 679
  ClientWidth = 476
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
    Left = 32
    Top = 157
    Width = 52
    Height = 13
    Caption = 'Sender ID:'
  end
  object scaleLable: TLabel
    Left = 32
    Top = 242
    Width = 126
    Height = 13
    Caption = 'Rust user interface scale :'
  end
  object updateTokenLabel: TLabel
    Left = 32
    Top = 623
    Width = 152
    Height = 13
    Caption = 'Paste clan'#39's update token here:'
  end
  object selectFolderButton: TButton
    Left = 343
    Top = 23
    Width = 75
    Height = 25
    Caption = 'Select folder'
    TabOrder = 0
    OnClick = selectFolderButtonClick
  end
  object Memo1: TMemo
    Left = 32
    Top = 479
    Width = 392
    Height = 106
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object openFolderButton: TButton
    Left = 262
    Top = 23
    Width = 75
    Height = 26
    Caption = 'Open folder'
    TabOrder = 2
    OnClick = openFolderButtonClick
  end
  object storeImagesCheckbox: TCheckBox
    Left = 32
    Top = 31
    Width = 224
    Height = 17
    Caption = 'Save screenshot copy to selected folder '
    TabOrder = 3
    OnClick = storeImagesCheckboxClick
  end
  object launchRustOnStartupCheckbox: TCheckBox
    Left = 32
    Top = 63
    Width = 126
    Height = 17
    Caption = 'Run Rust on startup'
    TabOrder = 4
    OnClick = launchRustOnStartupCheckboxClick
  end
  object launchRustOnStartupAndConnectToServerCheckbox: TCheckBox
    Left = 32
    Top = 95
    Width = 209
    Height = 17
    Caption = 'Run Rust on startup and connect to :'
    TabOrder = 5
    OnClick = launchRustOnStartupAndConnectToServerCheckboxClick
  end
  object rustServerEdit: TEdit
    Left = 231
    Top = 93
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
    Left = 32
    Top = 126
    Width = 217
    Height = 17
    Caption = 'Close the application when closing Rust'
    TabOrder = 7
    OnClick = closeStashPicOnRustCloseCheckboxClick
  end
  object usiEdit: TEdit
    Left = 32
    Top = 176
    Width = 193
    Height = 21
    ReadOnly = True
    TabOrder = 8
    Text = 'usiEdit'
  end
  object regenerateButton: TButton
    Left = 32
    Top = 203
    Width = 81
    Height = 25
    Caption = 'Regenerate'
    TabOrder = 9
    OnClick = regenerateButtonClick
  end
  object copyToBufferButton: TButton
    Left = 119
    Top = 203
    Width = 106
    Height = 25
    Caption = 'Copy to clipboard'
    TabOrder = 10
    OnClick = copyToBufferButtonClick
  end
  object scaleBar: TTrackBar
    Left = 32
    Top = 261
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
    Left = 32
    Top = 312
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
  object autoUpdateCheckBox: TCheckBox
    Left = 32
    Top = 600
    Width = 113
    Height = 17
    Caption = 'Automatic update'
    TabOrder = 13
  end
  object updateTokenEdit: TEdit
    Left = 32
    Top = 642
    Width = 217
    Height = 21
    TabOrder = 14
    Text = 'updateTokenEdit'
    OnChange = updateTokenEditChange
  end
  object updateButton: TButton
    Left = 255
    Top = 646
    Width = 75
    Height = 25
    Caption = 'Update now'
    TabOrder = 15
    OnClick = updateButtonClick
  end
  object Timer1: TTimer
    Interval = 50
    OnTimer = Timer1Timer
    Left = 256
    Top = 120
  end
  object closeStashPicTimer: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = closeStashPicTimerTimer
    Left = 288
    Top = 120
  end
end
