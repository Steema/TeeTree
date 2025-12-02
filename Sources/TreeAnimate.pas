{**********************************************}
{   TTreeAnimate Component                     }
{   Copyright (c) 2001-2025 by Steema Software }
{**********************************************}
{$I TeeDefs.inc}
unit TreeAnimate;

interface

uses
  {$IFNDEF LINUX}
  Windows,
  {$ENDIF}

  ExtCtrls, Graphics, Controls, Classes, SysUtils,

  {$IFDEF D18}
  System.UITypes,
  {$ENDIF}
  
  TeeProcs, TeeAnimate, TeeTree;

type
  TTreeAnimate=class(TTeeAnimate)
  private
    FTree : TCustomTree;
    procedure SetTree(const Value: TCustomTree);
  protected
    procedure Notification( AComponent: TComponent;
                            Operation: TOperation); override;
  published
    property Tree:TCustomTree read FTree write SetTree;
  end;

  TNodeAnimation=class(TTeeAnimation)
  private
    FNode : TTreeNodeShape;

    procedure SetNode(const ANode:TTreeNodeShape);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    function Animate:TTreeAnimate;
    Function IsEnabled:Boolean; override;
    class function IsValidOwner(const AObject:TObject):Boolean; override;
    Procedure Preview; override;

    property Node:TTreeNodeShape read FNode write SetNode;
  end;

  TIntegerAnimation=class(TNodeAnimation)
  private
    FEndValue   : Integer;
    FStartValue : Integer;

    OldValue    : Integer;
    Procedure SetEndValue(const Value:Integer);
  protected
    function EndAnimation:Boolean; override;
    Function GetValue:Integer; virtual; abstract;
    Procedure NewNode; override;
    Procedure NextFrame(const Fraction:Single); override;
    Procedure SetValue(AValue:Integer); virtual; abstract;
  public
    Procedure Play; override;
    Procedure StoreValue; override;

    property Value:Integer read GetValue write SetValue;
  published
    property EndValue:Integer read FEndValue write SetEndValue default 0;
    property Node;
    property StartValue:Integer read FStartValue write FStartValue default 0;
  end;

  TFontSizeAnimation=class(TIntegerAnimation)
  protected
    Function GetValue:Integer; override;
    Procedure SetValue(AValue:Integer); override;
  public
    Procedure Preview; override;
  end;

  TMoveSizeDirection=(mdHorizontal, mdVertical);

  TMovementAnimation=class(TIntegerAnimation)
  private
    FDirection : TMoveSizeDirection;
  protected
    Function GetValue:Integer; override;
    Procedure SetValue(AValue:Integer); override;
  public
    Procedure Preview; override;
  published
    property Direction:TMoveSizeDirection read FDirection write FDirection;
  end;

  TTransparencyAnimation=class(TIntegerAnimation)
  protected
    Function GetValue:Integer; override;
    Procedure SetValue(AValue:Integer); override;
  public
    Procedure Preview; override;
  end;

  TTextTranspAnimation=class(TIntegerAnimation)
  protected
    Function GetValue:Integer; override;
    Procedure SetValue(AValue:Integer); override;
  public
    Procedure Preview; override;
  end;

  TSizeAnimation=class(TIntegerAnimation)
  private
    FDirection : TMoveSizeDirection;
  protected
    Function GetValue:Integer; override;
    Procedure SetValue(AValue:Integer); override;
  published
    property Direction:TMoveSizeDirection read FDirection write FDirection;
  end;

  TBooleanAnimation=class(TNodeAnimation)
  private
    FNewValue : Boolean;
    OldValue  : Boolean;
  protected
    function EndAnimation:Boolean; override;
    Function GetValue:Boolean; virtual; abstract;
    Procedure NewNode; override;
    Procedure NextFrame(const Fraction:Single); override;
    Procedure SetValue(AValue:Boolean); virtual; abstract;
  public
    Procedure StoreValue; override;
    property Value:Boolean read GetValue write SetValue;
  published
    property NewValue:Boolean read FNewValue write FNewValue;
    property Node;
  end;

  TVisibleAnimation=class(TBooleanAnimation)
  protected
    Function GetValue:Boolean; override;
    Procedure SetValue(AValue:Boolean); override;
  public
    Procedure Stop; override;
  end;

  TColorAnimation=class(TNodeAnimation)
  private
    FEndColor   : TColor;
    FStartColor : TColor;

    OldColor    : TColor;
  protected
    function EndAnimation:Boolean; override;
    Function GetColor:TColor; virtual; abstract;
    Procedure NewNode; override;
    Procedure NextFrame(const Fraction:Single); override;
    Procedure SetColor(AColor:TColor); virtual; abstract;
  public
    Constructor Create(AOwner: TComponent); override;

    Procedure Play; override;
    Procedure StoreValue; override;

    property Value:TColor read GetColor write SetColor;
  published
    property EndColor:TColor read FEndColor write FEndColor default clNone;
    property StartColor:TColor read FStartColor write FStartColor default clNone;
  end;

  TNodeColor=(ncColor,ncBorder,ncFont,ncGradientStart,ncGradientEnd,ncGradientMiddle);

  TNodeColorAnimation=class(TColorAnimation)
  private
    FColor : TNodeColor;
  protected
    Function GetColor:TColor; override;
    Procedure SetColor(AColor:TColor); override;
  public
    Procedure Preview; override;
  published
    property Node;
    property NodeColor:TNodeColor read FColor write FColor default ncColor;
  end;

  TTreeColor=(tcColor,tcGrid,tcGradientStart,tcGradientEnd,tcGradientMiddle);

  TTreeColorAnimation=class(TColorAnimation)
  private
    FColor : TTreeColor;
  protected
    Function GetColor:TColor; override;
    Procedure SetColor(AColor:TColor); override;
  public
    Function IsEnabled:Boolean; override;
    Procedure Preview; override;
  published
    property TreeColor:TTreeColor read FColor write FColor;
  end;

  TCustomAnimation=class(TTeeAnimation);

  TAddTextAnimation=class(TNodeAnimation)
  private
    OldText : String;
  protected
    function EndAnimation:Boolean; override;
    Procedure NextFrame(const Fraction:Single); override;
  public
    Procedure Play; override;
    Procedure Preview; override;
    Procedure StoreValue; override;
  published
    property Node;
  end;

  TMoveTextAnimation=class(TNodeAnimation)
  private
    OldOffset : Integer;
  protected
    function EndAnimation:Boolean; override;
    Procedure NextFrame(const Fraction:Single); override;
  public
    Procedure Play; override;
    Procedure StoreValue; override;
  published
    property Node;
  end;

  TTextAngleAnimation=class(TIntegerAnimation)
  protected
    Function GetValue:Integer; override;
    Procedure SetValue(AValue:Integer); override;
  public
    Procedure Preview; override;
  end;

  TTextFlashAnimation=class(TNodeAnimation)
  private
    OldSize      : Integer;
    StartSize    : Integer;
    FSizePercent : Integer;
  protected
    function EndAnimation:Boolean; override;
    Procedure NextFrame(const Fraction:Single); override;
  public
    Constructor Create(AOwner: TComponent); override;

    Procedure Play; override;
    Procedure StoreValue; override;
  published
    property Node;
    property SizePercent:Integer read FSizePercent write FSizePercent default 100;
  end;

  TTextColorAnimation=class(TColorAnimation)
  protected
    Function GetColor:TColor; override;
    Procedure SetColor(AColor:TColor); override;
  public
    Procedure Preview; override;
  published
    property Node;
  end;

  TNodeZoomAnimation=class(TNodeAnimation)
  private
    FZoomPercent : Integer;
    OldBounds    : TRect;
    Procedure SetNodeBounds(Const R:TRect);
  protected
    function EndAnimation:Boolean; override;
    Procedure NextFrame(const Fraction:Single); override;
  public
    Constructor Create(AOwner: TComponent); override;

    Procedure Preview; override;
    Procedure StoreValue; override;
  published
    property Node;
    property ZoomPercent:Integer read FZoomPercent write FZoomPercent default 100;
  end;

