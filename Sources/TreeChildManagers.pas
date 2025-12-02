{**********************************************}
{   TTree Component Library                    }
{   Several "Child Align Manager" components.  }
{   Copyright (c) 2001-2025 by Steema Software }
{**********************************************}
{$I TeeDefs.inc}
{$I TeeDefs.inc}
unit TreeChildManagers;

interface

// This unit contains classes that derive from TeeTree "TChildManager" class.
//
// This classes perform automatic positioning of children nodes.
//

Uses {$IFNDEF LINUX}
     Windows,
     {$ENDIF}
     Graphics,
     TeeTree, Classes;

type
  TTreeExplorerAlignRight=class(TTreeExplorerAlignChild)
  public
    Constructor Create;
    Function CalcXYCross(const ANode,AParent:TTreeNodeShape):TPoint; override;
    Function XPosition(const ANode:TTreeNodeShape; ABrotherIndex:Integer):Integer; override;
  end;

  TTreeCircularAlignChild=class(TChildManager)
  private
    FOffset     : Integer;
    FTotalAngle : Integer;
    FXRadius    : Integer;
    FYRadius    : Integer;
    FYOffset    : Integer;
    FXOffset    : Integer;

    Function AngleNode(const ANode:TTreeNodeShape):Double;
  public
    Constructor Create;

    Function CalcXYCross(const ANode,AParent:TTreeNodeShape):TPoint; override;
    Function DrawConnection(const AConnection:TTreeConnection):Boolean; override;
    Function XPosition(const ANode:TTreeNodeShape; ABrotherIndex:Integer):Integer; override;
    Function YPosition(const ANode:TTreeNodeShape; ABrotherIndex:Integer):Integer; override;

    property AngleOffset:Integer read FOffset write FOffset default 0;
    property TotalAngle:Integer read FTotalAngle write FTotalAngle default 360;
    property XOffset:Integer read FXOffset write FXOffset default 0;
    property XRadius:Integer read FXRadius write FXRadius default 100;
    property YOffset:Integer read FYOffset write FYOffset default 0;
    property YRadius:Integer read FYRadius write FYRadius default 100;
  end;

  TTreeSideAlignChild=class(TChildManager)
  private
    FCrossMargin   : Integer;
    FHorizMargin   : Integer;
    FToShapeOffset : Integer;
    FVertMargin    : Integer;
  public
    Constructor Create; virtual;

    property CrossMargin:Integer read FCrossMargin write FCrossMargin;
    property HorizMargin:Integer read FHorizMargin write FHorizMargin;
    property ToShapeOffset:Integer read FToShapeOffset write FToShapeOffset;
    property VertMargin:Integer read FVertMargin write FVertMargin;
  end;

  TTreeTopBottomAlignChild=class(TTreeSideAlignChild)
  public
    Constructor Create; override;

    Function CalcXYCross(const ANode,AParent:TTreeNodeShape):TPoint; override;
    Function DrawConnection(const AConnection:TTreeConnection):Boolean; override;
    Function XPosition(const ANode:TTreeNodeShape; ABrotherIndex:Integer):Integer; override;
    Function YPosition(const ANode:TTreeNodeShape; ABrotherIndex:Integer):Integer; override;
  end;

  TTreeLeftRightAlignChild=class(TTreeSideAlignChild)
  public
    Constructor Create; override;

    Function CalcXYCross(const ANode,AParent:TTreeNodeShape):TPoint; override;
    Function DrawConnection(const AConnection:TTreeConnection):Boolean; override;
    Function XPosition(const ANode:TTreeNodeShape; ABrotherIndex:Integer):Integer; override;
    Function YPosition(const ANode:TTreeNodeShape; ABrotherIndex:Integer):Integer; override;
  end;

  TTreeListViewAlignChild=class(TChildManager)
  private
    RowCount  : Integer;
    RowHeight : Integer;

    FHorizMargin : Integer;
    FVertMargin  : Integer;

    IHeight      : Integer;
    IWidth       : Integer;

    Procedure CalculateSizes(const ANode:TTreeNodeShape);
    procedure SetVertMargin(const Value: Integer);
    procedure SetHorizMargin(const Value: Integer);
  public
    ColWidth  : Integer;

    Constructor Create; virtual;

    Function CalcXYCross(const ANode,AParent:TTreeNodeShape):TPoint; override;
    Function DrawConnection(const AConnection:TTreeConnection):Boolean; override;
    Function XPosition(const ANode:TTreeNodeShape; ABrotherIndex:Integer):Integer; override;
    Function YPosition(const ANode:TTreeNodeShape; ABrotherIndex:Integer):Integer; override;

    property HorizMargin:Integer read FHorizMargin write SetHorizMargin default 5;
    property VertMargin:Integer read FVertMargin write SetVertMargin default 2;
  end;

