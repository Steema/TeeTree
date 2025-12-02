{**********************************************}
{   TTreeAnimate Editor Dialog                 }
{   Copyright (c) 2001-2025 by Steema Software }
{**********************************************}
{$I TeeDefs.inc}
unit TreeAnimateEditor;

interface

uses
  {$IFNDEF LINUX}
  Windows, Messages,
  {$ENDIF}
  SysUtils, Classes,

  Graphics, Controls, Forms, Dialogs, ExtCtrls, Buttons, ComCtrls, StdCtrls, Grids,

  TeeGDIPlus,
  TeeProcs, TeeTree, TreeEd, TeCanvas, TeeAnimate, TreeAnimate, TeeInspector;

type
  TTreeAnimateEditor = class(TForm)
    Panel1: TPanel;
    Panel4: TPanel;
    SBPlay: TSpeedButton;
    SBPause: TSpeedButton;
    SBStop: TSpeedButton;
    SBFrame: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    Label3: TLabel;
    TrackBar1: TTrackBar;
    CBLoop: TCheckBox;
    Splitter1: TSplitter;
    TreeMap: TTree;
    Tree1: TTree;
    PanelAnim: TPanel;
    Ruler: TTreeRuler;
    Splitter2: TSplitter;
    Panel2: TPanel;
    UpScale: TUpDown;
    TeeInspector1: TTeeInspector;
    Panel3: TPanel;
    SBClose: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure TreeMapScroll(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SBPlayClick(Sender: TObject);
    procedure TreeMapAfterDraw(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SBPauseClick(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure SBStopClick(Sender: TObject);
    procedure CBLoopClick(Sender: TObject);
    procedure SBFrameClick(Sender: TObject);
    procedure TreeMapSelectShape(Sender: TTreeNodeShape);
    procedure Tree1SelectShape(Sender: TTreeNodeShape);
    procedure TreeMapDeletedShapes(Sender: TObject);
    procedure TreeMapDeletingShapes(Sender: TSelectedShapeList;
      var AllowDelete: Boolean);
    procedure TreeMapMovingShape(Sender: TTreeNodeShape; var DeltaX,
      DeltaY: Integer);
    procedure TreeMapResizingShape(Sender: TTreeNodeShape;
      ACorner: TTreeShapeHandle; var DeltaX, DeltaY: Integer);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure Tree1DeletedShapes(Sender: TObject);
    procedure RulerGetUnit( Sender:TTreeRuler; Pixel:Integer; var Text:String);
    procedure UpScaleClick(Sender: TObject; Button: TUDBtnType);
    procedure TeeInspector1Items2Change(Sender: TObject);
    procedure TeeInspector1Items3Change(Sender: TObject);
    procedure TeeInspector1Items1Change(Sender: TObject);
    procedure TeeInspector1Items0Change(Sender: TObject);
    procedure TeeInspector1Items4Change(Sender: TObject);
    procedure TeeInspector1Items0GetItems(Sender: TInspectorItem;
      Proc: TGetItemProc);
    procedure TeeInspector1Items6Change(Sender: TObject);
    procedure TeeInspector1Items5Change(Sender: TObject);
    procedure TeeInspector1Items7Change(Sender: TObject);
    procedure TeeInspector1Items8Change(Sender: TObject);
    procedure SBCloseClick(Sender: TObject);
    procedure PanelAnimResize(Sender: TObject);
    procedure TeeInspector1Items9GetItems(Sender: TInspectorItem;
      Proc: TGetItemProc);
    procedure TeeInspector1Items9Change(Sender: TObject);
    procedure TeeInspector1Items10GetItems(Sender: TInspectorItem;
      Proc: TGetItemProc);
    procedure TeeInspector1Items10Change(Sender: TObject);
    procedure TeeInspector1Items11GetItems(Sender: TInspectorItem;
      Proc: TGetItemProc);
    procedure TeeInspector1Items11Change(Sender: TObject);
  private
    { Private declarations }
    FAnimate    : TTreeAnimate;
    FOnModified : TNotifyEvent;
    FEvents     : TTeeAnimateEvents;

    Changing    : Boolean;
    IHorizScale : Integer;  // pixels (width) equalling one frame
    IVertScale  : Integer;

    procedure AnimateDeletedShapes(Sender: TObject);
    procedure AnimateClear(Sender: TObject);
    procedure AnimateContinue(Sender: TObject);
    procedure AnimateFrame(Sender: TObject);
    procedure AnimatePause(Sender: TObject);
    procedure AnimatePlay(Sender: TObject);
    procedure AnimateStop(Sender: TObject);
    Procedure FillNodes;
    Function NodeText(ANode:TTreeNodeShape):String;
    procedure TeeModified;
    Function TheAction:TTeeAnimation;
    Function TheActionBar:TTreeNodeShape;
    Procedure SetActionBarColor;
    procedure SetAnimate(const Value: TTreeAnimate);
  public
    { Public declarations }
    property Animate:TTreeAnimate read FAnimate write SetAnimate;
    class Procedure ModalShow(AOwner:TComponent; TreeAnimate:TTreeAnimate);

    property OnModified:TNotifyEvent read FOnModified write FOnModified;
  end;

implementation

uses TreeAnimationGallery, TeeTranslate, TeePenDlg;

{$IFNDEF LCL}
{$R *.DFM}
{$ELSE}
{$R *.lfm}
{$ENDIF}

class Procedure TTreeAnimateEditor.ModalShow(AOwner:TComponent; TreeAnimate:TTreeAnimate);
begin
  with TTreeAnimateEditor.Create(AOwner) do
  try
    FAnimate:=TreeAnimate;
    ShowModal;
  finally
    Free;
  end;
end;

type
  TNodeAnimate=class(TTreeNodeShape)
  protected
    procedure DoDrawHandle( Handle:TTreeShapeHandle;
                            var x,y:Integer; var Draw:Boolean); override;
  public
    Constructor Create(AOwner:TComponent); override;
    Procedure MoveRelative(OfsX,OfsY:Integer; MoveChilds:Boolean); override;
  end;

procedure TNodeAnimate.DoDrawHandle( Handle:TTreeShapeHandle;
                                     var x,y:Integer; var Draw:Boolean);
begin
  with Tree.Canvas do
  begin
    Brush.Style:=bsSolid;
    Brush.Color:=clNavy;
    Pen.Style:=psSolid;
    Pen.Color:=clBlue;
    Pen.Width:=1;
    Pen.Mode:=pmNotXor;
  end;
  Tree.Selected.HandleSize:=3;
  Draw:=(Handle=rcLeft) or (Handle=rcRight);
end;

procedure TTreeAnimateEditor.FormCreate(Sender: TObject);
begin
  Changing:=True;

  // Default settings for map shapes
  with TreeMap.GlobalFormat do
  begin
    NodeClass:=TNodeAnimate;
    ImageIndex:=tiNone;
    Cursor:=crHandPoint;
  end;

  TreeMap.Designing:=True;

  IHorizScale:=12;  // pixels (width) equalling one frame
  IVertScale:=12;  // pixels (height)
end;

procedure TTreeAnimateEditor.RulerGetUnit( Sender:TTreeRuler; Pixel:Integer;
                                           var Text:String);
begin
  Text:=IntToStr(Pixel div IHorizScale);
end;

procedure TTreeAnimateEditor.TreeMapScroll(Sender: TObject);
begin
  // Synchronize trees
  if Assigned(Tree1) and Assigned(TreeMap) then
     Tree1.View3DOptions.VertOffset:=TreeMap.View3DOptions.VertOffset;
end;

{ TNodeAnimate }

constructor TNodeAnimate.Create(AOwner: TComponent);
begin
  inherited;
  Color:=clBlack;
  Border.Color:=clRed;
  ImageIndex:=tiNone;
  Cursor:=crHandPoint;
end;

procedure TNodeAnimate.MoveRelative(OfsX, OfsY: Integer;
  MoveChilds: Boolean);
begin
  OfsY:=0;
  if OfsX<0 then if Left < -OfsX then OfsX:=0;
  inherited;
end;

type TTreeAnimateAccess=class(TTreeAnimate);

procedure TTreeAnimateEditor.FormShow(Sender: TObject);
begin
  if not Assigned(FAnimate) then exit;

  Tree1.AllowPanning:=pmNone;
  Tree1.TextEditor.Enabled:=False;

  TreeMap.AllowPanning:=pmHorizontal;
  TreeMap.TextEditor.Enabled:=False;

  with TreeMap.Page do
  begin
    Border.Visible:=False;
    UsePrinter:=False;
    Width:=IHorizScale*Animate.EndFrame;
    Height:=TreeMap.ClientHeight;
  end;

  TreeMap.Grid.HorizStep:=IHorizScale;
  TreeMap.Grid.VertStep:=IVertScale;

  TTreeAnimateAccess(Animate).OnDeleteShapes:=AnimateDeletedShapes;

  with (Tree1.GlobalFormat.ChildManager as TTreeExplorerAlignChild) do
  begin
    VertMargin:=-3+((IVertScale-10) div 4);
    TopPos:=0;
  end;

  FillNodes;

  CBLoop.Checked:=Animate.Loop;
  TrackBar1.Position:=Animate.Speed;

  // Replace Onxxx events...
  with TTreeAnimateAccess(Animate) do
  begin
    SaveEvents(FEvents);
    OnContinue:=AnimateContinue;
    OnFrame:=AnimateFrame;
    OnStop:=AnimateStop;
    OnPause:=AnimatePause;
    OnPlay:=AnimatePlay;
    OnClear:=AnimateClear;
  end;

  SBPlay.Enabled:=Animate.State=asStopped;
  SBPause.Enabled:=Animate.State<>asStopped;
  SBStop.Enabled:=SBPause.Enabled;

  TeeTranslateControl(Self);

  Changing:=False;
end;

Procedure TTreeAnimateEditor.FillNodes;
var t : Integer;
begin
  // Add map shapes
  TreeMap.Clear;
  with Animate do
  for t:=0 to Animations.Count-1 do
  with TreeMap.AddRootObject('',Animations[t]) do
  begin
    X0:=IHorizScale*Animations[t].StartFrame;
    Width:=IHorizScale*Animations[t].Duration;
    Y0:=1+(IVertScale*t);
    Height:=8+((IVertScale-10) div 2);
    if not Animations[t].IsEnabled then Color:=clDkGray;
  end;

  // Add left Tree nodes
  Tree1.Clear;
  with Animate do
  for t:=0 to Animations.Count-1 do
  with Tree1.AddRootObject(Animations[t].Description,Animations[t]) do
  begin
    Border.Visible:=False;
    Font.Size:=7+((IVertScale-10) div 4);
    Y0:=1+(IVertScale*t);
    Transparent:=True;
    ImageIndex:=tiNone;
  end;
end;

// When starting playing:
procedure TTreeAnimateEditor.AnimatePlay(Sender: TObject);
begin
  SBPlay.Enabled:=False;
  SBPause.Enabled:=True;
  SBPause.Down:=False;
  SBStop.Enabled:=True;
end;

// When Paused, disable buttons and repaint map
procedure TTreeAnimateEditor.AnimatePause(Sender: TObject);
begin
  SBPause.Down:=True;
  SBFrame.Enabled:=True;
  TreeMap.Invalidate;
end;

// When animation is stopped:
procedure TTreeAnimateEditor.AnimateStop(Sender: TObject);
begin
  if not (csDestroying in ComponentState) then
  begin
    SBPlay.Enabled:=True;
    SBPause.Enabled:=False;
    SBPause.Down:=False;
    SBStop.Enabled:=False;
    SBFrame.Enabled:=False;

    TreeMap.Invalidate;
  end;
end;

procedure TTreeAnimateEditor.AnimateFrame(Sender: TObject);
var P : TPoint;
begin
  P:=TreeMap.Canvas.Calculate3DPosition(IHorizScale*Animate.CurrentFrame,0,TeeTreeZ);

  // if current frame is outside Tree, scroll Tree
  if P.x>TreeMap.ChartWidth then
  begin
    with TreeMap.View3DOptions do HorizOffset:=HorizOffset-20;
  end
  else
  if P.x<0 then
    with TreeMap.View3DOptions do HorizOffset:=HorizOffset-P.x;

  // Repaint tree
  TreeMap.Invalidate;
end;

procedure TTreeAnimateEditor.SBPlayClick(Sender: TObject);
var t : Integer;
begin
  // Set actions
  for t:=0 to TreeMap.Shapes.Count-1 do
  with TTeeAnimation(TreeMap[t].Data) do
  begin
    StartFrame:=TreeMap[t].Left div IHorizScale;
    Duration:=TreeMap[t].Width div IHorizScale;
  end;
  Animate.Play;
end;

procedure TTreeAnimateEditor.TreeMapAfterDraw(Sender: TObject);
var tmp : Integer;
begin
  // Paint animation markers (start, end and current frame)
  if Assigned(Animate) then
  with TreeMap.Canvas do
  begin
    Pen.Color:=clBlack;
    Pen.Style:=psSolid;
    Pen.Width:=1;

    if Animate.EndFrame>0 then
       VertLine3D(1+(Succ(Animate.EndFrame)*IHorizScale),0,TreeMap.Height,TeeTreeZ);

    VertLine3D(-1,0,TreeMap.Height,TeeTreeZ);

    if Animate.State=asPlaying then Pen.Color:=clBlue
    else
    if Animate.State=asPaused then Pen.Color:=clRed
    else
       Exit;

    // Paint CurrentFrame
    tmp:=Animate.CurrentFrame;
    if tmp=-1 then tmp:=Succ(Animate.EndFrame);

    VertLine3D(tmp*IHorizScale,0,TreeMap.Height,TeeTreeZ);
  end;
end;

// Stop the animation and restore old events:
procedure TTreeAnimateEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  with TTreeAnimateAccess(Animate) do
  begin
    Stop;
    RestoreEvents(FEvents);
  end;
end;

// Pause or Continue playing:
procedure TTreeAnimateEditor.SBPauseClick(Sender: TObject);
begin
  if SBPause.Down then Animate.Pause
                  else Animate.Continue;
end;

// Change speed:
procedure TTreeAnimateEditor.TrackBar1Change(Sender: TObject);
begin
  if not Changing then
  begin
    Animate.Speed:=TrackBar1.Position;
    TeeModified;
  end;
end;

// Stop animation:
procedure TTreeAnimateEditor.SBStopClick(Sender: TObject);
begin
  Animate.Stop;
end;

// Set Loop:
procedure TTreeAnimateEditor.CBLoopClick(Sender: TObject);
begin
  if not Changing then
  begin
    Animate.Loop:=CBLoop.Checked;
    TeeModified;
  end;
end;

// Next frame:
procedure TTreeAnimateEditor.SBFrameClick(Sender: TObject);
begin
  Animate.NextFrame;
end;

// Select node in Tree when a bar is selected:
procedure TTreeAnimateEditor.TreeMapSelectShape(Sender: TTreeNodeShape);
begin
  Tree1.Selected.Clear;
  Tree1.Roots[TTeeAnimation(Sender.Data).Index].Selected:=True;
end;

// Select a bar in map when a node in Tree is selected:
procedure TTreeAnimateEditor.Tree1SelectShape(Sender: TTreeNodeShape);

  Procedure DoSelection;
  var tmp     : Boolean;
      tmpIsOk : Boolean;
  begin
    TreeMap.OnSelectShape:=nil;
    TreeMap.Selected.Clear;

    tmp:=Assigned(Sender);

    if tmp then
       TreeMap.Roots[TTeeAnimation(Sender.Data).Index].Selected:=True;

    TreeMap.OnSelectShape:=TreeMapSelectShape;

    TeeInspector1.Enabled:=tmp;

    SpeedButton6.Enabled:=tmp;

    if tmp then
    with TTeeAnimation(Sender.Data) do
    begin
      TeeInspector1.Items[1].Value:=Enabled;
      TeeInspector1.Items[2].Value:=StartFrame;
      TeeInspector1.Items[3].Value:=Duration;
      TeeInspector1.Items[4].Value:=Loop;

      tmpIsOk:=TTeeAnimation(Sender.Data) is TIntegerAnimation;
      TeeInspector1.Items[7].Visible:=tmpIsOk;
      TeeInspector1.Items[8].Visible:=tmpIsOk;

      if tmpIsOk then
      with TIntegerAnimation(Sender.Data) do
      begin
        TeeInspector1.Items[7].Value:=StartValue;
        TeeInspector1.Items[8].Value:=EndValue;
      end;

      tmpIsOk:=TTeeAnimation(Sender.Data) is TColorAnimation;
      TeeInspector1.Items[5].Visible:=tmpIsOk;
      TeeInspector1.Items[6].Visible:=TeeInspector1.Items[5].Visible;

      if tmpIsOk then
      begin
        TeeInspector1.Items[5].Value:=TColorAnimation(Sender.Data).StartColor;
        TeeInspector1.Items[6].Value:=TColorAnimation(Sender.Data).EndColor;
      end;

      if TTeeAnimation(Sender.Data) is TNodeAnimation then
      begin
        TeeInspector1.Items[0].Visible:=True;
        with TNodeAnimation(Sender.Data) do
        begin
          TeeInspector1.Items[0].Value:=NodeText(Node);
          TeeInspector1.Items[0].Data:=Node;
        end;
      end
      else
      begin
        TeeInspector1.Items[0].Visible:=False;
      end;

      { Direction Animation }
      if TTeeAnimation(Sender.Data) is TMovementAnimation then
      begin
        with TMovementAnimation(Sender.Data) do
        begin
          TeeInspector1.Items[10].Visible := True;
          TeeInspector1.Items[9].Visible := True;
          TeeInspector1.Items[9].Value := MoveSizeDirection[Direction];
          TeeInspector1.Items[9].Data:= TObject(Direction);
        end;
      end
      else
        TeeInspector1.Items[9].Visible := False;

      {NodeColor}
      if TTeeAnimation(Sender.Data) is TNodeColorAnimation then
      begin
        with TNodeColorAnimation(Sender.Data) do
        begin
          TeeInspector1.Items[10].Visible := True;
          TeeInspector1.Items[10].Value := TreeAnimate.NodeColor[NodeColor];
          TeeInspector1.Items[10].Data:= TObject(NodeColor);
        end;
      end
      else
        TeeInspector1.Items[10].Visible := False;

      {TreeColor}
      if TTeeAnimation(Sender.Data) is TTreeColorAnimation then
      begin
        with TTreeColorAnimation(Sender.Data) do
        begin
          TeeInspector1.Items[0].Visible := False;
          TeeInspector1.Items[11].Visible := True;
          TeeInspector1.Items[11].Value := TreeAnimate.TreeColor[TreeColor];
          TeeInspector1.Items[11].Data:= TObject(TreeColor);
        end;
      end
      else
        TeeInspector1.Items[11].Visible := False;

      {ZoomPercent}
      if TTeeAnimation(Sender.Data) is TNodeZoomAnimation then
      begin
        with TNodeZoomAnimation(Sender.Data) do
        begin
          TeeInspector1.Items[12].Visible := True;
          TeeInspector1.Items[12].Value := ZoomPercent;
        end;
      end
      else
        TeeInspector1.Items[12].Visible := False;

      {SizePercent}
      if TTeeAnimation(Sender.Data) is TTextFlashAnimation then
      begin
        with TTextFlashAnimation(Sender.Data) do
        begin
          TeeInspector1.Items[13].Visible := True;
          TeeInspector1.Items[13].Value := SizePercent;
        end;
      end
      else
        TeeInspector1.Items[13].Visible := False;

    end
    else
    begin
      TeeInspector1.Items[0].Visible:=False;
      TeeInspector1.Items[5].Visible:=False;
      TeeInspector1.Items[6].Visible:=False;
      TeeInspector1.Items[7].Visible:=False;
      TeeInspector1.Items[8].Visible:=False;
      TeeInspector1.Items[9].Visible:=False;
      TeeInspector1.Items[10].Visible:=False;
      TeeInspector1.Items[11].Visible:=False;
      TeeInspector1.Items[12].Visible:=False;
      TeeInspector1.Items[13].Visible:=False;
    end;
  end;

begin
  Changing:=True;
  try
    DoSelection;
  finally
    Changing:=False;
  end;
end;

procedure TTreeAnimateEditor.AnimateDeletedShapes(Sender: TObject);
begin
  if Assigned(Tree1) then Tree1SelectShape(Tree1.Selected.First);
end;

procedure TTreeAnimateEditor.AnimateClear(Sender: TObject);
begin
  FillNodes;
end;

procedure TTreeAnimateEditor.TreeMapDeletedShapes(Sender: TObject);
begin
  SpeedButton6Click(Sender);
end;

procedure TTreeAnimateEditor.TreeMapDeletingShapes(
  Sender: TSelectedShapeList; var AllowDelete: Boolean);
begin
  TTeeAnimation(Sender.First.Data).Free;
  Tree1.Roots[TreeMap.Roots.IndexOf(Sender.First)].Free;
end;

Function TTreeAnimateEditor.TheActionBar:TTreeNodeShape;
begin
  result:=TreeMap.Roots[Tree1.Roots.IndexOf(Tree1.Selected.First)];
end;

Function TTreeAnimateEditor.TheAction:TTeeAnimation;
begin
  if Tree1.Selected.First<>nil then
     result:=TTeeAnimation(Tree1.Selected.First.Data)
  else
     result:=nil;
end;

procedure TTreeAnimateEditor.TreeMapMovingShape(Sender: TTreeNodeShape;
  var DeltaX, DeltaY: Integer);
var tmp : Integer;
begin
  DeltaY:=0; // prevent moving vertically

  tmp:=(DeltaX div IHorizScale);

  with TTeeAnimation(Sender.Data) do
  begin
    if (StartFrame+tmp)>0 then StartFrame:=StartFrame+tmp
                          else StartFrame:=0;
    Sender.X0:=StartFrame*IHorizScale;
    DeltaX:=0;

    TeeInspector1.Items[2].Value:=StartFrame;
  end;
end;

procedure TTreeAnimateEditor.TreeMapResizingShape(Sender: TTreeNodeShape;
  ACorner: TTreeShapeHandle; var DeltaX, DeltaY: Integer);
var tmp : Integer;
begin
  DeltaY:=0; // prevent resizing vertically

  tmp:=(DeltaX div IHorizScale);

  with TTeeAnimation(Sender.Data) do
  begin
    if ACorner=rcLeft then
    begin
      if (Duration-tmp)>0 then
      begin
        Duration:=Duration-tmp;
        StartFrame:=StartFrame+tmp;
        Sender.Left:=StartFrame*IHorizScale;
        TeeInspector1.Items[2].Value:=StartFrame;
      end;
    end
    else
    begin
      if (Duration+tmp)>1 then Duration:=Duration+tmp
                          else Duration:=1;
    end;

    Sender.Width:=Duration*IHorizScale;
    TeeInspector1.Items[3].Value:=Duration;
    DeltaX:=0;
  end;
end;

procedure TTreeAnimateEditor.SpeedButton6Click(Sender: TObject);
begin
  TheAction.Free;
  FillNodes;
  SpeedButton6.Enabled:=Animate.Animations.Count>0;
  Tree1SelectShape(Tree1.Selected.First);
  TeeModified;
end;

procedure TTreeAnimateEditor.SpeedButton5Click(Sender: TObject);
var tmp      : TTeeAnimation;
    tmpClass : TTeeAnimationClass;
    tmpSt    : String;
begin
  tmpClass:=TTreeAnimationGallery.Select;

  if Assigned(tmpClass) then
  begin
    tmp:=tmpClass.Create(Animate.Owner);
    tmpSt:=tmp.ClassName+IntToStr(Animate.Animations.Count+1);
    if Copy(tmpSt,1,1)='T' then Delete(tmpSt,1,1);
    tmp.Name:=tmpSt;

    Animate.Animations.Add(tmp);
    FillNodes;
    TreeMap.Roots.Last.Selected:=True;
    TeeModified;
  end;
end;

procedure TTreeAnimateEditor.TeeModified;
begin
  if Assigned(FOnModified) then FOnModified(Self);
end;

type TAnimationAccess=class(TTeeAnimation);

procedure TTreeAnimateEditor.AnimateContinue(Sender: TObject);
begin
  SBPause.Down:=False;
  SBFrame.Enabled:=False;
end;

procedure TTreeAnimateEditor.Tree1DeletedShapes(Sender: TObject);
begin
  SpeedButton6Click(Sender);
end;

procedure TTreeAnimateEditor.SetAnimate(const Value: TTreeAnimate);
begin
  FAnimate:=Value;
  FormShow(Self);
end;

procedure TTreeAnimateEditor.UpScaleClick(Sender: TObject;
  Button: TUDBtnType);
begin
  if UpScale.Position<3 then IHorizScale:=12*(4-UpScale.Position)
                        else IHorizScale:=12 div (UpScale.Position-2);

  TreeMap.Grid.HorizStep:=IHorizScale;
  FillNodes;
end;

procedure TTreeAnimateEditor.TeeInspector1Items2Change(Sender: TObject);
begin
  TheAction.StartFrame:=TInspectorItem(Sender).Value;
  TheActionBar.Left:=TheAction.StartFrame*IHorizScale;
  TeeModified;
end;

procedure TTreeAnimateEditor.TeeInspector1Items3Change(Sender: TObject);
var tmp : Integer;
begin
  tmp:=TInspectorItem(Sender).Value;

  if TheAction.Duration<>tmp then
  begin
    TheAction.Duration:=tmp;
    TheActionBar.Width:=IHorizScale*tmp;
    TeeModified;
  end;
end;

procedure TTreeAnimateEditor.TeeInspector1Items1Change(Sender: TObject);
begin
  if TheAction.Enabled<>TInspectorItem(Sender).Value then
  begin
    TheAction.Enabled:=TInspectorItem(Sender).Value;
    TeeModified;
  end;

  SetActionBarColor;
end;

procedure TTreeAnimateEditor.TeeInspector1Items0Change(Sender: TObject);
var tmp : TTreeNodeShape;
begin
  if TheAction is TNodeAnimation then
  begin
    tmp:=TNodeAnimation(TheAction).Node;
    TNodeAnimation(TheAction).Node:=TTreeNodeShape(TInspectorItem(Sender).Data);

    if not Assigned(tmp) then
    begin
      TAnimationAccess(TheAction).NewNode;

      Tree1SelectShape(Tree1.Selected.First);
    end;

    TeeInspector1Items1Change(TeeInspector1.Items[1]);

    TeeModified;
  end;
end;

procedure TTreeAnimateEditor.TeeInspector1Items4Change(Sender: TObject);
begin
  if TheAction.Loop<>TInspectorItem(Sender).Value then
  begin
    TheAction.Loop:=TInspectorItem(Sender).Value;
    TeeModified;
  end;
  SetActionBarColor;
end;

Procedure TTreeAnimateEditor.SetActionBarColor;
begin
  if TheAction.IsEnabled then
     if TheAction.Loop then TheActionBar.Color:=clBlue
                       else TheActionBar.Color:=clBlack
  else
     TheActionBar.Color:=clDkGray;
end;

Function TTreeAnimateEditor.NodeText(ANode:TTreeNodeShape):String;
begin
  if Assigned(ANode) then
  begin
    result:=ANode.SimpleText;
    if result='' then
    begin
      result:=ANode.Name;
      if result='' then result:='Node '+IntToStr(ANode.Tree.Shapes.IndexOf(ANode));
    end;
  end
  else result:='';
end;

procedure TTreeAnimateEditor.TeeInspector1Items0GetItems(
  Sender: TInspectorItem; Proc: TGetItemProc);
var t : Integer;
begin
  if Assigned(Animate.Tree) then
  for t:=0 to Animate.Tree.Shapes.Count-1 do
      Proc(NodeText(Animate.Tree[t]),Animate.Tree[t]);
end;

procedure TTreeAnimateEditor.TeeInspector1Items6Change(Sender: TObject);
begin
  TColorAnimation(TheAction).EndColor:=TInspectorItem(Sender).Value;
  TeeModified;
end;

procedure TTreeAnimateEditor.TeeInspector1Items5Change(Sender: TObject);
begin
  TColorAnimation(TheAction).StartColor:=TInspectorItem(Sender).Value;
  TeeModified;
end;

procedure TTreeAnimateEditor.TeeInspector1Items7Change(Sender: TObject);
begin
  if TheAction is TIntegerAnimation then
  with TIntegerAnimation(TheAction) do
  begin
    StartValue:=TInspectorItem(Sender).Value;
    TeeModified;
  end;
end;

procedure TTreeAnimateEditor.TeeInspector1Items8Change(Sender: TObject);
begin
  if TheAction is TIntegerAnimation then
  with TIntegerAnimation(TheAction) do
  begin
    EndValue:=TInspectorItem(Sender).Value;
    TeeModified;
  end;
end;

procedure TTreeAnimateEditor.SBCloseClick(Sender: TObject);
begin
  PanelAnim.Hide;
  Splitter2.Hide;
end;

procedure TTreeAnimateEditor.PanelAnimResize(Sender: TObject);
begin
  SBClose.Left:=PanelAnim.Width-20;
end;

procedure TTreeAnimateEditor.TeeInspector1Items9GetItems(
  Sender: TInspectorItem; Proc: TGetItemProc);
var t: Integer;
begin
  for t:=0 to Length(MoveSizeDirection)-1 do
      Proc(MoveSizeDirection[TMoveSizeDirection(t)],TObject(t));
end;

procedure TTreeAnimateEditor.TeeInspector1Items9Change(Sender: TObject);
var tmp : TMoveSizeDirection;
begin
  if TheAction is TMovementAnimation then
  begin
    tmp := TMoveSizeDirection(TInspectorItem(Sender).Data);

    with TMovementAnimation(TheAction) do
    begin
      if Direction <> tmp then
      begin
        Direction:= tmp;
        TeeModified;
      end;
    end;
  end;
end;

procedure TTreeAnimateEditor.TeeInspector1Items10GetItems(Sender: TInspectorItem; Proc: TGetItemProc);
var t: Integer;
begin
  for t:=0 to Length(NodeColor)-1 do
      Proc(NodeColor[TNodeColor(t)],TObject(t));
end;

procedure TTreeAnimateEditor.TeeInspector1Items10Change(Sender: TObject);
var tmp : TNodeColor;
begin
  if TheAction is TNodeColorAnimation then
  begin
    tmp := TNodeColor(TInspectorItem(Sender).Data);

    with TNodeColorAnimation(TheAction) do
    begin
      if NodeColor <> tmp then
      begin
        NodeColor:= tmp;
        TeeModified;
      end;
    end;
  end;
end;

procedure TTreeAnimateEditor.TeeInspector1Items11GetItems(Sender: TInspectorItem; Proc: TGetItemProc);
var t: Integer;
begin
  for t:=0 to Length(TreeColor)-1 do
      Proc(TreeColor[TTreeColor(t)],TObject(t));
end;

procedure TTreeAnimateEditor.TeeInspector1Items11Change(Sender: TObject);
var tmp : TTreeColor;
begin
  if TheAction is TTreeColorAnimation then
  begin
    tmp := TTreeColor(TInspectorItem(Sender).Data);

    with TTreeColorAnimation(TheAction) do
    begin
      if TreeColor <> tmp then
      begin
        TreeColor:= tmp;
        TeeModified;
      end;
    end;
  end;
end;

end.