const
  MoveSizeDirection: Array[TMoveSizeDirection] of String =('Horizontal','Vertical');

  NodeColor: Array[TNodeColor] of String = ('Color', 'Border', 'Font',
                                            'GradientStart', 'GradientEnd',
                                            'GradientMiddle');

  TreeColor: Array[TTreeColor] of String = ('Color', 'Grid',
                                            'GradientStart', 'GradientEnd',
                                            'GradientMiddle');

implementation

uses
  TeCanvas;

{ TNodeAnimation }

procedure TNodeAnimation.SetNode(const ANode: TTreeNodeShape);
begin
  if FNode<>ANode then
  begin
    if Assigned(FNode) then
       FNode.RemoveFreeNotification(Self);

    FNode:=ANode;

    if Assigned(FNode) then
       FNode.FreeNotification(Self);
  end;
end;

class function TNodeAnimation.IsValidOwner(const AObject:TObject):Boolean;
begin
  result:=AObject is TCustomTree;
end;

procedure TNodeAnimation.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;

  if not (csDestroying in ComponentState) then 
  if Operation=opRemove then
  begin
    if Assigned(FNode) and (AComponent=FNode) then
    begin
      // Node has been destroyed. Set Action Node to nil.
      FNode:=nil;

      // Call event
      if Assigned(Animate.OnDeleteShapes) then
         Animate.OnDeleteShapes(AComponent);
    end;
  end;
