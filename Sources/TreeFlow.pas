{**********************************************}
{   TTree Component - Flow-Chart Shapes        }
{   Copyright (c) 1998-2025 by Steema Software }
{**********************************************}
{$I TeeDefs.inc}
unit TreeFlow;

{ Several customized shapes used in Flow-Chart diagramms }
interface

Uses {$IFNDEF LINUX}
     Windows,
     {$ENDIF}
     Classes, Graphics, Controls, ExtCtrls,

     {$IFDEF D17}
     System.Types, System.UITypes,
     {$ENDIF}

     TeeTree, TeeProcs, TeCanvas;

type TFlowChartShape=class(TCustomTreeShape);

     TDecisionShape=class(TFlowChartShape)
     public
       Constructor Create(AOwner:TComponent); override;
     published
       property Style default tssDiamond;
     end;

     TConditionShape=class(TDecisionShape); // alias

     TProcessShape=class(TFlowChartShape)
     public
       Constructor Create(AOwner:TComponent); override;
     published
       property Style default tssRectangle;
     end;

     TPredefinedProcessShape = class(TProcessShape)
     protected
       procedure DrawShapeCanvas(const ACanvas:TCanvas3D; Const R:TRect); override;
     end;

     TTerminalShape=class(TFlowChartShape)
     protected
       Function GetShapePoints(Const R:TRect; Var P:TShapePoints):Integer; override;
     end;

     TConnectorShape=class(TFlowChartShape)
     public
       Constructor Create(AOwner:TComponent); override;
     published
       property Style default tssCircle;
     end;

     TInputOutputShape=class(TFlowChartShape)
     private
       FSlant : Double;

       Function ClickedSlantPoint(x,y:Integer):Boolean;
       procedure SetSlant(const Value: Double);
       Function SlantSize(const R:TRect):Integer;
     protected
       Function GetHandleCursor(x,y:Integer):TCursor; override;
       Function GetShapePoints(const R:TRect; Var P:TShapePoints):Integer; override;
     public
       Constructor Create(AOwner:TComponent); override;
       Procedure DrawHandles; override;
       function GetResizingHandle(x,y: Integer): TTreeShapeHandle; override;
       Procedure Resize(ACorner:TTreeShapeHandle; DeltaX,DeltaY:Integer); override;
     published
       property Slant:Double read FSlant write SetSlant;
     end;

     TTitleShape=class(TInputOutputShape); // alias

     TManualOperationShape=class(TFlowChartShape)
     protected
       Function GetShapePoints(Const R:TRect; Var P:TShapePoints):Integer; override;
     public
       Constructor Create(AOwner:TComponent); override;
     end;

     TSelectShape=class(TFlowChartShape)
     protected
       Function GetShapePoints(Const R:TRect; Var P:TShapePoints):Integer; override;
     public
       Constructor Create(AOwner:TComponent); override;
     end;

     TDocumentShape=class(TFlowChartShape)
     protected
       Function GetShapePoints(Const R:TRect; Var P:TShapePoints):Integer; override;
     public
       Constructor Create(AOwner:TComponent); override;
     end;

     TPunchCardShape=class(TFlowChartShape)
     private
       FPercentHoriz:Integer;
       FPercentVert:Integer;
       procedure SetPercentHoriz(const Value: Integer);
       procedure SetPercentVert(const Value: Integer);
     protected
       Function GetShapePoints(Const R:TRect; Var P:TShapePoints):Integer; override;
     public
       Constructor Create(AOwner:TComponent); override;
     published
       property PercentHoriz:Integer read FPercentHoriz write SetPercentHoriz default 25;
       property PercentVert:Integer read FPercentVert write SetPercentVert default 25;
     end;

     TCardShape=class(TPunchCardShape); // alias

     TPunchTapeShape=class(TFlowChartShape)
     protected
       Function GetShapePoints(Const R:TRect; Var P:TShapePoints):Integer; override;
     public
       Constructor Create(AOwner:TComponent); override;
     end;

     TDelayShape=class(TFlowChartShape)
     protected
       Function GetShapePoints(Const R:TRect; Var P:TShapePoints):Integer; override;
     public
       Constructor Create(AOwner:TComponent); override;
     end;

     TManualInputShape=class(TFlowChartShape)
     protected
       Function GetShapePoints(Const R:TRect; Var P:TShapePoints):Integer; override;
     public
       Constructor Create(AOwner:TComponent); override;
     end;

     TManualShape=class(TManualInputShape); // alias

     TFlowChartCircleShape=class(TFlowChartShape)
     public
       Constructor Create(AOwner:TComponent); override;
     published
       property Style default tssCircle;
     end;

     TAndShape=class(TFlowChartCircleShape)
     protected
       procedure DrawShapeCanvas(const ACanvas:TCanvas3D; Const R:TRect); override;
     end;

     TOrShape=class(TFlowChartCircleShape)
     protected
       procedure DrawShapeCanvas(const ACanvas:TCanvas3D; Const R:TRect); override;
     end;

     TOnlineStorageShape=class(TFlowChartShape)
     protected
       Function GetShapePoints(Const R:TRect; Var P:TShapePoints):Integer; override;
     end;

     TDataShape=class(TOnlineStorageShape); // alias

     TMagneticTapeShape=class(TFlowChartCircleShape)
     protected
       procedure DrawShapeCanvas(const ACanvas:TCanvas3D; Const R:TRect); override;
     end;

     TTapeShape=class(TMagneticTapeShape); // alias

     { "Other" custom shapes }
     TPentagonShape=class(TTreeCustomPolygonShape)
     protected
       Function GetShapePoints(Const R:TRect; Var P:TShapePoints):Integer; override;
     public
       Constructor Create(AOwner:TComponent); override;
     end;

     THexagonShape=class(TTreeCustomPolygonShape)
     protected
       Function GetShapePoints(Const R:TRect; Var P:TShapePoints):Integer; override;
     end;

     TOctagonShape=class(TTreeCustomPolygonShape)
     protected
       Function GetShapePoints(Const R:TRect; Var P:TShapePoints):Integer; override;
     public
       Constructor Create(AOwner:TComponent); override;
     end;

     TCrossShape=class(TCustomTreeShape)
     private
       FPercentHoriz : Integer;
       FPercentVert  : Integer;
       procedure SetHoriz(const Value: Integer);
       procedure SetVert(const Value: Integer);
     protected
       Function GetShapePoints(Const R:TRect; Var P:TShapePoints):Integer; override;
     public
       Constructor Create(AOwner:TComponent); override;
     published
       property PercentHoriz:Integer read FPercentHoriz write SetHoriz default 25;
       property PercentVert:Integer read FPercentVert write SetVert default 25;
     end;

     TTriangleRectShape=class(TCustomTreeShape)
     public
       Constructor Create(AOwner:TComponent); override;
     published
       property VertTextAlign default vtaBottom;
     end;

     TTriangleRectRightShape=class(TTriangleRectShape)
     protected
       Function GetShapePoints(Const R:TRect; Var P:TShapePoints):Integer; override;
     end;

     TTriangleRectLeftShape=class(TTriangleRectShape)
     protected
       Function GetShapePoints(Const R:TRect; Var P:TShapePoints):Integer; override;
     end;

     THouseShape=class(TCustomTreeShape)
     private
       FWallSize: Double;
       Function ClickedMiddle(x,y:Integer):Boolean;
       Function InternalWallSize(Const R:TRect):Integer;
       procedure SetWallSize(const Value: Double);
     protected
       Function GetHandleCursor(x,y:Integer):TCursor; override;
       Function GetShapePoints(Const R:TRect; Var P:TShapePoints):Integer; override;
     public
       Constructor Create(AOwner: TComponent); override;

       Procedure DrawHandles; override;
       function GetResizingHandle(x, y: Integer): TTreeShapeHandle; override;
       Procedure Resize(ACorner:TTreeShapeHandle; DeltaX,DeltaY:Integer); override;
     published
       property WallSize:Double read FWallSize write SetWallSize;
     end;

     TEnvelopeShape=class(TTreeNodeShape)
     private
       FOffsetY : Integer;
       Function ClickedMiddle(x,y:Integer):Boolean;
       Function MiddlePoint(Const R:TRect):TPoint;
       procedure SetOffsetY(const Value: Integer);
     protected
       procedure DrawShapeCanvas(const ACanvas:TCanvas3D; Const R:TRect); override;
       Function GetHandleCursor(x,y:Integer):TCursor; override;
     public
       Constructor Create(AOwner: TComponent); override;

       Procedure DrawHandles; override;
       Function GetResizingHandle(x,y:Integer):TTreeShapeHandle; override;
       Procedure Resize(ACorner:TTreeShapeHandle; DeltaX,DeltaY:Integer); override;
     published
       property OffsetY:Integer read FOffsetY write SetOffsetY default 33;
     end;

     TRingShape=class(TTreeNodeShape)
     protected
       procedure DrawShapeCanvas(const ACanvas:TCanvas3D; Const R:TRect); override;
     public
       Constructor Create(AOwner:TComponent); override;
     published
       property Style default tssCircle;
     end;

     TTreeCustomArrowShape=class(TCustomTreeShape)
     private
       FPercentHoriz : Integer;
       FPercentVert  : Integer;
       procedure SetHoriz(const Value: Integer);
       procedure SetVert(const Value: Integer);
     public
       Constructor Create(AOwner:TComponent); override;
     published
       property PercentHoriz:Integer read FPercentHoriz write SetHoriz default 25;
       property PercentVert:Integer read FPercentVert write SetVert default 33;
     end;

     TArrowUpShape=class(TTreeCustomArrowShape)
     protected
       Function GetShapePoints(Const R:TRect; Var P:TShapePoints):Integer; override;
     end;

     TArrowDownShape=class(TTreeCustomArrowShape)
     protected
       Function GetShapePoints(Const R:TRect; Var P:TShapePoints):Integer; override;
     end;

     TArrowLeftShape=class(TTreeCustomArrowShape)
     protected
       Function GetShapePoints(Const R:TRect; Var P:TShapePoints):Integer; override;
      end;

     TArrowRightShape=class(TTreeCustomArrowShape)
     protected
       Function GetShapePoints(Const R:TRect; Var P:TShapePoints):Integer; override;
     end;

     TCallOutShape=class(TCustomTreeShape)
     private
       FPosX : Integer;
       FPosY : Integer;
       Function CallOutPoint(Const R:TRect):TPoint;
       Function ClickedCallOut(x,y:Integer):Boolean;
     protected
       Function GetHandleCursor(x,y:Integer):TCursor; override;
       Function GetShapePoints(Const R:TRect; Var P:TShapePoints):Integer; override;
     public
       Constructor Create(AOwner:TComponent); override;

       Procedure DrawHandles; override;
       Function GetResizingHandle(x,y:Integer):TTreeShapeHandle; override;
       Procedure Resize(ACorner:TTreeShapeHandle; DeltaX,DeltaY:Integer); override;
     end;

     TStarShape=class(TCustomTreeShape)
     protected
       Function GetShapePoints(Const R:TRect; Var P:TShapePoints):Integer; override;
     end;

