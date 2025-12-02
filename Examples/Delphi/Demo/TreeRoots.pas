unit TreeRoots;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs, TeCanvas;

type
  TTreeRootsForm = class(TBaseForm)
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeShape3: TTreeNodeShape;
    TreeNodeShape4: TTreeNodeShape;
    Button1: TButton;
    Label1: TLabel;
    ComboFlat1: TComboFlat;
    Button2: TButton;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure ComboFlat1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Tree1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
    Procedure ChangeBorderColor(Sender: TTreeNodeShape);
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TTreeRootsForm.Button1Click(Sender: TObject);
begin
  // Sort in ascending order, ignoring text case.
  Tree1.Roots.Sort(True,True);
end;

procedure TTreeRootsForm.ComboFlat1Change(Sender: TObject);
var tmp : TTreeNodeShape;
begin
  // Example of using "Find" method.
  // Locate the first root node partially containing the combo text:

  tmp:=Tree1.Roots.Find(ComboFlat1.Items[ComboFlat1.ItemIndex],True);

  // If found, change color to Green:
  if Assigned(tmp) then
     tmp.Color:=clLime;
end;

procedure TTreeRootsForm.Button2Click(Sender: TObject);
begin
  // Example of "ForEach" method.
  // Call ChangeBorderColor procedure for each root node:

  Tree1.Roots.ForEach(ChangeBorderColor);
end;

// this method is called for each root node:
Procedure TTreeRootsForm.ChangeBorderColor(Sender: TTreeNodeShape);
begin
  if Sender.Border.Style=psSolid then
     Sender.Border.Style:=psDot
  else
     Sender.Border.Style:=psSolid;
end;

procedure TTreeRootsForm.FormShow(Sender: TObject);
begin
  inherited;
  Label2.Caption:='';
end;

procedure TTreeRootsForm.Tree1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var tmp : TTreeNodeShape;
begin
  // Example of "Clicked" function of Tree1.Roots object:

  // Find the node under XY position:
  tmp:=Tree1.Roots.Clicked(x,y);
  if Assigned(tmp) then Label2.Caption:=tmp.SimpleText
                   else Label2.Caption:='';
end;

initialization
  RegisterClass(TTreeRootsForm);
end.
