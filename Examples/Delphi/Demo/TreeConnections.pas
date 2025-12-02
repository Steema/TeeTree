unit TreeConnections;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs, TreeFlow, TeCanvas,
  TeePenDlg;

type
  TTreeConnectionsForm = class(TBaseForm)
    CheckBox1: TCheckBox;
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeShape3: TTreeNodeShape;
    TreeNodeShape4: TTreeNodeShape;
    TreeNodeShape1_TreeNodeShape2: TTreeConnection;
    TreeNodeShape3_TreeNodeShape2: TTreeConnection;
    TreeNodeShape4_TreeNodeShape2: TTreeConnection;
    TreeNodeShape3_TreeNodeShape1: TTreeConnection;
    TreeNodeShape4_TreeNodeShape3: TTreeConnection;
    TreeNodeShape5: TTreeNodeShape;
    TreeNodeShape2_TreeNodeShape5: TTreeConnection;
    BeveledShape1: TBeveledShape;
    BeveledShape1_TreeNodeShape5: TTreeConnection;
    Label1: TLabel;
    CheckBox2: TCheckBox;
    ButtonPen1: TButtonPen;
    procedure CheckBox1Click(Sender: TObject);
    procedure Tree1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure Tree1SelectConnection(Sender: TTreeConnection);
    procedure Tree1UnSelectConnection(Sender: TTreeConnection);
    procedure Tree1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    procedure SetConnectionCursor(Sender: TTreeConnection);
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TTreeConnectionsForm.CheckBox1Click(Sender: TObject);
begin
  // Example: Show / Hide all connections

  Tree1.Connections.Visible:=CheckBox1.Checked;
end;

procedure TTreeConnectionsForm.Tree1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var tmp : TTreeConnection;
begin
  // Find a connection under XY cursor:
  tmp:=Tree1.Connections.Clicked(x,y);

  // If found, show the "From" and "To" node texts:
  if Assigned(tmp) then
     Label1.Caption:=tmp.FromShape.SimpleText+' -> '+tmp.ToShape.SimpleText
  else
     Label1.Caption:='';
end;

procedure TTreeConnectionsForm.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:='';

  // Example of "ForEach" method:
  // Set all connections Cursor to "Hand point":

  Tree1.Connections.ForEach(SetConnectionCursor);
end;

procedure TTreeConnectionsForm.SetConnectionCursor(Sender: TTreeConnection);
begin
  Sender.Cursor:=crHandPoint;
end;

procedure TTreeConnectionsForm.CheckBox2Click(Sender: TObject);
begin
  Tree1.Designing:=CheckBox2.Checked;
end;

procedure TTreeConnectionsForm.Tree1SelectConnection(
  Sender: TTreeConnection);
begin
  // When the Tree is in Design mode ( Tree1.Designing=True )
  // this event is called when a connection is clicked, or when
  // the Tree.Connections.Selected property is set.

  ButtonPen1.Enabled:=True;
  ButtonPen1.LinkPen(Sender.Border);
end;

procedure TTreeConnectionsForm.Tree1UnSelectConnection(
  Sender: TTreeConnection);
begin
  // This event is called when a connection is "un-selected".
  ButtonPen1.Enabled:=False;
  ButtonPen1.LinkPen(nil);
end;

procedure TTreeConnectionsForm.Tree1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // If we are in Design mode, select the connection under XY cursor

  if Tree1.Designing then
     With Tree1.Connections do
          Selected:=Clicked(x,y);
end;

initialization
  RegisterClass(TTreeConnectionsForm);
end.
