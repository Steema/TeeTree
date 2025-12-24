{***************************************************}
{   TTree Component Library, for VCL and FireMonkey }
{   Copyright (c) 1998-2025 by Steema Software      }
{***************************************************}

// NOTE ABOUT "PAGEBOUNDS"
// If set, TeeTree will calculate totalbounds in function of page sizes
// --> no 'trimming' of empty space between page-border and shapes/connection
// points at min (left, top) and max (right, bottom) position
//
// Default value: OFF = original behavior of teeTree.

{.$DEFINE PAGEBOUNDS}

unit FMXTee.Tree;
{$DEFINE FMX}
{$I TeeDefs.inc} // <-- This should be below Unit

// NOTE: Removed $A-  (disable alignment) due to a C++ 2007 alignment bug

{$B-}  // <-- mandatory compiler option

(*
 This unit implements a visual component: TTree

 A Tree control maintains a network-hierarchy of "nodes", very similar
 to Microsoft TreeView control.

 But, every node in TeeTree is a full standalone component with properties,
 methods and events.
 Properties include color, border, brush, font, text, gradient, etc.

 Every node in the tree can optionally be linked to one or more nodes
 using "connection" components.

 "Connections" are also components that have properties, methods and events,
 which display lines from one node to another.

 Also, every node can optionally be associated to a single "parent" node.
 When assigned, the "parent" node will be the responsible to
 expand / collapse its children nodes and also to free (destroy) its
 children nodes when it is destroyed.

 When a node has a "parent" node, and the parent node is moved
 (changed to a new XY location), the children nodes are also moved.
 This only happens when children nodes have set their "AutoPosition"
 property to True.

 The way parent and children nodes are arranged on screen (layout)
 is determined by the "Tree.GlobalFormat.ChildManager" object,
 when nodes are Auto-Positioned.

 For example, the classic "Windows Explorer" layout of nodes is maintained
 by the TTreeExplorerAlignChild class in this unit.
*)

interface

Uses {$IFNDEF FMX}
     {$IFNDEF LINUX}
     Windows, Messages,
     {$ENDIF}
     {$ENDIF}

     {$IFDEF FMX}
     FMX.Types, FMX.Memo, FMX.Dialogs,

     {$IFNDEF ANDROID}
     FMX.Printer,
     {$ENDIF}

     FMX.Platform,
     FMX.Controls,

     {$IFDEF D18}
     FMX.StdCtrls,
     {$ENDIF}

     {$IFDEF D19}
     FMX.Graphics,
     {$ENDIF}

     {$ELSE}
     Controls, Graphics, Forms, ExtCtrls, Menus, Printers, Dialogs, StdCtrls,
     ImgList,
     {$ENDIF}

     Types,

     {$IFDEF D18}
     System.Generics.Collections,
     {$ENDIF}

     {$IFDEF D16}
     System.UITypes,
     {$ENDIF}

     Classes,

     {$IFDEF FMX}
     FMXTee.Procs, FMXTee.Canvas
     {$ELSE}
     TeeProcs, TeCanvas, TeeFilters
     {$ENDIF};

{ Warning. These config-constants may not exist in future versions }
Const TeeDefaultBoxSize        =  {$IFDEF FMX}5{$ELSE}4{$ENDIF};
      TeeDefaultArrowSize      =    4;
      TeeDefaultGridStep       =   10;
      TeeDefaultMaxScroll      = 1000;
      TeeDefaultMinScroll      =    0;

      MaxShapePoints           =  100;

      // Key codes
      TeeTree_EditKey        = TeeKey_F2;
      TeeTree_EscapeKey      = TeeKey_Escape;
      TeeTree_HomeKey        = TeeKey_Home;
      TeeTree_InsertKey      = TeeKey_Insert;
      TeeTree_UpKey          = TeeKey_Up;
      TeeTree_DownKey        = TeeKey_Down;
      TeeTree_PriorKey       = TeeKey_Prior;
      TeeTree_NextKey        = TeeKey_Next;
      TeeTree_RightKey       = TeeKey_Right;
      TeeTree_LeftKey        = TeeKey_Left;
      TeeTree_EndKey         = TeeKey_End;
      TeeTree_DeleteKey      = TeeKey_Delete;
      TeeTree_ReturnKey      = TeeKey_Return;
      TeeTree_SpaceKey       = TeeKey_Space;
      TeeTree_F11Key         = TeeKey_F11;

      // Default size for "FolderOpenClose" image (optimization)
      TreeDefaultImageHeight = 13;
      TreeDefaultImageWidth  = 15;

      {$IFNDEF FMX}
      // Special cursors used in TGridShape class.
      crArrowRight = TCursor(2021); { Right arrow cursor }
      crArrowDown  = TCursor(2022); { Down arrow cursor }
      {$ENDIF}

      // Child manager constants.
      // See TTreeExplorerAlignChild properties if you want to change them.
      TreeHorizMarginDefault = 19;
      TreeVertMarginDefault  =  1;
      TeeCrossBoxHorizMargin =  5;
      TeeTree_DefaultYPosition = 2;


      {$IFDEF FMX}

      clWhite={$IFDEF D17}TAlphaColors.White{$ELSE}claWhite{$ENDIF};
      clBlack={$IFDEF D17}TAlphaColors.Black{$ELSE}claBlack{$ENDIF};
      clGray={$IFDEF D17}TAlphaColors.Gray{$ELSE}claGray{$ENDIF};
      clYellow={$IFDEF D17}TAlphaColors.Yellow{$ELSE}claYellow{$ENDIF};
      clSilver={$IFDEF D17}TAlphaColors.Silver{$ELSE}claSilver{$ENDIF};
      clRed={$IFDEF D17}TAlphaColors.Red{$ELSE}claRed{$ENDIF};
      clBlue={$IFDEF D17}TAlphaColors.Blue{$ELSE}claBlue{$ENDIF};
      clGreen={$IFDEF D17}TAlphaColors.Green{$ELSE}claGreen{$ENDIF};

      TreeMsg_TeeExtension='ttx';
      TeeMsg_TreeFiles='TeeTree v2 FMX files (*.ttx)|*.ttx';
      TreeMsg_CannotSetShape='Use the Tree property. Shapes property is read-only';
      {$ENDIF}

      TeeHighLight={$IFDEF FMX}{$IFDEF D17}TAlphaColors.Blue{$ELSE}claBlue{$ENDIF}{$ELSE}clNavy{$ENDIF};
      TeeHighLightUnfocused={$IFDEF FMX}{$IFDEF D17}TAlphaColors.Darkgray{$ELSE}claDarkGray{$ENDIF}{$ELSE}clGray{$ENDIF};
      TeeHighLightText={$IFDEF FMX}{$IFDEF D17}TAlphaColors.White{$ELSE}claWhite{$ENDIF}{$ELSE}clWhite{$ENDIF};

      {$IFDEF D16}
      TreeAllComponentPlatformIDs=(pidWin32 or pidWin64 or pidOSX32
              {$IFDEF D18}
                 or {$IFDEF D26}pidiOSSimulator32{$ELSE}pidiOSSimulator{$ENDIF}
                 or {$IFDEF D26}pidiOSDevice32{$ELSE}pidiOSDevice{$ENDIF}
              {$ENDIF}
              {$IFDEF D19}
                 or
                   {$IFDEF D28}
                   pidAndroidArm32
                   {$ELSE}
                   {$IFDEF D26}
                   pidAndroid32Arm
                   {$ELSE}
                   pidAndroid
                   {$ENDIF}
                   {$ENDIF}

              {$ENDIF}
              {$IFDEF D22}or pidiOSDevice64{$ENDIF}
              {$IFDEF D26}or pidOSX64{$ENDIF}
              {$IFDEF D28}or pidOSXArm64{$ENDIF}

              {$IFDEF D28}
              or pidAndroidArm64
              {$ELSE}
               {$IFDEF D27}
               or pidAndroid64Arm
               {$ENDIF}
              {$ENDIF}
              );
      {$ENDIF}

// Global variables. Warning: they might be removed / replaced in future versions.

var   TeeTreeAnimatedScroll  : Boolean = True;
      TeeLineClickTolerance  : Integer =  3;     // pixels of tolerance when clicking nodes
      TeeConnectionCursor    : TCursor = crHandPoint;  // default connection cursor
      TeeConnectionPointCursor : TCursor = crCross;  // default connection point cursor

      TeePictureHorizMargin  : Integer = 3;
      TeePictureVertMargin   : Integer = 2;
      TeeTreeArrowMargin     : Integer = 2;
      TeeTextHorizMargin     : Integer = 3;
      TeeTextVertMargin      : Integer = 3;      
      TeeTreeZ               : Integer = 0;     // default Z position
      TreePageScrollQuantity : Integer = 20;

      TeeTreeDeleteKey       : Integer = TeeTree_DeleteKey; // key to delete nodes


      // default Tree lists Capacity.
      // Set both to 0 (zero) to minimize memory used.
      // Set to a bigger number (ie: 1000 or 10000) for a little more speed
      // when adding many nodes.

      TreeListCapacity       : Integer = 100;
      TreeShapeListCapacity  : Integer = 0;

type
  TCustomTree=class;

  TCustomTreePanel=TCustomTree; // For compatibility with previous versions (See event handler signatures below)

  TTreeClick=procedure( Sender:TCustomTreePanel;
                        Button:TMouseButton;
                        Shift: TShiftState;
                        X, Y: Integer) of object;

  TCustomTreeElement=class;

  // Node and Connection Text alignment constants
  THorizTextAlign =(htaCenter,htaLeft,htaRight);

  TTreeStrings=class(TStringList)
  private
    FAngle        : Integer;     // 0..360 degree. Rotation angle of text.
    FClipText     : Boolean;     // when true, text outside node is clipped
    FHorizAlign   : THorizTextAlign;
    FHorizOffset  : Integer;
    FTransparency : TTeeTransparency;
    FVertAlign    : TVertTextAlign;
    FVertOffset   : Integer;
    FVisible      : Boolean;

    IOwner        : TCustomTreeElement;
    procedure SetAngle(const Value: Integer);
    procedure SetClipText(const Value: Boolean);
    procedure SetHorizAlign(const Value:THorizTextAlign);
    procedure SetHorizOffset(const Value:Integer);
    procedure SetTransparency(const Value: TTeeTransparency);
    procedure SetVertAlign(const Value:TVertTextAlign);
    procedure SetVertOffset(const Value:Integer);
    procedure SetVisible(const Value: Boolean);
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
  published
    property Angle:Integer read FAngle write SetAngle default 0;
    property ClipText:Boolean read FClipText write SetClipText default False;
    property HorizAlign: THorizTextAlign read FHorizAlign
                                         write SetHorizAlign default htaCenter;
    property HorizOffset: Integer read FHorizOffset
                                  write SetHorizOffset default 0;
    property Transparency: TTeeTransparency read FTransparency
                                            write SetTransparency default 0;
    property VertAlign: TVertTextAlign read FVertAlign
                                       write SetVertAlign default vtaCenter;
    property VertOffset: Integer read FVertOffset
                                  write SetVertOffset default 0;
    property Visible:Boolean read FVisible write SetVisible default True;
  end;

  // This class is derived in TreeNodeShape and TreeConnection classes.
  // It is the shared base class both for nodes and connections.
  TCustomTreeElement=class(TComponent)
  private
    FCursor         : TCursor;
    FData           : Pointer;
    FFont           : TTeeFont;

    //{$IFNDEF FMX}
    {$IFDEF AUTOREFCOUNT}[weak]{$ENDIF}
    FTagObject      : TObject;
    //{$ENDIF}

    FTextString     : String;

    Function GetFont:TTeeFont;
    Function GetText:TTreeStrings;
    Function InternalFont:TTeeFont;
    procedure SetCursor(Value:TCursor);
    procedure SetFont(const Value: TTeeFont);
    procedure SetHorizTextAlign(Value:THorizTextAlign);
    procedure SetVertTextAlign(Value:TVertTextAlign);
    function GetSimpleText: String;
    procedure SetSimpleText(const Value: String);
    function IsFontStored: Boolean;
    function GetHorizTextAlign: THorizTextAlign;
    function GetVertTextAlign: TVertTextAlign;
    procedure ReadHorizAlign(Reader: TReader);
    procedure ReadVertAlign(Reader: TReader);
  protected
    FText : TTreeStrings;  // protected. Allows replacing.
    FTree : TCustomTree;

    procedure CanvasChanged(Sender:TObject); virtual;
    Procedure DefineProperties(Filer:TFiler); override;
    Function GetOwner:TPersistent; override;
    Procedure InternalDrawHandles;
    procedure ReadState(Reader: TReader); override;
    Procedure SetBooleanProperty(Var Variable:Boolean; Const Value:Boolean);
    Procedure SetColorProperty(Var Variable:TColor; Const Value:TColor);
    Procedure SetDoubleProperty(Var Variable:Double; Const Value:Double);
    Procedure SetIntegerProperty(Var Variable:Integer; Const Value:Integer);
    procedure SetParentComponent(AParent: TComponent); override;
    procedure SetText(const Value : TTreeStrings);
    Procedure SetTree(const Value:TCustomTree); virtual;
    Function TextLinesCount:Integer;
  public
    Destructor Destroy; override;

    Procedure Assign(Source:TPersistent); override;
    Procedure DrawHandles; dynamic;
    function GetParentComponent: TComponent; override;
    function HasParent: Boolean; override;
    procedure Repaint;

    property SimpleText: String read GetSimpleText write SetSimpleText;
    property Cursor: TCursor read FCursor write SetCursor default crDefault;
    property Data: Pointer read FData write FData;
    property Font: TTeeFont read GetFont write SetFont stored IsFontStored;
    property HorizTextAlign: THorizTextAlign read GetHorizTextAlign
                                             write SetHorizTextAlign;
    //{$IFNDEF FMX}
    property TagObject:TObject read FTagObject write FTagObject;
    //{$ENDIF}

    property Text: TTreeStrings read GetText write SetText;
    property Tree: TCustomTree read FTree write SetTree stored False;
    property VertTextAlign: TVertTextAlign read GetVertTextAlign
                                           write SetVertTextAlign;
  end;

  // Used when node Style is RoundRectangle.
  TRoundRectanglePoint=Array[0..15] of TPoint;

  TShapeGradient=TChartGradient;  // alias

  TTreePen=TTeePen;  // alias

  // Determines the AutoPosition of a node.
  // By default, Left and Top are True.
  // The Tree.GlobalFormat.ChildManager class is the responsible to
  // calculate the Left and Top node positions.
  TTreeShapeAutoPosition=class(TPersistent)
  private
    FNoLeft   : Boolean;
    FNoTop    : Boolean;

    IOnChange : TNotifyEvent;
    Function GetLeft:Boolean;
    Function GetTop:Boolean;
    procedure SetLeft(Value:Boolean);
    procedure SetTop(Value:Boolean);
  public
    Procedure Assign(Source:TPersistent); override;
  published
    property Left:Boolean read GetLeft write SetLeft stored False;
    property Top:Boolean read GetTop write SetTop stored False;
  end;

  TTreeConnection=class;  // forward declaration
  TTreeConnectionClass=class of TTreeConnection;

  TTreeBrush=TTeeBrush;  // alias

  // Default White color brush for nodes.
  TTreeShapeBrush=class(TTreeBrush)
  public
    // db: Must be overriden, otherwise it hides virtual TTeeBrush.Create
    Constructor Create(const Changed:TNotifyEvent); override;
  published
    property Color default clWhite;
  end;

  // Max 100 points for shape bounding.
  TShapePoints=Array[0..MaxShapePoints-1] of TPoint;

  TTreeNodeShape=class; { forward }
  TTreeNodeShapeClass=class of TTreeNodeShape;

  // Callback for Node "ForEach" method.
  TNodeListForEachProc=Procedure(Sender:TTreeNodeShape) of object;

  // Internal "TList" class.
  // Copied from Borland's VCL and optimized for speed.

  PPointerList = ^TPointerList;
  TPointerList = array[0..{$IFDEF D16}(Maxint div 16){$ELSE}MaxListSize{$ENDIF} - 1] of Pointer;

  TTreeList=class
  private
    FList     : PPointerList;
    FCount    : Integer;
    FCapacity : Integer;

    IDelta    : Integer;
  protected
    procedure SetCapacity(NewCapacity: Integer);
    procedure SetCount(NewCount: Integer);

    function Add(const Item: TObject): Integer;
    procedure Clear;
    procedure Delete(Index: Integer);
    procedure Exchange(Index1, Index2: Integer);
    procedure Insert(Index: Integer; const Item: TObject);
    procedure Move(CurIndex, NewIndex: Integer);
    function Remove(const Item: TObject): Integer;
    property Capacity: Integer read FCapacity write SetCapacity;
    property List: PPointerList read FList;
  public
    Destructor Destroy; override;
    property Count: Integer read FCount write SetCount;
    function IndexOf(const Item: TObject): Integer;
  end;

  // List of nodes
  TNodeShapeList=class(TTreeList)
  private
    ITree : TCustomTree;

    Function GetShape(Index:Integer):TTreeNodeShape;
  public
    Function Add(const Node:TTreeNodeShape):Integer; {$IFDEF D9}inline;{$ENDIF}
    Function Clicked(x,y:Integer):TTreeNodeShape;
    Function Find(Const S:String; Partial:Boolean=False):TTreeNodeShape;
    Function FindObject(const Value:TObject):TTreeNodeShape;

    Function First:TTreeNodeShape;
    Procedure ForEach(const Proc:TNodeListForEachProc);
    Function Last:TTreeNodeShape;

    procedure Sort(AscendingOrder,IgnoreCase:Boolean);

    property Items[Index:Integer]:TTreeNodeShape read GetShape; default;
  end;

  TTreeChildrenList=TNodeShapeList; // alias

  TConnListForEachProc=Procedure(Sender:TTreeConnection) of object;

  TDeleteConnectionEvent=Procedure(Sender:TTreeConnection; Var AllowDelete:Boolean) of object;

  // List of Connection objects. Used in Node class.
  TNodeConnectionList=class(TTreeList)
  private
    FVisible    : Boolean;

    Function GetConnection(Index:Integer):TTreeConnection;
    Procedure SetVisible(Value:Boolean);
  public
    Function Clicked(x,y:Integer):TTreeConnection;
    Function DeleteConnection(const AConnection:TTreeConnection):Boolean; virtual;
    Procedure DeleteAllTo(const AShape:TTreeNodeShape);
    Procedure ForEach(const Proc:TConnListForEachProc);
    Function ToShape(const AShape:TTreeNodeShape):TTreeConnection;

    property Items[Index:Integer]:TTreeConnection read GetConnection; default;

  //published  <-- Not possible, as it derives from TObject / TList.

    property Visible:Boolean read FVisible write SetVisible default True;
  end;

  // Default node "handles" (small squares displayed when a node is selected)
  TTreeShapeHandle=( rcNone,
                     rcLeftTop,rcRightBottom,
                     rcLeftBottom,rcRightTop,
                     rcLeft,rcTop,
                     rcRight,rcBottom,
                     rcCustom
                    );

  TTreeConnectionPen=class;

  // List of Connection objects. Used in TCustomTree class.
  TTreeConnectionList=class(TNodeConnectionList)
  private
    FControlVector  : TTreeConnectionPen;
    FMagneticHandle : TTreeShapeHandle;
    FMagneticPos    : TPoint;
    FOnDeleting     : TDeleteConnectionEvent;
    FSelected       : TTreeConnection;

    ITree       : TCustomTree;
    Procedure DrawMagnetic;
    Procedure SetSelected(Const Value:TTreeConnection);
  public
    constructor Create;
    destructor Destroy; override;
    Function DeleteConnection(const AConnection:TTreeConnection):Boolean; override;

    property ControlVector: TTreeConnectionPen read FControlVector write FControlVector;
    property Selected:TTreeConnection read FSelected write SetSelected;
    property OnDeleting:TDeleteConnectionEvent read FOnDeleting write FOnDeleting;
  end;

  // Constants for default "stock" images.
  // See TreeImagePool global variable.
  TTreeNodeImageIndex=( tiNone,
                        tiFolderClose,
                        tiFolderOpen,
                        tiDesktop,
                        tiMyPC,
                        tiNetworkNei,tiFloppy3,tiRecycleBin,tiHardDisk,
                        tiNetShare,tiComputer,tiWorld,
                        tiFolderOpenClose,
                        tiFolderCloseChecked,tiFolderCloseUnChecked,
                        tiChecked,tiUnChecked,
                        tiRadioChecked,tiRadioUnChecked,
                        tiFolderRadioChecked,tiFolderRadioUnChecked
                       );

  // Styles for node's CrossBox.
  TTreeNodeShapeShowCross=(
                            scAuto,   // displayed only when node has children
                            scAlways, // always displayed
                            scNever   // never displayed
                          );

  TClickShapeEvent=procedure( Sender:TTreeNodeShape;
                              Button:TMouseButton;
                              Shift: TShiftState;
                              X, Y: Integer) of object;

  TMouseShapeEvent=procedure(Sender:TTreeNodeShape; Shift:TShiftState;
                             X,Y:Integer) of object;

  // Constants used to determine the position of a node's image.
  TTreeImageAlignment=( iaAutomatic,
                        iaLeftTop,
                        iaRightBottom,
                        iaLeftBottom,
                        iaRightTop,
                        iaLeft,
                        iaTop,
                        iaRight,
                        iaBottom,
                        iaCenter );

  TTreePicture=class(TTeePicture)
  private
    function GetTransp: Boolean;
    procedure SetTransp(const Value: Boolean);
  published
    property Transparent:Boolean read GetTransp write SetTransp default False;
  end;

  // Constants for node Style
  TTreeShapeStyle=( tssRectangle,
                    tssCircle,
                    tssVertLine,
                    tssHorizLine,
                    tssLine,
                    tssInvertLine,
                    tssDiamond,
                    tssTriangleTop,
                    tssTriangleBottom,
                    tssTriangleLeft,
                    tssTriangleRight,
                    tssRoundRectangle,
                    tssCustom,
                    tssChamfer
                     );

  // Most important class. Node class.
  TTreeNodeShape=class(TCustomTreeElement)
  private
    FAdjustedRect  : TRect;     // contains shape bounds plus image bounds
    FAutoSize      : Boolean;   // when true, node size is determined by text size
    FAutoPosition  : TTreeShapeAutoPosition;  // default is left and top true
    FBorder        : TTreePen;   // pen used to draw border
    FBrush         : TTreeShapeBrush;  // brush used to fill node interior

    FGradient      : TShapeGradient;  // gradient to fill node
    FGradientClip  : Boolean;     // when false, draw gradient in shape rect bounds

    FImage         : TTreePicture;        // image to draw near node or inside it
    FImageAlignment: TTreeImageAlignment;  // automatic, left, top, etc
    FImageHeight   : Integer;           // height of image
    FImageRect     : TRect;           // read-only rectangle returning image position
    FImageWidth    : Integer;         // width of image
    FImageIndex    : TTreeNodeImageIndex;  // default image "stock" (pool) index
    FImageListIndex : Integer;            // Index, when using Tree.Images property

    FRoundSize     : Integer;  // used when style is tssRoundRectangle or tssChamfer
    FShadow        : TTeeShadow;       // shadow around node
    FStyle         : TTreeShapeStyle;  // line, rectangle, ellipse, etc

    FTransparency  : TTeeTransparency;  // from 0 to 100 %
    FTransparent   : Boolean;           // when true, node interior is not filled

    FVisible       : Boolean;          // true if node parent is expanded
    FX0,FY0        : Integer;    { position left,top }
    FX1,FY1        : Integer;    { position right,bottom }


    { Parent - Child variables }
    FBrotherIndex: Integer;              // -1 when node has no parent
    FChildren    : TTreeChildrenList;    // list of children nodes
    FConnections : TNodeConnectionList;  // list of connection objects
    FExpanded    : Boolean;              // True if node is expanded

    {$IFDEF AUTOREFCOUNT}[weak]{$ENDIF}
    FParent      : TTreeNodeShape;       // Parent Node

    FParents     : TNodeShapeList;       // List of other Parent nodes.
    FShowCross   : TTreeNodeShapeShowCross; // Style for CrossBox

    { Events }
    FOnClick      : TClickShapeEvent;
    FOnDblClick   : TClickShapeEvent;
    FOnMouseEnter : TMouseShapeEvent;
    FOnMouseLeave : TMouseShapeEvent;
    FOnMouseMove  : TMouseShapeEvent;

    { internal }
    IImageHeight   : Integer;    // pre-calculated ImageHeight.
    IImageWidth    : Integer;    // pre-calculated ImageWidth.
    IMouseInside   : Boolean;    // true when mouse is inside node bounds.
    IParents0      : TTreeNodeShape; // optimization: see GetParents method.

    Procedure ChangeTreeRecursive(const NewTree:TCustomTree);
    Procedure DoMove(DeltaX,DeltaY:Integer; AltShift:Boolean);
    Function Get3DRectangle:TRect;

    {$IFNDEF D7}
    Function GetAdjustedRectangle:TRect;
    Function GetAutoSize:Boolean;
    Function GetBrotherIndex: Integer;
    Function GetExpanded:Boolean;
    Function GetGradientClip:Boolean;
    Function GetImageAlignment:TTreeImageAlignment;
    Function GetImageHeight:Integer;
    Function GetImageIndex:TTreeNodeImageIndex;
    Function GetImageWidth:Integer;
    Function GetImageListIndex:Integer;
    Function GetImageRect:TRect;
    function GetParent: TTreeNodeShape;
    Function GetSelected:Boolean;
    Function GetShowCross:TTreeNodeShapeShowCross;
    Function GetStyle:TTreeShapeStyle;
    Function GetTransparent:Boolean;
    Function GetTransparency:TTeeTransparency;
    Function GetVisible:Boolean;
    function GetX0: Integer;
    function GetY0: Integer;
    {$ENDIF}

    Function GetAutoPosition:TTreeShapeAutoPosition;
    Function GetBackColor:TColor;
    Function GetBorder:TTreePen;
    function GetChecked:Boolean; // true if the Image is a checked checkbox or radioitem
    Function GetGradient:TShapeGradient;
    Function GetShadow:TTeeShadow;
    Procedure GetTrianglePoints( Const R:TRect;
                                 const MidX,MidY:TCoordinate;
                                 Var P:TShapePoints);

    Function InternalBrush:TTreeShapeBrush;
    Function InternalClipText:Boolean;
    Procedure InternalDrawShadow( tmpR:TRect; const ACanvas:TCanvas3D;
                                  const tmpStyle:TTreeShapeStyle); virtual;
    Procedure InternalDrawShape( tmpR:TRect; const ACanvas:TCanvas3D;
                                 tmpStyle:TTreeShapeStyle);
    Function InternalPen:TTreePen;
    procedure InternalSetImage(const Value:TPicture);
    Function InternalTextAngle:Integer;
    Function IsSizeStored:Boolean;
    Function IsVisible:Boolean;
    procedure PositionChanged(Sender:TObject);
    //function PrepareShadowBitmap(const R:TRect; out ACanvas:TCanvas3D):TBitmap;
    Procedure SetAutoPosition(const Value:TTreeShapeAutoPosition);
    Procedure SetAutoSize(Value:Boolean);
    procedure SetBackColor(const Value:TColor);
    procedure SetBorder(const Value:TTreePen);
    procedure SetBrush(const Value:TTreeShapeBrush);
    procedure SetImageAlignment(Value:TTreeImageAlignment);
    procedure SetImageHeight(Value:Integer);
    procedure SetImageWidth(Value:Integer);
    Procedure SetGradient(const Value:TShapeGradient);
    Procedure SetGradientClip(Value:Boolean);
    procedure SetRoundSize(const Value:Integer);
    Procedure SetShadow(const Value:TTeeShadow);
    procedure SetStyle(const Value:TTreeShapeStyle);
    procedure SetTransparent(const Value: Boolean);
    Procedure SetVisible(const Value:Boolean);
    Procedure SetX0(Value:Integer);
    Procedure SetX1(Value:Integer);
    Procedure SetY0(Value:Integer);
    Procedure SetY1(Value:Integer);
    function GetHeight: Integer;
    function GetWidth: Integer;
    procedure SetHeight(const Value: Integer);
    procedure SetTransparency(const Value: TTeeTransparency);
    procedure SetWidth(const Value: Integer);
    function GetColor: TColor;
    procedure SetColor(const Value: TColor);
    procedure SetImageListIndex(const Value: Integer);

    { Parent - Child }
    Procedure SetExpanded(Value:Boolean);
    Function GetPreviousBrother:TTreeNodeShape;
    Function GetRoot:TTreeNodeShape;
    Function InternalAddConnection(const AToShape:TTreeNodeShape):TTreeConnection;
    Function IsImageStored:Boolean;
    Function IsPositionLeftStored:Boolean;
    Function IsPositionTopStored:Boolean;
    Procedure RemoveChild(const AShape:TTreeNodeShape);
    procedure SetImageIndex(Value:TTreeNodeImageIndex);
    Procedure SetParent(const Value:TTreeNodeShape);
    procedure SetShowCross(Value:TTreeNodeShapeShowCross);
    function GetX1: Integer;
    function GetY1: Integer;
    function GetChildNodes: TTreeChildrenList;
    function GetConnections: TNodeConnectionList;
    function GetParents: TNodeShapeList;
    procedure SetBrotherIndex(const Value: Integer);
    procedure SetChecked(Value:Boolean);
    procedure SetLeft(const Value: Integer);
    procedure SetTop(const Value: Integer);

    function IsBorderStored: Boolean;
    function IsBrushStored: Boolean;
    function IsGradientStored: Boolean;
    function IsShadowStored: Boolean;
    function IsImageIndexStored: Boolean;
  protected
    IAutoSized  : Boolean;    // when False, recalculate again the node size.
    FSelected   : Boolean;    // When True, this node is Selected.

    procedure CanvasChanged(Sender:TObject); override;
    procedure ChangeAutoSize(Value:Boolean);
    Procedure DoClick(Button:TMouseButton; Shift:TShiftState; x,y:Integer); dynamic;
    procedure DoDrawHandle( Handle:TTreeShapeHandle;
                            var x,y:Integer; var Draw:Boolean); dynamic;
    Procedure DrawGradient(Const Rect:TRect; const ACanvas:TCanvas3D);
    Procedure DrawImage;
    procedure DrawShape(Const R:TRect);
    procedure DrawShapeCanvas(const ACanvas:TCanvas3D; Const R:TRect); virtual;
    procedure DrawSelectionFocus;
    procedure DrawText(const ACanvas:TCanvas3D; Var R:TRect);
    Procedure RecalcImageSize;
    Function GetBrush:TTreeShapeBrush;
    Procedure GetConnectionTo(Const pX0,pY0,pX1,pY1:TCoordinate;
                              Var AX,AY:TCoordinate); dynamic;
    Function GetEditedShape:TTreeNodeShape; dynamic;
    Function GetHandleCursor(x,y:Integer):TCursor; dynamic;
    Function GetRoundRectanglePoints(R:TRect; Var P:TShapePoints):Integer;
    Function GetShapePoints(Const R:TRect; Var P:TShapePoints):Integer; virtual;
    function HasCheckBox:Boolean;
    Procedure PictureChanged(Sender:TObject);
    Function RectTo3DCanvas(const ACanvas:TCanvas3D; Const R:TRect):TRect;
    Procedure SetBounds(Const R:TRect);
    Procedure SetCanvasFont(const ACanvas:TCanvas3D);
    procedure SetImage(const Value:TTreePicture);
    Procedure SetSelected(Value:Boolean); virtual;
    Procedure SetTree(const Value:TCustomTree); override;
    Function ShouldDrawCross:Boolean;

    { Parent - Child }
    Function AutoPositionLeft:Boolean;
    Function AutoPositionTop:Boolean;
    Function DoExpandCollapse(Value:Boolean):Integer;
    Procedure DoMouseEnter(Shift: TShiftState; X, Y: Integer);
    Procedure DoMouseLeave(Shift: TShiftState; X, Y: Integer);
    Procedure DoMouseMove(Shift: TShiftState; X, Y: Integer);
    Function RecursiveCountExpanded:Integer;
  public
    Constructor Create(AOwner : TComponent); override;
    Destructor Destroy; override;

    Procedure Assign(Source:TPersistent); override;
    Procedure AssignFormat(const ANode:TTreeNodeShape);

    property AdjustedRectangle:TRect read {$IFDEF D7}FAdjustedRect{$ELSE}GetAdjustedRectangle{$ENDIF}; // total bounds
    Function Bounds:TRect;
    procedure Clear;

    Function Clicked(const x,y:Integer):Boolean; overload; virtual;
    Function Clicked(const x,y:Single):Boolean; overload; virtual;

    {$IFDEF FMX}
    Function ClickedImage(x,y:Single):Boolean; overload;
    {$ENDIF}

    Function ClickedImage(x,y:Integer):Boolean; overload;
    procedure Collapse(Recursive:Boolean);
    Function Count:Integer;
    procedure Draw; virtual;
    Procedure DrawHandles; override;
    Procedure GetConnectionPos(const AShape:TTreeNodeShape;
                         Var AX,AY:TCoordinate);
    Function GetImage:TTreePicture;
    Function GetPicture:TPicture;
    Function GetResizingHandle(x,y:Integer):TTreeShapeHandle; dynamic;
    Function InsideTreeBounds:Boolean;
    Procedure RecalcSize(const ACanvas:TCanvas3D); virtual;
    Function XCenter:TCoordinate;
    Function YCenter:TCoordinate;

    { Parent - Child }
    Function Add(Const AText:String):TTreeNodeShape; // same as AddChild (alias)
    Function AddBrother(Const AText:String):TTreeNodeShape;
    Function AddChild(Const AText:String):TTreeNodeShape;
    Function AddChildFirst(Const AText:String):TTreeNodeShape;
    Function AddChildObject(Const AText:String; const Data:Pointer):TTreeNodeShape;
    Function AddConnection(const AToShape:TTreeNodeShape ):TTreeConnection;
    Function AddConnectionObject(const AToShape:TTreeNodeShape; const Data:Pointer):TTreeConnection;

    Procedure BringToFront;
    Function CalcXYCross(const AParent:TTreeNodeShape):TPoint;

    Function CrossBoxClicked(x,y:Integer):Boolean;
    Function DoDraw:Boolean;

    Function HasChilds:Boolean;
    Function HasChildren:Boolean;
    procedure Hide;
    Function Insert(Index:Integer; Const AText:String):TTreeNodeShape;

    Function Level:Integer;

    Function MaxHeightExpandedChilds: TCoordinate;
    Function MinHeightExpandedChilds: TCoordinate;
    Procedure MoveRelative(OfsX,OfsY:Integer; MoveChilds:Boolean); dynamic;

    Procedure ReCalcPositions(ABrotherIndex:Integer);
    Procedure Resize(ACorner:TTreeShapeHandle; DeltaX,DeltaY:Integer); dynamic;
    Procedure SaveToTextFile(Const FileName:String);
    Procedure SelectChilds;
    Procedure SendToBack;
    procedure Show;
    procedure SortChildsText(AscendingOrder,IgnoreCase:Boolean);

    procedure Toogle; {$IFDEF D11}deprecated;{$ENDIF}
    procedure Toggle; // expands or collapses the node
    procedure ToggleCheck; // checks or unchecks the node

    { public properties }
    property BrotherIndex:Integer read {$IFDEF D7}FBrotherIndex{$ELSE}GetBrotherIndex{$ENDIF} write SetBrotherIndex;
    property Children:TTreeChildrenList read GetChildNodes;
    property Childs:TTreeChildrenList read GetChildNodes;  // Obsolete (use: Children)
    property Connections:TNodeConnectionList read GetConnections;
    property Parents:TNodeShapeList read GetParents;
    property PreviousBrother:TTreeNodeShape read GetPreviousBrother;
    property Root:TTreeNodeShape read GetRoot;
    property Selected:Boolean read {$IFDEF D7}FSelected{$ELSE}GetSelected{$ENDIF} write SetSelected default False;

    property Height:Integer read GetHeight write SetHeight;
    property ImageRect:TRect read {$IFDEF D7}FImageRect{$ELSE}GetImageRect{$ENDIF};
    property Left:Integer read {$IFDEF D7}FX0{$ELSE}GetX0{$ENDIF} write SetLeft; // alias of X0
    property Top:Integer read {$IFDEF D7}FY0{$ELSE}GetY0{$ENDIF} write SetTop;   // alias of Y0
    property Width:Integer read GetWidth write SetWidth;

  published
    property AutoPosition:TTreeShapeAutoPosition read GetAutoPosition
                                                 write SetAutoPosition;
    property AutoSize:Boolean read {$IFDEF D7}FAutoSize{$ELSE}GetAutoSize{$ENDIF} write SetAutoSize default True;
    property BackColor:TColor read GetBackColor{FBackColor} write SetBackColor default clNone;
    property Border:TTreePen read GetBorder write SetBorder stored IsBorderStored;
    property Brush:TTreeShapeBrush read GetBrush write SetBrush stored IsBrushStored;
    property Checked:Boolean read GetChecked write SetChecked default False;

    property Color:TColor read GetColor write SetColor default clWhite;
    property Gradient:TShapeGradient read GetGradient write SetGradient stored IsGradientStored;
    property GradientClip:Boolean read {$IFDEF D7}FGradientClip{$ELSE}GetGradientClip{$ENDIF} write SetGradientClip
                                  default True;

    property Image:TTreePicture read GetImage write SetImage stored IsImageStored;
    property ImageAlignment:TTreeImageAlignment read {$IFDEF D7}FImageAlignment{$ELSE}GetImageAlignment{$ENDIF}
                                               write SetImageAlignment
                                               default iaAutomatic;
    property ImageHeight:Integer read {$IFDEF D7}FImageHeight{$ELSE}GetImageHeight{$ENDIF} write SetImageHeight
                                 default 0;
    property ImageWidth:Integer read {$IFDEF D7}FImageWidth{$ELSE}GetImageWidth{$ENDIF} write SetImageWidth
                                default 0;
    property RoundSize:Integer read FRoundSize write SetRoundSize default 3;
    property Shadow:TTeeShadow read GetShadow write SetShadow stored IsShadowStored;
    property Style:TTreeShapeStyle read {$IFDEF D7}FStyle{$ELSE}GetStyle{$ENDIF} write SetStyle default tssRectangle;
    property Transparency:TTeeTransparency read {$IFDEF D7}FTransparency{$ELSE}GetTransparency{$ENDIF}
                                           write SetTransparency default 0;
    property Transparent:Boolean read {$IFDEF D7}FTransparent{$ELSE}GetTransparent{$ENDIF} write SetTransparent default False;
    property Visible:Boolean read {$IFDEF D7}FVisible{$ELSE}GetVisible{$ENDIF} write SetVisible default True;
    property X0:Integer read {$IFDEF D7}FX0{$ELSE}GetX0{$ENDIF} write SetX0 stored IsPositionLeftStored;
    property X1:Integer read GetX1 write SetX1 stored IsSizeStored;
    property Y0:Integer read {$IFDEF D7}FY0{$ELSE}GetY0{$ENDIF} write SetY0 stored IsPositionTopStored;
    property Y1:Integer read GetY1 write SetY1 stored IsSizeStored;

    property Cursor;
    property Font;
    property Expanded:Boolean read {$IFDEF D7}FExpanded{$ELSE}GetExpanded{$ENDIF} write SetExpanded default False;
    property ImageIndex:TTreeNodeImageIndex read {$IFDEF D7}FImageIndex{$ELSE}GetImageIndex{$ENDIF} write SetImageIndex
             stored IsImageIndexStored;
    property ImageListIndex:Integer read {$IFDEF D7}FImageListIndex{$ELSE}GetImageListIndex{$ENDIF} write SetImageListIndex
             default -1;
    property Parent:TTreeNodeShape read {$IFDEF D7}FParent{$ELSE}GetParent{$ENDIF} write SetParent;
    property ShowCross:TTreeNodeShapeShowCross read {$IFDEF D7}FShowCross{$ELSE}GetShowCross{$ENDIF} write SetShowCross
                                 default scAuto;
    property Text;

    { events }
    property OnClick    :TClickShapeEvent read FOnClick write FOnClick;
    property OnDblClick :TClickShapeEvent read FOnDblClick write FOnDblClick;
    property OnMouseEnter:TMouseShapeEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave:TMouseShapeEvent read FOnMouseLeave write FOnMouseLeave;
    property OnMouseMove:TMouseShapeEvent read FOnMouseMove write FOnMouseMove;
  end;

  TExpandingCollapsingEvent=procedure(Sender:TTreeNodeShape; Var Expand:Boolean) of object;

  // Drawing styles for Connection arrows
  TConnectionArrowStyle=( casNone,casSolid,casLines,
                          casSquare,casCircle,casDiamond);

  // Brush with default color Black
  TConnectionArrowBrush=class(TTreeBrush)
  published
    property Color default clBlack;
  end;

  // Several ways to specify the connection points coordinates.
  TConnectionPointStyle=
     ( cpsAutoFrom,       // Automatic position on the "From" node
       cpsAutoTo,         // Automatic position on the "To" node
       cpsFromPercent,    // + / - percent on "From" size
       cpsToPercent,      // + / - percent on "To" size
       cpsFromRel,        // + / - pixels relative from "From" node origin
       cpsToRel,          // + / - pixels relative from "To" node origin
       cpsPrevious,       // + / - pixels relative to Previous Point in array
       cpsNext,           // + / - pixels relative to Next Point array
       cpsFixed           // Fixed XY pixel position
     );

  // Record containing coordinates and styles for each Connection point
  TConnectionPoint=record
    XStyle : TConnectionPointStyle;
    YStyle : TConnectionPointStyle;

    XValue : TCoordinate;  // Value to use when calculating X using XStyle
    YValue : TCoordinate;  // Value to use when calculating Y using YStyle

    X      : TCoordinate;  // real X pixel position
    Y      : TCoordinate;  // real Y pixel position
  end;

  // Dynamic Array of Connection points
  TConnectionPointArray=Array of TConnectionPoint;

  // Connection points object.
  TConnectionPoints=class
  private
    IConnection : TTreeConnection;

    procedure RemoveAuto;
  public
    Item : TConnectionPointArray;

    Function Add(Const P:TPoint): Integer; overload;
    Function Add(Ax,Ay:Integer):Integer; overload;
    Function Add( AXStyle:TConnectionPointStyle; Ax:Integer;
                  AYStyle:TConnectionPointStyle; Ay: Integer): Integer; overload;
    Function AddFromPrevious(XOffset,YOffset:Integer):Integer;
    Procedure CalculatePosition(Index:Integer);
    Procedure ChangeXStyle(Index:Integer; AStyle:TConnectionPointStyle);
    Procedure ChangeYStyle(Index:Integer; AStyle:TConnectionPointStyle);
    Procedure Clear; {$IFDEF D9}inline;{$ENDIF}
    Function Clicked(x,y:Integer):Integer;
    Function Count:Integer;
    Procedure Delete(Index:Integer);
    Procedure Insert(Index:Integer; x,y:Integer);
    Procedure Move(Index:Integer; DeltaX,DeltaY:Integer);

    { default array property cant be added (dyn array reference, OPascal limitation) }
  end;

  // Visual "arrow" optionally displayed at start / end connection points
  TConnectionArrow=class(TPersistent)
  private
    FBorder    : TTreePen;
    FBrush     : TConnectionArrowBrush;
    FSize      : Integer;
    FStyle     : TConnectionArrowStyle;

    IOwner     : TTreeConnection;

    function GetBackColor:TColor;
    Function GetBorder:TTreePen;
    Function GetBrush:TConnectionArrowBrush;
    Procedure SetBorder(const Value:TTreePen);
    Procedure SetBrush(const Value:TConnectionArrowBrush);
    Procedure SetSize(Value:Integer);
    Procedure SetStyle(const Value:TConnectionArrowStyle);
    procedure SetBackColor(const Value: TColor);
  public
    Constructor Create(const AOwner : TTreeConnection); virtual;
    Destructor Destroy; override;

    Procedure Assign(Source:TPersistent); override;
    Procedure Draw(Const Point:TConnectionPoint; Angle:Integer);
  published
    property BackColor:TColor read GetBackColor write SetBackColor default clNone;
    property Border:TTreePen read GetBorder write SetBorder;
    property Brush:TConnectionArrowBrush read GetBrush write SetBrush;
    property Size:Integer read FSize write SetSize default TeeDefaultArrowSize;
    property Style:TConnectionArrowStyle read FStyle write SetStyle;
  end;

  // The "start" (From) connection arrow is hidden by default
  TConnectionArrowFrom=class(TConnectionArrow)
  published
    property Style default casNone;
  end;

  // The "end" (To) connection arrow is solid by default
  TConnectionArrowTo=class(TConnectionArrow)
  published
    property Style default casSolid;
  end;

  // Connection styles.
  // When the style is "auto", the ChildManager class calculates the
  // connection points.
  TTreeConnectionStyle=(csAuto, csLine, csSides, csCurve, csInvertedSides);

  // Default connection line pen is gray color and small dots.
  TTreeConnectionPen=class(TTreePen)
  public
    Constructor Create(const OnChangeEvent:TNotifyEvent);
  published
    property Color default clGray;
    property SmallDots default True;
    property Style default psDot;
  end;

  TConnectionFormat=class(TTeeShape)
  published
    property Visible default False;
  end;

  TCurvePoints=Array[0..99] of TPoint; // static array for curved connections

  // Connection object.
  // Connections draw single or multi line segments between nodes
  TTreeConnection=class(TCustomTreeElement)
  private
    FArrowFrom : TConnectionArrowFrom;
    FArrowTo   : TConnectionArrowTo;
    FBorder    : TTreeConnectionPen;
    FFormat    : TConnectionFormat;
    FPoints    : TConnectionPoints;  // Warning: Future versions might change.
    FStyle     : TTreeConnectionStyle;
    FFromShape : TTreeNodeShape;
    FToShape   : TTreeNodeShape;

    Function GetArrowFrom:TConnectionArrowFrom;
    Function GetArrowTo:TConnectionArrowTo;
    Function GetBorder:TTreeConnectionPen;
    Function GetFormat:TConnectionFormat;
    Function GetFromShape:TTreeNodeShape;
    Function GetPoints:TConnectionPoints;
    Function GetStyle:TTreeConnectionStyle;
    Function GetToShape:TTreeNodeShape;
    Function InternalArrowFrom:TConnectionArrow;
    Function InternalArrowTo:TConnectionArrowTo;
    Function IsFormatStored:Boolean;
    procedure ReadPoints(Reader: TReader);
    procedure SavePoints(Writer: TWriter);
    procedure SetArrowFrom(const Value:TConnectionArrowFrom);
    procedure SetArrowTo(const Value:TConnectionArrowTo);
    procedure SetBorder(const Value : TTreeConnectionPen);
    procedure SetFormat(const Value : TConnectionFormat);
    procedure SetFromShape(const Value:TTreeNodeShape);
    Procedure SetStyle(const Value:TTreeConnectionStyle);
    procedure SetToShape(const Value:TTreeNodeShape);
  protected
    IBounds: TRect;

    Procedure DefineProperties(Filer:TFiler); override;
    Procedure GetCurvePoints(Var P:TCurvePoints);
    Procedure InternalDraw;
    Procedure PrepareCanvas;
    Procedure SetTree(const Value:TCustomTree); override;
    Procedure SetupPoints;
  public
    Constructor Create(AOwner:TComponent); override;
    Destructor Destroy; override;

    Procedure Assign(Source:TPersistent); override;
    Function Clicked(x,y:Integer):Boolean;
    Function ClickedSegment(x,y:Integer):Integer;
    Function Draw:Boolean;
    Function GetBounds: TRect;
    Procedure DrawHandles; override;
    procedure DrawText(Angle:Integer);

    //property Points:TConnectionPoints read FPoints;
    property Points:TConnectionPoints read GetPoints;
    Function Visible:Boolean;
  published
    property ArrowFrom:TConnectionArrowFrom read GetArrowFrom write SetArrowFrom;
    property ArrowTo:TConnectionArrowTo read GetArrowTo write SetArrowTo;
    property Border:TTreeConnectionPen read GetBorder write SetBorder;
    property Font;
    property Format:TConnectionFormat read GetFormat write SetFormat
                                      stored IsFormatStored;
    property Style:TTreeConnectionStyle read {FStyle}GetStyle
                                        write SetStyle default csAuto;
    property Cursor;
    property FromShape:TTreeNodeShape read {FFromShape}GetFromShape write SetFromShape;
    property ToShape  :TTreeNodeShape read {FToShape}GetToShape write SetToShape;
    property Text;
  end;

  TTreeNewShapeEvent=Procedure(Sender:TCustomTreePanel; NewShape:TTreeNodeShape) of object;
  TTreeNewConnectionEvent=Procedure(Sender:TCustomTreePanel; NewConnection:TTreeConnection) of object;

  // Pen used to draw borders around selected nodes
  TTreeSelectedPen=class(TTreePen)
  public
    Constructor Create(const OnChangeEvent:TNotifyEvent);
  published
    property Color default clYellow;
    property SmallDots default True;
    property Style default psDot;
  end;

  // Non-Visible pen
  TTreeHiddenPen=class(TTreePen)
  public
    Constructor Create(const OnChangeEvent:TNotifyEvent);
  published
    property Visible default False;
  end;

  TTreeSelectedUnFocusedPen=TTreeHiddenPen;

  TTreeSelectedHandlesPen=TTreeHiddenPen;

  // List of nodes that are selected
  TSelectedShapeList=class(TPersistent)
  private
    FBorder         : TTreeSelectedPen;
    FBorderUnFocused: TTreeSelectedUnFocusedPen;
    FColor          : TColor;
    FColorUnFocused : TColor;
    FFullRedraw     : Boolean;
    FHandleColor    : TColor;
    FHandleSize     : Integer;
    FHandlePen      : TTreeSelectedHandlesPen;
    FScrollToView   : Boolean;
    FScrollToCenter : Boolean;
    FShiftState     : TShiftState;
    FTextColor      : TColor;

    IFocused        : Boolean; // to optimize redraw time of selected nodes.
    IList           : TNodeShapeList;
    ITree           : TCustomTree;
    Function GetShape(Index:Integer):TTreeNodeShape;
    Function InternalColor:TColor;
    Procedure Repaint;
    Procedure SetBorder(const Value:TTreeSelectedPen);
    Procedure SetBorderUnFocused(const Value:TTreeSelectedUnFocusedPen);
    Procedure SetColor(Value:TColor);
    Procedure SetColorUnFocused(Value:TColor);
    procedure SetTextColor(Value: TColor);
    procedure SetScrollToCenter(const Value: Boolean);
    procedure SetFullRedraw(const Value: Boolean);
    procedure SetHandlesPen(const Value: TTreeSelectedHandlesPen);
    procedure SetHandleSize(const Value: Integer);
    procedure SetHandleColor(const Value: TColor);
    function GetText: String;
    procedure SetText(const Value: String);
    function GetData: Pointer;
    procedure SetData(const Value:Pointer);
  protected
    Procedure InternalAdd(const AShape:TTreeNodeShape);
  public
    Constructor Create(const ATree:TCustomTree);
    Destructor Destroy; override;
    Procedure Assign(Value:TPersistent); override;

    Procedure Add(const AShape:TTreeNodeShape);
    Procedure Clear;
    Function Count:Integer;
    property Data:Pointer read GetData write SetData; // For TreeView compatibility.
    Procedure Delete;
    Function First:TTreeNodeShape;
    procedure ForEach(const Proc: TNodeListForEachProc);
    Procedure Remove(const AShape:TTreeNodeShape);
    Procedure SelectAll;
    procedure ToggleCheck; // Check or UnCheck nodes

    property Shapes:TNodeShapeList read IList;
    property Items[Index:Integer]:TTreeNodeShape read GetShape; default;
    property Text:String read GetText write SetText; // For TreeView compatibility.
  published
    property Border:TTreeSelectedPen read FBorder write SetBorder;
    property BorderUnFocused:TTreeSelectedUnFocusedPen read FBorderUnFocused write SetBorderUnFocused;
    property Color:TColor read FColor write SetColor default TeeHighLight;
    property ColorUnFocused:TColor read FColorUnFocused write
                                   SetColorUnFocused default TeeHighLightUnfocused;
    property FullRedraw:Boolean read FFullRedraw write SetFullRedraw default False;
    property HandleColor:TColor read FHandleColor write SetHandleColor default clBlack;
    property HandleSize:Integer read FHandleSize write SetHandleSize default 3;
    property HandlePen:TTreeSelectedHandlesPen read FHandlePen write SetHandlesPen;
    property ScrollToView:Boolean read FScrollToView write FScrollToView default True;
    property ScrollToCenter:Boolean read FScrollToCenter write SetScrollToCenter default False;
    property ShiftState:TShiftState read FShiftState write FShiftState default [ssShift];
    property TextColor: TColor read FTextColor write SetTextColor
                        default TeeHighLightText;
  end;

  // Default gray pen for nodes "cross-box"
  TTreeCrossBoxPen=class(TTreePen)
  published
    property Color default clGray;
    property Width {$IFNDEF FMX}default 0{$ENDIF};
  end;

  TClickConnectionEvent=procedure( Sender:TTreeConnection;
                                   Button:TMouseButton;
                                   Shift: TShiftState;
                                   X, Y: Integer) of object;

  TTreeCrossBoxStyle=(cbsSquare,cbsDiamond,cbsCircle);
  TTreeCrossSignStyle=(cssCross, cssTriangle);

  // Cross-Box object.
  // The CrossBox is the plus/minus box used to expand/collapse nodes
  TTreeNodeCrossBox=class(TPersistent)
  private
    FBorder         : TTreeCrossBoxPen;
    FBrush          : TTreeBrush;
    FClickTolerance : Integer;
    FSignPen        : TTreePen;
    FSignStyle      : TTreeCrossSignStyle;
    FSize           : Integer;
    FStyle          : TTreeCrossBoxStyle;
    FVisible        : Boolean;

    { private internal }
    FTree   : TCustomTree;

    function GetBackColor:TColor;
    procedure SetBackColor(const Value: TColor);
    procedure SetBorder(const Value:TTreeCrossBoxPen);
    Procedure SetBrush(const Value:TTreeBrush);
    Procedure SetSignPen(const Value:TTreePen);
    Procedure SetSignStyle(const Value:TTreeCrossSignStyle);
    procedure SetSize(Value:Integer);
    procedure SetStyle(const Value: TTreeCrossBoxStyle);
    procedure SetVisible(Value:Boolean);
  public
    Constructor Create(const AOwner:TCustomTree);
    Destructor Destroy; override;

    Procedure Assign(Source:TPersistent); override;
    Procedure Draw(Const AtPoint:TPoint; DrawExpanded:Boolean);
  published
    property BackColor:TColor read GetBackColor write SetBackColor default clNone;
    property Border:TTreeCrossBoxPen read FBorder write SetBorder;
    property Brush:TTreeBrush read FBrush write SetBrush;
    property ClickTolerance:Integer read FClickTolerance
                                    write FClickTolerance default 0;
    property SignPen:TTreePen read FSignPen write SetSignPen;
    property SignStyle:TTreeCrossSignStyle read FSignStyle write SetSignStyle default cssCross;
    property Size:Integer read FSize write SetSize default TeeDefaultBoxSize;
    property Style:TTreeCrossBoxStyle read FStyle write SetStyle default cbsSquare;
    property Visible:Boolean read FVisible write SetVisible default True;
  end;

  TNotifyShapeEvent=procedure(Sender:TTreeNodeShape) of object;
  TNotifyConnectionEvent=procedure(Sender:TTreeConnection) of object;
  TDeleteShapesEvent=Procedure(Sender:TSelectedShapeList; Var AllowDelete:Boolean) of object;
  TShowHintShapeEvent=Procedure(Sender:TCustomTree; Shape:TTreeNodeShape; var Text:String) of object;

  TTreeChangingEvent=procedure(Sender:TCustomTree; Node:TTreeNodeShape;
                                                   Var Allow:Boolean) of object;

  TMovingShapeEvent=procedure(Sender:TTreeNodeShape; Var DeltaX,DeltaY:Integer)
                                                     of object;

  TTreeResizingShape=procedure( Sender:TTreeNodeShape;
                                ACorner:TTreeShapeHandle;
                                Var DeltaX,DeltaY:Integer) of object;

  // Record to backup and restore Tree events
  TTreeEvents=record
    FAfterDraw           : TNotifyEvent;
    FBeforeDraw          : TNotifyEvent;
    FMouseDown           : TMouseEvent;
    FMouseUp             : TMouseEvent;
    FMouseMove           : TMouseMoveEvent;
    FChanging            : TTreeChangingEvent;
    FCheckedShape        : TNotifyEvent;
    FClickBackGround     : TTreeClick;
    FClickConnection     : TClickConnectionEvent;
    FClickShape          : TClickShapeEvent;
    FDblClickConnection  : TClickConnectionEvent;
    FDblClickShape       : TClickShapeEvent;
    FDeletingShapes      : TDeleteShapesEvent;
    FDeletedShapes       : TNotifyEvent;
    FExpandedCollapsed   : TNotifyShapeEvent;
    FExpandingCollapsing : TExpandingCollapsingEvent;
    FMovingShape         : TMovingShapeEvent;
    FMouseEnterShape     : TMouseShapeEvent;
    FMouseLeaveShape     : TMouseShapeEvent;
    FResizingShape       : TTreeResizingShape;
    FSelectShape         : TNotifyShapeEvent;
    FSelectConnection    : TNotifyConnectionEvent;
    FUnSelectConnection  : TNotifyConnectionEvent;
    FUnSelectShape       : TNotifyShapeEvent;
    FScroll              : TNotifyEvent;
    FZoom                : TNotifyEvent;
  end;

  // ScrollBar
  TTeeScrollBar=class(TPersistent)
  private
    FAutomatic : Boolean;
    FFlat      : Boolean;
    FMin       : Integer;
    FMax       : Integer;
    FPageSize  : Integer;
    FVisible   : Boolean;

    ITree      : TCustomTree;

    ICode      : Integer;

    {$IFDEF FMX}
    IScroll  : TScrollBar;
    {$ENDIF}

    {$IFDEF FMX}
    procedure ScrollChanged(Sender:TObject);
    {$ELSE}
    Function CalcScrollOffset(ScrollCode:Integer):Integer;
    Function CanModifyBar:Boolean;
    {$ENDIF}

    Procedure ChangeVisible(Value:Boolean);
    Procedure DoCheckMinMax;
    function GetPosition: Integer;
    Procedure InternalSetRange(Redraw:Boolean);
    Procedure SetAutomatic(Value:Boolean);
    Procedure SetFlat(Value:Boolean);
    Procedure SetMax(Value:Integer);
    Procedure SetMin(Value:Integer);
    procedure SetPageSize(Value:Integer);
    procedure SetPosition(Value:Integer);
    Procedure SetRange;
    Procedure SetScrollParams(Offset:Integer);
    Procedure SetVisible(Value:Boolean);
  protected
    Procedure CheckScroll(AMin,AMax,AOffset,ASize:Integer);
    Function Vertical:Boolean;
  public
    Constructor Create(const ATree:TCustomTree; IsHoriz:Boolean);

    Procedure Assign(Source:TPersistent); override;
    property Position:Integer read GetPosition;
  published
    property Automatic:Boolean read FAutomatic write SetAutomatic default True;
    property Flat:Boolean read FFlat write SetFlat default False;
    property Max:Integer read FMax write SetMax default TeeDefaultMaxScroll;
    property Min:Integer read FMin write SetMin default TeeDefaultMinScroll;
    property PageSize:Integer read FPageSize write SetPageSize default 0;
    property Visible:Boolean read FVisible write SetVisible default False;
  end;

  // List of nodes, used in TCustomTree to store all nodes.
  TTreeShapeList=class(TNodeShapeList)
  private
    FVisible : Boolean;

    Procedure SetVisible(const Value:Boolean);
  public
    Function AddChild(const Node:TTreeNodeShape; const Text:String):TTreeNodeShape;
    Procedure Assign(Source:TTreeShapeList);
    procedure SelectAll;

    property Visible:Boolean read FVisible write SetVisible;
  end;

  TTreeZoomedAreaEvent=Procedure(Const R:TRect) of object;

  // Mouse-Wheel navigation options.
  TTreeWheelNavigation=(
                         wnSelection,    // mouse wheel selects nodes
                         wnScrollVert,   // mouse wheel scrolls vertically
                         wnScrollHoriz,  // mouse wheel scrolls horizontally
                         wnZoom,         // mouse wheel zooms in and out
                         wnNone          // mouse wheel does nothing.
                        );

  // Different keyboard navigation styles.
  TTreeNavigation=(
                    tnExplorer,  // arrow keys select and expand/collapse nodes
                    tnNearest,   // arrow keys select nearest node to current
                    tnNone,      // keyboard does not select nor expands nodes
                    tnCircularExplorer  // same as Explorer. Last goes to First.
                  );

  // Abstract base class for "Child Managers".
  // A "Child Manager" is an object responsible to re-position nodes
  // and draw connection lines between parent and children.
  //
  // See Tree1.GlobalFormat.ChildManager element.
  TChildManager=class
  public
    Function CalcXYCross(const ANode,AParent:TTreeNodeShape):TPoint; virtual; abstract;
    Function DrawConnection(const AConnection:TTreeConnection):Boolean; virtual; abstract;
    Function XPosition(const ANode:TTreeNodeShape; ABrotherIndex:Integer):Integer; virtual; abstract;
    Function YPosition(const ANode:TTreeNodeShape; ABrotherIndex:Integer):Integer; virtual; abstract;
  end;

  // Default ChildManager.
  // Very similar to Windows Explorer tree style.
  TTreeExplorerAlignChild=class(TChildManager)
  private
    FCrossMargin : Integer;
    FHorizMargin : Integer;
    FTopPos      : Integer;
    FVertMargin  : Integer;
  protected
    ArrowToAngle: Integer;
    Function AnyRootShouldDrawCross(const Tree:TCustomTree):Boolean;
  public
    Constructor Create;

    Function CalcXYCross(const ANode,AParent:TTreeNodeShape):TPoint; override;
    Function DrawConnection(const AConnection:TTreeConnection):Boolean; override;
    Function XPosition(const ANode:TTreeNodeShape; ABrotherIndex:Integer):Integer; override;
    Function YPosition(const ANode:TTreeNodeShape; ABrotherIndex:Integer):Integer; override;

    property HorizMargin:Integer read FHorizMargin write FHorizMargin
                                 default TreeHorizMarginDefault;
    property TopPos:Integer read FTopPos write FTopPos default TeeTree_DefaultYPosition;
    property VertMargin:Integer read FVertMargin write FVertMargin
                                 default TreeVertMarginDefault;
    property CrossMargin:Integer read FCrossMargin write FCrossMargin
                                 default TeeCrossBoxHorizMargin;
  end;

  TTeeHotTrackFont=class(TTeeFont)
  published
    property Style default [{$IFDEF FMX}TFontStyle.{$ENDIF}fsUnderline];
  end;

  // TCustomTree HotTrack class.
  TTreeHotTrack=class(TPersistent)
  private
    FActive    : Boolean;
    FBorder    : TTreePen;
    FFont      : TTeeHotTrackFont;
    FHotLink   : Boolean;
    FUseBorder : Boolean;
    FUseFont   : Boolean;

    ITree   : TCustomTree;
    procedure SetActive(const Value: Boolean);
    procedure SetBorder(const Value: TTreePen);
    procedure SetFont(const Value: TTeeHotTrackFont);
  public
    Constructor Create(const ATree:TCustomTree);
    Destructor Destroy; override;

    Procedure Assign(Source:TPersistent); override;
  published
    property Active:Boolean read FActive write SetActive default False;
    property Border:TTreePen read FBorder write SetBorder;
    property Font:TTeeHotTrackFont read FFont write SetFont;
    property HotLink:Boolean read FHotLink write FHotLink default True;
    property UseBorder:Boolean read FUseBorder write FUseBorder default False;
    property UseFont:Boolean read FUseFont write FUseFont default False;
  end;

  // Event signature for "OnStartEditing" Tree event
  TNotifyShapeEventStartEdit=procedure(Shape:TTreeNodeShape;
                                       Var AllowEditing:Boolean) of object;

  TDragDropShapeEvent=procedure(Sender:TCustomTree; Dragged,Parent:TTreeNodeShape)
                                               of object;

  // Global record with formatting objects global to all nodes of a Tree...
  TTreeGlobal=record
     Border       : TTreePen;           // default node Border
     Brush        : TTreeShapeBrush;    // default node Brush
     Connection   : TTreeConnection;    // default Connection
     Cursor       : TCursor;            // default node Cursor
     Font         : TTeeFont;           // default node Font
     ShowCross    : TTreeNodeShapeShowCross;  // default node ShowCross
     ImageIndex   : TTreeNodeImageIndex;      // default node ImageIndex
     Transparent  : Boolean;                  // default node Transparent
     ChildManager : TChildManager;            // default ChildManager class
     NodeClass    : TTreeNodeShapeClass;      // default node class.
     ConnectionClass: TTreeConnectionClass;   // default connection class.
  end;

  // Pen with default Silver color. Used in Tree1.Grid
  TGridPen=class(TTreeHiddenPen)
  published
    property Color default clSilver;
  end;

  // Pen with default Gray color. Used in Tree1.Grid
  TGridBigPen=class(TTreeHiddenPen)
  published
    property Color default clGray;
  end;

  // Displays a grid.
  TTreeGrid=class(TPersistent)
  private
    FBigPen    : TGridBigPen;  { hidden, clGray color }
    FBigStep   : Integer;  { 10 times FStep }
    FColor     : TColor;   { clGray }
    FPen       : TGridPen; { hidden, clSilver color }
    FHorizStep : Integer;  { 10 pixels }
    FVertStep  : Integer;  { 10 pixels }
    FVisible   : Boolean;

    ITree    : TCustomTree;

    procedure SetBigPen(const Value: TGridBigPen);
    procedure SetBigStep(const Value: Integer);
    procedure SetColor(const Value: TColor);
    procedure SetHorizStep(const Value: Integer);
    procedure SetPen(const Value: TGridPen);
    procedure SetStep(const Value: Integer);
    procedure SetVertStep(const Value: Integer);
    procedure SetVisible(const Value: Boolean);
  public
    Constructor Create(const ATree:TCustomTree);
    Destructor Destroy; override;

    Procedure Assign(Source:TPersistent); override;
    property HorizStep:Integer read FHorizStep write SetHorizStep default TeeDefaultGridStep;
  published
    property BigPen:TGridBigPen read FBigPen write SetBigPen;
    property BigStep:Integer read FBigStep write SetBigStep default 10;
    property Color:TColor read FColor write SetColor default clGray;
    property Pen:TGridPen read FPen write SetPen;
    property Step:Integer read FHorizStep write SetStep default TeeDefaultGridStep;
    property VertStep:Integer read FVertStep write SetVertStep default TeeDefaultGridStep;
    property Visible:Boolean read FVisible write SetVisible default False;
  end;

  // Dark Gray pen used to display Tree Page boundaries.
  TTreePageBorder=class(TTreePen)
  private
    FPrint : Boolean;
  published
    property Color default clDkGray;
    property Print:Boolean read FPrint write FPrint default False;
  end;

  // Contains properties to determine the Tree Page size.
  TTreePage=class(TPersistent)
  private
    FBorder     : TTreePageBorder;
    FCount      : Integer;
    FHeight     : Integer;
    FPage       : Integer;
    FUsePrinter : Boolean;
    FWidth      : Integer;

    ITree   : TCustomTree;
    Function IsStored:Boolean;
    function InternalGetCount: Integer;
    function GetCount: Integer;
    function GetHeight: Integer;
    function GetWidth: Integer;
    procedure SetBorder(const Value: TTreePageBorder);
    procedure SetHeight(const Value: Integer);
    procedure SetPage(const Value: Integer);
    procedure SetUsePrinter(const Value: Boolean);
    procedure SetWidth(const Value: Integer);
  public
    Constructor Create(const ATree:TCustomTree);
    Destructor Destroy; override;

    Procedure Assign(Source:TPersistent); override;
    procedure Refresh;
    property Count:Integer read GetCount;
    Procedure DrawBorder;
    property Page:Integer read FPage write SetPage default 1;
  published
    property Border:TTreePageBorder read FBorder write SetBorder;
    property Height:Integer read GetHeight write SetHeight stored IsStored;
    property Width:Integer read GetWidth write SetWidth stored IsStored;
    property UsePrinter:Boolean read FUsePrinter write SetUsePrinter default True;
  end;

  // Default base class for "custom" node shapes
  // See for example: TreeFlow.pas unit for examples of "custom" shapes.
  TCustomTreeShape=class(TTreeNodeShape)
  public
    Constructor Create(AOwner:TComponent); override;
  published
    property ImageIndex default tiNone;
    property Style default tssCustom;
  end;

  // Polygon shape.

  TPolygonShape=class;
  TPolygonShapeClass=class of TPolygonShape;

  // Collection item containing one point of a polygon shape.
  TPointItem=class(TCollectionItem)
  private
    FY: Integer;
    FX: Integer;
    procedure SetX(const Value: Integer);
    procedure SetY(const Value: Integer);
  public
    Procedure Assign(Source:TPersistent); override;

    function Shape:TPolygonShape;
  published
    property X:Integer read FX write SetX;
    property Y:Integer read FY write SetY;
  end;

  // Collection of Polygon shape points.
  TPointCollection=class(TOwnedCollection)
  private
    function Area:Double;
    function Centroid:TPointFloat;
    function GetPoint(Index:Integer): TPointItem;
    procedure SetPoint(Index:Integer; const Value: TPointItem);
  protected
    procedure Notify(Item: TCollectionItem; Action: TCollectionNotification); override;
  public
    Function Add:TPointItem;
    property Point[Index:Integer]:TPointItem read GetPoint write SetPoint; default;
  end;

  // Custom shape to create free drawing polygons
  TPolygonShape=class(TCustomTreeShape)
  private
    FPoints         : TPointCollection;
    FResizingHandle : Integer;

    IsPolyLine      : Boolean;
    Procedure InternalDraw(const ACanvas:TCanvas3D; const OffsetX,OffsetY:TCoordinate);
    procedure SetPoints(const Value: TPointCollection);
  protected
    Function GetHandleCursor(x,y:Integer):TCursor; override;
    Function GetShapePoints(Const R:TRect; Var P:TShapePoints):Integer; override;
    Procedure Loaded; override;
  public
    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;

    Procedure Assign(Source:TPersistent); override;

    function Add(X,Y:Integer):TPointItem;
    function Area:Double;
    function Centroid:TPointFloat;
    Function ClickedPoint(x,y:Integer):Integer;
    Procedure DrawHandles; override;
    Procedure FillSample; { sample points to show at Editor toolbar }
    Function GetResizingHandle(x,y:Integer):TTreeShapeHandle; override;
    function Insert(Index,X,Y:Integer):TPointItem;
    Procedure MoveRelative(OfsX,OfsY:Integer; MoveChilds:Boolean); override;
    Procedure RecalcSize(const ACanvas:TCanvas3D); override;
    Procedure Resize(ACorner:TTreeShapeHandle; DeltaX,DeltaY:Integer); override;
  published
    property Points:TPointCollection read FPoints write SetPoints;
  end;

  // Custom shape to create free drawing poly-lines
  TPolyLineShape=class(TPolygonShape)
  public
    Constructor Create(AOwner: TComponent); override;
    Function Clicked(const x,y:TCoordinate):Boolean; override;
  end;

  // Custom shape that displays the node Image centered.
  TImageShape=class(TTreeNodeShape)
  public
    Constructor Create(AOwner: TComponent); override;
    Procedure RecalcSize(const ACanvas:TCanvas3D); override;
  published
    property ImageIndex default tiMyPc;
    property ImageAlignment default iaCenter;
  end;

  // Simple shape to display Text only.
  // By default sets Transparent to True, Image to None and
  // hides Border.
  TTextShape=class(TTreeNodeShape)
  public
    Constructor Create(AOwner: TComponent); override;
  published
    property ImageIndex default tiNone;
    property Transparent default True;
  end;

  TNewPolygonEvent=procedure( Sender: TCustomTree;
                              APolygon:TPolygonShape) of object;

  TImageLevels=class;

  // Automatic Drag and drop options.
  TTreeDragDrop=class(TPersistent)
  private
    FAutomatic     : Boolean;
    FDragToRoot    : Boolean;
    FDragRoots     : Boolean;
    FFromOtherTree : Boolean;
    FRemove        : Boolean;
    FToOtherTree   : Boolean;
  public
    AutoScroll     : Boolean;

    Constructor Create;

    Procedure Assign(Source:TPersistent); override;
  published
    property Automatic:Boolean read FAutomatic write FAutomatic default False;
    property DragRoots:Boolean read FDragRoots write FDragRoots default True;
    property DragToRoot:Boolean read FDragToRoot write FDragToRoot default True;
    property FromOtherTree:Boolean read FFromOtherTree write FFromOtherTree default True;
    property RemoveNodes:Boolean read FRemove write FRemove default True;
    property ToOtherTree:Boolean read FToOtherTree write FToOtherTree default True;
  end;

  // Constants to determine when to show the Memo to edit a node's text.
  TTreeTextEditorMode=(
                        tteKey,   // when pressing the default key (F2)
                        tteMouse, // when clicking the node
                        tteBoth   // when key is pressed or mouse clicks.
                      );

  // Options to display a Memo to edit the node text.
  TTreeTextEditor=class(TPersistent)
  private
    FEnabled        : Boolean;
    FMemo           : TMemo;
    FMode           : TTreeTextEditorMode;
    FMouse          : TMouseButton;
    FShortCut       : TShortCut;
    FUseNodeFont    : Boolean;
    FUseNodeFormat  : Boolean;
    FUseNodeSize    : Boolean;
  public
    Constructor Create;
    Destructor Destroy; override;

    Procedure Assign(Source:TPersistent); override;
    property Memo:TMemo read FMemo;  { read only, returns the memo }
  published
    property Enabled:Boolean read FEnabled write FEnabled default True; { to show or not the memo }
    property Mode:TTreeTextEditorMode read FMode write FMode default tteKey; { when (key or mouse) to show or not the memo }
    property MouseButton:TMouseButton read FMouse write FMouse default {$IFDEF FMX}TMouseButton.{$ENDIF}mbLeft;  { which mouse button should show the memo }
    property ShortCut:TShortCut read FShortCut write FShortCut default TeeTree_EditKey;  { key to show the memo , default F2 }
    property UseNodeSize:Boolean read FUseNodeSize write FUseNodeSize default True; { get or not the same size as the node }
    property UseNodeFormat:Boolean read FUseNodeFormat write FUseNodeFormat default False;  { get or not the same back color and border as the node }
    property UseNodeFont:Boolean read FUseNodeFont write FUseNodeFont default False;  { get or not the same font as the node }
  end;

  TTreeAfterDrawEvent=class(TTeeEvent);

  TTreeSortCompareEvent=procedure(Node1,Node2:TTreeNodeShape;
                                  Var Compare:Integer) of object;

  TTreeAddingConnectionEvent=procedure( Node1,Node2:TTreeNodeShape;
                                        Var Add:Boolean) of object;

  { Tree Zoom Status}
  TTreeZoomDefault=record
    ZoomPercent,
    HorizOffset,
    VertOffset: Integer;
  end;

  {$IFDEF FMX}
  TImageList=class(TComponent)
  private
    // IList : TList{$IFDEF D18}<TBitmap>{$ENDIF};
  protected
    procedure Change; virtual;
  public
    procedure GetBitmap(Index:Integer; const Bitmap:TBitmap);
    function Count:Integer;
  end;
  {$ENDIF}

  // Main TeeTree class.
  TCustomTree=class(TCustomTeePanelExtended)
  private
    FAllowDelete     : Boolean;
    FAllowResize     : Boolean;
    FConnections     : TTreeConnectionList;
    FCrossBox        : TTreeNodeCrossBox;
    FDesigning       : Boolean;
    FDragDrop        : TTreeDragDrop;
    FDragged         : TTreeNodeShape;
    FGrid            : TTreeGrid;
    FHorzScroll      : TTeeScrollBar;
    FHotTrack        : TTreeHotTrack;
    FImages          : TImageList;
    FNavigation      : TTreeNavigation;
    FPage            : TTreePage;
    FReadOnly        : Boolean;
    FRoots           : TNodeShapeList;
    FScrollMouse     : TMouseButton;
    FSelected        : TSelectedShapeList;
    FSingleSelection : Boolean;
    FShapes          : TTreeShapeList;
    FShowHintShapes  : Boolean;
    FShowRootCross   : Boolean;
    FSnapToGrid      : Boolean;
    FTextEditor      : TTreeTextEditor;
    FVertScroll      : TTeeScrollBar;
    FWheelNavigation : TTreeWheelNavigation;
    FZoomDefault     : TTreeZoomDefault;

    { events }
    FOnAddingConn          : TTreeAddingConnectionEvent;
    FOnBeforeDraw          : TNotifyEvent;
    FOnChanging            : TTreeChangingEvent;
    FOnCheckedShape        : TNotifyEvent;
    FOnClickConnection     : TClickConnectionEvent;
    FOnClickShape          : TClickShapeEvent;
    FOnClickTree           : TTreeClick;
    FOnDblClickConnection  : TClickConnectionEvent;
    FOnDblClickShape       : TClickShapeEvent;
    FOnDeletingShapes      : TDeleteShapesEvent;
    FOnDeletedShapes       : TNotifyEvent;
    FOnDragDropShape       : TDragDropShapeEvent;
    FOnExpandedCollapsed   : TNotifyShapeEvent;
    FOnExpandingCollapsing : TExpandingCollapsingEvent;
    FOnMovingShape         : TMovingShapeEvent;
    FOnMouseEnterShape     : TMouseShapeEvent;
    FOnMouseLeaveShape     : TMouseShapeEvent;
    FOnNewConnection       : TTreeNewConnectionEvent;
    FOnNewShape            : TTreeNewShapeEvent;
    FOnResizingShape       : TTreeResizingShape;
    FOnSelectConnection    : TNotifyConnectionEvent;
    FOnSelectShape         : TNotifyShapeEvent;
    FOnShowHint            : TShowHintShapeEvent;
    FOnSortCompare         : TTreeSortCompareEvent;
    FOnStartEditing        : TNotifyShapeEventStartEdit;
    FOnStopEditing         : TNotifyShapeEvent;
    FOnUnSelectConnection  : TNotifyConnectionEvent;
    FOnUnSelectShape       : TNotifyShapeEvent;

  private
    { internal }
    OriginalX : Integer;
    OriginalY : Integer;

    // mouse dragging
    FResizing        : TTreeShapeHandle;
    FConnHandle      : Integer;

    { internal flags ... }
    IEscapedConnecting : Boolean;
    IShape1            : TTreeNodeShape;
    IShape2            : TTreeNodeShape;
    IFromConnect       : TPoint;
    IToConnect         : TPoint;
    IEditShape         : TTreeNodeShape;
    IChangingMemo      : Boolean;
    IClearing          : Boolean;
    IScrolled          : Boolean;
    IEditing           : Boolean;

    {$IFDEF D17}
    {$IFDEF FMX}
    type
        TPanDirection = (pdUndecided, pdHorizontal, pdVertical,  pdArbitrary);
    var
    IPanPoint: TPointF;
    IPanDirection: TPanDirection;
    {$ENDIF}
    {$ENDIF}

    Procedure AutomaticScrollBars;

    {$IFDEF PAGEBOUNDS}
    procedure CalculatePageBounds;
    {$ENDIF}

    Function CanBeParentOf(const AParent,AShape:TTreeNodeShape):Boolean;

    {$IFNDEF FMX}
    procedure CMHintShow(var Message: TMessage); message CM_HINTSHOW;
    {$ENDIF}

    Function Destroying:Boolean; {$IFDEF D9}inline;{$ENDIF}
    Procedure DrawConnecting(const x,y:TCoordinate; CheckPos:Boolean);
    Procedure DrawPolygon;

    {$IFDEF FMX}
    procedure EditKeyDown(Sender: TObject; var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
    {$ELSE}
    procedure EditKeyDown(Sender: TObject; var Key:Word; Shift: TShiftState);
    {$ENDIF}

    Procedure FinishDrag(const Target:TTreeNodeShape);
    Procedure FinishEditing(SetNewText:Boolean);
    Function GetGridColor:TColor;
    Function GetGridStep:Integer;
    function GetMemo: TMemo;
    Function GetShape(Index:Integer):TTreeNodeShape;
    procedure GlobalFormatChanged(Sender:TObject);
    Function InstanceName(const AShape:TTreeNodeShape):String;

    {$IFNDEF FMX}
    procedure InternalSetFocus(Value:Boolean);
    {$ENDIF}

    procedure InternalWheel(IsDown:Boolean);
    procedure MouseDrawZoomRectangle;
    procedure ReadGridColor(Reader: TReader);
    procedure ReadGridStep(Reader: TReader);
    Function Rectangle2DPosition(Const R:TRect):TRect;
    Procedure RemoveShape(const AShape:TTreeNodeShape);
    Procedure SelectedScroll;

    Procedure SetCrossBox(const Value:TTreeNodeCrossBox);
    Procedure SetDefaultCapacity;
    Procedure SetDesigningField(const Value:Boolean);
    Procedure SetGrid(const Value:TTreeGrid);
    Procedure SetGridColor(const Value:TColor);
    Procedure SetGridStep(const Value:Integer);
    Procedure SetHorzScrollBar(const Value:TTeeScrollBar);
    procedure SetImages(const Value: TImageList);
    procedure SetScrollParams;
    procedure SetSelected(const Value:TSelectedShapeList);
    Procedure SetShape(Index:Integer; const Value:TTreeNodeShape);
    procedure SetSingleSelection(Value:Boolean);
    procedure SetTextEditor(const Value: TTreeTextEditor);
    Procedure SetVertScrollBar(const Value:TTeeScrollBar);
    Procedure View3DChangedZoom(NewZoom:Integer);
    Procedure View3DScrolled(IsHoriz:Boolean);

    {$IFNDEF FMX}
    procedure WMHScroll(var Msg: TWMHScroll); message WM_HSCROLL;
    procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
    procedure WMVScroll(var Msg: TWMVScroll); message WM_VSCROLL;
    {$ENDIF}

    procedure SetAllowDelete(const Value: Boolean);
    procedure SetAllowResize(const Value: Boolean);
    procedure SetReadOnly(const Value: Boolean);
    procedure SetShowRootCross(const Value: Boolean);
    procedure SetHotTrack(const Value: TTreeHotTrack);
    procedure SetPage(const Value: TTreePage);
    procedure SetDragDrop(const Value: TTreeDragDrop);
  protected
    IBounds       : TRect;
    IBounds2D     : TRect;
    IImageLevels  : TImageLevels;

    // internal. Used when drawing a polygon at Tree editor.
    IPolygonMode  : TPolygonShapeClass;
    IPolygonShape : TPolygonShape;
    OnNewPolygon  : TNewPolygonEvent;

    // internal. Used at editor when adding a new shape dragging a rectangle
    IZoomPriority : Boolean;

    Procedure ChangeSelection(const ANode:TTreeNodeShape);

    {$IFNDEF FMX}
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    {$ENDIF}

    Procedure DefineProperties(Filer:TFiler); override;

    {$IFDEF FMX}
    procedure DragEnd; override;
    procedure DragOver(const Data: TDragObject; const Point: TPointF;
        var {$IFDEF D20}Operation: TDragOperation{$ELSE}Accept: Boolean{$ENDIF}); override;
    {$ELSE}
    procedure DragCanceled; override;
    procedure DragOver(Source: TObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean); override;
    procedure DoEndDrag(Target: TObject; X, Y: Integer); override;
    {$ENDIF}

    Procedure DoDraw;
    Function DoExpandCollapse(const AShape:TTreeNodeShape; Value:Boolean):Integer; virtual;
    Procedure DoSelectConnection(const AConnection:TTreeConnection);
    Procedure DrawDiamond(Const R:TRect);
    Procedure DrawGrid;
    Procedure DrawHandle(const Node:TCustomTreeElement; const Handle:TTreeShapeHandle;
                         x,y: TCoordinate);
    Procedure EndDrawHandles;

    {$IFNDEF D11}
    Procedure GetChildren(Proc:TGetChildProc; Root:TComponent); override;
    {$ENDIF}

    function GetChildOwner: TComponent; override;
    procedure InternalDraw(Const UserRectangle:TRect); override;

    {$IFDEF FMX}
    procedure KeyDown(var Key: Word; var KeyChar: WideChar; Shift: TShiftState); override;
    {$ELSE}
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    {$ENDIF}

    procedure Loaded; override;

    {$IFDEF FMX}
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Single); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Single); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Single); override;
    {$ELSE}
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    Procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    {$ENDIF}

    procedure Notification( AComponent: TComponent; Operation: TOperation); override;
    Procedure PrepareDrawHandles;
    Function PrepareGrid(Var tmpH,tmpV:Integer):TRect;

    {$IFDEF FMX}

    {$IFDEF D21}
    Procedure DoBeginUpdate; override;
    Procedure DoEndUpdate; override;
    {$ENDIF}

    procedure MouseWheel(Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean); override;

    {$IFDEF D17}
    procedure DoGesture(const EventInfo: TGestureEventInfo; var Handled: Boolean); override;
    {$ENDIF}

    {$ELSE}
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    {$ENDIF}

    property Dragged:TTreeNodeShape read FDragged;
  public
    AssignParent      : Boolean;  // when True, newly added nodes copy format from parent node.
    CreateConnections : Boolean;  // when True, adding a child node also adds a connection object.
    NegativeCoordinates : Boolean;  // when True, negative co�rdinates are allowed. Warning: Future versions might change.
    NoOwnerShapes     : Boolean;  // when True, new nodes are created without VCL Owner (nil).
    ShowImages        : Boolean;  // when True, node images are displayed.
    ShowText          : Boolean;  // when True, node text is displayed.
    ZoomCentered      : Boolean;  // when True, changing View3DOptions.Zoom does zoom from center.

    GlobalFormat      : TTreeGlobal;  // record containing default and global values.
    Connecting        : Boolean;      // when True, mouse is connecting nodes at Tree editor.
    OnZoomedArea      : TTreeZoomedAreaEvent;  // event to call when zooming.

    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;

    Function AddCloneShape(const AShape:TTreeNodeShape):TTreeNodeShape;

    Procedure AddNewShape(  const AShape:TTreeNodeShape;
                            X,Y:Integer; Const AText:String;
                            const AParentShape:TTreeNodeShape);
    Function AddShapeClass( X,Y:Integer; Const AText:String;
                            const AParentShape:TTreeNodeShape;
                            const AClass:TTreeNodeShapeClass ):TTreeNodeShape;
    Function AddShape( X,Y:Integer; Const AText:String;
                       const AParentShape:TTreeNodeShape):TTreeNodeShape;
    Function AddRoot(Const RootText:String):TTreeNodeShape;
    Function AddRootObject(Const AText:String; Data:Pointer):TTreeNodeShape;

    // Easy overloaded "Add" methods:
    Function Add(X,Y:Integer; Const Text:String; const Parent:TTreeNodeShape):TTreeNodeShape; overload;
    Function Add(Const Text:String):TTreeNodeShape; overload;
    Function Add(Const Text:String; const Parent:TTreeNodeShape):TTreeNodeShape; overload;

    Procedure Assign(Source:TPersistent); override;

    {$IFDEF D21}
    {$IFNDEF FMX}
    Procedure BeginUpdate;
    Procedure EndUpdate;
    {$ENDIF}
    {$ELSE}
    Procedure BeginUpdate; {$IFDEF FMX}override;{$ENDIF}
    Procedure EndUpdate; {$IFDEF FMX}override;{$ENDIF}
    {$ENDIF}

    Procedure CenterInView(const Shape:TTreeNodeShape; Animated:Boolean=True);
    Procedure ChangeManager(const NewManager:TChildManager);
    procedure Clear;
    Function ClickedShape(x,y:Integer):TTreeNodeShape;
    Function CloneShape(const AShape:TTreeNodeShape):TTreeNodeShape;

    Procedure DeleteShape(const AShape:TTreeNodeShape);

    property Editing:Boolean read IEditing;      // when True, text editor Memo is visible.

    Function FindFreeName(Const AShape:TTreeNodeShape):String;
    Procedure FullExpandCollapse(Expand:Boolean);

    {$IFDEF D11}
    Procedure GetChildren(Proc:TGetChildProc; Root:TComponent); override;
    {$ENDIF}

    Function GetRectangle:TRect; override; { to customize printing bounds }

    Function LoadFromStrings(const Strings:TStrings):TTreeNodeShape;
    Function LoadFromTextFile(Const FileName:String):TTreeNodeShape;

    procedure ProcessKey(Key: Word; Shift: TShiftState);

    Procedure SaveEvents(Var SavedEvents:TTreeEvents);
    Procedure SetEvents(Const SavedEvents:TTreeEvents);

    Procedure SelectConnection(const AConnection:TTreeConnection);
    Procedure SetDesignTime(Value:Boolean); // Sets ComponentState "csDesigning"
    Procedure Sort(Ascending:Boolean=True; IgnoreCase:Boolean=True); {$IFDEF FMX}reintroduce;{$ENDIF}
    Function StartConnecting:TTreeConnection;
    Procedure StopConnecting;
    Procedure StartEditing(const AShape:TTreeNodeShape);
    Procedure StopEditing;

    Procedure ZoomRectangle(R:TRect);
    Procedure ZoomFromCenter(NewZoom:Integer; X,Y:Integer);

    Procedure ZoomSetHome; overload;
    Procedure ZoomSetHome(const ZoomParams:TTreeZoomDefault); overload;
    Procedure ZoomReset;

    { properties }
    property AllowDelete:Boolean read FAllowDelete write SetAllowDelete default True;
    property AllowResize:Boolean read FAllowResize write SetAllowResize default True;
    property ConnectingShape1:TTreeNodeShape read IShape1;
    property ConnectingShape2:TTreeNodeShape read IShape2;
    property Connections:TTreeConnectionList read FConnections;
    property CrossBox:TTreeNodeCrossBox read FCrossBox write SetCrossBox;
    property Designing:Boolean read FDesigning write SetDesigningField default False;
    property DragAndDrop:TTreeDragDrop read FDragDrop write SetDragDrop;

    property Grid:TTreeGrid read FGrid write SetGrid;

    // deprecated. See Grid property.
    property GridColor:TColor read GetGridColor write SetGridColor default clNone;
    property GridStep:Integer read GetGridStep write SetGridStep;

    property HotTrack:TTreeHotTrack read FHotTrack write SetHotTrack;
    property Images:TImageList read FImages write SetImages;

    property InternalMemo:TMemo read GetMemo;  // OBSOLETE. Replaced with TextEditor.Memo

    property Items:TTreeShapeList read FShapes; // for TTreeView compatibility.
    property Navigation:TTreeNavigation read FNavigation
                                        write FNavigation default tnExplorer;
    property Page:TTreePage read FPage write SetPage;
    property ReadOnly:Boolean read FReadOnly write SetReadOnly default False;
    property Roots:TNodeShapeList read FRoots;
    property Scrolled:Boolean read IScrolled;
    property ScrollMouseButton:TMouseButton read FScrollMouse write FScrollMouse
             default {$IFDEF FMX}TMouseButton.{$ENDIF}mbRight;
    property Selected:TSelectedShapeList read FSelected write SetSelected;
    property Shape[Index:Integer]:TTreeNodeShape read GetShape write SetShape;
                                                 default;
    property Shapes:TTreeShapeList read FShapes;
    property SingleSelection:Boolean read FSingleSelection write SetSingleSelection
                                     default True;
    property ShowHintShapes:Boolean read FShowHintShapes write FShowHintShapes default True;
    property ShowRootCross:Boolean read FShowRootCross write SetShowRootCross default True;
    property SnapToGrid:Boolean read FSnapToGrid write FSnapToGrid default True;

    {$IFNDEF FMX}
    property TabStop default True;
    {$ENDIF}

    property TextEditor:TTreeTextEditor read FTextEditor write SetTextEditor;
    property TotalBounds:TRect read IBounds;
    property HorzScrollBar  : TTeeScrollBar read FHorzScroll write SetHorzScrollBar;
    property VertScrollBar  : TTeeScrollBar read FVertScroll write SetVertScrollBar;
    property WheelNavigation:TTreeWheelNavigation read FWheelNavigation
                                        write FWheelNavigation default wnSelection;

    { inherited }
    property BufferedDisplay default True;

    { events }
    property OnAddingConnection:TTreeAddingConnectionEvent read FOnAddingConn
                                                           write FOnAddingConn;
    property OnBeforeDraw: TNotifyEvent read FOnBeforeDraw write FOnBeforeDraw;
    property OnChanging:TTreeChangingEvent read FOnChanging write FOnChanging;
    property OnClickBackground:TTreeClick read FOnClickTree write FOnClickTree;
    property OnClickConnection:TClickConnectionEvent read FOnClickConnection
                                                     write FOnClickConnection;
    property OnClickShape:TClickShapeEvent read FOnClickShape write FOnClickShape;
    property OnCheckedShape:TNotifyEvent read FOnCheckedShape write FOnCheckedShape;
    property OnDblClick;
    property OnDblClickConnection:TClickConnectionEvent read FOnDblClickConnection
                                                     write FOnDblClickConnection;
    property OnDblClickShape:TClickShapeEvent read FOnDblClickShape write FOnDblClickShape;
    property OnDeletingShapes:TDeleteShapesEvent read FOnDeletingShapes write FOnDeletingShapes;
    property OnDeletedShapes:TNotifyEvent read FOnDeletedShapes write FOnDeletedShapes;
    property OnDragDropShape:TDragDropShapeEvent read FOnDragDropShape write FOnDragDropShape;
    property OnExpandedCollapsed:TNotifyShapeEvent read FOnExpandedCollapsed write FOnExpandedCollapsed;
    property OnExpandingCollapsing:TExpandingCollapsingEvent read FOnExpandingCollapsing write FOnExpandingCollapsing;
    property OnMovingShape:TMovingShapeEvent read FOnMovingShape write FOnMovingShape;
    property OnMouseEnterShape:TMouseShapeEvent read FOnMouseEnterShape write FOnMouseEnterShape;
    property OnMouseLeaveShape:TMouseShapeEvent read FOnMouseLeaveShape write FOnMouseLeaveShape;
    property OnNewConnection:TTreeNewConnectionEvent read FOnNewConnection write FOnNewConnection;
    property OnNewShape:TTreeNewShapeEvent read FOnNewShape write FOnNewShape;
    property OnResizingShape:TTreeResizingShape read FOnResizingShape write FOnResizingShape;
    property OnSelectConnection:TNotifyConnectionEvent read FOnSelectConnection write FOnSelectConnection;
    property OnSelectShape:TNotifyShapeEvent read FOnSelectShape write FOnSelectShape;
    property OnShowHint:TShowHintShapeEvent read FOnShowHint write FOnShowHint;
    property OnSortCompare:TTreeSortCompareEvent read FOnSortCompare write FOnSortCompare;
    property OnStartEditing:TNotifyShapeEventStartEdit read FOnStartEditing write FOnStartEditing;
    property OnStopEditing:TNotifyShapeEvent read FOnStopEditing write FOnStopEditing;
    property OnUnSelectConnection:TNotifyConnectionEvent read FOnUnSelectConnection write FOnUnSelectConnection;
    property OnUnSelectShape:TNotifyShapeEvent read FOnUnSelectShape write FOnUnSelectShape;

    { inherited events, make public }
    property OnKeyDown;
  end;

  {$IFDEF D16}
  [ComponentPlatformsAttribute(TreeAllComponentPlatformIDs)]
  {$ENDIF}
  TTree=class(TCustomTree)
  {$IFNDEF FMX}
  public
    property DockManager;
  {$ENDIF}
  published
    property AllowDelete;
    property AllowPanning;
    property AllowResize;
    property AnimatedZoomSteps;
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

    { events }
    property OnAddingConnection;
    property OnAfterDraw;
    property OnBeforeDraw;
    property OnChanging;
    property OnCheckedShape;
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

    {$IFNDEF FMX}
    property OnKeyPress;
    {$ENDIF}

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
    property OnSortCompare;
    property OnStartEditing;
    property OnStopEditing;
    property OnUnSelectConnection;
    property OnUnSelectShape;
    property OnUndoZoom;
    property OnZoom;

    { TPanel properties }
    property Align;
    property BevelInner default bvLowered;
    property BevelOuter default bvLowered;
    property BevelWidth;
    property BorderWidth;
    property BorderStyle default bsNone;
    property Color default clWhite;

    {$IFNDEF FMX}
    property DragCursor;
    {$ENDIF}

    property DragMode;
    property Enabled;

    {$IFNDEF FMX}
    property ParentColor default False;
    property ParentShowHint;
    {$ENDIF}

    property PopupMenu;
    property ShowHint;
    property TabOrder;

    {$IFNDEF FMX}
    property TabStop;
    {$ENDIF}

    property Visible;

    {$IFNDEF FMX}
    {$IFNDEF TEEOCX}
    property UseDockManager default True;
    property DockSite;
    {$ENDIF}
    {$ENDIF}

    property Anchors;

    {$IFNDEF FMX}
    property AutoSize;
    {$ENDIF}

    {$IFNDEF FMX}
    {$IFNDEF TEEOCX}
    property Constraints;
    {$ENDIF}
    {$ENDIF}

    {$IFNDEF FMX}
    property DragKind;
    {$ENDIF}
    property Locked;

    { TPanel events }
    property OnClick;

    {$IFNDEF FMX}
    property OnContextPopup;
    {$ENDIF}

    property OnDblClick;
    property OnDragDrop;
    property OnDragDropShape;
    property OnDragOver;

    {$IFDEF FMX}
    property OnDragEnter;
    property OnDragLeave;
    property OnDragEnd;
    property OnPainting;
    property OnPaint;
    property OnApplyStyleLookup;
    {$IFDEF D29}
    property OnFreeStyle;
    {$ENDIF}
    property OnCanFocus;
    {$ELSE}
    property OnEndDrag;
    {$ENDIF}

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

    {$IFNDEF FMX}
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
    {$ENDIF}
  end;

  // Small class to manage copy / cut / paste of nodes
  TTreeClipboard=class(TCustomTree)
  private
    IsCut : TCustomTree;
  public
    Procedure Copy(const SourceTree:TCustomTree);
    Procedure Cut(const SourceTree:TCustomTree);
    Procedure Paste(const DestTree:TCustomTree);
  end;

  // Custom shape to create "exact" polygons (pentagon, hexagon, octagon, etc)
  TTreeCustomPolygonShape=class(TCustomTreeShape)
  private
    FAngleOffset : Double;
    procedure SetAngleOffset(const Value: Double);
  protected
    Function GetPolygonPoints(Sides:Integer; Const R:TRect;
                              Var P:TShapePoints):Integer;
  published
    property AngleOffset:Double read FAngleOffset write SetAngleOffset;
  end;

  // ImageList component to supply images to nodes.
  // Image with index zero is assigned to nodes with Level zero, and so on.
  // The node level is the count of parents a node has. (Parent->Parent->etc)
  TImageLevels=class(TImageList)
  private
    FTree : TCustomTree;

    IPictures : Array[0..100] of TPicture;

    function NewPicture(const Level: Integer): TPicture;
    procedure SetTree(const Value: TCustomTree);
  protected
    Procedure ClearPictures;

    {$IFNDEF D22}
    procedure Change; override;
    {$ENDIF}

    Function GetPicture(Level:Integer):TPicture;
    procedure Notification( AComponent: TComponent;
                            Operation: TOperation); override;
  public
    Destructor Destroy; override;

    {$IFDEF D22}
    procedure Change; override;
    {$ENDIF}
  published
    property Tree: TCustomTree read FTree write SetTree;
  end;

  // TCustomTreeLink. Base class.
  TCustomTreeLink=class(TComponent)
  protected
    FTree : TCustomTree;
    procedure Notification( AComponent: TComponent;
                            Operation: TOperation); override;
    procedure SetTree(const Value: TCustomTree); virtual;
  published
    property Tree:TCustomTree read FTree write SetTree;
  end;

  TCustomPanelTreeLink=class(TCustomPanel,ITeeEventListener)
  private
    FTree : TCustomTree;
    procedure TeeEvent(Event: TTeeEvent); virtual;
  protected
    procedure Notification( AComponent: TComponent;
                            Operation: TOperation); override;
    procedure SetTree(const Value: TCustomTree); virtual;
  public
    Destructor Destroy; override;

    property Tree:TCustomTree read FTree write SetTree;
  end;

  { Ruler component }
  TRulerUnits=(ruPixels,ruCentimeters,ruInches);

  TTreeRuler=class;

  TTreeRulerGetUnit=procedure(Sender:TTreeRuler; Pixel:Integer; var Text:String)
                                                 of object;

  TTreeRuler=class(TCustomPanelTreeLink)
  private
    FMarker     : TTeePen;
    FOnGetUnit  : TTreeRulerGetUnit;
    FShowUnits  : Boolean;
    FUnits      : TRulerUnits;

    IOldPos     : Integer;

    {$IFNDEF FMX}
    procedure InitFont;
    {$ENDIF}
    
    function IsAlignLeft:Boolean;
    function IsVerticalAlign:Boolean;
    procedure SetMarker(const Value:TTeePen);
    procedure SetShowUnits(const Value: Boolean);
    procedure SetUnits(const Value: TRulerUnits);
    procedure TeeEvent(Event: TTeeEvent); override;
    function UnitsToStr(const Pixels:Integer):String;
  protected
    Procedure Paint; override;
  public
    Constructor Create(AOwner:TComponent); override;
    Destructor Destroy; override;

    Procedure DoMouseMove(x,y:Integer);

    {$IFNDEF FMX}
    property DockManager;
    {$ENDIF}

  published
    {$IFNDEF FMX}
    property Font;
    {$ENDIF}

    property Marker:TTeePen read FMarker write SetMarker;
    property ShowUnits:Boolean read FShowUnits write SetShowUnits default True;
    property Tree;
    property Units:TRulerUnits read FUnits write SetUnits default ruPixels;

    property OnGetUnit:TTreeRulerGetUnit read FOnGetUnit write FOnGetUnit;

    { events }
    property OnKeyDown;

    {$IFNDEF FMX}
    property OnKeyPress;
    {$ENDIF}

    property OnKeyUp;

    { TPanel properties }
    property Align;

    {$IFNDEF FMX}
    property BevelInner;
    property BevelOuter default bvNone;
    property BevelWidth;
    property BorderWidth;
    property BorderStyle default bsSingle;
    property Color default clWhite;
    property DragCursor;
    {$ENDIF}

    property DragMode;
    property Enabled;

    {$IFNDEF FMX}
    property ParentColor default False;
    property ParentShowHint;
    {$ENDIF}

    property PopupMenu;
    property ShowHint;
    property TabOrder;

    {$IFNDEF FMX}
    property TabStop;
    {$ENDIF}

    property Visible;

    {$IFNDEF FMX}
    {$IFNDEF TEEOCX}
    property UseDockManager default True;
    property DockSite;
    {$ENDIF}
    {$ENDIF}

    property Anchors;

    {$IFNDEF FMX}
    property AutoSize;
    {$IFNDEF TEEOCX}
    property Constraints;
    {$ENDIF}
    {$ENDIF}

    {$IFNDEF FMX}
    property DragKind;
    {$ENDIF}
    property Locked;

    { TPanel events }
    property OnClick;

    {$IFNDEF FMX}
    property OnContextPopup;
    {$ENDIF}

    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;

    {$IFDEF FMX}
    property OnDragEnter;
    property OnDragLeave;
    property OnDragEnd;
    property OnPainting;
    property OnPaint;
    property OnApplyStyleLookup;
    {$IFDEF D29}
    property OnFreeStyle;
    {$ENDIF}
    property OnCanFocus;

    {$IFDEF D25}
    property OnResized;
    {$ENDIF}

    {$ELSE}
    property OnEndDrag;
    {$ENDIF}

    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;

    {$IFNDEF FMX}
    property OnStartDrag;
    {$ENDIF}

    {$IFNDEF FMX}
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
    {$ENDIF}
  end;

{ Returns True when R1 and R2 rectangles intersect. }
Function Intersect(Const R1,R2:TRect):Boolean;

{ Adds a new shape object to the shapes's global palette }
Procedure RegisterCustomTreeShape( const AGroup:String;
                                   const AName:String;
                                   const AClass:TTreeNodeShapeClass);

{ Deletes a custom shape object in the shape's palette }
Procedure UnRegisterCustomTreeShapes(const AClass:Array of TTreeNodeShapeClass);

{ Storage for custom shape classes to display at Tree Editor palette tabs }
Var TreeCustomShapes : TList{$IFDEF D18}<Pointer>{$ENDIF};

type TTreeForEachCustomShapeProc=Procedure( Const AGroup:String;
                                            Const AName:String;
                                            AClass:TTreeNodeShapeClass) of object;

// Create a text file and store Node and children text recursively.
Procedure SaveTreeToTextFile(const Tree:TCustomTree; Const FileName:String); overload;
Procedure SaveTreeToTextFile(const Node:TTreeNodeShape; Const FileName:String); overload;

// Store Node and children text recursively into Stream. Returns Stream.
Function SaveTreeTextToStream(const Stream:TStream; const Tree:TCustomTree; const Node:TTreeNodeShape=nil):TStream;

// Traverses the "custom shape" array and call ForEachProc procedure pointer
Procedure TreeForEachCustomShape(const ForEachProc:TTreeForEachCustomShapeProc);

type
  TTreeImagePool=class
  private
    FImages : Array of TPicture;

    Function GetImage(Index:Integer):TPicture;
  public
    Constructor Create;
    Destructor Destroy; override;

    // Adds a new picture image into global TreeImagePool list
    Function Add(const Picture:TPicture):TTreeNodeImageIndex; overload;
    Function Add(const FileName:String):TTreeNodeImageIndex; overload;

    Function Count:Integer;

    property Image[Index:Integer]:TPicture read GetImage; default;
  end;

// Global variable containing a list of icons ( default "stock" icons for nodes )
// See TTreeNodeImageIndex enumeration type above.
Var TreeImagePool : TTreeImagePool;

type
  TLoadTreeProc=procedure(Reader:TReader; Stream:TStream) of object;

{ Load / Save a Tree from / to a *.trr file }
Procedure LoadTreeFromFile(Var ATree:TCustomTree; const FileName:String); overload;
Function LoadTreeFromFile(Var ATree:TCustomTree):String; overload;
Procedure LoadTreeFromFile( Var ATree:TCustomTree; const FileName:String;
                            AProc:TLoadTreeProc); overload;

// Load from Stream
Procedure LoadTreeFromStream(Var ATree:TCustomTree; const AStream:TStream); overload;
Procedure LoadTreeFromStream( Var ATree:TCustomTree; const AStream:TStream;
                              AProc:TLoadTreeProc); overload;

Procedure SaveTreeToFile(const Tree:TCustomTree; Const FileName:String);
Procedure SaveTreeToStream(const Tree:TCustomTree; const Stream:TStream);

implementation

// Images for TreeImagePool:
{$IFDEF ANDROID}
{.$R TreeBmp_Android.res}
{$ELSE}
{$IFDEF IOS}
{$R TreeBmp_iOS.res}
{$ELSE}
{$R TreeBmp.res}
{$ENDIF}
{$ENDIF}

uses
  {$IFNDEF FMX}
  TreeConst, TeePenDlg, CommCtrl, FlatSB,
  {$ENDIF}
  SysUtils, Math;

{$IFDEF FMX}
procedure TImageList.Change;
begin
end;

procedure TImageList.GetBitmap(Index:Integer; const Bitmap:TBitmap);
begin
end;

function TImageList.Count:Integer;
begin
  result:=0; // IList.Count
end;
{$ENDIF}

// speed optimization to avoid TeeCreatePenSmallDots
var GrayDotPen : {$IFDEF FMX}TTeePen{$ELSE}TPen{$ENDIF};

// Internal, with speed optimizations
// Returns True when R1 and R2 intersect (cross)
Function Intersect(Const R1,R2:TRect):Boolean;
Var tmp1 : TCoordinate;
    tmp2 : TCoordinate;
begin
  if R2.Left>R1.Left then tmp1:=R2.Left else tmp1:=R1.Left;
  if R2.Right<R1.Right then tmp2:=R2.Right else tmp2:=R1.Right;

  if tmp2<tmp1 then
     result:=False
  else
  begin
    if R2.Top>R1.Top then tmp1:=R2.Top else tmp1:=R1.Top;
    if R2.Bottom<R1.Bottom then tmp2:=R2.Bottom else tmp2:=R1.Bottom;

    result:=tmp2>=tmp1;
  end;
end;

Procedure SaveTreeToStream(const Tree:TCustomTree; const Stream:TStream);
Var OldVisible : Boolean;
begin
  OldVisible:=Tree.Visible;
  Tree.Visible:=True;
  try
    Stream.WriteComponent(Tree);
  finally
    Tree.Visible:=OldVisible;
  end;
end;

// Internal procedure to save a Tree to file.
Procedure InternalSaveTreeToStream(Tree:TCustomTree; Stream:TStream);
var Old : String;
begin
  Old:=Tree.Name;
  Tree.Name:='';
  try
    SaveTreeToStream(Tree,Stream);
  finally
    Tree.Name:=Old;
  end;
end;

// Save a Tree to a file in native format.
Procedure SaveTreeToFile(const Tree:TCustomTree; Const FileName:String);
var tmp : TFileStream;
begin
  tmp:=TFileStream.Create(ChangeFileExt(FileName,'.'+TreeMsg_TeeExtension),fmCreate);
  try
    InternalSaveTreeToStream(Tree,tmp);
  finally
    tmp.Free;
  end;
end;

// Internal. Used to load a Tree from a native file.

Var SavedTreeOwner :TComponent;

function TeeTreeFindGlobalComponent(const Name: string): TComponent;
begin
  if Name='' then
     result:=nil
  else
     result:=SavedTreeOwner
end;

type
  TInternalLoadTree=class(TCustomTree);

  TTreeReader=class(TReader)
  protected
    function Error(const Message: string): Boolean; override;
  end;

{$IFDEF FMX}
function TeeYesNo(const AMessage:String):Boolean;
{$IFDEF D24}
var DialogSvc: IFMXDialogServiceSync;
{$ENDIF}
begin
  {$IFDEF D24}
  if TPlatformServices.Current.SupportsPlatformService(IFMXDialogServiceSync, DialogSvc) then
     result:=DialogSvc.MessageDialogSync(AMessage,TMsgDlgType.mtConfirmation,mbYesNo,TMsgDlgBtn.mbYes,-1)=mrYes
  else
     result:=False;

  {$ELSE}
  result:=MessageDlg(AMessage, TMsgDlgType.mtConfirmation, mbYesNo, 0) = mrYes;
  {$ENDIF}
end;
{$ENDIF}

{ TTreeReader }

function TTreeReader.Error(const Message: string): Boolean;
begin
  result:=inherited Error(Message);

  if not result then
     result:=TeeYesNo(Message+#13+'Continue?');
end;

// Loads a Tree from a Stream in native format.
Procedure LoadTreeFromStream( Var ATree:TCustomTree; const AStream:TStream;
                              AProc:TLoadTreeProc); overload;
Var tmp       : TCustomTree;
    WasDesign : Boolean;
    tmpBounds : TRect;
    tmpAlign  : {$IFDEF FMX}TAlignLayout{$ELSE}TAlign{$ENDIF};
    Reader    : TTreeReader;
    tmpComp   : TComponent;
begin
  ATree.Clear;

  tmpBounds:=ATree.BoundsRect;
  tmpAlign:=ATree.Align;
  tmp:=ATree;

  try
    SavedTreeOwner:=ATree.Owner;

    RegisterFindGlobalComponentProc(TeeTreeFindGlobalComponent);

    try
      WasDesign:=csDesigning in ATree.ComponentState;
      if not WasDesign then
         ATree.SetDesignTime(True);

      try
        // Load Tree from Stream, with error checking.
        Reader:=TTreeReader.Create(AStream,4096);
        try
          tmpComp:=Reader.ReadRootComponent(ATree);
          if tmpComp is TCustomTree then
             ATree:=TCustomTree(tmpComp)
          else
             Raise Exception.Create('Internal Error reading Tree.');

          if Assigned(AProc) then
             AProc(Reader,AStream);
        finally
          Reader.Free;
        end;

      finally
        ATree.SetDesignTime(WasDesign);
      end;

    finally
      UnRegisterFindGlobalComponentProc(TeeTreeFindGlobalComponent);
    end;
  finally
    ATree:=tmp;
  end;

  ATree.Align:=tmpAlign;
  ATree.BoundsRect:=tmpBounds;
end;

// Loads a Tree from Stream in native format.
Procedure LoadTreeFromStream(Var ATree:TCustomTree; const AStream:TStream); overload;
var P : TLoadTreeProc;
begin
  P:=nil;
  LoadTreeFromStream(ATree,AStream,P);
end;

// Loads a Tree from a File in native format.
Procedure LoadTreeFromFile( Var ATree:TCustomTree; const FileName:String;
                            AProc:TLoadTreeProc); overload;
var FileStream : TFileStream;
    tmp        : String;
begin
  tmp:=FileName;

  // Load Tree from file, with error checking.
  if ExtractFileExt(tmp)='' then
     tmp:=tmp+'.'+TreeMsg_TeeExtension;

  FileStream:=TFileStream.Create(tmp,fmOpenRead or fmShareDenyWrite);
  try
    LoadTreeFromStream(ATree,FileStream,AProc);
    ATree.Invalidate;
  finally
    FileStream.Free;
  end;
end;

// Loads a Tree from a File in native format.
Procedure LoadTreeFromFile(Var ATree:TCustomTree; const FileName:String); overload;
var P : TLoadTreeProc;
begin
  P:=nil;
  LoadTreeFromFile(ATree,FileName,P);
end;

// Show an Open File Dialog and then Load a Tree from File.
Function LoadTreeFromFile(Var ATree:TCustomTree):String; overload;
begin
  result:='';

  With TOpenDialog.Create(nil) do
  try
    DefaultExt:=TreeMsg_TeeExtension;
    FileName:='';
    Filter:=TeeMsg_TreeFiles;
    FilterIndex:=2;
    if Execute then
    begin
      result:=FileName;
      LoadTreeFromFile(ATree,FileName);
    end;
  finally
    Free;
  end;
end;

{ TCustomTreeElement }

Destructor TCustomTreeElement.Destroy;
begin
  FText.Free;
  FFont.Free;
  inherited;
end;

// Optimization: Create Text TStrings object "on demand"
Function TCustomTreeElement.GetText:TTreeStrings;
begin
  if not Assigned(FText) then
  begin
    FText:=TTreeStrings.Create;
    FText.IOwner:=Self;

    if FTextString<>'' then
    begin
      FText.Add(FTextString);
      FTextString:='';
    end;

    TStringList(FText).OnChange:=CanvasChanged; // to notify changes of Text
  end;

  result:=FText;
end;

Function TCustomTreeElement.GetFont:TTeeFont;  // on-demand Font
begin
  if not Assigned(FFont) then
  begin
    FFont:=TTeeFont.Create(CanvasChanged);

    if Assigned(Tree) then
       FFont.Assign(Tree.GlobalFormat.Font);
  end;

  result:=FFont;
end;

Procedure TCustomTreeElement.Assign(Source:TPersistent);
begin
  if Source is TCustomTreeElement then
  With TCustomTreeElement(Source) do
  begin
    Self.FCursor:=FCursor;
    Self.FData:=FData;
    Self.Font:=FFont;
    Self.FTextString:=FTextString; // warning: before Text:=FText;
    Self.Text:=FText;
  end
  else
    inherited;
end;

// VCL Requeriment for DFM streaming
function TCustomTreeElement.GetParentComponent: TComponent;
begin
  result:=FTree;
end;

procedure TCustomTreeElement.SetText(const Value : TTreeStrings);
begin
  if Assigned(Value) then
  begin
    Text.Assign(Value);  { it will automatically call CanvasChanged }
  end
  else
  begin
    FreeAndNil(FText);
    CanvasChanged(Self); { to call derived method }
  end;
end;

{$IFNDEF FMX}
// Makes sure that Bottom is bigger or equal than Top and
// that Right is bigger or equal than Left.
procedure OrientRectangle(Var R:TRect);
var tmp : TCoordinate;
begin
  with R do
  begin
    if Top>Bottom then
    begin
      tmp:=Top;
      Top:=Bottom;
      Bottom:=tmp;
    end;

    if Left>Right then
    begin
      tmp:=Left;
      Left:=Right;
      Right:=tmp;
    end;
  end;
end;
{$ENDIF}

// VCL requirement for subcomponent streaming
Function TCustomTreeElement.GetOwner:TPersistent;
begin
  if csWriting in ComponentState then
     result:=Self
  else
     result:=inherited GetOwner;
end;

// Optimization: return global or local Font object
Function TCustomTreeElement.InternalFont:TTeeFont;
begin
  if Assigned(FFont) then
     result:=FFont  // local
  else
  if Assigned(Tree) then
     result:=Tree.GlobalFormat.Font  // global
  else
     result:=Font; // local on-demand
end;

// Optimization. Returns the number of lines in Text array.
Function TCustomTreeElement.TextLinesCount:Integer;
begin
  if Assigned(FText) then
     result:=FText.Count
  else
  if FTextString<>'' then
     result:=1
  else
     result:=0;
end;

// VCL requeriment for subcomponent streaming
procedure TCustomTreeElement.SetParentComponent(AParent: TComponent);
begin
  if not (csLoading in ComponentState) then
     if AParent is TCustomTree then
        FTree:=TCustomTree(AParent);
end;

// VCL requeriment for subcomponent streaming
function TCustomTreeElement.HasParent: Boolean;
begin
  result:=True;
end;

procedure TCustomTreeElement.SetFont(const Value: TTeeFont);
begin
  if Assigned(Value) then Font.Assign(Value)
                     else FreeAndNil(FFont); // destroy local font.
end;

procedure TCustomTreeElement.SetHorizTextAlign(Value: THorizTextAlign);
begin
  if HorizTextAlign<>Value then
     Text.HorizAlign:=Value;
end;

procedure TCustomTreeElement.SetVertTextAlign(Value: TVertTextAlign);
begin
  if VertTextAlign<>Value then
     Text.VertAlign:=Value;
end;

// VCL requeriment for subcomponent streaming
procedure TCustomTreeElement.ReadState(Reader: TReader);
begin
  inherited;

  if Reader.Parent is TCustomTree then
     Tree:=TCustomTree(Reader.Parent);
end;

Procedure TCustomTreeElement.SetColorProperty(Var Variable:TColor; Const Value:TColor);
Begin
  if Variable<>Value then
  begin
    Variable:=Value;
    CanvasChanged(Self);
  end;
end;

Procedure TCustomTreeElement.SetBooleanProperty(Var Variable:Boolean; Const Value:Boolean);
Begin
  if Variable<>Value then
  begin
    Variable:=Value;
    CanvasChanged(Self);
  end;
end;

Procedure TCustomTreeElement.SetDoubleProperty(Var Variable:Double; Const Value:Double);
Begin
  if Variable<>Value then
  begin
    Variable:=Value;
    CanvasChanged(Self);
  end;
end;

Procedure TCustomTreeElement.SetIntegerProperty(Var Variable:Integer; Const Value:Integer);
Begin
  if Variable<>Value then
  begin
    Variable:=Value;
    CanvasChanged(Self);
  end;
end;

procedure TCustomTreeElement.Repaint;
begin
  if Assigned(Tree) then
     Tree.Invalidate;
end;

procedure TCustomTreeElement.CanvasChanged(Sender:TObject);
Begin
  if Assigned(Tree) then
     Tree.Invalidate;
end;

procedure TCustomTreeElement.SetCursor(Value:TCursor);
begin
  FCursor:=Value;
end;

Procedure TCustomTreeElement.SetTree(const Value:TCustomTree);
begin
  FTree:=Value;
end;

// Optimized. Returns first text string.
function TCustomTreeElement.GetSimpleText: String;
begin
  if Assigned(FText) and (FText.Count>0) then
     result:=FText[0]
  else
     result:=FTextString;
end;

procedure TCustomTreeElement.SetSimpleText(const Value: String);
begin
  if SimpleText<>Value then
  begin
    if Assigned(FText) then
    begin
      if FText.Count>0 then FText[0]:=Value
                       else FText.Add(Value);
    end
    else
      FTextString:=Value;

    CanvasChanged(Self);
  end;
end;

function TCustomTreeElement.IsFontStored: Boolean;
begin
  result:=Assigned(FFont);
end;

// compatibility with v1. See Text.HorizAlign property.
function TCustomTreeElement.GetHorizTextAlign: THorizTextAlign;
begin
  if Assigned(FText) then result:=FText.HorizAlign
                     else result:=htaCenter;
end;

// compatibility with v1. See Text.HorizAlign property.
function TCustomTreeElement.GetVertTextAlign: TVertTextAlign;
begin
  if Assigned(FText) then result:=FText.VertAlign
                     else result:=vtaCenter;
end;

// compatibility with v1. See Text.HorizAlign property.
procedure TCustomTreeElement.ReadHorizAlign(Reader: TReader);
var tmp : String;
begin
  tmp:=Reader.ReadIdent;

  if tmp='htaRight' then Text.HorizAlign:=htaRight else
  if tmp='htaLeft' then  Text.HorizAlign:=htaLeft else
                         Text.HorizAlign:=htaCenter;
end;

// compatibility with v1. See Text.HorizAlign property.
procedure TCustomTreeElement.ReadVertAlign(Reader: TReader);
var tmp : String;
begin
  tmp:=Reader.ReadIdent;

  if tmp='vtaTop' then    Text.VertAlign:=vtaTop else
  if tmp='vtaBottom' then Text.VertAlign:=vtaBottom else
                          Text.VertAlign:=vtaCenter;
end;

// compatibility with v1. See Text.HorizAlign and VertAlign properties.
procedure TCustomTreeElement.DefineProperties(Filer: TFiler);
begin
  inherited;

  Filer.DefineProperty('HorizTextAlign',ReadHorizAlign,nil,False);
  Filer.DefineProperty('VertTextAlign',ReadVertAlign,nil,False);
end;

procedure TCustomTreeElement.InternalDrawHandles;
begin
  if Tree.AllowResize and (not (csLoading in ComponentState)) then
  begin
    Tree.PrepareDrawHandles;
    DrawHandles;
    Tree.EndDrawHandles;
  end;
end;

procedure TCustomTreeElement.DrawHandles;
begin
end;

{ TTreeShapeAutoPosition }
Procedure TTreeShapeAutoPosition.Assign(Source:TPersistent);
begin
  if Source is TTreeShapeAutoPosition then
  With TTreeShapeAutoPosition(Source) do
  begin
    Self.FNoLeft := FNoLeft;
    Self.FNoTop  := FNoTop;
  end
  else
  if Assigned(Source) then
     inherited;
end;

Function TTreeShapeAutoPosition.GetLeft:Boolean;
begin
  result:=not FNoLeft;
end;

Function TTreeShapeAutoPosition.GetTop:Boolean;
begin
  result:=not FNoTop;
end;

Procedure TTreeShapeAutoPosition.SetLeft(Value:Boolean);
begin
  if Value=FNoLeft then
  begin
    FNoLeft:=not Value;
    IOnChange(Self);
  end;
end;

Procedure TTreeShapeAutoPosition.SetTop(Value:Boolean);
begin
  if Value=FNoTop then
  begin
    FNoTop:=not Value;
    IOnChange(Self);
  end;
end;

{ TCustomTreeShape }

Constructor TTreeNodeShape.Create(AOwner : TComponent);
Begin
  inherited;
  FAutoSize:=True;

  FVisible:=True;
  FGradientClip:=True;

  FRoundSize:=3;

  FBrotherIndex:=-1;

  FChildren:=TTreeChildrenList.Create;

  // Default (initial) list capacity
  if TreeShapeListCapacity>0 then
     FChildren.Capacity:=TreeShapeListCapacity;

  FImageIndex :=tiFolderOpenClose;
  FImageListIndex:=-1;

  // RecalcImageSize;  optimized:
  IImageHeight:=TreeDefaultImageHeight;
  IImageWidth:=TreeDefaultImageWidth;
end;

Destructor TTreeNodeShape.Destroy;
var t : Integer;
begin
  // remove from global Tree list of shapes
  if Assigned(Tree) and (not Tree.IClearing) then Tree.RemoveShape(Self);

  // Optimization: When Tree.IClearing is True (Tree1.Clear) dont do this:
  if (not Assigned(Tree)) or (not Tree.IClearing) then
  begin
    // destroy all children and connections to chil nodes...
    Clear;

    // tell parents to destroy all connections to us
    if Assigned(FParents) then
    begin
      for t:=0 to FParents.Count-1 do
        if Assigned(FParents[t].FConnections) then
           FParents[t].FConnections.DeleteAllTo(Self);
    end
    else
    if Assigned(IParents0) then
        if Assigned(IParents0.FConnections) then
           IParents0.FConnections.DeleteAllTo(Self);

    // if we have a parent, tell it to remove child (self)
    if Assigned(Parent) then Parent.RemoveChild(Self);
  end;

  FConnections.Free;
  FChildren.Free;
  FParents.Free;

  if Assigned(Tree) then Tree.Invalidate;

  FShadow.Free;
  FAutoPosition.Free;
  FBrush.Free;
  FBorder.Free;
  FGradient.Free;
  FImage.Free;
  inherited;
end;

procedure TTreeNodeShape.Clear;
begin
  // destroy all children
  while Children.Count>0 do
     Children[0].{$IFDEF AUTOREFCOUNT}DisposeOf{$ELSE}Free{$ENDIF};

  // destroy all connections to children
  if Assigned(FConnections) then
  while FConnections.Count>0 do
     FConnections[0].{$IFDEF AUTOREFCOUNT}DisposeOf{$ELSE}Free{$ENDIF};
end;

procedure TTreeNodeShape.CanvasChanged(Sender:TObject);
Begin
  if AutoSize then IAutoSized:=False;
  inherited;
End;

procedure TTreeNodeShape.Collapse(Recursive: Boolean);
var t : Integer;
begin
  Expanded:=False;
  if Recursive then
     for t:=0 to Children.Count-1 do Children[t].Collapse(True);
end;

// Returns number of children nodes
function TTreeNodeShape.Count: Integer;
begin
  result:=Children.Count;
end;

// Deprecated (typo!)
procedure TTreeNodeShape.Toogle;
begin
  Toggle;
end;

// Expands or Collapses the node
procedure TTreeNodeShape.Toggle;
begin
  Expanded:=not Expanded;
end;

// Checks or UnChecks the node (when the node image has a checkbox)
procedure TTreeNodeShape.ToggleCheck;
begin
  Checked:=not Checked;
end;

procedure TTreeNodeShape.SetChecked(Value:Boolean);
begin
  if Checked<>Value then
  begin
     if Checked then
      case ImageIndex of
        tiFolderCloseChecked  : ImageIndex:=tiFolderCloseUnChecked;
        tiChecked             : ImageIndex:=tiUnChecked;
        tiRadioChecked        : ImageIndex:=tiRadioUnChecked;
        tiFolderRadioChecked  : ImageIndex:=tiFolderRadioUnChecked;
      end
      else
      case ImageIndex of
        tiFolderCloseUnChecked: ImageIndex:=tiFolderCloseChecked;
        tiUnChecked           : ImageIndex:=tiChecked;
        tiRadioUnChecked      : ImageIndex:=tiRadioChecked;
        tiFolderRadioUnChecked: ImageIndex:=tiFolderRadioChecked;
      end;

     if Assigned(FTree) and Assigned(FTree.FOnCheckedShape) then
        FTree.FOnCheckedShape(Self);
  end;
end;

// Returns True when the ImageIndex is a checked checkbox or radio
function TTreeNodeShape.GetChecked: Boolean;
begin
  result:=FImageListIndex=-1;

  if result then
     result:= (FImageIndex=tiFolderCloseChecked) or
              (FImageIndex=tiChecked) or
              (FImageIndex=tiRadioChecked) or
              (FImageIndex=tiFolderRadioChecked);
end;

// Returns True when the node image has a checkbox
function TTreeNodeShape.HasCheckBox:Boolean;
begin
  result:=False;

  if FImageListIndex=-1 then
  case FImageIndex of
      tiFolderCloseChecked,
      tiFolderCloseUnChecked,
      tiChecked,
      tiUnChecked,
      tiRadioChecked,
      tiRadioUnChecked,
      tiFolderRadioChecked,
      tiFolderRadioUnChecked: result:=True;
  end;
end;

Function TTreeNodeShape.GetBackColor:TColor;
begin
  result:=Brush.BackColor;
end;

Function TTreeNodeShape.GetAutoPosition:TTreeShapeAutoPosition;  // on-demand
begin
  if not Assigned(FAutoPosition) then
  begin
     FAutoPosition:=TTreeShapeAutoPosition.Create;
     FAutoPosition.IOnChange:=PositionChanged;
  end;

  result:=FAutoPosition;
end;

Function TTreeNodeShape.GetShadow:TTeeShadow; // on-demand shadow
begin
  if not Assigned(FShadow) then
     FShadow:=TTeeShadow.Create(CanvasChanged);

  result:=FShadow;
end;

{$IFNDEF D7}
function TTreeNodeShape.GetParent:TTreeNodeShape;
begin
  result:=FParent;
end;

Function TTreeNodeShape.GetExpanded:Boolean;
begin
  result:=FExpanded;
end;

function TTreeNodeShape.GetX0:Integer;
begin
  result:=FX0;
end;

function TTreeNodeShape.GetY0:Integer;
begin
  result:=FY0;
end;

Function TTreeNodeShape.GetSelected:Boolean;
begin
  result:=FSelected;
end;

Function TTreeNodeShape.GetAdjustedRectangle:TRect;
begin
  result:=FAdjustedRect;
end;

Function TTreeNodeShape.GetAutoSize:Boolean;
begin
  result:=FAutoSize;
end;

Function TTreeNodeShape.GetBrotherIndex:Integer;
begin
  result:=FBrotherIndex;
end;

Function TTreeNodeShape.GetShowCross:TTreeNodeShapeShowCross;
begin
  result:=FShowCross;
end;

Function TTreeNodeShape.GetStyle:TTreeShapeStyle;
begin
  result:=FStyle;
end;

Function TTreeNodeShape.GetTransparency:TTeeTransparency;
begin
  result:=FTransparency;
end;

Function TTreeNodeShape.GetTransparent:Boolean;
begin
  result:=FTransparent;
end;

Function TTreeNodeShape.GetVisible:Boolean;
begin
  result:=FVisible;
end;

Function TTreeNodeShape.GetGradientClip:Boolean;
begin
  result:=FGradientClip;
end;

Function TTreeNodeShape.GetImageAlignment:TTreeImageAlignment;
begin
  result:=FImageAlignment;
end;

Function TTreeNodeShape.GetImageHeight:Integer;
begin
  result:=FImageHeight;
end;

Function TTreeNodeShape.GetImageIndex:TTreeNodeImageIndex;
begin
  result:=FImageIndex;
end;

Function TTreeNodeShape.GetImageWidth:Integer;
begin
  result:=FImageWidth;
end;

Function TTreeNodeShape.GetImageListIndex:Integer;
begin
  result:=FImageListIndex;
end;

Function TTreeNodeShape.GetImageRect:TRect;
begin
  result:=FImageRect;
end;
{$ENDIF}

Function TTreeNodeShape.GetBorder:TTreePen; // on-demand border
begin
  if not Assigned(FBorder) then
  begin
    FBorder:=TTreePen.Create(CanvasChanged);

    if Assigned(Tree) then
       FBorder.Assign(Tree.GlobalFormat.Border);
  end;

  result:=FBorder;
end;

// Convert R rectangle to 3D position using ACanvas
Function TTreeNodeShape.RectTo3DCanvas(const ACanvas:TCanvas3D; Const R:TRect):TRect;
begin
  result.TopLeft    :=ACanvas.Calculate3DPosition(R.Left,R.Top,TeeTreeZ);
  result.BottomRight:=ACanvas.Calculate3DPosition(R.Right,R.Bottom,TeeTreeZ);
end;

function TTreeNodeShape.IsImageIndexStored: Boolean;
begin
  result:=(FImageIndex<>tiFolderOpenClose) and
          (FImageIndex>=Low(TTreeNodeImageIndex)) and
          (FImageIndex<=High(TTreeNodeImageIndex));
end;

procedure TTreeNodeShape.SetBorder(const Value : TTreePen);
begin
  if Assigned(Value) then Border.Assign(Value)
                     else FreeAndNil(FBorder);
end;

procedure TTreeNodeShape.DoMove(DeltaX, DeltaY: Integer; AltShift: Boolean);
begin
  { Call event before. DeltaX and DeltaY can be modified in this event. }
  if Assigned(FTree.FOnMovingShape) then
     FTree.FOnMovingShape(Self,DeltaX,DeltaY);

  if (DeltaX<>0) or (DeltaY<>0) then { if we should move the node... }
  begin
    if DeltaX<>0 then AutoPosition.FNoLeft:=True;
    if DeltaY<>0 then AutoPosition.FNoTop:=True;

    MoveRelative(DeltaX,DeltaY,AltShift);
  end;
end;

procedure TTreeNodeShape.PositionChanged(Sender:TObject);
begin
  CanvasChanged(Sender);
end;

procedure TTreeNodeShape.SetLeft(const Value: Integer);
begin
  X0:=Value;
end;

procedure TTreeNodeShape.SetTop(const Value: Integer);
begin
  Y0:=Value;
end;

function TTreeNodeShape.IsBorderStored: Boolean;
begin
  result:=Assigned(FBorder);
end;

function TTreeNodeShape.IsBrushStored: Boolean;
begin
  result:=Assigned(FBrush);
end;

function TTreeNodeShape.IsGradientStored: Boolean;
begin
  result:=Assigned(FGradient);
end;

function TTreeNodeShape.IsShadowStored: Boolean;
begin
  result:=Assigned(FShadow);
end;

procedure TTreeNodeShape.SetBrush(const Value : TTreeShapeBrush);
begin
  if Assigned(Value) then Brush.Assign(Value)
                     else FreeAndNil(FBrush);
end;

procedure TTreeNodeShape.SetX0(Value:Integer);
begin
  if FX0<>Value then
  begin
    FX1:=Value+(FX1-FX0);
    FX0:=Value;
    CanvasChanged(Self);  // Repaint; ?
  end;

  AutoPosition.FNoLeft:=True;
end;

Procedure TTreeNodeShape.SetY0(Value:Integer);
Begin
  if FY0<>Value then
  begin
    FY1:=Value+(FY1-FY0);
    FY0:=Value;
    CanvasChanged(Self); // Repaint; ?
  end;

  AutoPosition.FNoTop:=True;
End;

Procedure TTreeNodeShape.SetX1(Value:Integer);
begin
  if FX1<>Value then
  begin
    AutoSize:=False;
    FX1:=Value;
    CanvasChanged(Self);
  end;
end;

Procedure TTreeNodeShape.SetY1(Value:Integer);
Begin
  if FY1<>Value then
  begin
    AutoSize:=False;
    FY1:=Value;
    CanvasChanged(Self);
  end;
End;

procedure TTreeNodeShape.SetStyle(const Value:TTreeShapeStyle);
Begin
  if Value<>FStyle then
  begin
    FStyle:=Value;
    CanvasChanged(Self);
  end;
End;

Function TTreeNodeShape.IsSizeStored:Boolean;
begin
  result:=not AutoSize;
end;

// Returns true if the node should be displayed.
// Iterates through a whole leaf, so its time consuming.
function TTreeNodeShape.IsVisible: Boolean;
var tmpParent : TTreeNodeShape;
begin
  result:=Visible;
  tmpParent:=Parent;

  while Assigned(tmpParent) and result do
  begin
    result:=tmpParent.Visible and tmpParent.Expanded;
    tmpParent:=tmpParent.Parent;
  end;
end;

// When node Style is "Round rectangle", return points in P array
Function TTreeNodeShape.GetRoundRectanglePoints( R:TRect;
                                                 Var P:TShapePoints):Integer;
begin
  result:=16;

  With R do
  begin
    P[0].X:=Left;
    P[0].Y:=Bottom-RoundSize;
    P[1].X:=Left;
    P[1].Y:=Top+RoundSize;

    P[2].X:=P[1].X+1;
    P[2].Y:=P[1].Y-1;
    P[3].X:=P[2].X+1;
    P[3].Y:=P[2].Y-1;

    P[4].Y:=Top;
    P[4].X:=Left+RoundSize;
    P[5].Y:=Top;
    P[5].X:=Right-RoundSize;

    P[6].X:=P[5].X+1;
    P[6].Y:=P[5].Y+1;
    P[7].X:=P[6].X+1;
    P[7].Y:=P[6].Y+1;

    P[8].X:=Right;
    P[8].Y:=P[1].Y;
    P[9].X:=Right;
    P[9].Y:=P[0].Y;

    P[10].X:=P[9].X-1;
    P[10].Y:=P[9].Y+1;
    P[11].X:=P[10].X-1;
    P[11].Y:=P[10].Y+1;

    P[12].Y:=Bottom;
    P[12].X:=P[5].X;
    P[13].Y:=Bottom;
    P[13].X:=P[4].X;

    P[14].X:=P[13].X-1;
    P[14].Y:=P[13].Y-1;
    P[15].X:=P[14].X-1;
    P[15].Y:=P[14].Y-1;
  end;
end;

// Return coordinates in P array for "triangle" style
Procedure TTreeNodeShape.GetTrianglePoints( Const R:TRect;
                                            const MidX,MidY:TCoordinate;
                                            Var P:TShapePoints);
begin
  Case FStyle of
    tssTriangleTop: begin
                      P[0].X:=R.Left;   P[0].Y:=R.Bottom;
                      P[1].X:=MidX;     P[1].Y:=R.Top;
                      P[2]:=R.BottomRight;
                    end;
 tssTriangleBottom: begin
                      P[0]:=R.TopLeft;
                      P[1].X:=MidX;     P[1].Y:=R.Bottom;
                      P[2].X:=R.Right;  P[2].Y:=R.Top;
                    end;
   tssTriangleLeft: begin
                      P[0].X:=R.Left;   P[0].Y:=MidY;
                      P[1].X:=R.Right;  P[1].Y:=R.Top;
                      P[2]:=R.BottomRight;
                    end;
  tssTriangleRight: begin
                      P[0]:=R.TopLeft;
                      P[1].X:=R.Right;  P[1].Y:=MidY;
                      P[2].X:=R.Left;   P[2].Y:=R.Bottom;
                    end;
  end;
end;

// Display node text and return text dimensions in R rectangle
procedure TTreeNodeShape.DrawText(const ACanvas:TCanvas3D; Var R:TRect);
var
  tmpCount : Integer;

  function MaxTextWidth:Integer;
  var t : Integer;
  begin
    if Assigned(FText) then
    begin
      result:=0;

      for t:=0 to tmpCount-1 do
          result:=Max(result,ACanvas.TextWidth(FText[t]));
    end
    else
      result:=ACanvas.TextWidth(FTextString);
  end;

  function ZoomWidth(const S:String):Single;
  begin
    result:=100*ACanvas.TextWidth(S)/Tree.View3DOptions.ZoomFloat;
  end;

Const TextHorizMargin=1;
var t        : Integer;
    tmpH     : Single;
    tmpMidX  : TCoordinate;
    tmpMidY  : TCoordinate;
    tmpPosX  : TCoordinate;
    tmpPosY  : TCoordinate;
    tmpWidth : Single;
    tmpHeight: TCoordinate;
    tmpPosX0 : Integer;
    tmpPosY0 : Integer;
    tmpX     : Integer;
    tmpS     : String;
    tmpPen   : TCoordinate;

    S,C      : Extended;
    tmpOffX  : Integer;
    tmpOffY  : Integer;
    tmpAngle : Integer;
    tmpBlend : TTeeBlend;
    tmpR     : TRect;
    tmpW     : TCoordinate;
    isVisible: Boolean;
begin
  tmpCount:=TextLinesCount;
  isVisible:=(not Assigned(FText)) or FText.Visible;

  if (tmpCount>0) and isVisible then
  begin
    {$IFDEF FMX}
    R.NormalizeRect;
    {$ELSE}
    OrientRectangle(R);
    {$ENDIF}

    // Text clipping (prevent display text outside node rectangle
    if InternalClipText then
       ACanvas.ClipRectangle(RectTo3DCanvas(ACanvas,R));

    SetCanvasFont(ACanvas);  // prepare font

    tmpH:=Round(100*ACanvas.TextHeight(TeeCharForHeight)/Tree.View3DOptions.ZoomFloat); // Height in pixels

    if ACanvas.SupportsAlpha then
       tmpPosY:=0
    else
    begin
      // Vertical text alignment
      Case VertTextAlign of
        vtaCenter: tmpPosY:=((R.Top+R.Bottom) {$IFDEF FMX}*0.5{$ELSE}div 2{$ENDIF})-
                             Round((tmpH*tmpCount)*0.5);
        vtaTop:    tmpPosY:=R.Top;
      else
      {vtaBottom:} tmpPosY:=R.Bottom-Round(tmpH*tmpCount);
      end;
    end;

    ACanvas.BackMode:=cbmTransparent;
    ACanvas.TextAlign:=TA_LEFT;

    if InternalPen.Visible then tmpPen:=ACanvas.Pen.Width {$IFDEF FMX}*0.5{$ELSE}div 2{$ENDIF}
                           else tmpPen:=0;

    tmpMidX:=(R.Right+R.Left) {$IFDEF FMX}*0.5{$ELSE}div 2{$ENDIF};

    // Text position offsets
    if Assigned(FText) then
    begin
      tmpOffX:=FText.FHorizOffset;
      tmpOffY:=FText.FVertOffset;
    end
    else
    begin
      tmpOffX:=0;
      tmpOffY:=0;
    end;

    // Text Transparency ?
    if Assigned(FText) and (FText.Transparency>0) then
    begin
      if ACanvas.SupportsAlpha then
         tmpBlend:=ACanvas.BeginBlending(TeeZeroRect,FText.Transparency)
      else
      begin
        tmpR.Top:=tmpPosY+tmpOffY;
        tmpR.Bottom:=tmpR.Top+Round(tmpCount*tmpH);
        tmpR.Left:=R.Left+tmpOffX;

        tmpW:=MaxTextWidth;

        Case HorizTextAlign of
          htaCenter : tmpR.Left:=tmpMidX-(tmpW {$IFDEF FMX}*0.5{$ELSE}div 2{$ENDIF});
          htaLeft   : tmpR.Left:=R.Left+tmpPen+TeeTextHorizMargin;
        else
          {htaRight:} tmpR.Left:=R.Right-tmpPen-tmpW-TeeTextHorizMargin;
        end;

        tmpR.Right:=tmpR.Left+tmpW;

        tmpBlend:=TTeeBlend.Create(ACanvas,tmpR);
      end;
    end
    else
      tmpBlend:=nil;

    tmpMidY:=(R.Top+R.Bottom) {$IFDEF FMX}*0.5{$ELSE}div 2{$ENDIF};
    tmpHeight := (R.Bottom-R.Top);

    tmpWidth:=Round(100*MaxTextWidth/Tree.View3DOptions.ZoomFloat);

    tmpAngle:=InternalTextAngle;

    tmpW:=(R.Right-R.Left);

    if tmpAngle<>0 then
       SinCos(-tmpAngle*TeePiStep,S,C);

    // For each line of text...
    for t:=0 to tmpCount-1 do
    begin
      if Assigned(FText) then tmpS:=FText[t]
                         else tmpS:=FTextString;

      // Draw text line

      // Horizontal text alignment
      Case HorizTextAlign of
        htaCenter : tmpX:=-{$IFDEF FMX}Round{$ENDIF}(tmpW {$IFDEF FMX}*0.5{$ELSE}div 2{$ENDIF});
        htaLeft   : tmpX:=-Round(tmpWidth*0.5);
      else
        {htaRight:} tmpX:=Round( (tmpWidth*0.5) - tmpW );
      end;

      // Rotation

      if tmpAngle<>0 then
      begin
        tmpPosX0 := Round((tmpX)*C - (-(tmpHeight * 0.5) + tmpH*t)*S);
        tmpPosY0 := Round((tmpX)*S + (-(tmpHeight * 0.5) + tmpH*t)*C);
      end
      else
      begin
        tmpPosX0:=0;
        tmpPosY0:=0;
      end;

      // Horizontal translation

      Case HorizTextAlign of
        htaCenter : tmpPosX:=tmpMidX - Round(ZoomWidth(tmpS)*0.5);
        htaLeft   : tmpPosX:=R.Left+ tmpPen+TeeTextHorizMargin+tmpPosX0;
      else
        {htaRight:} tmpPosX:=R.Right-tmpPen-TeeTextHorizMargin+tmpPosX0-Round(ZoomWidth(tmpS));
      end;

      // Vertical translation

      Case VertTextAlign of
        vtaCenter: tmpPosY:=tmpMidY + Round( (t*tmpH) - ((tmpCount div 2)*tmpH) - (tmpCount mod 2)*(tmpH*0.5) );
        vtaTop:    tmpPosY:=R.Top + tmpPen + (TeeTextVertMargin div 2) + Round(tmpH*t) + tmpPosY0;
      else
      {vtaBottom:} tmpPosY:=R.Bottom - tmpPen - (TeeTextVertMargin div 2) - Round( (tmpH*tmpCount) - ((t)*tmpH));
      end;

      ACanvas.RotateLabel3D({$IFDEF FMX}Round{$ENDIF}(tmpPosX+tmpOffX),
                            {$IFDEF FMX}Round{$ENDIF}(tmpPosY+tmpOffY),
                            TeeTreeZ,tmpS,tmpAngle,
                            False);
    end;

    // Finish transparency
    if Assigned(tmpBlend) then
    begin
      tmpBlend.DoBlend(FText.Transparency);
      tmpBlend.Free;
    end
    else
    if Assigned(FText) and (FText.Transparency>0) then
       if ACanvas.SupportsAlpha then
          ACanvas.EndBlending(tmpBlend);

    // Un-clip
    if InternalClipText then
       ACanvas.UnClipRectangle;
  end;
end;

procedure TTreeNodeShape.DrawShape(Const R:TRect);
begin
  DrawShapeCanvas(Tree.Canvas,R);
end;

// Just draw shape to ACanvas. Dont change Pen, Brush, etc
Procedure TTreeNodeShape.InternalDrawShape( tmpR:TRect; const ACanvas:TCanvas3D;
                                            tmpStyle:TTreeShapeStyle);
var tmpR2   : TRect;
    tmpMidX : TCoordinate;
    tmpMidY : TCoordinate;
    P       : TShapePoints;
    Num     : Integer;
begin
  With ACanvas do
  Case tmpStyle of
    tssRectangle : RectangleWithZ(tmpR,TeeTreeZ);
    tssCircle    : EllipseWithZ(tmpR.Left,tmpR.Top,tmpR.Right,tmpR.Bottom,TeeTreeZ);
    tssLine      : begin
                     MoveTo3D(tmpR.Left,tmpR.Top,TeeTreeZ);
                     LineTo3D(tmpR.Right,tmpR.Bottom,TeeTreeZ);
                   end;
   tssInvertLine : begin
                     MoveTo3D(tmpR.Left,tmpR.Bottom,TeeTreeZ);
                     LineTo3D(tmpR.Right,tmpR.Top,TeeTreeZ);
                   end;
tssRoundRectangle: begin
                     tmpR:=CalcRect3D(tmpR,TeeTreeZ);
                     RoundRect(tmpR,RoundSize,RoundSize);
                   end;
       tssCustom : begin
                     if Self is TPolygonShape then
                        TPolygonShape(Self).InternalDraw(ACanvas,0,0)
                     else
                     begin
                       Num:=GetShapePoints(tmpR,P);
                       if Num>0 then PolygonWithZ(Slice(P,Num),TeeTreeZ);
                     end;
                   end;
      tssChamfer : begin
                     Num:=GetRoundRectanglePoints(tmpR,P);
                     PolygonWithZ(Slice(P,Num),TeeTreeZ);
                   end;
  else
  begin
    tmpMidX:=(tmpR.Left+tmpR.Right) {$IFDEF FMX}*0.5{$ELSE}div 2{$ENDIF};
    tmpMidY:=(tmpR.Top+tmpR.Bottom) {$IFDEF FMX}*0.5{$ELSE}div 2{$ENDIF};

    case tmpStyle of
      tssVertLine : VertLine3D(tmpMidX,tmpR.Top,tmpR.Bottom,TeeTreeZ);
      tssHorizLine: HorizLine3D(tmpR.Left,tmpR.Right,tmpMidY,TeeTreeZ);
      tssDiamond  : PlaneWithZ( TeePoint(tmpR.Left,tmpMidY),
                                TeePoint(tmpMidX,tmpR.Top),
                                TeePoint(tmpR.Right,tmpMidY),
                                TeePoint(tmpMidX,tmpR.Bottom),TeeTreeZ);
    else { triangle shapes }
      begin
        tmpR2:=tmpR;

        {$IFDEF FMX}
        tmpR2.NormalizeRect;
        {$ELSE}
        OrientRectangle(tmpR2);
        {$ENDIF}

        GetTrianglePoints(tmpR2,tmpMidX,tmpMidY,P);
        TriangleWithZ(P[0],P[1],P[2],TeeTreeZ);
      end;
    end;
  end;
  end;
end;

procedure TTreeNodeShape.InternalDrawShadow( tmpR:TRect; const ACanvas:TCanvas3D;
                                             const tmpStyle:TTreeShapeStyle);
var t,
    Num : Integer;
    P   : TShapePoints;
begin
  if Shadow.Smooth then
    case tmpStyle of
      tssCircle    : FShadow.DrawEllipse(ACanvas,ACanvas.CalcRect3D(tmpR,TeeTreeZ));
      tssRectangle : FShadow.Draw(ACanvas,ACanvas.CalcRect3D(tmpR,TeeTreeZ));
      tssRoundRectangle : FShadow.Draw(ACanvas,ACanvas.CalcRect3D(tmpR,TeeTreeZ),RoundSize,0);
    else
    begin
      Num:=GetShapePoints(tmpR,P);

      if Num>0 then
      begin
        for t:=0 to Num-1 do
            P[t]:=ACanvas.Calculate3DPosition(P[t].X,P[t].Y,TeeTreeZ);

        FShadow.Draw(ACanvas,P,Num{,0});
      end;
    end
    end
  else
  begin
    // Offset rect
    {$IFDEF FMX}
    tmpR.Offset(FShadow.HorizSize,FShadow.VertSize);
    {$ELSE}
    with tmpR do
    begin
      Inc(Left,   FShadow.HorizSize);
      Inc(Right,  FShadow.HorizSize);
      Inc(Top,    FShadow.VertSize);
      Inc(Bottom, FShadow.VertSize);
    end;
    {$ENDIF}

    InternalDrawShape(tmpR,ACanvas,FStyle);
  end;
end;

procedure TTreeNodeShape.DrawShapeCanvas(const ACanvas:TCanvas3D; Const R:TRect);

  Function GetRectWithPen:TRect;
  var tmpPen : TTreePen;
      tmp    : TCoordinate;
  begin
    result:=R;
    tmpPen:=InternalPen;

    if tmpPen.Visible then
    begin
      tmp:=tmpPen.Width {$IFDEF FMX}*0.5{$ELSE}div 2{$ENDIF};

      {$IFDEF FMX}
      result.Inflate(tmp,tmp,tmpPen.Width,tmpPen.Width);
      {$ELSE}
      Dec(result.Left,tmp);
      Dec(result.Top,tmp);
      Inc(result.Right,tmpPen.Width);
      Inc(result.Bottom,tmpPen.Width);
      {$ENDIF}
    end;
  end;

  procedure DoDrawShadow;
  var tmpR     : TRect;
      tmpR2    : TRect;
      tmpBlend : TTeeBlend;
  begin
    tmpR:=GetRectWithPen;

    if FShadow.Transparency<>0 then
    begin
      if ACanvas.SupportsAlpha then
         tmpR2:=TeeZeroRect
      else
      begin
        tmpR2:=tmpR;

        {$IFDEF FMX}
        tmpR2.Offset(FShadow.HorizSize,FShadow.VertSize);
        {$ELSE}
        with tmpR2 do
        begin
          Inc(Left,   FShadow.HorizSize);
          Inc(Right,  FShadow.HorizSize);
          Inc(Top,    FShadow.VertSize);
          Inc(Bottom, FShadow.VertSize);
        end;
        {$ENDIF}
      end;

      tmpBlend:=ACanvas.BeginBlending(tmpR2,FShadow.Transparency)
    end
    else
       tmpBlend:=nil;

    InternalDrawShadow(tmpR,ACanvas,FStyle);

    if FShadow.Transparency<>0 then
       ACanvas.EndBlending(tmpBlend);
  end;

var tmpR     : TRect;
    tmpBlend : TTeeBlend;
    tmpBrush : TTreeShapeBrush;
    tmpPic   : TPicture;
begin
  { transparency ? }
  if (Transparency>0) and (ACanvas is TTeeCanvas3D) then
  begin
    if ACanvas.SupportsAlpha then
       tmpBlend:=ACanvas.BeginBlending(TeeZeroRect,Transparency)
    else
    begin
      tmpR:=RectTo3DCanvas(ACanvas,GetRectWithPen);

      { apply shadow size }
      if Assigned(FShadow) then
      with FShadow do
      if Visible then
      begin
        {$IFDEF FMX}
        tmpR.Right:=tmpR.Right+HorizSize;
        tmpR.Bottom:=tmpR.Bottom+VertSize;
        {$ELSE}
        Inc(tmpR.Right,HorizSize);
        Inc(tmpR.Bottom,VertSize);
        {$ENDIF}
      end;

      { create blend object }
      tmpBlend:=TTeeBlend.Create(TTeeCanvas3D(ACanvas),tmpR);
    end;
  end
  else  // no transparency
    tmpBlend:=nil;

  With ACanvas do
  Begin
    Brush.Bitmap:=nil; // reset

    { draw shape shadow ? }
    if (not Self.FTransparent) and
       (Assigned(FShadow) and FShadow.Visible) and (FShadow.Size<>0) then
    begin
      { draw shadow }
      Pen.Style:=psClear;
      Brush.Color:=FShadow.Color;
      if Brush.Style<>bsSolid then Brush.Style:=bsSolid;

      DoDrawShadow;
    end;

    { Now: draw shape. }

    { Is shape selected ? }
    if Self.Selected and (Tree.Selected.Color<>clNone) and (not Tree.Designing) then
    begin
      { draw selection focus }
      Brush.Style:=bsSolid;
      Brush.Color:=Tree.Selected.InternalColor;
      Gradient.Visible:=False;

      // if shape style is "line", draw selection as rectangle (visually better)
      if (FStyle=tssLine) or
         (FStyle=tssHorizLine) or
         (FStyle=tssVertLine) or
         (FStyle=tssInvertLine) then InternalDrawShape(R,ACanvas,tssRectangle);

    end
    else  // not selected shape
    begin
      { draw gradient ? }
      if Assigned(Self.FGradient) and Self.FGradient.Visible then
      begin
        Self.DrawGradient(R,ACanvas);
        Brush.Style:=bsClear;
      end
      else
        { prepare pattern brush }
        if Self.Transparent then
        begin
          if Brush.Style<>bsClear then Brush.Style:=bsClear
        end
        else
        begin
          tmpBrush:=Self.InternalBrush;

          AssignBrush(tmpBrush,Self.Color,Self.BackColor);
        end;
    end;

    { prepare shape border pen }
    if Assigned(Tree) then
    begin
      with Tree do
      if IMouseInside and (not Designing) and
         HotTrack.Active and HotTrack.UseBorder then // HotTrack Active ?
            AssignVisiblePen(HotTrack.Border)
      else
         AssignVisiblePen(Self.InternalPen);
    end
    else AssignVisiblePen(Self.InternalPen);

    { finally, draw shape }
    if (Pen.Style<>psClear) or (Brush.Style<>bsClear) then
       InternalDrawShape(R,ACanvas,FStyle);

    { special case for centered image }
    if (ImageAlignment=iaCenter) and (IImageWidth>0) then
    begin
      tmpPic:=GetPicture;

      if tmpPic is TTeePicture then
         StretchDraw(RectTo3DCanvas(ACanvas,R),TTeePicture(tmpPic).Filtered)
      else
         StretchDraw(RectTo3DCanvas(ACanvas,R),tmpPic.Graphic);
    end;

    // apply transparency percent
    if Assigned(tmpBlend) then
    begin
      if Image.Filters.Count>0 then
         Image.Filters.ApplyTo(tmpBlend.Bitmap);

      tmpBlend.DoBlend(Transparency);
      tmpBlend.Free;
    end
    else
    if Transparency>0 then
       if ACanvas.SupportsAlpha then
          ACanvas.EndBlending(tmpBlend);
  end;
end;

// Called when the Image has changed.
Procedure TTreeNodeShape.PictureChanged(Sender:TObject);
begin
  RecalcImageSize;
  CanvasChanged(FImage);

  if Assigned(FImage) and FImage.Valid then
  begin
    FImageIndex:=tiNone;
    FImageListIndex:=-1;
  end;
end;

Function TTreeNodeShape.GetImage:TTreePicture; // on-demand
begin
  if not Assigned(FImage) then
  begin
    FImage:=TTreePicture.Create;
    FImage.Assign(GetPicture);
    FImage.OnChange:=PictureChanged;
  end;

  result:=FImage;
end;

procedure TTreeNodeShape.SetRoundSize(const Value:Integer);
begin
  SetIntegerProperty(FRoundSize,Value);
end;

Procedure TTreeNodeShape.SetShadow(const Value:TTeeShadow);
begin
  if Assigned(Value) then Shadow.Assign(Value)
                     else FreeAndNil(FShadow);
end;

// Internal. Recalculate private variables for Image Width and Height.
Procedure TTreeNodeShape.RecalcImageSize;
var tmpImage : TPicture;
begin
  tmpImage:=GetPicture;

  if Assigned(tmpImage) and Assigned(tmpImage.Graphic) {$IFNDEF FMX}and (not tmpImage.Graphic.Empty){$ENDIF} then
  begin
    if FImageHeight=0 then IImageHeight:=tmpImage.Graphic.Height
                      else IImageHeight:=FImageHeight;

    if FImageWidth=0 then IImageWidth:=tmpImage.Graphic.Width
                     else IImageWidth:=FImageWidth;
  end
  else
  begin
    // No image. Set internal size variables to zero.
    IImageWidth:=0;
    IImageHeight:=0;
  end;
end;

// Returns the FImage local variable or the global image.

// Priorites:
//    1 - ImageListIndex  ( Tree.Images TImageList property )
//    2 - Image local property.
//    3 - TImageLevels component.
//    4 - ImageIndex property   ( global "stock pool" of pictures )

Function TTreeNodeShape.GetPicture:TPicture;
const FolderOpenClose:Array[Boolean] of Integer=
                        ( Ord(tiFolderClose),Ord(tiFolderOpen) );
begin
  // 1 - ImageListIndex
  if (FImageListIndex<>-1) and Assigned(Tree) then
  begin
    Tree.Images.GetBitmap(FImageListIndex,Image.Bitmap);

    {$IFNDEF FMX}
    FImage.Bitmap.Transparent:=True;
    {$ENDIF}

    result:=FImage;
  end
  else
  // 2 - Image property
  if FImageIndex=tiNone then
     result:=FImage
  else
     result:=nil;

  if not Assigned(result) then
  begin
    // 3 - Special case: ImageLevels component
    if Assigned(Tree) and Assigned(Tree.IImageLevels) then
    begin
      result:=Tree.IImageLevels.GetPicture(Level);
      if Assigned(result) then exit;
    end;

    // 4 - ImageIndex property ( "stock pool" pictures )

    if FImageIndex=tiFolderOpenClose then
       result:=TreeImagePool[FolderOpenClose[Expanded]]
    else
    if FImageIndex<>tiNone then
       result:=TreeImagePool[Ord(FImageIndex)];

    (* Trying to speed up GDI+, to avoid Bitmap conversion at StretchDraw
    if Assigned(result) and result.Bitmap.Transparent then
       MakeTransparent(result.Bitmap);
    *)
  end;
end;

// Draws node image at Tree Canvas.
Procedure TTreeNodeShape.DrawImage;
var tmp  : TPicture;
    tmpG : TGraphic;
    tmpR : TRect;
begin
  tmp:=GetPicture;

  if Assigned(tmp) then
  begin
     tmpR := ImageRect;

     {$IFDEF FMX}
     tmpR.Offset(Tree.ChartBounds.TopLeft);
     {$ELSE}
     with Tree.ChartBounds do
     begin
       tmpR.Left := tmpR.Left + Left;
       tmpR.Right := tmpR.Right + Left;
       tmpR.Top := tmpR.Top + Top;
       tmpR.Bottom := tmpR.Bottom + Top;
     end;
     {$ENDIF}

     if tmp is TTreePicture then
        tmpG:=TTreePicture(tmp).Filtered
     else
        tmpG:=tmp.Graphic;

     Tree.Canvas.StretchDraw(RectTo3DCanvas(Tree.Canvas, tmpR),tmpG);
  end;
end;

// Returns the node plus image rectangle bounds, converted to pixels,
// applying the appropiate Tree.View3DOptions "Zoom" ,
// "HorizOffset" and "VertOffset"
Function TTreeNodeShape.Get3DRectangle:TRect;
begin
  result:=RectTo3DCanvas(Tree.Canvas,AdjustedRectangle);
end;

// Draws the node
procedure TTreeNodeShape.Draw;
var R : TRect;
begin
  if Tree.ShowImages and (ImageAlignment<>iaCenter) then
     DrawImage;

  R:=Bounds;

  if Tree.Shapes.Visible then
     DrawShapeCanvas(Tree.Canvas,R);

  if Tree.ShowText then
     DrawText(Tree.Canvas,R);

  // If node is selected...
  if Selected and (not Tree.Printing) then
     if Tree.Designing then InternalDrawHandles
                       else DrawSelectionFocus;
end;

// Returns the node bounding rectangle (in pixels) plus Left/Top offset
Function TTreeNodeShape.Bounds:TRect;
begin
  With Tree.ChartBounds do
  begin
    result.Left:=X0+Left;
    result.Top:=Y0+Top;
    result.Right:=X1+Left;
    result.Bottom:=Y1+Top;
  end;
end;

{$IFDEF FMX}
procedure Calc2DPos(ACanvas:TCanvas3D; var AX,AY:Single; Z:Integer); overload;
var X,Y:Integer;
begin
  X:=Round(AX);
  Y:=Round(AY);

  ACanvas.Calculate2DPosition(x,y,Z);

  AX:=X;
  AY:=Y;
end;

procedure Calc2DPos(ACanvas:TCanvas3D; var P:TPoint; Z:Integer); overload;
begin
  Calc2DPos(ACanvas,P.x,P.y,z);
end;

procedure Calc2DPos(ACanvas:TCanvas3D; var P:TPoint); overload;
begin
  Calc2DPos(ACanvas,P,TeeTreeZ);
end;

procedure Calc2DPos(ACanvas:TCanvas3D; var R:TRect); overload;
begin
  Calc2DPos(ACanvas,R.TopLeft);
  Calc2DPos(ACanvas,R.BottomRight);
end;
{$ENDIF}

{$IFDEF FMX}
Function TTreeNodeShape.ClickedImage(x,y:Single):Boolean;
begin
  Calc2DPos(Tree.Canvas,X,Y,0);

  result:=(IImageWidth>0) and PointInRect(ImageRect,x,y);
end;
{$ENDIF}

// Returns True when XY point is inside shape's Image
Function TTreeNodeShape.ClickedImage(x,y:Integer):Boolean;
begin
  Tree.Canvas.Calculate2DPosition(x,y,0);

  result:=(IImageWidth>0) and PointInRect(ImageRect,x,y);
end;

// Returns True when node bound rectangle (2D) is inside Tree bounds
Function TTreeNodeShape.InsideTreeBounds:Boolean;
begin
  with Bounds do
       result:=(Left<=Tree.IBounds2D.Right) and (Right>=Tree.IBounds2D.Left) and
               (Top<=Tree.IBounds2D.Bottom) and (Bottom>=Tree.IBounds2D.Top);
end;

Function TTreeNodeShape.Clicked(const x,y:Integer):Boolean;
begin
  result:=Clicked(1.0*x,y);
end;

// Returns True when the point (XY) is inside the shape bounds
Function TTreeNodeShape.Clicked(const x,y:Single):Boolean;
var R       : TRect;
    tmpMidX : TCoordinate;
    tmpMidY : TCoordinate;
    P       : TPoint;
    ShapeP  : TShapePoints;
    Num     : Integer;
    tmpX,
    tmpY    : TCoordinate;
Begin
  if FVisible and InsideTreeBounds then
  begin
    tmpX := {$IFNDEF FMX}Round{$ENDIF}(x);
    tmpY := {$IFNDEF FMX}Round{$ENDIF}(y);

    {$IFDEF FMX}
    Calc2DPos(Tree.Canvas,tmpX,tmpY,0);
    {$ELSE}
    Tree.Canvas.Calculate2DPosition(tmpX,tmpY,0);
    {$ENDIF}

    R:=Bounds;
    tmpMidX:=XCenter;
    tmpMidY:=YCenter;

    P:=TeePoint(tmpX,tmpY);

    Case FStyle of
      tssVertLine:  result:=PointInLine(P,tmpMidX,R.Top,tmpMidX,R.Bottom,TeeLineClickTolerance);
      tssHorizLine: result:=PointInLine(P,R.Left,tmpMidY,R.Right,tmpMidY,TeeLineClickTolerance);
      tssLine:      result:=PointInLine(P,R.TopLeft,R.BottomRight,TeeLineClickTolerance);
      tssDiamond:   result:=PointInPolygon( P,[ TeePoint(tmpMidX,R.Top),
                                                TeePoint(R.Right,tmpMidY),
                                                TeePoint(tmpMidX,R.Bottom),
                                                TeePoint(R.Left,tmpMidY)] );
      tssCustom: begin
                   Num:=GetShapePoints(R,ShapeP);

                   if Num=0 then result:=PointInRect(R,tmpX,tmpY)
                            else result:=PointInPolygon(P,Slice(ShapeP,Num));
                 end;
    else
    begin
      {$IFDEF FMX}
      R.NormalizeRect;
      {$ELSE}
      OrientRectangle(R);
      {$ENDIF}

      Case FStyle of
        tssCircle       : result:=PointInEllipse(P,R);
        tssTriangleTop,
        tssTriangleBottom,
        tssTriangleLeft,

        tssTriangleRight: begin
                            GetTrianglePoints(R,tmpMidX,tmpMidY,ShapeP);

                            result:=PointInPolygon(P,Slice(ShapeP,3));
                          end;
      else
        result:=PointInRect(R,tmpX,tmpY);
      end;
    end;
    end;

    if (not result) and (FImageAlignment<>iaCenter) then
       result:=ClickedImage({$IFNDEF FMX}Round{$ENDIF}(x),{$IFNDEF FMX}Round{$ENDIF}(y));
  end
  else result:=False;
end;

Procedure TTreeNodeShape.Assign(Source:TPersistent);
begin
  if Source is TTreeNodeShape then
  begin
    AssignFormat(TTreeNodeShape(Source));

    With TTreeNodeShape(Source) do
    begin
      Self.FAutoSize     :=FAutoSize;
      Self.IAutoSized    :=not FAutoSize;
      Self.FX0           :=FX0;
      Self.FX1           :=FX1;
      Self.FY0           :=FY0;
      Self.FY1           :=FY1;

      Self.IImageWidth   :=IImageWidth;
      Self.IImageHeight  :=IImageHeight;
    end;
  end;

  inherited;
end;

Procedure TTreeNodeShape.AssignFormat(const ANode:TTreeNodeShape);
begin
  with ANode do
  begin
    Self.Border         :=FBorder;
    Self.Brush          :=FBrush;
    Self.Gradient       :=FGradient;
    Self.FGradientClip  :=FGradientClip;
    Self.InternalSetImage(FImage);
    Self.FImageAlignment:=FImageAlignment;
    Self.FImageHeight   :=FImageHeight;
    Self.FImageWidth    :=FImageWidth;
    Self.FRoundSize     :=FRoundSize;
    Self.Shadow         :=FShadow;
    Self.FStyle         :=FStyle;
    Self.FTransparency  :=Transparency;
    Self.FTransparent   :=Transparent;
    Self.FExpanded      :=FExpanded;
    Self.FImageIndex    :=FImageIndex;
    Self.FImageListIndex:=FImageListIndex;

    Self.FCursor:=FCursor;
    Self.Font:=FFont;

    if Assigned(FText) or Assigned(Self.FText) then
       Self.Text:=FText;
  end;

  if (FImageIndex<>tiNone) or (FImageListIndex<>-1) then FreeAndNil(FImage);
end;

procedure TTreeNodeShape.SetTransparent(const Value: Boolean);
begin
  SetBooleanProperty(FTransparent,Value);
end;

// Calculate node bounds when AutoSize is true
Procedure TTreeNodeShape.RecalcSize(const ACanvas:TCanvas3D);
var t             : Integer;
    tmp           : TCoordinate;
    tmpWidthText  : Integer;
    tmpHeightText : Integer;
    tmpPen        : TTreePen;
begin
  SetCanvasFont(ACanvas); // set font to display node text

  { Horizontal Width }
  if Assigned(FText) then
  begin
    tmpWidthText:=0;

    for t:=0 to FText.Count-1 do
      tmpWidthText:=Math.Max(tmpWidthText,ACanvas.TextWidth(FText[t]));
  end
  else
    tmpWidthText:=ACanvas.TextWidth(FTextString);

  Inc(tmpWidthText,2*TeeTextHorizMargin);

  tmp:=tmpWidthText;
  tmpPen:=InternalPen;

  if tmpPen.Visible then
     {$IFDEF FMX}
     tmp:=tmp+2*tmpPen.Width;
     {$ELSE}
     Inc(tmp,2*tmpPen.Width);
     {$ENDIF}

  FX1:=X0+{$IFDEF FMX}Round{$ENDIF}(tmp);  // set Right coordinate

  { Vertical Height }
  tmpHeightText:=1+ACanvas.TextHeight(TeeCharForHeight)*Math.Max(1,TextLinesCount);
  tmp:=tmpHeightText;

  if tmpPen.Visible then
     {$IFDEF FMX}
     tmp:=tmp+tmpPen.Width-1;
     {$ELSE}
     Inc(tmp,tmpPen.Width-1);
     {$ENDIF}

  FY1:=Y0+{$IFDEF FMX}Round{$ENDIF}(tmp);  // set Bottom coordinate

  { Adjust for non-rectangle shapes }
  Case FStyle of
    tssCircle,
    tssDiamond,
    tssTriangleTop,
    tssTriangleBottom,
    tssTriangleLeft,
    tssTriangleRight : begin
                         Inc(FX1,tmpWidthText);
                         Inc(FY1,tmpHeightText);
                       end;
  end;

  IAutoSized:=True;  // internal
end;

Procedure TTreeNodeShape.SetVisible(const Value:Boolean);
begin
  SetBooleanProperty(FVisible,Value);
end;

Procedure TTreeNodeShape.SetAutoPosition(const Value:TTreeShapeAutoPosition);
begin
  if Assigned(Value) then AutoPosition.Assign(Value)
                     else FreeAndNil(FAutoPosition);
end;

Procedure TTreeNodeShape.SetAutoSize(Value:Boolean);
begin
  if FAutoSize<>Value then
  begin
    FAutoSize:=Value;
    IAutoSized:=not AutoSize;
    CanvasChanged(Self);
  end;
end;

// Set the Tree property.
Procedure TTreeNodeShape.SetTree(const Value:TCustomTree);
begin
  if FTree<>Value then
  begin
    if Assigned(Tree) then
    begin
      Tree.Shapes.Remove(Self);

      if not Assigned(Parent) then
         Tree.Roots.Remove(Self);

      if FSelected then
         Tree.Selected.Remove(Self);

      if Owner=Tree then
         Tree.RemoveComponent(Self);
    end;

    inherited;

    FChildren.ITree:=FTree;

    if Assigned(FTree) then
    begin
      Tree.Shapes.Add(Self);

      // add / remove from Tree.Roots list.
      if not Assigned(Parent) then
      begin
        Tree.Roots.Add(Self);

        FBrotherIndex:=-1;
      end
      else
        Tree.Roots.Remove(Self);

      if FSelected then
         Tree.Selected.InternalAdd(Self);
    end;
  end;
end;

// Try to find a good automatic position for connecting to AShape
Procedure TTreeNodeShape.GetConnectionPos(const AShape:TTreeNodeShape;
                                          Var AX,AY:TCoordinate);
var px0,
    px1,
    py0,
    py1  : TCoordinate;
begin
  With AShape.Bounds do
  begin
    px0:=Left;
    px1:=Right;
    py0:=Top;
    py1:=Bottom;
  end;

  With AShape.InternalPen do
  if Visible then
  begin
    {$IFDEF FMX}
    px0:=px0-Width*0.5;
    py1:=py1-Width*0.5;
    {$ELSE}
    Dec(px0,Width div 2);
    Inc(py1,Width div 2);
    {$ENDIF}
  end;

  GetConnectionTo(px0,py0,px1,py1,AX,AY);
end;

// Try to find a good automatic position for connecting to XY point
Procedure TTreeNodeShape.GetConnectionTo(Const pX0,pY0,pX1,pY1:TCoordinate;
                                         Var AX,AY:TCoordinate);
var tmpXCenter : Integer;
    tmpYCenter : Integer;
    tmp  : TRect;

  Procedure CalcPosRectangle;
  var IsMidX : Boolean;
  begin
    IsMidX:=False;

    if px1<tmp.Right then
    begin
      if px1<tmp.Left then
         Ax:=tmp.Left
      else
      begin
         Ax:=tmpXCenter;
         IsMidX:=True;
      end;
    end
    else
    begin
      if px0>tmp.Right then
         Ax:=tmp.Right
      else
      begin
        Ax:=tmpXCenter;
        IsMidX:=True;
      end;
    end;

    if py0>tmp.Top then
    begin
      if IsMidX or (py0>tmp.Bottom) then
         Ay:=tmp.Bottom
      else
         Ay:=tmpYCenter;
    end
    else
    begin
      if IsMidX or (py1<tmp.Top) then
         Ay:=tmp.Top
      else
         Ay:=tmpYCenter;
    end;
  end;

  Procedure CalcPosDiamond;
  begin
    if pX1<tmp.Left then
    begin
      Ax:=tmp.Left;
      Ay:=tmpYCenter;
    end
    else
    begin
      if pX0>tmp.Right then
      begin
        Ax:=tmp.Right;
        Ay:=tmpYCenter;
      end
      else
      begin
        if pY1<tmp.Top then
        begin
          Ax:=tmpXCenter;
          Ay:=tmp.Top;
        end
        else
        begin
          Ax:=tmpXCenter;
          Ay:=tmp.Bottom;
        end;
      end;
    end;
  end;

begin
  tmp:=Bounds;

  With InternalPen do
  if Visible then
  begin
    {$IFDEF FMX}
    tmp.Left:=tmp.Left-(Width*0.5);
    tmp.Bottom:=tmp.Bottom+(Width*0.5);
    {$ELSE}
    Dec(tmp.Left,Width div 2);
    Inc(tmp.Bottom,Width div 2);
    {$ENDIF}
  end;

  tmpXCenter:={$IFDEF FMX}Round{$ENDIF}((tmp.Left+tmp.Right) {$IFDEF FMX}*0.5{$ELSE}div 2{$ENDIF});
  tmpYCenter:={$IFDEF FMX}Round{$ENDIF}((tmp.Top+tmp.Bottom) {$IFDEF FMX}*0.5{$ELSE}div 2{$ENDIF});

  Case FStyle of
    tssCircle,
    tssDiamond        : CalcPosDiamond;

    tssTriangleLeft   : begin
                          if pX1<tmp.Left then
                          begin
                            Ax:=tmp.Left;
                            Ay:=tmpYCenter;
                          end
                          else
                          begin
                            Ax:=tmp.Right;
                            if pY1<tmp.Top then
                               Ay:=tmp.Top
                            else
                               Ay:=tmp.Bottom;
                          end;
                        end;

    tssTriangleRight  : begin
                          if pX0>tmp.Right then
                          begin
                            Ax:=tmp.Right;
                            Ay:=tmpYCenter;
                          end
                          else
                          begin
                            Ax:=tmp.Left;
                            if pY1<tmp.Top then
                               Ay:=tmp.Top
                            else
                               Ay:=tmp.Bottom;
                          end;
                        end;

    tssTriangleTop    : begin
                          if pY1<tmp.Top then
                          begin
                            Ax:=tmpXCenter;
                            Ay:=tmp.Top;
                          end
                          else
                          begin
                            Ay:=tmp.Bottom;
                            if pX1<tmp.Left then
                               Ax:=tmp.Left
                            else
                            if pX0>tmp.Right then
                               Ax:=tmp.Right
                            else
                            if pX0<tmp.Left then Ax:=tmp.Left
                                            else Ax:=tmp.Right;
                          end;
                        end;

    tssTriangleBottom : begin
                          if pY0>tmp.Bottom then
                          begin
                            Ax:=tmpXCenter;
                            Ay:=tmp.Bottom;
                          end
                          else
                          begin
                            Ay:=tmp.Top;
                            if (tmp.Left>pX1) then
                               Ax:=tmp.Left
                            else
                            if (tmp.Right<pX0) then
                               Ax:=tmp.Right
                            else
                            if tmp.Right<pX1 then Ax:=tmp.Right
                                             else Ax:=tmp.Left;
                          end;
                        end;
    tssVertLine       : begin
                          Ax:=tmpXCenter;

                          if pY1<tmp.Top then
                             Ay:=tmp.Top
                          else
                             Ay:=tmp.Bottom;
                        end;
    tssHorizLine      : begin
                          Ay:=tmpYCenter;

                          if pX1<tmp.Left then
                             Ax:=tmp.Left
                          else
                             Ax:=tmp.Right;
                        end;
    tssLine,
    tssInvertLine     : begin
                          if pX1<tmp.Left then
                          begin
                            Ax:=tmp.Left;
                            Ay:=tmp.Top;
                          end
                          else
                          begin
                            Ax:=tmp.Right;
                            Ay:=tmp.Bottom;
                          end;
                        end;
  else
    CalcPosRectangle;
  end;
end;

// Returns which "handle" (if any), is under XY point
Function TTreeNodeShape.GetResizingHandle(x,y:Integer):TTreeShapeHandle;
var tmpSize : Integer;

  Function AtHandle(const Ax,Ay:TCoordinate):Boolean;
  begin
    result:=(Abs(X-Ax)<=tmpSize) and (Abs(Y-Ay)<=tmpSize);
  end;

var MidX : TCoordinate;
    MidY : TCoordinate;
    tmpOk : Boolean;
begin
  tmpSize:=Tree.Selected.HandleSize;

  With Bounds do
  begin
    if AtHandle(Left,Top)     then result:=rcLeftTop else
    if AtHandle(Right,Bottom) then result:=rcRightBottom else
    if AtHandle(Right,Top)    then result:=rcRightTop else
    if AtHandle(Left,Bottom)  then result:=rcLeftBottom
    else
    begin
      MidX:=1+((Left+Right) {$IFDEF FMX}*0.5{$ELSE}div 2{$ENDIF});
      MidY:=1+((Top+Bottom) {$IFDEF FMX}*0.5{$ELSE}div 2{$ENDIF});

      if AtHandle(Left,MidY)    then result:=rcLeft else
      if AtHandle(Right,MidY)   then result:=rcRight else
      if AtHandle(MidX,Top)     then result:=rcTop else
      if AtHandle(MidX,Bottom)  then result:=rcBottom else
                                     result:=rcNone;
    end;
  end;

  // call DoDrawHandle, if it returns "false" in tmpOk,
  // then it means the handle is not visible...
  tmpOk:=True;

  DoDrawHandle(result,x,y,tmpOk);

  if not tmpOk then
     result:=rcNone;
end;

// Draws a border around the shape (useful to show "focus")
procedure TTreeNodeShape.DrawSelectionFocus;
var tmpR : TRect;
begin
  With Tree do
  if Selected.Border.Visible then
  With Canvas do
  begin
    if Tree.Selected.IFocused then
       AssignVisiblePen(Selected.Border)
    else
       AssignVisiblePen(Selected.BorderUnFocused);

    Brush.Style:=bsClear;
    tmpR:=Self.Bounds;

    if not Self.InternalPen.Visible then
    begin
      {$IFDEF FMX}
      tmpR.Right:=tmpR.Right-Self.InternalPen.Width+1;
      tmpR.Bottom:=tmpR.Bottom-Self.InternalPen.Width+1;
      {$ELSE}
      Dec(tmpR.Right,Self.InternalPen.Width);
      Dec(tmpR.Bottom,Self.InternalPen.Width);
      {$ENDIF}
    end;

    InternalDrawShape(tmpR,Canvas,FStyle);
  end;
end;

// Prepare Font (before drawing the node text)
Procedure TTreeNodeShape.SetCanvasFont(const ACanvas:TCanvas3D);
{$IFNDEF FMX}
{$IFNDEF LCL}
var tmpColor : TColor;
{$ENDIF}
{$ENDIF}
begin
  if not Assigned(Tree) then
     ACanvas.AssignFont3D(InternalFont)
  else

  with Tree do
  if Self.FSelected and
     (Selected.TextColor<>clNone) and
     (not Designing) then
  begin
    ACanvas.AssignFont3D(InternalFont);
    ACanvas.Font.Color:=Selected.TextColor;
  end
  else
  begin
    // HotTrack ...
    if IMouseInside and (not Designing) and
       HotTrack.Active then
    begin
      if HotTrack.UseFont then
         ACanvas.AssignFont3D(HotTrack.Font)
      else
      if HotTrack.HotLink then
      begin
        ACanvas.AssignFont3D(InternalFont);
        with ACanvas.Font do Style:=Style+[{$IFDEF FMX}TFontStyle.{$ENDIF}fsUnderline];
      end;
    end
    else
       ACanvas.AssignFont3D(InternalFont);

    {$IFNDEF FMX}
    {$IFNDEF LCL}
    tmpColor:=ACanvas.Font.Color;

    if (Cardinal(tmpColor)>={$IFDEF D7}clSystemColor{$ELSE}$80000000{$ENDIF}) and
       (Cardinal(clMenuBar)>=Cardinal(tmpColor)) then
       ACanvas.Font.Color:=ColorToRGB(tmpColor);

    {$ENDIF}
    {$ENDIF}
  end;
end;

// Returns in P array all XY points that make the shape
Function TTreeNodeShape.GetShapePoints(Const R:TRect; Var P:TShapePoints):Integer;
Var tmpX : TCoordinate;
    tmpY : TCoordinate;
begin
  With R do
  begin
    Case FStyle of
      tssCircle  : begin
                     P[0]:=TopLeft;
                     P[1].X:=Right+1;
                     P[1].Y:=Bottom+1;
                     result:=2;
                   end;
      tssDiamond: begin
                    tmpX:=(Left+Right) {$IFDEF FMX}*0.5{$ELSE}div 2{$ENDIF};
                    tmpY:=(Top+Bottom) {$IFDEF FMX}*0.5{$ELSE}div 2{$ENDIF};
                    P[0]:=TeePoint(Left,tmpY);
                    P[1]:=TeePoint(tmpX,Top);
                    P[2]:=TeePoint(Right,tmpY);
                    P[3]:=TeePoint(tmpX,Bottom);
                    result:=4;
                  end;
 tssTriangleTop,
 tssTriangleBottom,
 tssTriangleLeft,
 tssTriangleRight: begin
                    GetTrianglePoints(R,(R.Left+R.Right) {$IFDEF FMX}*0.5{$ELSE}div 2{$ENDIF},
                                        (R.Top+R.Bottom) {$IFDEF FMX}*0.5{$ELSE}div 2{$ENDIF},
                                        P);
                    result:=3;
                   end;
 tssRoundRectangle,
        tssChamfer : result:=GetRoundRectanglePoints(R,P);
    else
    begin
      result:=0;
      Exit;
    end;
    end;
 end;
end;

// Draws a gradient filling the shape interior
Procedure TTreeNodeShape.DrawGradient(Const Rect:TRect; const ACanvas:TCanvas3D);
var R : TRect;

  {$IFNDEF FMX}
  Function ClipGradientShape:TRect;
  var Num    : Integer;
      P      : TShapePoints;
      t      : Integer;
  begin
    result:=R;

    if FStyle=tssCircle then
       ACanvas.ClipEllipse(R)
    else
    begin
      // Create a clipping region using the shape bounding points
      Num:=GetShapePoints(R,P);

      if Num>0 then
      begin
        if Self is TPolygonShape then // trick
           for t:=0 to Num-1 do
             P[t]:=Tree.Canvas.Calculate3DPosition(P[t].X,P[t].Y,TeeTreeZ);

        ACanvas.ClipPolygon(P,Num);

        result:=RectFromPolygon(P,Num);
      end;
    end;
  end;
  {$ENDIF}

var tmpClip : Boolean;
begin
  if FGradient.Visible then
  begin
    tmpClip:=FGradientClip and (Self.FStyle<>tssRectangle);

    if Assigned(Tree) then
       tmpClip:=tmpClip and Tree.CanClip;

    R:=RectTo3DCanvas(ACanvas,Rect);

    {$IFNDEF FMX}
    if tmpClip then
       R:=ClipGradientShape;
    {$ENDIF}

    FGradient.Draw(ACanvas,R,0);

    if tmpClip then
       ACanvas.UnClipRectangle;
  end;
end;

procedure TTreeNodeShape.InternalSetImage(const Value:TPicture);
begin
  if Assigned(Value) then GetImage.Assign(Value)
                     else FreeAndNil(FImage);

  RecalcImageSize;
end;

// set Picture
procedure TTreeNodeShape.SetImage(const Value:TTreePicture);
begin
  if Assigned(Value) then
     FImageListIndex:=-1;  // reset ImageListIndex

  InternalSetImage(Value);
end;

Function TTreeNodeShape.GetGradient:TShapeGradient;
begin
  if not Assigned(FGradient) then
     FGradient:=TShapeGradient.Create(CanvasChanged);

  result:=FGradient;
end;

Function TTreeNodeShape.GetBrush:TTreeShapeBrush;
begin
  if not Assigned(FBrush) then
  begin
    FBrush:=TTreeShapeBrush.Create(CanvasChanged);

    if Assigned(Tree) then
       FBrush.Assign(Tree.GlobalFormat.Brush);
  end;

  result:=FBrush;
end;

Procedure TTreeNodeShape.SetGradientClip(Value:Boolean);
begin
  SetBooleanProperty(FGradientClip,Value);
end;

Procedure TTreeNodeShape.SetGradient(const Value:TShapeGradient);
begin
  if Assigned(Value) then Gradient.Assign(Value)
                     else FreeAndNil(FGradient);
end;

Function TTreeNodeShape.XCenter:TCoordinate;
begin
  result:=((X0+X1) {$IFDEF FMX}*0.5{$ELSE}div 2{$ENDIF})+Tree.ChartBounds.Left;
end;

Function TTreeNodeShape.YCenter:TCoordinate;
begin
  result:=((Y0+Y1) {$IFDEF FMX}*0.5{$ELSE}div 2{$ENDIF})+Tree.ChartBounds.Top;
end;

Procedure TTreeNodeShape.SetImageAlignment(Value:TTreeImageAlignment);
begin
  if FImageAlignment<>Value then
  begin
    FImageAlignment:=Value;
    CanvasChanged(Self);
  end;
end;

procedure TTreeNodeShape.SetImageHeight(Value:Integer);
begin
  SetIntegerProperty(FImageHeight,Value);
  RecalcImageSize;
end;

procedure TTreeNodeShape.SetImageWidth(Value:Integer);
begin
  SetIntegerProperty(FImageWidth,Value);
  RecalcImageSize;
end;

// Draw all 8 "handles" around the shape
Procedure TTreeNodeShape.DrawHandles;
Var MidX : Integer;
    MidY : Integer;
    pX0  : Integer;
    pX1  : Integer;
    pY0  : Integer;
    pY1  : Integer;
begin
  With Bounds{$IFDEF FMX}.Round{$ENDIF} do
  begin
    pX0:=Left;
    pY0:=Top;
    pX1:=Right+1;
    pY1:=Bottom+1;
  end;

  if InternalPen.Visible then
  begin
    Inc(pX1);
    Inc(pY1);
  end;

  with Tree do
  begin
    DrawHandle(Self,rcLeftTop,pX0,pY0);
    DrawHandle(Self,rcLeftBottom,pX0,pY1);
    DrawHandle(Self,rcRightTop,pX1,pY0);
    DrawHandle(Self,rcRightBottom,pX1,pY1);

    MidY:=(pY0+pY1) div 2;

    DrawHandle(Self,rcLeft,pX0,MidY);
    DrawHandle(Self,rcRight,pX1,MidY);

    MidX:=(pX0+pX1) div 2;

    DrawHandle(Self,rcTop,MidX,pY0);
    DrawHandle(Self,rcBottom,MidX,pY1);
  end;
end;

procedure TTreeNodeShape.SetBackColor(const Value: TColor);
begin
  Brush.BackColor:=Value;
end;

function TTreeNodeShape.GetHeight: Integer;
begin
  result:=Y1-Y0;
end;

function TTreeNodeShape.GetWidth: Integer;
begin
  result:=X1-X0;
end;

procedure TTreeNodeShape.SetHeight(const Value: Integer);
begin
  Y1:=Y0+Value;
end;

procedure TTreeNodeShape.SetWidth(const Value: Integer);
begin
  X1:=X0+Value;
end;

procedure TTreeNodeShape.SetTransparency(const Value: TTeeTransparency);
begin
  if FTransparency<>Value then
  begin
    FTransparency:=Value;
    CanvasChanged(Self);
  end;
end;

// Optimization: return local or global Pen object
function TTreeNodeShape.InternalPen: TTreePen;
begin
  if Assigned(FBorder) then
     result:=FBorder // local
  else
  if Assigned(Tree) then
     result:=Tree.GlobalFormat.Border  // global
  else
     result:=Border;  // force on-demand local
end;

// optimization: return local or global Brush object
function TTreeNodeShape.InternalBrush: TTreeShapeBrush;
begin
  if Assigned(FBrush) then
     result:=FBrush  // local
  else
  if Assigned(Tree) then
     result:=Tree.GlobalFormat.Brush // global
  else
     result:=Brush;  // force on-demand local
end;

function TTreeNodeShape.GetColor: TColor;
begin
  if Assigned(FBrush) then result:=FBrush.Color
                      else result:=clWhite;
end;

procedure TTreeNodeShape.SetColor(const Value: TColor);
begin
  Brush.Color:=Value;
end;

{ TConnectionArrow }

Constructor TConnectionArrow.Create(const AOwner : TTreeConnection);
begin
  inherited Create;
  IOwner:=AOwner;
  FSize:=TeeDefaultArrowSize;
end;

Destructor TConnectionArrow.Destroy;
begin
  FBorder.Free;
  FBrush.Free;
  inherited;
end;

function TConnectionArrow.GetBackColor:TColor;
begin
  result:=Brush.BackColor;
end;

Function TConnectionArrow.GetBorder:TTreePen;
begin
  if not Assigned(FBorder) then
     if Assigned(IOwner) then
        FBorder:=TTreePen.Create(IOwner.CanvasChanged)
     else
        FBorder:=TTreePen.Create(nil);

  result:=FBorder;
end;

Procedure RotatePoint(Var APoint:TPoint; Const Angle:Double; Const Center:TPoint);
var tmpSin : Extended;
    tmpCos : Extended;
    tmp    : TCoordinate;
begin
  SinCos(Angle*TeePiStep,tmpSin,tmpCos);

  {$IFDEF FMX}
  APoint.Offset(Center.X,Center.Y);
  {$ELSE}
  Dec(APoint.X,Center.X);
  Dec(APoint.Y,Center.Y);
  {$ENDIF}

  tmp:=APoint.X;

  APoint.X:={$IFNDEF FMX}Round{$ENDIF}(APoint.X*tmpCos+APoint.Y*tmpSin)+Center.X;
  APoint.Y:={$IFNDEF FMX}Round{$ENDIF}(tmp*tmpSin-APoint.Y*tmpCos)+Center.Y;
end;

// Draw the connection
Procedure TConnectionArrow.Draw(Const Point:TConnectionPoint; Angle:Integer);
var P1 : TPoint;
    P2 : TPoint;
    P3 : TPoint;

  Procedure CalcPosArrow;
  begin
    With IOwner.Tree.Canvas do
    begin
      P1:=Calculate3DPosition( Point.X-Self.FSize,
                               Point.Y-(Self.FSize div 2),TeeTreeZ);
      P2:=Calculate3DPosition( Point.X-Self.FSize,
                               Point.Y+(Self.FSize div 2),TeeTreeZ);
      P3:=Calculate3DPosition(Point.X,Point.Y,TeeTreeZ);
    end;
    if Angle<>0 then
    begin
      RotatePoint(P1,Angle,P3);
      RotatePoint(P2,Angle,P3);
    end;
  end;

var tmpR : TRect;
begin
  With tmpR do
  begin
    Left   := Point.X-(FSize div 2);
    Right  := Left+FSize;
    Top    := Point.Y-(FSize div 2);
    Bottom := Top+FSize;
  end;

  if Intersect(tmpR,IOwner.Tree.IBounds2D) then
  With IOwner,Tree.Canvas do
  begin
    AssignVisiblePen(Self.Border);
    AssignBrush(Self.Brush,Self.BackColor);

    Case Self.FStyle of
     casSolid: begin
                 CalcPosArrow;
                 Polygon([P1,P2,P3]);
               end;

     casLines: begin
                 CalcPosArrow;
                 MoveTo(P1.X,P1.Y);
                 LineTo(P3.X,P3.Y);
                 LineTo(P2.X,P2.Y);
               end;

    casSquare: RectangleWithZ(tmpR,TeeTreeZ);

    casCircle: With tmpR do
                 EllipseWithZ(Left,Top,Right,Bottom,TeeTreeZ);

   casDiamond: Tree.DrawDiamond(tmpR);
    end;
  end;
end;

Procedure TConnectionArrow.SetBorder(const Value:TTreePen);
begin
  if Assigned(Value) then Border.Assign(Value)
                     else FreeAndNil(FBorder);
end;

Procedure TConnectionArrow.SetBrush(const Value:TConnectionArrowBrush);
begin
  if Assigned(Value) then Brush.Assign(Value)
                     else FreeAndNil(FBrush);
end;

Procedure TConnectionArrow.SetSize(Value:Integer);
begin
  if FSize<>Value then
  begin
    FSize:=Value;

    if Assigned(IOwner) then
       IOwner.CanvasChanged(Self);
  end;
end;

Procedure TConnectionArrow.SetStyle(const Value:TConnectionArrowStyle);
begin
  if FStyle<>Value then
  begin
    FStyle:=Value;

    if Assigned(IOwner) then
       IOwner.CanvasChanged(Self);
  end;
end;

Procedure TConnectionArrow.Assign(Source:TPersistent);
begin
  if Source is TConnectionArrow then
  With TConnectionArrow(Source) do
  begin
    Self.Brush:=FBrush;
    Self.Border:=FBorder;
    Self.FSize:=Size;
    Self.FStyle:=Style;
  end
  else inherited;
end;

procedure TConnectionArrow.SetBackColor(const Value: TColor);
begin
  Brush.BackColor:=Value;
end;

function TConnectionArrow.GetBrush: TConnectionArrowBrush;
begin
  if not Assigned(FBrush) then
  begin
    FBrush:=TConnectionArrowBrush.Create(IOwner.CanvasChanged);
    FBrush.Color:=clBlack;
  end;

  result:=FBrush;
end;

{ TTreeShapeBrush }

Constructor TTreeShapeBrush.Create(const Changed: TNotifyEvent);
begin
  inherited;
  Color:=clWhite;
end;

{ TTreeConnectionPen }

Constructor TTreeConnectionPen.Create(const OnChangeEvent:TNotifyEvent);
begin
  inherited;
  SmallDots:=True;
  Style:=psDot;
  Color:=clGray;
end;

{ TConnectionPoints }
function TConnectionPoints.Add(Const P:TPoint): Integer;
begin
  result:=Add({$IFDEF FMX}Round{$ENDIF}(P.X),{$IFDEF FMX}Round{$ENDIF}(P.Y));
end;

function TConnectionPoints.Add(Ax, Ay: Integer): Integer;
begin
  result:=Add(cpsFixed,Ax,cpsFixed,Ay);
end;

function TConnectionPoints.Add( AXStyle:TConnectionPointStyle; Ax:Integer;
                                AYStyle:TConnectionPointStyle; Ay: Integer): Integer;
begin
  if IConnection.Style=csAuto then
     RemoveAuto;

  result:=Count;

  SetLength(Item,result+1);

  with Item[result] do
  begin
    XStyle:=AXStyle;
    XValue:=Ax;
    X:=Ax;
    YStyle:=AYStyle;
    YValue:=Ay;
    Y:=Ay;
//    IConnection.Tree.Canvas.Calculate2DPosition(XValue,YValue,TeeTreeZ);
  end;
end;

// Adds a new point to the array, at Index position
Procedure TConnectionPoints.Insert(Index:Integer; x,y:Integer);
var tmp : TConnectionPoint;
    t   : Integer;
    tmpPos : Integer;
begin
  tmpPos:=Add(x,y);

  if Index<tmpPos then
  begin
    { move new added point from last position to Index position }
    tmp:=Item[tmpPos];

    for t:=tmpPos downto Index+1 do
        Item[t]:=Item[t-1];

    Item[Index]:=tmp;
  end;
end;

// Returns the point index where the XY pixel position is in.
procedure TConnectionPoints.Clear;
begin
  Item:=nil;
end;

function TConnectionPoints.Clicked(x, y: Integer): Integer;
var t       : Integer;
    tmpSize : Integer;
begin
  result:=-1;

  with IConnection.Tree do
  begin
    Canvas.Calculate2DPosition(x,y,TeeTreeZ);
    tmpSize:=Selected.HandleSize;
  end;

  for t:=0 to High(Item) do
  begin
    if (Abs(X-Item[t].X)<=tmpSize) and (Abs(Y-Item[t].Y)<=tmpSize) then
    begin
      result:=t;
      break;
    end;
  end;
end;

function TConnectionPoints.Count: Integer;
begin
  result:=Length(Item);
end;

// Removes Point Index from the connection Points[] array
procedure TConnectionPoints.Delete(Index: Integer);
var t : Integer;
    l : Integer;
begin
  if IConnection.Style=csAuto then
     RemoveAuto;

  l:=Length(Item);

  for t:=Index to l-2 do
      Item[t]:=Item[t+1];

  SetLength(Item,Pred(l));

  IConnection.CanvasChanged(Self); // repaint
end;

Procedure TConnectionPoints.RemoveAuto;

  Procedure SetFromRel(Index:Integer);
  begin
    with Item[Index] do
    begin
      XStyle:=cpsFromRel;
      XValue:=X-IConnection.FromShape.X0;
      YStyle:=cpsFromRel;
      YValue:=Y-IConnection.FromShape.Y0;
    end;
  end;

var t : Integer;
begin
  IConnection.FStyle := csLine; // disable automatic style

  // All points but the last...
  for t:=0 to Count-2 do
      SetFromRel(t);

  // Last point...
  if Count>1 then
     if Assigned(IConnection.ToShape) then
     with Item[Count-1] do
     begin
       XStyle:=cpsToRel;
       XValue:=X-IConnection.ToShape.X0;
       YStyle:=cpsToRel;
       YValue:=Y-IConnection.ToShape.Y0;
     end
     else
       SetFromRel(Count-1);
end;

// Move the Point[ Index ] the specified amount of Delta pixels...
procedure TConnectionPoints.Move(Index, DeltaX, DeltaY: Integer);
begin
  if IConnection.Style=csAuto then
     RemoveAuto;

  with Item[Index] do
  begin
    if DeltaX<>0 then
    begin
      Case XStyle of
        cpsAutoFrom,
        cpsFromPercent: begin
                          XStyle:=cpsFromRel;
                          XValue:=X-IConnection.FromShape.X0;
                        end;
        cpsAutoTo,
        cpsToPercent  : begin
                          XStyle:=cpsToRel;
                          XValue:=X-IConnection.ToShape.X0;
                        end;
      end;
      XValue:=XValue+DeltaX;
    end;

    if DeltaY<>0 then
    begin
      Case YStyle of
        cpsAutoFrom,
        cpsFromPercent: begin
                          YStyle:=cpsFromRel;
                          YValue:=Y-IConnection.FromShape.Y0;
                        end;
        cpsAutoTo,
        cpsToPercent  : begin
                          YStyle:=cpsToRel;
                          YValue:=Y-IConnection.ToShape.Y0;
                        end;
      end;
      YValue:=YValue+DeltaY;
    end;
  end;

  IConnection.Tree.Invalidate;
end;

function TConnectionPoints.AddFromPrevious(XOffset,
  YOffset: Integer): Integer;
begin
  result:=Add(cpsPrevious,XOffset,cpsPrevious,YOffset);
end;

procedure TConnectionPoints.ChangeXStyle(Index: Integer;
  AStyle: TConnectionPointStyle);
begin
  with Item[Index] do
  begin
    XStyle:=AStyle;
    case XStyle of
      cpsFixed  : XValue:=X;
      cpsFromRel: XValue:=X-IConnection.FromShape.Left;
      cpsFromPercent: XValue:=Round((X-IConnection.FromShape.Left)*100.0/IConnection.FromShape.Width);
      cpsToRel  : XValue:=X-IConnection.ToShape.Left;
      cpsAutoFrom,
      cpsAutoTo : XValue:=0;
    end;
  end;

  IConnection.Repaint;
end;

procedure TConnectionPoints.ChangeYStyle(Index: Integer;
  AStyle: TConnectionPointStyle);
begin
  with Item[Index] do
  begin
    YStyle:=AStyle;
    case YStyle of
      cpsFixed  : YValue:=Y;
      cpsFromRel: YValue:=Y-IConnection.FromShape.Top;
      cpsFromPercent: YValue:=Round((Y-IConnection.FromShape.Top)*100.0/IConnection.FromShape.Height);
      cpsToRel  : YValue:=Y-IConnection.ToShape.Top;
      cpsAutoFrom,
      cpsAutoTo : YValue:=0;
    end;
  end;

  IConnection.Repaint;
end;

// calculate the XY pixel position for a given Index point in
// the Points[] array.
// The Point XStyle and YStyle determine how to do the calculation.
// See type TConnectionPoints help above.
// Addition of chartbounds to print connection lines correctly on printcanvas.
procedure TConnectionPoints.CalculatePosition(Index: Integer);
var p : TConnectionPoint;
    tmpNum : Integer;
begin
  tmpNum:=Length(Item);

  With Item[Index] do
  begin
    if XStyle=cpsAutoFrom then  // automatic from "FromShape" to "ToShape"
    begin
      if (Index<=tmpNum) and (Item[Index+1].XStyle=cpsAutoTo) then
         IConnection.FromShape.GetConnectionPos(IConnection.ToShape,X,Y)
      else
      { special case: next point is not automatic }
      begin
        CalculatePosition(Index+1);
        p:=Item[Index+1];
        p.x := p.x + IConnection.Tree.ChartBounds.Left;
        IConnection.FromShape.GetConnectionTo(p.X,p.Y,p.X,p.Y,X,Y);
      end;
    end
    else
    if XStyle=cpsAutoTo then   // automatic from "ToShape"
    begin
      if (Index>0) and (Item[Index-1].XStyle<>cpsNext) then
      begin
        p:=Item[Index-1];
        p.x := p.x + IConnection.Tree.ChartBounds.Left;
        IConnection.ToShape.GetConnectionTo(p.X,p.Y,p.X,p.Y,X,Y);
      end
      else IConnection.ToShape.GetConnectionPos(IConnection.FromShape,X,Y);
    end
    else
    begin
      Case XStyle of
    cpsFromPercent : With IConnection.FromShape do
                          X:=X0+Round(XValue*Width*0.01)+IConnection.Tree.ChartBounds.Left;

      cpsToPercent : With IConnection.ToShape do
                          X:=X0+Round(XValue*Width*0.01)+IConnection.Tree.ChartBounds.Left;

        cpsFromRel : X:=IConnection.FromShape.X0+XValue + IConnection.Tree.ChartBounds.Left;
          cpsToRel : X:=IConnection.ToShape.X0+XValue   + IConnection.Tree.ChartBounds.Left;

       cpsPrevious : if Index>0 then
                        X:=Item[Index-1].X+XValue
                     else
                        X:=0; // wrong. There is no Previous point !

          cpsFixed : X:=XValue;

           cpsNext : if Index<=tmpNum then
                     begin
                       CalculatePosition(Index+1);
                       X:=Item[Index+1].X+XValue;
                     end
                     else X:=0; // wrong. There is no Next point !
      end;

      Case YStyle of
    cpsFromPercent : With IConnection.FromShape do
                          Y:=Y0+Round(YValue*Height*0.01)+IConnection.Tree.ChartBounds.Top;

      cpsToPercent : With IConnection.ToShape do
                          Y:=Y0+Round(YValue*Height*0.01)+IConnection.Tree.ChartBounds.Top;

        cpsFromRel : Y:=IConnection.FromShape.Y0+YValue+IConnection.Tree.ChartBounds.Top;

          cpsToRel : Y:=IConnection.ToShape.Y0+YValue+IConnection.Tree.ChartBounds.Top;

       cpsPrevious : if Index>0 then
                        Y:=Item[Index-1].Y+YValue
                     else
                        Y:=0; // wrong. There is no Previous point !

          cpsFixed : Y:=YValue;

           cpsNext : if Index<=tmpNum then
                     begin
                       CalculatePosition(Index+1);
                       Y:=Item[Index+1].Y+YValue;
                     end
                     else Y:=0; // wrong. There is no Next point !
      end;
    end;
  end;
end;

{ TTreeConnection }

Constructor TTreeConnection.Create(AOwner: TComponent);
begin
  inherited;
  FPoints:=TConnectionPoints.Create;
  FPoints.IConnection:=Self;
end;

Destructor TTreeConnection.Destroy;
begin
  // Tell the "From" shape to remove self from Connections list
  if Assigned(Tree) and (not Tree.IClearing) then  // optimization.
  begin
    if Assigned(FromShape) then
    begin
      FromShape.Connections.Remove(Self);
      if Assigned(ToShape) then
         ToShape.Parents.Remove(FromShape);
    end;

    // remove self from Tree global connections list
    Tree.Connections.DeleteConnection(Self);
  end;

  FArrowTo.Free;
  FArrowFrom.Free;
  FBorder.Free;
  FFormat.Free;

  FPoints.Item:=nil;
  FPoints.Free;

  inherited;
end;

// NOTE: The Points[] array property is NOT a TCollection for
// memory and speed reasons. This is why it is stored using VCL
// DefineProperties mechanism.
procedure TTreeConnection.DefineProperties(Filer: TFiler);
var tmp : Boolean;
begin
  inherited;

  // Should we store the Points[] array ?
  tmp:=(Style<>csAuto) and (Length(Points.Item)>1);

  if tmp then
  begin
    if Style=csLine then
    // if the Points[] array has the default points for point 0 and 1,
    // do not store.
    with Points do
    begin
      if (Item[0].XStyle=cpsAutoFrom) and
         (Item[0].YStyle=cpsAutoFrom) and
         (Item[1].XStyle=cpsAutoTo) and
         (Item[1].YStyle=cpsAutoTo) then
             tmp:=False; // is default. do not store points[].
    end
  end;

  Filer.DefineProperty('Points',ReadPoints,SavePoints,tmp);
end;

// Internal. Read Points[] array from Stream.
procedure TTreeConnection.ReadPoints(Reader: TReader);
var t : Integer;
    tmpPoints : TConnectionPoints;
begin
  tmpPoints:=Points;
  tmpPoints.Item:=nil;  // due to a dccil problem, use tmpPoints shortcut
  t:=0;

  Reader.ReadListBegin;

  while not Reader.EndOfList do
  begin
    SetLength(tmpPoints.Item,t+1);

    with tmpPoints.Item[t] do
    begin
      XStyle:=TConnectionPointStyle(Reader.ReadInteger);
      YStyle:=TConnectionPointStyle(Reader.ReadInteger);

      XValue:=Reader.ReadInteger;
      YValue:=Reader.ReadInteger;
      X:=Reader.ReadInteger;
      Y:=Reader.ReadInteger;
    end;

    Inc(t);
  end;

  Reader.ReadListEnd;
end;

// Internal. Save Points[] array to Stream.
procedure TTreeConnection.SavePoints(Writer: TWriter);
var t   : Integer;
    tmp : Integer;
begin
  Writer.WriteListBegin;

  tmp:=Length(Points.Item);

  for t:=0 to tmp-1 do
  with Points.Item[t] do
  begin
    Writer.WriteInteger(Ord(XStyle));
    Writer.WriteInteger(Ord(YStyle));

    Writer.WriteInteger({$IFDEF FMX}Round{$ENDIF}(XValue));
    Writer.WriteInteger({$IFDEF FMX}Round{$ENDIF}(YValue));
    Writer.WriteInteger({$IFDEF FMX}Round{$ENDIF}(X));
    Writer.WriteInteger({$IFDEF FMX}Round{$ENDIF}(Y));
  end;

  Writer.WriteListEnd;
end;

Function TTreeConnection.GetArrowFrom:TConnectionArrowFrom; // on-demand
begin
  if not Assigned(FArrowFrom) then
  begin
    FArrowFrom:=TConnectionArrowFrom.Create(Self);
    FArrowFrom.Style:=casNone;

    if Assigned(FTree) then
       FArrowFrom.Assign(FTree.GlobalFormat.Connection.ArrowFrom);
  end;

  result:=FArrowFrom;
end;

Function TTreeConnection.GetArrowTo:TConnectionArrowTo; // on-demand
begin
  if not Assigned(FArrowTo) then
  begin
    FArrowTo:=TConnectionArrowTo.Create(Self);
    FArrowTo.Style:=casSolid;

    if Assigned(FTree) then
       FArrowTo.Assign(FTree.GlobalFormat.Connection.ArrowTo);
  end;

  result:=FArrowTo;
end;

Function TTreeConnection.GetBorder:TTreeConnectionPen;
begin
  if not Assigned(FBorder) then
  begin
    FBorder:=TTreeConnectionPen.Create(CanvasChanged);

    if Assigned(Tree) then
       FBorder.Assign(Tree.GlobalFormat.Connection.Border);
  end;

  result:=FBorder;
end;

Function TTreeConnection.GetFormat:TConnectionFormat;
begin
  if not Assigned(FFormat) then
  begin
    FFormat:=TConnectionFormat.Create(FTree);
    FFormat.Visible:=False;
  end;

  result:=FFormat;
end;

Function TTreeConnection.IsFormatStored:Boolean;
begin
  result:=Assigned(FFormat);
end;

Function TTreeConnection.GetBounds: TRect;
begin
  result:=IBounds;
end;

function TTreeConnection.GetFromShape: TTreeNodeShape;
begin
  result:=FFromShape;
end;

Function TTreeConnection.GetPoints: TConnectionPoints;
begin
  if not Assigned(FPoints) then
  begin
    FPoints:=TConnectionPoints.Create;
    FPoints.IConnection:=Self;
    SetupPoints;
  end;

  result:=FPoints;
end;

Function TTreeConnection.GetStyle: TTreeConnectionStyle;    
begin
  result:=FStyle;
end;

Function TTreeConnection.GetToShape: TTreeNodeShape;    
begin
  result:=FToShape;
end;

Procedure TTreeConnection.Assign(Source:TPersistent);
begin
  if Source is TTreeConnection then
  With TTreeConnection(Source) do
  begin
    Self.ArrowFrom :=FArrowFrom;
    Self.ArrowTo   :=FArrowTo;
    Self.Border    :=FBorder;
    Self.Format    :=FFormat;
    Self.FStyle    :=FStyle;
  end;

  inherited;
end;

procedure TTreeConnection.SetArrowFrom(const Value:TConnectionArrowFrom);
begin
  if Assigned(Value) then ArrowFrom.Assign(Value)
                     else FreeAndNil(FArrowFrom);
end;

procedure TTreeConnection.SetArrowTo(const Value:TConnectionArrowTo);
begin
  if Assigned(Value) then ArrowTo.Assign(Value)
                     else FreeAndNil(FArrowTo);
end;

Procedure TTreeConnection.SetupPoints;

  Procedure SetAuto(Var P:TConnectionPoint; AStyle:TConnectionPointStyle);
  begin
    with P do
    begin
      XStyle:=AStyle;
      XValue:=0;
      YStyle:=AStyle;
      YValue:=0;
    end;
  end;

begin
  if Style<>csAuto then
  with Points do
     if Style=csCurve then
     begin
       SetLength(Item,4);
       SetAuto(Item[0],cpsAutoFrom);

       With Item[1] do
       begin
         XStyle:=cpsPrevious;  // same X as previous point
         XValue:=0;
         YStyle:=cpsNext;  // same Y as next point
         YValue:=0;
       end;

       With Item[2] do
       begin
         XStyle:=cpsPrevious;  // same X as previous point
         XValue:=0;
         YStyle:=cpsNext;  // same Y as next point
         YValue:=0;
       end;

       // SetAuto(Item[2],cpsAutoTo);
       SetAuto(Item[3],cpsAutoTo);
     end
     else
     begin
       SetLength(Item,2);
       SetAuto(Item[0],cpsAutoFrom);
       SetAuto(Item[1],cpsAutoTo);
     end;
end;

Procedure TTreeConnection.SetStyle(const Value:TTreeConnectionStyle);
begin
  if FStyle<>Value then
  begin
    if (FStyle=csAuto) or (Value=csAuto) then
       Points.Clear;

    FStyle:=Value;

    SetupPoints;
    CanvasChanged(Self);
  end;
end;

Procedure TTreeConnection.SetTree(const Value:TCustomTree);
begin
  if FTree<>Value then
  begin
    if Assigned(FTree) then
       Tree.Connections.Remove(Self);

    inherited;

    if Assigned(FTree) then
       Tree.Connections.Add(Self);
  end;
end;

procedure TTreeConnection.SetFromShape(const Value:TTreeNodeShape);
begin
  if FFromShape<>Value then
  begin
    if Assigned(FromShape) then
    begin
      FromShape.Connections.Remove(Self);
      if Assigned(ToShape) then
         ToShape.Parents.Remove(FromShape);
    end;

    FFromShape:=Value;

    if Assigned(FromShape) then
    begin
      FromShape.Connections.Add(Self);
      if Assigned(ToShape) then
         ToShape.Parents.Add(FromShape);
    end;
  end;
end;

procedure TTreeConnection.SetToShape(const Value:TTreeNodeShape);
begin
  if FToShape<>Value then
  begin
    if Assigned(FromShape) and Assigned(ToShape) then
       ToShape.Parents.Remove(FromShape);

    FToShape:=Value;

    if Assigned(FromShape) and Assigned(ToShape) then
       ToShape.Parents.Add(FromShape);
  end;
end;

procedure TTreeConnection.SetBorder(const Value : TTreeConnectionPen);
begin
  if Assigned(Value) then Border.Assign(Value)
                     else FreeAndNil(FBorder);
end;

procedure TTreeConnection.SetFormat(const Value : TConnectionFormat);
begin
  if Assigned(Value) then Format.Assign(Value)
                     else FreeAndNil(FFormat);
end;

Function TTreeConnection.Visible:Boolean;
begin
  // if the From and To shapes are visible ...
  result:= Assigned(FromShape) and Assigned(ToShape) and
           FromShape.Visible and ToShape.Visible;
end;

// Draw connection
Function TTreeConnection.Draw:Boolean;
begin
  result:=True;

  if Visible then
    // use manager to draw connection line(s)...
    if Style=csAuto then
    begin
      if Assigned(Tree) and Assigned(Tree.GlobalFormat.ChildManager) then
         result:=Tree.GlobalFormat.ChildManager.DrawConnection(Self)
    end
    else
       InternalDraw;
end;

Procedure TTreeConnection.GetCurvePoints(Var P:TCurvePoints);
var t      : Integer;
    tmpNum : Integer;
begin
  tmpNum:=Points.Count;

  with Points do
  for t:=0 to tmpNum-1 do
      P[t]:=Tree.Canvas.Calculate3DPosition(Item[t].X,Item[t].Y,TeeTreeZ);
end;

Procedure TTreeConnection.PrepareCanvas;
var tmpPen : TTreePen;
begin
  // use local or global connection border pen...
  tmpPen:=FBorder;

  if not Assigned(tmpPen) then
     tmpPen:=Tree.GlobalFormat.Connection.Border;

  with Tree do
  begin
    Canvas.AssignVisiblePen(tmpPen);
    Canvas.Brush.Style:=bsClear;
  end;
end;

Procedure TTreeConnection.InternalDraw;
var tmpBounds : TRect;
    tmpNum    : Integer;
    tmpAngle  : Integer;
    t         : Integer;
    tmpX      : TCoordinate;
    tmpY      : TCoordinate;
    tmpCurve  : TCurvePoints;
    tmpX0     : TCoordinate;
    tmpY0     : TCoordinate;
    tmpX1     : TCoordinate;
    tmpY1     : TCoordinate;

    {$IFDEF FMX}
    P:TPathData;
    {$ENDIF}
begin

  tmpNum:=Length(Points.Item);

  if Style<>csAuto then
     if Style=csCurve then
     begin
       if tmpNum<4 then
       begin
         SetupPoints;  // If curve with less than 4 points, call Setup
         tmpNum:=Length(Points.Item);
       end;
     end
     else
     if tmpNum<2 then
     begin
       SetupPoints;   // If line with less than 2 points, call Setup
       tmpNum:=Length(Points.Item);
     end;

  if tmpNum=0 then exit;

  // Calculate XY pixel position for each connection point
  tmpNum:=Length(Points.Item);
  for t:=0 to Pred(tmpNum) do
  begin
    Points.CalculatePosition(t);

    if Style<>csAuto then
    with tmpBounds,Points.Item[t] do
    begin
      if t=0 then
      begin
        Left:=X;
        Right:=X;
        Top:=Y;
        Bottom:=Y;
      end
      else
      begin
        if X<Left then Left:=X else if X>Right then Right:=X;
        if Y<Top then Top:=Y else if Y>Bottom then Bottom:=Y;
      end;
    end;

    IBounds := tmpBounds;
  end;

  if (Style=csAuto) or Intersect(tmpBounds,Tree.IBounds2D) then
  begin
    PrepareCanvas;

    // Draw lines
    With Tree.Canvas do
    begin
      if Style=csCurve then // curve lines (bezier)
      begin
        GetCurvePoints(tmpCurve);

        // Curves need 4 points, or more than 4 in groups of 3
        if tmpNum>4 then
        while (tmpNum-4) mod 3<>0 do
        begin
          tmpCurve[tmpNum]:=tmpCurve[tmpNum-1];
          Inc(tmpNum);
        end;

       { for t := 0 to tmpNum do begin
          tmpCurve[t].X := tmpCurve[t].X + Tree.ChartBounds.Left;
          tmpCurve[t].Y := tmpCurve[t].Y + Tree.ChartBounds.Top;
        end;  }

        {$IFDEF FMX}
        P:=TPathData.Create;
        try
          //P.SmoothCurveTo();
          ReferenceCanvas.DrawPath(P,1);
        finally
          P.Free;
        end;
        {$ELSE}
        PolyBezier(Handle,tmpCurve,tmpNum);
        {$ENDIF}
      end
      else  // draw lines...
      with Points do
      if tmpNum>1 then
      begin
        tmpX:=Item[0].X;
        tmpY:=Item[0].Y;

        MoveTo3D(tmpX,tmpY,TeeTreeZ);  // first point

        for t:=1 to Pred(tmpNum) do // rest of points
        with Item[t] do
        begin
          Case Style of
            csSides          : begin
                                 LineTo3D(tmpX,Y,TeeTreeZ);
                                 if tmpX<>X then LineTo3D(X,Y,TeeTreeZ);
                                end;

            csInvertedSides  : begin
                                 LineTo3D(X,tmpY,TeeTreeZ);
                                 if tmpY<>Y then LineTo3D(X,Y,TeeTreeZ);
                               end;
          else
            LineTo3D(X,Y,TeeTreeZ);
          end;

          tmpX:=X;
          tmpY:=Y;
        end;
      end;
    end;

    // Draw Arrows

    if tmpNum>1 then
    begin
      tmpX1:=Points.Item[1].X;
      tmpY1:=Points.Item[1].Y;
      tmpX0:=Points.Item[0].X;
      tmpY0:=Points.Item[0].Y;

      Case Style of
        csSides         : tmpX1:=tmpX0;
        csInvertedSides : tmpY1:=tmpY0;
      end;

      tmpAngle:=Round(ArcTan2((tmpX1-tmpX0),(tmpY1-tmpY0))*180.0/pi)
    end
    else
      tmpAngle:=0;

    With InternalArrowFrom do
    if Style<>casNone then
       Draw(Points.Item[0],270-tmpAngle);

    t:=tmpNum-1;  // last point index

    if t>0 then
    begin
      tmpX1:=Points.Item[t].X;
      tmpY1:=Points.Item[t].Y;
      tmpX0:=Points.Item[t-1].X;
      tmpY0:=Points.Item[t-1].Y;

      Case Style of
        csSides         : tmpY0:=tmpY1;
        csInvertedSides : tmpX0:=tmpX1;
      end;

      tmpAngle:=Round(ArcTan2((tmpX1-tmpX0),(tmpY1-tmpY0))*180.0/pi)
    end
    else
      tmpAngle:=0;

    With InternalArrowTo do
    if Style<>casNone then
       Draw(Points.Item[t],90-tmpAngle);

    if FText <> nil then
       if FText.Angle <> 0 then
          tmpAngle := FText.Angle;

    Dec(tmpAngle,90);

    if ((tmpAngle<-90) and (tmpAngle>-180)) or
       ((tmpAngle<-180) and (tmpAngle>-270)) then
         Inc(tmpAngle,180);

    DrawText(tmpAngle);
  end;
end;

// Display connection text over the connection line
procedure TTreeConnection.DrawText(Angle:Integer);
var tmpX : TCoordinate;
    tmpY : TCoordinate;

  Procedure CalcTextPosition;
  var tmpA : TConnectionPoint;
      tmpB : TConnectionPoint;
      tmpL : Integer;
  begin
    with Points do
    begin
      // use the last and previous connection points positions
      // to calculate text XY position...

      tmpL := Length(Item) div 2;
      tmpB:=Item[tmpL];

      if tmpL>0 then tmpA:=Item[Pred(tmpL)]
                else tmpA:=Item[0];

      // Calculate X  pixel position
      Case Self.HorizTextAlign of
        htaCenter: tmpX:=tmpA.X+((tmpB.X-tmpA.X) {$IFDEF FMX}*0.5{$ELSE}div 2{$ENDIF});
        htaLeft  : tmpX:=tmpA.X;
      else
        { htaRight } tmpX:=tmpB.X;
      end;

      // Calculate X  pixel position
      Case Self.VertTextAlign of
        vtaCenter: tmpY:=tmpA.Y+((tmpB.Y-tmpA.Y) {$IFDEF FMX}*0.5{$ELSE}div 2{$ENDIF});
        vtaTop   : tmpY:=tmpA.Y;
      else
        { vtaBottom } tmpY:=tmpB.Y;
      end;
    end;
  end;

  procedure DrawTextBackground(tmpCount,tmpOffX,tmpOffY:Integer);
  var
    tmpA     : Integer;
    tmpW     : Integer;
    tmpX2    : TCoordinate;
    tmpY2    : TCoordinate;
    t        : Integer;
    tmpS     : String;
    tmpBound : TRect;
  begin
    tmpW:=0;

    for t:=0 to tmpCount-1 do
    begin
      if Assigned(FText) then
         tmpS:=FText[t]
      else
         tmpS:=FTextString;

      tmpW:=Max(tmpW,Tree.Canvas.TextWidth(tmpS));
    end;

    Inc(tmpW,Tree.Canvas.TextWidth(TeeCharForHeight));

    tmpX2:=tmpX+Tree.Canvas.View3DOptions.HorizOffset+tmpOffX;
    tmpY2:=tmpY+Tree.Canvas.View3DOptions.VertOffset+tmpOffY;

    tmpBound:=TeeRect(tmpX2-(tmpW div 2),tmpY2,
                      tmpX2+(tmpW div 2),
                      tmpY2+tmpCount*Tree.Canvas.TextHeight(TeeCharForHeight));

    tmpA:=Angle;
    while tmpA<0 do tmpA:=360+tmpA;

    Self.Format.Draw(Self.Tree,tmpBound,tmpA);
  end;

var t        : Integer;
    tmpH     : Integer;
    tmpS     : String;
    tmpCount : Integer;
    tmpOffX  : Integer;
    tmpOffY  : Integer;
    isVisible: Boolean;
begin
  tmpCount:=TextLinesCount;
  isVisible:=(not Assigned(FText)) or FText.Visible;

  if (tmpCount>0) and isVisible then
  With Tree.Canvas do
  begin
    TextAlign:=TA_CENTER;

    // Select Font into Tree Canvas (prepare canvas to output text)
    AssignFont(InternalFont);

    BackMode:=cbmTransparent;

    CalcTextPosition;  // calculate XY pixel position

    if Assigned(FText) then
    begin
      tmpOffX:=FText.FHorizOffset;
      tmpOffY:=FText.FVertOffset;
    end
    else
    begin
      tmpOffX:=0;
      tmpOffY:=0;
    end;

    // Draw Text
    tmpH:=TextHeight(TeeCharForHeight);

    if Assigned(Self.FFormat) and Self.Format.Visible
       and (not Self.Format.Transparent) then
           DrawTextBackground(tmpCount,tmpOffX,tmpOffY);

    for t:=0 to tmpCount-1 do
    begin
      if Assigned(FText) then
         tmpS:=FText[t]
      else
         tmpS:=FTextString;

      if Angle=0 then
         TextOut3D({$IFDEF FMX}Round{$ENDIF}(tmpX+tmpOffX),
                   {$IFDEF FMX}Round{$ENDIF}(tmpY+tmpOffY),
                   TeeTreeZ,tmpS)

      else
         RotateLabel3D({$IFDEF FMX}Round{$ENDIF}(tmpX+tmpOffX),
                       {$IFDEF FMX}Round{$ENDIF}(tmpY+tmpOffY),
                       TeeTreeZ,tmpS,Angle,False);

      {$IFDEF FMX}
      tmpY:=tmpY+tmpH;
      {$ELSE}
      Inc(tmpY,tmpH);
      {$ENDIF}
    end;
  end;
end;

// When the XY pixel position is "near" to one
// of the connection line segments, returns the segment index
// starting from zero. Returns -1 otherwise.
//
// For curved lines, it returns -1 or 0 only.
Function TTreeConnection.ClickedSegment(x,y:Integer):Integer;
var P : TPoint;

  Function CheckSegment(const x1,y1,x2,y2:TCoordinate):Boolean;
  begin
    result:=False;

    if x1=x2 then
    begin
      if Abs(x-x1)<=TeeLineClickTolerance then
         if y1<y2 then result:=(y>=y1) and (y<=y2)
                  else result:=(y>=y2) and (y<=y1);
    end
    else
    if y1=y2 then
    begin
      if Abs(y-y1)<=TeeLineClickTolerance then
         if x1<x2 then result:=(x>=x1) and (x<=x2)
                  else result:=(x>=x2) and (x<=x1);
    end
    else
      result:=PointInLine(P,x1,y1,x2,y2,TeeLineClickTolerance);
  end;

const
   NumPoints = 10;  //change to get better accuracy, but decreasing speed

var t,
    AvailablePoints,
    StartPos  : Integer;

    P1 : TPoint;
    P2 : TPoint;

    tmpCurve : TCurvePoints;
    tmpResult : Boolean;

    mu, mu3, mum1, mum12, mum13, mu2   : Double;
begin
  result:=-1;

  if Visible then
  begin
    Tree.Canvas.Calculate2DPosition(x,y,TeeTreeZ);
    P:=TeePoint(x,y);

    tmpResult:=False;

    if Style=csCurve then  // is XY inside polygon of points ?
    begin
      GetCurvePoints(tmpCurve);

      for t:= 0 to High(tmpCurve) do
          {$IFDEF FMX}
          Calc2DPos(Tree.Canvas,tmpCurve[t]);
          {$ELSE}
          Tree.Canvas.Calculate2DPosition(tmpCurve[t].x,tmpCurve[t].y,TeeTreeZ);
          {$ENDIF}

      StartPos := 0;

      while not tmpResult and (StartPos < Points.Count-1) do
      begin
        P1 := tmpCurve[StartPos];
        AvailablePoints := Points.Count - StartPos;
        t := 1;

        while not tmpResult and (t<=numpoints) do
        begin
          mu:=t/numpoints;
          mu2:=Sqr(mu);
          mu3:=mu2*mu;
          mum1:=1-mu;
          mum12:=Sqr(mum1);
          mum13:= mum12*mum1;

          if AvailablePoints > 3 then // Cubic
          begin
             P2.X := Round( mum13*tmpCurve[StartPos].x
                            + 3*mu*mum12*tmpCurve[StartPos+1].x
                            + 3*mu2*mum1*tmpCurve[StartPos+2].x
                            + mu3* tmpCurve[StartPos+3].x );

            P2.Y := Round( mum13*tmpCurve[StartPos].y
                           + 3*mu*mum12*tmpCurve[StartPos+1].y
                           + 3*mu2*mum1*tmpCurve[StartPos+2].y
                           + mu3* tmpCurve[StartPos+3].y );
          end
          else
          if AvailablePoints > 2 then // Quadratic
          begin
            P2.X := Round( mum13*tmpCurve[StartPos].x         // Windows way
                           + 3*mu*mum12*tmpCurve[StartPos+1].x
                           + 3*mu2*mum1*tmpCurve[StartPos+2].x
                           + mu3* tmpCurve[StartPos+2].x );

            P2.Y := Round( mum13*tmpCurve[StartPos].y
                           + 3*mu*mum12*tmpCurve[StartPos+1].y
                           + 3*mu2*mum1*tmpCurve[StartPos+2].y
                           + mu3* tmpCurve[StartPos+2].y );

          end
          else
          begin
            // Linear
            P2.x := tmpCurve[StartPos+1].x;
            P2.y := tmpCurve[StartPos+1].y;
          end;

          tmpResult:= CheckSegment(P1.X,P1.Y,P2.X,P2.Y);

          Inc(t);
          P1 := P2;

          if tmpResult then
          begin
            result:=t;
            break;
          end;
        end;

        if AvailablePoints > 3 then
           StartPos := StartPos + 3
        else
        if AvailablePoints > 2 then
           StartPos := StartPos + 2
        else
           StartPos := StartPos + 1;
      end;

    end
    else
    // is XY over any line ?
    for t:=0 to High(Points.Item)-1 do
    begin
      P1.X:=Points.Item[t].X;
      P1.Y:=Points.Item[t].Y;
      P2.X:=Points.Item[t+1].X;
      P2.Y:=Points.Item[t+1].Y;

      Case Style of
        csAuto,
        csLine          : tmpResult:=CheckSegment(P1.X,P1.Y,P2.X,P2.Y);
        csSides         : tmpResult:=CheckSegment(P1.X,P1.Y,P1.X,P2.Y) or
                                     CheckSegment(P1.X,P2.Y,P2.X,P2.Y);
        csInvertedSides : tmpResult:=CheckSegment(P1.X,P1.Y,P2.X,P1.Y) or
                                     CheckSegment(P2.X,P1.Y,P2.X,P2.Y);
      end;

      if tmpResult then
      begin
        result:=t;
        break;
      end;
    end;
  end;
end;

// Returns True when the XY pixel position is "near" to one
// of the connection line segments.
Function TTreeConnection.Clicked(x,y:Integer):Boolean;
begin
  result:=ClickedSegment(x,y)<>-1;
end;

function TTreeConnection.InternalArrowFrom: TConnectionArrow;
begin
  if Assigned(FArrowFrom) then
     result:=FArrowFrom
  else
  begin
    result:=Tree.GlobalFormat.Connection.ArrowFrom;
    result.IOwner:=Self;
  end;
end;

function TTreeConnection.InternalArrowTo: TConnectionArrowTo;
begin
  if Assigned(FArrowTo) then
     result:=FArrowTo
  else
  begin
    result:=Tree.GlobalFormat.Connection.ArrowTo;
    result.IOwner:=Self;
  end;
end;

{ TNodeConnectionList }

// Returns True if the XY pixel position is "near" any connection line
Function TNodeConnectionList.Clicked(x,y:Integer):TTreeConnection;
var t : Integer;
begin
  if Visible then
  for t:=0 to Count-1 do
  if Items[t].Clicked(x,y) then
  begin
    result:=Items[t];
    Exit;
  end;

  result:=nil;
end;

// Removes (not destroys) AConnection from the list
Function TNodeConnectionList.DeleteConnection(const AConnection:TTreeConnection):Boolean;
begin
  if Assigned(AConnection.Tree) then
     AConnection.Tree.Invalidate;

  Remove(AConnection);

  result:=True;
end;

{ TTreeConnectionList }

Constructor TTreeConnectionList.Create;
begin
  inherited Create;
  FControlVector := TTreeConnectionPen.Create(nil);
end;

Destructor TTreeConnectionList.Destroy;
begin
  FControlVector.Free;
  inherited Destroy;
end;

// Calls the OnDeleting event and removes (not destroys) AConnection from the list
Function TTreeConnectionList.DeleteConnection(const AConnection:TTreeConnection):Boolean;
begin
  result:=True;

  if Assigned(FOnDeleting) then
     FOnDeleting(AConnection,result);

  if result then
  begin
    if Selected=AConnection then
       Selected:=nil;

    result:=inherited DeleteConnection(AConnection);
  end;
end;

Function TNodeConnectionList.GetConnection(Index:Integer):TTreeConnection;
begin
  result:=TTreeConnection(List[Index]);
end;

// Returns the first connection component that connects to AShape node
Function TNodeConnectionList.ToShape(const AShape:TTreeNodeShape):TTreeConnection;
var t : Integer;
begin
  for t:=0 to Count-1 do
  if Items[t].ToShape=AShape then
  begin
    result:=Items[t];
    Exit;
  end;

  result:=nil;
end;

// Global Visible property.
Procedure TNodeConnectionList.SetVisible(Value:Boolean);
begin
  if FVisible<>Value then
  begin
    FVisible:=Value;

    if Count>0 then
       Items[0].Repaint;
  end;
end;

// Calls Proc procedure for each connection in list
procedure TNodeConnectionList.ForEach(const Proc: TConnListForEachProc);
var t : Integer;
begin
  for t:=0 to Count-1 do
      Proc(Items[t]);
end;

// Removes (destroys) all connections that point to AShape node
procedure TNodeConnectionList.DeleteAllTo(const AShape: TTreeNodeShape);
var t : Integer;
begin
  t:=0;

  While t<Count do
  if GetConnection(t).ToShape=AShape then
     GetConnection(t).{$IFDEF AUTOREFCOUNT}DisposeOf{$ELSE}Free{$ENDIF}
  else
     Inc(t);
end;

procedure TTreeConnectionList.DrawMagnetic;
begin
  if FMagneticHandle<>rcNone then // at magnetic point handle...
  begin
    with ITree.Canvas do
    begin
      Brush.Style:=bsClear;
      Pen.Color:=clRed;
    end;

    with FMagneticPos do
         ITree.Canvas.EllipseWithZ(X-12,Y-12,X+12,Y+12,TeeTreeZ);
  end;
end;

procedure TTreeConnectionList.SetSelected(const Value: TTreeConnection);
begin
  if FSelected<>Value then
  begin
    if Assigned(FSelected) then
    begin
      FSelected:=nil;

      if Assigned(ITree.FOnUnSelectConnection) and (not ITree.Destroying) then
         ITree.FOnUnSelectConnection(FSelected);
    end;

    FSelected:=Value;

    if Assigned(FSelected) then
       ITree.DoSelectConnection(FSelected);

    ITree.Invalidate;
  end;
end;

{ TNodeShapeList }

function TNodeShapeList.Add(const Node: TTreeNodeShape): Integer;
begin
  result:=inherited Add(Node);
end;

function TNodeShapeList.Clicked(x, y: Integer): TTreeNodeShape;
var t : Integer;
begin
  for t:=Count-1 downto 0 do
  begin
    result:=GetShape(t);

    if result.Clicked(X,Y) then
       Exit;
  end;

  result:=nil;
end;

Function TNodeShapeList.Find(Const S:String; Partial:Boolean=False):TTreeNodeShape;
var t : Integer;
begin
  for t:=0 to Count-1 do
  if ((not Partial) and (Items[t].SimpleText=S)) or
     ((Partial) and (Pos(S,Items[t].SimpleText)>0)) then
  begin
    result:=Items[t];
    exit;
  end;

  result:=nil;
end;

function TNodeShapeList.FindObject(const Value: TObject): TTreeNodeShape;
var t : Integer;
begin
  for t:=0 to Count-1 do
  if Items[t].Data=Value then
  begin
    result:=Items[t];
    exit;
  end;

  result:=nil;
end;

function TNodeShapeList.First: TTreeNodeShape;
begin
  result:=Items[0];
end;

// Calls Proc procedure for each node in the list
procedure TNodeShapeList.ForEach(const Proc: TNodeListForEachProc);
var t : Integer;
begin
  for t:=0 to Count-1 do
      Proc(Items[t]);
end;

// Returns Index'th node in the list
Function TNodeShapeList.GetShape(Index:Integer):TTreeNodeShape;
begin
  result:=TTreeNodeShape(List[Index]);
end;

function TNodeShapeList.Last: TTreeNodeShape;
begin
  result:=Items[Count-1];
end;

procedure TNodeShapeList.Sort(AscendingOrder, IgnoreCase: Boolean);

  Function CompareValueIndex(a,b:Integer):Integer;
  var tmpA : String;
      tmpB : String;
  begin
    if Assigned(ITree.FOnSortCompare) then
    begin
      result:=1;

      ITree.FOnSortCompare(Items[a],Items[b],result);
    end
    else
    begin
      tmpA:=Items[a].SimpleText;

      // TODO: Replace with "CompareText" and "CompareStr"

      if IgnoreCase then
         tmpA:=UpperCase(tmpA);

      tmpB:=Items[b].SimpleText;

      if IgnoreCase then
         tmpB:=UpperCase(tmpB);

      if tmpA<tmpB then
         result:=-1
      else
      if tmpA>tmpB then
         result:= 1
      else
         result:=0;

      if not AscendingOrder then
         result:=-result;
    end;
  end;

  procedure PrivateSort(l,r:Integer);
  var i : Integer;
      j : Integer;
      x : Integer;
      tmp : Integer;
  begin
    i:=l;
    j:=r;
    x:=(i+j) shr 1;

    while i<j do
    begin
      while CompareValueIndex(i,x)<0 do inc(i);
      while CompareValueIndex(x,j)<0 do dec(j);

      if i<j then
      begin
        tmp:=Items[i].FBrotherIndex;
        Items[i].FBrotherIndex:=Items[j].FBrotherIndex;
        Items[j].FBrotherIndex:=tmp;

        Exchange(i,j);

        if i=x then x:=j else if j=x then x:=i;
      end;

      if i<=j then
      begin
        inc(i);
        dec(j)
      end;
    end;

    if l<j then PrivateSort(l,j);
    if i<r then PrivateSort(i,r);
  end;

begin
  PrivateSort(0,Count-1);
  ITree.Invalidate;
end;

{ TTreeList }

// Modified Borland VCL TList. (Speed optimized)
Destructor TTreeList.Destroy;
begin
  Clear;
  inherited;
end;

function TTreeList.Add(const Item: TObject): Integer;
begin
  Result:=FCount;

  if Result=FCapacity then
  begin
    if IDelta=0 then IDelta:=4;
    SetCapacity(FCapacity + IDelta);
  end;

  FList^[Result] := Item;
  Inc(FCount);
end;

procedure TTreeList.Clear;
begin
  SetCount(0);
  SetCapacity(0);
end;

procedure TTreeList.Delete(Index: Integer);
begin
  Dec(FCount);

  if Index < FCount then
     System.Move(FList^[Index + 1], FList^[Index],(FCount - Index) * SizeOf(Pointer));
end;

procedure TTreeList.Exchange(Index1, Index2: Integer);
var Item: Pointer;
begin
  Item := FList^[Index1];
  FList^[Index1] := FList^[Index2];
  FList^[Index2] := Item;
end;

function TTreeList.IndexOf(const Item: TObject): Integer;
begin
  Result := 0;

  while (Result < FCount) and (FList^[Result] <> Item) do
    Inc(Result);

  if Result = FCount then
     Result := -1;
end;

procedure TTreeList.Insert(Index: Integer; const Item: TObject);
begin
  if FCount = FCapacity then
  begin
    if IDelta=0 then
       IDelta:=4;

    SetCapacity(FCapacity + IDelta);
  end;

  if Index < FCount then
     System.Move(FList^[Index], FList^[Index + 1],(FCount - Index) * SizeOf(Pointer));

  FList^[Index] := Item;
  Inc(FCount);
end;

procedure TTreeList.Move(CurIndex, NewIndex: Integer);
var Item : Pointer;
begin
  if CurIndex <> NewIndex then
  begin
    Item := FList^[CurIndex];
    FList^[CurIndex] := nil;
    Delete(CurIndex);
    Insert(NewIndex, nil);
    FList^[NewIndex] := Item;
  end;
end;

function TTreeList.Remove(const Item: TObject): Integer;
begin
  Result := IndexOf(Item);

  if Result >= 0 then
     Delete(Result);
end;

procedure TTreeList.SetCapacity(NewCapacity: Integer);
begin
  if NewCapacity <> FCapacity then
  begin
    ReallocMem(FList, NewCapacity * SizeOf(Pointer));
    FCapacity := NewCapacity;

    if FCapacity > 64 then
       IDelta := FCapacity div 4
    else
    if FCapacity > 8 then IDelta := 16
                     else IDelta := 4;
  end;
end;

procedure TTreeList.SetCount(NewCount: Integer);
begin
  if NewCount > FCapacity then
     SetCapacity(NewCount);

  if NewCount > FCount then
     FillChar(FList^[FCount], (NewCount - FCount) * SizeOf(Pointer), 0);

  FCount := NewCount;
end;

procedure TTreeConnection.DrawHandles;
var t    : Integer;
    tmp  : TColor;
    tmp2 : TColor;

  procedure DrawControlVector(t: integer);
  begin
    With Tree.Canvas do
    begin
      Brush.Color:=Tree.Connections.ControlVector.Color;
      Pen.Width:=Tree.Connections.ControlVector.Width;
      Pen.Style:=Tree.Connections.ControlVector.Style;
      Pen.Mode :=pmNotXor;

      MoveTo3D(Points.Item[t].X,Points.Item[t].Y,TeeTreeZ);
      LineTo3D(Points.Item[t+1].X,Points.Item[t+1].Y,TeeTreeZ);

      Pen.Mode:=pmCopy;
    end;
  end;

begin
  tmp:=Tree.Canvas.Brush.Color;

  for t:=0 to High(Points.Item) do
  with Points.Item[t] do
  begin
    Case XStyle of
      cpsAutoFrom,
      cpsAutoTo    : tmp2:=clBlue;
      cpsFromPercent,
      cpsFromRel   : tmp2:=clGreen;
      cpsToPercent,
      cpsToRel     : tmp2:=clRed;
    else
      tmp2:=tmp;
    end;

    Tree.Canvas.Brush.Color:=tmp2;
    Tree.DrawHandle(Self,rcCustom,X,Y);

    if Style = csCurve then
       if t+1 <= Points.Count-1 then
          DrawControlVector(t);
  end;
end;

{ TTreeNodeCrossBox }
Constructor TTreeNodeCrossBox.Create(const AOwner:TCustomTree);
begin
  inherited Create;

  FTree:=AOwner;

  FBrush:=TTreeBrush.Create(AOwner.CanvasChanged);

  FSignPen:=TTreePen.Create(AOwner.CanvasChanged);
  FSignPen.Color:=clBlack;

  {$IFNDEF FMX}
  FSignPen.Width:=0; // Thin GDI+ lines, without antialias
  {$ENDIF}

  FBorder:=TTreeCrossBoxPen.Create(AOwner.CanvasChanged);
  With FBorder do
  begin
    Style:=psSolid;

    {$IFNDEF FMX}
    Width:=0; // Thin GDI+ lines, without antialias
    {$ENDIF}

    Color:=clGray;
  end;

  FSize:=TeeDefaultBoxSize;
  FStyle:=cbsSquare;
  FVisible:=True;
end;

Destructor TTreeNodeCrossBox.Destroy;
begin
  FSignPen.Free;
  FBorder.Free;
  FBrush.Free;
  inherited;
end;

function TTreeNodeCrossBox.GetBackColor:TColor;
begin
  result:=Brush.BackColor;
end;

Procedure TTreeNodeCrossBox.SetBrush(const Value:TTreeBrush);
begin
  FBrush.Assign(Value);
end;

procedure TTreeNodeCrossBox.SetVisible(Value:Boolean);
begin
  FTree.SetBooleanProperty(FVisible,Value);
end;

Procedure TTreeNodeCrossBox.SetSignPen(const Value:TTreePen);
begin
  FSignPen.Assign(Value);
end;

Procedure TTreeNodeCrossBox.SetSignStyle(const Value:TTreeCrossSignStyle);
begin
  if FSignStyle<>Value then
  begin
    FSignStyle:=Value;
    FTree.Invalidate;
  end;
end;

procedure TTreeNodeCrossBox.SetSize(Value:Integer);
begin
  FTree.SetIntegerProperty(FSize,Value);
end;

procedure TTreeNodeCrossBox.SetBorder(const Value:TTreeCrossBoxPen);
begin
  FBorder.Assign(Value);
end;

Procedure TTreeNodeCrossBox.Assign(Source:TPersistent);
begin
  if Source is TTreeNodeCrossBox then
  With TTreeNodeCrossBox(Source) do
  begin
    Self.Border    :=FBorder;
    Self.Brush     :=FBrush;
    Self.FClickTolerance:=FClickTolerance;
    Self.SignPen   :=FSignPen;
    Self.FSignStyle:=FSignStyle;
    Self.FSize     :=FSize;
    Self.FStyle    :=FStyle;
  end;
end;

Procedure TTreeNodeCrossBox.Draw(Const AtPoint:TPoint; DrawExpanded:Boolean);
Var R       : TRect;
    tmpExtra : Integer;
    tmpSize : Integer;
    tmp     : TColor;
begin
  R.Left:=AtPoint.X-FSize;
  R.Top:=AtPoint.Y-FSize;
  R.Right:=AtPoint.X+FSize;
  R.Bottom:=AtPoint.Y+FSize;

  if Intersect(R,FTree.IBounds2D) then
  With FTree.Canvas do
  begin
    if Self.Brush.Style=bsSolid then
    begin
      tmp:=Self.Brush.Color;

      if tmp=clDefault then
         tmp:=clWhite;

      AssignBrush(Self.Brush,tmp);
    end
    else
      AssignBrush(Self.Brush,Self.BackColor);

    AssignVisiblePen(Self.Border);

    tmpSize:=FSize div 2;

    if FSignStyle=cssTriangle then
    begin
      Brush.Color:=Self.SignPen.Color;

      Inc(tmpSize);

      with AtPoint do
      if DrawExpanded then
         TriangleWithZ(TeePoint(X-tmpSize,Y-tmpSize),
                       TeePoint(X+tmpSize,Y-tmpSize),
                       TeePoint(X,Y+tmpSize),TeeTreeZ)
      else
         TriangleWithZ(TeePoint(X-tmpSize,Y-tmpSize),
                       TeePoint(X-tmpSize,Y+tmpSize),
                       TeePoint(X+tmpSize,Y),TeeTreeZ)
    end
    else
    begin
      Case Self.Style of
        cbsSquare  : RectangleWithZ(R,TeeTreeZ);
        cbsDiamond : FTree.DrawDiamond(R);
      else
        EllipseWithZ(R.Left,R.Top,R.Right,R.Bottom,TeeTreeZ);
      end;

      AssignVisiblePen(Self.SignPen);

      // GDI+ and FMX: 0,   GDI: 1
      {$IFDEF FMX}
      tmpExtra:=0;
      {$ELSE}
      // if Canvas.AntiAlias then
      //    tmpExtra:=0
      // else
            tmpExtra:=0;
      {$ENDIF}

      with AtPoint do
      begin
        // horizontal line
        HorizLine3D(X-tmpSize,X+tmpSize +tmpExtra,Y,TeeTreeZ);

        // vertical line
        if not DrawExpanded then
           VertLine3D(X,Y-tmpSize,Y+tmpSize +tmpExtra,TeeTreeZ);
      end;
    end;
  end;
end;

procedure TTreeNodeCrossBox.SetStyle(const Value: TTreeCrossBoxStyle);
begin
  if FStyle<>Value then
  begin
    FStyle:=Value;
    FTree.Invalidate;
  end;
end;

procedure TTreeNodeCrossBox.SetBackColor(const Value: TColor);
begin
  Brush.BackColor:=Value;
end;

// Called when child node "AShape" is destroyed.
Procedure TTreeNodeShape.RemoveChild(const AShape:TTreeNodeShape);
var t : Integer;
begin
  // Reset BrotherIndex for all Children nodes
  for t:=AShape.BrotherIndex+1 to Count-1 do
      Dec(Children[t].FBrotherIndex);

  AShape.FBrotherIndex:=-1;

  // remove AShape from children list
  Children.Remove(AShape);

  // destroy all connections to AShape
  if Assigned(FConnections) then
     FConnections.DeleteAllTo(AShape);
end;

Procedure TTreeNodeShape.SetSelected(Value:Boolean);
begin
  if FSelected<>Value then
  begin
    FSelected:=Value;

    if Assigned(Tree) then
       if FSelected then Tree.Selected.Add(Self)
                    else Tree.Selected.Remove(Self);
  end;
end;

Function TTreeNodeShape.CalcXYCross(const AParent:TTreeNodeShape):TPoint;
begin
  result:=Tree.GlobalFormat.ChildManager.CalcXYCross(Self,AParent);
end;

Function TTreeNodeShape.IsPositionLeftStored:Boolean;
begin
  result:=not AutoPositionLeft or not AutoSize;
end;

Function TTreeNodeShape.IsPositionTopStored:Boolean;
begin
  result:=not AutoPositionTop or not AutoSize;
end;

// Stores into Stream all Tree nodes and nodes children text.
// If Node parameter is assigned, then stores Node and node children text only.
Function SaveTreeTextToStream(const Stream:TStream; const Tree:TCustomTree; const Node:TTreeNodeShape=nil):TStream;

  Procedure WriteNodeText(const ANode:TTreeNodeShape; Const Indent:String);
  var t     : Integer;
      tmpS  : String;
      tmpS2 : String;
  begin
    tmpS:=ANode.SimpleText;

    if tmpS='' then
       tmpS:=ANode.Name;

    tmpS2:=Indent+tmpS+#13#10;

    Stream.Write(Pointer(tmpS2)^,Length(tmpS2)*SizeOf(Char));

    for t:=0 to ANode.Children.Count-1 do
        WriteNodeText(ANode.Children[t],Indent+' ');
  end;

var t : Integer;
begin
  result:=Stream;

  if Assigned(Node) then
     WriteNodeText(Node,'')
  else
  if Assigned(Tree) then
     for t:=0 to Tree.Roots.Count-1 do
         WriteNodeText(Tree.Roots[t],'');
end;

Procedure SaveTreeToTextFile(const Tree:TCustomTree; Const FileName:String);
begin
  SaveTreeTextToStream(TFileStream.Create(FileName,fmCreate),Tree).{$IFDEF AUTOREFCOUNT}DisposeOf{$ELSE}Free{$ENDIF};
end;

Procedure SaveTreeToTextFile(const Node:TTreeNodeShape; Const FileName:String);
begin
  SaveTreeTextToStream(TFileStream.Create(FileName,fmCreate),nil,Node).{$IFDEF AUTOREFCOUNT}DisposeOf{$ELSE}Free{$ENDIF};
end;

const
  TreeImageName:Array[TTreeNodeImageIndex] of String=
    ('','TreeFldClose','TreeFldOpen','TreeDesktop','TreeMyPc','TREENETWORKNEI',
      'TREEFLOPPY3','TREERECYCLEBIN','TREEHARDDISK','TREENETSHARE','TREECOMPUTER',
      'TREEWORLD','','TREEFLDCLOSECHECKED','TREEFLDCLOSEUNCHECK' ,
      'TREECHECKED', 'TREEUNCHECKED', 'TREERADIOCHECKED','TREERADIOUNCHECKED',
      'TREEFLDRADIOCHECKED','TREEFLDRADIOUNCHECKED');


{ TTreeImagePool }

Constructor TTreeImagePool.Create;
begin
  inherited;
  SetLength(FImages,Ord(High(TTreeNodeImageIndex))+1);
end;

Function TTreeImagePool.GetImage(Index:Integer):TPicture;
var tmp : TTreeNodeImageIndex;
begin
  result:=FImages[Index];

  if not Assigned(result) then
  begin
    tmp:=TTreeNodeImageIndex(Index);

    if tmp<>tiFolderOpenClose then
    begin
      FImages[Index]:=TPicture.Create;

      with FImages[Index] do
      begin
        {$IFDEF FMX}
        TeeLoadBitmap(Bitmap,TreeImageName[tmp]);
        {$ELSE}

        Bitmap.LoadFromResourceName(HInstance,TreeImageName[tmp]);

        Graphic.Transparent:=True;
        Bitmap.TransparentColor:=Bitmap.Canvas.Pixels[0,0];

        {$ENDIF}
      end;

      result:=FImages[Index];
    end;
  end;
end;

Function TTreeImagePool.Add(const Picture:TPicture):TTreeNodeImageIndex;
var tmp : Integer;
begin
  tmp:=Length(FImages);
  SetLength(FImages,tmp+1);

  FImages[tmp]:=TPicture.Create;
  FImages[tmp].Assign(Picture);

  result:=TTreeNodeImageIndex(tmp);  // forced out-of-bound
end;

Function TTreeImagePool.Add(const FileName:String):TTreeNodeImageIndex;
var tmp : Integer;
begin
  tmp:=Length(FImages);
  SetLength(FImages,tmp+1);

  FImages[tmp]:=TPicture.Create;
  FImages[tmp].LoadFromFile(FileName);

  result:=TTreeNodeImageIndex(tmp);  // forced out-of-bound
end;

Destructor TTreeImagePool.Destroy;
var t : Integer;
begin
  for t:=0 to Length(FImages)-1 do
      if Assigned(FImages[t]) then
         FImages[t].Free;

  FImages:=nil;
  inherited;
end;

function TTreeImagePool.Count: Integer;
begin
  result:=Length(FImages);
end;

procedure TTreeNodeShape.SortChildsText(AscendingOrder,IgnoreCase:Boolean);
begin
  Children.Sort(AscendingOrder,IgnoreCase);
end;

procedure TTreeNodeShape.SetShowCross(Value:TTreeNodeShapeShowCross);
begin
  if FShowCross<>Value then
  begin
    FShowCross:=Value;
    CanvasChanged(Self);
  end;
end;

procedure TTreeNodeShape.SetImageIndex(Value:TTreeNodeImageIndex);
begin
  {$IFOPT R+}
  if (Ord(Value)<0) or (Ord(Value)>=TreeImagePool.Count) then
     Value:=tiNone;
  {$ENDIF}

  if FImageIndex<>Value then
  begin
    FImageIndex:=Value;

    if not (csLoading in ComponentState) then
      if Value=tiNone then
      begin
        if Assigned(FImage) then
           FImage.Graphic:=nil;
      end
      else
      begin
        FImageListIndex:=-1;
        FreeAndNil(FImage);
      end;

    RecalcImageSize;
    CanvasChanged(Self);
  end;
end;

procedure TTreeNodeShape.SetImageListIndex(const Value:Integer);
begin
  if FImageListIndex<>Value then
  begin
    FImageListIndex:=Value; // just set the variable. Do not free FImage.
    FreeAndNil(FImage);

    RecalcImageSize;

    FImageListIndex:=Value; //TV52015206: This resets the ImageListIndex
    CanvasChanged(Self);
  end;
end;

Function TTreeNodeShape.DoExpandCollapse(Value:Boolean):Integer;
begin
  if Assigned(Tree) then
     result:=Tree.DoExpandCollapse(Self,Value)
  else
  begin
    FExpanded:=Value;
    result:=0;
  end;
end;

// Call the OnMouseEnter event if assigned
Procedure TTreeNodeShape.DoMouseEnter(Shift: TShiftState; X, Y: Integer);
begin
  IMouseInside:=True;

  if Assigned(FOnMouseEnter) then
     FOnMouseEnter(Self,Shift,X,Y);

  if Assigned(Tree.FOnMouseEnterShape) then
     Tree.FOnMouseEnterShape(Self,Shift,X,Y);

  if Tree.HotTrack.Active and (not Tree.Designing) then
     Tree.Invalidate;
end;

// Call the OnMouseLeave event if assigned
Procedure TTreeNodeShape.DoMouseLeave(Shift: TShiftState; X, Y: Integer);
begin
  IMouseInside:=False;

  if Assigned(FOnMouseLeave) then
     FOnMouseLeave(Self,Shift,X,Y);

  if Assigned(Tree.FOnMouseLeaveShape) then
     Tree.FOnMouseLeaveShape(Self,Shift,X,Y);

  if Tree.HotTrack.Active and (not Tree.Designing) then
     Tree.Invalidate;
end;

// Call the OnMouseMove event if assigned
Procedure TTreeNodeShape.DoMouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(FOnMouseMove) then
     FOnMouseMove(Self,Shift,X,Y);
end;

// Returns True when the node Image should be stored.
// It returns False when the ImageIndex property is not "none",
// or when the ImageListIndex property is not -1.
Function TTreeNodeShape.IsImageStored:Boolean;
begin
  result:=Assigned(FImage) and (FImageIndex=tiNone) and (FImageListIndex=-1);
end;

Procedure TTreeNodeShape.SetExpanded(Value:Boolean);
begin
  if FExpanded<>Value then
     DoExpandCollapse(Value);
end;

// Adds and returns a new connection component, from Self to AToShape node.
// Fast internal version.
Function TTreeNodeShape.InternalAddConnection(const AToShape:TTreeNodeShape):TTreeConnection;

  Procedure InternalSetName;
  begin
    result.Name:=Name+'_'+AToShape.Name;
  end;

begin
  // Create Connection object:
  if Assigned(Tree) and Tree.NoOwnerShapes then
     result:=Tree.GlobalFormat.ConnectionClass.Create(nil)
  else
  begin
    result:=TTreeConnection.Create(Owner);
    InternalSetName; // optimized. to avoid LStrClr
  end;

  if Assigned(Tree) and Tree.AssignParent then
  begin
    // Set connection Style default to existing connections, if any
    if Assigned(FConnections) and (FConnections.Count>0) then
       result.FStyle:=FConnections[0].Style
    else
    // set Style to Parent Connection style, if any
    if Assigned(Parent) and Assigned(Parent.FConnections) and
      (Parent.FConnections.Count>0) then
         result.FStyle:=Parent.FConnections[0].Style;
  end;

  Connections.Add(result); // add to local node's connection list

  With result do
  begin
    // Set the important properties

    // optimization. Set From and To properties directly to avoid
    // calling unnecessary code.
    FFromShape:=Self;
    FToShape:=AToShape;

    if Assigned(FToShape.FParents) then
       FToShape.FParents.Add(Self)  // use Parents list
    else
    if Assigned(FToShape.IParents0) then
       FToShape.Parents.Add(Self)  // force creating Parents list
    else
       FToShape.IParents0:=Self;  // optimization: do not create Parents list

    // Set Tree (optimized)
    FTree:=Self.Tree;
    FChildren.ITree:=FTree;
  end;

  if Assigned(Tree) then
  with Tree do
  begin
    Connections.Add(result); // add to global Tree Connections list

    // Call OnNewConnection event (if assigned)
    if Assigned(FOnNewConnection) then
       FOnNewConnection(Tree,result);

    // Finally, repaint Tree
    Invalidate;
  end;
end;

// Adds and returns a new connection component, from Self to AToShape node.
// Public version. First checks if there is already a connection to AToShape.
//
// If the OnAddingConnection Tree event is used, call it to give the
// oportunity to NOT create the new connection.
Function TTreeNodeShape.AddConnection(const AToShape:TTreeNodeShape):TTreeConnection;
var tmpOk : Boolean;
begin
  if Assigned(FConnections) then
     result:=FConnections.ToShape(AToShape)
  else
     result:=nil;

  if not Assigned(result) then
  begin
    tmpOk:=True;

    if Assigned(Tree) and Assigned(Tree.FOnAddingConn) then
       Tree.FOnAddingConn(Self,AToShape,tmpOk);

    if tmpOk then
       result:=InternalAddConnection(AToShape);
  end;
end;

// Select all childs ( set Selected to True )
Procedure TTreeNodeShape.SelectChilds;
var t : Integer;
begin
  for t:=0 to Children.Count-1 do
  With Children[t] do
  begin
    Selected:=True;
    SelectChilds;
  end;
end;

// Returns the top-most Root node that is parent of self
Function TTreeNodeShape.GetRoot:TTreeNodeShape;
begin
  result:=Self;

  While Assigned(result.Parent) do
        result:=result.Parent;
end;

// Returns True when the XY point is inside the node "cross-box"
Function TTreeNodeShape.CrossBoxClicked(x,y:Integer):Boolean;
var P       : TPoint;
    tmp     : Integer;
    tmpSize :  TCoordinate;
begin
  if Tree.CrossBox.Visible and Visible and ShouldDrawCross then
  begin
    With Tree.CrossBox do
         tmpSize:=ClickTolerance+Border.Width+Size;

    tmp:=Round( Tree.View3DOptions.Zoom*tmpSize*0.01 );

    P:=CalcXYCross(Parent);

    result:=PointInRect(TeeRect(P.X-tmp,P.Y-tmp,P.X+tmp,P.Y+tmp),x,y);
  end
  else
    result:=False;
end;

// Changes the node Parent property.
Procedure TTreeNodeShape.SetParent(const Value:TTreeNodeShape);
begin
  // Check circular relationship
  if (Value<>Self) and (Parent<>Value) and
     ( (not Assigned(Value)) or (Value.Parent<>Self) ) then
  begin
    if Assigned(Parent) then
       Parent.RemoveChild(Self);

    FParent:=Value;

    if Assigned(Parent) then
    begin
      FBrotherIndex:=Parent.Children.Add(Self);

      if not Assigned(Tree) then
         FTree:=Parent.Tree;

      if Assigned(Tree) then
         Tree.Roots.Remove(Self);

      Visible:=Parent.Expanded;
    end
    else
    begin
      if Assigned(Tree) then
         Tree.Roots.Add(Self);

      FBrotherIndex:=-1;
      Visible:=True;
    end;

    CanvasChanged(Self);
  end;
end;

// Adds a new node with same parent
Function TTreeNodeShape.AddBrother(Const AText:String):TTreeNodeShape;
begin
  if Assigned(Parent) then result:=Parent.AddChild(AText)
                      else result:=nil;
end;

// Returns the number of expanded children nodes, recursively
Function TTreeNodeShape.RecursiveCountExpanded:Integer;
var t : Integer;
begin
  result:=1;

  for t:=0 to Children.Count-1 do
  With Children[t] do
       if Expanded then
          Inc(result,RecursiveCountExpanded);
end;

// Returns True when the node has child nodes.
Function TTreeNodeShape.HasChilds:Boolean;
begin
  result:=Children.Count>0;
end;

// Returns True when the node has child nodes.
Function TTreeNodeShape.HasChildren:Boolean;
begin
  result:=Children.Count>0;
end;

// Sets Visible to False
procedure TTreeNodeShape.Hide;
begin
  Visible:=False;
end;

// Sets Visible to True
procedure TTreeNodeShape.Show;
begin
  Visible:=True;
end;

// Returns the node "level" ( 0 = Root node )
Function TTreeNodeShape.Level:Integer;
begin
  if Assigned(Parent) then
     result:=Succ(Parent.Level)
  else
     result:=0;
end;

// Returns the corresponding Cursor when the mouse is over a
// "handle" (small point at XY position), if any.
function TTreeNodeShape.GetHandleCursor(x,y:Integer):TCursor;
begin
  Case GetResizingHandle(x,y) of
    rcLeftTop,rcRightBottom : result:=crSizeNWSE;
    rcLeftBottom,rcRightTop : result:=crSizeNESW;
    rcLeft,rcRight          : result:=crSizeWE;
    rcBottom,rcTop          : result:=crSizeNS;
  else result:=crDefault;
  end;
end;

// Returns the lowest "Top" coordinate of recursively expanded children
Function TTreeNodeShape.MinHeightExpandedChilds: TCoordinate;
begin
  if Expanded and (Children.Count>0) then
     result:=TTreeNodeShape(Children.List[Pred(Children.Count)]).MinHeightExpandedChilds
  else
     result:=AdjustedRectangle.Top;
end;

// Returns the biggest "Bottom" coordinate of recursively expanded children
Function TTreeNodeShape.MaxHeightExpandedChilds: TCoordinate;
begin
  if Expanded and (Children.Count>0) then
     result:=TTreeNodeShape(Children.List[Pred(Children.Count)]).MaxHeightExpandedChilds
  else
     result:=AdjustedRectangle.Bottom;
end;

// Internal. Returns True when the "cross-box" is visible
Function TTreeNodeShape.ShouldDrawCross:Boolean;
begin
  result:=(FShowCross=scAlways) or ((FShowCross=scAuto) and (Children.Count>0));
end;

// Adds Source bounds to Dest rectangle:
procedure InflateRectangle(var Dest:TRect; const Source:TRect);
begin
  with Dest do
  begin
    if Source.Bottom>Bottom then Bottom:=Source.Bottom;
    if Source.Top<Top       then Top   :=Source.Top;
    if Source.Right>Right   then Right :=Source.Right;
    if Source.Left<Left     then Left  :=Source.Left;
  end;
end;

Function TTreeNodeShape.DoDraw:Boolean;
var t : Integer;
begin
  result:=True;

  if Visible then  // we should draw ourselves...
  begin
    // draw only if inside Tree boundaries
    if InsideTreeBounds then
       Draw;

    // draw all connections (only if global and local "visible")
    if Assigned(FConnections) and
       Tree.Connections.Visible and
       FConnections.Visible then

       for t:=0 to FConnections.Count-1 do
       with TTreeConnection(FConnections.List[t]) do // optimized access to: Connections[t]
       begin
         // optimization: only draw connections to nodes that
         // are not our children.
         // Only draw connections to our children if we are Expanded.
         if Assigned(ToShape) and
            ((ToShape.Parent<>Self) or Self.Expanded) then
              if not Draw then
              begin
                // stop drawing connections when "Draw" returns "False".
                // this is an optimization only currently used in Explorer
                // child manager class.
                result:=False;
                break;
              end;

         if Tree<>Self.Tree then
            Tree:=Self.Tree;

         // adjust totalbounds with position of connection points.
         InflateRectangle(Tree.IBounds,IBounds);
       end;

    // Draw "cross-box"
    With Tree.CrossBox do
    if Visible and (Size>0) and ShouldDrawCross then
       Draw(CalcXYCross(Parent),Expanded);

  end; // else ???

  if not Expanded then
     Exit;

  // Tell all our children to draw themselves...
  for t:=0 to Children.Count-1 do
      if not Children[t].DoDraw then
      begin
        result:=False;
        break;
      end;
end;

procedure TTreeNodeShape.ChangeAutoSize(Value: Boolean);
begin
  FAutoSize:=Value;
end;

function TTreeNodeShape.GetX1: Integer;
begin
  if (not IAutoSized) and Assigned(Tree) then
     RecalcSize(Tree.Canvas);

  result:=FX1;
end;

function TTreeNodeShape.GetY1: Integer;
begin
  if (not IAutoSized) and Assigned(Tree) then
     RecalcSize(Tree.Canvas);

  result:=FY1;
end;

// Calculate our XY position and the XY position of all of our children.
// This is only done when the nodes "AutoPosition" is true.
Procedure TTreeNodeShape.ReCalcPositions(ABrotherIndex:Integer);

  // Expand the AdjustedRectangle with Image dimensions
  Procedure CalculateImageBounds;

    Procedure CalcTopBottom;
    Var Dif : Integer;
    begin
      Dif:=(IImageHeight-(FY1-Y0)) div 2;
      FImageRect.Top:=Y0-Dif;

      if Dif>0 then
      begin
        {$IFDEF FMX}
        FAdjustedRect.Top:=FAdjustedRect.Top-Dif;
        FAdjustedRect.Bottom:=FAdjustedRect.Bottom+Dif;
        {$ELSE}
        Dec(FAdjustedRect.Top,Dif);
        Inc(FAdjustedRect.Bottom,Dif);
        {$ENDIF}
      end;
    end;

    Procedure CalcLeftRight;
    Var Dif : Integer;
    begin
      Dif:=(IImageWidth-(FX1-X0)) div 2;
      FImageRect.Left:=X0-Dif;

      if Dif>0 then
      begin
        {$IFDEF FMX}
        FAdjustedRect.Left:=FAdjustedRect.Left-Dif;
        FAdjustedRect.Right:=FAdjustedRect.Right+Dif;
        {$ELSE}
        Dec(FAdjustedRect.Left,Dif);
        Inc(FAdjustedRect.Right,Dif);
        {$ENDIF}
      end;
    end;

  begin
    with FAdjustedRect do
    Case FImageAlignment of
      iaAutomatic,
      iaLeft: begin
                Left:=Left-(TeePictureHorizMargin+IImageWidth);
                FImageRect.Left:=Left;
                CalcTopBottom;
              end;
       iaTop: begin
                Top:=Top-(TeePictureVertMargin+IImageWidth);
                FImageRect.Top:=Top;
                CalcLeftRight;
              end;
     iaRight: begin
                Right:=Right+TeePictureHorizMargin;
                FImageRect.Left:=Right;
                Right:=Right+IImageWidth;
                CalcTopBottom;
              end;
    iaBottom: begin
                Bottom:=Bottom+TeePictureVertMargin;
                FImageRect.Top:=Bottom;
                Bottom:=Bottom+IImageHeight;
                CalcLeftRight;
              end;
   iaLeftTop: begin
                Left:=Left-(TeePictureHorizMargin+IImageWidth);
                Top:=Top-(TeePictureVertMargin+IImageHeight);
                FImageRect.TopLeft:=TopLeft;
              end;
iaLeftBottom: begin
                Left:=Left-(TeePictureHorizMargin+IImageWidth);
                FImageRect.Left:=Left;
                FImageRect.Top:=Bottom;
                Bottom:=Bottom+IImageHeight;
              end;
  iaRightTop: begin
                Right:=Right+TeePictureHorizMargin;
                FImageRect.Left:=Right;
                Right:=Right+IImageWidth;
                Top:=Top-(TeePictureVertMargin+IImageHeight);
                FImageRect.Top:=Top;
              end;
iaRightBottom: begin
                Right:=Right+TeePictureHorizMargin;
                FImageRect.Left:=Right;
                Right:=Right+IImageWidth;
                Bottom:=Bottom+TeePictureVertMargin;
                FImageRect.Top:=Bottom+TeePictureVertMargin;
                Bottom:=Bottom+IImageHeight;
              end;
    iaCenter: begin
                FImageRect:=FAdjustedRect;  // special case for centered img.
                exit;
              end;
    end;

    // Set Image rectangle Right and Bottom coordinates (image size)
    With FImageRect do
    begin
      Right:=Left+IImageWidth;
      Bottom:=Top+IImageHeight;
    end;
  end;

var t   : Integer;
    Old : Integer;
begin
  if not IAutoSized then
     RecalcSize(Tree.Canvas); // optimization.

  // calculate automatic Left position
  if (not Assigned(FAutoPosition)) or FAutoPosition.Left then
  begin
    Old:=FX1-FX0;
    FX0:=Tree.GlobalFormat.ChildManager.XPosition(Self,ABrotherIndex);
    FX1:=FX0+Old;
  end;

  // calculate automatic Top position
  if (not Assigned(FAutoPosition)) or FAutoPosition.Top then
  begin
    Old:=FY1-FY0;
    FY0:=Tree.GlobalFormat.ChildManager.YPosition(Self,ABrotherIndex);
    FY1:=FY0+Old;
  end;

  FAdjustedRect.Left:=X0;
  FAdjustedRect.Top:=Y0;

  if Assigned(FText) then
  begin
    FAdjustedRect.Right:=FX1+Max(0,FText.HorizOffset);
    FAdjustedRect.Bottom:=FY1+Max(0,FText.VertOffset);
  end
  else
  begin
    FAdjustedRect.Right:=FX1;
    FAdjustedRect.Bottom:=FY1;
  end;

  if Tree.ShowImages and (IImageWidth>0) then
     CalculateImageBounds;

  with Tree.CrossBox do
   if Visible and (Size>0) and ShouldDrawCross then
   begin
     if FAdjustedRect.Bottom - FAdjustedRect.Top < (Size * 2) then
     begin
       t:=Size div 2;

       FAdjustedRect.Top:=FAdjustedRect.Top-t;
       FAdjustedRect.Bottom:=FAdjustedRect.Bottom+t;  // +(Size-t)
     end;
   end;

  if Expanded then  // or (Children.Count>1) then  //#2016 failed fix. re-examine
  for t:=0 to Children.Count-1 do
      TTreeNodeShape(Children.List[t]).ReCalcPositions(t);

  // Expand Tree TotalBounds property with adjusted rectangle.
  // These bounds cover both the visible and non-visible nodes.
  // They are used to display or not the tree scrollbars.

  InflateRectangle(Tree.IBounds,FAdjustedRect);
end;

// Adds a new child node as the first child, setting the Text
Function TTreeNodeShape.AddChildFirst(Const AText:String):TTreeNodeShape;
var t : Integer;
begin
  result:=AddChild(AText);

  for t:=Childs.Count-2 downto 0 do
  begin
    Childs[t].FBrotherIndex:=t+1;
    Childs.FList[t+1]:=Childs.FList[t];
  end;

  result.FBrotherIndex:=0;
  Childs.FList[0]:=result;
end;

// Adds a new child node, setting the Text and Data properties
Function TTreeNodeShape.AddChildObject(Const AText:String; const Data:Pointer):TTreeNodeShape;
begin
  result:=AddChild(AText);
  result.Data:=Data;
end;

// Adds a new child node, setting the Text and XY properties
Function TTreeNodeShape.AddChild(Const AText:String):TTreeNodeShape;
begin
  result:=Tree.AddShape( X0+TreeHorizMarginDefault,
                         TreeVertMarginDefault,AText,Self);
end;

// Same as AddChild.
Function TTreeNodeShape.Add(Const AText:String):TTreeNodeShape;
begin
  result:=AddChild(AText);
end;

// Changes our XY position, and the XY position of all of our children
Procedure TTreeNodeShape.MoveRelative(OfsX,OfsY:Integer; MoveChilds:Boolean);
var t : Integer;
begin
  { move this node... }
  if (not FTree.NegativeCoordinates) then
  begin
    if (FX0+OfsX) < 0 then OfsX := -FX0;
    if (FY0+OfsY) < 0 then OfsY := -FY0;
  end;
  {
    if (not NegativeCoordinates) then
    begin
      if (FDragged.Left + DifX) < 0 then DifX := -FDragged.Left;
      if (FDragged.Top + DifY) < 0 then DifY := -FDragged.Top;
    end;                                                      }

  Inc(FX0,OfsX);
  Inc(FX1,OfsX);
  Inc(FY0,OfsY);
  Inc(FY1,OfsY);

  if MoveChilds then { move children recursively ! }
     for t:=0 to Children.Count-1 do
         Children[t].MoveRelative(OfsX,OfsY,True);

  CanvasChanged(Self);
end;

// Change our size (widht and height). It does not change children size.
Procedure TTreeNodeShape.Resize( ACorner:TTreeShapeHandle;
                                 DeltaX,DeltaY:Integer);

  Procedure ChangeX0;
  begin
    Inc(FX0,DeltaX);
    if FX0>=FX1 then FX0:=FX1-1;
  end;

  Procedure ChangeY1;
  begin
    Inc(FY1,DeltaY);
    if FY1<=FY0 then FY1:=FY0+1;
  end;

  Procedure ChangeX1;
  begin
    Inc(FX1,DeltaX);
    if FX1<=FX0 then FX1:=FX0+1;
  end;

  Procedure ChangeY0;
  begin
    Inc(FY0,DeltaY);
    if FY0>=FY1 then FY0:=FY1-1;
  end;

begin
  if Assigned(FTree.FOnResizingShape) then
     FTree.FOnResizingShape(Self,ACorner,DeltaX,DeltaY);

  if (DeltaX<>0) or (DeltaY<>0) then
  begin
    Case ACorner of
      rcLeftTop    : begin ChangeX0; ChangeY0; end;
      rcLeftBottom : begin ChangeX0; ChangeY1; end;
      rcRightBottom: begin ChangeX1; ChangeY1; end;
      rcRightTop   : begin ChangeX1; ChangeY0; end;
      rcLeft       : ChangeX0;
      rcBottom     : ChangeY1;
      rcRight      : ChangeX1;
      rcTop        : ChangeY0;
    end;

    AutoSize:=False;
    CanvasChanged(Self);
  end;
end;

{ returns the node which is a brother just before the node }
Function TTreeNodeShape.GetPreviousBrother:TTreeNodeShape;
begin
  if Assigned(Parent) then
  begin
    if BrotherIndex>0 then
       result:=Parent.Children[BrotherIndex-1]
    else
       result:=nil;
  end
  else
    result:=nil;
end;

{ moves the node to be the last node to be displayed (to front) }
Procedure TTreeNodeShape.BringToFront;

  Procedure ScrollList(AList:TNodeShapeList);
  var tmpIndex : Integer;
      t        : Integer;
  begin
    with AList do
    begin
      tmpIndex:=IndexOf(Self);

      for t:=tmpIndex to Count-2 do
          List[t]:=List[Succ(t)];

      List[Count-1]:=Self;
    end;
  end;

begin
  if Assigned(Parent) then
     ScrollList(Parent.Children)
  else
     ScrollList(Tree.Roots);

  ScrollList(Tree.Shapes);

  CanvasChanged(Self);
end;

{ moves the node to be the first one to display (to back) }
Procedure TTreeNodeShape.SendToBack;

  Procedure ScrollList(AList:TNodeShapeList);
  var tmpIndex : Integer;
      t        : Integer;
  begin
    with AList do
    begin
      tmpIndex:=IndexOf(Self);

      for t:=tmpIndex downto 1 do
          List[t]:=List[Pred(t)];

      List[0]:=Self;
    end;
  end;

begin
  if Assigned(Parent) then
     ScrollList(Parent.Children)
  else
     ScrollList(Tree.Roots);

  ScrollList(Tree.Shapes);

  CanvasChanged(Self);
end;

// optimization: returns True if the node AutoPosition Left is True
function TTreeNodeShape.AutoPositionLeft: Boolean;
begin
  result:=(not Assigned(FAutoPosition)) or (not FAutoPosition.FNoLeft);
end;

// optimization: returns True if the node AutoPosition Top is True
function TTreeNodeShape.AutoPositionTop: Boolean;
begin
  result:=(not Assigned(FAutoPosition)) or (not FAutoPosition.FNoTop);
end;

Procedure TTreeNodeShape.ChangeTreeRecursive(const NewTree:TCustomTree);
var t : Integer;
begin
  Tree:=NewTree;

  for t:=0 to Children.Count-1 do
      Children[t].ChangeTreeRecursive(NewTree);

  if Assigned(FConnections) then
     for t:=0 to FConnections.Count-1 do
         FConnections[t].Tree:=NewTree;
end;

{ TTreeSelectedPen }

Constructor TTreeSelectedPen.Create(const OnChangeEvent:TNotifyEvent);
begin
  inherited;
  SmallDots:=True;
  Style:=psDot;
  Color:=clYellow;
  Width:=1;
end;

{ TTreeSelectedUnFocusedPen }

Constructor TTreeHiddenPen.Create(const OnChangeEvent:TNotifyEvent);
begin
  inherited;
  Visible:=False;
end;

{ TSelectedShapeList }

Constructor TSelectedShapeList.Create(const ATree:TCustomTree);
begin
  inherited Create;

  ITree:=ATree;
  IList:=TNodeShapeList.Create;
  IList.ITree:=ITree;

  FBorder:=TTreeSelectedPen.Create(ITree.CanvasChanged);
  FBorderUnFocused:=TTreeSelectedUnFocusedPen.Create(ITree.CanvasChanged);

  FColor:=TeeHighLight;
  FColorUnFocused:=TeeHighLightUnfocused;

  FHandlePen:=TTreeSelectedHandlesPen.Create(ITree.CanvasChanged);
  FHandleSize:=3;
  FHandleColor:=clBlack;
  FTextColor:=TeeHighLightText;

  FScrollToView:=True;
  FShiftState:=[ssShift];
end;

Destructor TSelectedShapeList.Destroy;
begin
  FBorder.Free;
  FBorderUnFocused.Free;
  FHandlePen.Free;
  IList.Free;

  inherited;
end;

Procedure TSelectedShapeList.Add(const AShape:TTreeNodeShape);
var tmp : Boolean;
begin
  AShape.FSelected:=True;

  // Remove selected connection, if any...
  ITree.Connections.Selected:=nil;

  // Hide memo editor...
  ITree.StopEditing;

  // Redraw handles if designing...
  tmp:=ITree.Designing and (not FullRedraw);

  if tmp and (Count=1) then
     Shapes.First.InternalDrawHandles;

  Shapes.Add(AShape);

  if tmp and (Count=2) then
     Shapes.First.InternalDrawHandles;

  // Move selected shape to center and / or to visible view...
  if AShape.Visible then
  begin
    if ScrollToCenter then
       ITree.CenterInView(AShape,TeeTreeAnimatedScroll);

    if FScrollToView then
       ITree.SelectedScroll;
  end;

  // Call OnSelectShape event
  if Assigned(ITree.FOnSelectShape) then
     ITree.FOnSelectShape(AShape);

  // if designing then redraw handles else redraw full tree...
  if tmp {$IFNDEF FMX}and ITree.Showing{$ENDIF} then
     AShape.InternalDrawHandles
  else
     ITree.Invalidate;
end;

Procedure TSelectedShapeList.Remove(const AShape:TTreeNodeShape);
var tmp : Boolean;
begin
  AShape.FSelected:=False;

  tmp:=ITree.Designing and (not FullRedraw);

  if tmp then
  begin
    AShape.InternalDrawHandles;

    if Count=2 then
    begin
      if Shapes.First=AShape then
         Shapes[1].InternalDrawHandles
      else
         Shapes.First.InternalDrawHandles;
    end;
  end;

  Shapes.Remove(AShape);

  if Assigned(ITree.FOnUnSelectShape) then
     ITree.FOnUnSelectShape(AShape);

  if tmp then
  begin
    if Count=1 then
       Shapes.First.InternalDrawHandles;
  end
  else
    ITree.Invalidate;
end;

Function TSelectedShapeList.Count:Integer;
begin
  result:=IList.Count;
end;

Function TSelectedShapeList.GetShape(Index:Integer):TTreeNodeShape;
begin
  result:=IList[Index];
end;

Procedure TSelectedShapeList.SetColor(Value:TColor);
begin
  if FColor<>Value then
  begin
    FColor:=Value;
    Repaint;
  end;
end;

Procedure TSelectedShapeList.SetColorUnFocused(Value:TColor);
begin
  if FColorUnFocused<>Value then
  begin
    FColorUnFocused:=Value;
    Repaint;
  end;
end;

Procedure TSelectedShapeList.Repaint;
begin
  if Count>0 then
     ITree.Invalidate;
end;

Procedure TSelectedShapeList.SetBorder(const Value:TTreeSelectedPen);
begin
  FBorder.Assign(Value);
  Repaint;
end;

Procedure TSelectedShapeList.SetBorderUnFocused(const Value:TTreeSelectedUnFocusedPen);
begin
  FBorderUnFocused.Assign(Value);
  Repaint;
end;

procedure TSelectedShapeList.SetTextColor(Value: TColor);
begin
  if FTextColor<>Value then
  begin
    FTextColor:=Value;
    Repaint;
  end;
end;

Procedure TSelectedShapeList.Assign(Value:TPersistent);
begin
  if Value is TSelectedShapeList then
  With TSelectedShapeList(Value) do
  begin
    Self.Border          :=FBorder;
    Self.BorderUnFocused :=FBorderUnFocused;
    Self.FColor          :=Color;
    Self.FColorUnFocused :=ColorUnFocused;
    Self.FFullRedraw     :=FullRedraw;
    Self.FTextColor      :=TextColor;
    Self.FScrollToView   :=ScrollToView;
    Self.FScrollToCenter :=ScrollToCenter;
    Self.FShiftState     :=ShiftState;
    Self.HandlePen       :=HandlePen;
    Self.FHandleColor    :=HandleColor;
    Self.FHandleSize     :=HandleSize;
  end
  else inherited;
end;

// Clear selection.
Procedure TSelectedShapeList.Clear;
begin
  if ITree.IClearing then
     IList.Clear  // optimization
  else
  While Count>0 do
     Shapes.First.Selected:=False;

  ITree.Connections.Selected:=nil;
end;

// Delete selected nodes.
Procedure TSelectedShapeList.Delete;
var tmp      : Boolean;
    tmpNode  : TTreeNodeShape;
    tmpIndex,t : Integer;
begin
  if Count>0 then
  begin
    if Assigned(ITree.FOnDeletingShapes) then
    begin
      tmp:=True;

      ITree.FOnDeletingShapes(Self,tmp);

      if not tmp then
         Exit;
    end;

    tmpNode:=nil;

    if Count>0 then
    With Items[0] do
    if Assigned(Parent) then
    begin
      if (Parent.Count-1) > BrotherIndex then
         tmpNode:=Parent.Children[BrotherIndex+1]
      else
      if BrotherIndex>0 then tmpNode:=PreviousBrother
                        else tmpNode:=Parent;
    end
    else
    begin
      tmpIndex:=Tree.Roots.IndexOf(Items[0]);

      for t:=tmpIndex-1 downto 0 do
      if not Tree.Roots[t].Selected then
      begin
        tmpNode:=Tree.Roots[t];
        break;
      end;

      if tmpNode = nil then
        for t:=tmpIndex+1 to Tree.Roots.Count-1 do
          if not Tree.Roots[t].Selected then
          begin
            tmpNode:=Tree.Roots[t];
            break;
          end;
    end;

    while Count>0 do
      Shapes.First.{$IFDEF AUTOREFCOUNT}DisposeOf{$ELSE}Free{$ENDIF};

    if Assigned(tmpNode) then
       tmpNode.Selected:=True;

    if Assigned(ITree.FOnDeletedShapes) then
       ITree.FOnDeletedShapes(ITree);
  end;
end;

// Call Proc procedure for all nodes in IList
procedure TSelectedShapeList.ForEach(const Proc: TNodeListForEachProc);
begin
  IList.ForEach(Proc);
end;

procedure TSelectedShapeList.SetScrollToCenter(const Value: Boolean);
begin
  if FScrollToCenter<>Value then
  begin
    FScrollToCenter:=Value;

    if FScrollToCenter and (Count>0) then
       ITree.CenterInView(Items[0],TeeTreeAnimatedScroll);
  end;
end;

procedure TSelectedShapeList.SetFullRedraw(const Value: Boolean);
begin
  ITree.SetBooleanProperty(FFullRedraw,Value);
end;

procedure TSelectedShapeList.SetHandlesPen(const Value: TTreeSelectedHandlesPen);
begin
  FHandlePen.Assign(Value);
end;

procedure TSelectedShapeList.SetHandleSize(const Value: Integer);
begin
  ITree.SetIntegerProperty(FHandleSize,Value);
end;

procedure TSelectedShapeList.SetHandleColor(const Value: TColor);
begin
  ITree.SetColorProperty(FHandleColor,Value);
end;

// Returns the appropiate color for selected nodes brush
function TSelectedShapeList.InternalColor: TColor;
begin
  if IFocused then result:=Color
              else result:=ColorUnFocused;
end;

function TSelectedShapeList.First: TTreeNodeShape;
begin
  if Count>0 then result:=GetShape(0)
             else result:=nil;
end;

function TSelectedShapeList.GetText: String;
begin
  if Count>0 then result:=Items[0].SimpleText
             else result:='';
end;

procedure TSelectedShapeList.SetText(const Value: String);
begin
  if Count>0 then
  with Items[0].Text do
  begin
    Clear;
    Add(Value);
  end;
end;

function TSelectedShapeList.GetData:Pointer;
begin
  if Count>0 then result:=Items[0].Data
             else result:=nil;
end;

procedure TSelectedShapeList.SetData(const Value:Pointer);
begin
  if Count>0 then Items[0].Data:=Value;
end;

procedure TSelectedShapeList.InternalAdd(const AShape: TTreeNodeShape);
begin
  Shapes.Add(AShape);
end;

procedure TSelectedShapeList.SelectAll;
begin
  ITree.Shapes.SelectAll;
end;

procedure TSelectedShapeList.ToggleCheck;
var t : Integer;
begin
  for t:=0 to Count-1 do
      Items[t].ToggleCheck;
end;

{ TTreeClipboard }

Procedure TTreeClipboard.Copy(const SourceTree:TCustomTree);
var t   : Integer;
    tmp : TTreeNodeShape;

  function IsParentSelected(const ANode: TTreeNodeShape):Boolean;
  var tmpNode: TTreeNodeShape;
  begin
    result:=False;
    tmpNode:=ANode.Parent;

    while Assigned(tmpNode) do
    begin
      result:=tmpNode.Selected;

      if result then
         break;

      tmpNode:=tmpNode.Parent;
    end;
  end;

begin
  IsCut:=nil;

  if SourceTree.Selected.Count>0 then
  begin
    Clear;

    for t:=0 to SourceTree.Selected.Count-1 do
    begin
      if not IsParentSelected(SourceTree.Selected[t]) then
      begin
        tmp:=CloneShape(SourceTree.Selected[t]);

        tmp.AutoPosition.Assign(SourceTree.Selected[t].AutoPosition);

        if tmp.SimpleText=SourceTree.Selected[t].Name then
           tmp.Text.Clear;

        tmp.Parent:=nil;
        tmp.Visible:=False;
        tmp.Tree:=Self;
      end;
    end;
  end;
end;

Procedure TTreeClipboard.Cut(const SourceTree:TCustomTree);
begin
  Copy(SourceTree);

  if Assigned(SourceTree.selected) then
     SourceTree.Selected.Delete;
end;

Procedure TTreeClipboard.Paste(const DestTree:TCustomTree);
var t : Integer;
    tmp : TTreeNodeShape;
begin
  DestTree.Selected.Clear;

  for t:=0 to Roots.Count-1 do
  begin
    tmp := DestTree.AddCloneShape(Roots[t]);

    with tmp do
    begin
      tmp.AutoPosition.Assign(Roots[t].AutoPosition);

      if not AutoPositionLeft then
         X0 := Roots[t].X0 + 15;

      if not AutoPositionTop then
         Y0 := Roots[t].Y0 + 15;

      Selected:=True;
    end;
  end;
end;

{ TTeeScrollBar }

{$IFDEF FMX}
Const SB_HORZ=0;
      SB_VERT=1;
{$ENDIF}

Constructor TTeeScrollBar.Create(const ATree:TCustomTree; IsHoriz:Boolean);
begin
  inherited Create;

  ITree:=ATree;
  FMax:=TeeDefaultMaxScroll;
  FMin:=TeeDefaultMinScroll;

  if IsHoriz then ICode:=SB_HORZ else ICode:=SB_VERT;

  FAutomatic:=True;

  {$IFDEF FMX}
  IScroll:=TScrollBar.Create(nil);
  IScroll.Stored:=False;

  if IsHoriz then
  begin
    IScroll.Orientation:=TOrientation.{$IFDEF D20}Horizontal{$ELSE}orHorizontal{$ENDIF};
    IScroll.Align:=TAlignLayout.{$IFDEF D20}Bottom{$ELSE}alBottom{$ENDIF};
    IScroll.Height:=15;
  end
  else
  begin
    IScroll.Orientation:=TOrientation.{$IFDEF D20}Vertical{$ELSE}orVertical{$ENDIF};
    IScroll.Align:=TAlignLayout.{$IFDEF D20}Right{$ELSE}alRight{$ENDIF};
    IScroll.Width:=15;
  end;

  IScroll.Visible:=False;

  {$IFNDEF D21}
  IScroll.DesignVisible:=False;
  {$ENDIF}

  IScroll.Parent:=ATree;

  IScroll.OnChange:=ScrollChanged;
  {$ENDIF}
end;

Procedure TTeeScrollBar.Assign(Source:TPersistent);
begin
  if Source is TTeeScrollBar then
  With TTeeScrollBar(Source) do
  begin
    Self.FFlat    :=FFlat;
    { ICode <-- no }
    Self.FMin     :=FMin;
    Self.FMax     :=FMax;
    Self.FVisible :=FVisible;
  end
  else inherited;
end;

{$IFDEF FMX}
Procedure TTeeScrollBar.InternalSetRange(Redraw:Boolean);
begin
  IScroll.Min:=FMin;

  if Vertical then
     IScroll.Max:=FMax-IScroll.Height // BevelWidth *(Inner + Outer)
  else
     IScroll.Max:=FMax-IScroll.Width // BevelWidth *(Inner + Outer)
end;
{$ELSE}
Function TTeeScrollBar.CanModifyBar:Boolean;
var tmp : TControl;
begin
  result:=Assigned(ITree.Parent) and (not (csLoading in ITree.ComponentState));

  if result then
  begin
    // Fix for non-TControl-derived applications (ie: Intraweb)
    tmp:=ITree.Parent;

    while Assigned(tmp.Parent) do tmp:=tmp.Parent;

    if not (tmp is TCustomForm) then
       result:=(not Assigned(tmp.Owner)) or (tmp.Owner is TControl);
  end;
end;

type TTeeWinControl=TWinControl;

Procedure TTeeScrollBar.InternalSetRange(Redraw:Boolean);
var tmp : TScrollInfo;
begin
  if CanModifyBar then
  begin
    tmp.cbSize:=SizeOf(tmp);
    tmp.nMin:=FMin;
    tmp.nMax:=FMax;
    tmp.fMask:=SIF_Range;

    if FFlat then
       FlatSB_SetScrollInfo(ITree.Handle,ICode,tmp,Redraw)
    else
       SetScrollRange(ITree.Handle,ICode,FMin,FMax,Redraw);
  end;
end;
{$ENDIF}

Procedure TTeeScrollBar.SetVisible(Value:Boolean);
begin
  if (not Automatic) and (FVisible<>Value) then
  begin
    ChangeVisible(Value);
    DoCheckMinMax;
  end;
end;

Procedure TTeeScrollBar.SetFlat(Value:Boolean);
begin
  FFlat:=Value;

  {$IFNDEF FMX}
  if CanModifyBar then
     if FFlat then
     begin
       InitializeFlatSB(ITree.Handle);
       FlatSB_SetScrollProp(ITree.Handle, WSB_PROP_HSTYLE, FSB_ENCARTA_MODE, True);
       FlatSB_SetScrollProp(ITree.Handle, WSB_PROP_VSTYLE, FSB_ENCARTA_MODE, True);
     end
     else
       UninitializeFlatSB(ITree.Handle);
  {$ENDIF}
end;

Procedure TTeeScrollBar.ChangeVisible(Value:Boolean);
begin
  FVisible:=Value;

  SetFlat(FFlat);

  {$IFDEF FMX}
  IScroll.Visible:=Value;

  {$IFNDEF D21}
  IScroll.DesignVisible:=Value;
  {$ENDIF}

  {$ELSE}
  if CanModifyBar then
     if FFlat then
        FlatSB_ShowScrollBar(ITree.Handle,ICode,FVisible)
    else
        ShowScrollBar(ITree.Handle,ICode,FVisible);
  {$ENDIF}
end;

Procedure TTeeScrollBar.CheckScroll(AMin,AMax,AOffset,ASize:Integer);

   Function IsOutOfBounds:Boolean;
   begin
     result:=((AMax-AMin+1)>0) and ( ((AMin+AOffset)<0) or ((AMax+AOffset)>=ASize) );
   end;

   Procedure CheckMinMax;
   var tmpMin : Integer;
       tmpMax : Integer;
   begin
     if (AMin+AOffset)<0 then
        tmpMin:=AMin-1
     else
        tmpMin:=-AOffset;

     if (AMax+AOffset)>=ASize then
        tmpMax:=AMax+1
     else
        tmpMax:=ASize-AOffset-1;

     if (tmpMin<>FMin) or (tmpMax<>FMax) then
     begin
       FMin:=tmpMin;
       FMax:=tmpMax;
       InternalSetRange(True);
     end;
   end;

begin
  if IsOutOfBounds then
  begin
    if Automatic then
    begin
      if not Visible then
      begin
        ChangeVisible(True);
        FMin:=0;
        FMax:=0;
      end;

      CheckMinMax;
    end;

    SetPosition(-AOffset);

    if Automatic then
       PageSize:=ASize;
  end
  else
  if Automatic and Visible then
  begin
    ChangeVisible(False);
    ITree.Repaint;
  end;
end;

{$IFDEF FMX}
procedure TTeeScrollBar.ScrollChanged(Sender:TObject);
begin
  if Vertical then
     ITree.View3DOptions.VertOffsetFloat:=-IScroll.Value
  else
     ITree.View3DOptions.HorizOffsetFloat:=-IScroll.Value;
end;
{$ELSE}
Function TTeeScrollBar.CalcScrollOffset(ScrollCode:Integer):Integer;
var ScrollInfo : TScrollInfo;
    tmp        : Integer;
    tmpSmall   : Integer;
    tmpLarge   : Integer;
    tmpSize    : Integer;
begin
  tmpSize:=PageSize;

  if tmpSize=0 then
  begin
    tmpSmall:=10;
    tmpLarge:=50;
  end
  else
  begin
    tmpSmall:=1+(tmpSize div 20);
    tmpLarge:=1+(tmpSize div 5);
  end;

  tmp:=Position;

  case ScrollCode of
        sb_LineUp: result:=Math.Max(Min,tmp-tmpSmall);
      sb_LineDown: result:=Math.Min(Max-tmpSize+1,tmp+tmpSmall);
        sb_PageUp: result:=Math.Max(Min,tmp-tmpLarge);
      sb_PageDown: result:=Math.Min(Max-tmpSize,tmp+tmpLarge);
 sb_ThumbPosition,
    sb_ThumbTrack: with ScrollInfo do
                   begin
                     cbSize:=SizeOf(ScrollInfo);
                     fMask:=SIF_ALL;

                     if FFlat then
                        FlatSB_GetScrollInfo(ITree.Handle, ICode, ScrollInfo)
                     else
                        GetScrollInfo(ITree.Handle, ICode, ScrollInfo);

                     result:=nTrackPos;
                   end;

           sb_Top: result:=Min;
    else
        {sb_Bottom:} result:=Max-tmpSize;
  end;
end;
{$ENDIF}

Procedure TTeeScrollBar.SetRange;
begin
  if Visible then
     InternalSetRange(True);
end;

Procedure TTeeScrollBar.SetMax(Value:Integer);
begin
  if FMax<>Value then
  begin
    FMax:=Value;
    SetRange;
  end;
end;

Procedure TTeeScrollBar.SetMin(Value:Integer);
begin
  if FMin<>Value then
  begin
    FMin:=Value;
    SetRange;
  end;
end;

function TTeeScrollBar.GetPosition: Integer;
begin
  {$IFDEF FMX}
  result:=Round(IScroll.Value);
  {$ELSE}
  if CanModifyBar then
     if FFlat then
        result:=FlatSB_GetScrollPos(ITree.Handle,ICode)
     else
        result:=GetScrollPos(ITree.Handle,ICode)
  else
     result:=0;
  {$ENDIF}
end;

Procedure TTeeScrollBar.SetAutomatic(Value:Boolean);
begin
  FAutomatic:=Value;

  if FAutomatic then
  begin
    Visible:=False;

    if Assigned(ITree) then
       ITree.AutomaticScrollBars;
  end
  else
  begin
    ChangeVisible(FVisible);
    DoCheckMinMax;
  end;
end;

Procedure TTeeScrollBar.DoCheckMinMax;
begin
  if FVisible then
  begin
    FMin:=0;

    if Vertical then
       FMax:=ITree.Page.FHeight*ITree.Page.Count
    else
       FMax:=ITree.Page.FWidth;

    InternalSetRange(True);
  end;
end;

procedure TTeeScrollBar.SetPageSize(Value:Integer);
{$IFNDEF FMX}
var tmp : TScrollInfo;
{$ENDIF}
begin
  if FPageSize<>Value then
  begin
    FPageSize:=Value;

    {$IFNDEF FMX}
    if CanModifyBar then
    begin
      tmp.cbSize:=SizeOf(tmp);
      tmp.nPage:=Value;
      tmp.fMask:=SIF_PAGE;

      if FFlat then
         FlatSB_SetScrollInfo(ITree.Handle,ICode,tmp,True)
      else
         SetScrollInfo(ITree.Handle,ICode,tmp,True);
    end;
    {$ENDIF}
  end;
end;

procedure TTeeScrollBar.SetScrollParams(Offset:Integer);
begin
  InternalSetRange(False);

  {$IFDEF FMX}
  IScroll.Value:=Offset;
  {$ELSE}
  if CanModifyBar then
     if FFlat then
        FlatSB_SetScrollPos(ITree.Handle,ICode,Offset,True)
     else
        SetScrollPos(ITree.Handle,ICode,Offset,True);
  {$ENDIF}

  SetPageSize(FPageSize);
  ChangeVisible(Visible);
end;

procedure TTeeScrollBar.SetPosition(Value:Integer);
begin
  if Visible and (not ITree.Destroying) then
     {$IFDEF FMX}
     IScroll.Value:=Value;
     {$ELSE}
     if CanModifyBar then
        if FFlat then
           FlatSB_SetScrollPos(ITree.Handle,ICode,Value,True)
        else
           SetScrollPos(ITree.Handle,ICode,Value,True);
     {$ENDIF}
end;

function TTeeScrollBar.Vertical: Boolean;
begin
  result:=ICode=SB_VERT;
end;

{ TTreeExplorerAlignChild }

Constructor TTreeExplorerAlignChild.Create;
begin
  inherited;
  FHorizMargin:=TreeHorizMarginDefault;
  FVertMargin:=TreeVertMarginDefault;
  FCrossMargin:=TeeCrossBoxHorizMargin;
  FTopPos:=TeeTree_DefaultYPosition;
end;

Function TTreeExplorerAlignChild.DrawConnection(const AConnection:TTreeConnection):Boolean;
Var P          : TPoint;
    tmp        : Integer;
    tmpX       : TCoordinate;
    tmpY       : TCoordinate;
    tmpY2      : TCoordinate;
    tmpYC      : TCoordinate;
    tmpArrowTo : TConnectionArrowTo;
    tmpPrep    : Boolean;
    tmpPrev    : TTreeNodeShape;
begin
  result:=True;
  tmpPrep:=False;

  with AConnection, Points do
  begin
    if Length(Item)<>2 then
       SetLength(Item,3);

    tmp:=ToShape.BrotherIndex;

    if tmp>0 then
    begin
      // Assert ToShape.Parent should not be nil
      tmpPrev:=ToShape.Parent.Children[tmp-1];
      P:=CalcXYCross(tmpPrev,ToShape.Parent);

      with Item[0] do
      begin
        X:=P.X;
        Y:=P.Y;

        XStyle:=cpsFixed;
        YStyle:=cpsFixed;
      end;

      With Tree.CrossBox do
      if Visible and (Size>0) and tmpPrev.ShouldDrawCross then
         Item[0].Y:=Item[0].Y+Size;

      P:=CalcXYCross(ToShape,FromShape);
    end
    else
    begin
      P:=CalcXYCross(ToShape,FromShape);
      Item[0].X:=P.X;
      tmpYC:=FromShape.YCenter;
      Item[0].Y:=tmpYC;

      if Tree.ShowImages and (FromShape.IImageHeight>0) and (FromShape.ImageAlignment<>iaCenter) then
         tmpY:=2+(FromShape.IImageHeight div 2)
      else
      with FromShape.Bounds do
           tmpY:=1+((Bottom-Top) {$IFDEF FMX}*0.5{$ELSE}div 2{$ENDIF});

      if ToShape.YCenter<tmpYC then
         Item[0].Y:=Item[0].Y-tmpY
      else
         Item[0].Y:=Item[0].Y+tmpY;
    end;

    with Item[1] do
    begin
      X:=P.X;
      Y:=P.Y;
      XStyle:=cpsFixed;
      YStyle:=cpsFixed;
    end;

    // draw arrow "from"
    With InternalArrowFrom do
         if Style<>casNone then
            Draw(Item[0],180);

    With Tree.CrossBox do
    if Visible and (Size>0) and ToShape.ShouldDrawCross and
      (FromShape=ToShape.Parent) then
    begin
      tmpY:=Item[1].Y;

      if ToShape.Y1<FromShape.Y1 then
         tmpY:=tmpY+Size
      else
         tmpY:=tmpY-Size;

      tmpY2:=Item[0].Y;

      with Tree.IBounds2D do
      begin
        if tmpY>Bottom then
           tmpY:=Bottom
        else
        if tmpY<Top then
           tmpY:=Top;

        if tmpY2>Bottom then
           tmpY2:=Bottom
        else
        if tmpY2<Top then
           tmpY2:=Top;
      end;

      if tmpY<>tmpY2 then
      begin
        if not tmpPrep then   // optimization
        begin
          PrepareCanvas;
          tmpPrep:=True;
        end;

        Tree.Canvas.VertLine3D(Item[0].X,tmpY2,tmpY,TeeTreeZ);
      end;

      tmpX:=Item[1].X;

      if ToShape.X1<FromShape.X0 then
         tmpX:=tmpX-Size
      else
         tmpX:=tmpX+Size;

      tmpY:=Item[1].Y;

      with Tree.IBounds2D do
      begin
        if (tmpY<=Bottom) and (tmpY>=Top) then
        begin
          if not tmpPrep then  // optimization
          begin
            PrepareCanvas;
            tmpPrep:=True;
          end;

          Tree.Canvas.MoveTo3D(tmpX,tmpY,TeeTreeZ);
        end;
      end;
    end
    else
    begin
      tmpY:=Item[0].Y;

      if tmpY<Tree.IBounds2D.Bottom then
      begin
        tmpY2:=Item[1].Y;

        if tmpY2>Tree.IBounds2D.Top then
        begin
          if not tmpPrep then  // optimization
          begin
            PrepareCanvas;
            tmpPrep:=True;
          end;

          Tree.Canvas.VertLine3D(Item[0].X,tmpY,tmpY2,TeeTreeZ);
        end;
      end;
    end;

    tmpArrowTo:=InternalArrowTo;

    Item[2]:=Item[1];

    With ToShape do
    if ImageAlignment=iaRight then
    begin
      Item[2].X:=AdjustedRectangle.Right;

      if tmpArrowTo.Style<>casNone then
         Item[2].X:=Item[2].X+TeeTreeArrowMargin;
    end
    else
    begin
      Item[2].X:=AdjustedRectangle.Left;

      if tmpArrowTo.Style<>casNone then
         Item[2].X:=Item[2].X-TeeTreeArrowMargin;
    end;

    Item[2].X := Item[2].X + Tree.ChartBounds.Left;

    tmpY:=Item[2].Y;

    with Tree.IBounds2D do
    if tmpY<=Bottom then
    begin
      // horizontal line
      if tmpY>Top then
      begin
        if not tmpPrep then  // optimization
        begin
          PrepareCanvas;
        end;

        Tree.Canvas.LineTo3D(Item[2].X,tmpY,TeeTreeZ);
      end;
    end;
    { Optimization fails when nodes are sorted and there are more nodes than height of treepanel
    else
    if ToShape.Parent=FromShape then
       result:=False;}

    { draw arrow "to" }
    if tmpArrowTo.Style<>casNone then
       tmpArrowTo.Draw(Item[2],ArrowToAngle);

    // Connection text
    if TextLinesCount>0 then
       DrawText(0);
  end;
end;

// Returns the XY pixel point where to display the ANode "cross-box"
Function TTreeExplorerAlignChild.CalcXYCross(const ANode,AParent:TTreeNodeShape):TPoint;

  // Returns true if parent node has an automatic connection to node.
  Function AutoConnection:Boolean;
  var tmp : TTreeConnection;
  begin
    if Assigned(AParent.FConnections) then
    begin
      tmp:=AParent.FConnections.ToShape(ANode);
      result:=Assigned(tmp) and (tmp.Style=csAuto);
    end
    else
      result:=False;
  end;

var t   : Integer;
    tmp : TCoordinate;
begin
  with ANode do
    result.Y:=((Y0+Y1) {$IFDEF FMX}*0.5{$ELSE}div 2{$ENDIF})+Tree.ChartBounds.Top; // YCenter

  if Assigned(AParent) then
  begin
    With AParent do
    begin
      if ANode.AutoPositionLeft or AutoConnection then // optimized.
      begin
        tmp:=X0+Tree.ChartBounds.Left;

        if tmp>AdjustedRectangle.Left then
           result.X:=AdjustedRectangle.Left+Tree.ChartBounds.Left+((X0-AdjustedRectangle.Left-TeePictureHorizMargin) {$IFDEF FMX}*0.5{$ELSE}div 2{$ENDIF})
        else
           result.X:=1+tmp+2*TeePictureHorizMargin;

        Exit;
      end;
    end;
  end
  else
  if ANode.AutoPositionLeft then
  With ANode.Tree.Roots do
  begin
    // speed optimization:
    // find the first auto-positioned root that is
    // previous than ANode.
    // If found, return X. If not, break loop.
    if ANode<>Items[0] then
    for t:=0 to Count-1 do
      if Items[t]=ANode then break
      else
      if Items[t].AutoPositionLeft then
      begin
        // return first-autopositioned root cross-box X pos.
        result.X:=CalcXYCross(Items[t],nil).X;
        exit;
      end;
  end;

  With ANode.Tree.CrossBox do
  if Visible then tmp:=Size {$IFDEF FMX}*0.5{$ELSE}div 2{$ENDIF}
             else tmp:=0;

  result.X:=ANode.AdjustedRectangle.Left-CrossMargin-tmp + ANode.Tree.ChartBounds.Left;
end;

// Returns True when any Root node displays the "cross-box".
Function TTreeExplorerAlignChild.AnyRootShouldDrawCross(const Tree:TCustomTree):Boolean;
var t : Integer;
begin
  With Tree do
  for t:=0 to Roots.Count-1 do
  if Roots[t].AutoPositionLeft and Roots[t].ShouldDrawCross then
  begin
    result:=True;
    Exit;
  end;

  result:=False;
end;

Function TTreeExplorerAlignChild.XPosition(const ANode:TTreeNodeShape; ABrotherIndex:Integer):Integer;

  Procedure CalcRootPosition;
  begin
    result:=2;

    with ANode do
    begin
      { Take borders into account }
      if Tree.Border.Visible then
         Inc(result, Tree.BorderWidth);

      if Tree.Page.Border.Visible then
         Inc(result, {$IFDEF FMX}Round{$ENDIF}(Tree.Page.Border.Width));

      if Tree.BevelInner<>bvNone then
         Inc(result, Tree.BevelWidth);

      if Tree.BevelOuter<>bvNone then
         Inc(result, Tree.BevelWidth);

      if Tree.ShowImages and (IImageWidth>0) then
         Inc(result,IImageWidth+TeePictureHorizMargin);

      if AnyRootShouldDrawCross(Tree) then
         Inc(result,Tree.CrossBox.Size+CrossMargin);

      With Tree.IBounds do
           Left:=Math.Min(Left,0);
    end;
  end;

var tmp : Integer;
begin
  With ANode do
  if Assigned(Parent) then // child node
  begin
    // indent X from parent
    if Tree.ShowImages and (Parent.IImageWidth=0) and
       (IImageWidth>0) then
          result:=Parent.X0+HorizMargin+IImageWidth+TeePictureHorizMargin+CrossMargin
    else
       result:=Parent.X0+HorizMargin+CrossMargin;
  end
  else
  begin
    if ABrotherIndex=0 then
       CalcRootPosition
    else
    begin
      tmp:=ABrotherIndex;

      while tmp>0 do  // search previous autopositioned root
      begin
        Dec(tmp);

        if Tree.Roots[tmp].AutoPositionLeft then
        begin
          result:=Tree.Roots[tmp].X0; // same X as previous root
          Exit;
        end;
      end;

      // if no other previous root is autopositioned, calc default pos:
      CalcRootPosition;
    end;
  end;
end;

// Returns the Y vertical pixel position for Y auto-positioned ANode.
Function TTreeExplorerAlignChild.YPosition(const ANode:TTreeNodeShape; ABrotherIndex:Integer):Integer;
begin
  With ANode do
  if Assigned(Parent) then
  begin
    if ABrotherIndex=0 then
      result:={$IFDEF FMX}Round{$ENDIF}(Parent.AdjustedRectangle.Bottom)
    else
    With TTreeNodeShape(Parent.Children.List[Pred(ABrotherIndex)]) do
    if Expanded then
       result:={$IFDEF FMX}Round{$ENDIF}(MaxHeightExpandedChilds)
    else
       result:={$IFDEF FMX}Round{$ENDIF}(AdjustedRectangle.Bottom);
  end
  else // is a root node
    if ABrotherIndex=0 then
    begin
      // first root
      result:=TopPos;

      Tree.IBounds.Top:=Math.Min(Tree.IBounds.Top,0);

      Exit;
    end
    else
    begin
      Repeat
        Dec(ABrotherIndex);

        if Tree.Roots[ABrotherIndex].AutoPositionTop then
        begin
          result:={$IFDEF FMX}Round{$ENDIF}(Tree.Roots[ABrotherIndex].MaxHeightExpandedChilds+VertMargin);
          Exit;
        end;
      Until ABrotherIndex=0;

      result:=TopPos;

      With Tree.IBounds do Top:=Math.Min(Top,0);
      
      Exit;
    end;

  Inc(result,VertMargin);
end;

// internal. To create objects of the Global Format variable
Procedure CreateGlobalFormat(var Format:TTreeGlobal; ChangeEvent:TNotifyEvent);
begin
  with Format do
  begin
    Border:=TTreePen.Create(ChangeEvent);
    Brush:=TTreeShapeBrush.Create(ChangeEvent);
    Connection:=TTreeConnection.Create(nil);
    Font:=TTeeFont.Create(ChangeEvent);

    // defaults for new added nodes...
    Transparent:=False;
    ImageIndex:=tiFolderOpenClose;
    Cursor:=crDefault;
    ShowCross:=scAuto;

    // class to use when creating new nodes:
    NodeClass:=TTreeNodeShape;

    // class to use when creating new connections:
    ConnectionClass:=TTreeConnection;

    // children manager...
    ChildManager:=TTreeExplorerAlignChild.Create;
  end;
end;

// internal. To destroy objects of the Global Format variable
Procedure FreeGlobalFormat(var Format:TTreeGlobal);
begin
  with Format do
  begin
    Border.Free;
    Brush.Free;
    Connection.Free;
    Font.Free;
    ChildManager.Free;
  end;
end;

type
  TTeeZoomPenAccess=class(TTeeZoomPen);

{ TCustomTree }

Constructor TCustomTree.Create(AOwner: TComponent);
{$IFDEF TEETRIALTREE}
Const TreeFirstTimeTrial:Boolean=True;
{$ENDIF}
begin
  inherited;

  AutoRepaint:=False;

  CreateGlobalFormat(GlobalFormat,GlobalFormatChanged);

  FAllowDelete     :=True;
  FAllowResize     :=True;
  
  FReadOnly        :=False;
  FSingleSelection :=True;
  FScrollMouse     :={$IFDEF FMX}TMouseButton.{$ENDIF}mbRight;
  CreateConnections:=True;

  FDragDrop        :=TTreeDragDrop.Create;

  AssignParent     :=csDesigning in ComponentState;
  NoOwnerShapes    :=not AssignParent; //this means that default at runtime, no trees can be saved!

  FSnapToGrid      :=True;
  FShowRootCross   :=True;

  {$IFNDEF FMX}
  TabStop          :=True;
  {$ENDIF}

  Color            :=clWhite;

  BevelInner       :=bvLowered;
  BevelOuter       :=bvLowered;

  BorderStyle      :=bsNone;

  FShowHintShapes  :=True;
  FSelected        :=TSelectedShapeList.Create(Self);

  FShapes          :=TTreeShapeList.Create;
  FShapes.ITree    :=Self;

  FShapes.Visible  :=True;

  ShowImages       :=True;
  ShowText         :=True;

  FConnections     :=TTreeConnectionList.Create;
  FConnections.ITree:=Self;
  FConnections.FVisible:=True; // <-- optimization, to avoid overriden Constructor

  FRoots           :=TNodeShapeList.Create;
  FRoots.ITree     :=Self;

  FGrid            :=TTreeGrid.Create(Self);

  FCrossBox        :=TTreeNodeCrossBox.Create(Self);

  { scroll bars }
  FHorzScroll      :=TTeeScrollBar.Create(Self,True);
  FVertScroll      :=TTeeScrollBar.Create(Self,False);

  FHotTrack        :=TTreeHotTrack.Create(Self);
  FPage            :=TTreePage.Create(Self);

  FTextEditor      :=TTreeTextEditor.Create;

  View3DOptions.OnScrolled:=View3DScrolled;
  View3DOptions.OnChangedZoom:=View3DChangedZoom;

  SetDefaultCapacity; // internal capacity for lists

  FConnHandle:=-1; // internal, for connection points dragging

  Zoom.Pen.Color:=clBlack;

  TTeeZoomPenAccess(Zoom.Pen).DefaultColor:=clBlack;

  MarginLeft:=0;
  MarginTop:=0;
  MarginRight:=0;
  MarginBottom:=0;
  View3D:=True;

  AutoRepaint:=True;

  {$IFDEF TEETRIALTREE}
  if TreeFirstTimeTrial and (not (csDesigning in ComponentState)) then
  begin
    TeeShowTreeAbout('');
    TreeFirstTimeTrial:=False;
  end;
  {$ENDIF}
end;

Destructor TCustomTree.Destroy;
begin
  AutoRepaint:=False;
  Clear;

  FGrid.Free;
  FHorzScroll.Free;
  FVertScroll.Free;
  FSelected.Free;
  FShapes.Free;
  FDragDrop.Free;
  FConnections.Free;
  FRoots.Free;
  FCrossBox.Free;
  FHotTrack.Free;
  FPage.Free;
  FTextEditor.Free;
  FreeGlobalFormat(GlobalFormat);

  inherited;
end;

Function TCustomTree.Destroying:Boolean;
begin
  result:=csDestroying in ComponentState;
end;

procedure TCustomTree.GlobalFormatChanged(Sender:TObject);
var t : Integer;
begin
  if Assigned(Shapes) then
  for t:=0 to Shapes.Count-1 do
  with FShapes[t] do
    if FAutoSize then
       IAutoSized:=False;

  CanvasChanged(Sender);
end;

Procedure TCustomTree.FinishEditing(SetNewText:Boolean);
begin { hide the Memo and set new node text }
  if Assigned(InternalMemo) then
  begin
    if SetNewText then
       IEditShape.Text.Assign(TextEditor.Memo.Lines);

    InternalMemo.Parent:=nil;
    SetFocus;

    if Assigned(FOnStopEditing) then
       FOnStopEditing(IEditShape);
  end;

  IEditing:=False;
end;

{$IFDEF FMX}
procedure TCustomTree.EditKeyDown(Sender: TObject; var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
{$ELSE}
procedure TCustomTree.EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
{$ENDIF}
begin
  if Editing then
     if Key=TeeTree_EscapeKey then
        FinishEditing(False)
     else
     if Key=TextEditor.ShortCut then
        StopEditing;
end;

Procedure TCustomTree.StartEditing(const AShape:TTreeNodeShape);
var P   : TPoint;
    tmp : Boolean;
begin { show a Memo control to edit the AShape text }
  IEditing:=True;
  IEditShape:=AShape.GetEditedShape;

  if not Assigned(TextEditor.Memo) then
  begin
    TextEditor.FMemo:=TMemo.Create(nil);
    TextEditor.Memo.OnKeyDown:=EditKeyDown;

    {$IFDEF FMX}
    TextEditor.Memo.ShowScrollBars:=False;
    {$ENDIF}
  end;

  With TextEditor.Memo do
  begin
    Visible:=False;
    Parent:=Self;

    With IEditShape do
         P:=Self.Canvas.Calculate3DPosition(X0,Y0,TeeTreeZ);

    {$IFDEF FMX}
    Position.X:=P.X;
    Position.Y:=P.Y;
    {$ELSE}
    Left:=P.X;
    Top:=P.Y;
    {$ENDIF}

    IChangingMemo:=True;
    Lines:=IEditShape.Text;
    SelectAll;

    {$IFNDEF FMX}
    if SelLength>2 then
       SelLength:=SelLength-2;

    Ctl3D:=False;
    {$ENDIF}

    IChangingMemo:=False;
    tmp:=True;

    // Call event.
    if Assigned(FOnStartEditing) then
       FOnStartEditing(IEditShape,tmp);

    // If accepted to show the memo...
    if tmp then
    begin
      if TextEditor.UseNodeSize then
      begin
        Width:=Math.Max(10,Round(IEditShape.Width*0.01*View3DOptions.Zoom));
        Height:=Math.Max({$IFDEF FMX}18{$ELSE}5{$ENDIF},Round(IEditShape.Height*0.01*View3DOptions.Zoom));
      end;

      if TextEditor.UseNodeFormat then
      begin
        if IEditShape.Border.Visible then
           BorderStyle:=bsSingle
        else
           BorderStyle:=bsNone;

        Color:=IEditShape.Color;
      end;

      if TextEditor.UseNodeFont then
         Font:=IEditShape.Font;

      Visible:=True;

      {$IFDEF D17}
      Show;
      {$ENDIF}

      SetFocus;
    end
    else
    begin
      {$IFDEF D17}
      Hide;
      {$ELSE}
      Visible:=False;
      {$ENDIF}

      IEditing:=False;
    end;
  end;
end;

Procedure TCustomTree.StopEditing;
begin
  if Editing then
     FinishEditing(True); { remove Memo }
end;

Procedure TCustomTree.ChangeSelection(const ANode:TTreeNodeShape);
var Allow : Boolean;
begin
  Allow:=True;

  if Assigned(FOnChanging) then
     FOnChanging(Self,ANode,Allow);

  if Allow then
  begin
    Selected.Clear;
    ANode.Selected:=True;
  end;
end;

type
  TTreeNodeMoveDir=(dirLeft,dirRight,dirUp,dirDown);

procedure TCustomTree.ProcessKey(Key: Word; Shift: TShiftState);

   Function RootOf(const ANode:TTreeNodeShape):TTreeNodeShape;
   begin
     result:=ANode;

     while Assigned(result.Parent) do
           result:=result.Parent;
   end;

   Procedure TrySelectNextRoot(const ANode:TTreeNodeShape);
   Var tmp : Integer;
   begin
     tmp:=Roots.IndexOf(RootOf(ANode));

     if tmp<Roots.Count-1 then
        ChangeSelection(Roots[tmp+1])
     else
     if (FNavigation=tnCircularExplorer) and (tmp>0) then
        ChangeSelection(Roots[0]);
   end;

   Procedure TrySelectParentBrother(const AShape:TTreeNodeShape);
   var tmp : Integer;
   begin
     if Assigned(AShape) then
     With AShape do
     if Assigned(Parent) then
     begin
       tmp:=BrotherIndex;

       if tmp=Parent.Children.Count-1 then
          TrySelectParentBrother(Parent)
       else
          ChangeSelection(Parent.Children[tmp+1]);
     end
     else
       TrySelectNextRoot(AShape);
   end;

   Function GetNavigateNode(const ANode:TTreeNodeShape):TTreeNodeShape;
   begin
     result:=ANode;

     While Assigned(result) and
        result.Expanded and
        result.HasChilds do
           result:=result.Children.Last;
   end;

   Procedure TrySelectRoot(const ARoot:TTreeNodeShape);
   Var Node : TTreeNodeShape;
   begin
     Node:=GetNavigateNode(ARoot);

     if Assigned(Node) then
        ChangeSelection(Node);
   end;

   Function TryGetSelectedFirst:Boolean;
   begin
     result:=Selected.First<>nil;

     if not result then
        if Roots.Count>0 then
           Roots[0].Selected:=True;
   end;

   Procedure NavigateUp;
   Var tmp : Integer;
   begin
     if TryGetSelectedFirst then
     With Selected.First do
     begin
       if Assigned(Parent) then
       begin
         tmp:=BrotherIndex;

         if tmp=0 then
         begin
           if Parent.Visible then
              ChangeSelection(Parent);
         end
         else
           TrySelectRoot(PreviousBrother);
       end
       else
       begin
         tmp:=Roots.IndexOf(Self.Selected.First);

         if tmp>0 then
            TrySelectRoot(Roots[tmp-1])
         else
         if FNavigation=tnCircularExplorer then
            if Roots.Count>1 then
               TrySelectRoot(Roots.Last)
            else
               ChangeSelection(GetNavigateNode(Self.Selected.First));
       end;
     end;
   end;

   Procedure NavigateDown;
   var Node : TTreeNodeShape;
   begin
     if TryGetSelectedFirst then
     With Selected.First do
     begin
       if Expanded and HasChilds then
          ChangeSelection(Children[0])
       else
       begin
         Node:=Self.Selected.First;
         TrySelectParentBrother(Node);

         if Self.Selected.Count>0 then
            if Node=Self.Selected.First then
               TrySelectNextRoot(Node);
       end;
     end;
   end;

   Procedure MultiNavigate(Up:Boolean);
   var t : Integer;
   begin
     for t:=1 to TreePageScrollQuantity do
         if Up then NavigateUp else NavigateDown;
   end;

   Procedure ExplorerNavigation;
   var tmp : TTreeNodeShape;
   begin
     Case Key of
       TeeTree_HomeKey  : if Roots.Count>0 then
                             ChangeSelection(Roots[0]);

       TeeTree_UpKey    : NavigateUp;
       TeeTree_DownKey  : NavigateDown;
       TeeTree_PriorKey : MultiNavigate(True);
       TeeTree_NextKey  : MultiNavigate(False);

       TeeTree_RightKey : if TryGetSelectedFirst then
                            with Selected.First do
                            if (HasChilds or (ShowCross=scAlways)) and
                               (not Expanded) then
                            begin
                              Expanded:=True;
                              Selected:=True;
                            end
                            else
                              NavigateDown;

        TeeTree_LeftKey : if TryGetSelectedFirst then
                            With Selected.First do
                            if Expanded then
                            begin
                              Expanded:=False;
                              Selected:=True;
                            end
                            else
                              NavigateUp;

         TeeTree_EndKey : if Roots.Count>0 then
                          begin
                            tmp:=Roots.Last;

                            while tmp.Expanded and tmp.HasChilds do
                                  tmp:=tmp.Children.Last;

                            ChangeSelection(tmp);
                          end;
     end;
   end;

    Procedure NearestNavigation;

      Function GetNearest(const ANode:TTreeNodeShape; const Dir:TTreeNodeMoveDir):TTreeNodeShape;
      var t          : Integer;
          resultDist : Double;
          tmpCX      : Double;
          tmpCY      : Double;

        Function DistToShape(const AShape:TTreeNodeShape):Double;
        begin
          result:=Sqrt( Sqr( tmpCX-AShape.XCenter )+
                        Sqr( tmpCY-AShape.YCenter ) );
        end;

        Procedure AssignResult;

          Function Calc(const AShape:TTreeNodeShape):TTreeNodeShape;
          begin
            result:=AShape;
            resultDist:=DistToShape(result);
          end;

        begin
          if (not Assigned(result)) or (DistToShape(Shapes[t])<resultDist) then
          begin
            Case Dir of
              dirLeft : if Shapes[t].XCenter<tmpCX then result:=Calc(Shapes[t]);
              dirRight: if Shapes[t].XCenter>tmpCX then result:=Calc(Shapes[t]);
              dirUp   : if Shapes[t].YCenter<tmpCY then result:=Calc(Shapes[t]);
              dirDown : if Shapes[t].YCenter>tmpCY then result:=Calc(Shapes[t]);
            end;
          end;
        end;

      Var tmp : Boolean;
      begin
        result:=nil;

        tmpCX:=ANode.XCenter;
        tmpCY:=ANode.YCenter;

        for t:=0 to Shapes.Count-1 do
        begin
          if (Shapes[t]<>ANode) and Shapes[t].Visible then
          begin
            if Assigned(result) then
            begin
              case Dir of
                dirLeft : tmp:=(tmpCX-Shapes[t].XCenter)<(tmpCX-result.XCenter);
                dirRight: tmp:=(Shapes[t].XCenter-tmpCX)<(result.XCenter-tmpCX);
                dirUp   : tmp:=(tmpCY-Shapes[t].YCenter)<(tmpCY-result.YCenter);
                dirDown : tmp:=(Shapes[t].YCenter-tmpCY)<(result.YCenter-tmpCY);
              else
                tmp:=False;
              end;

              if tmp then
                 AssignResult;
            end
            else
              AssignResult;
          end;
        end;

        if result=ANode then
           result:=nil;
      end;

    var tmp:TTreeNodeShape;
    begin
      tmp:=nil;

      if Selected.Count>0 then
      Case Key of
        TeeTree_UpKey    : tmp:=GetNearest(Selected.First,dirUp);
        TeeTree_DownKey  : tmp:=GetNearest(Selected.First,dirDown);
        TeeTree_LeftKey  : tmp:=GetNearest(Selected.First,dirLeft);
        TeeTree_RightKey : tmp:=GetNearest(Selected.First,dirRight);
      end;

      if Assigned(tmp) then
         ChangeSelection(tmp);
    end;

var DeltaX : Integer;
    DeltaY : Integer;
    t      : Integer;
    Jump   : Integer;
Begin
  DeltaX:=0;
  DeltaY:=0;

  if Key=TeeTreeDeleteKey then  // delete key ?
  begin
    if AllowDelete and (not ReadOnly) then
       Selected.Delete;

    Exit;
  end;

  if (ssCtrl in Shift) and (ssShift in Shift) then Jump:=10
                                              else Jump:=1;

  Case Key of
    TeeTree_EscapeKey: if Editing then
                          FinishEditing(False) { Hide editor Memo }
                       else
                       if Connecting then
                          StopConnecting { Stop connecting }
                       else
                       if Assigned(IPolygonMode) then { Stop / Finish drawing polygon }
                       begin
                         IPolygonMode:=nil;

                         if Assigned(IPolygonShape) then
                         begin
                           Selected.Clear;

                           with IPolygonShape do
                           begin
                             { delete last temporary point }
                             Points[Points.Count-1].{$IFDEF AUTOREFCOUNT}DisposeOf{$ELSE}Free{$ENDIF};
                             IAutoSized:=False;

                             { select newly added Polygon shape }
                             Selected:=True;

                             if Assigned(OnNewPolygon) then
                                OnNewPolygon(Self,IPolygonShape);

                             { repaint }
                             Invalidate;
                           end;

                           IPolygonShape:=nil;
                         end;
                       end
                       else
                          Selected.Clear; { simply clear node selection }

    TeeTree_HomeKey,
    TeeTree_UpKey,
    TeeTree_PriorKey : DeltaY:=-Jump;
    TeeTree_EndKey,
    TeeTree_DownKey,
    TeeTree_NextKey  : DeltaY:= Jump;
    TeeTree_LeftKey  : DeltaX:=-Jump;
    TeeTree_RightKey : DeltaX:= Jump;

    TeeTree_ReturnKey:
               { expand / collapse selected node }
               if Selected.Count>0 then
               With Selected.First do
               begin
                 Toggle;
                 Selected:=True;
                 Exit;
               end;

    TeeTree_SpaceKey:
               { check / uncheck selected nodes }
               if (not Editing) and (not Designing) then
                  Selected.ToggleCheck;
  else
  begin
    if Key=TextEditor.ShortCut then
       if (not FReadOnly) and (Selected.Count>0) then
          if TextEditor.Enabled and
             ( (TextEditor.Mode=tteKey) or (TextEditor.Mode=tteBoth) ) then
             StartEditing(Selected.First);
    Exit;
  end;
  end;

  if Designing and ((ssCtrl in Shift) or (ssShift in Shift)) then
  begin
    { move or resize selected nodes }
    for t:=0 to Selected.Count-1 do
    With Selected[t] do
    if ssCtrl in Shift then
       DoMove(DeltaX,DeltaY,ssAlt in Shift)
    else
       Resize(rcRightBottom,DeltaX,DeltaY)
  end
  else
  { delegate keyboard navigation }
  Case FNavigation of
    tnExplorer,
    tnCircularExplorer: ExplorerNavigation;
    tnNearest         : NearestNavigation;
  end;
end;

{$IFDEF FMX}
procedure TCustomTree.KeyDown(var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
{$ELSE}
procedure TCustomTree.KeyDown(var Key: Word; Shift: TShiftState);
{$ENDIF}
begin
  inherited;

  {$IFDEF FMX}
  if Key=0 then
     Key:=Ord(KeyChar);
  {$ENDIF}

  ProcessKey(Key,Shift);
end;

Procedure TCustomTree.SetCrossBox(const Value:TTreeNodeCrossBox);
begin
  FCrossBox.Assign(Value);
end;

{$IFNDEF FMX}
procedure TCustomTree.CreateParams(var Params: TCreateParams);
begin
  inherited;

  with Params do
       Style:=Style or WS_HSCROLL or WS_VSCROLL;
end;
{$ENDIF}

Procedure TCustomTree.SetGridColor(const Value:TColor);
begin
  FGrid.Color:=Value;
end;

procedure TCustomTree.SetSingleSelection(Value:Boolean);
begin
  FSingleSelection:=Value;

  if FSingleSelection then
     While Selected.Count>1 do
           Selected[1].Selected:=False;
end;

Procedure TCustomTree.SetHorzScrollBar(const Value:TTeeScrollBar);
begin
  FHorzScroll.Assign(Value);
end;

Procedure TCustomTree.SetVertScrollBar(const Value:TTeeScrollBar);
begin
  FVertScroll.Assign(Value);
end;

procedure TCustomTree.SetSelected(const Value:TSelectedShapeList);
begin
  FSelected.Assign(Value);
end;

procedure TCustomTree.SetScrollParams;
begin
  FHorzScroll.SetScrollParams(-View3DOptions.HorizOffset);
  FVertScroll.SetScrollParams(-View3DOptions.VertOffset);
end;

{public methods to re-initialize home ZoomReset position}
procedure TCustomTree.ZoomSetHome;
begin
  FZoomDefault.ZoomPercent:=View3DOptions.Zoom;
  FZoomDefault.HorizOffset:=View3DOptions.HorizOffset;
  FZoomDefault.VertOffset:=View3DOptions.VertOffset;
end;

procedure TCustomTree.ZoomSetHome(const ZoomParams:TTreeZoomDefault);
begin
  FZoomDefault.ZoomPercent:=ZoomParams.ZoomPercent;
  FZoomDefault.HorizOffset:=ZoomParams.HorizOffset;
  FZoomDefault.VertOffset:=ZoomParams.VertOffset;
end;

{$IFNDEF FMX}
procedure TCustomTree.CreateWnd;
begin
  inherited;

  SetScrollParams;
  ZoomSetHome;
end;
{$ENDIF}

procedure TCustomTree.Loaded;
begin
  inherited;

  SetScrollParams;
  ZoomSetHome;
end;

{$IFNDEF FMX}
procedure TCustomTree.WMHScroll(var Msg: TWMHScroll);
begin
  if Msg.ScrollCode=sb_EndScroll then
  begin
    if not FHorzScroll.Visible then
       Repaint
  end
  else
    View3DOptions.HorizOffset:=-FHorzScroll.CalcScrollOffset(Msg.ScrollCode)
end;

procedure TCustomTree.WMVScroll(var Msg: TWMVScroll);
begin
  if Msg.ScrollCode=sb_EndScroll then
  begin
    if not FVertScroll.Visible then
       Repaint
  end
  else
    View3DOptions.VertOffset:=-FVertScroll.CalcScrollOffset(Msg.ScrollCode)
end;
{$ENDIF}

Function TCustomTree.Rectangle2DPosition(Const R:TRect):TRect;
begin
  { convert from screen pixels to logical pixels }
  result:=R;

  {$IFDEF FMX}
  Calc2DPos(Canvas,result);
  {$ELSE}
  Canvas.Calculate2DPosition(result.Left,result.Top,TeeTreeZ);
  Canvas.Calculate2DPosition(result.Right,result.Bottom,TeeTreeZ);
  {$ENDIF}
end;

// Scroll tree to make sure the first selected node is visible
Procedure TCustomTree.SelectedScroll;
var R   : TRect;
    tmp : TCoordinate;
begin
  if EqualRect(ChartBounds,TeeZeroRect) then
     Exit;

  InternalCanvas.Projection(100,ChartBounds,ChartBounds);

  R:=ChartBounds;

  if BevelInner<>bvNone then
     InflateRect(R,-BevelWidth,-BevelWidth);

  if BevelOuter<>bvNone then
     InflateRect(R,-BevelWidth,-BevelWidth);

  R:=Rectangle2DPosition(R);

  if (Selected.First.Parent = nil) then
  begin
    With Selected.First do
    begin
      tmp:=R.Bottom-Y1;

      if tmp<0 then
         with View3DOptions do
              VertOffsetFloat:=VertOffset+tmp
      else
      begin
        tmp:=Y0-R.Top;

        if tmp<0 then
           with View3DOptions do
                VertOffsetFloat:=VertOffset-tmp;
      end;

      tmp:=R.Right-X0;

      if tmp<0 then
         with View3DOptions do
              HorizOffsetFloat:=HorizOffset+tmp
      else
      begin
        tmp:=X1-R.Left;

        if tmp<0 then
           with View3DOptions do
                HorizOffsetFloat:=HorizOffset-tmp;
      end;
    end;
  end
  else
  begin
    With Selected.First.AdjustedRectangle do
    begin
      tmp:=R.Bottom-Bottom;

      if tmp<0 then
         with View3DOptions do
              VertOffsetFloat:=VertOffset+tmp
      else
      begin
        tmp:=Top-R.Top;

        if tmp<0 then
           with View3DOptions do
                VertOffsetFloat:=VertOffset-tmp;
      end;

      tmp:=R.Right-Right;

      if tmp<0 then
         with View3DOptions do
              HorizOffsetFloat:=HorizOffset+tmp
      else
      begin
        tmp:=Left-R.Left;

        if tmp<0 then
           with View3DOptions do
                HorizOffsetFloat:=HorizOffset-tmp;
      end;
    end;
  end;
end;

Function TCustomTree.ClickedShape(x,y:Integer):TTreeNodeShape;
begin { return the Shape that contains the mouse XY position }
  result:=Shapes.Clicked(x,y);
end;

Function TCustomTree.InstanceName(const AShape:TTreeNodeShape):String;
begin
  result:=AShape.ClassName;

  if UpperCase(Copy(result,1,1))='T' then
     Delete(result,1,1);
end;

Function TCustomTree.AddCloneShape(const AShape:TTreeNodeShape):TTreeNodeShape;
begin { create, add and return a new shape, clone of AShape parameter }

  result:=CloneShape(AShape);
  result.Visible:=True;

  if not NoOwnerShapes then
  begin
    result.Name:=FindFreeName(result);

    if result.TextLinesCount=0 then
       result.FTextString:=result.Name;
  end;
end;

Function TCustomTree.CloneShape(const AShape:TTreeNodeShape):TTreeNodeShape;
var t        : Integer;
    tmpShape : TTreeNodeShape;
    tmpConn  : TTreeConnection;
begin { duplicate and return a shape }
  result:=TTreeNodeShapeClass(AShape.ClassType).Create(Owner);

  With result do
  begin
    Assign(AShape);
    Tree:=Self;
    FVisible:=False;
  end;

  { Clone Children nodes }
  for t:=0 to AShape.Children.Count-1 do
  begin
    tmpShape:=AddCloneShape(AShape.Children[t]);
    tmpShape.Parent:=result;

    { if we have a connection to this child node, add it }
    if Assigned(AShape.FConnections) then
    begin
      tmpConn:=AShape.Connections.ToShape(AShape.Children[t]);

      if Assigned(tmpConn) then
         result.AddConnection(tmpShape).Assign(tmpConn);
    end;
  end;
end;

Function TCustomTree.LoadFromStrings(const Strings:TStrings):TTreeNodeShape;
var St        : String;
    i,t,
    Level     : Integer;
    ANode     : TTreeNodeShape;
    OldAssign : Boolean;
begin { create a new root and children nodes from text in Strings }
  result:=nil;
  Level:=0;
  ANode:=nil;

  OldAssign:=AssignParent;
  AssignParent:=False;

  AutoRepaint:=False;

  try
    for t:=0 to Strings.Count-1 do
    begin
      St:=Strings[t];

      if not Assigned(result) then
      begin
        result:=AddRoot(St);
        ANode:=result;
        Level:=0;
      end
      else
      begin
        i:=0;

        While Copy(St,1,1)=' ' do
        begin
          Inc(i);
          Delete(St,1,1);
        end;

        if i=0 then
        begin
          ANode:=AddRoot(St);
          Level:=0;
        end
        else
        if i=Level then
           ANode:=ANode.AddBrother(St)
        else
        begin
          if i>Level then
          begin
            ANode:=ANode.AddChild(St);
            Inc(Level);
          end
          else
          begin
            While i<Level do
            begin
              ANode:=ANode.Parent;
              Dec(Level);
            end;

            if Assigned(ANode) then
               ANode:=ANode.AddBrother(St)
            else
            begin
              ANode:=AddRoot(St);
              Level:=0;
            end;
          end;
        end;
      end;
    end;
  finally
    AutoRepaint:=True;
    AssignParent:=OldAssign;
    Invalidate;
  end;
end;

Function TCustomTree.LoadFromTextFile(Const FileName:String):TTreeNodeShape;
Var tmpStrings : TStringList;
begin { load a text file and create nodes }
  tmpStrings:=TStringList.Create;
  try
    tmpStrings.LoadFromFile(FileName);
    result:=LoadFromStrings(tmpStrings);
  finally
    tmpStrings.Free;
  end;
end;

// Remove the AShape from all internal collections
Procedure TCustomTree.RemoveShape(const AShape:TTreeNodeShape);
begin
  Shapes.Remove(AShape);
  Selected.Shapes.Remove(AShape);
  Roots.Remove(AShape);
end;

// Backup all Tree events, for later reuse
Procedure TCustomTree.SaveEvents(Var SavedEvents:TTreeEvents);
begin
  With SavedEvents do
  begin
    FAfterDraw           :=OnAfterDraw;
    FBeforeDraw          :=OnBeforeDraw;
    FMouseDown           :=OnMouseDown;
    FMouseMove           :=OnMouseMove;
    FMouseUp             :=OnMouseUp;
    FChanging            :=FOnChanging;
    FCheckedShape        :=FOnCheckedShape;
    FClickBackground     :=FOnClickTree;
    FClickConnection     :=FOnClickConnection;
    FClickShape          :=FOnClickShape;
    FMovingShape         :=FOnMovingShape;
    FMouseEnterShape     :=FOnMouseEnterShape;
    FMouseLeaveShape     :=FOnMouseLeaveShape;
    FDblClickConnection  :=FOnDblClickConnection;
    FDblClickShape       :=FOnDblClickShape;
    FDeletingShapes      :=FOnDeletingShapes;
    FDeletedShapes       :=FOnDeletedShapes;
    FExpandedCollapsed   :=FOnExpandedCollapsed;
    FExpandingCollapsing :=FOnExpandingCollapsing;
    FResizingShape       :=FOnResizingShape;
    FSelectShape         :=FOnSelectShape;
    FSelectConnection    :=FOnSelectConnection;
    FUnSelectConnection  :=FOnUnSelectConnection;
    FUnSelectShape       :=FOnUnSelectShape;
    FScroll              :=OnScroll;
    FZoom                :=OnZoom;
  end;
end;

// Reuse events saved in SavedEvents record
Procedure TCustomTree.SetEvents(Const SavedEvents:TTreeEvents);
begin
  With SavedEvents do
  begin
    OnAfterDraw            :=FAfterDraw;
    OnBeforeDraw           :=FBeforeDraw;
    OnMouseDown            :=FMouseDown;
    OnMouseMove            :=FMouseMove;
    OnMouseUp              :=FMouseUp;
    FOnChanging            :=FChanging;
    FOnCheckedShape        :=FCheckedShape;
    FOnClickTree           :=FClickBackGround;
    FOnClickConnection     :=FClickConnection;
    FOnClickShape          :=FClickShape;
    FOnMovingShape         :=FMovingShape;
    FOnMouseEnterShape     :=FMouseEnterShape;
    FOnMouseLeaveShape     :=FMouseLeaveShape;
    FOnDblClickConnection  :=FDblClickConnection;
    FOnDblClickShape       :=FDblClickShape;
    FOnExpandedCollapsed   :=FExpandedCollapsed;
    FOnExpandingCollapsing :=FExpandingCollapsing;
    FOnResizingShape       :=FResizingShape;
    FOnSelectShape         :=FSelectShape;
    FOnSelectConnection    :=FSelectConnection;
    FOnDeletingShapes      :=FDeletingShapes;
    FOnDeletedShapes       :=FDeletedShapes;
    FOnUnSelectConnection  :=FUnSelectConnection;
    FOnUnSelectShape       :=FUnSelectShape;
    OnScroll               :=FScroll;
    OnZoom                 :=FZoom;
  end;
end;

// These two methods just to have a default way to refer to Tree nodes.
// Example :
// Tree1[23].Color:=clRed is equivalent to Tree1.Shapes[23].Color:=clRed;

Function TCustomTree.GetShape(Index:Integer):TTreeNodeShape;
begin
  result:=Shapes[Index];
end;

Procedure TCustomTree.SetShape(Index:Integer; const Value:TTreeNodeShape);
begin
  raise Exception.Create(TreeMsg_CannotSetShape);
end;

// Called when the user (or program) changes the View3DOptions
// HorizOffset or VertOffset properties. (ie: Scrolls using the mouse)
Procedure TCustomTree.View3DScrolled(IsHoriz:Boolean);
begin
  if (not (csLoading in ComponentState)) and
     (not (csDestroying in ComponentState)) then
  begin
    if IsHoriz then
       FHorzScroll.SetPosition(-View3DOptions.HorizOffset)
    else
       FVertScroll.SetPosition(-View3DOptions.VertOffset);

    if Assigned(OnScroll) then
       OnScroll(Self);
  end;
end;

// Called when the user (or program) changes the View3DOptions
// Zoom property.
Procedure TCustomTree.View3DChangedZoom(NewZoom:Integer);
var tmp : Double;
    x,y: Double;
begin
  if ZoomCentered then
     ZoomFromCenter(NewZoom,ChartXCenter,ChartYCenter)
  else
  begin
    tmp:=1-(0.01*(View3DOptions.Zoom-NewZoom));

    with View3DOptions do
    begin
      x:=ChartXCenter-(ChartXCenter*tmp);
      y:=ChartYCenter-(ChartYCenter*tmp);

      HorizOffsetFloat:=HorizOffsetFloat-x;
      VertOffsetFloat :=VertOffsetFloat-y;
    end;
  end;

  if Assigned(OnZoom) then
     OnZoom(Self);
end;

Procedure TCustomTree.SetGridStep(const Value:Integer);
begin
  FGrid.Step:=Value;
end;

// Zooms the R rectangle coordinates
Procedure TCustomTree.ZoomRectangle(R:TRect);

  Procedure Zoom3DRect(const R:TRect);
  var P0    : TPoint;
      P1    : TPoint;
      l1    : Double;
      l2    : Double;
      P     : TPoint;
      xc,yc : Integer;
      IZoom : Double;
  begin
    View3DOptions.OnScrolled:=nil;
    View3DOptions.OnChangedZoom:=nil;

    P0:=R.TopLeft;
    P1:=R.BottomRight;
    l1:=Sqrt(Sqr(P1.X-P0.X)+Sqr(P1.Y-P0.Y));

    P:=Canvas.Calculate3DPosition((P0.X+P1.X) {$IFDEF FMX}*0.5{$ELSE}div 2{$ENDIF},
                                  (P0.Y+P1.Y) {$IFDEF FMX}*0.5{$ELSE}div 2{$ENDIF},TeeTreeZ);
    P.X:=P.X-ChartXCenter;
    P.Y:=P.Y-ChartYCenter;

    With View3DOptions do
    begin
      IZoom:=0.01*Zoom;
      HorizOffset:=HorizOffset-Round(IZoom*P.X);
      VertOffset :=VertOffset-Round(IZoom*P.Y);
    end;

    Canvas.Projection(100,ChartBounds,ChartBounds);

    xc:=ChartXCenter;
    yc:=ChartYCenter;
    P.x:=xc;
    P.y:=yc;

    {$IFDEF FMX}
    Calc2DPos(Canvas,P,0);
    {$ELSE}
    Canvas.Calculate2DPosition(P.x,P.y,0);
    {$ENDIF}

    l2:=Sqrt(Sqr(ChartWidth)+Sqr(ChartHeight));

    With View3DOptions do
    begin
      Zoom:=Round(100.0*l2/l1);
      IZoom:=0.01*Zoom;
      HorizOffset:=Round(IZoom*(xc-P.x));
      VertOffset :=Round(IZoom*(yc-P.y));
    end;

    View3DOptions.OnScrolled:=View3DScrolled;
    View3DOptions.OnChangedZoom:=View3DChangedZoom;
  end;

begin
  if (Abs(R.Right-R.Left)>4) and (Abs(R.Bottom-R.Top)>4) then
  begin
    With View3DOptions do
         if Zoom<1 then
            Zoom:=1;

    {$IFDEF FMX}
    R.NormalizeRect;
    {$ELSE}
    OrientRectangle(R);
    {$ENDIF}

    Zoom3DRect(Rectangle2DPosition(R));
  end;
end;

procedure TCustomTree.MouseDrawZoomRectangle;
begin
  {$IFDEF FMX}
  DelphiCanvas.BeginScene;
  {$ENDIF}

  DrawZoomRectangle;

  {$IFDEF FMX}
  DelphiCanvas.EndScene;
  {$ENDIF}
end;

// Called when mouse button is depressed...
{$IFDEF FMX}
procedure TCustomTree.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Single);
{$ELSE}
Procedure TCustomTree.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
{$ENDIF}

  Procedure SelectShapesUnderRectangle(Const R:TRect);
  var t         : Integer;
      FirstTime : Boolean;
  begin
    FirstTime:=True;

    for t:=0 to Shapes.Count-1 do
    With Shapes[t] do
    if Visible then
    begin
      if Intersect(Get3DRectangle,R) then
      begin
        if FirstTime then
        begin
          Self.Selected.Clear;
          FirstTime:=False;
        end;

        Selected:=True;
      end;
    end;
  end;

  Procedure AttachMagneticHandle;
  var tmpX : Integer;
      tmpY : Integer;
  begin
    Case Connections.FMagneticHandle of
       rcLeft        : begin tmpX:=0;   tmpY:=50;  end;
       rcRight       : begin tmpX:=100; tmpY:=50;  end;
       rcTop         : begin tmpX:=50;  tmpY:=0;   end;
       rcBottom      : begin tmpX:=50;  tmpY:=100; end;
       rcLeftTop     : begin tmpX:=0;   tmpY:=0;   end;
       rcRightBottom : begin tmpX:=100; tmpY:=100; end;
       rcLeftBottom  : begin tmpX:=0;   tmpY:=100; end;
    else
      {rcRightTop   :} begin tmpX:=100; tmpY:=0;   end;
    end;

    Connections.FMagneticHandle:=rcNone;

    with Connections.Selected.Points.Item[FConnHandle] do
    begin
      if FConnHandle=0 then
      begin
        XStyle:=cpsFromPercent;
        YStyle:=cpsFromPercent;
      end
      else
      begin
        XStyle:=cpsToPercent;
        YStyle:=cpsToPercent;
      end;

      XValue:=tmpX;
      YValue:=tmpY;
    end;

    Invalidate;
  end;

Var tmpR : TRect;
begin
  CancelMouse:=IScrolled;

  inherited;

  IScrolled:=False;

  // reset internal mouse click variables
  FDragged:=nil;

  if Connections.FMagneticHandle<>rcNone then
     AttachMagneticHandle;

  FConnHandle:=-1; // reset to -1 after above "Attach" call.

  FResizing:=rcNone;

  Panning.Active:=False;

  {$IFNDEF FMX}
  if not Panning.InsideBounds then
     SetCaptureControl(nil);
  {$ENDIF}

  // apply Zoom / Shape selection if active...
  if Zoom.Active then
  begin
    MouseDrawZoomRectangle;

    Zoom.Active:=False;

    With Zoom do
      tmpR:=TeeRect(Math.Min(X0,X1),Math.Min(Y0,Y1),Math.Max(X0,X1),Math.Max(Y0,Y1));

    if Assigned(OnZoomedArea) then
    begin
      OnZoomedArea(Rectangle2DPosition(tmpR));

      if CancelMouse then
         Exit;
    end;

    if Designing then
       SelectShapesUnderRectangle(tmpR)
    else
    if Zoom.Allow then
    begin
      if ((Zoom.X1-Zoom.X0)<-4) and ((Zoom.Y1-Zoom.Y0)<-4) then // TChart UnZoom behavior
        ZoomReset
      else
      begin
        ZoomRectangle(tmpR);

        if Assigned(OnZoom) then
           OnZoom(Self);
      end;
    end;
  end;
end;

{$IFNDEF FMX}
procedure TCustomTree.CMHintShow(var Message: TMessage);
var ANode : TTreeNodeShape;
begin
  Message.Result := 0;

  with GetCursorPos do
       ANode:=ClickedShape(X,Y);

  if Assigned(ANode) then
  with TCMHintShow(Message).HintInfo^,ANode.Bounds do
  begin
    HintPos:=ClientToScreen(Canvas.Calculate3DPosition(Left,Top-2,TeeTreeZ));
    ReShowTimeOut:=0;
  end;
end;
{$ENDIF}

// Called when moving the mouse...
{$IFDEF FMX}
procedure TCustomTree.MouseMove(Shift: TShiftState; X, Y: Single);
{$ELSE}
procedure TCustomTree.MouseMove(Shift: TShiftState; X, Y: Integer);
{$ENDIF}

  Procedure DoCancelHint; // hide hint
  begin
    if ShowHintShapes then
    begin
      Hint:='';
      {$IFNDEF FMX}
      Application.CancelHint;
      {$ENDIF}
    end;
  end;

  // Returns True if mouse is inside any shape or shape "cross-box"...
  Function CheckMouseShapes:Boolean;
  Var t   : Integer;
      x2  : TCoordinate;
      y2  : TCoordinate;
      P   : TPoint;
      NeedsHint : Boolean;
      tmp : String;
  Begin
    result:=False;

    // convert from screen XY to "Tree.Canvas" X2,Y2 (apply zoom and scroll)
    x2:=x;
    y2:=y;

    {$IFDEF FMX}
    P.X:=X;
    P.Y:=Y;
    Calc2DPos(Canvas,P);
    X:=P.X;
    Y:=P.Y;
    {$ELSE}
    Canvas.Calculate2DPosition(x2,y2,0);
    {$ENDIF}

    for t:=Shapes.Count-1 downto 0 do
    With Shapes[t] do
    if Visible then
    Begin
      if Clicked(X,Y) then
      Begin
        if not IMouseInside then
           DoMouseEnter(Shift,{$IFDEF FMX}Round{$ENDIF}(x),
                              {$IFDEF FMX}Round{$ENDIF}(y));

        if (Cursor<>crDefault) or (Self.Cursor<>Self.OriginalCursor) then
           Self.Cursor:=Cursor; { <-- mouse is over a Shape ! }

        result:=True;

        NeedsHint:=ShowHintShapes and (TextLinesCount>0) and IsVisible;

        if NeedsHint then
        begin
          P:=Canvas.Calculate3DPosition(X1,Y1,TeeTreeZ);
          NeedsHint:=PointInRect(ChartBounds, P);

          if not NeedsHint then
          begin
            P:=Canvas.Calculate3DPosition(X0,Y0,TeeTreeZ);
            NeedsHint:=PointInRect(ChartBounds, P);
          end;
        end;

        if NeedsHint then
        begin
          {$IFNDEF FMX}
          With Application do
          begin
            HintShortPause:=0;
            HintPause:=0;
          end;
          {$ENDIF}

          tmp:=SimpleText;

          // call OnShowHint event...
          if Assigned(FOnShowHint) then FOnShowHint(Self,Shapes[t],tmp);

          Hint:=tmp;
          ShowHint:=tmp<>'';
        end
        else
          DoCancelHint;

        DoMouseMove(Shift,{$IFDEF FMX}Round{$ENDIF}(X),{$IFDEF FMX}Round{$ENDIF}(Y));
      end
      else
      begin
        if IMouseInside then
           DoMouseLeave(Shift,{$IFDEF FMX}Round{$ENDIF}(X),{$IFDEF FMX}Round{$ENDIF}(Y));

        if CrossBoxClicked({$IFDEF FMX}Round{$ENDIF}(x2),{$IFDEF FMX}Round{$ENDIF}(y2)) then
        begin
          Self.Cursor:=OriginalCursor;
          result:=True;
          break;
        end;
      end;
    End;
  end;

  Function CheckMouseConnections:Boolean;
  var tmpConn : TTreeConnection;
  Begin
    result:=False;
    tmpConn:=Connections.Clicked({$IFDEF FMX}Round{$ENDIF}(x),{$IFDEF FMX}Round{$ENDIF}(y));

    if Assigned(tmpConn) then
    begin
      { mouse is over a Connection line }
      result:=True;

      if Designing and Assigned(FOnClickConnection) then
         Cursor:=TeeConnectionCursor
      else
         Cursor:=tmpConn.Cursor;
    end;
  end;

  Function DoSnapGrid(IsHoriz:Boolean; APos:Integer; Var APos2:Integer):Integer;
  var tmp : Integer;
  begin
    if IsHoriz then tmp:=FGrid.HorizStep
               else tmp:=FGrid.VertStep;

    if Abs(APos-APos2)<tmp then
       result:=0
    else
    begin
      result:=tmp*(Abs(APos-APos2) div tmp);

      if APos<APos2 then
         result:=-result;

      Inc(APos2,result);
    end;
  end;

  Function NearHandle(const AShape:TTreeNodeShape):TTreeShapeHandle;

    Function NearTheHandle(const x,y: TCoordinate):Boolean;
    begin
      result:=(Abs(Connections.FMagneticPos.X-x)<3) and
              (Abs(Connections.FMagneticPos.Y-y)<3);
    end;

  Var MidX,
      MidY,
      pX0,
      pX1,
      pY0,
      pY1  : TCoordinate;
  begin
    With AShape.Bounds do
    begin
      pX0:=Left;
      pY0:=Top;
      pX1:=Right+1;
      pY1:=Bottom+1;
    end;

    if AShape.InternalPen.Visible then
    begin
      pX1:=pX1+AShape.InternalPen.Width;
      pY1:=pY1+AShape.InternalPen.Width;
    end;

    MidY:=(pY0+pY1) {$IFDEF FMX}*0.5{$ELSE}div 2{$ENDIF};
    MidX:=(pX0+pX1) {$IFDEF FMX}*0.5{$ELSE}div 2{$ENDIF};

    if NearTheHandle(pX0,pY0) then result:=rcLeftTop else
    if NearTheHandle(pX0,pY1) then result:=rcLeftBottom else
    if NearTheHandle(pX1,pY0) then result:=rcRightTop else
    if NearTheHandle(pX1,pY1) then result:=rcRightBottom else
    if NearTheHandle(pX0,MidY) then result:=rcLeft else
    if NearTheHandle(pX1,MidY) then result:=rcRight else
    if NearTheHandle(MidX,pY0) then result:=rcTop else
    if NearTheHandle(MidX,pY1) then result:=rcBottom else
                                    result:=rcNone;
  end;

  Procedure CursorScroll(const X,Y:TCoordinate);
  var R   : TRect;
      tmp : TCoordinate;
      tmpScrolled: Boolean;
  begin
    if FDragDrop.AutoScroll then
    begin
      tmpScrolled := False;
      InternalCanvas.Projection(100,ChartBounds,ChartBounds);
      R := ChartBounds;

      tmp:=Y-R.Bottom;

      if (tmp>0) then
      begin
         with View3DOptions do
         begin
           VertOffsetFloat:=VertOffsetFloat-tmp;
           tmpScrolled := True;
         end;
      end
      else
      begin
        tmp:=Y-R.Top;

        if tmp<0 then
           with View3DOptions do
           begin
             if NegativeCoordinates or (VertOffset-tmp<0) then
             begin
               VertOffsetFloat:=VertOffsetFloat-tmp;
               tmpScrolled := True;
             end;
           end;
      end;

      tmp:=X-R.Right;

      if tmp>0 then
      begin
         with View3DOptions do
         begin
           HorizOffsetFloat:=HorizOffsetFloat-tmp;
           tmpScrolled := True;
         end;
      end
      else
      begin
        tmp:=X-R.Left;

        if tmp<0 then
          with View3DOptions do
          begin
            if NegativeCoordinates or (HorizOffset-tmp<0) then
            begin
              HorizOffsetFloat:=HorizOffsetFloat-tmp;
              tmpScrolled := True;
            end;
          end;
      end;

      if tmpScrolled then
         if Assigned(OnScroll) then
            OnScroll(Self);
    end;
  end;

  procedure CheckNegativeCoordinates(var X,Y: TCoordinate);
  begin
    if not NegativeCoordinates then
    begin
      if X < 0 then X := 0;
      if Y < 0 then Y := 0;
    end;
  end;

var t    : Integer;
    DifX : Integer;
    DifY : Integer;
    x2   : Integer;
    y2   : Integer;
    Done : Boolean;
    P    : TPoint;
    ACursor : TCursor;

begin
  if (csDesigning in ComponentState) or (ChartWidth=0) then
     Exit;

  inherited;

  if Connecting then  // connecting two nodes
  begin
    DrawConnecting(x,y,False);

    CheckNegativeCoordinates(X,Y);

    IToConnect.X:=X;
    IToConnect.Y:=Y;

    {$IFDEF FMX}
    Calc2DPos(Canvas,IToConnect.X,IToConnect.y,0);
    {$ELSE}
    Canvas.Calculate2DPosition(IToConnect.x,IToConnect.y,0);
    {$ENDIF}

    DrawConnecting(x,y,True);

    if not CheckMouseShapes then { <-- guess cursor on shape }
       Cursor:=OriginalCursor;
  end
  else
  if Assigned(IPolygonMode) and Assigned(IPolygonShape) then  // drawing a polygon
  begin
    DrawPolygon;

    {$IFDEF FMX}
    Calc2DPos(Canvas,X,Y,0);
    {$ELSE}
    Canvas.Calculate2DPosition(X,Y,0);
    {$ENDIF}

    CheckNegativeCoordinates(X,Y);
    t:=IPolygonShape.Points.Count;
    IPolygonShape.Points[t-1].X:={$IFDEF FMX}Round{$ENDIF}(X);
    IPolygonShape.Points[t-1].Y:={$IFDEF FMX}Round{$ENDIF}(Y);

    DrawPolygon;
  end
  else
  if Panning.Active then // scroll active...
  with View3DOptions do
  begin
    { Do Scroll }
    if (AllowPanning=pmBoth) or (AllowPanning=pmHorizontal) then
       HorizOffsetFloat:=HorizOffsetFloat+(X-Panning.X0);

    if (AllowPanning=pmBoth) or (AllowPanning=pmVertical) then
       VertOffsetFloat:=VertOffsetFloat+(Y-Panning.Y0);

    if (X<>Panning.X0) or (Y<>Panning.Y0) then
    begin
      Panning.X0:={$IFDEF FMX}Round{$ENDIF}(X);
      Panning.Y0:={$IFDEF FMX}Round{$ENDIF}(Y);
      IScrolled:=True;

      CancelMouse:=True;

      if Assigned(OnScroll) then
         OnScroll(Self);
     end;
  end
  else
  With Zoom do // zoom active...
  if Active then
  begin
    MouseDrawZoomRectangle;

    X1:={$IFDEF FMX}Round{$ENDIF}(X);
    Y1:={$IFDEF FMX}Round{$ENDIF}(Y);

    MouseDrawZoomRectangle;
  end
  else
  if FDesigning and Assigned(FDragged) then // dragging (moving or resizing) a node...
  begin
    CursorScroll(X,Y);

    // calculate new XY point

    {$IFDEF FMX}
    Calc2DPos(Canvas,X,Y,TeeTreeZ);
    {$ELSE}
    Canvas.Calculate2DPosition(X,Y,TeeTreeZ);
    {$ENDIF}

    CheckNegativeCoordinates(X,Y);

    if FSnapToGrid and (not (ssCtrl in Shift)) then
       // Pressing CTRL key while dragging (moving or resizing) a node
       // does NOT snap to grid...
    begin
      DifX:=DoSnapGrid(True,{$IFDEF FMX}Round{$ENDIF}(X),OriginalX);
      DifY:=DoSnapGrid(False,{$IFDEF FMX}Round{$ENDIF}(Y),OriginalY);
    end
    else
    begin
      DifX:={$IFDEF FMX}Round{$ENDIF}(X)-OriginalX;
      DifY:={$IFDEF FMX}Round{$ENDIF}(Y)-OriginalY;
      OriginalX:={$IFDEF FMX}Round{$ENDIF}(X);
      OriginalY:={$IFDEF FMX}Round{$ENDIF}(Y);
    end;

    // apply zoom
    //tmpZoom:=100.0/View3DOptions.Zoom;
    //P.X:=Round(tmpZoom*DifX);
    //P.Y:=Round(tmpZoom*DifY);

    P.X := DifX;
    P.Y := DifY;

    if (P.X<>0) or (P.Y<>0) then // if moved...
    begin
      if FResizing=rcNone then // move shape
      begin
        for t:=0 to Selected.Count-1 do
          if Selected.Shapes.IndexOf(Selected[t].Parent) = -1 then
          with Selected[t] do
          begin
            DoMove({$IFDEF FMX}Round{$ENDIF}(P.X),
                   {$IFDEF FMX}Round{$ENDIF}(P.Y),(not (ssAlt in Shift)));
          end;
      end
      else
        FDragged.Resize(FResizing,{$IFDEF FMX}Round{$ENDIF}(P.X),
                        {$IFDEF FMX}Round{$ENDIF}(P.Y)); // resize shape
    end;
  end
  else
  // if dragging a connection point...
  if FDesigning and (FConnHandle<>-1) then
  begin
    CursorScroll(X,Y);

    {$IFDEF FMX}
    Calc2DPos(Canvas,X,Y,TeeTreeZ);
    {$ELSE}
    Canvas.Calculate2DPosition(X,Y,TeeTreeZ);
    {$ENDIF}

    CheckNegativeCoordinates(X,Y);

    DifX:={$IFDEF FMX}Round{$ENDIF}(X)-OriginalX;
    DifY:={$IFDEF FMX}Round{$ENDIF}(Y)-OriginalY;
    OriginalX:={$IFDEF FMX}Round{$ENDIF}(X);
    OriginalY:={$IFDEF FMX}Round{$ENDIF}(Y);

    P.X := DifX;
    P.Y := DifY;


    if (P.X<>0) or (P.Y<>0) then // if moved...
    begin
     Connections.Selected.Points.Move(FConnHandle,{$IFDEF FMX}Round{$ENDIF}(P.X),
                 {$IFDEF FMX}Round{$ENDIF}(P.Y));

      // if first or last point is being dragged, check
      // if it is near to a "magnetic" handle in the From or To shape.

      if not (ssShift in Shift) then // if Ctrl and Shift keys are *not* pressed...

      if (FConnHandle=0) or
         (FConnHandle=Connections.Selected.Points.Count-1) then
      with Connections.Selected do
      begin
        Points.CalculatePosition(FConnHandle);

        with Points.Item[FConnHandle] do
             Connections.FMagneticPos:=TeePoint(X,Y);

        if FConnHandle=0 then
           Connections.FMagneticHandle:=NearHandle(FromShape)
        else
           Connections.FMagneticHandle:=NearHandle(ToShape)
      end;
    end;
  end
  else
  // check mouse cursor...
  begin
    Done:=False;

    if Designing then
    begin
      // check if mouse is over a connection point handle...
      if Assigned(Connections.Selected) then
      begin
        if Connections.Selected.Points.Clicked({$IFDEF FMX}Round{$ENDIF}(x),
                                      {$IFDEF FMX}Round{$ENDIF}(y))<>-1 then
        begin
          Cursor:=TeeConnectionPointCursor;
          Done:=True;
        end;
      end;

      // Check if mouse is over a shape resizing handle...
      if (not Done) and AllowResize then
      begin
        x2:={$IFDEF FMX}Round{$ENDIF}(x);
        y2:={$IFDEF FMX}Round{$ENDIF}(y);
        Canvas.Calculate2DPosition(x2,y2,0);

        for t:=Shapes.Count-1 downto 0 do
        if Shapes[t].Selected  then
        begin
          ACursor:=Shapes[t].GetHandleCursor(x2,y2);

          if ACursor<>crDefault then
          begin
            Done:=True;
            Cursor:=ACursor;
            break;
          end;
        end;
      end;

    end;
    if not Done then
       if not CheckMouseShapes then { <-- guess cursor on shape }
          if not CheckMouseConnections then { <-- guess cursor on connection }
          begin
            Cursor:=OriginalCursor;
            DoCancelHint;
          end;
  end;
end;

// Adds and returns a new top-level node
Function TCustomTree.Add(Const Text:String):TTreeNodeShape;
begin
  result:=AddRoot(Text);
end;

// Adds and returns a new child node
Function TCustomTree.Add(Const Text:String; const Parent:TTreeNodeShape):TTreeNodeShape;
begin
  result:=AddShape(0,0,Text,Parent);
  Invalidate;
end;

// Adds and returns a new child node at XY position
Function TCustomTree.Add(X,Y:Integer; Const Text:String; const Parent:TTreeNodeShape):TTreeNodeShape;
begin
  result:=AddShape(X,Y,Text,Parent);
  result.AutoPosition.Left:=False;
  result.AutoPosition.Top:=False;

  Invalidate;
end;

// Adds and returns a new top-level node
Function TCustomTree.AddRoot(Const RootText:String):TTreeNodeShape;
begin
  result:=AddShape(0,0,RootText,nil);

  Invalidate;
end;

// Adds and returns a new top-level node, setting the Data property.
Function TCustomTree.AddRootObject(Const AText:String; Data:Pointer):TTreeNodeShape;
begin
  result:=AddRoot(AText);
  result.Data:=Data;
end;

// Adds and returns a new node, setting the XY, Text and Parent properties.
Function TCustomTree.AddShape( X,Y:Integer; Const AText:String;
                               const AParentShape:TTreeNodeShape):TTreeNodeShape;
begin
  result:=AddShapeClass(X,Y,AText,AParentShape,GlobalFormat.NodeClass);
end;

procedure ReplaceInvalidChars(var S:String);
const
  ValidChars=['A'..'Z','_'];

var t : Integer;
begin
  {$IFDEF NEXTGEN}
  for t:=0 to Length(S)-1 do
  {$ELSE}
  for t:=1 to Length(S) do
  {$ENDIF}

    {$IFDEF IOS}
    {$WARN SYMBOL_DEPRECATED OFF}
    {$ENDIF}

    {$IFDEF ANDROID}
    {$WARN SYMBOL_DEPRECATED OFF}
    {$ENDIF}

    if not ({$IFDEF D12}CharInSet(UpCase(S[t]), ValidChars)
            {$ELSE}UpCase(S[t]) in ValidChars {$ENDIF}) then
      S[t]:='_';

    {$IFDEF IOS}
    {$WARN SYMBOL_DEPRECATED DEFAULT}
    {$ENDIF}

    {$IFDEF ANDROID}
    {$WARN SYMBOL_DEPRECATED DEFAULT}
    {$ENDIF}
end;

// Returns a new valid name for nodes.
Function TCustomTree.FindFreeName(Const AShape:TTreeNodeShape):String;
var t    : Integer;
    tmpS : String;
begin
  result:='';

  // Remove characters different than 'a'..'z'
  tmpS:=InstanceName(AShape);

  ReplaceInvalidChars(tmpS);

  if Assigned(AShape.Owner) then
  With AShape.Owner do
  begin
    t:=0;

    repeat

      Inc(t);
      result:=tmpS+TeeStr(t);

    Until not Assigned(FindComponent(result));
  end;
end;

// Adds a newly created node (AShape) into Tree
Procedure TCustomTree.AddNewShape( const AShape:TTreeNodeShape;
                                   X,Y:Integer;
                                   Const AText:String;
                                   const AParentShape:TTreeNodeShape);
begin
  With AShape do
  begin
    Tree:=Self;

    if AssignParent and Assigned(AParentShape) then
    begin
      Assign(AParentShape);
      FX1:=(FX1-FX0)+X;
      FY1:=(FY1-FY0)+Y;
      FX0:=X;
      FY0:=Y;
    end
    else
    if FStyle<>tssCustom then
    begin
      if not FTransparent then
         FTransparent:=GlobalFormat.Transparent;

      if FImageIndex<>GlobalFormat.ImageIndex then
      begin
        FImageIndex:=GlobalFormat.ImageIndex;
        RecalcImageSize;
      end;

      FCursor:=GlobalFormat.Cursor;
      FShowCross:=GlobalFormat.ShowCross;
    end;

    if not NoOwnerShapes then
       Name:=FindFreeName(AShape);

    FX0:=X;
    FY0:=Y;

    if AText<>'' then
    begin
      FTextString:=AText;

      // optimization. Check if Assigned before calling FreeAndNil
      if Assigned(FText) then
         FreeAndNil(FText);
    end;

    IAutoSized:=not AutoSize; { <-- When repainting, Tree will call RecalcSize }
  end;
end;

// Call OnSelectConnection event if assigned
Procedure TCustomTree.DoSelectConnection(const AConnection:TTreeConnection);
begin
  if Assigned(FOnSelectConnection) then
     FOnSelectConnection(AConnection);
end;

// Creates and returns a new node, of specified AClass
Function TCustomTree.AddShapeClass( X,Y:Integer;
                                    Const AText:String;
                                    const AParentShape:TTreeNodeShape;
                                    const AClass:TTreeNodeShapeClass ):TTreeNodeShape;
begin
  if NoOwnerShapes then
     result:=AClass.Create(nil)
  else
     result:=AClass.Create(Owner);

  // Optimization. Set Tree before calling AddNewShape,
  // to avoid unnecessary code (Tree.Roots.Add)
  result.FTree:=Self;
  result.FChildren.ITree:=Self;

  Shapes.Add(result);

  AddNewShape(result,X,Y,AText,AParentShape);

  if Assigned(AParentShape) then
  begin
    // optimization. Do not set "Parent" to avoid unnecessary code. }
    result.FParent:=AParentShape;
    result.FBrotherIndex:=AParentShape.Children.Add(result);
    result.FVisible:=AParentShape.Expanded;

    if CreateConnections then
       // call InternalAddConnection instead of AddConnection for speed reasons
       AParentShape.InternalAddConnection(result);  // speed optimization
  end
  else
  begin
    Roots.Add(result);
    result.FBrotherIndex:=-1;
  end;

  // Call OnNewShape event if used
  if Assigned(FOnNewShape) then
     FOnNewShape(Self,result);
end;

Procedure TCustomTree.SetDesignTime(Value:Boolean);
begin
  SetDesigning(Value);
end;

Procedure TCustomTree.SetDesigningField(const Value:Boolean);
begin
  SetBooleanProperty(FDesigning,Value);

  if not FDesigning then
     Selected.Clear;
end;

// Clear selection list of nodes, and sets AConnection in Selected
Procedure TCustomTree.SelectConnection(const AConnection:TTreeConnection);
begin
  if Connections.Selected<>AConnection then
  begin
    Selected.Clear;
    Connections.Selected:=AConnection;
  end;
end;

// Called when the mouse is clicked
{$IFDEF FMX}
procedure TCustomTree.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Single);
{$ELSE}
Procedure TCustomTree.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
{$ENDIF}

  // Call OnClickxxx events for node "AIndex"...
  Procedure CallEvents(const AIndex:Integer);
  begin
    if Assigned(FOnClickShape) then
       FOnClickShape(Shapes[AIndex],Button,Shift,{$IFDEF FMX}Round{$ENDIF}(x),{$IFDEF FMX}Round{$ENDIF}(y));

    if not CancelMouse then
       if Assigned(Shapes[AIndex].FOnClick) then
          Shapes[AIndex].FOnClick(Shapes[AIndex],Button,Shift,{$IFDEF FMX}Round{$ENDIF}(x),{$IFDEF FMX}Round{$ENDIF}(y));
  end;

  Procedure InitDraggedPosition;
  begin
    OriginalX:={$IFDEF FMX}Round{$ENDIF}(X);
    OriginalY:={$IFDEF FMX}Round{$ENDIF}(Y);

    Canvas.Calculate2DPosition(OriginalX,OriginalY,TeeTreeZ);
  end;

  Procedure CheckClickConnection(AEvent:TClickConnectionEvent);
  var tmpConn : TTreeConnection;
  begin
    if Assigned(AEvent) then
    begin
      tmpConn:=Connections.Clicked({$IFDEF FMX}Round{$ENDIF}(x),{$IFDEF FMX}Round{$ENDIF}(y));

      if Assigned(tmpConn) then
      begin
        FDragged:=nil;
        CancelMouse:=True;
        AEvent(tmpConn,Button,Shift,{$IFDEF FMX}Round{$ENDIF}(x),{$IFDEF FMX}Round{$ENDIF}(y));
      end;
    end;
  end;

Var x2 : Integer;
    y2 : Integer;

  Procedure ProcessDblClick;
  var t   : Integer;
      tmp : TTreeNodeShape;
  begin
    tmp:=ClickedShape({$IFDEF FMX}Round{$ENDIF}(x),{$IFDEF FMX}Round{$ENDIF}(y));

    if Assigned(tmp) then
    begin
      if Assigned(FOnDblClickShape)  then
         FOnDblClickShape(tmp,Button,Shift,{$IFDEF FMX}Round{$ENDIF}(x),{$IFDEF FMX}Round{$ENDIF}(y));

      if Assigned(tmp.FOnDblClick) then
         tmp.FOnDblClick(tmp,Button,Shift,{$IFDEF FMX}Round{$ENDIF}(x),{$IFDEF FMX}Round{$ENDIF}(y));

      if not CancelMouse then
         if Button={$IFDEF FMX}TMouseButton.{$ENDIF}mbLeft then
            if (not tmp.HasCheckBox) or (not tmp.ClickedImage(X,Y)) then
               tmp.Toggle;

      CancelMouse:=True;
    end
    else
    if Button={$IFDEF FMX}TMouseButton.{$ENDIF}mbLeft then
       for t:=Shapes.Count-1 downto 0 do
       With Shapes[t] do
       if CrossBoxClicked(x2,y2) then
       begin
         Toggle;
         CancelMouse:=True;
         break;
       end;

    if not CancelMouse then
       CheckClickConnection(FOnDblClickConnection);
  end;

  Procedure ProcessClick;  // single-click

    Procedure CheckZoom;
    begin
      if Zoom.Allow and (Button=Zoom.MouseButton) and
         (Zoom.KeyShift<=Shift) then
      begin
        Zoom.Activate({$IFDEF FMX}Round{$ENDIF}(x),{$IFDEF FMX}Round{$ENDIF}(y));
        MouseDrawZoomRectangle;
        CancelMouse:=True;
      end;
    end;

  var t   : Integer;
      tmp : Integer;
      P   : TPoint;
      Ok  : Boolean;
      tmpNode : TTreeNodeShape;
  begin
    if Button={$IFDEF FMX}TMouseButton.{$ENDIF}mbLeft then
    begin
      // when adding new shapes from editor palette,
      // drawing a rectangle like a zoom...
      if IZoomPriority then
      begin
        CheckZoom;
        if CancelMouse then Exit;
      end;

      // In PolygonMode, add a new point to the temporary PolygonShape...
      if Assigned(IPolygonMode) then
      begin
        P:=GetCursorPos;

        {$IFDEF FMX}
        Calc2DPos(Canvas,P.X,P.Y,0);
        {$ELSE}
        Canvas.Calculate2DPosition(P.X,P.Y,0);
        {$ENDIF}

        Ok:=Assigned(IPolygonShape);
        if not Ok then
        begin
          // Create polygon shape...
          IPolygonShape:=TPolygonShape(AddShapeClass(0,0,'',nil,IPolygonMode));
          IPolygonShape.Add({$IFDEF FMX}Round{$ENDIF}(P.X),{$IFDEF FMX}Round{$ENDIF}(P.Y));
        end;

        { add new point }
        IPolygonShape.Add({$IFDEF FMX}Round{$ENDIF}(P.X),{$IFDEF FMX}Round{$ENDIF}(P.Y));

        if not Ok then
           DrawPolygon;

        Exit;
      end;

      // check if mouse clicks on connection point...
      if Assigned(Connections.Selected) then
      with Connections.Selected do
      begin
        FConnHandle:=Points.Clicked({$IFDEF FMX}Round{$ENDIF}(x),{$IFDEF FMX}Round{$ENDIF}(y)); // on a connection point handle ?
        P.X := X;
        P.Y := Y;

        {$IFDEF FMX}
        Calc2DPos(Canvas,P);
        {$ELSE}
        Canvas.Calculate2DPosition(P.X,P.Y,TeeTreeZ);
        {$ENDIF}

        // if not on a handle, but clicked a connection segment,
        // add a new point.
        // (do it only when in "design" mode)
        if (FConnHandle=-1) and Designing then
        begin
           // add a new point when clicking the connection
           if Style<>csCurve then
           begin
             tmp:=ClickedSegment({$IFDEF FMX}Round{$ENDIF}(x),{$IFDEF FMX}Round{$ENDIF}(y));

             if tmp<>-1 then
             begin
               Points.Insert(tmp+1,{$IFDEF FMX}Round{$ENDIF}(P.X),{$IFDEF FMX}Round{$ENDIF}(P.Y));

               FConnHandle:=tmp+1;

               with Points.Item[tmp+1] do
               begin
                 XStyle:=cpsFromRel;
                 XValue:=x-FromShape.X0;
                 YStyle:=cpsFromRel;
                 YValue:=y-FromShape.Y0;
               end;
             end;
           end
           else
           if Clicked({$IFDEF FMX}Round{$ENDIF}(x),{$IFDEF FMX}Round{$ENDIF}(y)) then
           begin
             FConnHandle:=Points.Add({$IFDEF FMX}Round{$ENDIF}(P.X),{$IFDEF FMX}Round{$ENDIF}(P.Y));
           end;

           Invalidate;
        end;
      end
      else
        FConnHandle:=-1;

      if FConnHandle<>-1 then
      begin
        FDragged:=nil;  // un-drag shape (if any)
        InitDraggedPosition;
        CancelMouse:=True;
      end
      else
      // check if mouse clicks on shape or selected shape handle...
      for t:=Shapes.Count-1 downto 0 do
      begin
        if AllowResize and Shapes[t].Selected then
        begin
          FResizing:=Shapes[t].GetResizingHandle(X2,Y2);

          if FResizing<>rcNone then
          begin
            FDragged:=Shapes[t];
            InitDraggedPosition;
            CancelMouse:=True;
            Break;
          end;
        end;

        if Shapes[t].HasCheckBox and Shapes[t].ClickedImage(X,Y) then
        begin
          Shapes[t].ToggleCheck;
          CallEvents(t);
          CancelMouse:=True;
          break;
        end
        else
        if Shapes[t].Clicked(X,Y) then
        begin
          if Connecting then
          begin
            if not Assigned(IShape1) then
               IShape1:=Shapes[t]
            else
            if not Assigned(IShape2) then
               IShape2:=Shapes[t];

            CancelMouse:=True;
            Break;
          end;

          if Designing then
          begin
            FDragged:=Shapes[t];

            if (not FDragged.Selected) and
               (not (ssShift in Shift)) then
                  Selected.Clear;

            if ssCtrl in Shift then
               FDragged.Selected:=not FDragged.Selected
            else
               FDragged.Selected:=True;

            if ssAlt in Shift then
               FDragged.SelectChilds;

            InitDraggedPosition;
            CallEvents(t);
          end
          else
          begin
            CallEvents(t);

            if not CancelMouse then
               if Assigned(OnMouseDown) then OnMouseDown(Self,Button,Shift,x,y);

            if SingleSelection then
            begin
              if not Shapes[t].Selected then ChangeSelection(Shapes[t]);
            end
            else
            if (Selected.ShiftState=[]) or
               ((Shift*Selected.ShiftState)=Selected.ShiftState) then
               Shapes[t].Selected:=not Shapes[t].Selected
            else
            begin // multi-selection, do not call OnChanging event

              if (Selected.Count<>1) or (Selected[0]<>Shapes[t]) then
              begin
                Selected.Clear;
                Shapes[t].Selected:=True;
              end;
            end;

            // Start Drag and drop...
            if DragAndDrop.Automatic then
              if DragAndDrop.DragRoots or Assigned(Shapes[t].Parent) then
              begin
                {$IFNDEF FMX}
                BeginDrag(False,-1);
                {$ENDIF}
                FDragged:=Shapes[t];
              end;

          end;

          Shapes[t].DoClick(Button,Shift,{$IFDEF FMX}Round{$ENDIF}(x),{$IFDEF FMX}Round{$ENDIF}(y));

          CancelMouse:=True;
          break;
        end
        else
        With Shapes[t] do
        if CrossBoxClicked(x2,y2) then  // clicked on cross-box ?
        begin
          Toggle;
          CancelMouse:=True;
          break;
        end;
      end;
    end
    else
    begin
      tmpNode:=Shapes.Clicked({$IFDEF FMX}Round{$ENDIF}(x),{$IFDEF FMX}Round{$ENDIF}(y));

      if Assigned(tmpNode) then
         CallEvents(Shapes.IndexOf(tmpNode));
    end;

    // show text memo editor when clicking a selected shape...
    if (not ReadOnly) and TextEditor.Enabled and
       (Button=TextEditor.MouseButton) and
       ( (TextEditor.Mode=tteMouse) or (TextEditor.Mode=tteBoth) ) then
    begin
      for t:=0 to Selected.Count-1 do
      if Selected[t].Clicked(X,Y) then
      begin
        StartEditing(Selected[t]);
        CancelMouse:=True;
        break;
      end;
    end;

    { Check CancelMouse... }
    if not CancelMouse then
    begin
      StopEditing;  // hide text editor

      CheckClickConnection(FOnClickConnection);
    end;

    { again check CancelMouse... }
    if not CancelMouse then
    begin
      if (Button=ScrollMouseButton) and
         (AllowPanning<>pmNone) then
      begin
        Panning.Activate({$IFDEF FMX}Round{$ENDIF}(x),{$IFDEF FMX}Round{$ENDIF}(y));

        {$IFNDEF FMX}
        if not Panning.InsideBounds then
           SetCaptureControl(Self);
        {$ENDIF}
      end;

      if Button={$IFDEF FMX}TMouseButton.{$ENDIF}mbLeft then
         if Connecting then StopConnecting
                       else Selected.Clear;

      CheckZoom; // activate zoom rectangle ?

      if Assigned(FOnClickTree) then // call basic OnClick event
         FOnClickTree(Self,Button,Shift,{$IFDEF FMX}Round{$ENDIF}(x),{$IFDEF FMX}Round{$ENDIF}(y));
    end;
  end;

begin
  CancelMouse:=False;
  IScrolled:=False;

  // automatically set focus when clicking the Tree...
  if not IsLibrary then // OCX
  begin
    Selected.IFocused:={$IFDEF FMX}IsFocused{$ELSE}Focused{$ENDIF};

    if not Selected.IFocused then
       if (not (csDesigning in ComponentState)) and
          (CanFocus {$IFNDEF FMX}or (not Assigned(GetParentForm(Self))){$ENDIF}) then
              SetFocus;
  end;

  // VCL inherited...
  inherited;

  if not CancelMouse then
  begin
    x2:={$IFDEF FMX}Round{$ENDIF}(x);
    y2:={$IFDEF FMX}Round{$ENDIF}(y);

    Canvas.Calculate2DPosition(x2,y2,0);

    if ssDouble in Shift then ProcessDblClick
                         else ProcessClick;
  end;
end;

{$IFNDEF FMX}
// If there are selected nodes, re-paint Tree.
// Store in IFocused local variable the focus status.
procedure TCustomTree.InternalSetFocus(Value:Boolean);
begin
  if Selected.IFocused<>Value then
  begin
    Selected.IFocused:=Value;

    if (not FDesigning) and (Selected.Count>0) then
       Invalidate;
  end;
end;
{$ENDIF}

{$IFNDEF FMX}
procedure TCustomTree.CMFocusChanged(var Message: TCMFocusChanged);
begin
  inherited;
  InternalSetFocus(Message.Sender=Self);
end;
{$ENDIF}

Function TCustomTree.DoExpandCollapse(const AShape:TTreeNodeShape; Value:Boolean):Integer;

  Procedure InternalDoExpandCollapse(const ANode:TTreeNodeShape);
  var t : Integer;
  begin
    // Show or hide child nodes when expanding / collapsing
    for t:=0 to ANode.Children.Count-1 do
    With ANode.Children[t] do
    begin
      if Visible<>Value then
      begin
        FVisible:=Value;
        Inc(result);

        if Expanded and HasChilds then
           InternalDoExpandCollapse(ANode.Children[t]);
      end;

      // when collapsing, if child nodes are selected, then
      // make the parent (AShape) selected. And, unselect childs if
      // the tree is in single-selection mode.
      if (not Value) and Selected then
      begin
        if Self.SingleSelection then
           Selected:=False;

        ANode.Selected:=True;
      end;
    end;
  end;

begin
  result:=0;

  if Assigned(FOnExpandingCollapsing) then
     FOnExpandingCollapsing(AShape,Value);

  AShape.FExpanded:=Value; // after calling optional OnExpandingCollapsing...

  InternalDoExpandCollapse(AShape);

  StopEditing;  // hide in-line memo text editor

  // unselect connection if "From" node collapsed
  if Assigned(Connections.Selected) then
     if not Connections.Selected.Visible then
        Connections.Selected:=nil;

  if Assigned(FOnExpandedCollapsed) then
     FOnExpandedCollapsed(AShape);

  Invalidate;
end;

Procedure TCustomTree.Assign(Source:TPersistent);
begin
  if Source is TCustomTree then
  With TCustomTree(Source) do
  begin
    Self.Grid           :=FGrid;
    Self.FAllowDelete   :=FAllowDelete;
    Self.FAllowResize   :=FAllowResize;
    Self.CrossBox       :=FCrossBox;
    Self.FDesigning     :=FDesigning;
    Self.DragAndDrop    :=DragAndDrop;
    Self.HorzScrollBar  :=FHorzScroll;
    Self.HotTrack       :=HotTrack;
    Self.Images         :=FImages;
    Self.FNavigation    :=FNavigation;
    Self.Page           :=FPage;
    Self.FReadOnly      :=FReadOnly;
    Self.Selected       :=FSelected;
    Self.FSingleSelection:=FSingleSelection;
    Self.FShowRootCross :=FShowRootCross;
    Self.FSnapToGrid    :=FSnapToGrid;
    Self.TextEditor     :=TextEditor;
    Self.VertScrollBar  :=FVertScroll;
    Self.FWheelNavigation:=FWheelNavigation;
  end;

  inherited;
end;

// VCL requeriment to stream nodes to DFM form files
Procedure TCustomTree.GetChildren(Proc:TGetChildProc; Root:TComponent);
var t   : Integer;
    tmp : TTreeConnection;
begin
  inherited;

  for t:=0 to Shapes.Count-1 do
      if (not NoOwnerShapes) or Assigned(Shapes[t].Owner) then
         Proc(Shapes[t]);

  for t:=0 to Connections.Count-1 do
  begin
    tmp:=Connections[t];

    with tmp do
    if (not NoOwnerShapes) or
       Assigned(FromShape) and
       Assigned(FromShape.Owner) and
       Assigned(ToShape) and
       Assigned(ToShape.Owner) then
          Proc(tmp);
  end;
end;

// expand or collapse all nodes, recursively
Procedure TCustomTree.FullExpandCollapse(Expand:Boolean);

  Procedure InternalFull(const AShape:TTreeNodeShape);
  var t : Integer;
  begin
    With AShape do
    begin
      Expanded:=Expand;

      for t:=0 to Children.Count-1 do
          InternalFull(Children[t]);
    end;
  end;

var t : Integer;
begin
  for t:=0 to Roots.Count-1 do
      InternalFull(Roots[t]);
end;

// prepare canvas and call DoDraw to draw Tree
procedure TCustomTree.InternalDraw(Const UserRectangle:TRect);
var Old : Boolean;
begin
  Old:=AutoRepaint;
  AutoRepaint:=False;
  PanelPaint(UserRectangle);
  RecalcWidthHeight;
  InternalCanvas.Projection(100,ChartBounds,ChartBounds);
  DoDraw;
  DrawPanelBevels(UserRectangle);
  AutoRepaint:=Old;
end;

// Calculate best grid size (minimum 4 pixels)
Function TCustomTree.PrepareGrid(Var tmpH,tmpV:Integer):TRect;
begin
  tmpH:=FGrid.HorizStep;
  tmpV:=FGrid.VertStep;

  result:=IBounds2D; {Rectangle2DPosition(ChartBounds);}

  With result do
  begin
    Left:={$IFDEF FMX}((Left/tmpH)-1){$ELSE}Pred(Left div tmpH){$ENDIF}*tmpH;
    Top:={$IFDEF FMX}((Top/tmpV)-1){$ELSE}Pred(Top div tmpV){$ENDIF}*tmpV;

    if ChartWidth>0 then
       while {$IFNDEF FMX}Round{$ENDIF}(tmpH/((Right-Left)/(ChartWidth)))<4 do
             tmpH:=tmpH*2;
  end;
end;

Procedure TCustomTree.AutomaticScrollBars;
var tmpR : TRect;
    tmpPageSize: Integer;
begin
  if (HorzScrollBar.Automatic or VertScrollBar.Automatic) and
     (Shapes.Count>0) then
  begin
    tmpR:=IBounds;

    with tmpR do
    begin
      TopLeft:=Canvas.Calculate3DPosition(Left,Top,TeeTreeZ);
      BottomRight:=Canvas.Calculate3DPosition(Right,Bottom,TeeTreeZ);

      if HorzScrollBar.Automatic then
      begin
        Left:=Left-View3DOptions.HorizOffset;
        Right:=Right-View3DOptions.HorizOffset;

        tmpPageSize := {$IFDEF FMX}System.Round{$ENDIF}(Self.Width);

        {$IFNDEF FMX}
        if VertScrollBar.Visible then
           Dec(tmpPageSize,GetSystemMetrics(SM_CYVSCROLL)+5); // 5 as offset...
        {$ENDIF}

        HorzScrollBar.CheckScroll( {$IFDEF FMX}System.Round{$ENDIF}(Left),
                                   {$IFDEF FMX}System.Round{$ENDIF}(Right),View3DOptions.HorizOffset,tmpPageSize);
      end;

      if VertScrollBar.Automatic then
      begin
        Top:=Top-View3DOptions.VertOffset;
        Bottom:=Bottom-View3DOptions.VertOffset;

        tmpPageSize := {$IFDEF FMX}System.Round{$ENDIF}(Self.Height);

        {$IFNDEF FMX}
        if HorzScrollBar.Visible then
          Dec(tmpPageSize,GetSystemMetrics(SM_CXHSCROLL)+5); // 5 as offset...
        {$ENDIF}

        VertScrollBar.CheckScroll( {$IFDEF FMX}System.Round{$ENDIF}(Top),
                                   {$IFDEF FMX}System.Round{$ENDIF}(Bottom),View3DOptions.VertOffset, tmpPageSize);
      end;
    end;
  end;
end;

// Set Brush and Pen to draw selection handles
Procedure TCustomTree.PrepareDrawHandles;
begin
  // Workaround: (GDIPlus canvas "SupportsXORMode" is True, but not useful here)
  Selected.FullRedraw:=Canvas.ClassName='TGDIPlusCanvas';

  with Canvas do
  begin
    Brush.Style:=bsSolid;

    if Selected.Count>1 then
       Brush.Color:=clGray
    else
       Brush.Color:=Selected.HandleColor;

    AssignVisiblePen(Selected.HandlePen);

    {$IFNDEF FMX}
    if not Selected.FullRedraw then
       SetROP2(Handle, R2_NOTXORPEN);
    {$ENDIF}
  end;
end;

{$IFDEF PAGEBOUNDS}
procedure TCustomTree.CalculatePageBounds;

  function DoCalc(const AValue,ASize:TCoordinate):TCoordinate;
  begin
    result:=Math.Sign(AValue) * (1+(Abs(AValue) {$IFDEF FMX}/{$ELSE}div{$ENDIF} ASize)*ASize);
  end;

  function CalcHoriz(const AValue:TCoordinate):TCoordinate;
  begin
    result:=DoCalc(AValue,Page.Width);
  end;

  function CalcVert(const AValue:TCoordinate):TCoordinate;
  begin
    result:=DoCalc(AValue,Page.Height);
  end;

var tmpCalc : TCoordinate;
begin
  with IBounds do
  begin
    if Right <> 0 then
    begin
      tmpCalc := CalcHoriz(Right);

      if Right < tmpCalc then
         Right := tmpCalc;

      if Right < 0 then
         Right := 0;
    end;

    if Bottom <> 0 then
    begin
      tmpCalc := CalcVert(Bottom);

      if Bottom < tmpCalc then
         Bottom := tmpCalc;

      if Bottom < 0 then
         Bottom := 0;
    end;

    if NegativeCoordinates then
    begin
      if Left <> 0 then
      begin
        tmpCalc := CalcHoriz(Left);

        if Left > tmpCalc then
           Left := tmpCalc;
      end;

      if Top <> 0 then
      begin
        tmpCalc := CalcVert(Top);

        if Top > tmpCalc then
           Top := tmpCalc;
      end;
    end;

    if Left > 0 then
       Left := 0;

    if Top > 0 then
       Top := 0;
  end;
end;
{$ENDIF}

// draw helper grid
Procedure TCustomTree.DrawGrid;
var tmpH : Integer;
    tmpV : Integer;
    tmpX,
    tmpY : TCoordinate;
    tmpR : TRect;
begin
  tmpR:=PrepareGrid(tmpH,tmpV);  // CLR restriction

  With tmpR do
  begin
    tmpX:=Left;
    tmpY:=Top;

    if FGrid.Pen.Visible then
    begin
      // Minor Grid

      Canvas.AssignVisiblePen(FGrid.Pen);

      While Left<Right do
      begin
        Left:=Left+tmpH;
        Canvas.VertLine3D(Left,tmpY,Bottom,TeeTreeZ);
      end;

      Left:=tmpX;

      While Top<Bottom do
      begin
        Canvas.HorizLine3D(Left,Right,Top,TeeTreeZ);
        Top:=Top+tmpV;
      end;
    end
    else
    begin
      // Just draw dots
      with Canvas.Pen do
      begin
        Style:=psSolid;
        Width:=1;
        Color:=FGrid.Color;
      end;

      While Left<Right do
      begin
        Top:=tmpY;

        While Top<Bottom do
        begin
          with Canvas.Calculate3DPosition(Left,Top,TeeTreeZ) do
               Canvas.DoHorizLine(X,X+1,Y);

          Top:=Top+tmpV;
        end;

        Left:=Left+tmpH;
      end;
    end;

    if FGrid.BigPen.Visible then
    begin
      // Major Grid

      Canvas.AssignVisiblePen(FGrid.BigPen);

      Left:=tmpX+tmpH;

      While Left<Right do
      begin
        Top:=tmpY+tmpV;

        While Top<Bottom do
        begin
          if ({$IFDEF FMX}System.Round{$ENDIF}(Top) mod (FGrid.BigStep*tmpV))=0 then
             Canvas.HorizLine3D(tmpX,Right,Top,TeeTreeZ);

          Top:=Top+tmpV;
        end;

        Left:=Left+tmpH;

        if ({$IFDEF FMX}System.Round{$ENDIF}(Left) mod (FGrid.BigStep*tmpH))=0 then
           Canvas.VertLine3D(Left,tmpY,Bottom,TeeTreeZ);
      end;
    end;
  end;
end;

// main Tree drawing procedure
Procedure TCustomTree.DoDraw;

  procedure CheckScrollBars;
  begin
    with VertScrollBar do
    if (not Automatic) and Visible then
       SetPosition(-View3DOptions.VertOffset);

    with HorzScrollBar do
    if (not Automatic) and Visible then
       SetPosition(-View3DOptions.HorizOffset);

    AutomaticScrollBars;
  end;

var t          : Integer;
    WasClipped : Boolean;
begin
  { initiate clipping }
  WasClipped:=(not EqualRect(ChartBounds,inherited GetRectangle{TeeRect(0,0,Width,Height)})) and CanClip;

  if WasClipped then
     Canvas.ClipRectangle(ChartBounds);

  { convert from screen coordinates to "virtual" 2D }
  IBounds2D:=Rectangle2DPosition(ChartBounds);

  { call OnBeforeDraw event }
  if Assigned(OnBeforeDraw) then
     OnBeforeDraw(Self);

  if FGrid.Visible then
     DrawGrid;

  { initialize rectangle }
  IBounds:=TeeRect(MaxInt,MaxInt,0,0);

  { First of all, traverse all tree nodes to calculate all
    their sizes and automatic XY positions... }
  for t:=0 to Roots.Count-1 do
      Roots[t].ReCalcPositions(t);

  { ...then draw all shapes and connections... }
  for t:=0 to Roots.Count-1 do
      Roots[t].DoDraw;

  // reset Global optimization
  GlobalFormat.Connection.ArrowFrom.IOwner:=nil;
  GlobalFormat.Connection.ArrowTo.IOwner:=nil;

  // draw handles if any connection is selected...
  if Assigned(Connections.Selected) and
     (not Printing) and Designing then
          Connections.Selected.InternalDrawHandles;

  // Calculate number of pages
  Page.FCount:=Page.InternalGetCount;

  { Draw Page border }
  if Page.Border.Visible then
     if Designing or Page.Border.Print then
        Page.DrawBorder;

  { Draw zoom rectangle when zooming or selecting }
  if Zoom.Active then DrawZoomRectangle; 

  if Connections.FMagneticHandle<>rcNone then
     Connections.DrawMagnetic;

  { reset Canvas to defaults }
  Canvas.ResetState;

  {$IFDEF PAGEBOUNDS}
  { Calculate bounds in function of pages }
  CalculatePageBounds;
  {$ENDIF}

  { check scroll bars }
  if not Printing then
     CheckScrollBars;

  BroadcastTeeEvent(TTreeAfterDrawEvent.Create).{$IFDEF AUTOREFCOUNT}DisposeOf{$ELSE}Free{$ENDIF};

  { call OnAfterDraw event }
  if Assigned(OnAfterDraw) then
     OnAfterDraw(Self);

  { remove clipping }
  if WasClipped then
     Canvas.UnClipRectangle;
end;

function TCustomTree.GetChildOwner: TComponent;
begin
  Result:=Owner;
end;

Procedure TCustomTree.SetDefaultCapacity;
begin
  Shapes.Capacity:=TreeListCapacity;
  Connections.Capacity:=TreeListCapacity;
  Roots.Capacity:=TreeListCapacity;
end;

// remove (destroy) all nodes
Procedure TCustomTree.Clear;
var Old : Boolean;
    t   : Integer;
begin
  Old:=AutoRepaint;
  IClearing:=True;
  try
    AutoRepaint:=False;

    for t:=0 to Shapes.Count-1 do
        Shapes[t].{$IFDEF AUTOREFCOUNT}DisposeOf{$ELSE}Free{$ENDIF};

    Shapes.Clear;
    Roots.Clear;
    Selected.Clear;

//    While Roots.Count>0 do Roots[0].Free;

    for t:=0 to Connections.Count-1 do
        Connections[t].{$IFDEF AUTOREFCOUNT}DisposeOf{$ELSE}Free{$ENDIF};

    Connections.Clear;

//    While Connections.Count>0 do Connections[0].Free;

    // Reset scroll.
    View3DOptions.HorizOffset:=0;
    View3DOptions.VertOffset:=0;

    SetDefaultCapacity;
  finally
    IClearing:=False;
    AutoRepaint:=Old;
    Invalidate;
  end;
end;

// re-order all nodes based on the alphabetically order of nodes text
Procedure TCustomTree.Sort(Ascending:Boolean=True; IgnoreCase:Boolean=True);

  Procedure SortTree(ANode:TTreeNodeShape);
  var t : Integer;
  begin
    With ANode do
    begin
      for t:=0 to Children.Count-1 do
          SortTree(Children[t]);

      Children.Sort(Ascending,IgnoreCase);
    end;
  end;

var t : Integer;
begin
  for t:=0 to Roots.Count-1 do SortTree(Roots[t]);
  Roots.Sort(Ascending,IgnoreCase);
  Invalidate;
end;

// move the Shape to the Tree center, optionally with animation
Procedure TCustomTree.CenterInView(const Shape:TTreeNodeShape; Animated:Boolean);
var t     : Integer;
    P     : TPoint;
    tmpX  : Integer;
    tmpY  : Integer;
    IZoom : Double;
begin
  if not Designing then
  With Shape do
  begin
    P:=Canvas.Calculate3DPosition(XCenter,YCenter,TeeTreeZ);
    tmpX:=ChartXCenter;
    if tmpX=0 then tmpX:={$IFDEF FMX}Round(Width*0.5){$ELSE}ClientWidth div 2{$ENDIF};

    P.X:=P.X-tmpX;
    P.Y:=P.Y-{$IFDEF FMX}Height*0.5{$ELSE}(ClientHeight div 2){$ENDIF};

    if Animated and (Zoom.AnimatedSteps>0) then
    With View3DOptions do
    begin
      IZoom:=1.0/Self.Zoom.AnimatedSteps;
      tmpX:=Round(IZoom*P.X);
      tmpY:=Round(IZoom*P.Y);

      if (tmpX<>0) and (tmpY<>0) then
      for t:=1 to Self.Zoom.AnimatedSteps do
      begin
        HorizOffset:=HorizOffset-tmpX;
        VertOffset:=VertOffset-tmpY;

        {$IFNDEF FMX}
        Application.ProcessMessages;
        {$ENDIF}
      end;
    end
    else
    With View3DOptions do
    begin
      HorizOffsetFloat:=HorizOffsetFloat-P.X;
      VertOffsetFloat :=VertOffsetFloat-P.Y;
    end;
  end;
end;

Procedure TCustomTree.StopConnecting;
begin
  IEscapedConnecting:=True;
end;

// Draw a temporary connection line between two shapes when
// connecting them using the mouse
Procedure TCustomTree.DrawConnecting(const x,y:TCoordinate; CheckPos:Boolean);
var X2,
    Y2  : TCoordinate;
    tmp : TTreeNodeShape;
begin
  if Assigned(IShape1) then
  begin
    if CheckPos and (not Assigned(IShape2)) then
    begin
      x2:=x;
      y2:=y;

      tmp:=ClickedShape({$IFDEF FMX}Round{$ENDIF}(x2),
                        {$IFDEF FMX}Round{$ENDIF}(y2));

      if Assigned(tmp) then
         IShape1.GetConnectionPos(tmp,IFromConnect.X,IFromConnect.Y);
    end;

    With Canvas do
    begin
      Pen.Color:=clBlack;
      Pen.Style:=psSolid;
      Pen.Width:=1;
      Pen.Mode :=pmNotXor;

      MoveTo3D(IFromConnect.X,IFromConnect.Y,TeeTreeZ);
      LineTo3D(IToConnect.X,IToConnect.Y,TeeTreeZ);

      Pen.Mode:=pmCopy;
    end;
  end;
end;

{$IFDEF FMX}
{$IFDEF D21}
{$DEFINE D21FMX}
{$ENDIF}
{$ENDIF}

procedure TCustomTree.{$IFDEF D21FMX}DoBeginUpdate{$ELSE}BeginUpdate{$ENDIF};
begin
  {$IFDEF FMX}inherited;{$ENDIF}
  AutoRepaint:=False;
end;

procedure TCustomTree.{$IFDEF D21FMX}DoEndUpdate{$ELSE}EndUpdate{$ENDIF};
begin
  if not AutoRepaint then
  begin
    AutoRepaint:=True;
    Invalidate;
  end;

 {$IFDEF FMX}inherited;{$ENDIF}
end;

Procedure TCustomTree.DrawPolygon;
begin
  With Canvas do
  begin
    Pen.Color:=clBlack;
    Pen.Style:=psSolid;
    Pen.Width:=1;
    Pen.Mode :=pmNotXor;
    Brush.Style:=bsClear;
  end;

  IPolygonShape.InternalDraw(Canvas,0,0);

  Canvas.Pen.Mode:=pmCopy;
end;

// initiate a mouse operation to connect shapes drawing a line
Function TCustomTree.StartConnecting:TTreeConnection;
begin
  result:=nil;
  IEscapedConnecting:=False;

  Connecting:=True;
  try
    SetFocus;
    IFromConnect.X:=0;
    IFromConnect.Y:=0;
    IToConnect:=IFromConnect;
    IShape1:=nil;

    While not Assigned(IShape1) do
    begin
      {$IFNDEF FMX}
      Application.ProcessMessages;
      {$ENDIF}

      if IEscapedConnecting then
      begin
        Connecting:=False;
        Exit;
      end;
    end;

    if Assigned(IShape1) then
    begin
      IFromConnect.X:=IShape1.X0;
      IFromConnect.Y:=IShape1.Y0;
      IToConnect:=IFromConnect;
    end;

    IShape2:=nil;

    While not Assigned(IShape2) do
    begin
      {$IFNDEF FMX}
      Application.ProcessMessages;
      {$ENDIF}

      if IEscapedConnecting then
      begin
        Connecting:=False;
        DrawConnecting(IToConnect.x,IToConnect.y,False);
        Exit;
      end;
    end;

    DrawConnecting(IToConnect.X,IToConnect.Y,False);
    result:=IShape1.AddConnection(IShape2);

    // Changed from version 1:
    // Connections created by mouse do not set Parent
    (*
    // warning: to-do: check circular connections here...
    if not Assigned(IShape2.Parent) then
       if IShape1.Parent<>IShape2 then IShape2.Parent:=IShape1;
    *)

  finally
    Connecting:=False;
  end;
end;

// Scroll when zooming, to position the center at the
// new center.
Procedure TCustomTree.ZoomFromCenter(NewZoom:Integer; X,Y:Integer);
var xc : Integer;
    yc : Integer;
    IZoomFactor : Double;
begin
  xc:=x;
  yc:=y;

  Canvas.Calculate2DPosition(x,y,TeeTreeZ);

  With View3DOptions do
  begin
    IZoomFactor:=0.01*NewZoom;

    HorizOffset:=Round(IZoomFactor*(xc-x));
    VertOffset :=Round(IZoomFactor*(yc-y));
  end;
end;

procedure TCustomTree.SetAllowDelete(const Value: Boolean);
begin
  FAllowDelete:=Value;
end;

procedure TCustomTree.SetAllowResize(const Value: Boolean);
begin
  if FAllowResize<>Value then
  begin
    FAllowResize:=Value;

    if Designing then
       Invalidate;
  end;
end;

procedure TCustomTree.SetReadOnly(const Value: Boolean);
begin
  FReadOnly:=Value;
end;

procedure TCustomTree.SetShowRootCross(const Value: Boolean);
var t : Integer;
begin
  FShowRootCross:=Value;

  for t:=0 to Roots.Count-1 do
      if FShowRootCross then
         Roots[t].ShowCross:=scAlways
      else
         Roots[t].ShowCross:=scNever;
end;

procedure TCustomTree.DrawDiamond(const R: TRect);
var tmpX,
    tmpY : TCoordinate;
begin
  With R do
  begin
    tmpX:=(Left+Right) {$IFDEF FMX}*0.5{$ELSE}div 2{$ENDIF};
    tmpY:=(Top+Bottom) {$IFDEF FMX}*0.5{$ELSE}div 2{$ENDIF};

    Canvas.PlaneWithZ( TeePoint(Left,tmpY),
                       TeePoint(tmpX,Top),
                       TeePoint(Right,tmpY),
                       TeePoint(tmpX,Bottom),TeeTreeZ);
  end;
end;

// Draws a "handle" (small rectangle) at point XY
procedure TCustomTree.DrawHandle(const Node:TCustomTreeElement; const Handle:TTreeShapeHandle;
                                 x, y: TCoordinate);
var tmp   : Integer;
    tmpX,
    tmpY  : Integer;
    tmpOk : Boolean;
begin
  tmpOk:=True;

  if Node is TTreeNodeShape then
  begin
    tmpX:={$IFDEF FMX}Round{$ENDIF}(x);
    tmpY:={$IFDEF FMX}Round{$ENDIF}(y);

    TTreeNodeShape(Node).DoDrawHandle(Handle,tmpX,tmpY,tmpOk);

    x:=tmpX;
    y:=tmpY;
  end;

  if tmpOk then
  begin
    tmp:=Selected.HandleSize;

    with Canvas,Calculate3DPosition(x,y,TeeTreeZ) do
         Rectangle(X-tmp,Y-tmp,X+tmp,Y+tmp);
  end;
end;

procedure TCustomTree.SetHotTrack(const Value: TTreeHotTrack);
begin
  FHotTrack.Assign(Value);
end;

procedure TCustomTree.InternalWheel(IsDown:Boolean);
var tmp : Double;
    tmpFactor : Integer;
begin
  if IsDown then
     tmpFactor:=+1
  else
     tmpFactor:=-1;

  case FWheelNavigation of
    wnSelection     : if IsDown then
                         ProcessKey(TeeTree_DownKey,[]) // navigate one node down
                      else
                         ProcessKey(TeeTree_UpKey,[]);  // navigate one node up

    wnScrollVert    : with View3DOptions do
                           VertOffset:=VertOffset+tmpFactor*TreePageScrollQuantity;

    wnScrollHoriz   : with View3DOptions do
                           HorizOffset:=HorizOffset+tmpFactor*2;

    wnZoom          : with View3DOptions do
                      begin
                        tmp:=Math.Max(1,0.05*ZoomFloat);
                        ZoomFloat:=Max(1,ZoomFloat-tmpFactor*tmp);
                      end;
  end;
end;

{$IFDEF FMX}
procedure TCustomTree.MouseWheel(Shift: TShiftState; WheelDelta: Integer; var Handled: Boolean);
begin
  inherited;
  InternalWheel(WheelDelta<0);
end;

{$IFDEF D17}
procedure TCustomTree.DoGesture(const EventInfo: TGestureEventInfo; var Handled: Boolean);

  procedure CheckScrollBar(AScroll:TScrollBar; ADirection:TPanDirection; const ADelta:Single);
  var OldValue : Single;
  begin
    if ((IPanDirection = TPanDirection.pdArbitrary) or (IPanDirection = ADirection))
      and Assigned(AScroll) and AScroll.Visible then
    begin
      OldValue := AScroll.Value;
      AScroll.Value := AScroll.Value - ADelta;
      Handled := not SameValue(OldValue,AScroll.Value, Epsilon);
    end;
  end;

var
  DX, DY : Single;
begin
  Handled := False;

  if EventInfo.GestureID = igiPan then
  begin
    if TInteractiveGestureFlag.gfBegin in EventInfo.Flags then
    begin
      //AniCalculations.MouseDown(EventInfo.Location.X, EventInfo.Location.Y);
      IPanPoint := EventInfo.Location;
      IPanDirection := TPanDirection.pdUndecided;
      Handled:=True;
    end
    else
    begin
      if IPanDirection = pdUndecided then
      begin
        DX := Abs(EventInfo.Location.X - IPanPoint.X);
        DY := Abs(EventInfo.Location.Y - IPanPoint.Y);

        if Abs(RadToDeg(DegToRad(45) - ArcTan2(DY, DX))) < 22 then
          IPanDirection := TPanDirection.pdArbitrary
        else if DX > DY then
          IPanDirection := TPanDirection.pdHorizontal
        else
          IPanDirection := TPanDirection.pdVertical;
      end;

      CheckScrollBar(HorzScrollBar.IScroll,TPanDirection.pdHorizontal,
                     EventInfo.Location.X - IPanPoint.X);

      CheckScrollBar(VertScrollBar.IScroll,TPanDirection.pdVertical,
                     EventInfo.Location.Y - IPanPoint.Y);

      if Handled then
      begin
        IPanPoint := EventInfo.Location;
        //AniCalculations.MouseMove(EventInfo.Location.X, EventInfo.Location.Y);
      end;

      {
      if (TInteractiveGestureFlag.gfEnd in EventInfo.Flags) then
        AniCalculations.MouseUp(EventInfo.Location.X, EventInfo.Location.Y);
      }
    end;
  end;
end;
{$ENDIF}

{$ELSE}
function TCustomTree.DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean;
begin
  result:=inherited DoMouseWheelDown(Shift,MousePos);

  if not result then
  begin
    InternalWheel(True);
    result:=True;
  end;
end;

function TCustomTree.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean;
begin
  result:=inherited DoMouseWheelUp(Shift,MousePos);

  if not result  then
  begin
    InternalWheel(False);
    result:=True;
  end;
end;
{$ENDIF}

// Returns True when AShape can be a child node of AParent
Function TCustomTree.CanBeParentOf(const AParent,AShape:TTreeNodeShape):Boolean;
var tmp : TTreeNodeShape;
begin
  result:=False;

  tmp:=AParent;

  if Assigned(tmp) and Assigned(AShape) and
     (tmp<>AShape) and (tmp<>AShape.Parent) then
  begin
    While Assigned(tmp.Parent) do
    if tmp.Parent=AShape then
       Exit
    else
       tmp:=tmp.Parent;

    result:=True;
  end;
end;

// called while moving the mouse in a drag-drop operation
{$IFDEF FMX}
procedure TCustomTree.DragOver(const Data: TDragObject; const Point: TPointF;
     var {$IFDEF D20}Operation: TDragOperation{$ELSE}Accept: Boolean{$ENDIF});
{$ELSE}
procedure TCustomTree.DragOver(Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
{$ENDIF}

var tmp     : TTreeNodeShape;
    tmpTree : TCustomTree;

    {$IFDEF FMX}
    {$IFDEF D20}
    Accept : Boolean;
    {$ENDIF}
    {$ENDIF}
begin
  inherited;

  {$IFDEF FMX}
  {$IFDEF D20}
  Accept:=Operation=TDragOperation.Move;
  {$ENDIF}
  {$ENDIF}

  // todo: check if Vert. scrollbar is visible...

  {$IFNDEF FMX}
  if y<15 then //On the upper edge - should scroll up
     SendMessage(Handle,WM_VSCROLL,SB_LINEUP,0)
  else
  if Height-y<15 then // On the lower edge - should scroll down
     SendMessage(Handle,WM_VSCROLL,SB_LINEDOWN,0);
  {$ENDIF}

  if ((not Assigned(OnDragOver)) or (not Accept)) then
  begin

    if ({$IFDEF FMX}Data.{$ENDIF}Source<>Self) and ({$IFDEF FMX}Data.{$ENDIF}Source is TCustomTree) and
       (
         (not TCustomTree({$IFDEF FMX}Data.{$ENDIF}Source).DragAndDrop.ToOtherTree) or
         (not Self.DragAndDrop.FromOtherTree)
       )
          then
    begin
      Accept:=False;

      {$IFDEF FMX}
      {$IFDEF D20}
      if Accept then
         Operation:=TDragOperation.Move;
      {$ENDIF}
      {$ENDIF}

      Exit;
    end;

    {$IFDEF FMX}
    with Point.Round do
    {$ENDIF}
       tmp:=ClickedShape(x,y);

    Accept:={$IFDEF FMX}True{$ELSE}State=dsDragEnter{$ENDIF};

    if not Accept then
    begin
      if {$IFDEF FMX}Data.{$ENDIF}Source is TCustomTree then
         tmpTree:=TCustomTree({$IFDEF FMX}Data.{$ENDIF}Source)
      else
         tmpTree:=Self;

      if Assigned(tmpTree.FDragged) then
      begin
        if tmpTree.DragAndDrop.DragToRoot and
           (not Assigned(tmp)) then
        begin
          if Assigned(tmpTree.FDragged.Parent) then
             Accept:=True;
        end
        else
          Accept:=CanBeParentOf(tmp,tmpTree.FDragged);
      end
{      else
      begin
        if Source is TCustomTree then tmpTree:=TCustomTree(Source)
                                 else tmpTree:=Self;
        Accept:=tmpTree.DragAndDrop.DragToRoot;
      end};
    end;
  end;

  {$IFDEF FMX}
  {$IFDEF D20}
  if Accept then
     Operation:=TDragOperation.Move;
  {$ENDIF}
  {$ENDIF}
end;

{$IFNDEF FMX}
procedure TCustomTree.DragCanceled;
begin
  FDragged:=nil;
end;
{$ENDIF}

Procedure TCustomTree.FinishDrag(const Target:TTreeNodeShape);
var tmpC  : TTreeConnection;
    tmpOk : Boolean;
begin
  tmpOk:=False;

  if Assigned(Target) then
  begin
    if CanBeParentOf(Target,FDragged) then
    begin
      if Assigned(Dragged.Parent) then
      begin
        { if a connection exists, switch it to the new node }
        if Assigned(Dragged.Parent.FConnections) then
        begin
          tmpC:=Dragged.Parent.Connections.ToShape(Dragged);

          if Assigned(tmpC) then
          begin
            tmpC.Tree:=Self;
            tmpC.FromShape:=Target;
          end;
        end;
      end
      else Target.AddConnection(Dragged);

      Dragged.Parent:=Target;
      Dragged.Visible:=Target.Visible;

      if Target.Visible then
         Target.Expanded:=True;

      tmpOk:=True;
    end;
  end
  else
  if DragAndDrop.DragToRoot then
  begin
    Dragged.Parent:=nil;
    Dragged.Visible:=True;
    tmpOk:=True;
  end;

  if tmpOk then
  begin
    Dragged.Repaint;

    // Call event
    if Assigned(FOnDragDropShape) then
       FOnDragDropShape(Self,Dragged,Target);
  end;

  FDragged:=nil;
end;

// called when the mouse button is depressed on a drag-drop operation.
// if allowed, the dragged node is set to be a child of the drop node.
{$IFDEF FMX}
procedure TCustomTree.DragEnd;
var X,Y:Integer;
{$ELSE}
procedure TCustomTree.DoEndDrag(Target: TObject; X, Y: Integer);
{$ENDIF}
var tmpTarget : TCustomTree;
    tmp       : TTreeNodeShape;
begin
  if Assigned(FDragged) then
  begin
    {$IFNDEF FMX}
    if (Target<>Self) and (Target is TCustomTree) then
    begin
      tmpTarget:=TCustomTree(Target);
      tmp:=tmpTarget.ClickedShape(x,y);

      tmpTarget.FDragged:=Dragged;
      FDragged:=nil;

      if not DragAndDrop.RemoveNodes then
      begin
        tmpTarget.FDragged:=CloneShape(tmpTarget.FDragged);
      end;

      tmpTarget.FDragged.ChangeTreeRecursive(tmpTarget);

      Invalidate;
    end
    else
    {$ENDIF}
    begin
      {$IFDEF FMX}
      X:=0;
      Y:=0;
      {$ENDIF}

      tmpTarget:=Self;
      tmp:=tmpTarget.ClickedShape(x,y);
    end;

    tmpTarget.FinishDrag(tmp);
  end;

  inherited;
end;

{ Tree Shape Palette }

type
  TTreeCustomShapePalette=record
    Group      : String;
    Name       : String;
    ShapeClass : TTreeNodeShapeClass;
  end;

  PTreeCustomShapePalette=^TTreeCustomShapePalette;

// returns a record for a given AClass custom shape parameter
Function GetCustomShape(AClass:TTreeNodeShapeClass; Var P:PTreeCustomShapePalette):Integer;
var t : Integer;
begin
  result:=-1;

  for t:=0 to TreeCustomShapes.Count-1 do // for each...
  if PTreeCustomShapePalette(TreeCustomShapes[t])^.ShapeClass=AClass then
  begin
    P:=PTreeCustomShapePalette(TreeCustomShapes[t]); // return

    result:=t;
    Exit;
  end;
end;

// removes a custom shape class from global list
Procedure UnRegisterCustomTreeShapes(const AClass:Array of TTreeNodeShapeClass);
Var P   : PTreeCustomShapePalette;
    t   : Integer;
    tmp : Integer;
begin
  TeeActivateGroup;

  for t:=Low(AClass) to High(AClass) do // for each class...
  begin
    tmp:=GetCustomShape(AClass[t],P);

    if tmp<>-1 then // if found...
    begin
      Dispose(P);
      TreeCustomShapes.Delete(tmp); // destroy and remove

      UnRegisterClass(AClass[t]);
    end;
  end;
end;

// adds a new custom shape class to global list
Procedure RegisterCustomTreeShape( Const AGroup:String;
                                   Const AName:String;
                                   const AClass:TTreeNodeShapeClass);
Var P : PTreeCustomShapePalette;
begin
  if GetCustomShape(AClass,P)=-1 then  // if not exists ...
  begin
    New(P);

    With P^ do
    begin
      Group:=AGroup;
      Name:=AName;
      ShapeClass:=AClass;

      TeeActivateGroup;
      RegisterClass(ShapeClass);
    end;

    TreeCustomShapes.Add(P);  // add
  end;
end;

// iterate over all custom shapes in list and call procedure
Procedure TreeForEachCustomShape(const ForEachProc:TTreeForEachCustomShapeProc);
var t : Integer;
begin
  for t:=0 to TreeCustomShapes.Count-1 do
  With PTreeCustomShapePalette(TreeCustomShapes[t])^ do
       ForEachProc(Group,Name,ShapeClass);
end;

// Destroy all "custom" shapes from global list
Procedure TreeRemoveCustomShapes;
var t : Integer;
begin
  for t:=0 to TreeCustomShapes.Count-1 do
      Dispose(PTreeCustomShapePalette(TreeCustomShapes[t]));

  TreeCustomShapes.Free;
end;

{ TTreeCustomNodeShape }

Constructor TCustomTreeShape.Create(AOwner: TComponent);
begin
  inherited;

  FImageIndex:=tiNone;
  FImageListIndex:=-1;
  FStyle:=tssCustom;
  IImageWidth:=0;
  IImageHeight:=0;
end;

function TCustomTree.GetGridColor: TColor;
begin
  result:=FGrid.Color;
end;

function TCustomTree.GetGridStep: Integer;
begin
  result:=FGrid.Step;
end;

procedure TCustomTree.SetGrid(const Value: TTreeGrid);
begin
  FGrid.Assign(Value);
end;

// Compatibility with v1.0 saved forms and tree files
procedure TCustomTree.ReadGridColor(Reader: TReader);
begin
  FGrid.Color:={$IFDEF FMX}clGray{$ELSE}StringToColor(Reader.ReadIdent){$ENDIF};
end;

procedure TCustomTree.ReadGridStep(Reader: TReader);
begin
  FGrid.Step:=Reader.ReadInteger;
end;

procedure TCustomTree.DefineProperties(Filer: TFiler);
begin
  inherited;

  Filer.DefineProperty('GridColor',ReadGridColor,nil,False);
  Filer.DefineProperty('GridStep',ReadGridStep,nil,False);
end;

// Return rectangle corresponding to current page:
function TCustomTree.GetRectangle: TRect;
var nRow,
    nCol,
    PagesPerRow: Integer;
begin
  with Page do
  begin
    result:=TeeRect(0,0,Width,Height);

    if Page>1 then
    begin
      PagesPerRow := 1 + {$IFDEF FMX}Round{$ENDIF}(Self.IBounds.Right {$IFDEF FMX}/{$ELSE}div{$ENDIF} Width);

      nRow := Pred(Page) div PagesPerRow;
      nCol := Pred(Page) - nRow* PagesPerRow;

      result.Top := nRow * Height;
      result.Left := nCol * Width;
      result.Bottom := result.Top + Height;
      result.Right := result.Left + Width;
    end;
  end;
end;

procedure TCustomTree.SetPage(const Value: TTreePage);
begin
  FPage.Assign(Value);
end;

procedure TCustomTree.SetDragDrop(const Value: TTreeDragDrop);
begin
  FDragDrop.Assign(Value);
end;

function TCustomTree.GetMemo: TMemo;
begin
  result:=TextEditor.Memo;
end;

procedure TCustomTree.SetTextEditor(const Value: TTreeTextEditor);
begin
  FTextEditor.Assign(Value);
end;

procedure TCustomTree.DeleteShape(const AShape: TTreeNodeShape);
begin
  AShape.{$IFDEF AUTOREFCOUNT}DisposeOf{$ELSE}Free{$ENDIF};
end;

procedure TCustomTree.SetImages(const Value: TImageList);
begin
  if FImages<>Value then
  begin
    if Assigned(FImages) then
       FImages.RemoveFreeNotification(Self);

    FImages:=Value;

    if Assigned(FImages) then
       FImages.FreeNotification(Self);
  end;
end;

procedure TCustomTree.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;

  if Operation=opRemove then
     if Assigned(FImages) and (AComponent=FImages) then
        Images:=nil;
end;

// Replaces the default "Child Manager" and returns a new created
// instance of the class parameter.
Procedure TCustomTree.ChangeManager(const NewManager:TChildManager);
begin
  GlobalFormat.ChildManager.Free;
  GlobalFormat.ChildManager:=NewManager;
end;

procedure TCustomTree.EndDrawHandles;
begin
  {$IFNDEF FMX}
  SetROP2(Canvas.Handle, R2_COPYPEN);
  {$ENDIF}
end;

procedure TCustomTree.ZoomReset;
begin
  View3DOptions.Zoom:=FZoomDefault.ZoomPercent;
  View3DOptions.HorizOffset:=FZoomDefault.HorizOffset;
  View3DOptions.VertOffset:=FZoomDefault.VertOffset;

  if Assigned(OnUndoZoom) then
     OnUndoZoom(Self);
end;

{ TTreeHotTrack }

Constructor TTreeHotTrack.Create(const ATree: TCustomTree);
begin
  inherited Create;
  ITree:=ATree;

  FBorder:=TTreePen.Create(ITree.CanvasChanged);
  FFont:=TTeeHotTrackFont.Create(ITree.CanvasChanged);
  FFont.Style:=[{$IFDEF FMX}TFontStyle.{$ENDIF}fsUnderline];

  FHotLink:=True;
end;

Destructor TTreeHotTrack.Destroy;
begin
  FBorder.Free;
  FFont.Free;
  inherited;
end;

procedure TTreeHotTrack.Assign(Source: TPersistent);
begin
  if Source is TTreeHotTrack then
  with TTreeHotTrack(Source) do
  begin
    Self.FActive   :=Active;
    Self.Border    :=Border;
    Self.Font      :=Font;
    Self.FHotLink  :=HotLink;
    Self.UseBorder :=UseBorder;
    Self.UseFont   :=UseFont;
  end
  else inherited;
end;

procedure TTreeHotTrack.SetActive(const Value: Boolean);
begin
  ITree.SetBooleanProperty(FActive,Value);
end;

procedure TTreeHotTrack.SetBorder(const Value: TTreePen);
begin
  FBorder.Assign(Value);
end;

procedure TTreeHotTrack.SetFont(const Value: TTeeHotTrackFont);
begin
  FFont.Assign(Value);
end;

{ TTreeShapeList }

Function TTreeShapeList.AddChild(const Node: TTreeNodeShape;
  const Text: String):TTreeNodeShape;
begin
  if Assigned(Node) then
     result:=Node.AddChild(Text)
  else
     result:=ITree.AddRoot(Text);
end;

procedure TTreeShapeList.Assign(Source: TTreeShapeList);
var t : Integer;
begin
  Clear;

  for t:=0 to Source.Count-1 do
      ITree.AddCloneShape(Source[t]);
end;

procedure TTreeShapeList.SelectAll;
var t : Integer;
begin
  for t:=0 to Count-1 do
      Items[t].Selected:=True;
end;

procedure TTreeShapeList.SetVisible(const Value: Boolean);
begin
  ITree.SetBooleanProperty(FVisible,Value);
end;

{ TTreeCustomPolygonShape }
function TTreeCustomPolygonShape.GetPolygonPoints(Sides: Integer;
  const R: TRect; var P: TShapePoints): Integer;
var XRadius : Double;
    YRadius : Double;
    XC      : Double;
    YC      : Double;
    t       : Integer;
    PiStep  : Double;
    tmpAngle: Double;
begin
  result:=Sides;

  With R do
  begin
    XRadius:=(Right-Left)*0.5;
    YRadius:=(Bottom-Top)*0.5;
    Xc:=(Right+Left)*0.5;
    Yc:=(Bottom+Top)*0.5;
  end;

  PiStep:=2*Pi/Sides;

  for t:=0 to Sides-1 do
  begin
    tmpAngle:=FAngleOffset*TeePiStep+(t*PiStep);

    P[t].x:=Round(xc-(XRadius*Cos(tmpAngle)));
    P[t].y:=Round(yc-(YRadius*Sin(tmpAngle)));
  end;
end;

procedure TTreeCustomPolygonShape.SetAngleOffset(const Value: Double);
begin
  // do not call Tree.SetDoubleProperty, just in case it is nil.
  if FAngleOffset<>Value then
  begin
    FAngleOffset:=Value;
    Repaint;
  end;
end;

{ TTreeGrid }

Constructor TTreeGrid.Create(const ATree:TCustomTree);
begin
  inherited Create;

  ITree:=ATree;
  FBigStep:=10;

  FHorizStep:=TeeDefaultGridStep;
  FVertStep:=TeeDefaultGridStep;

  FBigPen:=TGridBigPen.Create(ITree.CanvasChanged);
  FBigPen.Color:=clGray;

  FColor:=clGray;

  FPen:=TGridPen.Create(ITree.CanvasChanged);
  FPen.Color:=clSilver;
end;

Destructor TTreeGrid.Destroy;
begin
  FBigPen.Free;
  FPen.Free;
  inherited;
end;

procedure TTreeGrid.Assign(Source: TPersistent);
begin
  if Source is TTreeGrid then
  with TTreeGrid(Source) do
  begin
    Self.FBigStep   :=FBigStep;
    Self.BigPen     :=FBigPen;
    Self.FColor     :=FColor;
    Self.FHorizStep :=FHorizStep;
    Self.Pen        :=FPen;
    Self.FVertStep  :=FVertStep;
    Self.FVisible   :=FVisible;
  end
  else inherited;
end;

procedure TTreeGrid.SetBigStep(const Value: Integer);
begin
  if Value>0 then ITree.SetIntegerProperty(FBigStep,Value);
end;

procedure TTreeGrid.SetPen(const Value: TGridPen);
begin
  FPen.Assign(Value);
end;

procedure TTreeGrid.SetBigPen(const Value: TGridBigPen);
begin
  FBigPen.Assign(Value);
end;

procedure TTreeGrid.SetHorizStep(const Value: Integer);
begin
  if Value>0 then ITree.SetIntegerProperty(FHorizStep,Value);
end;

procedure TTreeGrid.SetVertStep(const Value: Integer);
begin
  if Value>0 then ITree.SetIntegerProperty(FVertStep,Value);
end;

procedure TTreeGrid.SetColor(const Value: TColor);
begin
  ITree.SetColorProperty(FColor,Value);
end;

procedure TTreeGrid.SetVisible(const Value: Boolean);
begin
  ITree.SetBooleanProperty(FVisible,Value);
end;

procedure TTreeGrid.SetStep(const Value: Integer);
begin
  // change both
  HorizStep:=Value;
  VertStep:=Value;
end;

{ TTreePage }

Constructor TTreePage.Create(const ATree: TCustomTree);
begin
  inherited Create;
  ITree:=ATree;

  FPage:=1;

  FBorder:=TTreePageBorder.Create(ITree.CanvasChanged);
  FBorder.Color:=clDkGray;

  FUsePrinter:=True;

  { defaults for A4 paper }
  FWidth:=771;
  FHeight:=1058;
end;

Destructor TTreePage.Destroy;
begin
  FBorder.Free;
  inherited;
end;

procedure TTreePage.Assign(Source: TPersistent);
begin
  if Source is TTreePage then
  with TTreePage(Source) do
  begin
    Self.Border      :=Border;
    Self.FUsePrinter :=UsePrinter;
    Self.FHeight     :=FHeight;  { warning: use internal variable }
    Self.FWidth      :=FWidth;   { warning: use internal variable }
    Self.Page        :=FPage;
  end
  else
    inherited;
end;

procedure TTreePage.Refresh;
var PagesPerRow,
    nCol,
    nRow : Integer;
begin
  with ITree.View3DOptions do
  begin
    PagesPerRow := 1 + {$IFDEF FMX}Round{$ENDIF}(ITree.IBounds.Right {$IFDEF FMX}/{$ELSE}div{$ENDIF} Width);

    nRow := Pred(FPage) div PagesPerRow;
    nCol := Pred(FPage) - nRow*PagesPerRow;

    VertOffset := -nRow*Height;
    HorizOffset := -nCol*Width;
  end;

  ITree.Invalidate;
end;

procedure TTreePage.DrawBorder;
var R   : TRect;
    tmp : TCoordinate;
begin
  if FBorder.Print or (not ITree.Printing) then
  begin
    R:=ITree.GetRectangle;

    with ITree.Canvas do
    begin
      AssignVisiblePen(Self.FBorder);
      Brush.Style:=bsClear;

      if ITree.Printing then
      begin
        tmp:=Self.FBorder.Width;
        Rectangle(0,0,R.Right-tmp,R.Bottom-tmp);
      end
      else
      with ITree.View3DOptions do
      if (HorizOffset<>0) or (VertOffset<>0) then
         RectangleWithZ(R,TeeTreeZ)
      else
      begin
        VertLine3D(R.Right,0,R.Bottom,TeeTreeZ);
        HorizLine3D(0,R.Right,R.Bottom,TeeTreeZ);
      end;
    end;
  end;
end;

function TTreePage.IsStored: Boolean;
begin
  result:=not UsePrinter;
end;

procedure TTreePage.SetBorder(const Value: TTreePageBorder);
begin
  FBorder.Assign(Value);
end;

procedure TTreePage.SetHeight(const Value: Integer);
begin
  ITree.SetIntegerProperty(FHeight,Value);
  FUsePrinter:=False;
end;

procedure TTreePage.SetUsePrinter(const Value: Boolean);
begin
  ITree.SetBooleanProperty(FUsePrinter,Value);
end;

procedure TTreePage.SetWidth(const Value: Integer);
begin
  ITree.SetIntegerProperty(FWidth,Value);
  FUsePrinter:=False;
end;

function TTreePage.GetHeight: Integer;
begin
  {$IFNDEF TEENOPRINT}
  if UsePrinter then
    try
      {$IFDEF FMX}
      result:=Printer.PageHeight;
      {$ELSE}
      result:=Round(1.0*Screen.PixelsPerInch*Printer.PageHeight/
                   GetDeviceCaps(Printer.Handle,LOGPIXELSY))
      {$ENDIF}
    except
      on EPrinter do
      begin
        FUsePrinter:=False;
        result:=FHeight;
      end;
    end
  else
  {$ENDIF}
     result:=FHeight;
end;

function TTreePage.GetWidth: Integer;
begin
  {$IFNDEF TEENOPRINT}
  if UsePrinter then
    try
      {$IFDEF FMX}
      result:=Printer.PageWidth
      {$ELSE}
      result:=Round(1.0*Screen.PixelsPerInch*Printer.PageWidth/
                   GetDeviceCaps(Printer.Handle,LOGPIXELSX))
      {$ENDIF}
    except
      on EPrinter do
      begin
        FUsePrinter:=False;
        result:=FWidth;
      end;
    end
  else
  {$ENDIF}
     result:=FWidth;
end;

// return number of pages
function TTreePage.GetCount: Integer;
begin
  if FCount=0 then
     FCount:=InternalGetCount;

  result:=FCount;
end;

procedure TTreePage.SetPage(const Value: Integer);
begin
  if (FPage<>Value) and (Value<=Count) and (Value>0) then
  begin
    FPage:=Value;
    Refresh;
  end;
end;

function TTreePage.InternalGetCount: Integer;
begin
  result:=1+{$IFDEF FMX}Round{$ENDIF}(ITree.IBounds.Bottom {$IFDEF FMX}/{$ELSE}div{$ENDIF} Height);

  if Width <> 0 then
     result:=result*(1+{$IFDEF FMX}Round{$ENDIF}(ITree.IBounds.Right {$IFDEF FMX}/{$ELSE}div{$ENDIF} Width));
end;

{ TPolygonShape }

Constructor TPolygonShape.Create(AOwner: TComponent);
begin
  inherited;

  FPoints:=TPointCollection.Create(Self,TPointItem);

  with AutoPosition do
  begin
    FNoLeft:=True;
    FNoTop:=True;
  end;
end;

Destructor TPolygonShape.Destroy;
begin
  FPoints.Free;
  inherited;
end;

function TPolygonShape.Add(X, Y: Integer):TPointItem;
begin
  result:=TPointItem(Points.Add);
  result.FX:=X;
  result.FY:=Y;
  IAutoSized:=False;
end;

function TPolygonShape.Insert(Index,X,Y:Integer):TPointItem;
begin
  result:=Add(X,Y);
  result.Index:=Index;
end;

function TPolygonShape.Area:Double;
begin
  result:=Points.Area;
end;

function TPolygonShape.Centroid:TPointFloat;
begin
  result:=Points.Centroid;
end;

procedure TPolygonShape.ReCalcSize;
var tmp : Integer;
    t   : Integer;
begin { find the maximum bounding rectangle for all points XY }
  tmp:=Points.Count;

  if tmp>0 then
  begin
    FX0:=Points[0].X;
    FX1:=FX0;
    FY0:=Points[0].Y;
    FY1:=FY0;

    for t:=1 to tmp-1 do
    begin
      if Points[t].X<FX0 then FX0:=Points[t].X
      else
      if Points[t].X>FX1 then FX1:=Points[t].X;

      if Points[t].Y<FY0 then FY0:=Points[t].Y
      else
      if Points[t].Y>FY1 then FY1:=Points[t].Y;
    end;
  end
  else
  begin
    FX0:=0;
    FY0:=0;
    FX1:=0;
    FY1:=0;
  end;

  IAutoSized:=True;
end;

procedure TPolygonShape.DrawHandles;
var t : Integer;
begin
  for t:=0 to Points.Count-1 do
      Tree.DrawHandle(Self,rcCustom,Points[t].X,Points[t].Y);
end;

procedure TPolygonShape.FillSample;
begin
  if Points.Count=0 then
  begin
    Points.Clear;
    Add(6,4);
    Add(21,8);
    Add(21,14);
    Add(18,19);
    Add(14,14);
    Add(9,21);
    Add(2,10);
  end;
end;

Function TPolygonShape.ClickedPoint(x,y:Integer):Integer;
var t : Integer;
    tmpSize : Integer;
begin
  tmpSize:=Tree.Selected.HandleSize;

  for t:=0 to Points.Count-1 do
  if (Abs(Points[t].X-X)<=tmpSize) and (Abs(Points[t].Y-Y)<=tmpSize) then
  begin
    result:=t;
    exit;
  end;

  result:=-1;
end;

function TPolygonShape.GetHandleCursor(x, y: Integer): TCursor;
begin
  if GetResizingHandle(x,y)=rcCustom then result:=crSizeAll
                                     else result:=crDefault;
end;

function TPolygonShape.GetResizingHandle(x, y: Integer): TTreeShapeHandle;
begin
  FResizingHandle:=ClickedPoint(x,y);
  if FResizingHandle<>-1 then result:=rcCustom
                         else result:=rcNone;
end;

function TPolygonShape.GetShapePoints(const R: TRect;
  var P: TShapePoints): Integer;
var t : Integer;
begin
  result:=Min(MaxShapePoints,Points.Count);

  for t:=0 to result-1 do
  with Points[t] do
  begin
    P[t].X:=X;
    P[t].Y:=Y;
  end;
end;

procedure TPolygonShape.Resize(ACorner: TTreeShapeHandle; DeltaX,
  DeltaY: Integer);
begin
  if (ACorner=rcCustom) and (FResizingHandle<>-1) then
    if (DeltaY<>0) or (DeltaX<>0) then
    begin
      with Points[FResizingHandle] do
      begin
        FX:=FX+DeltaX;
        FY:=FY+DeltaY;
      end;

      IAutoSized:=False;
      Repaint;
    end;
end;

procedure TPolygonShape.SetPoints(const Value: TPointCollection);
begin
  FPoints.Assign(Value);
  IAutoSized:=False;
end;

procedure TPolygonShape.MoveRelative(OfsX, OfsY: Integer;
  MoveChilds: Boolean);
var t : Integer;
begin
  inherited;

  with Points do
  for t:=0 to Count-1 do
  with Point[t] do
  begin
    Inc(FX,OfsX);
    Inc(FY,OfsY);
  end;

  IAutoSized:=False;
end;

Procedure TPolygonShape.InternalDraw(const ACanvas:TCanvas3D; const OffsetX,OffsetY:TCoordinate);
var tmp : Integer;
    P   : TShapePoints;
    t   : Integer;
begin
  tmp:=GetShapePoints(TeeRect(0,0,0,0),P);

  if tmp>0 then
  begin
    for t:=0 to tmp-1 do
    begin
      {$IFDEF FMX}
      P[t].X:=P[t].X+OffsetX;
      P[t].Y:=P[t].Y+OffsetY;
      {$ELSE}
      Inc(P[t].X,OffsetX);
      Inc(P[t].Y,OffsetY);
      {$ENDIF}
    end;

    if IsPolyLine then
    begin
      ACanvas.MoveTo3D(P[0].X,P[0].Y,TeeTreeZ);

      for t:=1 to tmp-1 do
          ACanvas.LineTo3D(P[t].X,P[t].Y,TeeTreeZ);
    end
    else
      if tmp>2 then
         ACanvas.PolygonWithZ(Slice(P,tmp),TeeTreeZ)
      else
         ACanvas.LineWithZ(P[0].X,P[0].Y,P[1].X,P[1].Y,TeeTreeZ);
  end;
end;

procedure TPolygonShape.Loaded;
begin
  inherited;

  IAutoSized:=False;
  FAutoSize:=False;

  with AutoPosition do
  begin
    FNoLeft:=True;
    FNoTop:=True;
  end;
end;

procedure TPolygonShape.Assign(Source: TPersistent);
begin
  if Source is TPolygonShape then
  with TPolygonShape(Source) do
  begin
    Self.Points:=Points;
  end;

  inherited;
end;

{ TPointCollection }

function TPointCollection.Add: TPointItem;
begin
  result:=TPointItem(inherited Add);
end;

function TPointCollection.GetPoint(Index:Integer): TPointItem;
begin
  result:=TPointItem(inherited Items[Index]);
end;

procedure TPointCollection.SetPoint(Index:Integer; const Value: TPointItem);
begin
  inherited Items[Index]:=Value;
end;

procedure TPointCollection.Notify(Item: TCollectionItem; Action: TCollectionNotification);
begin
  if Owner is TPolygonShape then
     TPolygonShape(Owner).Repaint;
end;

function TPointCollection.Area:Double;
var N,
    t,
    tt : Integer;
begin
  result:=0;

  N:=Count;

  for t:=0 to N-1 do
  begin
    tt:= (t + 1) mod N;
    result:=result + (Point[t].x * Point[tt].y) - (Point[t].y * Point[tt].x);
  end;

  result:=Abs(result*0.5);
end;

function TPointCollection.Centroid:TPointFloat;
var tmp    : Double;
    Factor : Double;
    N,i,j  : Integer;
begin
  N:=Count;

  if N>2 then
  begin
    result.x:=0;
    result.y:=0;

    for i:=0 to N-1 do
    begin
      j:= (i + 1) mod N;
      Factor:= ( Point[i].x*Point[j].y-Point[j].x*Point[i].y);
      result.x:=result.x+ ( Point[i].x+Point[j].x)*Factor;
      result.y:=result.y+ ( Point[i].y+Point[j].y)*Factor;
    end;

    tmp:=Area*6;
    if tmp=0 then tmp:=6;

    Factor:=1.0/tmp;
    result.x:=-result.x*Factor;
    result.y:=-result.y*Factor;
  end
  else
  if N>1 then
  begin
    result.x:=(Point[1].x+Point[0].x)*0.5;
    result.y:=(Point[1].y+Point[0].y)*0.5;
  end
  else
  if N>0 then
  begin
    result.x:=Point[0].x;
    result.y:=Point[0].y;
  end;
end;

{ TPointItem }

procedure TPointItem.Assign(Source: TPersistent);
begin
  if Source is TPointItem then
  With TPointItem(Source) do
  begin
    Self.FX :=FX;
    Self.FY :=FY;
  end
  else inherited;
end;

procedure TPointItem.SetX(const Value: Integer);
begin
  if FX<>Value then
  begin
    FX:=Value;
    Shape.IAutoSized:=False;
    Shape.Repaint;
  end;
end;

procedure TPointItem.SetY(const Value: Integer);
begin
  if FY<>Value then
  begin
    FY:=Value;
    Shape.IAutoSized:=False;
    Shape.Repaint;
  end;
end;

type
  TOwnedCollectionAccess=class(TOwnedCollection);

function TPointItem.Shape: TPolygonShape;
begin
  result:=TPolygonShape(TOwnedCollectionAccess(Collection).GetOwner);
end;

{ TImageShape }
Constructor TImageShape.Create(AOwner: TComponent);
begin
  inherited;
  Border.Visible:=False;
  FImageIndex:=tiMyPc;
  Transparent:=True;
  FImageAlignment:=iaCenter;
end;

Const NullCursor=0;

procedure TImageShape.RecalcSize(const ACanvas: TCanvas3D);
var tmp : TPicture;
begin
  inherited;

  tmp:=GetPicture;

  if Assigned(tmp) then
  begin
    Width:=tmp.Width;
    Height:=tmp.Height;

    IAutoSized:=True;
  end;
end;

{ TImageLevels }

Destructor TImageLevels.Destroy;
begin
  ClearPictures;
  inherited;
end;

Procedure TImageLevels.ClearPictures;
var t : Integer;
begin
  for t:=0 to 100 do
      FreeAndNil(IPictures[t]);
end;

procedure TImageLevels.Change;
begin
  inherited;
  ClearPictures;
end;

function TImageLevels.NewPicture(const Level: Integer): TPicture;
begin
  result:=TPicture.Create;
  result.Graphic:=TBitmap.Create{$IFNDEF D19}{$IFDEF FMX}(0,0){$ENDIF}{$ENDIF};
  GetBitmap(Level,result.Bitmap);
end;

function TImageLevels.GetPicture(Level: Integer): TPicture;
begin
  if Count>Level then
  begin
    if not Assigned(IPictures[Level]) then
       IPictures[Level]:=NewPicture(Level);

    result:=IPictures[Level];
  end
  else
    result:=nil;
end;

procedure TImageLevels.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;

  if Operation=opRemove then
     if Assigned(FTree) and (AComponent=FTree) then
        Tree:=nil;
end;

procedure TImageLevels.SetTree(const Value: TCustomTree);
begin
  if FTree<>Value then
  begin
    if Assigned(FTree) then
    begin
      FTree.IImageLevels:=nil;
      FTree.RemoveFreeNotification(Self);
    end;

    FTree:=Value;

    if Assigned(FTree) then
    begin
      FTree.IImageLevels:=Self;
      FTree.FreeNotification(Self);
    end;
  end;
end;

{ TTreeDragDrop }

Constructor TTreeDragDrop.Create;
begin
  inherited;
  AutoScroll:=True;
  FDragToRoot:=True;
  FDragRoots:=True;
  FFromOtherTree:=True;
  FRemove:=True;
  FToOtherTree:=True;
end;

procedure TTreeDragDrop.Assign(Source: TPersistent);
begin
  if Source is TTreeDragDrop then
  with TTreeDragDrop(Source) do
  begin
    Self.FAutomatic  :=FAutomatic;
    Self.AutoScroll  :=AutoScroll;
    Self.FDragToRoot :=FDragToRoot;
    Self.FDragRoots  :=FDragRoots;
    Self.FFromOtherTree:=FFromOtherTree;
    Self.FRemove     :=FRemove;
    Self.FToOtherTree:=FToOtherTree;
  end
  else inherited;
end;

{ TTreeTextEditor }

Constructor TTreeTextEditor.Create;
begin
  inherited;

  FEnabled:=True;
  FMouse:={$IFDEF FMX}TMouseButton.{$ENDIF}mbLeft;
  FMode:=tteKey;
  FUseNodeSize:=True;
  FShortCut:=TeeTree_EditKey;
end;

Destructor TTreeTextEditor.Destroy;
begin
  FMemo.Free;
  inherited;
end;

procedure TTreeTextEditor.Assign(Source: TPersistent);
begin
  if Source is TTreeTextEditor then
  with TTreeTextEditor(Source) do
  begin
    Self.FEnabled       := FEnabled;
    Self.FMouse         := FMouse;
    Self.FMode          := FMode;
    Self.FShortCut      := FShortCut;
    Self.FUseNodeSize   := FUseNodeSize;
    Self.FUseNodeFormat := FUseNodeFormat;
    Self.FUseNodeFont   := FUseNodeFont;
  end
  else inherited;
end;

function TTreeNodeShape.Insert(Index: Integer;
  const AText: String): TTreeNodeShape;
var t : Integer;
begin
  result:=AddChild(AText);

  for t:=Count-1 downto Index+1 do
      Children.List[t]:=Children.List[t-1];

  Children.List[Index]:=result;
end;

function TTreeNodeShape.GetChildNodes: TTreeChildrenList;
begin
  if not Assigned(FChildren) then
  begin
    FChildren:=TTreeChildrenList.Create;
    FChildren.Capacity:=TreeShapeListCapacity;
  end;

  result:=FChildren;
end;

function TTreeNodeShape.GetConnections: TNodeConnectionList;
begin
  if not Assigned(FConnections) then
  begin
    FConnections:=TNodeConnectionList.Create;
    FConnections.Capacity:=TreeShapeListCapacity;
    FConnections.FVisible:=True; // <-- optimization, to avoid overriden Constructor
  end;

  result:=FConnections;
end;

function TTreeNodeShape.GetParents: TNodeShapeList;
begin
  if not Assigned(FParents) then
  begin
    FParents:=TNodeShapeList.Create;
    FParents.ITree:=Tree;
    FParents.Capacity:=TreeShapeListCapacity;

    if Assigned(IParents0) then
    begin
      FParents.Add(IParents0);
      IParents0:=nil;
    end;
  end;

  result:=FParents;
end;

{ TCustomTreeLink }

procedure TCustomTreeLink.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;

  if Operation=opRemove then
     if Assigned(FTree) and (AComponent=FTree) then
        Tree:=nil;
end;

procedure TCustomTreeLink.SetTree(const Value: TCustomTree);
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

{ TPolyLineShape }

function TPolyLineShape.Clicked(const x,y:TCoordinate): Boolean;
var t : Integer;
    P : TPoint;
begin
  result:=False;

  if (Points.Count>1) and FVisible and InsideTreeBounds then
  begin
    P.X:=X;
    P.Y:=Y;

    {$IFDEF FMX}
    Calc2DPos(Tree.Canvas,P,0);
    {$ELSE}
    Tree.Canvas.Calculate2DPosition(P.X,P.Y,0);
    {$ENDIF}

    for t:=1 to Points.Count-1 do
    begin
      result:=PointInLine( P, Points[t-1].X, Points[t-1].Y,
                              Points[t].X, Points[t].Y,
                              TeeLineClickTolerance);

      if result then
         break;
    end;
  end
end;

Constructor TPolyLineShape.Create(AOwner: TComponent);
begin
  inherited;
  IsPolyLine:=True;
end;

{ TTreeStrings }

constructor TTreeStrings.Create;
begin
  FVisible := True;
  inherited Create;
end;

procedure TTreeStrings.Assign(Source: TPersistent);
begin
  if Assigned(Source) then
  begin
    if Source is TTreeStrings then
    With TTreeStrings(Source) do
    begin
      Self.FAngle      :=FAngle; // first is "Text" (not FText)
      Self.FClipText   :=FClipText;
      Self.FHorizAlign :=FHorizAlign;
      Self.FVertAlign  :=FVertAlign;
      Self.FHorizOffset:=FHorizOffset;
      Self.FVertOffset :=FVertOffset;
      Self.FVisible    :=FVisible;
    end;

    inherited;
  end
  else // reset
  begin
    FAngle       :=0;
    FClipText    :=False;
    FHorizAlign  :=htaCenter;
    FVertAlign   :=vtaCenter;
    FHorizOffset :=0;
    FVertOffset  :=0;
    FVisible     :=True;
  end;
end;

procedure TTreeStrings.SetAngle(const Value: Integer);
begin
  IOwner.SetIntegerProperty(FAngle,Value mod 360);
end;

procedure TTreeStrings.SetClipText(const Value: Boolean);
begin
  IOwner.SetBooleanProperty(FClipText,Value);
end;

procedure TTreeStrings.SetHorizAlign(const Value: THorizTextAlign);
begin
  if FHorizAlign<>Value then
  begin
    FHorizAlign:=Value;
    IOwner.CanvasChanged(Self);
  end;
end;

procedure TTreeStrings.SetHorizOffset(const Value: Integer);
begin
  IOwner.SetIntegerProperty(FHorizOffset,Value);
end;

procedure TTreeStrings.SetTransparency(const Value: TTeeTransparency);
begin
  if FTransparency<>Value then
  begin
    FTransparency:=Value;
    IOwner.CanvasChanged(Self);
  end;
end;

procedure TTreeStrings.SetVertAlign(const Value: TVertTextAlign);
begin
  if FVertAlign<>Value then
  begin
    FVertAlign:=Value;
    IOwner.CanvasChanged(Self);
  end;
end;

procedure TTreeStrings.SetVertOffset(const Value: Integer);
begin
  IOwner.SetIntegerProperty(FVertOffset,Value);
end;

procedure TTreeStrings.SetVisible(const Value: Boolean);
begin
  IOwner.SetBooleanProperty(FVisible,Value);
end;

function TTreeNodeShape.InternalClipText: Boolean;
begin
  if Assigned(FText) then result:=FText.ClipText
                     else result:=False;
end;

function TTreeNodeShape.InternalTextAngle: Integer;
begin
  if Assigned(FText) then result:=FText.Angle
                     else result:=0;
end;

procedure TTreeNodeShape.SaveToTextFile(const FileName: String);
begin
  SaveTreeToTextFile(Self,FileName);
end;

function TTreeNodeShape.AddConnectionObject(const AToShape: TTreeNodeShape;
  const Data: Pointer): TTreeConnection;
begin
  result:=AddConnection(AToShape);

  if Assigned(result) then
     result.Data:=Data;
end;

procedure TTreeNodeShape.SetBrotherIndex(const Value: Integer);
begin
  if (FBrotherIndex<>Value) and Assigned(FParent) then
  begin
    if (Value>=0) and (Value<=FParent.Count-1) then
    begin
      FParent.Children.Exchange(FBrotherIndex,Value);
      FParent.Children[FBrotherIndex].FBrotherIndex:=FBrotherIndex;
      FBrotherIndex:=Value;

      Repaint;
    end;
  end;
end;

// Abstract method. Returning "False" in Draw parameter will
// disable drawing this handle.
procedure TTreeNodeShape.DoDrawHandle( Handle: TTreeShapeHandle;
                                       var x, y: Integer; var Draw: Boolean);
begin
  // default = Draw:=True
end;

Procedure TTreeNodeShape.DoClick(Button:TMouseButton; Shift:TShiftState; x,y:Integer);
begin
  // Called when a node is clicked. Protected.
end;

{ TTreePicture }

function TTreePicture.GetTransp: Boolean;
begin
  result:=Assigned(Graphic) {$IFNDEF FMX}and Graphic.Transparent{$ENDIF};
end;

procedure TTreePicture.SetTransp(const Value: Boolean);
begin
  {$IFNDEF FMX}
  if Assigned(Graphic) then
     Graphic.Transparent:=Value;
  {$ENDIF}
end;

{ TTextShape }

Constructor TTextShape.Create(AOwner: TComponent);
begin
  inherited;

  Border.Visible:=False;
  FTransparent:=True;
  FImageIndex:=tiNone;
end;

{ TCustomPanelTreeLink }

Destructor TCustomPanelTreeLink.Destroy;
begin
  Tree:=nil;
  inherited;
end;

procedure TCustomPanelTreeLink.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if Operation=opRemove then
     if Assigned(FTree) and (AComponent=FTree) then
        Tree:=nil;
end;

procedure TCustomPanelTreeLink.TeeEvent(Event: TTeeEvent);
begin // Abstract
end;

procedure TCustomPanelTreeLink.SetTree(const Value: TCustomTree);
begin
  if FTree<>Value then
  begin
    if Assigned(FTree) then
    begin
      FTree.RemoveListener(Self);
      FTree.RemoveFreeNotification(Self);
    end;

    FTree:=Value;

    if Assigned(FTree) then
    begin
      FTree.FreeNotification(Self);
      FTree.Listeners.Add(Self);
    end;
  end;
end;

{ TTreeRuler }

Constructor TTreeRuler.Create(AOwner:TComponent);
begin
  inherited;

  IOldPos:=-1;

  FMarker:=TTeePen.Create;
  FMarker.Color:=clRed;

  FShowUnits:=True;

  {$IFNDEF FMX}
  BevelOuter:=bvNone;
  InitFont;
  {$ENDIF}
end;

{$IFNDEF FMX}
procedure TTreeRuler.InitFont;
begin
  with Font do
  begin
    Name:='Microsoft Sans Serif';
    Size:=7;
    Color:=clDkGray;
    Style:=[];
  end;
end;
{$ENDIF}

procedure TTreeRuler.TeeEvent(Event: TTeeEvent);
begin
  if Event is TTeeMouseEvent then
  begin
    with TTeeMouseEvent(Event) do
         if Event=meMove then
            DoMouseMove({$IFDEF FMX}Round{$ENDIF}(X),
                        {$IFDEF FMX}Round{$ENDIF}(Y));
  end
  else
  if Event is TTreeAfterDrawEvent then
     {$IFDEF FMX}
     Repaint;
     {$ELSE}
     Invalidate;
     {$ENDIF}
end;

destructor TTreeRuler.Destroy;
begin
  FMarker.Free;
  inherited;
end;

procedure TTreeRuler.SetMarker(const Value: TTeePen);
begin
  FMarker.Assign(Value);
end;

procedure TTreeRuler.SetUnits(const Value: TRulerUnits);
begin
  if FUnits<>Value then
  begin
    FUnits:=Value;

    {$IFDEF FMX}
    Repaint;
    {$ELSE}
    Invalidate;
    {$ENDIF}
  end;
end;

function TTreeRuler.IsAlignLeft:Boolean;
begin
  result:=Align={$IFDEF FMX}TAlignLayout.{$IFDEF D20}Left{$ELSE}alLeft{$ENDIF}{$ELSE}alLeft{$ENDIF};
end;

procedure TTreeRuler.DoMouseMove(x, y: Integer);

  Procedure PaintMarker(Position:Integer);
  begin
    With Canvas do
    begin
      {$IFDEF FMX}
      Stroke.Assign(FMarker);
      {$ELSE}
      Pen.Assign(FMarker);
      Pen.Mode:=pmNotXor;
      {$ENDIF}

      if IsAlignLeft then
      begin
        {$IFDEF FMX}
        DrawLine(PointF(2,2+Position),PointF(Width-1,2+Position),1);
        {$ELSE}
        MoveTo(2,2+Position);
        LineTo(Width-1,2+Position);
        {$ENDIF}
      end
      else
      begin
        Inc(Position,{$IFDEF FMX}Round{$ENDIF}(Tree.BoundsRect.Left-Self.BoundsRect.Left));

        {$IFDEF FMX}
        DrawLine(PointF(2+Position,2),PointF(2+Position,Height-1),1);
        {$ELSE}
        MoveTo(2+Position,2);
        LineTo(2+Position,Height-1);
        {$ENDIF}
      end;

      {$IFNDEF FMX}
      Pen.Mode:=pmCopy;
      {$ENDIF}
    end;
  end;

  Procedure NewMarker(const Position:Integer);
  begin
    PaintMarker(Position);
    IOldPos:=Position;
  end;

begin
  if FMarker.Visible and Assigned(FTree) then
  begin
    if IOldPos<>-1 then
       PaintMarker(IOldPos);

    if IsAlignLeft then
       NewMarker(y)
    else
       NewMarker(x);
  end;
end;

procedure TTreeRuler.SetShowUnits(const Value: Boolean);
begin
  if FShowUnits<>Value then
  begin
    FShowUnits:=Value;

    {$IFDEF FMX}
    Repaint;
    {$ELSE}
    Invalidate;
    {$ENDIF}
  end;
end;

{$IFNDEF FMX}
function Create90DegreeFont(const AHandle:HDC; const AFont:HFONT):HFONT;
var NewFont  : HFONT;
    LogRec   : TLOGFONT;
begin
  GetObject(AFont, SizeOf(LogRec), @LogRec);

  LogRec.lfEscapement   := 90*10;
  LogRec.lfOrientation  := 90*10;
  LogRec.lfOutPrecision := OUT_TT_ONLY_PRECIS;
  LogRec.lfQuality:=TeeFontAntiAlias;
  NewFont:=CreateFontIndirect(LogRec);
  result:=SelectObject(AHandle,NewFont);
end;
{$ENDIF}

function TTreeRuler.IsVerticalAlign:Boolean;
begin
  result:=IsAlignLeft or
          (Align={$IFDEF FMX}TAlignLayout.{$IFDEF D20}Right{$ELSE}alRight{$ENDIF}{$ELSE}alRight{$ENDIF});
end;

Function TTreeRuler.UnitsToStr(const Pixels:Integer):String;
var tmp : Double;
begin
  if FUnits=ruPixels then
     result:=TeeStr(Pixels)
  else
  begin
    tmp:=Pixels/{$IFDEF FMX}96{$ELSE}Screen.PixelsPerInch{$ENDIF};

    if FUnits=ruCentimeters then
       tmp:=2.54*tmp;

    result:=FormatFloat('0.##',tmp);
  end;

  if Assigned(FOnGetUnit) then
     FOnGetUnit(Self,Pixels,result);
end;

type
  TTreeAccess=class(TCustomTree);

procedure TTreeRuler.Paint;
var t        : TCoordinate;
    tmpH     : Integer;
    tmpV     : Integer;
    tmpS     : Integer;
    tmpEnd   : TCoordinate;
    tmpP     : TPoint;
    tmpVert  : Boolean;
    tmpMajor : Boolean;

    {$IFNDEF FMX}
    DC       : TTeeCanvasHandle;
    OldFont  : HFONT;
    {$ENDIF}

    tmpOffX  : TCoordinate;
    tmpWidth,
    tmp      : Integer;

    {$IFDEF FMX}
    Pen : {$IFDEF D17}TStrokeBrush{$ELSE}TBrush{$ENDIF};
    tmpTX,
    tmpTY : Single;
    {$ENDIF}
begin
  inherited;
  IOldPos:=-1;

  {$IFNDEF FMX}
  OldFont:=0;
  DC:=0;
  {$ENDIF};

  if Assigned(FTree) and Assigned(FTree.Canvas) then
  With Canvas do
  begin
    {$IFDEF FMX}
    Pen:=Stroke;
    {$ENDIF}

    {$IFDEF FMX}
    Stroke.Style:=TBrushKind.{$IFDEF D20}Solid{$ELSE}bkSolid{$ENDIF};

    {$IFDEF D17}
    Stroke.Thickness:=1;
    {$ELSE}
    StrokeThickness:=1;
    {$ENDIF}

    Stroke.Color:=TAlphaColors.Darkgray;
    {$ELSE}
    Pen.Style:=psSolid;
    Pen.Width:=1;
    Pen.Color:=clDkGray;
    {$ENDIF}

    tmpVert:=IsVerticalAlign;

    if FShowUnits then
    begin
      {$IFNDEF FMX}
      Font:=Self.Font;
      {$ENDIF}

      { rotate font 90 degree }
      if tmpVert then
      begin
        {$IFNDEF FMX}
        OldFont:=Create90DegreeFont(Handle,Font.Handle);
        SetTextAlign(DC,TA_RIGHT);
        {$ENDIF}
      end;
    end;

    {$IFNDEF FMX}
    SetBkMode(Handle,TRANSPARENT);
    {$ENDIF}

    With TTreeAccess(FTree).PrepareGrid(tmpH,tmpV) do
    begin
      if tmpVert then
      begin
        t:=Top;
        tmpEnd:=Bottom;
        tmp:=tmpV;
      end
      else
      begin
        t:=Left+tmpH;

        tmpEnd:=Right;
        tmp:=tmpH;
      end;

      While t<tmpEnd do
      begin
        if tmpVert then
        begin
          tmpP.Y:=t;
          tmpP.X:=0;
        end
        else
        begin
          tmpP.X:=t;
          tmpP.Y:=0;
        end;

        tmpMajor:=({$IFDEF FMX}System.Round{$ENDIF}(t) mod (FTree.Grid.BigStep*tmp))=0;

        if tmpMajor then
        begin
          Pen.Color:=clBlack;

          if t=0 then
             tmpWidth:=2
          else
             tmpWidth:=1;

          {$IFDEF FMX}
          {$IFDEF D17}
          Pen.Thickness:=tmpWidth;
          {$ELSE}
          StrokeThickness:=tmpWidth;
          {$ENDIF}
          {$ELSE}
          Pen.Width:=tmpWidth;
          {$ENDIF}

          tmpS:=2;
        end
        else
        begin
          Pen.Color:=clDkGray;

          {$IFDEF FMX}
          {$IFDEF D17}
          Pen.Thickness:=1;
          {$ELSE}
          StrokeThickness:=1;
          {$ENDIF}
          {$ELSE}
          Pen.Width:=1;
          {$ENDIF}

          tmpS:=10;
        end;

        tmpP:=FTree.Canvas.Calculate3DPosition(tmpP.X,tmpP.Y,TeeTreeZ);

        if tmpVert then
        begin
          {$IFDEF FMX}
          DrawLine(PointF(tmpS,tmpP.Y),PointF(Width-1,tmpP.Y),1);
          {$ELSE}
          MoveTo(tmpS,tmpP.Y);
          LineTo(Width-1,tmpP.Y);
          {$ENDIF}

          tmpOffX:=0;
        end
        else
        begin
          tmpOffX:=(Tree.BoundsRect.Left-Self.BoundsRect.Left);

          if Align={$IFDEF FMX}TAlignLayout.{$IFDEF D20}Bottom{$ELSE}alBottom{$ENDIF}{$ELSE}alBottom{$ENDIF} then
          begin
            {$IFDEF FMX}
            DrawLine(PointF(tmpP.X+tmpOffX,1),PointF(tmpP.X+tmpOffX,Height-tmpS),1);
            {$ELSE}
            MoveTo(tmpP.X+tmpOffX,1);
            LineTo(tmpP.X+tmpOffX,Height-tmpS);
            {$ENDIF}
          end
          else
          begin
            {$IFDEF FMX}
            DrawLine(PointF(tmpP.X-tmpOffX,tmpS),PointF(tmpP.X+tmpOffX,Height-1),1);
            {$ELSE}
            MoveTo(tmpP.X+tmpOffX,tmpS);
            LineTo(tmpP.X+tmpOffX,Height-1);
            {$ENDIF}
          end;
        end;

        if FShowUnits and tmpMajor then
        begin
          {$IFDEF FMX}

          if tmpVert then
          begin
            tmpTX:=tmpS-3;
            tmpTY:=tmpP.y+4;
          end
          else
          begin
            tmpTX:=tmpP.X+tmpOffX+2;
            tmpTY:=tmpS-3;
          end;

          FillText(RectF(tmpTX,tmpTY,1000,1000),
             UnitsToStr(System.Round(t)),False,1,[],
                        TTextAlign.{$IFDEF D20}Leading{$ELSE}taLeading{$ENDIF});

          {$ELSE}
          if tmpVert then TextOut(tmpS-3,tmpP.y+4,UnitsToStr(t))
                     else TextOut(tmpP.X+tmpOffX+2,tmpS-3,UnitsToStr(t));
          {$ENDIF}
        end;

        t:=t+tmp;
      end;
    end;

    {$IFNDEF FMX}
    if OldFont<>0 then
       DeleteObject(SelectObject(DC,OldFont));
    {$ENDIF}
  end;
end;

procedure TTreeNodeShape.SetBounds(const R: TRect);
begin
  with R{$IFDEF FMX}.Round{$ENDIF} do
  begin
    FX0:=Left;
    FY0:=Top;
    FX1:=Right;
    FY1:=Bottom;
  end;
end;

function TTreeNodeShape.GetEditedShape: TTreeNodeShape;
begin
  result:=Self;
end;

{$IFNDEF FMX}
procedure LoadCustomCursors;
begin
  // Internal cursors, used in TGridShape class
  Screen.Cursors[crArrowRight]:=LoadCursor(HInstance,'TREEARROWRIGHT');
  Screen.Cursors[crArrowDown]:=LoadCursor(HInstance,'TREEARROWDOWN');
end;

procedure ResetCursors;
begin
  DestroyCursor(Screen.Cursors[crArrowRight]);
  DestroyCursor(Screen.Cursors[crArrowDown]);

  Screen.Cursors[crArrowRight]:=NullCursor;
  Screen.Cursors[crArrowDown]:=NullCursor;
end;
{$ENDIF}

procedure CreateGrayDotPen;
begin
  { optimization, create Gray small-dotted pen }
  GrayDotPen:={$IFDEF FMX}TTeePen{$ELSE}TPen{$ENDIF}.Create;

  {$IFNDEF FMX}
  if IsWindowsNT then
     {$IFNDEF D10}
     GrayDotPen.Handle:=TeeCreatePenSmallDots(clGray)
     {$ENDIF}
  else
  {$ENDIF}
  begin
    GrayDotPen.Color:=clDkGray;
    GrayDotPen.Style:=psDot;
  end;
end;

procedure RegisterTreeClasses;
begin
  TeeActivateGroup;

  RegisterClasses([TTreeNodeShape,TTreeConnection]);

  {$IFDEF FMX}
    GroupDescendentsWith(TCustomTree,TFMXObject);
    GroupDescendentsWith(TCustomTreeElement,TFMXObject);
  {$ELSE}
    GroupDescendentsWith(TCustomTree,TControl);
    GroupDescendentsWith(TCustomTreeElement,TControl);
  {$ENDIF}
end;

procedure FreeTreeGlobals;
begin
  GrayDotPen.Free; // destroy internal pen

  // destroy image bitmaps pool
  TreeImagePool.Free;
end;

initialization
  // initialize pool of "stock" image bitmaps...
  TreeImagePool:=TTreeImagePool.Create;

  TreeCustomShapes:=TList{$IFDEF D18}<Pointer>{$ENDIF}.Create;  // global list of shape classes

  RegisterTreeClasses;

  CreateGrayDotPen;

  {$IFNDEF FMX}
  LoadCustomCursors;
  {$ENDIF}

finalization
  // finalize custom cursors...
  {$IFNDEF FMX}
  ResetCursors;
  {$ENDIF}

  FreeTreeGlobals;

  // destroy list of shape classes
  TreeRemoveCustomShapes;
end.

