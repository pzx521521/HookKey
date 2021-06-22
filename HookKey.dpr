program HookKey;

uses
  Forms,
  SysUtils,
  ufrmMain in 'ufrmMain.pas' {frmMain};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  if ParamCount = 2 then
    frmMain.tmrMain.Interval := StrToIntDef(ParamStr(1))*1000;
  Application.ShowMainForm := False;
  Application.Run;
end.
