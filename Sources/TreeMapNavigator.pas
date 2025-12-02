{***************************************************}
{   TTree Component Library, for VCL and FireMonkey }
{   Copyright (c) 1998-2025 by Steema Software      }
{***************************************************}
unit TreeMapNavigator;
{$I TeeDefs.inc}

interface

uses
  Classes, Types,

  {$IFDEF FMX}
  FMX.Types, FMX.Platform, FMX.Controls,
  FMXTee.Tree, FMXTee.Canvas
  {$ELSE}
  Graphics, TeeTree, TeCanvas
  {$ENDIF}
  ;

type
  TTeeSize=record
    Width,
    Height : TCoordinate;
  end;

  TNavigatorQuality=(nqNormal, nqLow, nqHigh, nqHighest);

  TTreeNavigator=class(TTree)
  private
    FClickToNavigate : Boolean;
    FOnSelectionMoved : TNotifyEvent;
    FQuality : TNavigatorQuality;
    FScrollOutside : Boolean;

    {$IFDEF AUTOREFCOUNT}
    [weak]
    {$ENDIF} FTree : TTree;

    IRefreshing,
    IRepositioning : Boolean;
    ITool : TTreeNodeShape;

    procedure CreateSelector;
    function GetSelector:TTreeNodeShape;
    procedure MovingShape(Sender:TTreeNodeShape; var DeltaX,DeltaY:Integer);
    procedure SetQuality(const Value: TNavigatorQuality);
    procedure SetScrollOutside(const Value: Boolean);
    procedure SetTree(const Value:TTree);
    procedure VerifyInsideBounds;
  protected
    procedure Click; override;
    procedure InternalDraw(const UserRectangle:TRect); override;
    procedure Loaded; override;
    procedure Notification( AComponent: TComponent; Operation: TOperation); override;
    procedure PrepareTree;
    procedure Resize; override;
  public
    // Set the selection rectangle border size automatically
    AutoBorderSize : Boolean;

    Constructor Create(AOwner:TComponent); override;
    Destructor Destroy; override;

    // Creates a bitmap using total Tree contents to display as background
    procedure RefreshTreeMap;

    // Moves and resizes the Map selector, using current Tree scroll and zoom
    procedure Reposition;

    // The draggable and resizeable rectangle shape:
    property Selector:TTreeNodeShape read GetSelector;

    // Returns the width to height ratio of the total Tree content size
    function TotalBoundsRatio:Single;

    // Returns the size (width and height) of the total Tree content
    function TotalSize:TTeeSize;
  published

    // Enables clicking anywhere in the Map to scroll the Tree
    property ClickToNavigate:Boolean read FClickToNavigate write FClickToNavigate default True;

    // Map resolution, default is: mrNormal
    property Quality:TNavigatorQuality read FQuality write SetQuality default nqNormal;

    // Allows moving the selection outside the Tree total content bounds
    property ScrollOutside:Boolean read FScrollOutside write SetScrollOutside default False;

    // The target Tree control
    property Tree:TTree read FTree write SetTree;

    // Events

    property OnSelectionMoved:TNotifyEvent read FOnSelectionMoved write FOnSelectionMoved;
  end;

implementation

uses
  {$IFDEF FMX}
  FMXTee.Procs, FMX.Graphics,
  {$ELSE}
  TeeGDIPlus, TeeProcs, Controls,
  {$ENDIF}
  Math;

Constructor TTreeNavigator.Create(AOwner: TComponent);
begin
  inherited;

  Page.UsePrinter:=False;
  Page.Border.Hide;

  AutoBorderSize:=True;

  FClickToNavigate:=True;
  FQuality:=nqNormal;

  Designing:=True;
  ReadOnly:=True;
  SnapToGrid:=False;

  AllowDelete:=False;
  AllowResize:=False;
  AllowZoom:=False;
  AllowPanning:=pmNone;

  View3D:=False;

  BackImage.Mode:=pbmStretch;

  if csDesigning in ComponentState then
     if (not Assigned(Owner)) or (not (csLoading in Owner.ComponentState)) then
        CreateSelector;

  OnMovingShape:=MovingShape;
end;

Destructor TTreeNavigator.Destroy;
begin
  Tree:=nil;
  inherited;
end;

procedure TTreeNavigator.CreateSelector;
begin
  ITool:=AddRoot('');

  ITool.ImageIndex:=tiNone;
  ITool.AutoSize:=False;
  ITool.Border.Color:=clRed;
  ITool.Brush.Style:=bsClear;
  ITool.Transparency:=20;
end;

function TTreeNavigator.GetSelector:TTreeNodeShape;
begin
  if not Assigned(ITool) then
     CreateSelector;

  result:=ITool;
end;

type
  TCanvas3DAccess=class(TCanvas3D);

