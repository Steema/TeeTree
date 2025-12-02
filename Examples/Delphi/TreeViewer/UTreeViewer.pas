unit UTreeViewer;
{$I TeeDefs.inc}

interface

uses
  {$IFNDEF LINUX}
  Windows, SysUtils,
  {$ENDIF}
  Classes, Controls, Forms, Dialogs, ExtCtrls, Buttons,

  TeeProcs, TeeTree, TreeEd, TreeAnimate, TreeAnimateEditor, TeeGDIPlus,
  TeeAnimate;

type
  TViewer = class(TForm)
    Panel1: TPanel;
    Tree1: TTree;
    TreeAnimate1: TTreeAnimate;
    SBOpen: TSpeedButton;
    ButtonPrint: TSpeedButton;
    ButtonPrintPreview: TSpeedButton;
    Bevel1: TBevel;
    SBGrid: TSpeedButton;
    SBAbout: TSpeedButton;
    OpenDialog1: TOpenDialog;
    SBScroll: TSpeedButton;
    Bevel2: TBevel;
    SBEdit: TSpeedButton;
    SBPlay: TSpeedButton;
    SBStop: TSpeedButton;
    procedure SBOpenClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ButtonPrintPreviewClick(Sender: TObject);
    procedure ButtonPrintClick(Sender: TObject);
    procedure SBGridClick(Sender: TObject);
    procedure SBAboutClick(Sender: TObject);
    procedure SBScrollClick(Sender: TObject);
    procedure SBEditClick(Sender: TObject);
    procedure SBPlayClick(Sender: TObject);
    procedure TreeAnimate1Play(Sender: TObject);
    procedure SBStopClick(Sender: TObject);
    procedure TreeAnimate1Stop(Sender: TObject);
  private
    { Private declarations }
    procedure LoadTree(Const FileName:String);
    Procedure ResetTree;
  public
    { Public declarations }
  end;

var
  Viewer: TViewer;

implementation

{$IFNDEF LCL}
{$R *.DFM}
{$ELSE}
{$R *.lfm}
{$ENDIF}

uses
  TreeNavigator, TeePrevi, TreeFlow, TreeElectric, TreeUML, TreeTransit,
  TeeAbout, TreeConst, TeePreviewPanel;

Procedure TViewer.ResetTree;
var tmpEmpty : TTree;
begin
  Tree1.Clear;

  { Create an empty Tree }
  tmpEmpty:=TTree.Create(nil);
  try
    { Assign empty to current }
    Tree1.Assign(tmpEmpty);
  finally
    tmpEmpty.Free;
  end;
end;

procedure TViewer.LoadTree(Const FileName:String);
var tmp : TCustomTree;
begin
  tmp:=TCustomTree(Tree1);
  LoadTreeFromFile(tmp,FileName);
  Tree1:=TTree(tmp);
  SBGrid.Down:=Tree1.Grid.Visible;
end;

procedure TViewer.SBOpenClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    ResetTree;
    LoadTree(OpenDialog1.FileName);
  end;
end;

procedure TViewer.FormShow(Sender: TObject);
begin
  if ParamCount>0 then LoadTree(ParamStr(1));
end;

// Show TeeTree Print Preview dialog.
procedure TreePreview(AOwner:TComponent; Tree:TCustomTree; PrintPanel:Boolean=False);
var OldPrintTeePanel : Boolean;
    OldChange        : Boolean;
begin
  OldPrintTeePanel:=PrintTeePanel;
  PrintTeePanel:=PrintPanel;
  OldChange:=TeeChangePaperOrientation;
  TeeChangePaperOrientation:=False;
  try
    with TChartPreview.Create(AOwner) do
    try
      PageNavigatorClass:=TTreePageNavigator;
      TeePreviewPanel1.Panel:=Tree;
      ShowModal;
    finally
      Free;
      Tree.Invalidate;
    end;
  finally
    TeeChangePaperOrientation:=OldChange;
    PrintTeePanel:=OldPrintTeePanel;
  end;
end;

procedure TViewer.ButtonPrintPreviewClick(Sender: TObject);
var tmpOld : Boolean;
begin
  tmpOld:=Tree1.Grid.Visible;
  Tree1.Grid.Visible:=False;
  try
    TreePreview(Self,Tree1);
  finally
    Tree1.Grid.Visible:=tmpOld;
  end;
end;

procedure TreePrintDialog(Tree:TCustomTree);
var t : Integer;
begin
  With TPrintDialog.Create(nil) do
  try
    if Tree.Page.Count>1 then
    begin
      Options:=Options+[poPageNums];

      MinPage:=1;
      MaxPage:=Tree.Page.Count;

      FromPage:=MinPage;
      ToPage:=MaxPage;
    end;

    if Execute then
       for t:=1 to Copies do Tree.Print;
  finally
    Free;
  end;
end;

procedure TViewer.ButtonPrintClick(Sender: TObject);
begin
  TreePrintDialog(Tree1);
end;

procedure TViewer.SBGridClick(Sender: TObject);
begin
  Tree1.Grid.Visible:=SBGrid.Down;
end;

procedure TViewer.SBAboutClick(Sender: TObject);
begin
  TeeShowTreeAbout('');
end;

procedure TViewer.SBScrollClick(Sender: TObject);
begin
  if SBScroll.Down then
  begin
    Tree1.ScrollMouseButton:=mbLeft;
    Tree1.Zoom.MouseButton:=mbRight;
  end
  else
  begin
    Tree1.ScrollMouseButton:=mbRight;
    Tree1.Zoom.MouseButton:=mbLeft;
  end;
end;

procedure TViewer.SBEditClick(Sender: TObject);
begin
  EditTree(Self,Tree1);
end;

procedure TViewer.SBPlayClick(Sender: TObject);
begin
  TreeAnimate1.Play;
end;

procedure TViewer.TreeAnimate1Play(Sender: TObject);
begin
  SBPlay.Enabled:=False;
  SBStop.Enabled:=True;
end;

procedure TViewer.SBStopClick(Sender: TObject);
begin
  TreeAnimate1.Stop;
end;

procedure TViewer.TreeAnimate1Stop(Sender: TObject);
begin
  SBPlay.Enabled:=True;
  SBStop.Enabled:=False;
end;

initialization
  RegisterCustomTreeShape('Standard','Polygon',TPolygonShape);
  RegisterCustomTreeShape('Standard','PolyLine',TPolyLineShape);
  RegisterCustomTreeShape('Standard','Image',TImageShape);
  RegisterCustomTreeShape('Standard','Text',TTextShape);
finalization
  UnRegisterCustomTreeShapes([TPolygonShape,TPolyLineShape,TImageShape]);
end.