end;

function TNodeAnimation.IsEnabled: Boolean;
begin
  result:=inherited IsEnabled and Assigned(FNode);
end;

procedure TNodeAnimation.Preview;
begin
  // Do not call abstract "inherited" here
  Node:=Animate.Tree[0];
end;

function TNodeAnimation.Animate: TTreeAnimate;
begin
  result:=TTreeAnimate(IAnimate);
end;

{ TFontSizeAnimation }

procedure TFontSizeAnimation.SetValue(AValue: Integer);
begin
  Node.Font.Size:=AValue;
end;

function TFontSizeAnimation.GetValue: Integer;
begin
  result:=Node.Font.Size;
end;

procedure TFontSizeAnimation.Preview;
begin
  inherited;
  FStartValue:=Node.Font.Size;
  FEndValue:=Node.Font.Size*2;
end;

{ TMovementAnimation }

procedure TMovementAnimation.SetValue(AValue: Integer);
begin
  Case FDirection of
    mdHorizontal : Node.Left:=AValue;
    mdVertical   : Node.Top:=AValue;
  end;
end;

function TMovementAnimation.GetValue: Integer;
begin
  if FDirection=mdHorizontal then result:=Node.Left
                             else result:=Node.Top;
end;

procedure TMovementAnimation.Preview;
begin
  inherited;
  Node.Tree.HorzScrollBar.Automatic:=False;

  with Node.Border do
  begin
    Visible:=True;
    Width:=2;
    EndStyle:=esFlat;
  end;

  FStartValue:=Node.Tree.Width;
  FEndValue:=-Node.Width-Node.Border.Width;

  Animate.Speed:=10;
end;

{ TIntegerAnimation }

procedure TIntegerAnimation.NextFrame(const Fraction:Single);
var tmp,
    tmpEnd,
    tmpStart : Integer;
begin
  tmpStart:=StartValue;
  tmpEnd:=EndValue;

  tmp:=tmpStart+Round(Fraction*(tmpEnd-tmpStart));
  Value:=tmp;

  if tmpEnd>=tmpStart then
  begin
    if tmp>=FEndValue then Stop;
  end
  else
    if tmp<=FEndValue then Stop;

  inherited;
end;

procedure TIntegerAnimation.Play;
begin
  if IPlaying=asStopped then Value:=FStartValue;
  inherited;
end;

function TIntegerAnimation.EndAnimation:Boolean;
begin
  if not (csDestroying in ComponentState) then
     Value:=OldValue;

  result:=inherited EndAnimation;
end;

Procedure TIntegerAnimation.NewNode;
begin
  if Assigned(IAnimate) and (not (csLoading in IAnimate.ComponentState)) then
  if Assigned(Node) then 
  begin
    if FStartValue=0 then FStartValue:=Value;
    if FEndValue=0 then FEndValue:=Value;
  end;
end;

procedure TIntegerAnimation.StoreValue;
begin
  inherited;
  OldValue:=Value;
end;

procedure TIntegerAnimation.SetEndValue(const Value: Integer);
begin
  FEndValue:=Value;
end;

{ TTransparencyAnimation }

procedure TTransparencyAnimation.SetValue(AValue: Integer);
begin
  Node.Transparency:=AValue;
end;

function TTransparencyAnimation.GetValue: Integer;
begin
  result:=Node.Transparency;
end;

procedure TTransparencyAnimation.Preview;
begin
  inherited;
  Node.Transparent:=False;
  Node.Color:=clYellow;
  FStartValue:=0;
  FEndValue:=100;
end;

{ TSizeAnimation }

