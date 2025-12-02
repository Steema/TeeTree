unit NodeFont;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs;

type
  TNodeFontForm = class(TBaseForm)
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
    TreeNodeShape8: TTreeNodeShape;
    Button1: TButton;
    TreeNodeShape9: TTreeNodeShape;
    TreeNodeShape10: TTreeNodeShape;
    TreeNodeShape11: TTreeNodeShape;
    TextShape1: TTextShape;
    procedure Button1Click(Sender: TObject);
    procedure Tree1SelectShape(Sender: TTreeNodeShape);
    procedure Tree1UnSelectShape(Sender: TTreeNodeShape);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

Uses TreeShEd;

procedure TNodeFontForm.Button1Click(Sender: TObject);
begin
  // Show the node editor dialog, at Text tab,
  // showing properties for the first selected node...
  EditTreeShapePage(Self,Tree1.Selected.First,stText,True);
end;

procedure TNodeFontForm.Tree1SelectShape(Sender: TTreeNodeShape);
begin
  // enable button when selecting nodes...
  Button1.Enabled:=True;
end;

procedure TNodeFontForm.Tree1UnSelectShape(Sender: TTreeNodeShape);
begin
  // disable button when un-selecting nodes...
  Button1.Enabled:=False;
end;

procedure TNodeFontForm.FormCreate(Sender: TObject);
begin
  inherited;

  TextShape1.Font.Outline.Fill.Gradient.Visible:=True;
end;

initialization
  RegisterClass(TNodeFontForm);
end.