Const MaxRows=100;
      MaxCols=100;

type
  TGridCellShape=class(TTreeNodeShape)
  protected
    procedure CanvasChanged(Sender:TObject); override;
    Procedure SetSelected(Value:Boolean); override;
  public
    Column : Integer;
    Row    : Integer;
  end;

  TGridShape=class; // forward

  TGridShapeNewCellEvent=procedure(Sender:TGridShape; Row,Col:Integer) of object;

  TGridShape=class(TTreeNodeShape)
  private
    FCell : Array[0..MaxRows,0..MaxCols] of TGridCellShape;

    FColumns     : Integer;
    FRows        : Integer;
    FGridLines   : TTreePen;
    FOnNewCell   : TGridShapeNewCellEvent;
    FSelectedCol : Integer;
    FSelectedRow : Integer;

    procedure SetColumns(const Value: Integer);
    procedure SetRows(const Value: Integer);
    procedure SetGridLines(const Value: TTreePen);
  protected
    Function CellRect(Const R:TRect; Row,Col:Integer):TRect;
    Procedure DoClick( Button:TMouseButton; Shift:TShiftState;
                       x,y:Integer); override;
    procedure DrawShapeCanvas(const ACanvas:TCanvas3D; Const R:TRect); override;
    function GetCell(Row, Col: Integer): TGridCellShape; virtual;
    Function GetEditedShape:TTreeNodeShape; override;
    Function GetHandleCursor(x,y:Integer):TCursor; override;
    procedure Loaded; override;
    Procedure SetSelected(Value:Boolean); override;
  public
    Constructor Create(AOwner:TComponent); override;
    Destructor Destroy; override;

    Procedure AddColumn;
    Procedure AddRow;
    Function CellAt(x,y:Integer):TGridCellShape;
    Procedure ClearSelection;
    Procedure DeleteColumn(Column:Integer);
    Procedure DeleteRow(Row:Integer);
    Procedure RecalcSize(const ACanvas:TCanvas3D); override;

    property Cells[Row,Col:Integer]:TGridCellShape read GetCell; default;
  published
    property AutoSize default False;
    property Columns:Integer read FColumns write SetColumns;
    property GridLines:TTreePen read FGridLines write SetGridLines;
    property Rows:Integer read FRows write SetRows;
    property Transparent default True;

    property OnNewCell:TGridShapeNewCellEvent read FOnNewCell
                                              write FOnNewCell;
  end;

  TBeveledShape=class(TTreeNodeShape)
  private
    FBevel     : TPanelBevel;
    FBevelSize : Integer;
    procedure SetBevel(const Value: TPanelBevel);
    procedure SetBevelSize(const Value: Integer);
  protected
    procedure DrawShapeCanvas(const ACanvas:TCanvas3D; Const R:TRect); override;
  public
    Constructor Create(AOwner : TComponent); override;
  published
    property Bevel:TPanelBevel read FBevel write SetBevel default bvRaised;
    property BevelSize:Integer read FBevelSize write SetBevelSize default 1;
    property Color default clBtnFace;
  end;

implementation

Uses SysUtils, Math, TreeConst;

type TTreeAccess=class(TCustomTree);

{ Decision }
Constructor TDecisionShape.Create(AOwner:TComponent);
begin
  inherited;
  Style:=tssDiamond;
  Brush.Color:=clRed;
  Font.Color:=clWhite;
end;

{ Process }
Constructor TProcessShape.Create(AOwner:TComponent);
begin
  inherited;
  Style:=tssRectangle;
end;

{ TPredefinedProcessShape }
procedure TPredefinedProcessShape.DrawShapeCanvas(const ACanvas: TCanvas3D; const R: TRect);
var xp : Integer;
begin
  inherited;

  with R do
  begin
    xp:=Abs(Right-Left) div 6;
    ACanvas.MoveTo3D(Left+xp,Top,TeeTreeZ);
    ACanvas.LineTo3D(Left+xp,Bottom,TeeTreeZ);
    ACanvas.MoveTo3D(Right-xp,Top,TeeTreeZ);
    ACanvas.LineTo3D(Right-xp,Bottom,TeeTreeZ);
  end;
end;


{ Connector }
Constructor TConnectorShape.Create(AOwner:TComponent);
begin
  inherited;
  Style:=tssCircle;
end;

{ TTerminalShape }
function TTerminalShape.GetShapePoints(const R: TRect;
  var P: TShapePoints): Integer;
var xc      : Integer;
    yc      : Integer;
    XRadius : Integer;
    YRadius : Integer;
    tmpOffset : Double;
    tmpStep : Double;

  Procedure DrawCurve(AOffset,AFactor,AInverse:Integer);
  Var t     : Integer;
      Angle : Double;
  begin
    for t:=1 to 16 do
    begin
      Angle:=tmpOffset+t*tmpStep;
      P[AOffset+t].X:=xc-(Round(XRadius*Cos(Angle))*AInverse);
      P[AOffset+t].Y:=yc+AFactor*Round(YRadius*Sin(Angle));
    end;
  end;

begin
  result:=33;
  With R do
  begin
    yc:=(Bottom+Top) div 2;
    XRadius:=(Right-Left) div 4;
    YRadius:=(Bottom-Top) div 2;
    xc:=Right-XRadius;
    P[0]:=TeePoint(xc,Top);    
  end;
  tmpOffset:=1.5*pi;
  tmpStep:=Pi/16.0;
  DrawCurve(0,1,-1);
  xc:=R.Left+XRadius;
  DrawCurve(16,-1,1);
end;

