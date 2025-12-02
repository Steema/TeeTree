unit BrotherIndex;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, StdCtrls, TreeEd, ExtCtrls, TeeProcs;

type
  TBrotherIndexForm = class(TBaseForm)
    Label1: TLabel;
    Label2: TLabel;
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeShape1_TreeNodeShape2: TTreeConnection;
    TreeNodeShape3: TTreeNodeShape;
    TreeNodeShape1_TreeNodeShape3: TTreeConnection;
    TreeNodeShape4: TTreeNodeShape;
    TreeNodeShape1_TreeNodeShape4: TTreeConnection;
    TreeNodeShape5: TTreeNodeShape;
    TreeNodeShape1_TreeNodeShape5: TTreeConnection;
    TreeNodeShape6: TTreeNodeShape;
    TreeNodeShape7: TTreeNodeShape;
    TreeNodeShape6_TreeNodeShape7: TTreeConnection;
    TreeNodeShape8: TTreeNodeShape;
    TreeNodeShape6_TreeNodeShape8: TTreeConnection;
    TreeNodeShape9: TTreeNodeShape;
    TreeNodeShape8_TreeNodeShape9: TTreeConnection;
    TreeNodeShape10: TTreeNodeShape;
    TreeNodeShape8_TreeNodeShape10: TTreeConnection;
    TreeNodeShape11: TTreeNodeShape;
    TreeNodeShape8_TreeNodeShape11: TTreeConnection;
    TreeNodeShape12: TTreeNodeShape;
    TreeNodeShape6_TreeNodeShape12: TTreeConnection;
    TreeNodeShape13: TTreeNodeShape;
    TreeNodeShape14: TTreeNodeShape;
    TreeNodeShape15: TTreeNodeShape;
    TreeNodeShape14_TreeNodeShape15: TTreeConnection;
    Button1: TButton;
    Button2: TButton;
    procedure Tree1SelectShape(Sender: TTreeNodeShape);
    procedure Tree1UnSelectShape(Sender: TTreeNodeShape);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TBrotherIndexForm.Tree1SelectShape(Sender: TTreeNodeShape);
begin
  Label2.Caption:=IntToStr( Sender.BrotherIndex );

  if Assigned(Sender.Parent) then
  begin
    Button1.Enabled:=Sender.BrotherIndex>0;
    Button2.Enabled:=Sender.BrotherIndex<Sender.Parent.Count-1;
  end
  else
  begin
    Button1.Enabled:=False;
    Button2.Enabled:=False;
  end;
end;

procedure TBrotherIndexForm.Tree1UnSelectShape(Sender: TTreeNodeShape);
begin
  Label2.Caption:='';
  Button1.Enabled:=False;
  Button2.Enabled:=False;
end;

procedure TBrotherIndexForm.Button1Click(Sender: TObject);
begin
  with Tree1.Selected.First do
       BrotherIndex:=BrotherIndex-1;

  Tree1SelectShape(Tree1.Selected.First);
end;

procedure TBrotherIndexForm.Button2Click(Sender: TObject);
begin
  with Tree1.Selected.First do
       BrotherIndex:=BrotherIndex+1;

  Tree1SelectShape(Tree1.Selected.First);
end;

procedure TBrotherIndexForm.FormCreate(Sender: TObject);
begin
  inherited;
  Button1.Enabled:=False;
  Button2.Enabled:=False;
end;

initialization
  RegisterClass(TBrotherIndexForm);
end.
