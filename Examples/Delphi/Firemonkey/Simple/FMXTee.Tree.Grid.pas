unit FMXTee.Tree.Grid;
{$I TeeDefs.inc}

{$DEFINE FMX}

interface

uses
  System.Types, System.UITypes,
  System.Classes, System.Math,
  FMXTee.Canvas,
  FMXTee.Tree, System.Rtti, System.TypInfo;

Const MaxRows=1000;
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
    procedure DrawShapeCanvas(ACanvas:TCanvas3D; Const R:TRect); override;
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
    Procedure RecalcSize(ACanvas:TCanvas3D); override;

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

  TGridTree=class
  private
    {$IFDEF NEXTGEN}[weak]{$ENDIF} ITree : TCustomTree;
  public
    Constructor Create(ATree:TCustomTree);

    function AddHeader(const AFields:Array of TValue):TGridShape;
    function AddRoot(const AFields:Array of TValue):TGridShape;
    function AddChild(AParent:TTreeNodeShape; const AFields:Array of TValue):TGridShape;

    procedure RecalcDimensions;
  end;

implementation

uses
  System.SysUtils;

{ TGridTree }

constructor TGridTree.Create(ATree: TCustomTree);
begin
  inherited Create;
  ITree:=ATree;
end;

function TGridTree.AddHeader(const AFields: array of TValue):TGridShape;
var t : Integer;
begin
  result:=AddRoot(AFields);
  result.Border.Show;

  for t := 0 to result.Columns-1 do
  with result.Cells[0,t] do
  begin
    Font.Size:=14;
    Height:=26;
  end;
end;

function IsTextField(AField:TValue):Boolean;
begin
  case AField.Kind of
    tkChar,
    tkString,
    tkWChar,
    tkWString,
    tkLString,
    tkUString: result:=True;
  else
    result:=False;
  end;
end;

function TGridTree.AddRoot(const AFields: array of TValue):TGridShape;
begin
  result:=AddChild(nil,AFields);
end;

function TGridTree.AddChild(AParent:TTreeNodeShape; const AFields: array of TValue):TGridShape;
var
  t: Integer;
begin
  result:=TGridShape.Create(ITree.Owner);
  result.Tree:=ITree;
  result.ImageIndex:=TTreeNodeImageIndex.tiNone;
  result.Parent:=AParent;

  result.Columns:=Length(AFields);

  for t := 0 to result.Columns-1 do
  begin
    result.Cells[0,t].SimpleText:=AFields[t].ToString;

    if IsTextField(AFields[t]) then
       result.Cells[0,t].Text.HorizAlign:=THorizTextAlign.htaLeft
    else
       result.Cells[0,t].Text.HorizAlign:=THorizTextAlign.htaRight;
  end;

  result.Rows:=1;
  result.Height:=18;
  result.Border.Hide;

  result.AutoSize:=False;
end;

procedure TGridTree.RecalcDimensions;

  procedure RecalcNodeList(AList:TNodeShapeList);
  const
    CharWidth=9;

  var l,
      len,
      row,col, Max : Integer;
      Grid : TGridShape;
      colWidths : Array of Integer;
      cell : TGridCellShape;
  begin
    for row := 0 to AList.Count-1 do
    begin
      len:=0;
      Grid:=(AList[row] as TGridShape);

      if Grid.Columns>Length(colWidths) then
      begin
        SetLength(colWidths,Grid.Columns);

        for col := 0 to Grid.Columns-1 do
            colWidths[col]:=0;
      end;

      for col := 0 to Grid.Columns-1 do
      begin
        l:=Length(Grid.Cells[0,col].SimpleText);
        if l>len then
           len:=l;

        if l>colWidths[col] then
           colWidths[col]:=l;
      end;
    end;

    Max:=SumInt(colWidths);

    {
    Max:=0;

    if Length(colWidths)>0 then
       for col := 0 to Length(colWidths)-1 do
           Inc(Max,colWidths[col]);
    }

    for row := 0 to AList.Count-1 do
    begin
      Grid:=(AList[row] as TGridShape);
      Grid.Width:=Max*CharWidth;

      for col := 0 to Grid.Columns-1 do
      begin
        cell:=Grid.Cells[0,col];

        if col=0 then
           cell.X0:=0
        else
           cell.X0:=Grid.Cells[0,col-1].X1;

        cell.Y0:=0;

        cell.Width:=colWidths[col]*CharWidth;
        cell.Height:=Grid.Height;
      end;

      RecalcNodeList(Grid.Children);
    end;

    colWidths:=nil;
  end;

begin
  RecalcNodeList(ITree.Roots);
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
    if Assigned(FOnNewCell) then
       FOnNewCell(Self,Row,Col);
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

type TCellAccess=class(TGridCellShape);

procedure TGridShape.DrawShapeCanvas(ACanvas: TCanvas3D; const R: TRect);
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

       Selected:=Self.Selected;

       DrawShapeCanvas(ACanvas,tmpR);
       DrawText(ACanvas,tmpR);

       if Selected and (not Tree.Printing) then
       if Self.FTree.Designing then
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

    for t:=0 to Col-1 do
        {$IFDEF FMX}
        result.Left:=result.Left+Cells[Row,t].Width;
        {$ELSE}
        Inc(result.Left,Cells[Row,t].Width);
        {$ENDIF}

    result.Top:=R.Top;
    for t:=0 to Row-1 do
        {$IFDEF FMX}
        result.Top:=result.Top+Cells[t,Col].Height;
        {$ELSE}
        Inc(result.Top,Cells[t,Col].Height);
        {$ENDIF}

    result.Right:=result.Left+Cells[Row,Col].Width;
    result.Bottom:=result.Top+Cells[Row,Col].Height;
  end
  else
  if not Cells[Row,Col].AutoSize then
  begin
    if Col=0 then
       result.Left:=R.Left
    else
       result.Left:=Cells[Row,Col-1].X1;

    if Row=0 then
       result.Top:=R.Top
    else
       result.Top:=Cells[Row-1,Col].Y1;

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
       (Abs(x-tmpR.Left)<3) then
         result:={$IFDEF FMX}crVSplit{$ELSE}crArrowRight{$ENDIF}
    else
    if ((x>=tmpR.Left) and (x<=tmpR.Right)) and
       (Abs(y-tmpR.Top)<3) then
         result:={$IFDEF FMX}crVSplit{$ELSE}crArrowDown{$ENDIF}
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

end.