{ InputOutput }
Constructor TInputOutputShape.Create(AOwner:TComponent);
begin
  inherited;
  Brush.Color:=clYellow;
  FSlant:=12.5;
end;

Function TInputOutputShape.SlantSize(Const R:TRect):Integer;
var tmpSize2 : Integer;
    ISlant   : Double;
begin
  ISlant:=FSlant*0.01;
  result:=Round((R.Right-R.Left)*ISlant);
  if result=0 then result:=1;
  tmpSize2:=Round((R.Bottom-R.Top)*ISlant);
  if tmpSize2>result then result:=tmpSize2;
end;

Function TInputOutputShape.ClickedSlantPoint(x,y:Integer):Boolean;
var tmpSize : Integer;
    tmp     : Integer;
    tmpR    : TRect;
begin
  tmpSize:=Tree.Selected.HandleSize;
  tmpR:=Bounds;
  tmp:=SlantSize(tmpR);
  result:=(Abs(X-(tmpR.Left+tmp))<=tmpSize) and (Abs(Y-tmpR.Top)<=tmpSize);
end;

function TInputOutputShape.GetHandleCursor(x, y: Integer): TCursor;
begin
  result:=inherited GetHandleCursor(x,y);
  if (result=crDefault) and ClickedSlantPoint(x,y) then
     result:=crSizeWE;
end;

Function TInputOutputShape.GetShapePoints(Const R:TRect; Var P:TShapePoints):Integer;
var tmpSize : Integer;
begin
  result:=4;  { <-- has four points }

  { calculate horizontal slant size }
  tmpSize:=SlantSize(R);

  { return points }
  P[0]:=TeePoint(R.Left,R.Bottom);
  P[1]:=TeePoint(R.Left+tmpSize,R.Top);
  P[2]:=TeePoint(R.Right,R.Top);
  P[3]:=TeePoint(R.Right-tmpSize,R.Bottom);
end;

procedure TInputOutputShape.SetSlant(const Value: Double);
begin
  SetDoubleProperty(FSlant,Value);
end;

procedure TInputOutputShape.DrawHandles;
var tmpR : TRect;
begin
  inherited;
  tmpR:=Bounds;
  TTreeAccess(Tree).DrawHandle(Self,rcCustom,tmpR.Left+SlantSize(tmpR),tmpR.Top);
end;

function TInputOutputShape.GetResizingHandle(x, y: Integer): TTreeShapeHandle;
begin
  result:=inherited GetResizingHandle(x,y);
  if (result=rcNone) and ClickedSlantPoint(x,y) then
     result:=rcCustom;
end;

procedure TInputOutputShape.Resize(ACorner: TTreeShapeHandle; DeltaX,
  DeltaY: Integer);
var tmp : Double;
begin
  if ACorner=rcCustom then
  begin
    if DeltaX<>0 then
    begin
      tmp:=SlantSize(Bounds)+DeltaX;
      FSlant:=100.0*(tmp/Width);
      Repaint;
    end;
  end
  else inherited;
end;

{ ManualOperation }
Constructor TManualOperationShape.Create(AOwner:TComponent);
begin
  inherited;
  Brush.Color:=clAqua;
end;

Function TManualOperationShape.GetShapePoints(Const R:TRect; Var P:TShapePoints):Integer;
var tmpSize : Integer;
    tmpSize2: Integer;
begin
  if Style=tssCustom then
  begin
    result:=4;  { <-- has four points }

    { calculate horizontal slant size }
    tmpSize:=(R.Right-R.Left) div 8;
    if tmpSize=0 then tmpSize:=1;
    tmpSize2:=(R.Bottom-R.Top) div 8;
    if tmpSize2>tmpSize then tmpSize:=tmpSize2;

    { return points }
    P[0]:=TeePoint(R.Left+tmpSize,R.Bottom);
    P[1]:=R.TopLeft;
    P[2]:=TeePoint(R.Right,R.Top);
    P[3]:=TeePoint(R.Right-tmpSize,R.Bottom);
  end
  else result:=inherited GetShapePoints(R,P);
end;

{ Select }
Constructor TSelectShape.Create(AOwner:TComponent);
begin
  inherited;
  Brush.Color:=clLime;
end;

Function TSelectShape.GetShapePoints(Const R:TRect; Var P:TShapePoints):Integer;
var tmpSize  : Integer;
    tmpSize2 : Integer;
    tmpYC    : Integer;
begin
  result:=6;  { <-- has four points }

  { calculate vertical center }
  tmpYC:=(R.Top+R.Bottom) div 2;

  { calculate horizontal slant size }
  tmpSize:=(R.Right-R.Left) div 8;
  if tmpSize=0 then tmpSize:=1;
  tmpSize2:=(R.Bottom-R.Top) div 8;
  if tmpSize2>tmpSize then tmpSize:=tmpSize2;

  { return points }
  P[0]:=TeePoint(R.Left,tmpYC);
  P[1]:=TeePoint(R.Left+tmpSize,R.Top);
  P[2]:=TeePoint(R.Right-tmpSize,R.Top);
  P[3]:=TeePoint(R.Right,tmpYC);
  P[4]:=TeePoint(P[2].X,R.Bottom);
  P[5]:=TeePoint(P[1].X,R.Bottom);
end;

Procedure DrawCurves(Const R:TRect; Yc,AStart,ASteps:Integer;
                     Var P:TShapePoints; DoForward:Boolean);
var xc      : Integer;
    XRadius : Integer;
    YRadius : Integer;

  Procedure AddPoint(AIndex:Integer; const Angle:Double);
  begin
    P[AIndex]:=TeePoint(xc-Round(XRadius*Sin(Angle)),yc-Round(YRadius*Cos(Angle)));
  end;

Var PiStep : Double;
    tmp    : Double;
    t      : Integer;
begin
  XRadius:=(R.Right-R.Left) div 4;
  YRadius:=(R.Bottom-R.Top) div 4;
  PiStep:=2.0*Pi/3.0/(ASteps-1);

  xc:=R.Right-XRadius;
  tmp:=Pi/3.0;
  for t:=1 to ASteps do
  if DoForward then AddPoint(AStart+t,PiStep*t-tmp)
               else AddPoint(2*ASteps+AStart+1-t,PiStep*t-tmp);

  xc:=R.Left+XRadius;
  tmp:=1.5*Pi;
  for t:=1 to ASteps do
  if DoForward then AddPoint(2*ASteps+AStart+1-t,PiStep*t-tmp)
               else AddPoint(AStart+t,PiStep*t-tmp)
end;

{ TDocumentShape }
constructor TDocumentShape.Create(AOwner: TComponent);
begin
  inherited;
  Brush.Color:=$00FF80FF;
end;

function TDocumentShape.GetShapePoints(const R: TRect;
  var P: TShapePoints): Integer;
Const Steps=8;
var tmp : Integer;
begin
  result:=3+2*Steps;
  With R do
  begin
    P[0]:=TopLeft;
    P[1]:=TeePoint(Right,Top);
    tmp:=(Bottom-Top) div 8;
    P[2]:=TeePoint(Right,Bottom-Round(tmp+2.0*tmp/3.0));
    DrawCurves(R,Bottom-tmp,2,Steps,P,True);
    P[2+2*Steps]:=TeePoint(Left,Bottom-tmp);
  end;
end;


{ TPunchCardShape }
constructor TPunchCardShape.Create(AOwner: TComponent);
begin
  inherited;
  Brush.Color:=$FF8000;
  FPercentHoriz:=25;
  FPercentVert:=25;
end;

function TPunchCardShape.GetShapePoints(const R: TRect;
  var P: TShapePoints): Integer;
begin
  result:=5;
  With R do
  begin
    P[0]:=TeePoint(Right,Top);
    P[1]:=BottomRight;
    P[2]:=TeePoint(Left,Bottom);
    P[3]:=TeePoint(Left,Top+Round((Bottom-Top)*FPercentVert*0.01));
    P[4]:=TeePoint(Left+Round((Right-Left)*FPercentHoriz*0.01),Top);
  end;
end;

procedure TPunchCardShape.SetPercentHoriz(const Value: Integer);
begin
  SetIntegerProperty(FPercentHoriz,Value);
end;

procedure TPunchCardShape.SetPercentVert(const Value: Integer);
begin
  SetIntegerProperty(FPercentVert,Value);
