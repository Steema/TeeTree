unit DragFromEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, StdCtrls, TeeTree, TreeEd, ExtCtrls, TeeProcs;

type
  TDragFromEditForm = class(TBaseForm)
    Edit1: TEdit;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Tree1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Tree1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TDragFromEditForm.FormCreate(Sender: TObject);
begin
  inherited;

  // Set Edit1 drag and drop to automatic:
  Edit1.DragMode:=dmAutomatic;
end;

procedure TDragFromEditForm.Tree1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept:=Source=Edit1;  // Edit1 can be dragged to Tree
end;

procedure TDragFromEditForm.Tree1DragDrop(Sender, Source: TObject; X, Y: Integer);
var Node : TTreeNodeShape;
begin
  if Source=Edit1 then
  begin
    Node:=Tree1.Shapes.Clicked(x,y);    // dropped on a existing node ?
    if Assigned(Node) then Node.Expanded:=True;  // if ok, expand node

    Tree1.Selected.Clear;
    Tree1.Add(Edit1.Text,Node).Selected:=True;  // add and select new node
  end;
end;

procedure TDragFromEditForm.FormShow(Sender: TObject);
begin
  inherited;
  Edit1.SetFocus;
end;

initialization
  RegisterClass(TDragFromEditForm);
end.
