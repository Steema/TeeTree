unit TreeSelected;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs, TreeFlow;

type
  TTreeSelectedForm = class(TBaseForm)
    Label1: TLabel;
    Label2: TLabel;
    CheckBox1: TCheckBox;
    ManualOperationShape1: TManualOperationShape;
    SelectShape1: TSelectShape;
    PunchCardShape1: TPunchCardShape;
    DelayShape1: TDelayShape;
    procedure Tree1SelectShape(Sender: TTreeNodeShape);
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Tree1UnSelectShape(Sender: TTreeNodeShape);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TTreeSelectedForm.Tree1SelectShape(Sender: TTreeNodeShape);
begin
  Label2.Caption:=IntToStr(Tree1.Selected.Count);
end;

procedure TTreeSelectedForm.FormCreate(Sender: TObject);
begin
  inherited;
  // Permit multiple selection of nodes:
  Tree1.SingleSelection:=False;
end;

procedure TTreeSelectedForm.CheckBox1Click(Sender: TObject);
var t : Integer;
begin
  inherited;

  // Example: Use Selected list to change the nodes Transparent property.

  for t:=0 to Tree1.Selected.Count-1 do
      Tree1.Selected[t].Transparent:=CheckBox1.Checked;
end;

procedure TTreeSelectedForm.Tree1UnSelectShape(Sender: TTreeNodeShape);
begin
  Label2.Caption:=IntToStr(Tree1.Selected.Count);
end;

initialization
  RegisterClass(TTreeSelectedForm);
end.
