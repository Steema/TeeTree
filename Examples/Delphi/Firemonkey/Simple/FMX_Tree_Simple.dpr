program FMX_Tree_Simple;

uses
  FMX.Types,
  FMX.Forms,
  Unit_FMX_Tree in 'Unit_FMX_Tree.pas' {FireMonkey_TeeTree_Form},
  Unit_FMX_Tree_Columns in 'Unit_FMX_Tree_Columns.pas' {TreeColumns},
  FMXTee.Tree.Grid in 'FMXTee.Tree.Grid.pas';

{$R *.res}

begin
  //ReportMemoryLeaksOnShutdown:=True;

  Application.Initialize;
  Application.CreateForm(TFireMonkey_TeeTree_Form, FireMonkey_TeeTree_Form);
  Application.Run;
end.
