unit NodeDrawOrder;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, StdCtrls, TeeTree, TreeEd, ExtCtrls, TeeProcs;

type
  TNodeDrawOrderForm = class(TBaseForm)
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeShape3: TTreeNodeShape;
    TreeNodeShape4: TTreeNodeShape;
    TreeNodeShape5: TTreeNodeShape;
    BToFront: TButton;
    BToBack: TButton;
    BOneUp: TButton;
    BOneDown: TButton;
    procedure Tree1UnSelectShape(Sender: TTreeNodeShape);
    procedure Tree1SelectShape(Sender: TTreeNodeShape);
    procedure BToFrontClick(Sender: TObject);
    procedure BToBackClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BOneUpClick(Sender: TObject);
    procedure BOneDownClick(Sender: TObject);
  private
    { Private declarations }
    Procedure EnableButtons;
    Procedure MoveUpDown(ANode:TTreeNodeShape; Delta:Integer);
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TNodeDrawOrderForm.Tree1UnSelectShape(Sender: TTreeNodeShape);
begin
  BToFront.Enabled:=False;
  BToBack.Enabled:=False;
  BOneUp.Enabled:=False;
  BOneDown.Enabled:=False;
end;

Procedure TNodeDrawOrderForm.EnableButtons;
var NodeOrder : Integer;
begin
  // Enable / Disable buttons
  NodeOrder:=Tree1.Shapes.IndexOf(Tree1.Selected.First);

  BToFront.Enabled:=NodeOrder < Tree1.Shapes.Count-1;
  BToBack.Enabled:=NodeOrder > 0;

  BOneUp.Enabled:=BToFront.Enabled;
  BOneDown.Enabled:=BToBack.Enabled;
end;

procedure TNodeDrawOrderForm.Tree1SelectShape(Sender: TTreeNodeShape);
begin
  EnableButtons;
end;

procedure TNodeDrawOrderForm.BToFrontClick(Sender: TObject);
begin
  // Move first selected node to front...

  Tree1.Selected.First.BringToFront;

  EnableButtons;
end;

procedure TNodeDrawOrderForm.BToBackClick(Sender: TObject);
begin
  // Move first selected node to back...

  Tree1.Selected.First.SendToBack;

  EnableButtons;
end;

procedure TNodeDrawOrderForm.FormCreate(Sender: TObject);
begin
  inherited;

  // When selecting a node, do not fill the node interior...
  Tree1.Selected.ColorUnFocused:=clNone;
  Tree1.Selected.Color:=clNone;
end;

// Moves one node Up or Down the specified "Delta" items.
// When Delta is bigger than zero, it moves the node Up.
// When Delta is lower than zero, it moves the node Down.

type TNodeListAccess=class(TNodeShapeList);

Procedure TNodeDrawOrderForm.MoveUpDown(ANode:TTreeNodeShape; Delta:Integer);

  Procedure DoMoveUpDown(AList:TNodeShapeList);
  var NodeOrder : Integer;
  begin
    NodeOrder:=AList.IndexOf(ANode);
    if ((Delta<0) and (NodeOrder>0)) or
       ((Delta>0) and (NodeOrder<AList.Count-1)) then
         TNodeListAccess(AList).Exchange(NodeOrder,NodeOrder+Delta);
  end;

begin
  if Assigned(ANode.Parent) then DoMoveUpDown(ANode.Parent.Children)
                            else DoMoveUpDown(ANode.Tree.Roots);

  DoMoveUpDown(ANode.Tree.Shapes);
  ANode.Tree.Invalidate;
  EnableButtons;
end;

procedure TNodeDrawOrderForm.BOneUpClick(Sender: TObject);
begin
  MoveUpDown(Tree1.Selected.First,+1); // Move selected node Up one
end;

procedure TNodeDrawOrderForm.BOneDownClick(Sender: TObject);
begin
  MoveUpDown(Tree1.Selected.First,-1); // Move selected node Down one
end;

initialization
  RegisterClass(TNodeDrawOrderForm);
end.