end;

{ TPunchTapeShape }
constructor TPunchTapeShape.Create(AOwner: TComponent);
begin
  inherited;
  Brush.Color:=$808080;
end;

function TPunchTapeShape.GetShapePoints(const R: TRect;
  var P: TShapePoints): Integer;
Const Steps=8;
var tmp : Integer;
begin
  result:=3+4*Steps;
  With R do
  begin
    tmp:=(Bottom-Top) div 8;
    P[0]:=TeePoint(Right,Bottom-Round(tmp+2.0*tmp/3.0));
    DrawCurves(R,Bottom-tmp,0,Steps,P,True);
    P[2*Steps]:=TeePoint(Left,Bottom-tmp);
    P[1+2*Steps]:=TeePoint(Left,Top+tmp);
    DrawCurves(R,Top+tmp,1+2*Steps,Steps,P,False);
    P[2+4*Steps]:=TeePoint(Right,Top+tmp-Round(2.0*tmp/3.0));
  end;
end;

{ TDelayShape }
constructor TDelayShape.Create(AOwner: TComponent);
begin
  inherited;
  Brush.Color:=$C5FCE9;
end;

function TDelayShape.GetShapePoints(const R: TRect;
  var P: TShapePoints): Integer;
var Angle   : Double;
    xc      : Integer;
    yc      : Integer;
    XRadius : Integer;
    YRadius : Integer;
    t       : Integer;
    tmpOffset : Double;
    tmpStep : Double;
begin
  result:=33;

  With R do
  begin
    P[0]:=TopLeft;
    xc:=Left;
    yc:=(Bottom+Top) div 2;
    XRadius:=Right-Left;
    YRadius:=(Bottom-Top) div 2;
  end;

  tmpOffset:=1.5*pi;
  tmpStep:=Pi/32.0;

  for t:=1 to 32 do
  begin
    Angle:=tmpOffset+t*tmpStep;
    P[t].X:=xc+Round(XRadius*Cos(Angle));
    P[t].Y:=yc+Round(YRadius*Sin(Angle));
  end;
end;

{ TManualInputShape }
constructor TManualInputShape.Create(AOwner: TComponent);
begin
  inherited;
  Brush.Color:=$BEE1FC;
end;

function TManualInputShape.GetShapePoints(const R: TRect;
  var P: TShapePoints): Integer;
begin
  result:=4;

  With R do
  begin
    P[0]:=TeePoint(Left,(Top+Bottom) div 2);
    P[1]:=TeePoint(Right,Top);
    P[2]:=BottomRight;
    P[3]:=TeePoint(Left,Bottom);
  end;
end;

{ TFlowChartCircleShape }
constructor TFlowChartCircleShape.Create(AOwner: TComponent);
begin
  inherited;
  Style:=tssCircle;
end;

{ TAndShape }
procedure TAndShape.DrawShapeCanvas(const ACanvas: TCanvas3D; const R: TRect);
Var xc      : Integer;
    yc      : Integer;
    XRadius : Integer;
    YRadius : Integer;

  Procedure DoLine(Const Angle:Extended);
  Var tmpSin : Extended;
      tmpCos : Extended;
  begin
    SinCos(Angle,tmpSin,tmpCos);
    ACanvas.MoveTo3D(xc+Round(XRadius*tmpCos),yc+Round(YRadius*tmpSin),TeeTreeZ);
    SinCos(Pi+Angle,tmpSin,tmpCos);
    ACanvas.LineTo3D(xc+Round(XRadius*tmpCos),yc+Round(YRadius*tmpSin),TeeTreeZ);
  end;

begin
  inherited;

  With R do
  begin
    xc:=(Left+Right) div 2;
    XRadius:=(Right-Left) div 2;
    yc:=(Top+Bottom) div 2;
    YRadius:=(Bottom-Top) div 2;
  end;

  DoLine(0.25*Pi);
  DoLine((0.5*Pi)+(0.25*Pi));
end;

{ TOrShape }
procedure TOrShape.DrawShapeCanvas(const ACanvas: TCanvas3D; const R: TRect);
begin
  inherited;

  With R do
  begin
    ACanvas.HorizLine3D(Left,Right,(Top+Bottom) div 2,TeeTreeZ);
    ACanvas.VertLine3D((Left+Right) div 2,Top,Bottom,TeeTreeZ);
  end;
end;

{ TOnlineStorageShape }
function TOnlineStorageShape.GetShapePoints(const R: TRect;
  var P: TShapePoints): Integer;
var xc      : Integer;
    yc      : Integer;
    XRadius : Integer;
    YRadius : Integer;
    tmpOffset : Double;
    tmpStep : Double;

  Procedure DrawCurve(AOffset,AFactor:Integer);
  Var t     : Integer;
      Angle : Double;
  begin
    for t:=1 to 16 do
    begin
      Angle:=tmpOffset+t*tmpStep;
      P[AOffset+t].X:=xc-Round(XRadius*Cos(Angle));
      P[AOffset+t].Y:=yc+AFactor*Round(YRadius*Sin(Angle));
    end;
  end;

begin
  result:=33;
  With R do
  begin
    P[0]:=TeePoint(Right,Top);
    xc:=Right;
    yc:=(Bottom+Top) div 2;
    XRadius:=(Right-Left) div 4;
    YRadius:=(Bottom-Top) div 2;
  end;

  tmpOffset:=1.5*pi;
  tmpStep:=Pi/16.0;
  DrawCurve(0,1);
  xc:=R.Left+XRadius;
  DrawCurve(16,-1);
end;

{ TMagneticTapeShape }
procedure TMagneticTapeShape.DrawShapeCanvas(const ACanvas: TCanvas3D; const R: TRect);
begin
  inherited;

  With R do
  begin
    ACanvas.MoveTo3D((Left+Right) div 2,Bottom,TeeTreeZ);
    ACanvas.LineTo3D(Right,Bottom,TeeTreeZ);
  end;
end;

{ TPentagonShape }
constructor TPentagonShape.Create(AOwner: TComponent);
begin
  inherited;
  AngleOffset:=18;
end;

function TPentagonShape.GetShapePoints(const R: TRect;
  var P: TShapePoints): Integer;
begin
  result:=GetPolygonPoints(5,R,P);
end;

{ THexagonShape }
function THexagonShape.GetShapePoints(const R: TRect;
  var P: TShapePoints): Integer;
begin
  result:=GetPolygonPoints(6,R,P);
end;

{ TOctagonShape }
constructor TOctagonShape.Create(AOwner: TComponent);
begin
  inherited;
  AngleOffset:=22.5;
end;

function TOctagonShape.GetShapePoints(const R: TRect;
  var P: TShapePoints): Integer;
begin
  result:=GetPolygonPoints(8,R,P);
end;

{ TCrossShape }
constructor TCrossShape.Create(AOwner: TComponent);
begin
  inherited;
  FPercentHoriz:=25;
  FPercentVert:=25;
end;

function TCrossShape.GetShapePoints(const R: TRect;
  var P: TShapePoints): Integer;
var tmpX : Integer;
    tmpY : Integer;
begin
  result:=12;
  With R do
  begin
    tmpX:=Round((Right-Left)*FPercentHoriz*0.01);
    tmpY:=Round((Bottom-Top)*FPercentVert*0.01);
    P[0] :=TeePoint(Left+tmpX,Top);
    P[1] :=TeePoint(Right-tmpX,Top);
    P[2] :=TeePoint(Right-tmpX,Top+tmpY);
    P[3] :=TeePoint(Right,Top+tmpY);
    P[4] :=TeePoint(Right,Bottom-tmpY);
    P[5] :=TeePoint(Right-tmpX,Bottom-tmpY);
    P[6] :=TeePoint(Right-tmpX,Bottom);
    P[7] :=TeePoint(Left+tmpX,Bottom);
    P[8] :=TeePoint(Left+tmpX,Bottom-tmpY);
    P[9] :=TeePoint(Left,Bottom-tmpY);
    P[10]:=TeePoint(Left,Top+tmpY);
    P[11]:=TeePoint(Left+tmpX,Top+tmpY);
  end;
end;

procedure TCrossShape.SetHoriz(const Value: Integer);
begin
  SetIntegerProperty(FPercentHoriz,Value);
end;

procedure TCrossShape.SetVert(const Value: Integer);
begin
  SetIntegerProperty(FPercentVert,Value);
