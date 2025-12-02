{***********************************************}
{   TTree Component - Electric (Circuit) Shapes }
{   Copyright (c) 2001-2025 by Steema Software  }
{***********************************************}
{$I TeeDefs.inc}
unit TreeElectric;

{ Several customized shapes used in Electronic and Circuit diagramms }
interface

Uses {$IFNDEF LINUX}
     Windows,
     {$ENDIF}
     Classes, Graphics, Controls,

     {$IFDEF D17}
     System.Types,
     {$ENDIF}

     TeeTree, TreeFlow, TeCanvas;

type
     TElectricShape=class(TCustomTreeShape);

     TSolidResistorShape=class(TElectricShape)
     protected
       procedure DrawShapeCanvas(const ACanvas:TCanvas3D; Const R:TRect); override;
     end;

     TFuseShape=class(TSolidResistorShape)
     protected
       procedure DrawShapeCanvas(const ACanvas:TCanvas3D; Const R:TRect); override;
     end;

     TResistorShape=class(TElectricShape)
     protected
       procedure DrawShapeCanvas(const ACanvas:TCanvas3D; Const R:TRect); override;
     end;

     TCapacitorShape=class(TElectricShape)
     protected
       procedure DrawShapeCanvas(const ACanvas:TCanvas3D; Const R:TRect); override;
     end;

     TDiodeShape=class(TElectricShape)
     protected
       procedure DrawShapeCanvas(const ACanvas:TCanvas3D; Const R:TRect); override;
     end;

     TGroundShape=class(TElectricShape)
     protected
       procedure DrawShapeCanvas(const ACanvas:TCanvas3D; Const R:TRect); override;
     end;

     TSourceShape=class(TElectricShape)
     protected
       procedure DrawShapeCanvas(const ACanvas:TCanvas3D; Const R:TRect); override;
     end;

     TChasisShape=class(TElectricShape)
     protected
       procedure DrawShapeCanvas(const ACanvas:TCanvas3D; Const R:TRect); override;
     public
       Constructor Create(AOwner:TComponent); override;
     end;

     TOrGateShape=class(TElectricShape)
     protected
       Function GetShapePoints(Const R:TRect; Var P:TShapePoints):Integer; override;
     end;

     TAndGateShape=class(TElectricShape)
     protected
       Function GetShapePoints(Const R:TRect; Var P:TShapePoints):Integer; override;
     end;

     TLampShape=class(TOctagonShape)
     protected
       procedure DrawShapeCanvas(const ACanvas:TCanvas3D; Const R:TRect); override;
     public
       Constructor Create(AOwner: TComponent); override;
     published
       property Color default clYellow;
     end;

implementation

Uses TreeConst, Math;

{ TSolidResistorShape }
procedure TSolidResistorShape.DrawShapeCanvas(const ACanvas: TCanvas3D;
  const R: TRect);
Var tmpX : Integer;
    tmpY : Integer;
begin
  inherited;

  tmpX:=(R.Right-R.Left) div 4;
  tmpY:=(R.Bottom+R.Top) div 2;

  with ACanvas do
  begin
    RectangleWithZ(TeeRect(R.Left+tmpX,R.Top,R.Right-tmpX,R.Bottom),TeeTreeZ);
    HorizLine3D(R.Left,R.Left+tmpX,tmpY,TeeTreeZ);
    HorizLine3D(R.Right,R.Right-tmpX,tmpY,TeeTreeZ);
  end;
end;

{ TResistorShape }
procedure TResistorShape.DrawShapeCanvas(const ACanvas: TCanvas3D; const R: TRect);
Var tmpX  : Integer;
    tmpX2 : Integer;
    tmpY  : Integer;
    tmp   : Integer;
begin
  inherited;

  tmpX:=(R.Right-R.Left) div 8;
  tmpY:=(R.Bottom+R.Top) div 2;

  with ACanvas do
  begin
    HorizLine3D(R.Left,R.Left+tmpX,tmpY,TeeTreeZ);
    tmpX2:=R.Right-tmpX;
    HorizLine3D(R.Right,tmpX2,tmpY,TeeTreeZ);

    tmp:=R.Left+tmpX;
    tmpX:=(R.Right-R.Left) div 9;
    LineWithZ(tmp,tmpY,tmp+tmpX,R.Top,TeeTreeZ);
    Inc(tmp,tmpX);
    LineWithZ(tmp,R.Top,tmp+tmpX,R.Bottom,TeeTreeZ);
    Inc(tmp,tmpX);
    LineWithZ(tmp,R.Bottom,tmp+tmpX,R.Top,TeeTreeZ);
    Inc(tmp,tmpX);
    LineWithZ(tmp,R.Top,tmp+tmpX,R.Bottom,TeeTreeZ);
    Inc(tmp,tmpX);
    LineWithZ(tmp,R.Bottom,tmp+tmpX,R.Top,TeeTreeZ);
    Inc(tmp,tmpX);
    LineWithZ(tmp,R.Top,tmp+tmpX,R.Bottom,TeeTreeZ);
    Inc(tmp,tmpX);
    LineWithZ(tmp,R.Bottom,tmpX2,tmpY,TeeTreeZ);
  end;