procedure TSizeAnimation.SetValue(AValue: Integer);
begin
  Case FDirection of
    mdHorizontal : Node.Width:=AValue;
    mdVertical   : Node.Height:=AValue;
  end;
end;

function TSizeAnimation.GetValue: Integer;
begin
  if FDirection=mdHorizontal then result:=Node.Width
                             else result:=Node.Height;
end;

{ TBoolAnimation }

procedure TBooleanAnimation.NewNode;
begin
  if Assigned(IAnimate) and (not (csLoading in IAnimate.ComponentState)) then
     FNewValue:=not Value;
end;

procedure TBooleanAnimation.NextFrame;
begin
  Value:=NewValue;
  inherited;
end;

function TBooleanAnimation.EndAnimation:Boolean;
begin
  if not (csDestroying in ComponentState) then
     Value:=OldValue;

  result:=inherited EndAnimation;
end;

procedure TBooleanAnimation.StoreValue;
begin
  inherited;
  OldValue:=Value;
end;

{ TVisibleAnimation }

function TVisibleAnimation.GetValue: Boolean;
begin
  result:=Node.Visible;
end;

procedure TVisibleAnimation.SetValue(AValue: Boolean);
begin
  Node.Visible:=AValue;
end;

procedure TVisibleAnimation.Stop;
begin
  Value:=OldValue;
  inherited;
end;

{ TColorAnimation }

constructor TColorAnimation.Create(AOwner: TComponent);
begin
  inherited;
  FStartColor:=clNone;
  FEndColor:=clNone;
end;

function TColorAnimation.EndAnimation:Boolean;
begin
  if not (csDestroying in ComponentState) then
     Value:=OldColor;

  result:=inherited EndAnimation;
end;

procedure TColorAnimation.NewNode;
begin
  if Assigned(IAnimate) and (not (csLoading in IAnimate.ComponentState)) then
  if Assigned(Node) then 
  begin
    if FStartColor=clNone then FStartColor:=Value;
    if FEndColor=clNone then FEndColor:=Value;
  end;
end;

procedure TColorAnimation.NextFrame(const Fraction:Single);
var tmp0 : TRGB;
    tmp1 : TRGB;
    tmp  : TColor;
begin
  tmp0:=RGBValue(StartColor);
  tmp1:=RGBValue(EndColor);

  tmp:=RGB( tmp0.Red+Round(Fraction*(tmp1.Red-tmp0.Red)),
            tmp0.Green+Round(Fraction*(tmp1.Green-tmp0.Green)),
            tmp0.Blue+Round(Fraction*(tmp1.Blue-tmp0.Blue)));

  Value:=tmp;

  if EndColor>=StartColor then
  begin
    if tmp>=FEndColor then Stop;
  end
  else
    if tmp<=FEndColor then Stop;

  inherited;
end;

procedure TColorAnimation.Play;
begin
  if IPlaying=asStopped then Value:=FStartColor;
  inherited;
end;

procedure TColorAnimation.StoreValue;
begin
  inherited;
  OldColor:=Value;
end;

{ TNodeColorAnimation }

function TNodeColorAnimation.GetColor: TColor;
begin
  if Assigned(Node) then
  Case FColor of
    ncColor          : result:=Node.Color;
    ncBorder         : result:=Node.Border.Color;
    ncFont           : result:=Node.Font.Color;
    ncGradientStart  : result:=Node.Gradient.StartColor;
    ncGradientEnd    : result:=Node.Gradient.EndColor;
  else
    {ncGradientMiddle :} result:=Node.Gradient.MidColor;
  end
  else result:=clWhite;
end;

procedure TNodeColorAnimation.Preview;
begin
  inherited;
  Node.Transparent:=False;
  FStartColor:=Node.Color;
  FEndColor:=clRed;
end;

procedure TNodeColorAnimation.SetColor(AColor: TColor);
begin
  Case FColor of
    ncColor          : Node.Color:=AColor;
    ncBorder         : Node.Border.Color:=AColor;
    ncFont           : Node.Font.Color:=AColor;
    ncGradientStart  : Node.Gradient.StartColor:=AColor;
    ncGradientEnd    : Node.Gradient.EndColor:=AColor;
    ncGradientMiddle : Node.Gradient.MidColor:=AColor;
  end;
end;

{ TTreeColorAnimation }

