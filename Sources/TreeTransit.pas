{***********************************************}
{   TTree Component - Transit Shapes            }
{   Copyright (c) 2001-2025 by Steema Software  }
{***********************************************}
{$I TeeDefs.inc}
unit TreeTransit;

{ Several custom shapes used in streets and roads... }
interface

Uses {$IFNDEF LINUX}
     Windows,
     {$ENDIF}
     Classes, Graphics, Controls,

     TeeTree, TreeFlow, TeCanvas;

type TTransitShape=class(TCustomTreeShape);

     TStopShape=class(TOctagonShape)
     public
       Constructor Create(AOwner: TComponent); override;
       Procedure RecalcSize(const ACanvas:TCanvas3D); override;
     published
       property Color default clRed;
     end;

     TYieldShape=class(TTransitShape)
     public
       Constructor Create(AOwner: TComponent); override;
     published
       property Color default clYellow;
       property Style default tssTriangleBottom;
     end;

     TSlowShape=class(TTransitShape)
     public
       Constructor Create(AOwner: TComponent); override;
     published
       property Color default clYellow;
       property Style default tssDiamond;
     end;

     TDangerShape=class(TTransitShape)
     public
       Constructor Create(AOwner: TComponent); override;
     published
       property Color default clRed;
       property Style default tssDiamond;
     end;

implementation

Uses TreeConst;

{ TStopShape }

constructor TStopShape.Create(AOwner: TComponent);
begin
  inherited;
  Color:=clRed;
  Border.Color:=clWhite;
  Font.Color:=clWhite;
  Font.Style:=[fsBold];
  Text.Clear;
  Text.Add('STOP');
end;

procedure TStopShape.RecalcSize(const ACanvas:TCanvas3D);
var tmp : Integer;
begin
  inherited;
  tmp:=Width;
  tmp:=Round(1.1*tmp);
  Height:=tmp;
  Width:=tmp;
  ChangeAutoSize(True);
end;

{ TYieldShape }

constructor TYieldShape.Create(AOwner: TComponent);
begin
  inherited;
  Border.Color:=clBlack;
  Border.Visible:=True;
  Color:=clYellow;
  Style:=tssTriangleBottom;
  Text.Clear;
  Text.Add('YIELD');
end;

{ TSlowShape }

constructor TSlowShape.Create(AOwner: TComponent);
begin
  inherited;
  Color:=clYellow;
  Style:=tssDiamond;
  Font.Style:=[fsBold];
  Text.Clear;
  Text.Add('SLOW');
end;

{ TDangerShape }

constructor TDangerShape.Create(AOwner: TComponent);
begin
  inherited;
  Color:=clRed;
  Style:=tssDiamond;
  Font.Color:=clWhite;
  Text.Clear;
  Text.Add('DANGER');
end;

initialization
  RegisterCustomTreeShape(TeeTree_tabTransit, 'Stop', TStopShape);
  RegisterCustomTreeShape(TeeTree_tabTransit, 'Yield', TYieldShape);
  RegisterCustomTreeShape(TeeTree_tabTransit, 'Slow', TSlowShape);
  RegisterCustomTreeShape(TeeTree_tabTransit, 'Danger', TDangerShape);
finalization
  UnRegisterCustomTreeShapes([ TStopShape, TYieldShape, TSlowShape,
                               TDangerShape ]);
end.