procedure TTreeNavigator.RefreshTreeMap;

  procedure AssignTreeImage(const ABitmap:TBitmap);
  begin
    if not Assigned(BackImage.Bitmap) then
       BackImage.Bitmap:=TBitmap.Create;

    if (BackImage.Bitmap.Width<>Width) or
       (BackImage.Bitmap.Height<>Height) then
    begin
      BackImage.Bitmap.Assign(ABitmap);

      { Alternative solution:
      TeeSetBitmapSize(BackImage.Bitmap,Width,Height);
      TGDIPlusCanvas.ResizeBitmap(ABitmap,BackImage.Bitmap);
      }
    end;
  end;

  procedure DoRefresh;
  var
    S : TTeeSize;
    tmp : TBitmap;
    tmpMin : Integer;
    tmpT : TTeeTransform;

    tmpMaxSize,
    OldH,
    OldV : Integer;
    V : TView3DOptions;

    Old : Boolean;

  begin
    S:=TotalSize;

    if (S.Width=0) or (S.Height=0) then
    begin
      FTree.Draw;
      S:=TotalSize;
    end;

    if (S.Width=0) or (S.Height=0) then
       Exit;

    tmp:=TBitmap.Create;
    try
      case Quality of
        nqNormal: tmpMaxSize:=1024;
        nqLow: tmpMaxSize:=512;
        nqHigh: tmpMaxSize:=2048;
      else
        tmpMaxSize:=4096; // nqHighest
      end;

      tmpMin:=Round(tmpMaxSize/TotalBoundsRatio);

      if S.Width>S.Height then
         TeeSetBitmapSize(tmp,tmpMaxSize,tmpMin)
      else
         TeeSetBitmapSize(tmp,tmpMin,tmpMaxSize);

      tmpT:=TTeeTransform.Create;
      try
        tmpT.Scale.X:=tmp.Width/S.Width;
        tmpT.Scale.Y:=tmp.Height/S.Height;

        tmpT.Enabled:=True;

        TCanvas3DAccess(FTree.Canvas).FTransform:=tmpT;

        V:=FTree.View3DOptions;
        OldH:=V.HorizOffset;
        OldV:=V.VertOffset;

        FTree.AutoRepaint:=False;

        V.HorizOffset:=0;
        V.VertOffset:=0;

        try
          Old:=FTree.BufferedDisplay;
          FTree.BufferedDisplay:=False;
          try
            {$IFDEF FMX}
            tmp.Canvas.BeginScene;
            try
            {$ENDIF}

              FTree.Draw(tmp.Canvas,TeeRect(0,0,S.Width,S.Height));

            {$IFDEF FMX}
            finally
              tmp.Canvas.EndScene;
            end;
            {$ENDIF}
          finally
            FTree.BufferedDisplay:=Old;
          end;
        finally
          V.HorizOffset:=OldH;
          V.VertOffset:=OldV;

          FTree.AutoRepaint:=True;
        end;

        AssignTreeImage(tmp);

      finally
        TCanvas3DAccess(FTree.Canvas).FTransform.Free;
        TCanvas3DAccess(FTree.Canvas).FTransform:=nil;
      end;

    finally
      tmp.Free;
    end;
  end;

begin
  if IRefreshing then
     Exit;

  if FTree.Canvas.ReferenceCanvas=nil then
     Exit;

  IRefreshing:=True;
  try
    DoRefresh;
  finally
    IRefreshing:=False;
  end;
end;

procedure TTreeNavigator.PrepareTree;
begin
  // AllowResize:=FTree.Zoom.Allow;

  if not (csLoading in ComponentState) then
     RefreshTreeMap;

  Selector;
  
  Reposition;
end;

function TTreeNavigator.TotalSize:TTeeSize;
var R : {$IFDEF FMX}TRectF{$ELSE}TRect{$ENDIF};
begin
  if Assigned(FTree) then
  begin
    R:=FTree.TotalBounds;

    result.Width:=R.Right;
    result.Height:=R.Bottom;
  end
  else
  begin
    result.Width:=0;
    result.Height:=0;
  end;
end;

procedure TTreeNavigator.VerifyInsideBounds;
var V : TView3DOptions;
    S : TTeeSize;
    tmpSize : TCoordinate;
begin
  V:=FTree.View3DOptions;
  S:=TotalSize;

  if V.HorizOffset>0 then
     V.HorizOffset:=0
  else
  begin
    tmpSize:=S.Width-Round(FTree.{$IFDEF FMX}Width{$ELSE}ClientWidth{$ENDIF}/(0.01*FTree.View3DOptions.ZoomFloat));

    if -V.HorizOffset>tmpSize then
       V.HorizOffsetFloat:=-tmpSize;
  end;

  if V.VertOffset>0 then
     V.VertOffset:=0
  else
  begin
    tmpSize:=S.Height-Round(FTree.{$IFDEF FMX}Height{$ELSE}ClientHeight{$ENDIF}/(0.01*FTree.View3DOptions.ZoomFloat));

    if -V.VertOffset>tmpSize then
       V.VertOffsetFloat:=-tmpSize;
  end;
end;

// Scrolls the Tree to where the selector rectangle is located
procedure TTreeNavigator.MovingShape(Sender:TTreeNodeShape; var DeltaX,DeltaY:Integer);
var S : TTeeSize;
    tmpZoom : Single;
    tmpSize : Integer;
