{**********************************************}
{   TDBTree Database Tree Component            }
{   Copyright (c) 1998-2025 by Steema Software }
{**********************************************}
{$I TeeDefs.inc}
unit TeeDBTre;

{ Linking a Tree component to a Database Table or Query
  (or any other DataSet), is easy just by setting some
  properties.

  Use the "Database Wizard Dialog" to connect DBTree components to
  Tables or Queries.

  For more advanced layouts, use the Layout collection property.

  It's also easy to do it by code. Follow the instructions below.

  Related Property:
  =================
    MultiLineText : Boolean   ( default True )

    When True, Tree nodes are filled with several lines of text.
    When False, text is joined into a single line.


 Situations:
 ===========

  Situation 1:
  ============

    We have a table or query which includes a "Code and Parent"
    fields:

       Code   Parent Text
       ------ ------ ------------
          1     0    Continents
          2     1      America
          3     1      Africa
          4     1      Australia
          5     2        USA
          6     5          California
          7     4        Sydney
          ..    ...    ...


    We want to create a tree like this:

       Continents -> America -> USA -> California
                  -> Africa
                  -> Australia -> Sydney

    We need to set the following properties:

      With DBTree1 do
      begin
        DataSet     := Table1 ;
        CodeField   := 'Code' ;
        ParentField := 'Parent' ;
        TextFields  := 'Text';
        Refresh;
      end;

    If we need several fields for "text", we can use this syntax:

      DBTree1.TextFields   := 'Text;OtherText;OtherField';


  Situation 2:
  ============

     We have a Table or Query or any other DataSet but it does not
     include a "Parent" or "Code" field.

     We have this data:


        Country      City
        ----------   ---------------
        AUSTRALIA    Sydney
        USA          New York
        UK           London
        AUSTRALIA    Camberra
        UK           Manchester
        UK           Liverpool
        USA          Michigan
        USA          Chicago

     And the tree we need is:

        AUSTRALIA -> Sydney
                  -> Camberra

        UK        -> Liverpool
                  -> London
                  -> Manchester

        USA       -> Chicago
                  -> Michigan
                  -> New York


     The code we need is:

       With DBTree1 do
       begin
         DataSet     := Table1 ;
         CodeField   := '';
         ParentField := 'Country' ;
         TextFields  := 'City' ;
         Refresh;
       end;


     Additionally you can expand the first root node:

         DBTree1.Roots[0].Expanded:=True;

  Situation 3:
  ============

     We have a master-detail relation between to tables or queries
     (or any other types of datasets):

       Master dataset:

             Person   Department
             -------  --------------
             John     Accounting
             Chris    Management
             Anne     Sales
             Peter    Accounting
             James    Sales
             Linda    Sales

       Detail dataset:

             Person  Month  Salary
             ------- ------ ----------
             John    April  $1000
             John    May    $1100
             John    June   $800
             John    July   $1200
             ...
             Chris   March  $900
             Chris   April  $700
             Chris   May    $500
             ...
             Anne...


       We want the following tree:

           Department -> Accounting -> John -> April $1000
                                            -> May $1100
                                            -> June $800
                                            -> July $1200
                                    -> Peter

                      -> Management -> Chris -> March $900
                                             -> April $700
                                             -> May $500

                      -> Sales -> Anne
                               -> James
                               -> Linda


     The code to use is:

       With DBTree1 do
       begin
         DataSet     := Table1 ;  ( the master table )
         CodeField   := '';
         ParentField := 'Department' ;
         TextFields  := 'Person' ;
         Detail      := Table2 ;  ( the detail table )
         DetailFields:= 'Month;Salary' ;
         Refresh;
       end;

     More Advanced Situations:
     =========================

     When having more than one master-detail relationship (more than 2 datasets)
     or for special db-trees, add more DBLayout items, either at design-time
     or runtime.

    }
interface

