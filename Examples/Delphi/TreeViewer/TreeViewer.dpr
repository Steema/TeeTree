program TreeViewer;
{$I TeeDefs.inc}

uses
  Forms,
  UTreeViewer in 'UTreeViewer.pas' {Viewer},
  TreeNavigator in '..\TreeNavigator.pas';

{$R *.res}

begin
  Application.Title := 'TeeTree v2 Viewer';
  Application.CreateForm(TViewer, Viewer);
  Application.Run;
end.
