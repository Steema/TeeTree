unit ImageZoom;
{$I TeeDefs.inc}

interface

uses
  Windows, Messages,
  SysUtils, Classes,
  Graphics, Controls, Forms, Dialogs, ExtCtrls, StdCtrls, ComCtrls,
  Base, jpeg, TeeTree, TreeEd, TeeProcs, TreeFlow, TreeUML;

type
  TImageZoomForm = class(TBaseForm)
    ImageShape1: TImageShape;
    Label1: TLabel;
    TrackBar1: TTrackBar;
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeShape3: TTreeNodeShape;
    TreeNodeShape3_TreeNodeShape1: TTreeConnection;
    TreeNodeShape4: TTreeNodeShape;
    TreeNodeShape2_TreeNodeShape4: TTreeConnection;
    TreeNodeShape4_TreeNodeShape1: TTreeConnection;
    TreeNodeShape5: TTreeNodeShape;
    Label2: TLabel;
    TreeNodeShape6: TTreeNodeShape;
    TreeNodeShape7: TTreeNodeShape;
    TreeNodeShape6_TreeNodeShape7: TTreeConnection;
    ActorShape1: TActorShape;
    ArrowDownShape1: TArrowDownShape;
    procedure FormCreate(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TImageZoomForm.FormCreate(Sender: TObject);
begin
  inherited;

  // set node position to 0,0
  // and same size as Image size.
  with ImageShape1 do
  begin
    Left:=0;
    Top:=0;
    Width:=Image.Width;
    Height:=Image.Height;
  end;

  Tree1.Designing:=True;  // set design-mode to allow moving nodes

  // Changing zoom from Tree center 
  Tree1.ZoomCentered:=True;

  TrackBar1.Position:=200;  // default zoom = 200 %
  Tree1.View3DOptions.Zoom:=TrackBar1.Position;

  // Scroll image
  with Tree1.View3DOptions do
  begin
    HorizOffset:= -ImageShape1.Width div 2;
    VertOffset := -ImageShape1.Height div 2;
  end;

  // remove Tree Page border
  Tree1.Page.Border.Visible:=False;
end;

procedure TImageZoomForm.TrackBar1Change(Sender: TObject);
begin
  // change zoom...
  Tree1.View3DOptions.Zoom:=TrackBar1.Position;
  Label2.Caption:=IntToStr(TrackBar1.Position)+'%';
end;

initialization
  RegisterClass(TImageZoomForm);
end.