uses
  {$IFNDEF LINUX}
  Windows, Messages,
  {$ENDIF}
  SysUtils, Classes,

  {$IFDEF D17}
  System.Generics.Collections,
  {$ENDIF}

  Graphics, Controls, Forms, Dialogs, ExtCtrls,
  TeeProcs, TeeTree, DB;

Const MaxFields = 20;

type
  EDBTreeException=class(Exception);
  TCustomDBTree=class;

  TMaxDBTreeFields=Array[0..MaxFields-1] of TField;
  TDBTreeFields=Packed Record
    Count : Integer;
    Field : TMaxDBTreeFields;
  end;

  TDBLayoutDisplay=(ldSingle,ldMultiLine,ldGrid);

  TDBLayout=class(TCollectionItem)
  private
    FCodeField    : String;      // used only in situation "1" ( Parent->Code )
    FDataSet      : TDataSet;         // the dataset
    FDisplayMode  : TDBLayoutDisplay; // the display mode (single line, multi, grid)
    FHeaderFormat : TTreeNodeShape;   // optional header text and format
    FParentField  : String;           // List of field names to do group by
    FFormat       : TTreeNodeShape;   // optional shape determining the node format
    FFields       : String;           // List of field names to display
  private
    ICodeField   : TField;
    IDetails     : {$IFDEF D17}System.Generics.Collections.TList<TDataSet>{$ELSE}TList{$ENDIF};
    IFields      : TDBTreeFields;
    IParents     : TDBTreeFields;

    Function AddNode(AParent:TTreeNodeShape):TTreeNodeShape;
    Procedure AddNodeText(ANode:TTreeNodeShape; Var AFields:TDBTreeFields);
    Function AddText(AChild:TTreeNodeShape):TTreeNodeShape;
    procedure InitDetails;
    Procedure RunNextLayouts(ADetailRoot:TTreeNodeShape);
    procedure SetDataSet(const Value: TDataSet);
    procedure SetFields(const Value: String);
    procedure SetCodeField(const Value: String);
    procedure SetParentField(const Value: String);
    procedure SetFormat(const Value: TTreeNodeShape);
    function GetFormat: TTreeNodeShape;
    function GetHeaderFormat: TTreeNodeShape;
    procedure SetHeaderFormat(const Value: TTreeNodeShape);
    procedure ReadFormat(Reader: TStream);
    procedure WriteFormat(Writer: TStream);
    procedure ReadHeaderFormat(Reader: TStream);
    procedure WriteHeaderFormat(Writer: TStream);
  protected
    procedure DefineProperties(Filer:TFiler); override;
    Procedure FinishAddingText(ANode:TTreeNodeShape); virtual;
    procedure Prepare; virtual;
    Procedure Run(ARoot:TTreeNodeShape); virtual;
  public
    Destructor Destroy; override;

    Procedure Assign(Source:TPersistent); override;

    Function Tree:TCustomDBTree;
  published
    property DataSet:TDataSet read FDataSet write SetDataSet;
    property DisplayMode:TDBLayoutDisplay read FDisplayMode
                                          write FDisplayMode default ldSingle;
    property HeaderFormat:TTreeNodeShape read GetHeaderFormat write SetHeaderFormat
                                         stored False;
    property Fields:String read FFields write SetFields;
    property CodeField:String read FCodeField write SetCodeField;
    property ParentField:String read FParentField write SetParentField;
    property Format:TTreeNodeShape read GetFormat write SetFormat
                                   stored False;
  end;

  TDBTreeLayout=class(TOwnedCollection)
  private
    Function Get(Index:Integer):TDBLayout;
    Procedure Put(Index:Integer; Const Value:TDBLayout);
  public
    Function Add:TDBLayout;
    property Node[Index:Integer]:TDBLayout read Get write Put; default;
  end;

  TCustomDBTree = class(TCustomTree)
  private
    { Private declarations }
    FLayout: TDBTreeLayout;

    Procedure CreateDetail;
    Procedure CreateParentLayout;
    procedure SetDataSet(const Value: TDataSet);
    procedure SetDetail(const Value: TDataSet);
    procedure CheckDataSet(var ADataSet: TDataSet; const Value: TDataSet);
    procedure SetLayout(const Value: TDBTreeLayout);
    function GetDataSet: TDataSet;
    function GetMultiLineText: Boolean;
    procedure SetMultiLineText(const Value: Boolean);
    function GetTextFields: String;
    procedure SetTextFields(const Value: String);
    function GetCodeField: String;
    function GetDetail: TDataSet;
    function GetDetailFields: String;
    function GetParentField: String;
    procedure SetCodeField(const Value: String);
    procedure SetDetailFields(const Value: String);
    procedure SetParentField(const Value: String);
    function IsLayoutStored: Boolean;
  protected
    IPreviewRecords : Integer;

    { Protected declarations }
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public declarations }
    Constructor Create(AOwner:TComponent); override;
    Destructor Destroy; override;

    Function FindNodeCode(ACode:Integer):TTreeNodeShape;
    Procedure Refresh;

    property Layout:TDBTreeLayout read FLayout write SetLayout
                                  stored IsLayoutStored;

    // compatibility with version 1.
    // The new Layout[] property now replaces all these:
    property CodeField:String read GetCodeField write SetCodeField;
    property DataSet:TDataSet read GetDataSet write SetDataSet;
    property Detail:TDataSet read GetDetail write SetDetail;
    property DetailFields:String read GetDetailFields write SetDetailFields;
    property MultiLineText:Boolean read GetMultiLineText write SetMultiLineText
                            default False;
    property ParentField:String read GetParentField write SetParentField;
    property TextFields:String read GetTextFields write SetTextFields;
  end;

  TDBTree=class(TCustomDBTree)
  public
    property DockManager;
  published
    { TCustomDBTree }
    property CodeField;
    property DataSet;
    property Detail;
    property DetailFields;
    property MultiLineText;
    property ParentField;
    property TextFields;

    { TCustomTree properties }
    property AllowDelete;
    property AllowPanning;
    property BackImage;
    property BackImageMode;
    property BufferedDisplay;
    property CrossBox;
    property Designing;
    property DragAndDrop;
    property Gradient;
    property Grid;
    property HorzScrollBar;
    property HotTrack;
    property Images;
    property Layout;
    property Monochrome;
    property Page;
    property PrintProportional;
    property ReadOnly;
    property ScrollMouseButton;
    property Selected;
    property SingleSelection;
    property Shadow;
    property ShowHintShapes;
    property ShowRootCross;
    property SnapToGrid;
    property TextEditor;
    property VertScrollBar;
    property View3DOptions;
    property WheelNavigation;
    property Zoom;

    { TCustomTree events }
    property OnAddingConnection;
    property OnAfterDraw;
    property OnBeforeDraw;
    property OnChanging;
    property OnClickBackground;
    property OnClickConnection;
    property OnClickShape;
    property OnDblClickConnection;
    property OnDblClickShape;
    property OnDeletingShapes;
    property OnDeletedShapes;
    property OnExpandingCollapsing;
    property OnExpandedCollapsed;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMovingShape;
    property OnMouseEnterShape;
    property OnMouseLeaveShape;
    property OnNewConnection;
    property OnNewShape;
    property OnResizingShape;
    property OnSelectConnection;
    property OnSelectShape;
    property OnScroll;
    property OnShowHint;
    property OnStartEditing;
    property OnStopEditing;
    property OnUnSelectConnection;
    property OnUnSelectShape;
    property OnUndoZoom;
    property OnZoom;

    { TPanel properties }
    property Align;
    property BevelInner;
    property BevelOuter default bvNone;
    property BevelWidth;
    property BorderWidth;
    property BorderStyle default bsSingle;
    property Color default clWhite;
    property DragCursor;
    property DragMode;
    property Enabled;
    property ParentColor;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property UseDockManager default True;
    property DockSite;
    property Anchors;
    property AutoSize;
    property Constraints;
    property DragKind;
    property Locked;

    { TPanel events }
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragDropShape;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseDown;

    {$IFDEF D10}
    property OnMouseEnter;
    property OnMouseLeave;
    {$ENDIF}

    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDrag;
    property OnCanResize;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    {$IFNDEF TEEOCX}
    property OnConstrainedResize;
    property OnDockDrop;
    property OnDockOver;
    property OnEndDock;
    property OnGetSiteInfo;
    property OnStartDock;
    property OnUnDock;
    {$ENDIF}
  end;

