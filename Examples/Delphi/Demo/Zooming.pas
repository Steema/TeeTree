unit Zooming;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs, TreeTransit,
  TreeUML, TreeElectric, TreeFlow, ComCtrls;

type
  TZoomingForm = class(TBaseForm)
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeShape3: TTreeNodeShape;
    TreeNodeShape4: TTreeNodeShape;
    TreeNodeShape5: TTreeNodeShape;
    TreeNodeShape6: TTreeNodeShape;
    TreeNodeShape7: TTreeNodeShape;
    TreeNodeShape8: TTreeNodeShape;
    TitleShape1: TTitleShape;
    SelectShape1: TSelectShape;
    ProcessShape1: TProcessShape;
    CardShape1: TCardShape;
    ManualShape1: TManualShape;
    AndShape1: TAndShape;
    TapeShape1: TTapeShape;
    CrossShape1: TCrossShape;
    HouseShape1: THouseShape;
    ArrowUpShape1: TArrowUpShape;
    HexagonShape1: THexagonShape;
    PentagonShape1: TPentagonShape;
    TriangleRectLeftShape1: TTriangleRectLeftShape;
    OrGateShape1: TOrGateShape;
    AndGateShape1: TAndGateShape;
    SolidResistorShape1: TSolidResistorShape;
    ProcShape1: TProcShape;
    SlowShape1: TSlowShape;
    PolygonShape1: TPolygonShape;
    Label1: TLabel;
    TrackBar1: TTrackBar;
    Button1: TButton;
    Label2: TLabel;
    CheckBox1: TCheckBox;
    procedure TrackBar1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Tree1Zoom(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
    ChangingZoom : Boolean;
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TZoomingForm.TrackBar1Change(Sender: TObject);
begin
  ChangingZoom:=True;

  // Change zoom
  Tree1.View3DOptions.Zoom:=TrackBar1.Position;
  Label2.Caption:=TeeStr(Tree1.View3DOptions.Zoom)+'%';

  // Enable or disable "Reset" button
  Button1.Enabled:=TrackBar1.Position<>100;

  ChangingZoom:=False;
end;

procedure TZoomingForm.Button1Click(Sender: TObject);
begin
  // Reset default view
  TrackBar1.Position:=100;
  Tree1.View3DOptions.Zoom:=100;
  Tree1.View3DOptions.HorizOffset:=0;
  Tree1.View3DOptions.VertOffset:=0;

  Tree1Zoom(Sender);  // call OnZoom event
end;

procedure TZoomingForm.Tree1Zoom(Sender: TObject);
begin
  if not ChangingZoom then
  begin
    // Show % percent of zoom in label
    Label2.Caption:=TeeStr(Tree1.View3DOptions.Zoom)+'%';

    TrackBar1.Position:=Tree1.View3DOptions.Zoom;

    // Enable or disable "Reset" button
    Button1.Enabled:=TrackBar1.Position<>100;
  end;
end;

procedure TZoomingForm.FormCreate(Sender: TObject);
begin
  inherited;
  TrackBar1.Position:=100;
end;

procedure TZoomingForm.CheckBox1Click(Sender: TObject);
begin
  Tree1.ZoomCentered:=CheckBox1.Checked;
end;

initialization
  RegisterClass(TZoomingForm);
end.
