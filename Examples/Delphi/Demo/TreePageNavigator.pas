unit TreePageNavigator;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs, TreeNavigator,
  TeeNavigator;

type
  TTreePageNavigatorForm = class(TBaseForm)
    Label1: TLabel;
    TreePageNavigator1: TTreePageNavigator;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Tree1AfterDraw(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TTreePageNavigatorForm.FormCreate(Sender: TObject);
var t : Integer;
begin
  inherited;

  // Dont forget to set this property:
  TreePageNavigator1.Tree:=Tree1;

  // Fill Tree with many many nodes, to produce a multi-page Tree:
  for t:=0 to 2000 do
      with Tree1.Add('Text line: '+IntToStr(t)) do
      begin
        Top:=16*t;
        Transparent:=True;
        Border.Visible:=False;
      end;

  // After adding nodes, enable saving of nodes to file.
  // This is done *after* adding nodes for speed reasons.
  // If this is done before, adding nodes will be slow.
  Tree1.NoOwnerShapes:=False;

  // Show Page boundaries:
  Tree1.Page.Border.Visible:=True;
  // Show it also when not designing the Tree:
  Tree1.Page.Border.Print:=True;

  // Show Tree grid:
  Tree1.Grid.Visible:=True;
end;

procedure TTreePageNavigatorForm.Tree1AfterDraw(Sender: TObject);
begin
  // Show current page, each time the Tree is redisplayed:
  Label2.Caption:=IntToStr(Tree1.Page.Page)+' / '+IntToStr(Tree1.Page.Count);

  // Refresh navigator buttons:
  TreePageNavigator1.EnableButtons;
end;

initialization
  RegisterClass(TTreePageNavigatorForm);
end.
