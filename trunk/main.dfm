object editor_form: Teditor_form
  Left = 0
  Top = 0
  ActiveControl = custom_pages
  Caption = 'editor_form'
  ClientHeight = 504
  ClientWidth = 218
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 194
    Top = 0
    Height = 504
    ResizeStyle = rsUpdate
    ExplicitLeft = 448
    ExplicitTop = 224
    ExplicitHeight = 100
  end
  object custom_pages: TPageControl
    Left = 0
    Top = 0
    Width = 194
    Height = 504
    ActivePage = TabSheet1
    Align = alLeft
    TabOrder = 0
    ExplicitTop = 17
    ExplicitHeight = 648
    object TabSheet1: TTabSheet
      Caption = 'Modes'
      ExplicitHeight = 620
      DesignSize = (
        186
        476)
      object mode_view: TSpeedButton
        Left = 0
        Top = 3
        Width = 73
        Height = 22
        GroupIndex = 1
        Down = True
        Caption = 'view move'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object xy_btn: TSpeedButton
        Left = 73
        Top = 3
        Width = 23
        Height = 22
        GroupIndex = 3
        Down = True
        Caption = 'XY'
      end
      object z_btn: TSpeedButton
        Left = 98
        Top = 3
        Width = 23
        Height = 22
        GroupIndex = 3
        Caption = 'Z'
      end
      object nodes_move: TSpeedButton
        Left = 88
        Top = 31
        Width = 41
        Height = 22
        GroupIndex = 2
        Caption = 'move'
      end
      object nodes_select: TSpeedButton
        Left = 43
        Top = 31
        Width = 44
        Height = 22
        GroupIndex = 2
        Down = True
        Caption = 'select'
      end
      object mode_nodes: TSpeedButton
        Left = 0
        Top = 31
        Width = 43
        Height = 22
        GroupIndex = 1
        Caption = 'nodes'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object XY_move: TSpeedButton
        Left = 88
        Top = 54
        Width = 24
        Height = 22
        GroupIndex = 4
        Down = True
        Caption = 'XY'
      end
      object XZ_move: TSpeedButton
        Left = 113
        Top = 54
        Width = 24
        Height = 22
        GroupIndex = 4
        Caption = 'XZ'
      end
      object ZY_move: TSpeedButton
        Left = 138
        Top = 54
        Width = 24
        Height = 22
        GroupIndex = 4
        Caption = 'ZY'
      end
      object mode_beams: TSpeedButton
        Left = 0
        Top = 104
        Width = 51
        Height = 22
        GroupIndex = 1
        Caption = 'beams'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        OnClick = mode_beamsClick
      end
      object movex_btn: TSpeedButton
        Left = 88
        Top = 76
        Width = 24
        Height = 22
        GroupIndex = 4
        Caption = 'X'
      end
      object movey_btn: TSpeedButton
        Left = 113
        Top = 76
        Width = 24
        Height = 22
        GroupIndex = 4
        Caption = 'Y'
      end
      object movez_btn: TSpeedButton
        Left = 138
        Top = 76
        Width = 24
        Height = 22
        GroupIndex = 4
        Caption = 'Z'
      end
      object SpeedButton5: TSpeedButton
        Left = 0
        Top = 54
        Width = 88
        Height = 22
        Caption = 'clone selected'
        Flat = True
        OnClick = SpeedButton5Click
      end
      object beams_select: TSpeedButton
        Left = 52
        Top = 104
        Width = 40
        Height = 22
        GroupIndex = 6
        Down = True
        Caption = 'select'
      end
      object SpeedButton7: TSpeedButton
        Left = 0
        Top = 127
        Width = 104
        Height = 22
        Caption = 'connect sel nodes'
        Flat = True
        OnClick = SpeedButton7Click
      end
      object Bevel1: TBevel
        Left = 0
        Top = 27
        Width = 186
        Height = 2
        Anchors = [akLeft, akTop, akRight]
      end
      object Bevel2: TBevel
        Left = 0
        Top = 100
        Width = 186
        Height = 2
        Anchors = [akLeft, akTop, akRight]
      end
      object beams_add: TSpeedButton
        Left = 92
        Top = 104
        Width = 34
        Height = 22
        GroupIndex = 6
        Caption = 'add'
        OnClick = beams_addClick
      end
      object nodes_add: TSpeedButton
        Left = 130
        Top = 31
        Width = 41
        Height = 22
        GroupIndex = 2
        Caption = 'add'
      end
      object del_nodes: TSpeedButton
        Left = 0
        Top = 76
        Width = 88
        Height = 22
        Caption = 'delete selected'
        Flat = True
        OnClick = del_nodesClick
      end
      object del_beams: TSpeedButton
        Left = 0
        Top = 149
        Width = 88
        Height = 22
        Caption = 'delete selected'
        Flat = True
        OnClick = del_beamsClick
      end
      object GroupBox1: TGroupBox
        Left = 3
        Top = 197
        Width = 159
        Height = 124
        Caption = 'Grid setup'
        TabOrder = 0
        object Label1: TLabel
          Left = 12
          Top = 53
          Width = 31
          Height = 13
          Caption = 'Label1'
        end
        object grid_size_tb: TTrackBar
          Left = 3
          Top = 19
          Width = 150
          Height = 30
          Max = 30
          Min = 1
          Position = 20
          TabOrder = 0
          OnChange = grid_size_tbChange
        end
        object Snaptogrid1: TCheckBox
          Left = 11
          Top = 79
          Width = 97
          Height = 17
          Caption = 'Snap to grid'
          TabOrder = 1
        end
        object Grid1: TCheckBox
          Left = 11
          Top = 98
          Width = 97
          Height = 17
          Caption = 'Show grid'
          TabOrder = 2
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'File info'
      ImageIndex = 1
      ExplicitHeight = 620
    end
  end
  object ApplicationEvents1: TApplicationEvents
    OnIdle = ApplicationEvents1Idle
    OnShortCut = ApplicationEvents1ShortCut
    Left = 40
    Top = 384
  end
  object od: TOpenDialog
    Filter = '*.truck|*.truck|All|*'
    Left = 8
    Top = 416
  end
  object sd: TSaveDialog
    Left = 40
    Top = 416
  end
  object MainMenu1: TMainMenu
    Left = 8
    Top = 384
    object File1: TMenuItem
      Caption = 'File'
      object Open1: TMenuItem
        Caption = 'Open'
        OnClick = Open1Click
      end
      object Save1: TMenuItem
        Caption = 'Save'
        OnClick = Save1Click
      end
      object SaveAs1: TMenuItem
        Caption = 'Save as'
        OnClick = SaveAs1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Clear1: TMenuItem
        Caption = 'Clear'
        OnClick = Clear1Click
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object View1: TMenuItem
      Caption = 'View'
      object Axis1: TMenuItem
        Caption = 'Show axis'
        OnClick = Axis1Click
      end
      object Gridsize1: TMenuItem
        Caption = 'Grid size'
        object N10x101: TMenuItem
          Caption = '10x10'
          GroupIndex = 1
          RadioItem = True
          OnClick = N10x101Click
        end
        object N50x501: TMenuItem
          Caption = '50x50'
          GroupIndex = 1
          RadioItem = True
          OnClick = N50x501Click
        end
        object N100x1001: TMenuItem
          Caption = '100x100'
          GroupIndex = 1
          RadioItem = True
          OnClick = N100x1001Click
        end
        object N500x5001: TMenuItem
          Caption = '500x500'
          Checked = True
          GroupIndex = 1
          RadioItem = True
          OnClick = N500x5001Click
        end
        object N1000x10001: TMenuItem
          Caption = '1000x1000'
          GroupIndex = 1
          RadioItem = True
          OnClick = N1000x10001Click
        end
      end
      object Shownodes1: TMenuItem
        Caption = 'Show nodes'
        Checked = True
        OnClick = Shownodes1Click
      end
      object Showbeams1: TMenuItem
        Caption = 'Show all beams'
        Checked = True
        OnClick = Showbeams1Click
      end
      object Nodesnum1: TMenuItem
        Caption = 'Nodes num'
        Checked = True
        OnClick = Nodesnum1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Addview1: TMenuItem
        Caption = 'Add view'
        object Free1: TMenuItem
          Caption = 'Free'
          OnClick = Free1Click
        end
        object Left2: TMenuItem
          Caption = 'Left'
          OnClick = Left2Click
        end
        object op2: TMenuItem
          Caption = 'Top'
          OnClick = op2Click
        end
        object Front2: TMenuItem
          Caption = 'Front'
          OnClick = Front2Click
        end
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Resetviewa1: TMenuItem
        Caption = 'Reset views'
      end
      object Rotate1: TMenuItem
        Caption = 'Rotate'
        ShortCut = 16466
        OnClick = Rotate1Click
      end
    end
    object Edit1: TMenuItem
      Caption = 'Edit'
      object Autoselectnewnodes1: TMenuItem
        Caption = 'Autoselect new elements'
        OnClick = Autoselectnewnodes1Click
      end
    end
  end
  object rotate_timer: TTimer
    Enabled = False
    Interval = 40
    OnTimer = rotate_timerTimer
    Left = 72
    Top = 416
  end
end
