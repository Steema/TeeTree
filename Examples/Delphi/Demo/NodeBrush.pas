unit NodeBrush;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, StdCtrls, TeCanvas, TeeTree, TreeEd, ExtCtrls, TeeProcs;

type
  TNodeBrushForm = class(TBaseForm)
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeShape3: TTreeNodeShape;
    TreeNodeShape4: TTreeNodeShape;
    TreeNodeShape5: TTreeNodeShape;
    TreeNodeShape6: TTreeNodeShape;
    TreeNodeShape7: TTreeNodeShape;
    TreeNodeShape8: TTreeNodeShape;
    TreeNodeShape9: TTreeNodeShape;
    TreeNodeShape10: TTreeNodeShape;
    TreeNodeShape11: TTreeNodeShape;
    ButtonColor1: TButtonColor;
    ButtonColor2: TButtonColor;
    procedure ButtonColor1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonColor2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TNodeBrushForm.ButtonColor1Click(Sender: TObject);
var t: Integer;
begin
  // Change all nodes BackColor
  for t:=0 to Tree1.Shapes.Count-1 do
      Tree1[t].BackColor:=ButtonColor1.SymbolColor;
end;

procedure TNodeBrushForm.FormCreate(Sender: TObject);
begin
  inherited;
  // Prepare buttons...
  ButtonColor1.LinkProperty(TreeNodeShape1,'BackColor');
  ButtonColor2.LinkProperty(TreeNodeShape1.Brush,'Color');
end;

procedure TNodeBrushForm.ButtonColor2Click(Sender: TObject);
var t: Integer;
begin
  // Change all nodes Brush Color
  for t:=0 to Tree1.Shapes.Count-1 do
      Tree1[t].Brush.Color:=ButtonColor2.SymbolColor;
end;

initialization
  RegisterClass(TNodeBrushForm);
end.
