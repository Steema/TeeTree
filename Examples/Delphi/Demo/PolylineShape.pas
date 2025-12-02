unit PolylineShape;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs, TeCanvas, TeePenDlg;

type
  TPolylineShapeForm = class(TBaseForm)
    PolyLineShape1: TPolyLineShape;
    ButtonPen1: TButtonPen;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Tree1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TPolylineShapeForm.FormCreate(Sender: TObject);
begin
  inherited;

  PolyLineShape1.Selected:=True;

  ButtonPen1.LinkPen(PolyLineShape1.Border);

  Tree1.SnapToGrid:=False; // for better, free-hand dragging of points...
end;

procedure TPolylineShapeForm.Tree1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var Point : Integer;
begin
  // If the mouse cursor is over a poly-line point, delete it...
  if Button=mbRight then
  begin
    Point:=PolyLineShape1.ClickedPoint(x,y);

    if Point<>-1 then
       PolyLineShape1.Points.Delete(Point);
  end;
end;

initialization
  RegisterClass(TPolylineShapeForm);
end.