implementation

uses
  TreeFlow, TreeConst, TeCanvas;

{ TCustomDBTree }
Constructor TCustomDBTree.Create(AOwner:TComponent);
begin
  inherited;
  FLayout:=TDBTreeLayout.Create(Self,TDBLayout);
  IPreviewRecords:=-1;
end;

destructor TCustomDBTree.Destroy;
begin
  FreeAndNil(FLayout);
  inherited;
end;

// Locate an existing node with same "ACode"
Function TCustomDBTree.FindNodeCode(ACode:Integer):TTreeNodeShape;

   // Recursively search a node with "ACode" in Tag property.
   Function FindNodeCodeRoot(const ANode:TTreeNodeShape):TTreeNodeShape;
   var t : Integer;
   begin
     if ANode.Tag=ACode then
        result:=ANode
     else
     begin
       result:=nil;

       for t:=0 to ANode.Childs.Count-1 do
       begin
         result:=FindNodeCodeRoot(ANode.Childs[t]);

         if Assigned(result) then
            break;
       end;
     end;
   end;

var t : Integer;
begin
  result:=nil;

  if (ACode>0) and (Roots.Count>0) then
    // Traverse all roots and try to find node:
    for t:=0 to Roots.Count-1 do
    begin
      result:=FindNodeCodeRoot(Roots[t]);

      if Assigned(result) then
         break;
    end;
