{***********************************************}
{   TTree Component - UML Shapes                }
{   Copyright (c) 2001-2025 by Steema Software  }
{***********************************************}
{$I TeeDefs.inc}
unit TreeUML;

{
  Several customized shapes used in UML
  (Unified Modelling Language) diagramms.
}

interface

Uses {$IFNDEF LINUX}
     Windows,
     {$ENDIF}
     Classes, Graphics, Controls,

     {$IFDEF D17}
     System.Types,
     {$ENDIF}

     TeeTree, TeeProcs, TeCanvas;

type
   TUMLShape=TCustomTreeShape;

   TActorShape=class(TUMLShape)
   protected
     procedure DrawShapeCanvas(const ACanvas:TCanvas3D; Const R:TRect); override;
   end;

   TUMLRectangle=class(TTreeNodeShape)
   public
     Constructor Create(AOwner:TComponent); override;
   published
     property ImageIndex default tiNone;
     property VertTextAlign default vtaTop;
   end;

   TClassShape=class(TUMLRectangle)
   protected
     procedure DrawShapeCanvas(const ACanvas:TCanvas3D; Const R:TRect); override;
   end;

   TInterfaceShape=class(TUMLRectangle)
   protected
     procedure DrawShapeCanvas(const ACanvas:TCanvas3D; Const R:TRect); override;
   end;

   TPackageShape=class(TUMLShape)
   protected
     procedure DrawShapeCanvas(const ACanvas:TCanvas3D; Const R:TRect); override;
     Function GetShapePoints(Const R:TRect; Var P:TShapePoints):Integer; override;
   end;

   TActionShape=class(TUMLShape)
   protected
     function GetShapePoints(const R: TRect; var P: TShapePoints): Integer; override;
   end;

   TProcShape=class(TUMLShape)
   protected
     procedure DrawShapeCanvas(const ACanvas:TCanvas3D; Const R:TRect); override;
   public
     Constructor Create(AOwner:TComponent); override;
   end;

   TNoteShape=class(TUMLShape)
   protected
     procedure DrawShapeCanvas(const ACanvas:TCanvas3D; Const R:TRect); override;
     function GetShapePoints(const R: TRect; var P: TShapePoints): Integer; override;
   end;

   TStoreShape=class(TUMLShape)
   protected
     procedure DrawShapeCanvas(const ACanvas:TCanvas3D; Const R:TRect); override;
   public
     Constructor Create(AOwner:TComponent); override;
   end;

implementation

Uses TreeConst;

{ TActorShape }

procedure TActorShape.DrawShapeCanvas(const ACanvas: TCanvas3D; const R: TRect);
var tmpX  : Integer;
    tmpY  : Integer;
    tmpY2 : Integer;
    tmp   : Integer;
begin
  inherited;

  with R do
  begin
    tmpX:=(Right+Left) div 2;
    tmpY:=(Bottom-Top) div 3;
    tmpY2:=(Bottom-Top) div 9;
  end;

  with ACanvas do
  begin
    HorizLine3D(R.Left,R.Right,R.Top+tmpY,TeeTreeZ);
    VertLine3D(tmpX,R.Top+tmpY-tmpY2,R.Bottom-tmpY,TeeTreeZ);
    LineWithZ(tmpX,R.Bottom-tmpY,R.Left,R.Bottom,TeeTreeZ);
    LineWithZ(tmpX,R.Bottom-tmpY,R.Right,R.Bottom,TeeTreeZ);
    tmp:=(tmpY-tmpY2) div 2;
    EllipseWithZ(tmpX-tmp,R.Top,tmpX+tmp,R.Top+tmp+tmp,TeeTreeZ);
  end;
end;

{ TUMLRectangle }

Constructor TUMLRectangle.Create(AOwner: TComponent);
begin
  inherited;
  VertTextAlign:=vtaTop;
  ImageIndex:=tiNone;
end;

{ TClassShape }

procedure TClassShape.DrawShapeCanvas(const ACanvas: TCanvas3D; const R: TRect);
var tmpY : Integer;
begin
  inherited;

  tmpY:=TextLinesCount*ACanvas.TextHeight(TeeCharForHeight);
  ACanvas.HorizLine3D(R.Left,R.Right,R.Top+tmpY+1,TeeTreeZ);
  tmpY:=((R.Bottom-R.Top)-tmpY) div 2;
  ACanvas.HorizLine3D(R.Left,R.Right,R.Bottom-tmpY,TeeTreeZ);
end;

{ TPackageShape }

procedure TPackageShape.DrawShapeCanvas(const ACanvas: TCanvas3D;
  const R: TRect);
var tmpX : Integer;
    tmpY : Integer;
begin
  inherited;
  tmpY:=(R.Bottom-R.Top) div 4;
  tmpX:=(R.Right-R.Left) div 3;
  ACanvas.HorizLine3D(R.Left,R.Left+tmpX,R.Top+tmpY,TeeTreeZ);
end;

function TPackageShape.GetShapePoints(const R: TRect;
  var P: TShapePoints): Integer;
var tmpX : Integer;
    tmpY : Integer;
begin
  result:=6;
  P[0]:=R.TopLeft;
  P[1]:=TeePoint(R.Left,R.Bottom);
  P[2]:=R.BottomRight;
  tmpY:=(R.Bottom-R.Top) div 4;
  P[3]:=TeePoint(R.Right,R.Top+tmpY);
  tmpX:=(R.Right-R.Left) div 3;
  P[4]:=TeePoint(R.Left+tmpX,R.Top+tmpY);
  P[5]:=TeePoint(R.Left+tmpX,R.Top);
