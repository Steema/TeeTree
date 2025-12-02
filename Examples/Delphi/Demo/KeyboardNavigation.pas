unit KeyboardNavigation;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs, TeCanvas, ComCtrls;

type
  TTreeNavigationForm = class(TForm)
    PageControl1: TPageControl;
    Memo1: TMemo;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Tree1: TTree;
    Tree2: TTree;
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeShape3: TTreeNodeShape;
    TreeNodeShape4: TTreeNodeShape;
    TreeNodeShape5: TTreeNodeShape;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TTreeNavigationForm.FormCreate(Sender: TObject);
var t  : Integer;
    tt : Integer;
begin
  inherited;

  // Set Tree1 navigation mode to "Explorer" :  (the default)
  Tree1.Navigation:=tnExplorer;

  // Add sample nodes:

  for t:=1 to 5 do
  with Tree1.Add('Root: '+IntToStr(t)) do
       for tt:=1 to 10 do Add('Child: '+IntToStr(tt));

  Tree1.Roots[0].Selected:=True;

  // Set Tree2 navigation mode to "Nearest":
  Tree2.Navigation:=tnNearest;
end;

initialization
  RegisterClass(TTreeNavigationForm);
end.
