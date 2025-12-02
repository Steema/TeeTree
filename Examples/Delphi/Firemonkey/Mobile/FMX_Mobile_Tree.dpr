program FMX_Mobile_Tree;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit_FMX_Mobile_Tree in 'Unit_FMX_Mobile_Tree.pas' {TeeTree_Mobile_Form},
  Unit_FMX_Mobile_Tree_Settings in 'Unit_FMX_Mobile_Tree_Settings.pas' {SettingsForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TTeeTree_Mobile_Form, TeeTree_Mobile_Form);
  Application.CreateForm(TSettingsForm, SettingsForm);
  Application.Run;
end.
