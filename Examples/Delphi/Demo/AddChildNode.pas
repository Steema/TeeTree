unit AddChildNode;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs;

type
  TAddChildrenForm = class(TBaseForm)
    ButtonAddBrother: TButton;
    ButtonAddRoot: TButton;
    ButtonAddChild: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Tree1SelectShape(Sender: TTreeNodeShape);
    procedure ButtonAddRootClick(Sender: TObject);
    procedure Tree1UnSelectShape(Sender: TTreeNodeShape);
    procedure ButtonAddChildClick(Sender: TObject);
    procedure ButtonAddBrotherClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AddChildrenForm: TAddChildrenForm;

implementation

{$R *.DFM}

procedure TAddChildrenForm.FormCreate(Sender: TObject);
var MyRoot : TTreeNodeShape;
begin
  inherited;

  // Add a "Root" node (without parent)

  MyRoot:=Tree1.Add('This is a Root node');

  // Add one children node to root:

  MyRoot.AddChild('This is a child node.');

  // Another way to add a child node:

  Tree1.Add('Another child node',MyRoot);

  // Recursive way:
  MyRoot.AddChild('Third child.').AddChild('Hello');


  // Expand root:
  MyRoot.Expanded:=True;
end;

procedure TAddChildrenForm.Tree1SelectShape(Sender: TTreeNodeShape);
begin
  inherited;
  ButtonAddChild.Enabled:=True;
  ButtonAddBrother.Enabled:=True;
end;

procedure TAddChildrenForm.ButtonAddRootClick(Sender: TObject);
begin
  // Add one root node:
  Tree1.AddRoot('Root num: '+IntToStr(Tree1.Roots.Count+1));

  // Select it:
  Tree1.Selected.Clear;
  Tree1.Roots.Last.Selected:=True;
end;

procedure TAddChildrenForm.Tree1UnSelectShape(Sender: TTreeNodeShape);
begin
  inherited;
  ButtonAddChild.Enabled:=False;
  ButtonAddBrother.Enabled:=False;
end;

procedure TAddChildrenForm.ButtonAddChildClick(Sender: TObject);
var Node : TTreeNodeShape;
begin
  inherited;

  // Add one child node and select it.
  // Expand this node to show its children.
  with Tree1.Selected.First do
  begin
    Node:=AddChild('Child num: '+IntToStr(Count+1));
    Expanded:=True;
  end;

  Tree1.Selected.Clear;

  Node.Selected:=True;
end;

procedure TAddChildrenForm.ButtonAddBrotherClick(Sender: TObject);
var Node : TTreeNodeShape;
begin
  inherited;

  // Add one brother node and select it.
  // Expand the node parent to show its children.
  with Tree1.Selected.First do
  if Assigned(Parent) then
  begin
    Node:=AddBrother('Child num: '+IntToStr(Parent.Count+1));
    Expanded:=True;
  end
  else // node has no parent:
    Node:=Tree1.AddRoot('Root num: '+IntToStr(Tree1.Roots.Count+1));

  Tree1.Selected.Clear;

  Node.Selected:=True;
end;

initialization
  RegisterClass(TAddChildrenForm);
end.
