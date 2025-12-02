unit Unit_FMX_Tree_Columns;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Rtti, System.Classes,
  System.Variants, FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs,
  FMXTee.Tree, FMXTee.Procs;

type
  TTreeColumns = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    Tree1: TTree;
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses FMXTee.Tree.Grid;

procedure TTreeColumns.FormCreate(Sender: TObject);
var Node,
    USA : TTreeNodeShape;
begin
  // Create a normal TTree:
  Tree1:=TTree.Create(Self);
  Tree1.Align:=TAlignLayout.alClient;
  Tree1.Parent:=Self;

  Tree1.Gradient.Visible:=True;
  Tree1.Gradient.EndColor:=TAlphaColors.Lightgray;
  Tree1.BevelInner:=bvNone;
  Tree1.BevelOuter:=bvNone;

  // Add sample nodes, each one with several columns:

  with TGridTree.Create(Tree1) do
  try
    AddHeader(['Continent','Area Sq. Km','Landmass %','Population 2008']);

    AddRoot(['Asia',                  43820000, 0.295, 4164000000]);
    AddRoot(['Africa',                30370000, 0.204, 1022000000]);

    Node:=AddRoot(['Europe',                10180000, 0.068, 738199000]);
    AddChild(Node,['Germany', 81993000]);
    AddChild(Node,['Spain', 47265321]);
    AddChild(Node,['UK', 63181775]);

    Node:=AddRoot(['North America',         24490000, 0.165, 542056000]);
    AddChild(Node,['Canada', 35056064]);
      USA:=AddChild(Node,['USA', 315602000]);
        AddChild(USA,['California', 38041430]);
        AddChild(USA,['Texas', 26059203]);
        AddChild(USA,['New York', 19570261]);

    AddRoot(['South America',         17840000, 0.120, 392555000]);
    AddRoot(['Australia and Oceania',  9038000, 0.059, 378000000]);
    AddRoot(['Antarctica',            14000000, 0.092, 4490]);

    RecalcDimensions;
  finally
    Free;
  end;
end;

end.