end;

// When a DataSet is destroyed, try to find a Layout referencing it.
procedure TCustomDBTree.Notification(AComponent: TComponent;
  Operation: TOperation);
var t : Integer;
begin
  inherited;

  if (Operation=opRemove) and Assigned(FLayout) then
    for t:=0 to Layout.Count-1 do
    with Layout[t] do
    begin
      if Assigned(DataSet) and (AComponent=DataSet) then
         FDataSet:=nil
    end;
end;

// Main procedure.
// Traverse all datasets and fill nodes.
Procedure TCustomDBTree.Refresh;

  // Call the DataSet EnableControls or DisableControls when appropiate.
  Procedure DoEnableDisable(DoEnable:Boolean);
  var t : Integer;
  begin
    t:=Layout.Count-1;

    repeat
      if Layout[t].IFields.Count>0 then
      begin
        if DoEnable then Layout[t].DataSet.EnableControls
                    else Layout[t].DataSet.DisableControls;
        break;
      end
      else Dec(t);

    Until t=0;
  end;

Var t          : Integer;
    tt         : Integer;
    OldNoOwner : Boolean;
    tmpCanRun  : Boolean;
begin
  if Layout.Count=0 then exit;

  for t:=0 to Layout.Count-1 do Layout[t].Prepare;

  if Layout[0].IFields.Count>0 then
  begin
    { default tree options }
    GlobalFormat.Border.Visible:=False;
    GlobalFormat.Transparent:=True;

    OldNoOwner:=NoOwnerShapes;
    NoOwnerShapes:=True;

    // disable controls for the last layout dataset
    DoEnableDisable(False);
    try
      Self.Clear;
      Layout[0].Run(nil);

      for t:=1 to Layout.Count-1 do
      if Assigned(Layout[t].DataSet) then
      begin
        tmpCanRun:=True;

        for tt:=t-1 downto 0 do
        if (Layout[tt].IFields.Count>0) then
        begin
          Layout[tt].InitDetails;
          try
            Layout[tt].DataSet.GetDetailDataSets(Layout[tt].IDetails);

            if (Layout[tt].IDetails.IndexOf(Layout[t].DataSet)<>-1) then
            begin
              tmpCanRun:=False;
              break;
            end;
          finally
            Layout[tt].IDetails.Free;
          end;
        end;

        if tmpCanRun then
           Layout[t].Run(nil);
      end;

    finally
      NoOwnerShapes:=OldNoOwner;
      DoEnableDisable(True);
      if (csDesigning in ComponentState) and
         (Roots.Count>0) and
         (Roots[0].Count>0) then
            Roots[0].Expanded:=True;
    end;
  end;