end;

{ TTriangleRectShape }
constructor TTriangleRectShape.Create(AOwner: TComponent);
begin
  inherited;
  VertTextAlign:=vtaBottom;
end;

{ TTriangleRectRightShape }
function TTriangleRectRightShape.GetShapePoints(const R: TRect;
  var P: TShapePoints): Integer;
begin
  result:=3;
  With R do
  begin
    P[0] :=TopLeft;
    P[1] :=BottomRight;
    P[2] :=TeePoint(Left,Bottom);
  end;
end;

{ TTriangleRectLeftShape }
function TTriangleRectLeftShape.GetShapePoints(const R: TRect;
  var P: TShapePoints): Integer;
begin
  result:=3;
  With R do
  begin
    P[0] :=TeePoint(Right,Top);
    P[1] :=BottomRight;
    P[2] :=TeePoint(Left,Bottom);
  end;
end;

{ THouseShape }
Function THouseShape.InternalWallSize(Const R:TRect):Integer;
begin
  result:=Round((R.Bottom-R.Top)*FWallSize*0.01);
end;

Function THouseShape.ClickedMiddle(x,y:Integer):Boolean;
var tmpSize : Integer;
    tmpR    : TRect;
begin
  tmpSize:=Tree.Selected.HandleSize;
  tmpR:=Bounds;
  result:=(Abs(X-XCenter)<=tmpSize) and
          (Abs(Y-(tmpR.Top+InternalWallSize(tmpR)))<=tmpSize);
end;

procedure THouseShape.DrawHandles;
begin
  inherited;
  TTreeAccess(Tree).DrawHandle(Self,rcCustom,XCenter,Y0+InternalWallSize(Bounds));
end;

function THouseShape.GetHandleCursor(x, y: Integer): TCursor;
begin
  result:=inherited GetHandleCursor(x,y);
  if (result=crDefault) and ClickedMiddle(x,y) then
     result:=crSizeNS;
end;

function THouseShape.GetResizingHandle(x, y: Integer): TTreeShapeHandle;
begin
  result:=inherited GetResizingHandle(x,y);
  if (result=rcNone) and ClickedMiddle(x,y) then
     result:=rcCustom;
end;

function THouseShape.GetShapePoints(const R: TRect;
  var P: TShapePoints): Integer;
var tmp : Integer;
begin
  result:=5;
  With R do
  begin
    P[0]:=TeePoint((Left+Right) div 2,Top);
    tmp:=Top+InternalWallSize(R);
    P[1]:=TeePoint(Right,tmp);
    P[2]:=BottomRight;
    P[3]:=TeePoint(Left,Bottom);
    P[4]:=TeePoint(Left,tmp);
  end;
end;

procedure THouseShape.Resize(ACorner: TTreeShapeHandle; DeltaX,
  DeltaY: Integer);
var tmp : Integer;
begin
  if ACorner=rcCustom then
  begin
    if DeltaY<>0 then
    begin
      tmp:=InternalWallSize(Bounds)+DeltaY;
      FWallSize:=100.0*(tmp/Height);
      Repaint;
    end;
  end
  else inherited;
end;

constructor THouseShape.Create(AOwner: TComponent);
begin
  inherited;
  FWallSize:=50;
end;

procedure THouseShape.SetWallSize(const Value: Double);
begin
  SetDoubleProperty(FWallSize,Value);
end;

{ TEnvelopeShape }
Constructor TEnvelopeShape.Create(AOwner: TComponent);
begin
  inherited;
  FOffsetY:=33;
end;

Function TEnvelopeShape.MiddlePoint(Const R:TRect):TPoint;
begin
  with R do
  begin
    result.X:=(Left+Right) div 2;
    result.Y:=Top+Round((Bottom-Top)*FOffsetY*0.01);
  end;
end;

procedure TEnvelopeShape.DrawHandles;
begin
  inherited;
  with MiddlePoint(Bounds) do
       TTreeAccess(Tree).DrawHandle(Self,rcCustom,X,Y);
end;

procedure TEnvelopeShape.DrawShapeCanvas(const ACanvas: TCanvas3D;
  const R: TRect);
begin
  inherited;

  With R do
  begin
    ACanvas.MoveTo3D(Left,Top,TeeTreeZ);

    with MiddlePoint(R) do
      ACanvas.LineTo3D(X,Y,TeeTreeZ);

    ACanvas.LineTo3D(Right,Top,TeeTreeZ);
  end;
end;

Function TEnvelopeShape.ClickedMiddle(x,y:Integer):Boolean;
var tmp     : TPoint;
    tmpSize : Integer;
begin
  tmpSize:=Tree.Selected.HandleSize;
  tmp:=MiddlePoint(Bounds);
  result:=(Abs(X-tmp.X)<=tmpSize) and (Abs(Y-tmp.Y)<=tmpSize);
end;

function TEnvelopeShape.GetHandleCursor(x, y: Integer): TCursor;
begin
  result:=inherited GetHandleCursor(x,y);
  if (result=crDefault) and ClickedMiddle(x,y) then
     result:=crSizeNS;
end;

procedure TEnvelopeShape.Resize(ACorner: TTreeShapeHandle; DeltaX,
  DeltaY: Integer);
var tmp : Double;
begin
  if ACorner=rcCustom then
  begin
    if DeltaY<>0 then
    begin
      tmp:=(FOffsetY*Height*0.01)+DeltaY;
      FOffsetY:=Round(tmp*100/Height);

      Repaint;
    end;
  end
  else inherited;
end;

procedure TEnvelopeShape.SetOffsetY(const Value: Integer);
begin
  SetIntegerProperty(FOffsetY,Value);
end;

function TEnvelopeShape.GetResizingHandle(x, y: Integer): TTreeShapeHandle;
begin
  result:=inherited GetResizingHandle(x,y);
  if (result=rcNone) and ClickedMiddle(x,y) then
     result:=rcCustom;
end;

{ TRingShape }
constructor TRingShape.Create(AOwner: TComponent);
begin
  inherited;
  Style:=tssCircle;
end;

procedure TRingShape.DrawShapeCanvas(const ACanvas: TCanvas3D; const R: TRect);
var tmpX : Integer;
    tmpY : Integer;
begin
  inherited;

  With R do
  begin
    tmpX:=(Right-Left) div 4;
    tmpY:=(Bottom-Top) div 4;

    ACanvas.EllipseWithZ(Left+tmpX,Top+tmpY,Right-tmpX,Bottom-tmpY,TeeTreeZ);
  end;
end;

{ TArrowShape }
constructor TTreeCustomArrowShape.Create(AOwner: TComponent);
begin
  inherited;
  FPercentHoriz:=25;
  FPercentVert:=33;
end;

procedure TTreeCustomArrowShape.SetHoriz(const Value: Integer);
begin
  SetIntegerProperty(FPercentHoriz,Value);
end;

procedure TTreeCustomArrowShape.SetVert(const Value: Integer);
begin
  SetIntegerProperty(FPercentVert,Value);
end;

{ TArrowUpShape }
function TArrowUpShape.GetShapePoints(const R: TRect;
  var P: TShapePoints): Integer;
var tmpX : Integer;
    tmpY : Integer;
begin
  result:=7;
  With R do
  begin
    tmpX:=Round((Right-Left)*FPercentHoriz*0.01);
    tmpY:=Top+Round((Bottom-Top)*FPercentVert*0.01);
    P[0]:=TeePoint((Left+Right) div 2,Top);
    P[1]:=TeePoint(Right,tmpY);
    P[2]:=TeePoint(Right-tmpX,tmpY);
    P[3]:=TeePoint(Right-tmpX,Bottom);
    P[4]:=TeePoint(Left+tmpX,Bottom);
    P[5]:=TeePoint(Left+tmpX,tmpY);
    P[6]:=TeePoint(Left,tmpY);
  end;
end;

{ TArrowDownShape }
function TArrowDownShape.GetShapePoints(const R: TRect;
  var P: TShapePoints): Integer;
var tmpX : Integer;
    tmpY : Integer;
