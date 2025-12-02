unit RemoveNodes;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, StdCtrls, TreeEd, ExtCtrls, TeeProcs;

type
  TRemoveNodesForm = class(TBaseForm)
    Button1: TButton;
    Button2: TButton;
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeShape1_TreeNodeShape2: TTreeConnection;
    TreeNodeShape3: TTreeNodeShape;
    TreeNodeShape2_TreeNodeShape3: TTreeConnection;
    TreeNodeShape4: TTreeNodeShape;
    TreeNodeShape2_TreeNodeShape4: TTreeConnection;
    TreeNodeShape5: TTreeNodeShape;
    TreeNodeShape2_TreeNodeShape5: TTreeConnection;
    TreeNodeShape6: TTreeNodeShape;
    TreeNodeShape1_TreeNodeShape6: TTreeConnection;
    TreeNodeShape7: TTreeNodeShape;
    TreeNodeShape1_TreeNodeShape7: TTreeConnection;
    TreeNodeShape8: TTreeNodeShape;
    TreeNodeShape7_TreeNodeShape8: TTreeConnection;
    TreeNodeShape9: TTreeNodeShape;
    TreeNodeShape10: TTreeNodeShape;
    TreeNodeShape9_TreeNodeShape10: TTreeConnection;
    TreeNodeShape11: TTreeNodeShape;
    TreeNodeShape9_TreeNodeShape11: TTreeConnection;
    TreeNodeShape12: TTreeNodeShape;
    TreeNodeShape11_TreeNodeShape12: TTreeConnection;
    TreeNodeShape13: TTreeNodeShape;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Tree1SelectShape(Sender: TTreeNodeShape);
    procedure Tree1UnSelectShape(Sender: TTreeNodeShape);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TRemoveNodesForm.Button1Click(Sender: TObject);
begin
  Tree1.Selected.First.Free;  // Destroy node
end;

procedure TRemoveNodesForm.Button2Click(Sender: TObject);
begin
  Tree1.Selected.First.Parent:=nil;  // Remove from Parent
end;

procedure TRemoveNodesForm.Tree1SelectShape(Sender: TTreeNodeShape);
begin
  Button1.Enabled:=True;
  Button2.Enabled:=Assigned(Sender.Parent);
end;

procedure TRemoveNodesForm.Tree1UnSelectShape(Sender: TTreeNodeShape);
begin
  Button1.Enabled:=False;
  Button2.Enabled:=False;
end;

initialization
  RegisterClass(TRemoveNodesForm);
end.
