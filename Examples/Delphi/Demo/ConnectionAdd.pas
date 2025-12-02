unit ConnectionAdd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, Buttons, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs;

type
  TConnectionAddForm = class(TBaseForm)
    SpeedButton1: TSpeedButton;
    TreeNodeA: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeC: TTreeNodeShape;
    TreeNodeShape4: TTreeNodeShape;
    TreeNodeShape5: TTreeNodeShape;
    TreeNodeShape6: TTreeNodeShape;
    Label1: TLabel;
    Label2: TLabel;
    Panel2: TPanel;
    Label3: TLabel;
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Tree1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TConnectionAddForm.SpeedButton1Click(Sender: TObject);
var Connection : TTreeConnection;
begin
  if SpeedButton1.Down then
  begin
    // Prepare to connect nodes...

    Label1.Caption:='Click one node to start a connection. Press ESCAPE to cancel.';

    // Change Tree cursor to "+"
    Tree1.Cursor:=crCross;
    Tree1.OriginalCursor:=crCross;

    // Initiate mouse connection
    Connection:=Tree1.StartConnecting;

    // If user connected two nodes:
    if Assigned(Connection) then
    begin
      // Change connection style to single line, color red
      Connection.Style:=csLine;
      Connection.Border.Color:=clRed;
    end;

    // Reset button
    SpeedButton1.Down:=False;
  end
  else
  begin
    Tree1.StopConnecting;  // User pressed button while connecting
  end;

  // Restore Tree cursor
  Tree1.Cursor:=crDefault;
  Tree1.OriginalCursor:=crDefault;

  // Empty message label
  Label1.Caption:='';
end;

procedure TConnectionAddForm.FormCreate(Sender: TObject);
var t          : Integer;
    Connection : TTreeConnection;
begin
  inherited;

  // Cosmetic. Set all nodes Cursor to HandPoint.
  for t:=0 to Tree1.Shapes.Count-1 do
      Tree1[t].Cursor:=crHandPoint;


  // Example. Create a connection from Node A to Node C

  Connection:=TreeNodeA.AddConnection(TreeNodeC);
  Connection.Style:=csLine;
  Connection.Border.Style:=psSolid;
  Connection.Border.Color:=clBlue;
end;

procedure TConnectionAddForm.Tree1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);

var Node       : TTreeNodeShape;
    Connection : TTreeConnection;
begin

  // Find which object is under the mouse XY

  Node:=Tree1.Shapes.Clicked(x,y);
  if Assigned(Node) then
  begin
    Label3.Caption:='Node: '+Node.SimpleText;
  end
  else
  begin
    Connection:=Tree1.Connections.Clicked(x,y);
    if Assigned(Connection) then
       Label3.Caption:='Connection: '+ Connection.FromShape.SimpleText+' --> '+
                                       Connection.ToShape.SimpleText
    else
       Label3.Caption:=''; 
  end;
end;

initialization
  RegisterClass(TConnectionAddForm);
end.