begin
  result:=7;
  With R do
  begin
    tmpX:=Round((Right-Left)*FPercentHoriz*0.01);
    tmpY:=Bottom-Round((Bottom-Top)*FPercentVert*0.01);
    P[0]:=TeePoint((Left+Right) div 2,Bottom);
    P[1]:=TeePoint(Right,tmpY);
    P[2]:=TeePoint(Right-tmpX,tmpY);
    P[3]:=TeePoint(Right-tmpX,Top);
    P[4]:=TeePoint(Left+tmpX,Top);
    P[5]:=TeePoint(Left+tmpX,tmpY);
    P[6]:=TeePoint(Left,tmpY);
  end;
end;

{ TArrowRightShape }
function TArrowRightShape.GetShapePoints(const R: TRect;
  var P: TShapePoints): Integer;
var tmpX : Integer;
    tmpY : Integer;
begin
  result:=7;
  With R do
  begin
    tmpX:=Right-Round((Right-Left)*FPercentHoriz*0.01);
    tmpY:=Round((Bottom-Top)*FPercentVert*0.01);
    P[0]:=TeePoint(Right,(Top+Bottom) div 2);
    P[1]:=TeePoint(tmpX,Bottom);
    P[2]:=TeePoint(tmpX,Bottom-tmpY);
    P[3]:=TeePoint(Left,Bottom-tmpY);
    P[4]:=TeePoint(Left,Top+tmpY);
    P[5]:=TeePoint(tmpX,Top+tmpY);
    P[6]:=TeePoint(tmpX,Top);
  end;
end;

{ TArrowLeftShape }
function TArrowLeftShape.GetShapePoints(const R: TRect;
  var P: TShapePoints): Integer;
var tmpX : Integer;
    tmpY : Integer;
begin
  result:=7;
  With R do
  begin
    tmpX:=Left+Round((Right-Left)*FPercentHoriz*0.01);
    tmpY:=Round((Bottom-Top)*FPercentVert*0.01);
    P[0]:=TeePoint(Left,(Top+Bottom) div 2);
    P[1]:=TeePoint(tmpX,Bottom);
    P[2]:=TeePoint(tmpX,Bottom-tmpY);
    P[3]:=TeePoint(Right,Bottom-tmpY);
    P[4]:=TeePoint(Right,Top+tmpY);
    P[5]:=TeePoint(tmpX,Top+tmpY);
    P[6]:=TeePoint(tmpX,Top);
  end;
end;

{ TCallOutShape }

Function TCallOutShape.CallOutPoint(Const R:TRect):TPoint;
begin
  result:=TeePoint( R.Left+Round(FPosX*(R.Right-R.Left)*0.01),
                    R.Top+Round(FPosY*(R.Bottom-R.Top)*0.01));
end;

procedure TCallOutShape.DrawHandles;
begin
  inherited;
  with CallOutPoint(Bounds) do
       TTreeAccess(Tree).DrawHandle(Self,rcCustom,X,Y);
end;

Function TCallOutShape.ClickedCallOut(x,y:Integer):Boolean;
var P       : TPoint;
    tmpSize : Integer;
begin
  P:=CallOutPoint(Bounds);
  tmpSize:=Tree.Selected.HandleSize;
  result:=(Abs(X-P.X)<=tmpSize) and (Abs(Y-P.Y)<=tmpSize);
end;

function TCallOutShape.GetHandleCursor(x, y: Integer): TCursor;
begin
  result:=inherited GetHandleCursor(x,y);
  if (result=crDefault) and ClickedCallOut(x,y) then
     result:=crSizeAll;
end;

function TCallOutShape.GetResizingHandle(x, y: Integer): TTreeShapeHandle;
begin
  result:=inherited GetResizingHandle(x,y);
  if (result=rcNone) and ClickedCallOut(x,y) then
     result:=rcCustom;
end;

function TCallOutShape.GetShapePoints(const R: TRect;
  var P: TShapePoints): Integer;
var tmp : Integer;
begin
  result:=7;
  With R do
  begin
    tmp:=(Bottom-Top) div 6;
    P[0] :=TopLeft;
    P[1] :=TeePoint(Right,Top);
    P[2] :=TeePoint(Right,Bottom-tmp);
    P[3] :=TeePoint((Left+Right) div 2,Bottom-tmp);
    P[4] :=CallOutPoint(R);
    P[5] :=TeePoint(Left+((Right-Left) div 3),Bottom-tmp);
    P[6] :=TeePoint(Left,Bottom-tmp);
  end;
end;

procedure TCallOutShape.Resize(ACorner: TTreeShapeHandle; DeltaX,
  DeltaY: Integer);
begin
  if ACorner=rcCustom then
  begin
    if DeltaX<>0 then
    begin
      FPosX:=Round(100.0*((Width*FPosX*0.01)+DeltaX)/Width);
      Repaint;
    end;
    if DeltaY<>0 then
    begin
      FPosY:=Round(100.0*((Height*FPosY*0.01)+DeltaY)/Height);
      Repaint;
    end;
  end
  else inherited;
end;

constructor TCallOutShape.Create(AOwner: TComponent);
begin
  inherited;
  FPosX:=25;
  FPosY:=100;
end;

{ TStarShape }

function TStarShape.GetShapePoints(const R: TRect;
  var P: TShapePoints): Integer;
var tmpXC : Integer;
    tmpYC : Integer;
    tmpX  : Integer;
    tmpY  : Integer;

  Function PointAtAngle(Angle:Integer):TPoint;
  var tmpSin : Extended;
      tmpCos : Extended;
  begin
    SinCos(Angle*TeePiStep,tmpSin,tmpCos);
    result.X:=tmpXC+Round(tmpX*tmpSin);
    result.Y:=tmpYC-Round(tmpY*tmpCos);
  end;

var tmpX2 : Integer;
    tmpY2 : Integer;
    tmpX3 : Integer;
    tmpY3 : Integer;
begin
  result:=10;
  With R do
  begin
    tmpX:=(Right-Left) div 2;
    tmpY:=Math.Max(1,(Bottom-Top) div 2);
    tmpXC:=(Right+Left) div 2;
    tmpYC:=(Top+Bottom) div 2;

    tmpX2:=(2*tmpX) div 7;
    tmpY2:=(Bottom-Top) div 3;
    tmpX3:=tmpX div 2;
    tmpY3:=tmpY div 2;

    P[0]:=TeePoint((Left+Right) div 2,Top);
    P[2]:=PointAtAngle(72);

    P[1].X:=tmpXC+tmpX2;
    P[1].Y:=P[2].Y;

    P[3].X:=tmpXC+tmpX3;
    P[3].Y:=Bottom-tmpY2;

    P[4].X:=tmpXC+((Right-Left) div 3);
    P[4].Y:=Bottom;

    P[5].X:=tmpXC;
    P[5].Y:=Bottom-tmpY3;

    P[6].X:=tmpXC-((Right-Left) div 3);
    P[6].Y:=Bottom;

    P[7].X:=tmpXC-tmpX3;
    P[7].Y:=P[3].Y;

    P[8]:=PointAtAngle(288);

    P[9].X:=tmpXC-tmpX2;
    P[9].Y:=P[8].Y;
  end;
end;

{ TGridShape }
Constructor TGridShape.Create(AOwner: TComponent);
begin
  inherited;
  Width:=100;
  Height:=100;

  FGridLines:=TTreePen.Create(CanvasChanged);
  FGridLines.Color:=clGray;
  FGridLines.SmallDots:=True;

  FSelectedCol:=-1;
  FSelectedRow:=-1;

  Columns:=3;
  Rows:=3;
  Transparent:=True;
end;

Destructor TGridShape.Destroy;
begin
  FGridLines.Free;
  inherited;
end;

procedure TGridShape.AddColumn;
begin
  Inc(FColumns);
end;

procedure TGridShape.AddRow;
begin
  Inc(FRows);
end;

procedure TGridShape.DeleteColumn(Column: Integer);
var ARow : Integer;
    ACol : Integer;
begin
  if (Column>=0) and (Column<FColumns) then
  begin
    Dec(FColumns);

    for ARow:=0 to Rows-1 do
        FreeAndNil(FCell[ARow,Column]);

    for ACol:=Column to Columns-1 do
        for ARow:=0 to Rows-1 do
        begin
          FCell[ARow,ACol]:=FCell[ARow,ACol+1];
          FCell[ARow,ACol].Column:=ACol;
        end;

    for ARow:=0 to Rows-1 do
        FCell[ARow,Columns]:=nil;
  end;
end;

procedure TGridShape.DeleteRow(Row: Integer);
var ACol : Integer;
    ARow : Integer;
