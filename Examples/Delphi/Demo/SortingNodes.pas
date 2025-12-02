unit SortingNodes;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, StdCtrls, ExtCtrls, TeeTree, TreeEd, TeeProcs;

type
  TSortingNodesForm = class(TBaseForm)
    Button1: TButton;
    RadioGroup1: TRadioGroup;
    procedure RadioGroup1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Tree1SortCompare(Node1, Node2: TTreeNodeShape;
      var Compare: Integer);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TSortingNodesForm.RadioGroup1Click(Sender: TObject);
begin
  // if "Sort by Color" then set the OnSortCompare event...
  if RadioGroup1.ItemIndex=0 then
     Tree1.OnSortCompare:=Tree1SortCompare
  else
  // unset event, do default text sorting...
     Tree1.OnSortCompare:=nil;
end;

procedure TSortingNodesForm.Button1Click(Sender: TObject);
begin
  Tree1.Sort;
end;

// This event is called repeteadly during the sort procedure.
// You should return in "Compare" parameter values -1,0 or 1,
// indicating if Node1 is lower, equal or bigger than Node2.
procedure TSortingNodesForm.Tree1SortCompare(Node1, Node2: TTreeNodeShape;
  var Compare: Integer);
begin
  // This example uses the node Color property to sort items...

  if Node1.Color < Node2.Color then Compare:=-1  // -1 = lower
  else
  if Node1.Color = Node2.Color then Compare:= 0  //  0 = equal
                               else Compare:= 1; //  1 = bigger
end;

procedure TSortingNodesForm.FormCreate(Sender: TObject);
begin
  inherited;

  // Add sample nodes with different colors...

  with Tree1.Add('abc') do
  begin
    Color:=clYellow;
    Expanded:=True;

    Add('123').Color:=clLime;
    Add('456').Color:=clRed;
    Add('789').Color:=clAqua;
    Add('xxx').Color:=clRed;
    Add('ggg').Color:=clLime;
    Add('555').Color:=clYellow;
  end;

  Tree1.Add('zzz').Color:=clAqua;
  Tree1.Add('hhh').Color:=clRed;
  Tree1.Add('000').Color:=clYellow;
  Tree1.Add('123').Color:=clLime;
end;

initialization
  RegisterClass(TSortingNodesForm);
end.