end;

{ TCapacitorShape }

procedure TCapacitorShape.DrawShapeCanvas(const ACanvas: TCanvas3D;
  const R: TRect);
var tmpX : Integer;
    tmpC : Integer;
    tmpY : Integer;
begin
  inherited;

  tmpX:=Math.Min(2,(R.Right-R.Left) div 8);
  tmpC:=(R.Right+R.Left) div 2;
  tmpY:=(R.Bottom+R.Top) div 2;

  with ACanvas do
  begin
    HorizLine3D(R.Left,tmpC-tmpX,tmpY,TeeTreeZ);
    HorizLine3D(R.Right,tmpC+tmpX,tmpY,TeeTreeZ);
    VertLine3D(tmpC-tmpX,R.Top,R.Bottom,TeeTreeZ);
    VertLine3D(tmpC+tmpX,R.Top,R.Bottom,TeeTreeZ);
  end;
end;

{ TDiodeShape }
procedure TDiodeShape.DrawShapeCanvas(const ACanvas: TCanvas3D; const R: TRect);
var tmpX : Integer;
    tmpY : Integer;
begin
  inherited;

  tmpX:=(R.Right-R.Left) div 3;
  tmpY:=(R.Bottom+R.Top) div 2;

  with ACanvas do
  begin
    HorizLine3D(R.Left,R.Left+tmpX,tmpY,TeeTreeZ);
    HorizLine3D(R.Right,R.Right-tmpX,tmpY,TeeTreeZ);
    VertLine3D(R.Left+tmpX,R.Top,R.Bottom,TeeTreeZ);

    TriangleWithZ( TeePoint(R.Left+tmpX,tmpY),
                   TeePoint(R.Right-tmpX,R.Top),
                   TeePoint(R.Right-tmpX,R.Bottom), TeeTreeZ);
  end;
end;

{ TGroundShape }

procedure TGroundShape.DrawShapeCanvas(const ACanvas: TCanvas3D; const R: TRect);
var tmpX  : Integer;
    tmpY  : Integer;
    tmpY2 : Integer;
begin
  inherited;

  tmpX:=(R.Left+R.Right) div 2;
  tmpY:=(R.Bottom+R.Top) div 2;

  with ACanvas do
  begin
    VertLine3D(tmpX,R.Top,tmpY,TeeTreeZ);
    HorizLine3D(R.Left,R.Right,tmpY,TeeTreeZ);

    tmpX:=(R.Right-R.Left) div 8;
    tmpY2:=(R.Bottom-R.Top) div 4;

    HorizLine3D(R.Left+tmpX,R.Right-tmpX,tmpY+tmpY2,TeeTreeZ);

    Inc(tmpX,tmpX);
    HorizLine3D(R.Left+tmpX,R.Right-tmpX,tmpY+tmpY2+tmpY2,TeeTreeZ);
  end;
end;

{ TSourceShape }

procedure TSourceShape.DrawShapeCanvas(const ACanvas: TCanvas3D; const R: TRect);
var tmpX  : Integer;
    tmpY  : Integer;
    tmpX2 : Integer;
    tmpY2 : Integer;
    tmpXC : Integer;
begin
  inherited;

  tmpX:=(R.Right-R.Left) div 4;
  tmpY:=(R.Bottom-R.Top) div 4;
  tmpXC:=(R.Right+R.Left) div 2;

  with ACanvas do
  begin
    VertLine3D(tmpXC,R.Top,R.Top+tmpY,TeeTreeZ);
    EllipseWithZ(R.Left,R.Top+tmpY,R.Right,R.Bottom-tmpY,TeeTreeZ);
    VertLine3D(tmpXC,R.Bottom,R.Bottom-tmpY,TeeTreeZ);

    tmpY2:=tmpY div 3;
    tmpX2:=tmpX div 3;

    VertLine3D(tmpXC,R.Top+tmpY+tmpY2,R.Top+tmpY+tmpY2+tmpY2,TeeTreeZ);
    HorizLine3D(tmpXC-tmpX2,tmpXC+tmpX2,R.Top+tmpY+tmpY2+(tmpY2 div 2),TeeTreeZ);
    HorizLine3D(tmpXC-tmpX2,tmpXC+tmpX2,R.Bottom-tmpY-tmpY2-(tmpY2 div 2),TeeTreeZ);
  end;