begin
  Dec(FRows);

  for ACol:=0 to Columns-1 do
      FreeAndNil(FCell[Row,ACol]);

  for ARow:=Row to Rows-1 do
      for ACol:=0 to Columns-1 do
      begin
        FCell[ARow,ACol]:=FCell[ARow+1,ACol];
        FCell[ARow,ACol].Row:=ARow;
      end;

  for ACol:=0 to Columns-1 do
      FCell[Rows,ACol]:=nil;
end;

function TGridShape.GetCell(Row, Col: Integer): TGridCellShape;
begin
  if not Assigned(FCell[Row,Col]) then
  begin
    FCell[Row,Col]:=TGridCellShape.Create(Self);
    with FCell[Row,Col] do
    begin
      AutoSize:=False;
      Transparent:=True;
    end;

    FCell[Row,Col].Column:=Col;
    FCell[Row,Col].Row:=Row;

    // Call OnNewCell event:
    if Assigned(FOnNewCell) then FOnNewCell(Self,Row,Col);
  end;
  result:=FCell[Row,Col];
end;

procedure TGridShape.SetColumns(const Value: Integer);
begin
  if FColumns<>Value then
  begin
    While Value<FColumns do DeleteColumn(FColumns-1);
    While Value>FColumns do AddColumn;
    Repaint;
  end;
end;

procedure TGridShape.SetGridLines(const Value: TTreePen);
begin
  FGridLines.Assign(Value);
end;

procedure TGridShape.SetRows(const Value: Integer);
begin
  if FRows<>Value then
  begin
    While Value<FRows do DeleteRow(FRows-1);
    While Value>FRows do AddRow;
    Repaint;
  end;
end;

type
  TCellAccess=class(TGridCellShape);

procedure TGridShape.DrawShapeCanvas(const ACanvas: TCanvas3D; const R: TRect);
var tmpRow : Integer;
    tmpCol : Integer;
    tmpR   : TRect;
    tmpR2  : TRect;
begin
  inherited;

  for tmpRow:=0 to Rows-1 do
   for tmpCol:=0 to Columns-1 do
   begin
     tmpR:=CellRect(R,tmpRow,tmpCol);

     with TCellAccess(Cells[tmpRow,tmpCol]) do
     begin
       SetBounds(tmpR);

       FTree:=Self.FTree;
       DrawShapeCanvas(ACanvas,tmpR);
       DrawText(ACanvas,tmpR);

       if Selected and (not Tree.Printing) then
       begin
         tmpR2:=tmpR;
         InflateRect(tmpR2,-2,-2);
         SetBounds(tmpR2);
         DrawHandles;
         SetBounds(tmpR);
       end;
     end;
   end;

   if Assigned(Tree) and Tree.Designing then // draw grid lines
   begin
     if FSelectedCol<>-1 then
     begin
       Tree.Canvas.Brush.Color:=clGray;
       tmpR:=CellRect(R,0,FSelectedCol);
       tmpR.Top:=R.Top;
       tmpR.Bottom:=R.Bottom;
       Tree.Canvas.RectangleWithZ(tmpR,TeeTreeZ);
     end;

     Tree.Canvas.AssignVisiblePen(FGridLines);

     for tmpRow:=1 to Rows-1 do
     begin
       tmpR:=CellRect(R,tmpRow,0);
       Tree.Canvas.HorizLine3D(R.Left,R.Right,tmpR.Top,TeeTreeZ);
     end;

     for tmpCol:=1 to Columns-1 do
     begin
       tmpR:=CellRect(R,0,tmpCol);
       Tree.Canvas.VertLine3D(tmpR.Left,R.Top,R.Bottom,TeeTreeZ);
     end;
   end;
end;

function TGridShape.CellRect(Const R:TRect; Row, Col: Integer): TRect;
var t    : Integer;
    tmpW : Integer;
    tmpH : Integer;
begin
  if AutoSize then
  begin
    result.Left:=R.Left;
    for t:=0 to Col-1 do Inc(result.Left,Cells[Row,t].Width);

    result.Top:=R.Top;
    for t:=0 to Row-1 do Inc(result.Top,Cells[t,Col].Height);

    result.Right:=result.Left+Cells[Row,Col].Width;
    result.Bottom:=result.Top+Cells[Row,Col].Height;
  end
  else
  begin
    tmpW:=Width div Columns;
    result.Left:=R.Left+Col*tmpW;
    if Col=Columns-1 then result.Right:=R.Right
                     else result.Right:=result.Left+tmpW;

    tmpH:=Height div Rows;
    result.Top:=R.Top+Row*tmpH;
    if Row=Rows-1 then result.Bottom:=R.Bottom
                  else result.Bottom:=result.Top+tmpH;
  end;
end;

function TGridShape.GetHandleCursor(x, y: Integer): TCursor;
var tmpR : TRect;
    tmp  : TTreeNodeShape;
begin
  result:=inherited GetHandleCursor(x,y);
  if result=crDefault then
  begin
    tmpR:=Bounds;
    if ((y>=tmpR.Top) and (y<=tmpR.Bottom)) and
       (Abs(x-tmpR.Left)<3) then result:=crArrowRight
    else
    if ((x>=tmpR.Left) and (x<=tmpR.Right)) and
       (Abs(y-tmpR.Top)<3) then result:=crArrowDown
    else
    begin
      tmp:=CellAt(x,y);
      if Assigned(tmp) then result:=tmp.Cursor;
    end;
  end;
end;

function TGridShape.CellAt(x, y: Integer): TGridCellShape;
var tmpRow : Integer;
    tmpCol : Integer;
begin
  result:=nil;
  for tmpRow:=0 to Rows-1 do
    for tmpCol:=0 to Columns-1 do
       if PointInRect(CellRect(Bounds,tmpRow,tmpCol),x,y) then
       begin
         result:=Cells[tmpRow,tmpCol];
         exit;
       end;
end;

procedure TGridShape.RecalcSize;
var tmpCol    : Integer;
    tmpRow    : Integer;
    tmpW      : Integer;
    tmpH      : Integer;
    tmpTotalW : Integer;
    tmpTotalH : Integer;
begin
  tmpTotalW:=0;
  tmpTotalH:=0;

  // Calculate each Columns Width
  for tmpCol:=0 to Columns-1 do
  begin
    if Rows=1 then  // special case for single-row grid:
    begin
      with Cells[0,tmpCol] do
      begin
        RecalcSize(Self.Tree.Canvas);
        Inc(tmpTotalW,Width);
        if Height>tmpTotalH then tmpTotalH:=Height;
      end;
    end
    else
    begin
      tmpW:=0;

      // Find maximum width of this column:
      for tmpRow:=0 to Rows-1 do
      begin
        with Cells[tmpRow,tmpCol] do
        begin
          RecalcSize(Self.Tree.Canvas);
          if Width>tmpW then tmpW:=Width;
        end;
      end;

      // Set max Width to all rows of this column:
      for tmpRow:=0 to Rows-1 do
      with Cells[tmpRow,tmpCol] do
           if Width<tmpW then Width:=tmpW;

      Inc(tmpTotalW,tmpW);
    end;
  end;

  if Rows>1 then
  begin
    // Calculate total Height of all rows:
    tmpTotalH:=0;

    for tmpRow:=0 to Rows-1 do
    begin
      // Find maximum Height of this row:
      tmpH:=0;
      for tmpCol:=0 to Columns-1 do
          with Cells[tmpRow,tmpCol] do
               if Height>tmpH then tmpH:=Height;

      // Set max Height to all cells of this row:
      for tmpCol:=0 to Columns-1 do
          with Cells[tmpRow,tmpCol] do
               if Height<tmpH then Height:=tmpH;

      Inc(tmpTotalH,tmpH);
    end;
  end;

  // Set total grid size:
  Width:=tmpTotalW;
  Height:=tmpTotalH;

  // Reset AutoSize and IAutoSized to True:
  AutoSize:=True;
  IAutoSized:=True;
end;

procedure TGridShape.Loaded;
begin
  inherited;
  SimpleText:='';
end;

procedure TGridShape.ClearSelection;
var Row : Integer;
    Col : Integer;
begin
  for Row:=0 to Rows-1 do
      for Col:=0 to Columns-1 do
          if Assigned(FCell[Row,Col]) then
             FCell[Row,Col].Selected:=False;
