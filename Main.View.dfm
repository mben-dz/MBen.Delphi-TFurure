object MainView: TMainView
  Left = 0
  Top = 0
  Margins.Left = 5
  Margins.Top = 5
  Margins.Right = 5
  Margins.Bottom = 5
  Caption = 'MainView'
  ClientHeight = 464
  ClientWidth = 683
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -30
  Font.Name = 'Bahnschrift SemiLight SemiConde'
  Font.Style = []
  Font.Quality = fqClearTypeNatural
  PixelsPerInch = 144
  DesignSize = (
    683
    464)
  TextHeight = 36
  object BtnWaitOutsideMainThread: TButton
    Left = 10
    Top = 30
    Width = 325
    Height = 80
    Cursor = crHandPoint
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = 'Wait Outside MainThread'
    TabOrder = 0
    OnClick = BtnWaitOutsideMainThreadClick
  end
  object BtnStartWithHelper: TButton
    Left = 10
    Top = 120
    Width = 325
    Height = 80
    Cursor = crHandPoint
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = 'Use Helper with Callback'
    TabOrder = 1
    OnClick = BtnStartWithHelperClick
  end
  object BtnWrongUse: TButton
    Left = 366
    Top = 30
    Width = 300
    Height = 80
    Cursor = crHandPoint
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = 'Wrong Use'
    TabOrder = 2
    OnClick = BtnWrongUseClick
  end
  object BtnMonitorSolution: TButton
    Left = 366
    Top = 120
    Width = 300
    Height = 80
    Cursor = crHandPoint
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = 'Monitor Solution'
    TabOrder = 3
    OnClick = BtnMonitorSolutionClick
  end
  object BtnSimulateIFuture: TButton
    Left = 10
    Top = 210
    Width = 656
    Height = 104
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = 'Simulate IFuture Scenario Work'
    TabOrder = 4
    OnClick = BtnSimulateIFutureClick
  end
  object MemoReply: TMemo
    Left = 0
    Top = 325
    Width = 683
    Height = 139
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alBottom
    Color = 3678237
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -24
    Font.Name = 'Bahnschrift SemiLight SemiConde'
    Font.Style = []
    Font.Quality = fqClearTypeNatural
    Lines.Strings = (
      'Future Reply goes Here:')
    ParentFont = False
    TabOrder = 5
    ExplicitTop = 324
  end
  object BtnClear: TButton
    Left = 570
    Top = 421
    Width = 113
    Height = 43
    Cursor = crHandPoint
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Anchors = [akRight, akBottom]
    Caption = 'Clear'
    TabOrder = 6
    OnClick = BtnClearClick
    ExplicitTop = 420
  end
end
