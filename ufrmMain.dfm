object frmMain: TfrmMain
  Left = 168
  Top = 35
  Caption = 'frmMain'
  ClientHeight = 322
  ClientWidth = 421
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 421
    Height = 322
    Align = alClient
    TabOrder = 0
    ExplicitTop = 1
    ExplicitWidth = 377
    ExplicitHeight = 313
  end
  object tmrMain: TTimer
    Interval = 10000
    OnTimer = tmrMainTimer
    Left = 192
    Top = 136
  end
end