implementation

Uses TeCanvas;

{ TTreeExplorerAlignRight }
constructor TTreeExplorerAlignRight.Create;
begin
  inherited;
  ArrowToAngle:=180;
end;

function TTreeExplorerAlignRight.CalcXYCross(const ANode,
  AParent: TTreeNodeShape): TPoint;

  // Returns true if parent node has an automatic connection to node.
  Function AutoConnection:Boolean;
  var tmp : TTreeConnection;
  begin
    tmp:=AParent.Connections.ToShape(ANode);
    result:=Assigned(tmp) and (tmp.Style=csAuto);
  end;

var t   : Integer;
    tmp : Integer;
begin
  with ANode do
    result.Y:=((Y0+Y1) div 2)+Tree.ChartBounds.Top; // YCenter

  if Assigned(AParent) then
  begin
    With AParent do
    begin
      if ANode.AutoPosition.Left or AutoConnection then // optimized.
      begin
        result.X:=4+1+X1+Tree.ChartBounds.Left+2*TeePictureHorizMargin;
        exit;
      end;
    end;
  end
  else
  if ANode.AutoPosition.Left then
  With ANode.Tree.Roots do
  begin
    t:=IndexOf(ANode);
    if (t>0) and (Items[t-1].AutoPosition.Left) then // is not the first root
    begin
      result.X:=CalcXYCross(Items[t-1],nil).X; // return previous root cross-box
      exit;
    end;
  end;

  With ANode.Tree.CrossBox do
  if Visible then tmp:=Size div 2
             else tmp:=0;

  result.X:=ANode.AdjustedRectangle.Right+CrossMargin+tmp;
end;

function TTreeExplorerAlignRight.XPosition(const ANode: TTreeNodeShape; ABrotherIndex:Integer): Integer;
var tmp : Integer;
begin
  With ANode do
  if Assigned(Parent) then // child node
  begin
    // indent X from parent
    if Tree.ShowImages and (Parent.GetPicture.Width=0) and
       (ANode.GetPicture.Width>0) then
          result:=Parent.X1-HorizMargin-ANode.GetPicture.Width-TeePictureHorizMargin
    else
       result:=Parent.X1-HorizMargin;
    Dec(result,Width);
  end
  else
  begin
    tmp:=ABrotherIndex;

    if (tmp=0) or (not Tree.Roots[tmp-1].AutoPosition.Left) then  // first tree root
    begin
      result:=Tree.ClientWidth-2-Width;

      if Tree.ShowImages and (ANode.GetPicture.Width>0) then
         Dec(result,ANode.GetPicture.Width+TeePictureHorizMargin);
      if AnyRootShouldDrawCross(ANode.Tree) then
         Dec(result,Tree.CrossBox.Size+CrossMargin+2);
    end
    else result:=Tree.Roots[tmp-1].X0; // same X as previous root
  end;
end;

{ TTreeCircularAlignChild }

function TTreeCircularAlignChild.CalcXYCross(const ANode,
  AParent: TTreeNodeShape): TPoint;
var tmp : Integer;
begin
  With ANode.Tree.CrossBox do
  if Visible then tmp:=Size div 2
             else tmp:=0;

  result.X:=ANode.AdjustedRectangle.Left-TeeCrossBoxHorizMargin-tmp;;
  result.Y:=ANode.Y0+(ANode.Height div 2);
end;

type TTreeConnectionAccess=class(TTreeConnection);

Constructor TTreeCircularAlignChild.Create;
begin
  inherited;
  FXRadius:=100;
  FYRadius:=100;
  FTotalAngle:=360;
end;

function TTreeCircularAlignChild.DrawConnection(const AConnection: TTreeConnection): Boolean;
begin
  result:=True;
  AConnection.Style:=csLine;
  TTreeConnectionAccess(AConnection).InternalDraw;
end;

Function TTreeCircularAlignChild.AngleNode(const ANode:TTreeNodeShape):Double;
begin
  result:=TeePiStep*(FOffset+(FTotalAngle*ANode.BrotherIndex/ANode.Parent.Count));
