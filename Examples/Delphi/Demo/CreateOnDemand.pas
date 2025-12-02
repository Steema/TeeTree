unit CreateOnDemand;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs;

type
  TCreateOnDemandForm = class(TBaseForm)
    procedure FormCreate(Sender: TObject);
    procedure Tree1ExpandingCollapsing(Sender: TTreeNodeShape;
      var Expand: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TCreateOnDemandForm.FormCreate(Sender: TObject);
var t : Integer;
begin
  inherited;

  // Add first level "Root" example nodes only:

  for t:=1 to 10 do
      Tree1.Add('Root '+IntToStr(t));

  // Children nodes will be created "on demand", the very first time
  // a node is expanded.

  // Important:
  // Set nodes ShowCross property to "scAlways" so the +/- box is
  // always visible, even the node has no children yet.

  for t:=0 to Tree1.Roots.Count-1 do
      Tree1.Roots[t].ShowCross:=scAlways;

  // Remove border
  Tree1.GlobalFormat.Border.Visible:=False;
end;

procedure TCreateOnDemandForm.Tree1ExpandingCollapsing(
  Sender: TTreeNodeShape; var Expand: Boolean);
var t           : Integer;
    NumChildren : Integer;
begin
  inherited;

  if Expand then
     if Sender.Children.Count=0 then  // very first time is expanded !
     begin
       // Add children nodes

       NumChildren:=1+Random(5);  // how many ? (random example)

       for t:=1 to NumChildren do
         Sender.AddChild('Child '+IntToStr(t));

       // Set nodes ShowCross property to "scAlways" so the +/- box is
       // always visible, even the node has no children yet.
       for t:=1 to NumChildren do
         Sender.Children[t-1].ShowCross:=scAlways;

     end;
end;

initialization
  RegisterClass(TCreateOnDemandForm);
end.