begin
  S:=TotalSize;

  IRepositioning:=True;
  try
    if not FScrollOutside then
    begin
      if ITool.Left<0 then
         ITool.Left:=0
      else
      begin
        tmpSize:={$IFDEF FMX}Round{$ENDIF}(Width-ITool.Width);

        if ITool.Left>tmpSize then
           ITool.Left:=tmpSize;
      end;

      if ITool.Top<0 then
         ITool.Top:=0
      else
      begin
        tmpSize:={$IFDEF FMX}Round{$ENDIF}(Height-ITool.Height);

        if ITool.Top>tmpSize then
           ITool.Top:=tmpSize;
      end;
    end;

    tmpZoom:=1/(0.01*FTree.View3DOptions.ZoomFloat);

    FTree.View3DOptions.HorizOffset:= -Round(tmpZoom*ITool.Left*S.Width/Width);
    FTree.View3DOptions.VertOffset:=  -Round(tmpZoom*ITool.Top*S.Height/Height);

    if not FScrollOutside then
       VerifyInsideBounds;

    // Trigger the event
    if Assigned(FOnSelectionMoved) then
       FOnSelectionMoved(Self);

  finally
    IRepositioning:=False;
  end;
end;

procedure TTreeNavigator.Reposition;
var V : TView3DOptions;
    S : TTeeSize;
    tmpZoom : Single;
begin
  if not Assigned(FTree) then
     Exit;

  if IRepositioning then
     Exit;
     
  V:=FTree.View3DOptions;

  S:=TotalSize;

  if (S.Width>0) and (S.Height>0) then
  begin
    if not ScrollOutside then
       VerifyInsideBounds;

    tmpZoom:=1/(0.01*FTree.View3DOptions.ZoomFloat);

    // Ensure Selector creation
    Selector;
    
    ITool.Width:=Round(tmpZoom*Width*FTree.{$IFDEF FMX}Width{$ELSE}ClientWidth{$ENDIF}/S.Width);
    ITool.Height:=Round(tmpZoom*Height*FTree.{$IFDEF FMX}Height{$ELSE}ClientHeight{$ENDIF}/S.Height);

    ITool.Left:=Round(-V.HorizOffset*Width/S.Width);
    ITool.Top:=Round(-V.VertOffset*Height/S.Height);

    if AutoBorderSize then
    begin
      ITool.Border.Width:=Max(1,Min(5,ITool.Width div 8));
    end;
  end;
end;

function TTreeNavigator.TotalBoundsRatio:Single;
var S : TTeeSize;
begin
  result:=1;

  if Assigned(FTree) then
  begin
    S:=TotalSize;

    if S.Height>0 then
       result:=S.Width/S.Height;
  end
end;

procedure TTreeNavigator.Resize;
begin
  inherited;
  Reposition;
end;

procedure TTreeNavigator.SetTree(const Value: TTree);
begin
  if FTree<>Value then
  begin
    if Assigned(FTree) then
       FTree.RemoveFreeNotification(Self);

    FTree:=Value;

    if Assigned(FTree) then
    begin
      FTree.FreeNotification(Self);
      PrepareTree;
    end;
  end;
end;

procedure TTreeNavigator.SetQuality(const Value: TNavigatorQuality);
begin
  if FQuality<>Value then
  begin
    FQuality:=Value;
    RefreshTreeMap;
  end;
end;

procedure TTreeNavigator.SetScrollOutside(const Value: Boolean);
begin
  FScrollOutside:=Value;

  if not FScrollOutside then
     Reposition;
end;

// Move the selection rectangle and synchronize the Tree
procedure TTreeNavigator.Click;
var P : {$IFDEF FMX}TPointF{$ELSE}TPoint{$ENDIF};
    DeltaX,
    DeltaY : Integer;
begin
  inherited;

  if Assigned(FTree) and FClickToNavigate then
  begin
    P:=GetCursorPos;

    IRepositioning:=True;
    try
      // Ensure Selector creation
      Selector;

      ITool.Left:={$IFDEF FMX}Round{$ENDIF}(Min(Width-ITool.Width,Max(0,P.X-(ITool.Width {$IFDEF FMX}*0.5{$ELSE}div 2{$ENDIF}))));
      ITool.Top:={$IFDEF FMX}Round{$ENDIF}(Min(Height-ITool.Height,Max(0,P.Y-(ITool.Height {$IFDEF FMX}*0.5{$ELSE}div 2{$ENDIF}))));

      DeltaX:=0;
      DeltaY:=0;

      MovingShape(ITool,DeltaX,DeltaY);
    finally
      IRepositioning:=False;
    end;
  end;
end;

procedure TTreeNavigator.InternalDraw(const UserRectangle:TRect);
begin
  if Assigned(FTree) then
    if not BackImage.Valid then
       PrepareTree;

  inherited;
end;

procedure TTreeNavigator.Loaded;
begin
  inherited;

  if Shapes.Count>0 then
     ITool:=Shapes[0];
end;

// Reset the Tree property to nil when it is removed or destroyed.
procedure TTreeNavigator.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;

  if (Operation=opRemove) and (AComponent=FTree) then
     Tree:=nil;
end;

end.
