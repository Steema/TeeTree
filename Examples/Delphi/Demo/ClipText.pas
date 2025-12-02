unit ClipText;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, StdCtrls, TreeEd, ExtCtrls, TeeProcs;

type
  TClipTextForm = class(TBaseForm)
    CheckBox1: TCheckBox;
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeShape3: TTreeNodeShape;
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TClipTextForm.CheckBox1Click(Sender: TObject);
begin
  // clip text, or not ...

  TreeNodeShape1.Text.ClipText:=CheckBox1.Checked;
  TreeNodeShape2.Text.ClipText:=CheckBox1.Checked;
  TreeNodeShape3.Text.ClipText:=CheckBox1.Checked;
end;

initialization
  RegisterClass(TClipTextForm);
end.
