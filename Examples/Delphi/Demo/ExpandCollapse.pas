unit ExpandCollapse;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs;

type
  TExpandCollapseForm = class(TBaseForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Tree1ExpandingCollapsing(Sender: TTreeNodeShape;
      var Expand: Boolean);
    procedure Tree1ExpandedCollapsed(Sender: TTreeNodeShape);
  private
    { Private declarations }
  public
    { Public declarations }
    MyNode : TTreeNodeShape;
  end;

implementation

{$R *.DFM}

procedure TExpandCollapseForm.FormCreate(Sender: TObject);
begin
  inherited;

  // Add sample nodes...

  with Tree1.Add('Root1') do
  begin
    AddChild('Child1');
    AddChild('Child2');
    AddChild('Child3').AddChild('SubChild');
  end;

  with Tree1.Add('Root2') do
  begin
    ImageIndex:=tiFloppy3;
    AddChild('Child1');

    MyNode:=AddChild('Child2 - I cannot be expanded !');

    MyNode.AddChild('SubChild');

    AddChild('Child3').AddChild('SubChild').AddChild('SubSubChild');
  end;

  // Expand first root node:
  Tree1.Roots[0].Expanded:=True;

  // Clear example label:
  Label1.Caption:='';
end;

procedure TExpandCollapseForm.Button1Click(Sender: TObject);
begin
  Tree1.FullExpandCollapse(True);
end;

procedure TExpandCollapseForm.Button2Click(Sender: TObject);
begin
  Tree1.FullExpandCollapse(False);
end;

procedure TExpandCollapseForm.Tree1ExpandingCollapsing(
  Sender: TTreeNodeShape; var Expand: Boolean);
begin
  // Example:
  // We can set here the Expand parameter to False to
  // prevent expanding the Sender node when Sender = MyNode.

  if Sender=MyNode then Expand:=False;
end;

procedure TExpandCollapseForm.Tree1ExpandedCollapsed(
  Sender: TTreeNodeShape);
begin
  if Sender.Expanded then
     Label1.Caption:='Node: "'+Sender.SimpleText+'" has been expanded.'
  else
     Label1.Caption:='Node: "'+Sender.SimpleText+'" has been collapsed.'
end;

initialization
  RegisterClass(TExpandCollapseForm);
end.
