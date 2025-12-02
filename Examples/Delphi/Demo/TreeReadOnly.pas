unit TreeReadOnly;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs;

type
  TTreeReadOnlyForm = class(TBaseForm)
    TreeNodeShape1: TTreeNodeShape;
    CheckBox1: TCheckBox;
    Panel2: TPanel;
    Label1: TLabel;
    procedure CheckBox1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Tree1StartEditing(Shape: TTreeNodeShape;
      var AllowEditing: Boolean);
    procedure Tree1StopEditing(Sender: TTreeNodeShape);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TTreeReadOnlyForm.CheckBox1Click(Sender: TObject);
begin
  Tree1.ReadOnly:=CheckBox1.Checked;
end;

procedure TTreeReadOnlyForm.FormShow(Sender: TObject);
begin
  inherited;
  Label1.Caption:='';
  TreeNodeShape1.Selected:=True;
  Tree1.SetFocus;
end;

procedure TTreeReadOnlyForm.Tree1StartEditing(Shape: TTreeNodeShape;
  var AllowEditing: Boolean);
begin
  Label1.Caption:='Press ESCAPE key to stop editing.';

  // Example: change color of editor memo.
  Tree1.TextEditor.Memo.Color:=clAqua; 
end;

procedure TTreeReadOnlyForm.Tree1StopEditing(Sender: TTreeNodeShape);
begin
  Label1.Caption:='';
end;

initialization
  RegisterClass(TTreeReadOnlyForm);
end.
