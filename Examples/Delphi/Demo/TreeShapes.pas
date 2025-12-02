unit TreeShapes;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, StdCtrls, TreeEd, ExtCtrls, TeeProcs;

type
  TTreeShapesForm = class(TBaseForm)
    CheckBox1: TCheckBox;
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeShape3: TTreeNodeShape;
    TreeNodeShape4: TTreeNodeShape;
    TreeNodeShape3_TreeNodeShape4: TTreeConnection;
    PolyLineShape1: TPolyLineShape;
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TTreeShapesForm.CheckBox1Click(Sender: TObject);
begin
  // Show or Hide all shapes:
  Tree1.Shapes.Visible:=CheckBox1.Checked;
end;

initialization
  RegisterClass(TTreeShapesForm);
end.
