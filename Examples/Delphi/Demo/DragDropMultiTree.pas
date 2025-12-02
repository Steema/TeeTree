unit DragDropMultiTree;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, ExtCtrls, TeeTree, TreeEd, StdCtrls, TeeProcs;

type
  TDragDropMultiForm = class(TBaseForm)
    Tree2: TTree;
    Splitter1: TSplitter;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeShape1_TreeNodeShape2: TTreeConnection;
    TreeNodeShape3: TTreeNodeShape;
    TreeNodeShape1_TreeNodeShape3: TTreeConnection;
    TreeNodeShape4: TTreeNodeShape;
    TreeNodeShape3_TreeNodeShape4: TTreeConnection;
    TreeNodeShape5: TTreeNodeShape;
    TreeNodeShape6: TTreeNodeShape;
    TreeNodeShape5_TreeNodeShape6: TTreeConnection;
    TreeNodeShape7: TTreeNodeShape;
    TreeNodeShape8: TTreeNodeShape;
    TreeNodeShape9: TTreeNodeShape;
    TreeNodeShape8_TreeNodeShape9: TTreeConnection;
    TreeNodeShape10: TTreeNodeShape;
    TreeNodeShape11: TTreeNodeShape;
    TreeNodeShape12: TTreeNodeShape;
    TreeNodeShape11_TreeNodeShape12: TTreeConnection;
    TreeNodeShape13: TTreeNodeShape;
    TreeNodeShape12_TreeNodeShape13: TTreeConnection;
    TreeNodeShape14: TTreeNodeShape;
    TreeNodeShape12_TreeNodeShape14: TTreeConnection;
    TreeNodeShape15: TTreeNodeShape;
    TreeNodeShape16: TTreeNodeShape;
    TreeNodeShape15_TreeNodeShape16: TTreeConnection;
    TreeNodeShape17: TTreeNodeShape;
    TreeNodeShape16_TreeNodeShape17: TTreeConnection;
    procedure Tree1Resize(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TDragDropMultiForm.Tree1Resize(Sender: TObject);
begin
  CheckBox2.Left:=Tree2.Left;
  CheckBox4.Left:=Tree2.Left;
end;

procedure TDragDropMultiForm.CheckBox2Click(Sender: TObject);
begin
  Tree2.DragAndDrop.FromOtherTree:=CheckBox2.Checked;
end;

procedure TDragDropMultiForm.CheckBox1Click(Sender: TObject);
begin
  Tree1.DragAndDrop.FromOtherTree:=CheckBox1.Checked;
end;

procedure TDragDropMultiForm.FormCreate(Sender: TObject);
begin
  inherited;

  Tree1.DragAndDrop.Automatic:=True;
  Tree2.DragAndDrop.Automatic:=True;

  // (Optional)
  Tree1.DragAndDrop.ToOtherTree:=True;
  Tree1.DragAndDrop.FromOtherTree:=True;
  Tree1.DragAndDrop.DragRoots:=True;
  Tree1.DragAndDrop.DragToRoot:=True;
end;

procedure TDragDropMultiForm.CheckBox3Click(Sender: TObject);
begin
  Tree1.DragAndDrop.ToOtherTree:=CheckBox3.Checked;
end;

procedure TDragDropMultiForm.CheckBox4Click(Sender: TObject);
begin
  Tree2.DragAndDrop.ToOtherTree:=CheckBox4.Checked;
end;

initialization
  RegisterClass(TDragDropMultiForm);
end.