end;

// Set the DataSet property.
Procedure TCustomDBTree.CheckDataSet(Var ADataSet:TDataSet; Const Value:TDataSet);
begin
  if ADataSet<>Value then
  begin
    if Assigned(ADataSet) then
       ADataSet.RemoveFreeNotification(Self);

    ADataSet:=Value;

    if Assigned(ADataSet) then
       ADataSet.FreeNotification(Self);
  end;
end;

procedure TCustomDBTree.SetDataSet(const Value: TDataSet);
begin
  if Layout.Count=0 then
     Layout.Add;

  Layout[0].DataSet:=Value;
end;

procedure TCustomDBTree.SetDetail(const Value: TDataSet);
begin
  if Detail<>Value then
  begin
    CreateDetail;
    Layout[1].DataSet:=Value;
  end;
end;

procedure TCustomDBTree.SetLayout(const Value: TDBTreeLayout);
begin
  FLayout.Assign(Value);
end;

function TCustomDBTree.GetDataSet: TDataSet;
begin  // return default DataSet
  if FLayout.Count=0 then result:=nil
                     else result:=FLayout[0].FDataSet;
end;

function TCustomDBTree.GetMultiLineText: Boolean;
begin
  if Layout.Count=0 then result:=False
                    else result:=Layout[0].DisplayMode=ldMultiLine;
end;

procedure TCustomDBTree.SetMultiLineText(const Value: Boolean);
begin
  if MultiLineText<>Value then
  begin
    if Layout.Count=0 then Layout.Add;

    if Value then Layout[0].DisplayMode:=ldMultiLine
             else Layout[0].DisplayMode:=ldSingle;
  end;
end;

function TCustomDBTree.GetTextFields: String;
begin
  if Layout.Count=0 then result:=''
                    else result:=Layout[0].Fields;
end;

procedure TCustomDBTree.SetTextFields(const Value: String);
begin
  if TextFields<>Value then
  begin
    if Layout.Count=0 then Layout.Add;
    Layout[0].Fields:=Value;
  end;
end;

function TCustomDBTree.GetCodeField: String;
begin  // compatibility with version 1
  if Layout.Count=0 then result:=''
                    else result:=Layout[0].FCodeField;
end;

function TCustomDBTree.GetDetail: TDataSet;
begin
  if Layout.Count<2 then result:=nil
                    else result:=Layout[1].DataSet
end;

function TCustomDBTree.GetDetailFields: String;
begin
  if Layout.Count<2 then result:=''
                    else result:=Layout[1].FFields
end;

function TCustomDBTree.GetParentField: String;
begin
  if Layout.Count=0 then result:=''
                    else result:=Layout[0].FParentField
end;

procedure TCustomDBTree.SetCodeField(const Value: String);
begin
  if CodeField<>Value then
  begin
    CreateParentLayout;
    Layout[0].FCodeField:=Value;
  end;
end;

Procedure TCustomDBTree.CreateDetail;
begin
  if Layout.Count=0 then Layout.Add;
  if Layout.Count<2 then Layout.Add;
end;

procedure TCustomDBTree.SetDetailFields(const Value: String);
begin
  if DetailFields<>Value then
  begin
    CreateDetail;
    Layout[1].FFields:=Value;
  end;
end;

Procedure TCustomDBTree.CreateParentLayout;
begin
  if Layout.Count=0 then Layout.Add;
end;