end;

function TTreeCircularAlignChild.XPosition(const ANode: TTreeNodeShape; ABrotherIndex:Integer): Integer;
begin
  with ANode do
  if Assigned(Parent) then
  begin
    result:=FXOffset+Parent.XCenter+
            Round(FXRadius*Sin(AngleNode(ANode)))-(Width div 2);
  end
  else result:=X0;
end;

function TTreeCircularAlignChild.YPosition(const ANode: TTreeNodeShape;
  ABrotherIndex: Integer): Integer;
begin
  with ANode do
  if Assigned(Parent) then
  begin
    result:=FYOffset+Parent.YCenter+
            Round(FYRadius*Cos(AngleNode(ANode)))-(Height div 2);
  end
  else result:=Y0;
end;

{ TTreeTopBottomAlignChild }

function TTreeTopBottomAlignChild.CalcXYCross(const ANode,AParent: TTreeNodeShape): TPoint;
begin
  result.X:=ANode.XCenter;
  result.Y:=ANode.Y1+CrossMargin;
end;

constructor TTreeTopBottomAlignChild.Create;
begin
  inherited;
  FVertMargin:=32;
  FHorizMargin:=8;
end;

function TTreeTopBottomAlignChild.DrawConnection(const AConnection: TTreeConnection): Boolean;
begin
  result:=True;

  with TTreeConnectionAccess(AConnection) do
  begin
    with Points do
    if Count=0 then
    begin
      Clear;
      Add(cpsFromPercent,50,cpsFromPercent,100);
      Add(cpsPrevious,0,cpsPrevious,FVertMargin div 2);
      Add(cpsToPercent,50,cpsPrevious,0);
      Add(cpsPrevious,0,cpsToRel,FToShapeOffset);
    end
    else
    if Count>3 then
       Item[3].YValue:=FToShapeOffset;

    InternalDraw;
  end;
end;

function TTreeTopBottomAlignChild.XPosition(const ANode: TTreeNodeShape; ABrotherIndex:Integer): Integer;
var t   : Integer;
    tmp : Integer;
begin
  with ANode do
  if Assigned(Parent) then
  begin
    tmp:=0;
    for t:=0 to Parent.Count-1 do
        Inc(tmp,Parent.Children[t].Width);

    Inc(tmp,FHorizMargin*(Parent.Count-1));

    result:=Parent.XCenter-(tmp div 2);

    for t:=0 to BrotherIndex-1 do
        Inc(result,Parent.Children[t].Width+FHorizMargin);
  end
  else
    result:=X0;
end;

function TTreeTopBottomAlignChild.YPosition(const ANode: TTreeNodeShape;
  ABrotherIndex: Integer): Integer;
begin
  with ANode do
  if Assigned(Parent) then result:=Parent.Y1+FVertMargin
                      else result:=Y0;
end;

{ TTreeLeftRightAlignChild }
Constructor TTreeLeftRightAlignChild.Create;
begin
  inherited;
  FVertMargin:=8;
  FHorizMargin:=32;
end;

function TTreeLeftRightAlignChild.CalcXYCross(const ANode,AParent: TTreeNodeShape): TPoint;
begin
  result.X:=ANode.X1+CrossMargin;
  result.Y:=ANode.YCenter;
end;

function TTreeLeftRightAlignChild.DrawConnection(const AConnection: TTreeConnection): Boolean;
begin
  result:=True;

  with TTreeConnectionAccess(AConnection) do
  begin
    with Points do
    if Count=0 then
    begin
      Clear;
      Add(cpsFromPercent,100,cpsFromPercent,50);
      Add(cpsPrevious,FHorizMargin div 2,cpsPrevious,0);
      Add(cpsPrevious,0,cpsToPercent,50);
      Add(cpsToRel,FToShapeOffset,cpsPrevious,0);
    end
    else
    if Count>3 then
       Item[3].XValue:=FToShapeOffset;

    InternalDraw;
  end;
end;

function TTreeLeftRightAlignChild.XPosition(const ANode: TTreeNodeShape; ABrotherIndex:Integer): Integer;
begin
  with ANode do
  if Assigned(Parent) then result:=Parent.X1+FHorizMargin
                      else result:=X0;
end;

function TTreeLeftRightAlignChild.YPosition(const ANode: TTreeNodeShape;
  ABrotherIndex: Integer): Integer;
var t   : Integer;
    tmp : Integer;
