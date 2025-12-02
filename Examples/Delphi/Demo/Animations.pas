unit Animations;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs, TreeFlow,
  TreeAnimate, TreeAnimateEditor, ComCtrls, Buttons;

type
  TAnimationsForm = class(TBaseForm)
    Button2: TButton;
    CheckBox1: TCheckBox;
    TrackBar1: TTrackBar;
    Label1: TLabel;
    TreeNodeShape1: TTreeNodeShape;
    TreeAnimate1: TTreeAnimate;
    TFontSizeAnimation1: TFontSizeAnimation;
    TTransparencyAnimation2: TTransparencyAnimation;
    TreeNodeShape2: TTreeNodeShape;
    TVisibleAnimation3: TVisibleAnimation;
    TMovementAnimation4: TMovementAnimation;
    TreeNodeShape3: TTreeNodeShape;
    TMovementAnimation5: TMovementAnimation;
    TFontSizeAnimation6: TFontSizeAnimation;
    TTreeColorAnimation7: TTreeColorAnimation;
    TNodeColorAnimation8: TNodeColorAnimation;
    TNodeColorAnimation9: TNodeColorAnimation;
    TPauseAnimation10: TCustomAnimation;
    TMovementAnimation11: TMovementAnimation;
    TNodeColorAnimation12: TNodeColorAnimation;
    TTransparencyAnimation13: TTransparencyAnimation;
    TAddTextAnimation14: TAddTextAnimation;
    TreeNodeShape4: TTreeNodeShape;
    TreeNodeShape5: TTreeNodeShape;
    TFontSizeAnimation15: TFontSizeAnimation;
    TTreeColorAnimation16: TTreeColorAnimation;
    ArrowRightShape1: TArrowRightShape;
    TNodeColorAnimation17: TNodeColorAnimation;
    TMovementAnimation18: TMovementAnimation;
    TTextAngleAnimation19: TTextAngleAnimation;
    MoveTextAnimation20: TMoveTextAnimation;
    SBPlay: TSpeedButton;
    SBStop: TSpeedButton;
    NodeZoomAnimation21: TNodeZoomAnimation;
    procedure Button2Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure SBPlayClick(Sender: TObject);
    procedure TreeAnimate1Play(Sender: TObject);
    procedure SBStopClick(Sender: TObject);
    procedure TreeAnimate1Stop(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TAnimationsForm.Button2Click(Sender: TObject);
begin
  TTreeAnimateEditor.ModalShow(Self,TreeAnimate1);
end;

procedure TAnimationsForm.CheckBox1Click(Sender: TObject);
begin
  TreeAnimate1.Loop:=CheckBox1.Checked;
end;

procedure TAnimationsForm.TrackBar1Change(Sender: TObject);
begin
  TreeAnimate1.Speed:=TrackBar1.Position;
end;

procedure TAnimationsForm.SBPlayClick(Sender: TObject);
begin
  TreeAnimate1.Play;
end;

procedure TAnimationsForm.TreeAnimate1Play(Sender: TObject);
begin
  SBStop.Enabled:=True;
  SBPlay.Enabled:=False;
end;

procedure TAnimationsForm.SBStopClick(Sender: TObject);
begin
  TreeAnimate1.Stop;
end;

procedure TAnimationsForm.TreeAnimate1Stop(Sender: TObject);
begin
  SBStop.Enabled:=False;
  SBPlay.Enabled:=True;
  SBPlay.Down:=False;
end;

initialization
  RegisterClass(TAnimationsForm);
end.
