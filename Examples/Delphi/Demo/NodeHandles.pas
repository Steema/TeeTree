unit NodeHandles;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs, TeePenDlg, TeCanvas,
  ComCtrls, TeeGDIPlus;

type
  THandlesForm = class(TBaseForm)
    TreeNodeShape1: TTreeNodeShape;
    TextShape1: TTextShape;
    TextShape2: TTextShape;
    TextShape3: TTextShape;
    TextShape4: TTextShape;
    TextShape5: TTextShape;
    TextShape6: TTextShape;
    TextShape7: TTextShape;
    TextShape8: TTextShape;
    TextShape1_TreeNodeShape1: TTreeConnection;
    TextShape2_TreeNodeShape1: TTreeConnection;
    TextShape3_TreeNodeShape1: TTreeConnection;
    TextShape4_TreeNodeShape1: TTreeConnection;
    TextShape8_TreeNodeShape1: TTreeConnection;
    TextShape7_TreeNodeShape1: TTreeConnection;
    TextShape6_TreeNodeShape1: TTreeConnection;
    TextShape5_TreeNodeShape1: TTreeConnection;
    ButtonColor1: TButtonColor;
    ButtonPen1: TButtonPen;
    Label1: TLabel;
    Edit1: TEdit;
    UpDown1: TUpDown;
    procedure FormCreate(Sender: TObject);
    procedure Tree1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Edit1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure THandlesForm.FormCreate(Sender: TObject);
begin
  inherited;
  TreeNodeShape1.Selected:=True;

  Tree1.SnapToGrid:=False; // Allow moving and resizing nodes 1 pixel at a time

  ButtonColor1.LinkProperty(Tree1.Selected,'HandleColor');
  ButtonPen1.LinkPen(Tree1.Selected.HandlePen);
end;

procedure THandlesForm.Tree1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var tmp : TTreeNodeShape;
    t   : Integer;
begin
  tmp:=nil;

  if Tree1.Selected.Count>0 then
    case Tree1.Selected.First.GetResizingHandle(x,y) of
      rcLeftTop     : tmp:=TextShape1;
      rcTop         : tmp:=TextShape2;
      rcRightTop    : tmp:=TextShape3;
      rcRight       : tmp:=TextShape4;
      rcLeft        : tmp:=TextShape5;
      rcLeftBottom  : tmp:=TextShape6;
      rcBottom      : tmp:=TextShape7;
      rcRightBottom : tmp:=TextShape8;
    end;

  if Assigned(tmp) then
     tmp.Font.Style:=[fsBold]
  else
  for t:=0 to Tree1.Shapes.Count-1 do
      Tree1.Shapes[t].Font.Style:=[];
end;

procedure THandlesForm.Edit1Change(Sender: TObject);
begin
  Tree1.Selected.HandleSize:=UpDown1.Position;
end;

initialization
  RegisterClass(THandlesForm);
end.