begin
  with ANode do
  if Assigned(Parent) then
  begin
    tmp:=0;
    for t:=0 to Parent.Count-1 do
        Inc(tmp,Parent.Children[t].Height);

    Inc(tmp,FVertMargin*(Parent.Count-1));

    result:=Parent.YCenter-(tmp div 2);

    for t:=0 to BrotherIndex-1 do
        Inc(result,Parent.Children[t].Height+FVertMargin);
  end
  else
    result:=Y0;
end;

{ TTreeSideAlignChild }

constructor TTreeSideAlignChild.Create;
begin
  inherited;
  FCrossMargin:=8;
  FToShapeOffset:=-4;
end;

{ TTreeListViewAlignChild }

function TTreeListViewAlignChild.CalcXYCross(const ANode,AParent: TTreeNodeShape): TPoint;
begin
  result.X:=ANode.X0;
  result.Y:=ANode.Y0;
end;

function TTreeListViewAlignChild.DrawConnection(const AConnection: TTreeConnection): Boolean;
begin
  result:=True; // keep drawing nodes, but do not draw connections
end;

Procedure TTreeListViewAlignChild.CalculateSizes(const ANode:TTreeNodeShape);
begin
  with ANode.Tree do
  if (IHeight<>ChartHeight) or (IWidth<>ChartWidth) then
  begin
    IHeight:=ChartHeight;
    IWidth:=ChartWidth;

    RowHeight:=ANode.Height+FVertMargin;

    RowCount:=Trunc(IHeight/RowHeight);

    // check if horiz.scroll bar *will* be visible...
    if not HorzScrollBar.Visible then
    with Roots do
    if XPosition(Last,Count-1)+Last.Width>IWidth then
       Dec(RowCount);
  end;
end;

function TTreeListViewAlignChild.XPosition(const ANode: TTreeNodeShape; ABrotherIndex:Integer): Integer;

  Function ImageWidthColumn(Col:Integer):Integer;
  var t    : Integer;
      tmp  : Integer;
      tmpW : Integer;
  begin
    result:=0;
    if ANode.Tree.ShowImages then
       for t:=0 to RowCount-1 do
       begin
         tmp:=t+(Col*RowCount);
         if tmp<ANode.Tree.Roots.Count then
         begin
             with ANode.Tree.Roots[tmp] do
                  if ImageAlignment=iaAutomatic then
                  begin
                    tmpW:=GetPicture.Width;
                    if tmpW>result then result:=tmpW;
                  end
         end
         else
           break;
       end;
  end;

  Function ColumnWidth(Col:Integer):Integer;
  var tmp : Integer;
      t   : Integer;
  begin
    result:=0;
    for t:=0 to RowCount-1 do
    begin
      with ANode.Tree.Roots[t+(Col*RowCount)] do tmp:=Width;
      if tmp>result then result:=tmp;
    end;

    Inc(result,ImageWidthColumn(Col)+TeePictureHorizMargin+FHorizMargin);
  end;

var tmpCol : Integer;
    t      : Integer;
begin
  CalculateSizes(ANode);

  if Assigned(ANode.Parent) then
     result:=ANode.X0
  else
  begin
    tmpCol:=ABrotherIndex div RowCount;

    result:=ImageWidthColumn(tmpCol)+TeePictureHorizMargin+FHorizMargin;

    if ColWidth=0 then  // automatic column width
       for t:=0 to tmpCol-1 do
           Inc(result,ColumnWidth(t))
    else
       Inc(result,ColWidth*tmpCol); // fixed column width
  end;
end;

function TTreeListViewAlignChild.YPosition(const ANode: TTreeNodeShape;
  ABrotherIndex: Integer): Integer;
var tmp  : Integer;
begin
  CalculateSizes(ANode);
  if Assigned(ANode.Parent) then result:=ANode.Y0
  else
  begin
    tmp:=ANode.Tree.Roots.IndexOf(ANode);
    result:=RowHeight*(tmp mod RowCount);
  end;
end;

constructor TTreeListViewAlignChild.Create;
begin
  inherited;
  FVertMargin:=2;
  FHorizMargin:=5;
end;

procedure TTreeListViewAlignChild.SetVertMargin(const Value: Integer);
begin
  FVertMargin:=Value;
  IHeight:=0;
end;

procedure TTreeListViewAlignChild.SetHorizMargin(const Value: Integer);
begin
  FHorizMargin:=Value;
  IHeight:=0;
end;

end.
