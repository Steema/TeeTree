unit MouseWheel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs;

type
  TMouseWheelForm = class(TBaseForm)
    Label1: TLabel;
    ComboBox1: TComboBox;
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeShape1_TreeNodeShape2: TTreeConnection;
    TreeNodeShape3: TTreeNodeShape;
    TreeNodeShape1_TreeNodeShape3: TTreeConnection;
    TreeNodeShape4: TTreeNodeShape;
    TreeNodeShape3_TreeNodeShape4: TTreeConnection;
    TreeNodeShape5: TTreeNodeShape;
    TreeNodeShape3_TreeNodeShape5: TTreeConnection;
    TreeNodeShape6: TTreeNodeShape;
    TreeNodeShape1_TreeNodeShape6: TTreeConnection;
    TreeNodeShape7: TTreeNodeShape;
    TreeNodeShape1_TreeNodeShape7: TTreeConnection;
    TreeNodeShape8: TTreeNodeShape;
    TreeNodeShape7_TreeNodeShape8: TTreeConnection;
    TreeNodeShape9: TTreeNodeShape;
    TreeNodeShape7_TreeNodeShape9: TTreeConnection;
    TreeNodeShape10: TTreeNodeShape;
    TreeNodeShape11: TTreeNodeShape;
    TreeNodeShape10_TreeNodeShape11: TTreeConnection;
    TreeNodeShape12: TTreeNodeShape;
    TreeNodeShape13: TTreeNodeShape;
    TreeNodeShape14: TTreeNodeShape;
    TreeNodeShape13_TreeNodeShape14: TTreeConnection;
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TMouseWheelForm.ComboBox1Change(Sender: TObject);
begin
  // Change mouse wheel style:
  Case ComboBox1.ItemIndex of
    0: Tree1.WheelNavigation:=wnSelection;
    1: Tree1.WheelNavigation:=wnScrollVert;
    2: Tree1.WheelNavigation:=wnScrollHoriz;
    3: Tree1.WheelNavigation:=wnZoom;
    4: Tree1.WheelNavigation:=wnNone;
  end;
end;

procedure TMouseWheelForm.FormCreate(Sender: TObject);
begin
  inherited;
  ComboBox1.ItemIndex:=0;
end;

procedure TMouseWheelForm.FormShow(Sender: TObject);
begin
  inherited;
  Tree1.SetFocus;
end;

initialization
  RegisterClass(TMouseWheelForm);
end.