function TTreeColorAnimation.GetColor: TColor;
begin
  case FColor of
    tcColor          : result:=Animate.Tree.Color;
    tcGrid           : result:=Animate.Tree.Grid.Color;
    tcGradientStart  : result:=Animate.Tree.Gradient.StartColor;
    tcGradientEnd    : result:=Animate.Tree.Gradient.EndColor;
  else
    {tcGradientMiddle :} result:=Animate.Tree.Gradient.MidColor;
  end;
end;

function TTreeColorAnimation.IsEnabled: Boolean;
begin
  result:=Enabled;
end;

procedure TTreeColorAnimation.Preview;
begin
  inherited;
  FStartColor:=Animate.Tree.Color;
  FEndColor:=clWhite;
end;

procedure TTreeColorAnimation.SetColor(AColor: TColor);
begin
  Case FColor of
    tcColor          : Animate.Tree.Color:=AColor;
    tcGrid           : Animate.Tree.Grid.Color:=AColor;
    tcGradientStart  : Animate.Tree.Gradient.StartColor:=AColor;
    tcGradientEnd    : Animate.Tree.Gradient.EndColor:=AColor;
    tcGradientMiddle : Animate.Tree.Gradient.MidColor:=AColor;
  end;
end;

{ TAddTextAnimation }

function TAddTextAnimation.EndAnimation:Boolean;
begin
  Node.SimpleText:=OldText;

  result:=inherited EndAnimation;
end;

procedure TAddTextAnimation.NextFrame(const Fraction:Single);
var tmp0 : Integer;
    tmp1 : Integer;
begin
  tmp1:=Length(OldText);
  tmp0:=Round(Fraction*tmp1);

  Node.SimpleText:=Copy(OldText,1,tmp0);
  if Node.SimpleText=OldText then Stop;

  inherited;
end;

procedure TAddTextAnimation.Play;
begin
  if IPlaying=asStopped then Node.SimpleText:='';
  inherited;
end;

procedure TAddTextAnimation.Preview;
begin
  inherited;
  Node.Text.HorizAlign:=htaLeft;
end;

procedure TAddTextAnimation.StoreValue;
begin
  inherited;
  OldText:=Node.SimpleText;
  Node.SimpleText:='';
end;

{ TMoveTextAnimation }

function TMoveTextAnimation.EndAnimation:Boolean;
begin
  Node.Text.HorizOffset:=OldOffset;

  result:=inherited EndAnimation;
end;

procedure TMoveTextAnimation.NextFrame(const Fraction:Single);
var tmp0 : Integer;
begin
  tmp0:=Round(Fraction*(2*Node.Width));

  Node.Text.HorizOffset:=Node.Width-tmp0;

  if tmp0>100 then Stop;

  inherited;
end;

procedure TMoveTextAnimation.Play;
begin
  if IPlaying=asStopped then Node.Text.HorizOffset:=Node.Width;
  inherited;
end;

procedure TMoveTextAnimation.StoreValue;
begin
  OldOffset:=Node.Text.HorizOffset;
  Node.Text.ClipText:=True;
  inherited;
end;

{ TTextAngleAnimation }

function TTextAngleAnimation.GetValue: Integer;
begin
  result:=Node.Text.Angle;
end;

procedure TTextAngleAnimation.Preview;
begin
  inherited;
  FStartValue:=0;
  FEndValue:=360;
end;

procedure TTextAngleAnimation.SetValue(AValue: Integer);
begin
  Node.Text.Angle:=AValue;
end;

{ TTextTranspAnimation }

function TTextTranspAnimation.GetValue: Integer;
begin
  result:=Node.Text.Transparency;
end;

procedure TTextTranspAnimation.Preview;
begin
  inherited;
  FStartValue:=0;
  FEndValue:=100;
end;

procedure TTextTranspAnimation.SetValue(AValue: Integer);
begin
  Node.Text.Transparency:=AValue;
end;

{ TTextFlashAnimation }

constructor TTextFlashAnimation.Create(AOwner: TComponent);
begin
  inherited;
  FSizePercent:=100;
end;

function TTextFlashAnimation.EndAnimation:Boolean;
begin
  Node.Font.Size:=OldSize;

  result:=inherited EndAnimation;
end;

procedure TTextFlashAnimation.NextFrame(const Fraction:Single);
var tmp : Integer;
    MaxSize : Integer;
