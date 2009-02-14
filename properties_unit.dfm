object properties_form: Tproperties_form
  Left = 0
  Top = 0
  Caption = 'Advanced properties'
  ClientHeight = 376
  ClientWidth = 574
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 574
    Height = 376
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'File info'
      object Label1: TLabel
        Left = 5
        Top = 99
        Width = 53
        Height = 13
        Caption = 'Description'
      end
      object name_edit: TLabeledEdit
        Left = 5
        Top = 22
        Width = 121
        Height = 21
        EditLabel.Width = 55
        EditLabel.Height = 13
        EditLabel.Caption = 'Truck name'
        TabOrder = 0
      end
      object ffversion_edit: TLabeledEdit
        Left = 5
        Top = 68
        Width = 121
        Height = 21
        EditLabel.Width = 85
        EditLabel.Height = 13
        EditLabel.Caption = 'FileFormatVersion'
        TabOrder = 1
      end
      object desc_memo: TMemo
        Left = 5
        Top = 118
        Width = 300
        Height = 94
        ScrollBars = ssBoth
        TabOrder = 2
      end
      object help_edit: TLabeledEdit
        Left = 144
        Top = 22
        Width = 161
        Height = 21
        EditLabel.Width = 38
        EditLabel.Height = 13
        EditLabel.Caption = 'Help file'
        TabOrder = 3
      end
      object LabeledEdit1: TLabeledEdit
        Left = 5
        Top = 248
        Width = 121
        Height = 21
        EditLabel.Width = 44
        EditLabel.Height = 13
        EditLabel.Caption = 'Dry mass'
        TabOrder = 4
      end
      object LabeledEdit2: TLabeledEdit
        Left = 132
        Top = 248
        Width = 121
        Height = 21
        EditLabel.Width = 56
        EditLabel.Height = 13
        EditLabel.Caption = 'Cargo mass'
        TabOrder = 5
      end
      object LabeledEdit3: TLabeledEdit
        Left = 5
        Top = 290
        Width = 248
        Height = 21
        EditLabel.Width = 38
        EditLabel.Height = 13
        EditLabel.Caption = 'Material'
        TabOrder = 6
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
    end
  end
end
