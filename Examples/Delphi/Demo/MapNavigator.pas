unit MapNavigator;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Base, TeeGDIPlus, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs,
  TreeMapNavigator, TeCanvas;

type
  TTreeMapNavigatorForm = class(TBaseForm)
    TreeNodeShape1: TTreeNodeShape;
    TreeNavigator1: TTreeNavigator;
    CBClickOnMap: TCheckBox;
    CBScrollOutside: TCheckBox;
    Label2: TLabel;
    CBQuality: TComboFlat;
    Splitter1: TSplitter;
    procedure FormCreate(Sender: TObject);
    procedure Tree1Scroll(Sender: TObject);
    procedure CBScrollOutsideClick(Sender: TObject);
    procedure CBClickOnMapClick(Sender: TObject);
    procedure CBQualityChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses
  RandomNodes;
  
procedure TTreeMapNavigatorForm.FormCreate(Sender: TObject);
begin
  inherited;

  // Cosmetic settings:
  Tree1.Page.Border.Hide;

  Tree1.BevelInner:=bvNone;
  Tree1.BevelOuter:=bvNone;

  // Pending to support Zoom
  Tree1.Zoom.Allow:=False;

  // Add lots of Tree nodes, at random positions and colors:
  AddRandomNodes(Tree1);

  // Example, changing the small rectangle format:
  // TreeNavigator1.Selector.Border.Color:=clLime;

  // Disabled zoom by default:
  Tree1.Zoom.Allow:=False;
end;

procedure TTreeMapNavigatorForm.Tree1Scroll(Sender: TObject);
begin
  inherited;
  TreeNavigator1.Reposition;
end;

procedure TTreeMapNavigatorForm.CBScrollOutsideClick(Sender: TObject);
begin
  TreeNavigator1.ScrollOutside:=CBScrollOutside.Checked;
end;

procedure TTreeMapNavigatorForm.CBClickOnMapClick(Sender: TObject);
begin
  TreeNavigator1.ClickToNavigate:=CBClickOnMap.Checked;
end;

procedure TTreeMapNavigatorForm.CBQualityChange(Sender: TObject);
begin
  case CBQuality.ItemIndex of
    0: TreeNavigator1.Quality:=nqLow;
    1: TreeNavigator1.Quality:=nqNormal;
    2: TreeNavigator1.Quality:=nqHigh;
  else
    TreeNavigator1.Quality:=nqHighest;
  end;
end;

initialization
  RegisterClass(TTreeMapNavigatorForm);
end.
