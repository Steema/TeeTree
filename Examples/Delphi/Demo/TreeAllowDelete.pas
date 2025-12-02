unit TreeAllowDelete;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs;

type
  TTreeAllowDeleteForm = class(TBaseForm)
    CheckBox1: TCheckBox;
    Label1: TLabel;
    ComboBox1: TComboBox;
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeShape1_TreeNodeShape2: TTreeConnection;
    TreeNodeShape3: TTreeNodeShape;
    TreeNodeShape1_TreeNodeShape3: TTreeConnection;
    TreeNodeShape4: TTreeNodeShape;
    TreeNodeShape1_TreeNodeShape4: TTreeConnection;
    TreeNodeShape5: TTreeNodeShape;
    TreeNodeShape5_TreeNodeShape4: TTreeConnection;
    TreeNodeShape6: TTreeNodeShape;
    TreeNodeShape1_TreeNodeShape6: TTreeConnection;
    TreeNodeShape7: TTreeNodeShape;
    TreeNodeShape8: TTreeNodeShape;
    TreeNodeShape7_TreeNodeShape8: TTreeConnection;
    TreeNodeShape9: TTreeNodeShape;
    TreeNodeShape8_TreeNodeShape9: TTreeConnection;
    TreeNodeShape10: TTreeNodeShape;
    TreeNodeShape8_TreeNodeShape10: TTreeConnection;
    TreeNodeShape11: TTreeNodeShape;
    TreeNodeShape8_TreeNodeShape11: TTreeConnection;
    TreeNodeShape12: TTreeNodeShape;
    TreeNodeShape7_TreeNodeShape12: TTreeConnection;
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TTreeAllowDeleteForm.FormCreate(Sender: TObject);
begin
  inherited;

  ComboBox1.ItemIndex:=0;
end;

procedure TTreeAllowDeleteForm.ComboBox1Change(Sender: TObject);
begin
  // change key to delete nodes:

  if ComboBox1.ItemIndex=0 then
     TeeTreeDeleteKey:=VK_DELETE
  else
     TeeTreeDeleteKey:=VK_F4;
end;

procedure TTreeAllowDeleteForm.CheckBox1Click(Sender: TObject);
begin
  Tree1.AllowDelete:=CheckBox1.Checked;
end;

initialization
  RegisterClass(TTreeAllowDeleteForm);
end.
