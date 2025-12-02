unit NodeGradient;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, StdCtrls, TeeTree, TreeEd, ExtCtrls, TeeProcs;

type
  TNodeGradientForm = class(TBaseForm)
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeShape3: TTreeNodeShape;
    TreeNodeShape4: TTreeNodeShape;
    TreeNodeShape5: TTreeNodeShape;
    TreeNodeShape6: TTreeNodeShape;
    TreeNodeShape7: TTreeNodeShape;
    TreeNodeShape8: TTreeNodeShape;
    CheckBox1: TCheckBox;
    Button1: TButton;
    PolygonShape1: TPolygonShape;
    procedure Button1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Tree1SelectShape(Sender: TTreeNodeShape);
    procedure Tree1UnSelectShape(Sender: TTreeNodeShape);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

Uses TeeEdiGrad;

procedure TNodeGradientForm.Button1Click(Sender: TObject);
begin
  // show the Gradient editor dialog for selected node...
  if Tree1.Selected.Count>0 then
     TTeeGradientEditor.Edit(Self,Tree1.Selected.First.Gradient);
end;

procedure TNodeGradientForm.CheckBox1Click(Sender: TObject);
var t: Integer;
begin
  // set - unset gradient clipping
  for t:=0 to Tree1.Shapes.Count-1 do
      Tree1[t].GradientClip:=CheckBox1.Checked;
end;

procedure TNodeGradientForm.FormCreate(Sender: TObject);
begin
  inherited;

  // set color to "clNone" to show selected nodes with
  // their original fill...
  Tree1.Selected.Color:=clNone;
end;

procedure TNodeGradientForm.Tree1SelectShape(Sender: TTreeNodeShape);
begin
  Button1.Enabled:=True;
end;

procedure TNodeGradientForm.Tree1UnSelectShape(Sender: TTreeNodeShape);
begin
  Button1.Enabled:=False;
end;

procedure TNodeGradientForm.FormShow(Sender: TObject);
begin
  inherited;
  TreeNodeShape1.Selected:=True;
end;

initialization
  RegisterClass(TNodeGradientForm);
end.
