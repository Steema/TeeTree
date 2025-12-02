unit TextAlignment;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs, ComCtrls;

type
  TTextAlignForm = class(TBaseForm)
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeShape3: TTreeNodeShape;
    TreeNodeShape4: TTreeNodeShape;
    TreeNodeShape5: TTreeNodeShape;
    TreeNodeShape6: TTreeNodeShape;
    TreeNodeShape7: TTreeNodeShape;
    Label1: TLabel;
    Edit1: TEdit;
    UpDown1: TUpDown;
    Label2: TLabel;
    Edit2: TEdit;
    UpDown2: TUpDown;
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TTextAlignForm.Edit1Change(Sender: TObject);
var t: Integer;
begin
  // Change Horizontal Text Offset in all shapes...
  for t:=0 to Tree1.Shapes.Count-1 do
      Tree1[t].Text.HorizOffset:=UpDown1.Position;
end;

procedure TTextAlignForm.Edit2Change(Sender: TObject);
var t: Integer;
begin
  // Change Vertical Text Offset in all shapes...
  for t:=0 to Tree1.Shapes.Count-1 do
      Tree1[t].Text.VertOffset:=UpDown2.Position;
end;

initialization
  RegisterClass(TTextAlignForm);
end.
