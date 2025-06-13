program AsyncFutureTest;

uses
  Vcl.Forms,
  Main.View in 'Main.View.pas' {MainView},
  API.Helpers in 'API\API.Helpers.pas';

{$R *.res}

var
  MainView: TMainView;
begin
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
{$ENDIF}

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainView, MainView);
  Application.Run;
end.
