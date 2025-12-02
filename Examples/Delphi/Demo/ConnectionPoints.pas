unit ConnectionPoints;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs, TeCanvas;

type
  TConnectionPointsForm = class(TBaseForm)
    FromNode: TTreeNodeShape;
    ToNode: TTreeNodeShape;
    Label1: TLabel;
    ComboFlat1: TComboFlat;
    procedure FormCreate(Sender: TObject);
    procedure ComboFlat1Change(Sender: TObject);
  private
    { Private declarations }
    Connection : TTreeConnection;
  public
    { Public declarations }
    Procedure FirstExample;
    Procedure SecondExample;
    Procedure ThirdExample;
  end;

implementation

{$R *.DFM}

procedure TConnectionPointsForm.FormCreate(Sender: TObject);
begin
  inherited;

  // Add a new connection from "From" to "To" nodes:
  Connection:=FromNode.AddConnection(ToNode);

  // Set border format:
  with Connection.Border do
  begin
    Color:=clRed;
    SmallDots:=False;
    Width:=2;
    Style:=psSolid;
  end;

  // Arrow:
  Connection.ArrowTo.Size:=10;

  // Another way to create a connection:
  // Connection:=TTreeConnection.Create(Self);
  // Connection.Tree:=Tree1;
  // Connection.FromShape:=FromNode;
  // Connection.ToShape:=ToNode;

  ComboFlat1.ItemIndex:=0;
  FirstExample;
end;

Procedure TConnectionPointsForm.FirstExample;
begin
  // Set "Line" style:
  Connection.Style:=csLine;

  // Clear and Add points.
  Connection.Points.Clear;

  // First point is at Right Bottom corner of the "From" node:
  Connection.Points.Add(cpsFromPercent,100,cpsFromPercent,100);

  // Second point is at same X than previous, and Y = center (50%) of "To" node:
  Connection.Points.Add(cpsPrevious,0,cpsToPercent,50);

  // Third point is at Left side of "To" node, and same Y as previous point:
  Connection.Points.Add(cpsToPercent,0,cpsPrevious,0);

  // Repaint Tree:
  Tree1.Invalidate;
end;

procedure TConnectionPointsForm.ComboFlat1Change(Sender: TObject);
begin
  Case ComboFlat1.ItemIndex of
    0: FirstExample;
    1: SecondExample;
    2: ThirdExample;
  end;
end;

procedure TConnectionPointsForm.SecondExample;
begin
  // Set "Line" style:
  Connection.Style:=csLine;

  // Clear and Add points.
  Connection.Points.Clear;

  // First point is automatic at "From" node:
  Connection.Points.Add(cpsAutoFrom,0,cpsAutoFrom,0);

  // Second point is automatic at "To" node:
  Connection.Points.Add(cpsAutoTo,0,cpsAutoTo,0);

  // Repaint Tree:
  Tree1.Invalidate;
end;

procedure TConnectionPointsForm.ThirdExample;
begin
  // Set "Line" style:
  Connection.Style:=csLine;

  // Clear and Add points.
  Connection.Points.Clear;

  // First point is at center-top of the "From" node:
  Connection.Points.Add(cpsFromPercent,50,cpsFromPercent,0);

  // Second point is at same X than previous,
  // and Y = same as previous point minus 20 pixels:
  Connection.Points.AddFromPrevious(0,-20);

  // Third point is X= 50 pixels from previous point and same Y as previous point:
  Connection.Points.AddFromPrevious(-50,0);

  // Fourth point is same X as previous, and Y 30 pixels more:
  Connection.Points.AddFromPrevious(0,30);

  Connection.Points.AddFromPrevious(6,60);

  // At "To" node top-center:
  Connection.Points.Add(cpsToPercent,50,cpsToPercent,0);

  // Repaint Tree:
  Tree1.Invalidate;
end;

initialization
  RegisterClass(TConnectionPointsForm);
end.
