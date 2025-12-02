unit TreeGrid;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs, TeCanvas, TeePenDlg,
  ComCtrls;

type
  TTreeGridForm = class(TBaseForm)
    ButtonPen1: TButtonPen;
    ButtonPen2: TButtonPen;
    TreeNodeShape1: TTreeNodeShape;
    Label1: TLabel;
    Edit1: TEdit;
    UpDown1: TUpDown;
    CheckBox1: TCheckBox;
    Label2: TLabel;
    Edit2: TEdit;
    UpDown2: TUpDown;
    procedure FormCreate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Procedure SnapToGrid(ANode:TTreeNodeShape);

implementation

{$R *.DFM}

procedure TTreeGridForm.FormCreate(Sender: TObject);
begin
  inherited;

  // Show Grid:
  Tree1.Grid.Visible:=True;
  Tree1.Grid.Pen.Visible:=True;
  Tree1.Grid.Pen.Style:=psSolid;
  Tree1.Grid.BigPen.Visible:=True;

  // Set design mode:
  Tree1.Designing:=True;

  // Prepare buttons:
  ButtonPen1.LinkPen(Tree1.Grid.Pen);
  ButtonPen2.LinkPen(Tree1.Grid.BigPen);
end;

procedure TTreeGridForm.Edit1Change(Sender: TObject);
begin
  Tree1.Grid.Step:=UpDown1.Position;

  // Example: Align Node to grid:
  if Tree1.SnapToGrid then SnapToGrid(TreeNodeShape1);
end;

procedure TTreeGridForm.CheckBox1Click(Sender: TObject);
begin
  Tree1.SnapToGrid:=CheckBox1.Checked;
end;

procedure TTreeGridForm.Edit2Change(Sender: TObject);
begin
  Tree1.Grid.BigStep:=UpDown2.Position;
end;

Procedure SnapToGrid(ANode:TTreeNodeShape);
var HalfStep : Integer;
    x        : Integer;
    y        : Integer;
    Dif      : Integer;
begin
  HalfStep:=ANode.Tree.Grid.Step div 2;

  x:=ANode.Left;
  y:=ANode.Top;

  Dif:=x mod ANode.Tree.Grid.Step;
  if Dif>HalfStep then x:=x+ANode.Tree.Grid.Step-Dif
                  else x:=x-Dif;

  Dif:=y mod ANode.Tree.Grid.Step;
  if Dif>HalfStep then y:=y+ANode.Tree.Grid.Step-Dif
                  else y:=y-Dif;

  ANode.Left:=x;
  ANode.Top:=y;
end;

initialization
  RegisterClass(TTreeGridForm);
end.
