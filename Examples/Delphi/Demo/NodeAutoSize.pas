unit NodeAutoSize;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, ComCtrls, StdCtrls, TeeTree, TreeEd, ExtCtrls, TeeProcs;

type
  TNodeAutoSizeForm = class(TBaseForm)
    TreeNodeShape1: TTreeNodeShape;
    Label1: TLabel;
    TrackBar1: TTrackBar;
    TreeNodeShape2: TTreeNodeShape;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    procedure TrackBar1Change(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Tree1ResizingShape(Sender: TTreeNodeShape;
      ACorner: TTreeShapeHandle; var DeltaX, DeltaY: Integer);
    procedure CheckBox2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    Procedure ShowNodeSize;
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TNodeAutoSizeForm.TrackBar1Change(Sender: TObject);
begin
  TreeNodeShape1.Font.Size:=TrackBar1.Position;

  ShowNodeSize;
end;

procedure TNodeAutoSizeForm.CheckBox1Click(Sender: TObject);
begin
  TreeNodeShape1.AutoSize:=CheckBox1.Checked;

  ShowNodeSize;
end;

procedure TNodeAutoSizeForm.Tree1ResizingShape(Sender: TTreeNodeShape;
  ACorner: TTreeShapeHandle; var DeltaX, DeltaY: Integer);
begin
  // When a node is resized, it means AutoSize is False.
  CheckBox1.Checked:=False;

  ShowNodeSize;
end;

Procedure TNodeAutoSizeForm.ShowNodeSize;
begin
  // Show node size...
  TreeNodeShape2.Text.Clear;
  TreeNodeShape2.Text.Add('Node size: ');
  TreeNodeShape2.Text.Add( IntToStr(TreeNodeShape1.Width)+' x '+
                           IntToStr(TreeNodeShape1.Height) );
end;

procedure TNodeAutoSizeForm.CheckBox2Click(Sender: TObject);
begin
  // Set design mode...
  Tree1.Designing:=CheckBox2.Checked;

  if Tree1.Designing then
  begin
    Tree1.Selected.Clear;
    TreeNodeShape1.Selected:=True;
  end;
end;

procedure TNodeAutoSizeForm.FormCreate(Sender: TObject);
begin
  inherited;
  // Set text clipping to true
  TreeNodeShape1.Text.ClipText:=True;

  // Show node size
  ShowNodeSize;
end;

initialization
  RegisterClass(TNodeAutoSizeForm);
end.