begin
  MaxSize:=StartSize+Round(StartSize*SizePercent/50.0);

  if Fraction>0.5 then
     tmp:=MaxSize-Round(Fraction*(MaxSize-StartSize))
  else
     tmp:=StartSize+Round(Fraction*(MaxSize-StartSize));

  Node.Font.Size:=tmp;

  if Fraction>=1 then Stop;

  inherited;
end;

procedure TTextFlashAnimation.Play;
begin
  if IPlaying=asStopped then StartSize:=Node.Font.Size;
  inherited;
end;

procedure TTextFlashAnimation.StoreValue;
begin
  OldSize:=Node.Font.Size;
  inherited;
end;

{ TTextColorAnimation }

function TTextColorAnimation.GetColor: TColor;
begin
  result:=Node.Font.Color;
end;

procedure TTextColorAnimation.Preview;
begin
  inherited;
  Node.Font.Size:=18;
  Node.Font.Style:=[fsBold];
  FStartColor:=Node.Font.Color;
  FEndColor:=clRed;
end;

procedure TTextColorAnimation.SetColor(AColor: TColor);
begin
  Node.Font.Color:=AColor;
end;

{ TNodeZoomAnimation }

constructor TNodeZoomAnimation.Create(AOwner: TComponent);
begin
  inherited;
  FZoomPercent:=100;
end;

function TNodeZoomAnimation.EndAnimation:Boolean;
begin
  if not (csDestroying in ComponentState) then
     SetNodeBounds(OldBounds);

  result:=inherited EndAnimation;
end;

procedure TNodeZoomAnimation.NextFrame(const Fraction:Single);
var tmpZoom : Double;
    tmpW    : Double;
    tmpH    : Double;
begin
  tmpZoom:=Fraction*ZoomPercent;

  tmpW:=OldBounds.Right-OldBounds.Left;
  tmpW:=tmpW+(tmpW*tmpZoom*0.01);

  tmpH:=OldBounds.Bottom-OldBounds.Top;
  tmpH:=tmpH+(tmpH*tmpZoom*0.01);

  with Node do
  begin
    Left:=Round((OldBounds.Right+OldBounds.Left-tmpW)*0.5);
    Width:=Round(tmpW);
    Top:=Round((OldBounds.Bottom+OldBounds.Top-tmpH)*0.5);
    Height:=Round(tmpH);
  end;

  if tmpZoom>=ZoomPercent then Stop;

  inherited;
end;

procedure TNodeZoomAnimation.Preview;
begin
  inherited;
  Node.Transparent:=False;
  Node.Border.Visible:=True;
end;

Procedure TNodeZoomAnimation.SetNodeBounds(Const R:TRect);
begin
  Node.Left:=R.Left;
  Node.Top:=R.Top;
  Node.Width:=R.Right-R.Left;
  Node.Height:=R.Bottom-R.Top;
end;

procedure TNodeZoomAnimation.StoreValue;
begin
  inherited;
  with OldBounds do
  begin
    Left:=Node.Left;
    Top:=Node.Top;
    Right:=Left+Node.Width;
    Bottom:=Top+Node.Height;
  end;
end;

{ TTreeAnimate }

procedure TTreeAnimate.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;

  if Operation=opRemove then
     if Assigned(FTree) and (AComponent=FTree) then
        Tree:=nil;
end;

procedure TTreeAnimate.SetTree(const Value: TCustomTree);
begin
  if FTree<>Value then
  begin
    if Assigned(FTree) then
       FTree.RemoveFreeNotification(Self);

    FTree:=Value;

    if Assigned(FTree) then
       FTree.FreeNotification(Self);
  end;
end;

initialization
  TeeRegisterAnimation(TFontSizeAnimation);
  TeeRegisterAnimation(TMovementAnimation);
  TeeRegisterAnimation(TTransparencyAnimation);
  TeeRegisterAnimation(TTextTranspAnimation);
  TeeRegisterAnimation(TVisibleAnimation);
  TeeRegisterAnimation(TNodeColorAnimation);
  TeeRegisterAnimation(TTreeColorAnimation);
  TeeRegisterAnimation(TCustomAnimation);
  TeeRegisterAnimation(TAddTextAnimation);
  TeeRegisterAnimation(TMoveTextAnimation);
  TeeRegisterAnimation(TTextAngleAnimation);
  TeeRegisterAnimation(TTextFlashAnimation);
  TeeRegisterAnimation(TTextColorAnimation);
  TeeRegisterAnimation(TNodeZoomAnimation);
end.
