unit ScrollBars;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, StdCtrls, TeeTree, TreeEd, ExtCtrls, TeeProcs, TreeFlow, TeeGDIPlus;

type
  TScrollBarsForm = class(TBaseForm)
    CheckBox1: TCheckBox;
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeShape3: TTreeNodeShape;
    CrossShape1: TCrossShape;
    TreeNodeShape4: TTreeNodeShape;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TScrollBarsForm.CheckBox1Click(Sender: TObject);
begin
  Tree1.HorzScrollBar.Flat:=CheckBox1.Checked;
  Tree1.VertScrollBar.Flat:=CheckBox1.Checked;
end;

procedure TScrollBarsForm.CheckBox2Click(Sender: TObject);
begin
  // Set Automatic:
  Tree1.HorzScrollBar.Automatic:=CheckBox2.Checked;
  Tree1.VertScrollBar.Automatic:=CheckBox2.Checked;

  CheckBox3.Enabled:=not CheckBox2.Checked;
  CheckBox3.Checked:=True;

  // When disabling Automatic, set Visible:
  if not CheckBox2.Checked then
  begin
    Tree1.HorzScrollBar.Visible:=CheckBox3.Checked;
    Tree1.VertScrollBar.Visible:=CheckBox3.Checked;
  end;
end;

procedure TScrollBarsForm.CheckBox3Click(Sender: TObject);
begin
  Tree1.HorzScrollBar.Visible:=CheckBox3.Checked;
  Tree1.VertScrollBar.Visible:=CheckBox3.Checked;
end;

initialization
  RegisterClass(TScrollBarsForm);
end.
