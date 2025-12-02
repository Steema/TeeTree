unit RandomNodes;
{$I TeeDefs.inc}

// Simple unit with a procedure to Add Random Tree Nodes to a TTree

interface

uses
  {$IFDEF FMX}
  FMXTee.Tree
  {$ELSE}
  TeeTree
  {$ENDIF};

procedure AddRandomNodes(const ATree:TTree);

implementation

uses
  {$IFDEF MSWINDOWS}
  Windows,
  {$ENDIF}

  Math, SysUtils,
  {$IFDEF FMX}
  FMXTee.Canvas, FMXTee.Filters
  {$ELSE}
  Graphics, TeeFilters
  {$ENDIF}
  ;

const
  // Number of random nodes to add:
  MAX_NODES=4000;

  // Max Logical dimensions:
  TOTAL_WIDTH=16000;
  TOTAL_HEIGHT=20000;

  // Add some random connections between nodes:
  AddConnections:Boolean=False; //True;

procedure AddRandomNodes(const ATree:TTree);

  // Returns the first node that is "near" to ANode.
  // "Near" means distance is about a 5% of total logical size
  function FindNearNode(const ANode:TTreeNodeShape):TTreeNodeShape;
  var t : Integer;
      tmpMinDistance,
      tmp : Integer;
      tmpNode : TTreeNodeShape;
  begin
    tmpMinDistance:=Min(TOTAL_WIDTH,TOTAL_HEIGHT) div 20;

    for t:=0 to ATree.Shapes.Count-1 do
    begin
      tmpNode:=ATree.Shapes[t];

      if tmpNode<>ANode then
      begin
        tmp:=Abs(tmpNode.Left-ANode.Left)+Abs(tmpNode.Top-ANode.Top);

        if tmp<tmpMinDistance then
        begin
          result:=tmpNode;
          Exit;
        end;
      end;
    end;

    // No shapes found, so simply return a random node:
    result:=ATree.Shape[Random(ATree.Shapes.Count)]
   end;

var t : Integer;
    tmp : TTreeNodeShape;
    Hue, Lum, Sat : Word;
    tmpC : TTreeConnection;
    tmpRandom : Integer;
begin
  ATree.Clear;

  ATree.BeginUpdate;

  for t:=0 to MAX_NODES-1 do
  begin
    tmp:=TTreeNodeShape.Create(ATree.Owner);

    tmp.ImageIndex:=tiNone;

    tmp.Left:=Random(TOTAL_WIDTH);
    tmp.Top:=Random(TOTAL_HEIGHT);

    tmp.Width:=Max(60,Random(Round(ATree.Width*0.25)));
    tmp.Height:=Max(60,(tmp.Width div 2)+Random(tmp.Width div 12));

    tmpRandom:=Random(10);

    if tmpRandom<5 then
       tmp.Style:=tssRectangle
    else
    if tmpRandom<8 then
       tmp.Style:=tssCircle
    else
       tmp.Style:=tssDiamond;

    tmp.Color:=RGB(Random(255),Random(255),Random(255));

    ColorToHLS(tmp.Color,Hue,Lum,Sat);

    if Lum>128 then
       tmp.Font.Color:=clBlack
    else
       tmp.Font.Color:=clWhite;

    tmp.Font.Size:=Round(Max(8,0.2*Min(tmp.Width,tmp.Height)));

    tmp.SimpleText:=IntToStr(t);

    tmp.Shadow.Size:=6;
    tmp.Shadow.Transparency:=10;
    
    tmp.Tree:=ATree;
  end;

  if AddConnections then
  begin
    ATree.GlobalFormat.Connection.ArrowTo.Size:=12;

    ATree.GlobalFormat.Connection.Border.Width:=2;
    ATree.GlobalFormat.Connection.Border.Style:=psSolid;
    ATree.GlobalFormat.Connection.Border.SmallDots:=False;
    ATree.GlobalFormat.Connection.Border.Color:=clBlack;

    for t:=0 to (MAX_NODES div 6)-1 do
    begin
      tmpC:=TTreeConnection.Create(ATree.Owner);
      tmpC.Tree:=ATree;

      tmpC.FromShape:=ATree.Shape[Random(ATree.Shapes.Count)];
      tmpC.ToShape:=FindNearNode(tmpC.FromShape);

      tmpC.Style:=csLine;
    end;
  end;

  ATree.EndUpdate;
end;

end.
