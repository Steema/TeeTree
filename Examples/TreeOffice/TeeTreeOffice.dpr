program TeeTreeOffice;
{$I TeeDefs.inc}

uses
  Forms,
  TreeEd,
  UTreeOffice in 'UTreeOffice.pas' {TreeEditor1},
  TeeUpdateVersion in  'TeeUpdateVersion.pas',
  TreeOfficeConstants in 'TreeOfficeConstants.pas';

{$R *.res}

begin
  Application.Initialize;
  RegisterTeeTreeOffice;
  TrimWorkingSet;
  Application.HelpFile := 'TeeTreeOffice.hlp';
  Application.Title := 'TeeTree Office v2.0';
  Application.CreateForm(TTreeEditor1, TreeEditor1);
  Application.Run;
end.
