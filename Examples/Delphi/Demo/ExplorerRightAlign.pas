unit ExplorerRightAlign;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs, ComCtrls,
  TreeChildManagers;

type
  TExplorerRightAlignForm = class(TBaseForm)
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
    TreeNodeShape7: TTreeNodeShape;
    TreeNodeShape1_TreeNodeShape7: TTreeConnection;
    TreeNodeShape8: TTreeNodeShape;
    TreeNodeShape1_TreeNodeShape8: TTreeConnection;
    TreeNodeShape9: TTreeNodeShape;
    TreeNodeShape6_TreeNodeShape9: TTreeConnection;
    TreeNodeShape10: TTreeNodeShape;
    TreeNodeShape6_TreeNodeShape10: TTreeConnection;
    TreeNodeShape11: TTreeNodeShape;
    TreeNodeShape10_TreeNodeShape11: TTreeConnection;
    TreeNodeShape12: TTreeNodeShape;
    TreeNodeShape10_TreeNodeShape12: TTreeConnection;
    TreeNodeShape13: TTreeNodeShape;
    TreeNodeShape6_TreeNodeShape13: TTreeConnection;
    TreeNodeShape14: TTreeNodeShape;
    TreeNodeShape6_TreeNodeShape14: TTreeConnection;
    TreeNodeShape15: TTreeNodeShape;
    Label1: TLabel;
    Edit1: TEdit;
    UpDown1: TUpDown;
    Label2: TLabel;
    Edit2: TEdit;
    UpDown2: TUpDown;
    Label3: TLabel;
    Edit3: TEdit;
    UpDown3: TUpDown;
    procedure FormCreate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ExplorerAlign : TTreeExplorerAlignRight;
  end;

implementation

{$R *.DFM}

procedure TExplorerRightAlignForm.FormCreate(Sender: TObject);
var t : Integer;
begin
  inherited;

  // Replace default "manager" with a new one:
  ExplorerAlign:=TTreeExplorerAlignRight.Create;
  Tree1.ChangeManager(ExplorerAlign);

  // Change Image alignment to right:
  for t:=0 to Tree1.Shapes.Count-1 do
      Tree1[t].ImageAlignment:=TeeTree.iaRight;

  // Cosmetic
  Tree1.GlobalFormat.Border.Visible:=False;

  // Vertical Scrollbar, always hidden:
  Tree1.VertScrollBar.Automatic:=False;
  Tree1.VertScrollBar.Visible:=False;
end;

procedure TExplorerRightAlignForm.Edit1Change(Sender: TObject);
begin
  ExplorerAlign.HorizMargin:=UpDown1.Position;
  Tree1.Invalidate;
end;

procedure TExplorerRightAlignForm.Edit2Change(Sender: TObject);
begin
  ExplorerAlign.VertMargin:=UpDown2.Position;
  Tree1.Invalidate;
end;

procedure TExplorerRightAlignForm.Edit3Change(Sender: TObject);
begin
  ExplorerAlign.CrossMargin:=UpDown3.Position;
  Tree1.Invalidate;
end;

initialization
  RegisterClass(TExplorerRightAlignForm);
end.