end;

// Returns the selected grid cell:
function TGridShape.GetEditedShape: TTreeNodeShape;
var Row : Integer;
    Col : Integer;
begin
  for Row:=0 to Rows-1 do
      for Col:=0 to Columns-1 do
          if Assigned(FCell[Row,Col]) and
             FCell[Row,Col].Selected then
          begin
            result:=FCell[Row,Col];
            exit;
          end;
  result:=Self;
end;

Procedure TGridShape.DoClick( Button:TMouseButton; Shift:TShiftState;
                              x,y:Integer);
var tmp : TGridCellShape;
begin
  // When clicking the Grid, try to select the individual grid cell
  // under mouse XY:

  if Selected and Assigned(Tree) and Tree.Designing then
  begin
    ClearSelection;
    tmp:=CellAt(x,y);
    if Assigned(tmp) then
       tmp.Selected:=True;  // select the individual cell
  end;
end;

procedure TGridShape.SetSelected(Value: Boolean);
begin
  inherited;
  if not Selected then ClearSelection;
end;

{ TGridCellShape }

procedure TGridCellShape.CanvasChanged(Sender: TObject);
begin
  if Owner is TTreeNodeShape then
     TCellAccess(Owner).CanvasChanged(Sender)
  else
     inherited;
end;

procedure TGridCellShape.SetSelected(Value: Boolean);
begin
  SetBooleanProperty(FSelected,Value);
end;

{ TBeveledShape }

constructor TBeveledShape.Create(AOwner: TComponent);
begin
  inherited;

  FBevel:=bvRaised;
  FBevelSize:=1;
  Color:=clSilver;
end;

procedure TBeveledShape.DrawShapeCanvas(const ACanvas: TCanvas3D; const R: TRect);

  procedure Frame3D(Var Rect: TRect; TopColor, BottomColor: TColor;
    Width: Integer);

    procedure DoRect;
    begin
      with ACanvas, Rect do
      begin
        Pen.Color := TopColor;
        DoVertLine(Left,Top,Bottom);
        DoHorizLine(Left,Right,Top);
        Pen.Color := BottomColor;
        DoVertLine(Right,Top,Bottom);
        DoHorizLine(Left-1,Right+1,Bottom);
      end;
    end;

  begin
    ACanvas.Pen.Width := 1;
    Dec(Rect.Bottom);
    Dec(Rect.Right);
    while Width > 0 do
    begin
      Dec(Width);
      DoRect;
      InflateRect(Rect, -1, -1);
    end;
    Inc(Rect.Bottom); Inc(Rect.Right);
  end;

Const Colors:Array[Boolean] of TColor=(clBtnHighlight,clBtnShadow);
var Rect : TRect;
begin
  inherited;

  if FBevel<>bvNone then
  begin
    With ACanvas.Pen do
    begin
      Style:=psSolid;
      Width:=1;
      Mode:=pmCopy;
    end;

    ACanvas.Brush.Style:=bsClear;

    Rect:=RectTo3DCanvas(ACanvas,R);
    Frame3D(Rect,Colors[FBevel=bvLowered],Colors[FBevel=bvRaised],FBevelSize);
  end;
end;

procedure TBeveledShape.SetBevel(const Value: TPanelBevel);
begin
  if FBevel<>Value then
  begin
    FBevel:=Value;
    Repaint;
  end;
end;

procedure TBeveledShape.SetBevelSize(const Value: Integer);
begin
  SetIntegerProperty(FBevelSize,Value);
end;

initialization
  TeeActivateGroup;
  
  // alias classes:
  RegisterClass(TConditionShape);
  RegisterClass(TTitleShape);
  RegisterClass(TCardShape);
  RegisterClass(TManualShape);
  RegisterClass(TDataShape);
  RegisterClass(TTapeShape);

  // shapes:
  RegisterCustomTreeShape(TeeTree_tabFlow, 'Decision', TDecisionShape);
  RegisterCustomTreeShape(TeeTree_tabFlow, 'Process', TProcessShape);
  RegisterCustomTreeShape(TeeTree_tabFlow, 'Predefined Process', TPredefinedProcessShape);
  RegisterCustomTreeShape(TeeTree_tabFlow, 'Terminal', TTerminalShape);
  RegisterCustomTreeShape(TeeTree_tabFlow, 'Connector', TConnectorShape);
  RegisterCustomTreeShape(TeeTree_tabFlow, 'Input/Output',     TInputOutputShape);
  RegisterCustomTreeShape(TeeTree_tabFlow, 'Manual Operation',   TManualOperationShape);
  RegisterCustomTreeShape(TeeTree_tabFlow, 'Select',    TSelectShape);
  RegisterCustomTreeShape(TeeTree_tabFlow, 'Document',  TDocumentShape);
  RegisterCustomTreeShape(TeeTree_tabFlow, 'Punched Card', TPunchCardShape);
  RegisterCustomTreeShape(TeeTree_tabFlow, 'Punched Tape', TPunchTapeShape);
  RegisterCustomTreeShape(TeeTree_tabFlow, 'Delay',     TDelayShape);
  RegisterCustomTreeShape(TeeTree_tabFlow, 'Manual Input',    TManualInputShape);
  RegisterCustomTreeShape(TeeTree_tabFlow, 'And',       TAndShape);
  RegisterCustomTreeShape(TeeTree_tabFlow, 'Or',        TOrShape);
  RegisterCustomTreeShape(TeeTree_tabFlow, 'Online Storage', TOnlineStorageShape);
  RegisterCustomTreeShape(TeeTree_tabFlow, 'Magnetic Tape', TMagneticTapeShape);

  RegisterCustomTreeShape(TeeTree_tabOther, 'Pentagon', TPentagonShape);
  RegisterCustomTreeShape(TeeTree_tabOther, 'Hexagon',  THexagonShape);
  RegisterCustomTreeShape(TeeTree_tabOther, 'Octagon',  TOctagonShape);
  RegisterCustomTreeShape(TeeTree_tabOther, 'Cross',    TCrossShape);
  RegisterCustomTreeShape(TeeTree_tabOther, 'Triangle Rect. Right', TTriangleRectRightShape);
  RegisterCustomTreeShape(TeeTree_tabOther, 'Triangle Rect. Left',  TTriangleRectLeftShape);
  RegisterCustomTreeShape(TeeTree_tabOther, 'House',  THouseShape);
  RegisterCustomTreeShape(TeeTree_tabOther, 'Envelope',  TEnvelopeShape);
  RegisterCustomTreeShape(TeeTree_tabOther, 'Ring',  TRingShape);
  RegisterCustomTreeShape(TeeTree_tabOther, 'ArrowUp',  TArrowUpShape);
  RegisterCustomTreeShape(TeeTree_tabOther, 'ArrowDown',  TArrowDownShape);
  RegisterCustomTreeShape(TeeTree_tabOther, 'ArrowLeft',  TArrowLeftShape);
  RegisterCustomTreeShape(TeeTree_tabOther, 'ArrowRight',  TArrowRightShape);

  RegisterCustomTreeShape(TeeTree_tabOther, 'CallOut',  TCallOutShape);
  RegisterCustomTreeShape(TeeTree_tabOther, 'Start',  TStarShape);
  RegisterCustomTreeShape(TeeTree_tabOther, 'Grid',  TGridShape);
  RegisterCustomTreeShape(TeeTree_tabOther, 'Bevel',  TBeveledShape);
finalization
  TeeActivateGroup;

  UnRegisterCustomTreeShapes([TDecisionShape,TInputOutputShape,TProcessShape,
                              TPredefinedProcessShape, TConnectorShape, TTerminalShape,
                              TSelectShape,TDocumentShape,TPunchCardShape,
                              TPunchTapeShape,TDelayShape, TManualInputShape,
                              TAndShape,TOrShape, TOnlineStorageShape, TMagneticTapeShape]);

  UnRegisterCustomTreeShapes([TPentagonShape,THexagonShape,TOctagonShape,
                              TCrossShape,TTriangleRectRightShape,
                              TTriangleRectLeftShape,THouseShape,TEnvelopeShape,
                              TRingShape,TArrowUpShape,TArrowDownShape,
                              TArrowLeftShape,TArrowRightShape,
                              TCallOutShape,TStarShape,TGridShape,
                              TBeveledShape]);
end.
