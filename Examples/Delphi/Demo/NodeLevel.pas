unit NodeLevel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, StdCtrls, TreeEd, ExtCtrls, TeeProcs;

type
  TNodeLevelForm = class(TBaseForm)
    Label1: TLabel;
    Label2: TLabel;
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeShape1_TreeNodeShape2: TTreeConnection;
    TreeNodeShape3: TTreeNodeShape;
    TreeNodeShape2_TreeNodeShape3: TTreeConnection;
    TreeNodeShape4: TTreeNodeShape;
    TreeNodeShape3_TreeNodeShape4: TTreeConnection;
    TreeNodeShape5: TTreeNodeShape;
    TreeNodeShape2_TreeNodeShape5: TTreeConnection;
    TreeNodeShape6: TTreeNodeShape;
    TreeNodeShape7: TTreeNodeShape;
    TreeNodeShape6_TreeNodeShape7: TTreeConnection;
    procedure Tree1SelectShape(Sender: TTreeNodeShape);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TNodeLevelForm.Tree1SelectShape(Sender: TTreeNodeShape);
begin
  Label2.Caption:=IntToStr(Sender.Level);
end;

initialization
  RegisterClass(TNodeLevelForm);
end.