procedure TCustomDBTree.SetParentField(const Value: String);
begin
  if ParentField<>Value then
  begin
    CreateParentLayout;
    Layout[0].FParentField:=Value;
  end;
end;

function TCustomDBTree.IsLayoutStored: Boolean;
begin
  result:=Layout.Count>0;
end;

{ TDBLayout }

procedure TDBLayout.Prepare;

  // Find all AFields (field names) in ADataSet and return
  // field objects in AFieldsArray.
  Procedure ObtainFields( Const AFields:String; ADataSet:TDataSet;
                          Var AFieldsArray:TDBTreeFields);

    Procedure FieldNotFound(const ADataSet:TDataSet; Const AFieldName:String);
    begin
      raise EDBTreeException.CreateFmt(TreeMsg_DBFieldNotFound,
                  [AFieldName,ADataSet.Name]);
    end;

  var t     : Integer;
      tmpSt : String;
  begin
    ADataSet.FieldDefs.Update;
    AFieldsArray.Count:=TeeNumFields(AFields);

    for t:=0 to AFieldsArray.Count-1 do
    begin
      tmpSt:=TeeExtractField(AFields,t+1);
      AFieldsArray.Field[t]:=ADataSet.FieldByName(tmpSt);

      if not Assigned(AFieldsArray.Field[t]) then
         FieldNotFound(ADataSet,tmpSt);
    end;
  end;

begin
  if Assigned(DataSet) then
  With DataSet do
  if Active then
  begin
    ObtainFields(Self.Fields,DataSet,IFields);
    if IFields.Count=0 then
        raise EDBTreeException.Create(TreeMsg_OneDetailField);

    ObtainFields(FParentField,DataSet,IParents);

    if (FCodeField<>'') and (IParents.Count=0) then
       raise EDBTreeException.Create(TreeMsg_OneParentField);

    if FCodeField='' then ICodeField:=nil
                     else ICodeField:=DataSet.FieldByName(FCodeField);
  end
  else
  begin
    IFields.Count:=0;
    IParents.Count:=0;
    ICodeField:=nil;
  end;
end;

procedure TDBLayout.SetCodeField(const Value: String);
begin
  FCodeField:=Value;
end;

procedure TDBLayout.SetParentField(const Value: String);
begin
  FParentField:=Value;
end;

function TDBLayout.Tree: TCustomDBTree;
begin
  result:=TCustomDBTree(TDBTreeLayout(Collection).GetOwner);
end;

Procedure TDBLayout.FinishAddingText(ANode:TTreeNodeShape);
begin
  if Assigned(ICodeField) then
     ANode.Tag:=ICodeField.AsInteger;

  AddNodeText(ANode,IFields);
end;

Procedure TDBLayout.RunNextLayouts(ADetailRoot:TTreeNodeShape);
var t : Integer;
begin
  for t:=Index+1 to Collection.Count-1 do
      with TDBTreeLayout(Collection)[t] do
      if (IFields.Count>0) and (Self.IDetails.IndexOf(DataSet)<>-1) then
         Run(ADetailRoot);
end;

Function TDBLayout.AddNode(AParent:TTreeNodeShape):TTreeNodeShape;
begin
  if Assigned(AParent) then
     result:=AParent.AddChild(IFields.Field[0].DisplayText)
  else
     result:=Tree.Add(IFields.Field[0].DisplayText);

  if Assigned(FFormat) then result.AssignFormat(FFormat);
end;

Function TDBLayout.AddText(AChild:TTreeNodeShape):TTreeNodeShape;
var t : Integer;
begin
  if DisplayMode=ldGrid then
  begin
    result:=TGridShape.Create(nil);

    with TGridShape(result) do
    begin
      AutoSize:=True;
      Tree:=Self.Tree;
      Parent:=AChild;
      Columns:=IFields.Count;
      Rows:=1;

      for t:=0 to IFields.Count-1 do
      begin
        Cells[0,t].Text.Add(IFields.Field[t].DisplayText);
        if Assigned(FFormat) then
          Cells[0,t].AssignFormat(FFormat);
      end;

      if Assigned(FFormat) then
         result.AssignFormat(FFormat);
    end;
  end
  else
  begin
    result:=AddNode(AChild);
    FinishAddingText(result);
  end;
