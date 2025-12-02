unit NodeBorder;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs, TeCanvas, TeePenDlg,
  TeeGDIPlus;

type
  TNodeBorderForm = class(TBaseForm)
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeShape3: TTreeNodeShape;
    TreeNodeShape4: TTreeNodeShape;
    TreeNodeShape5: TTreeNodeShape;
    TreeNodeShape6: TTreeNodeShape;
    TreeNodeShape7: TTreeNodeShape;
    TreeNodeShape8: TTreeNodeShape;
    TreeNodeShape9: TTreeNodeShape;
    ButtonPen1: TButtonPen;
    CheckBox1: TCheckBox;
    TreeNodeShape10: TTreeNodeShape;
    procedure Tree1SelectShape(Sender: TTreeNodeShape);
    procedure Tree1UnSelectShape(Sender: TTreeNodeShape);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TNodeBorderForm.Tree1SelectShape(Sender: TTreeNodeShape);
begin
  // when a node is selected, enable button...
  ButtonPen1.LinkPen(Sender.Border);
  ButtonPen1.Enabled:=True;

  Sender.Font.Color:=clBlue; // blue font
end;

procedure TNodeBorderForm.Tree1UnSelectShape(Sender: TTreeNodeShape);
begin
  // when a node is un-selected, disable button...
  ButtonPen1.Enabled:=False;
  
  Sender.Font.Color:=clBlack;  // black font
end;

procedure TNodeBorderForm.CheckBox1Click(Sender: TObject);
var t: Integer;
begin
  // show or hide borders
  for t:=0 to Tree1.Shapes.Count-1 do
      Tree1.Shapes[t].Border.Visible:=CheckBox1.Checked;
end;

initialization
  RegisterClass(TNodeBorderForm);
end.
