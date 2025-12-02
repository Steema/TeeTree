unit DBTreeWizard;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  BaseDB, StdCtrls, Db, DBTables, TeeProcs, TeeTree, TeeDBTre, ExtCtrls;

type
  TDBTreeWizardForm = class(TBaseDBForm)
    Table1: TTable;
    CheckBox1: TCheckBox;
    Button1: TButton;
    procedure CheckBox1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

uses TreeDBEd;  // <--- Database Tree Wizard dialog 

procedure TDBTreeWizardForm.CheckBox1Click(Sender: TObject);
begin
  Table1.Active:=CheckBox1.Checked;

  DBTree1.Clear;
  DBTree1.Refresh;
end;

procedure TDBTreeWizardForm.Button1Click(Sender: TObject);
begin
  ShowDBTreeEditor(Self,DBTree1);
end;

initialization
  RegisterClass(TDBTreeWizardForm);
end.