end;

procedure TDBLayout.Assign(Source: TPersistent);
begin
  if Source is TDBLayout then
  with TDBLayout(Source) do
  begin
    Self.FCodeField   :=FCodeField;
    Self.DataSet      :=FDataSet;
    Self.FDisplayMode :=FDisplayMode;
    Self.FParentField :=FParentField;
    Self.Format       :=FFormat;
    Self.HeaderFormat :=FHeaderFormat;
    Self.FFields      :=FFields;
  end
  else inherited;
end;

Destructor TDBLayout.Destroy;
begin
  FFormat.Free;
  FHeaderFormat.Free;
  DataSet:=nil;
  inherited;
end;

Procedure TDBLayout.AddNodeText(ANode:TTreeNodeShape; Var AFields:TDBTreeFields);
var t : Integer;
begin
  With ANode.Text do
  for t:=1 to AFields.Count-1 do
  if DisplayMode=ldMultiLine then Add(AFields.Field[t].DisplayText)
  else
  begin
    if (Count=0) or (Strings[0]='') then
       Add(AFields.Field[t].DisplayText)
    else
       Strings[0]:=Strings[0]+' '+AFields.Field[t].DisplayText
  end;
end;

procedure TDBLayout.InitDetails;
begin
  IDetails:={$IFDEF D17}System.Generics.Collections.TList<TDataSet>{$ELSE}TList{$ENDIF}.Create;
end;

procedure TDBLayout.Run(ARoot:TTreeNodeShape);

  // Find a children node with AText (group field text)
  Function GetParentFieldNode( ARoot:TTreeNodeShape;
                               Const AText:String):TTreeNodeShape;
  Var t       : Integer;
      tmpList : TNodeShapeList;
  begin
    if Assigned(ARoot) then tmpList:=ARoot.Children
                       else tmpList:=Tree.Roots;

    for t:=tmpList.Count-1 downto 0 do
    begin
      result:=tmpList[t];
      if result.SimpleText=AText then Exit;
    end;

    result:=nil;
  end;

  Function NewRoot:TTreeNodeShape;
  begin
    result:=AddNode(nil);
    FinishAddingText(result);
  end;

var b         : TBookMark;
    tmpChild  : TTreeNodeShape;
    tmpDetail : TTreeNodeShape;
    tmpChild2 : TTreeNodeShape;
    t         : Integer;
    tmpSt     : String;
    tmpRecCount : Integer;
begin
  if Assigned(DataSet) then
  with DataSet do
  if Active then
  begin
    b:=GetBookMark; // Backup current dataset position (current record)
    try
      InitDetails;
      try
        GetDetailDataSets(IDetails);

        // Header ?
        if Assigned(FHeaderFormat) and (FHeaderFormat.SimpleText<>'') then
        begin
          if Assigned(ARoot) then ARoot:=ARoot.Add('')
                             else ARoot:=Tree.Add('');
          ARoot.AssignFormat(FHeaderFormat);
          ARoot.Text:=FHeaderFormat.Text;
        end;

        tmpRecCount:=0;

        if Assigned(FFormat) then FFormat.Text:=nil;

        // Traverse dataset
        First;
        while not eof do
        begin

          tmpDetail:=nil;

          if Assigned(ICodeField) then  // situation 1 (Parent->Code)
          begin
            if Assigned(ARoot) then
            begin
              tmpChild:=Tree.FindNodeCode(IParents.Field[0].AsInteger);
              if Assigned(tmpChild) then tmpDetail:=AddText(tmpChild)
                                    else tmpDetail:=NewRoot;
            end
            else ARoot:=NewRoot
          end
          else
          if IParents.Count>0 then  // Group by  (situation 2 and 3)
          begin
            tmpChild:=ARoot;
            for t:=0 to IParents.Count-1 do
            begin
              tmpSt:=IParents.Field[t].DisplayText;
              tmpChild2:=GetParentFieldNode(tmpChild,tmpSt);
              if not Assigned(tmpChild2) then
              begin
                if Assigned(tmpChild) then tmpChild:=tmpChild.AddChild(tmpSt)
                                      else tmpChild:=Tree.Add(tmpSt);
                if Assigned(FFormat) then tmpChild.AssignFormat(FFormat);
              end
              else tmpChild:=tmpChild2;
            end;

            tmpDetail:=AddText(tmpChild);  // add detail fields

          end
          else tmpDetail:=AddText(ARoot);  // add detail fields

          // Process next layouts
          RunNextLayouts(tmpDetail);

          // In "Preview" mode, stop when processed enough records
          if Tree.IPreviewRecords<>-1 then
          begin
            if tmpRecCount>=Tree.IPreviewRecords then break;
            Inc(tmpRecCount);
          end;

          Next;
        end;
      finally
        IDetails.Free;
      end;
    finally
      // Restore dataset current record
      GotoBookMark(b);
      FreeBookmark(b);
    end;
  end;