end;

{ TChasisShape }

constructor TChasisShape.Create(AOwner: TComponent);
begin
  inherited;
  Color:=clBlack;
end;

procedure TChasisShape.DrawShapeCanvas(const ACanvas: TCanvas3D; const R: TRect);
var tmpX  : Integer;
    tmpY  : Integer;
    tmpX2 : Integer;
    t     : Integer;
begin
  inherited;

  tmpX:=(R.Right+R.Left) div 2;
  tmpY:=(R.Bottom-R.Top) div 3;

  with ACanvas do
  begin
    VertLine3D(tmpX,R.Top,R.Top+tmpY,TeeTreeZ);
    RectangleWithZ(TeeRect(R.Left,R.Top+tmpY,R.Right,R.Bottom-tmpY),TeeTreeZ);

    tmpX2:=(R.Right-R.Left) div 8;

    for t:=0 to 7 do
        LineWithZ(R.Left+(t*tmpX2),R.Bottom,R.Left+((t+1)*tmpX2),R.Bottom-tmpY,TeeTreeZ);
  end;
end;

{ TOrGateShape }

function TOrGateShape.GetShapePoints(const R: TRect;
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
      P[AOffset+t].X:=xc+Round(XRadius*Cos(Angle));
      P[AOffset+t].Y:=yc+AFactor*Round(YRadius*Sin(Angle));
    end;
  end;

begin
  result:=33;

  With R do
  begin
    P[0]:=TopLeft;
    xc:=Left;
    yc:=(Bottom+Top) div 2;
    XRadius:=(Right-Left) div 8;
    YRadius:=(Bottom-Top) div 2;
  end;

  tmpOffset:=1.5*pi;
  tmpStep:=Pi/16.0;
  DrawCurve(0,1);

  XRadius:=(R.Right-R.Left) div 2;
  xc:=R.Right-XRadius;
  DrawCurve(16,-1);
end;

{ TAndGateShape }

function TAndGateShape.GetShapePoints(const R: TRect;
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

{ TFuseShape }

procedure TFuseShape.DrawShapeCanvas(const ACanvas: TCanvas3D; const R: TRect);
begin
  inherited;
  ACanvas.HorizLine3D(R.Left,R.Right,(R.Bottom+R.Top) div 2,TeeTreeZ);
end;

{ TLampShape }

constructor TLampShape.Create(AOwner: TComponent);
begin
  inherited;
  Color:=clYellow;
end;

procedure TLampShape.DrawShapeCanvas(const ACanvas: TCanvas3D; const R: TRect);
var tmpX : Integer;
    tmpY : Integer;
begin
  inherited;

  with R do
  begin
    tmpX:=Round((Right-Left)/5.0);
    tmpY:=Round((Bottom-Top)/5.0);
  end;

  with ACanvas do
  begin
    LineWithZ(R.Left+tmpX,R.Top+tmpY,R.Right-tmpX,R.Bottom-tmpY,TeeTreeZ);
    LineWithZ(R.Left+tmpX,R.Bottom-tmpY,R.Right-tmpX,R.Top+tmpY,TeeTreeZ);
  end;
end;

initialization
  RegisterCustomTreeShape(TeeTree_tabElectric, 'Resistor', TResistorShape);
  RegisterCustomTreeShape(TeeTree_tabElectric, 'Solid Resistor', TSolidResistorShape);
  RegisterCustomTreeShape(TeeTree_tabElectric, 'Fuse', TFuseShape);
  RegisterCustomTreeShape(TeeTree_tabElectric, 'Capacitor', TCapacitorShape);
  RegisterCustomTreeShape(TeeTree_tabElectric, 'Diode', TDiodeShape);
  RegisterCustomTreeShape(TeeTree_tabElectric, 'Ground', TGroundShape);
  RegisterCustomTreeShape(TeeTree_tabElectric, 'Source', TSourceShape);
  RegisterCustomTreeShape(TeeTree_tabElectric, 'Chasis', TChasisShape);
  RegisterCustomTreeShape(TeeTree_tabElectric, 'OR Gate', TOrGateShape);
  RegisterCustomTreeShape(TeeTree_tabElectric, 'AND Gate', TAndGateShape);
  RegisterCustomTreeShape(TeeTree_tabElectric, 'Lamp', TLampShape);
finalization
  UnRegisterCustomTreeShapes([ TResistorShape,TSolidResistorShape,TFuseShape,
                               TCapacitorShape,TDiodeShape,TGroundShape,
                               TSourceShape,TChasisShape,TOrGateShape,
                               TAndGateShape,TLampShape
                             ]);
end.
