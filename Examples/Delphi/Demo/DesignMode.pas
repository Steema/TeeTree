unit DesignMode;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, StdCtrls, TeeTree, TreeEd, ExtCtrls, TeeProcs, TreeFlow, TreeUML;

type
  TDesignModeForm = class(TBaseForm)
    CheckBox1: TCheckBox;
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    ActorShape1: TActorShape;
    EnvelopeShape1: TEnvelopeShape;
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TDesignModeForm.FormCreate(Sender: TObject);
begin
  inherited;
  Tree1.Designing:=True;

  Tree1.Roots[0].Selected:=True;
end;

procedure TDesignModeForm.CheckBox1Click(Sender: TObject);
begin
  Tree1.Designing:=CheckBox1.Checked;
end;

initialization
  RegisterClass(TDesignModeForm);
end.