end;

procedure TDBLayout.SetDataSet(const Value: TDataSet);
begin
  Tree.CheckDataSet(FDataSet,Value);
end;

procedure TDBLayout.SetFields(const Value: String);
begin
  FFields:=Value;
end;

procedure TDBLayout.SetFormat(const Value: TTreeNodeShape);
begin
  if Assigned(Value) then Format.Assign(Value)
                     else FreeAndNil(FFormat);
end;

function TDBLayout.GetFormat: TTreeNodeShape;
begin
  if not Assigned(FFormat) then
  begin
    FFormat:=TTreeNodeShape.Create(nil);
    FFormat.AutoSize:=False;
    FFormat.Border.Visible:=False;
    FFormat.Transparent:=True;
  end;
  result:=FFormat;
end;

function TDBLayout.GetHeaderFormat: TTreeNodeShape;
begin
  if not Assigned(FHeaderFormat) then
  begin
    FHeaderFormat:=TTreeNodeShape.Create(nil);
    FHeaderFormat.AutoSize:=False;
    FHeaderFormat.Border.Visible:=False;
    FHeaderFormat.Transparent:=True;
  end;
  result:=FHeaderFormat;
end;

procedure TDBLayout.SetHeaderFormat(const Value: TTreeNodeShape);
begin
  if Assigned(Value) then HeaderFormat.Assign(Value)
                     else FreeAndNil(FHeaderFormat);
end;

procedure TDBLayout.ReadFormat(Reader: TStream);
begin
  FFormat:=TTreeNodeShape(Reader.ReadComponent(nil));
end;

procedure TDBLayout.WriteFormat(Writer: TStream);
begin
  Writer.WriteComponent(FFormat);
end;

procedure TDBLayout.ReadHeaderFormat(Reader: TStream);
begin
  FHeaderFormat:=TTreeNodeShape(Reader.ReadComponent(nil));
end;

procedure TDBLayout.WriteHeaderFormat(Writer: TStream);
begin
  Writer.WriteComponent(FHeaderFormat);
end;

procedure TDBLayout.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineBinaryProperty('IFormat',ReadFormat,WriteFormat,Assigned(FFormat));
  Filer.DefineBinaryProperty('IHeaderFormat',ReadHeaderFormat,WriteHeaderFormat,Assigned(FHeaderFormat));
end;

{ TDBTreeLayout }

function TDBTreeLayout.Add: TDBLayout;
begin
  result:=TDBLayout(inherited Add);
end;

function TDBTreeLayout.Get(Index: Integer): TDBLayout;
begin
  result:=TDBLayout(inherited Items[Index]);
end;

procedure TDBTreeLayout.Put(Index: Integer; const Value: TDBLayout);
begin
  Items[Index].Assign(Value);
end;

end.