end;

{ TInterfaceShape }

procedure TInterfaceShape.DrawShapeCanvas(const ACanvas: TCanvas3D;
  const R: TRect);
var tmpY : Integer;
begin
  inherited;
  tmpY:=TextLinesCount*ACanvas.TextHeight(TeeCharForHeight);
  ACanvas.HorizLine3D(R.Left,R.Right,R.Top+tmpY+1,TeeTreeZ);
end;

{ TActionShape }

function TActionShape.GetShapePoints(const R: TRect;
  var P: TShapePoints): Integer;
var xc      : Integer;
    yc      : Integer;
    XRadius : Integer;
    YRadius : Integer;
    tmpOffset : Double;
    tmpStep : Double;

  Procedure DrawCurve(AOffset,AXFactor,AYFactor:Integer);
  Var t     : Integer;
      Angle : Double;
  begin
    for t:=1 to 16 do
    begin
      Angle:=tmpOffset+t*tmpStep;
      P[AOffset+t].X:=xc+AXFactor*Round(XRadius*Cos(Angle));
      P[AOffset+t].Y:=yc+AYFactor*Round(YRadius*Sin(Angle));
    end;
  end;

begin
  result:=34;
  With R do
  begin
    yc:=(Bottom+Top) div 2;
    XRadius:=(Right-Left) div 6;
    YRadius:=(Bottom-Top) div 2;
    xc:=R.Left+XRadius;
    P[1]:=TeePoint(Left+XRadius,Top);
    P[0]:=TeePoint(Right-XRadius,Top);
  end;
  tmpOffset:=1.5*pi;
  tmpStep:=Pi/16.0;
  DrawCurve(1,-1,1);

  P[18]:=TeePoint(R.Left+XRadius,R.Bottom);

  xc:=R.Right-XRadius;
  DrawCurve(18,1,-1);
end;

{ TProcShape }

Constructor TProcShape.Create(AOwner: TComponent);
begin
  inherited;
  Style:=tssCircle;
end;

procedure TProcShape.DrawShapeCanvas(const ACanvas: TCanvas3D; const R: TRect);
begin
  inherited;
  ACanvas.VertLine3D(R.Left-4,R.Top+2,R.Bottom-2,TeeTreeZ);
  ACanvas.HorizLine3D(R.Left-4,R.Left,(R.Top+R.Bottom) div 2,TeeTreeZ);
end;

{ TNoteShape }

Const TeeNoteShapeSize=0.1;

procedure TNoteShape.DrawShapeCanvas(const ACanvas: TCanvas3D; const R: TRect);
var tmpX : Integer;
    tmpY : Integer;
begin
  inherited;
  tmpX:=Round(TeeNoteShapeSize*(R.Right-R.Left));
  tmpY:=Round(TeeNoteShapeSize*(R.Bottom-R.Top));
  ACanvas.VertLine3D(R.Right-tmpX,R.Top,R.Top+tmpY,TeeTreeZ);
  ACanvas.HorizLine3D(R.Right-tmpX,R.Right,R.Top+tmpY,TeeTreeZ);
end;

function TNoteShape.GetShapePoints(const R: TRect; var P: TShapePoints): Integer;
begin
  result:=5;
  P[0]:=R.TopLeft;
  P[1]:=TeePoint(R.Left,R.Bottom);
  P[2]:=R.BottomRight;
  P[3]:=TeePoint(R.Right,R.Top+Round(TeeNoteShapeSize*(R.Bottom-R.Top)));
  P[4]:=TeePoint(R.Right-Round(TeeNoteShapeSize*(R.Right-R.Left)),R.Top);
end;

{ TStoreShape }

Constructor TStoreShape.Create(AOwner: TComponent);
begin
  inherited;
  Style:=tssCircle;
end;

procedure TStoreShape.DrawShapeCanvas(const ACanvas: TCanvas3D; const R: TRect);
begin
  inherited;
  ACanvas.HorizLine3D(R.Left+4,R.Right-4,R.Bottom+2,TeeTreeZ);
  ACanvas.VertLine3D((R.Left+R.Right) div 2,R.Bottom+2,R.Bottom,TeeTreeZ);
end;

initialization
  RegisterCustomTreeShape(TeeTree_tabUML, 'Package', TPackageShape);
  RegisterCustomTreeShape(TeeTree_tabUML, 'Class', TClassShape);
  RegisterCustomTreeShape(TeeTree_tabUML, 'Interface', TInterfaceShape);
  RegisterCustomTreeShape(TeeTree_tabUML, 'Action', TActionShape);
  RegisterCustomTreeShape(TeeTree_tabUML, 'Actor', TActorShape);
  RegisterCustomTreeShape(TeeTree_tabUML, 'Procedure', TProcShape);
  RegisterCustomTreeShape(TeeTree_tabUML, 'Note', TNoteShape);
  RegisterCustomTreeShape(TeeTree_tabUML, 'Store', TStoreShape);
finalization
  UnRegisterCustomTreeShapes([ TActorShape, TClassShape,
                               TInterfaceShape, TPackageShape,
                               TActionShape, TProcShape, TNoteShape,
                               TStoreShape
                             ]);
end.
