object Form1: TForm1
  Left = 192
  Top = 125
  Width = 872
  Height = 470
  Caption = 
    'Steema.com - Speed comparison between TeeTree and Borland TreeVi' +
    'ew'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 256
    Top = 10
    Width = 104
    Height = 16
    Caption = 'Steema TeeTree'
  end
  object Label2: TLabel
    Left = 571
    Top = 10
    Width = 108
    Height = 16
    Caption = 'Borland TreeView'
  end
  object Label5: TLabel
    Left = 158
    Top = 236
    Width = 7
    Height = 16
    Caption = '0'
  end
  object Label6: TLabel
    Left = 158
    Top = 266
    Width = 7
    Height = 16
    Caption = '0'
  end
  object TreeView1: TTreeView
    Left = 571
    Top = 30
    Width = 287
    Height = 395
    Indent = 19
    TabOrder = 0
  end
  object Button1: TButton
    Left = 20
    Top = 39
    Width = 188
    Height = 31
    Caption = '&Add 5000 nodes'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 20
    Top = 79
    Width = 188
    Height = 31
    Caption = 'A&dd 10000 nodes'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 20
    Top = 118
    Width = 188
    Height = 31
    Caption = 'Add 50000 &nodes'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 20
    Top = 167
    Width = 188
    Height = 31
    Caption = '&Clearing 10000 nodes'
    TabOrder = 4
    OnClick = Button4Click
  end
  object CheckBox1: TCheckBox
    Left = 20
    Top = 236
    Width = 119
    Height = 21
    Caption = 'TeeTree time:'
    Checked = True
    State = cbChecked
    TabOrder = 5
  end
  object CheckBox2: TCheckBox
    Left = 20
    Top = 266
    Width = 119
    Height = 21
    Caption = 'TreeView time:'
    Checked = True
    State = cbChecked
    TabOrder = 6
  end
  object Button5: TButton
    Left = 69
    Top = 325
    Width = 92
    Height = 31
    Caption = 'Close'
    TabOrder = 7
    OnClick = Button5Click
  end
  object Tree1: TTree
    Left = 256
    Top = 30
    Width = 287
    Height = 395
    AnimatedZoomSteps = 3
    Zoom.AnimatedSteps = 3
    Zoom.Pen.Mode = pmNotXor
    TabOrder = 8
  end
end
