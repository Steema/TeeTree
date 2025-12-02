{**********************************************}
{   TTree Component  - Tree Editor dialog      }
{   Copyright (c) 1998-2025 by Steema Software }
{**********************************************}
{$I TeeDefs.inc}
unit TreeEd;

interface

uses
  {$IFNDEF LINUX}
  Windows, Messages,
  {$ENDIF}
  SysUtils, Classes,

  Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls, Buttons, Menus,
  ComCtrls, ExtDlgs, Grids, ImgList,

  TeeTree, TeCanvas, TeeProcs, TeeRecentFiles,

  Types,

  {$IFDEF D17}
  System.UITypes,
  {$ENDIF}

  TeeGDIPlus, TeePenDlg, TeeInspector, TreeNavigator, TeeNavigator;

Const sgStandard=0;  { "Standard" shape toolbar tab }

type
  { internal, used to show standard shapes at toolbar }

  TTreeTagShape=packed record
    UseStyle : Boolean;
    Style    : TTreeShapeStyle;
    AClass   : TTreeNodeShapeClass;
    AInstance: TTreeNodeShape;
  end;

  PTreeTagShape=^TTreeTagShape;

  TTreeUndoItem=class(TCollectionItem)
  private
    FStore : TPersistent;
    Procedure StoreCopy;
  public
    Source : TPersistent;
    Text   : String;
    Destructor Destroy; override;
    Procedure Undo;
  end;

  TTreeUndo=class(TCollection)
  public
    Procedure Add(ASource:TPersistent; Const AText:String);
    Function Last:TTreeUndoItem;
    Procedure Undo;
  end;

  TTreeClass=class of TCustomTree;

  TTreeEditor = class(TForm)
    PopupNode: TPopupMenu;
    Copy1: TMenuItem;
    Cut1: TMenuItem;
    Paste1: TMenuItem;
    Delete1: TMenuItem;
    N1: TMenuItem;
    Edit1: TMenuItem;
    BringtoFront1: TMenuItem;
    SendtoBack1: TMenuItem;
    N2: TMenuItem;
    AddChild1: TMenuItem;
    AddBrother1: TMenuItem;
    N5: TMenuItem;
    AddnewRoot2: TMenuItem;
    Prune1: TMenuItem;
    PageTree: TPageControl;
    TabGeneral: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    BCrossBorder: TButtonPen;
    SignPenButton: TButtonPen;
    Button6: TButton;
    Label8: TLabel;
    Edit2: TEdit;
    UDCrossSize: TUpDown;
    TabSheet4: TTabSheet;
    BBackImage: TButton;
    Label3: TLabel;
    CBImageStyle: TComboFlat;
    Label4: TLabel;
    Label5: TLabel;
    Aligntogrid1: TMenuItem;
    TabSheet5: TTabSheet;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    StatusBar1: TStatusBar;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    TabSheet6: TTabSheet;
    CBAllowZoom: TCheckBox;
    Label7: TLabel;
    CBAllowScroll: TComboFlat;
    CBZoomAnimated: TCheckBox;
    Label9: TLabel;
    Edit3: TEdit;
    UpDown2: TUpDown;
    TabSheet7: TTabSheet;
    Button7: TButtonPen;
    CBSelectedColorDef: TCheckBox;
    CBSelectedTextDef: TCheckBox;
    TabSheet8: TTabSheet;
    GroupBox1: TGroupBox;
    CBHorizVisible: TCheckBox;
    GroupBox2: TGroupBox;
    CBVertVisible: TCheckBox;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Edit4: TMenuItem;
    View1: TMenuItem;
    Insert1: TMenuItem;
    Format1: TMenuItem;
    Tools1: TMenuItem;
    N3: TMenuItem;
    AboutTeeTree101: TMenuItem;
    N4: TMenuItem;
    TeeTree10HomePage1: TMenuItem;
    wwwSteemacom1: TMenuItem;
    New1: TMenuItem;
    Open1: TMenuItem;
    Saveas1: TMenuItem;
    Close1: TMenuItem;
    N6: TMenuItem;
    Printpreview1: TMenuItem;
    Print1: TMenuItem;
    N7: TMenuItem;
    Cut2: TMenuItem;
    Copy2: TMenuItem;
    Paste2: TMenuItem;
    Delete2: TMenuItem;
    Selectall1: TMenuItem;
    N8: TMenuItem;
    Search2: TMenuItem;
    Zoom1: TMenuItem;
    N1001: TMenuItem;
    N751: TMenuItem;
    N501: TMenuItem;
    N251: TMenuItem;
    N151: TMenuItem;
    N101: TMenuItem;
    N11: TMenuItem;
    Connections1: TMenuItem;
    Images1: TMenuItem;
    Text1: TMenuItem;
    Shapes1: TMenuItem;
    Crossboxes1: TMenuItem;
    Grid1: TMenuItem;
    Child1: TMenuItem;
    Brother1: TMenuItem;
    Prunenode1: TMenuItem;
    Linknodes1: TMenuItem;
    Style1: TMenuItem;
    Border1: TMenuItem;
    Font1: TMenuItem;
    Gradient1: TMenuItem;
    Shadow1: TMenuItem;
    Transparent1: TMenuItem;
    RoundRectangle1: TMenuItem;
    Rectangle2: TMenuItem;
    Ellipse2: TMenuItem;
    Triangle2: TMenuItem;
    Line2: TMenuItem;
    Diamond2: TMenuItem;
    N15: TMenuItem;
    NewRoot1: TMenuItem;
    N2001: TMenuItem;
    N51: TMenuItem;
    Editortabs1: TMenuItem;
    Left1: TMenuItem;
    Top1: TMenuItem;
    Right1: TMenuItem;
    Bottom1: TMenuItem;
    Horizontal1: TMenuItem;
    Vertical1: TMenuItem;
    Diagonal1: TMenuItem;
    InvDiagonal1: TMenuItem;
    N9: TMenuItem;
    Help1: TMenuItem;
    CBVertAuto: TCheckBox;
    Shapetabs1: TMenuItem;
    TrackBarZoom: TTrackBar;
    CBHorizAuto: TCheckBox;
    Export1: TMenuItem;
    CBBuffered: TCheckBox;
    TabSheet10: TTabSheet;
    CBSnapGrid: TCheckBox;
    CBGrid: TCheckBox;
    Label12: TLabel;
    UpDown3: TUpDown;
    Edit5: TEdit;
    SaveDialog1: TSaveDialog;
    CBScrollToView: TCheckBox;
    Button3: TButtonPen;
    CBShowHint: TCheckBox;
    CBSingleSelect: TCheckBox;
    Editortips1: TMenuItem;
    N10: TMenuItem;
    PageShapes: TPageControl;
    TabSheet9: TTabSheet;
    SpeedNormal: TSpeedButton;
    SpeedLink: TSpeedButton;
    NodeTheTree: TMenuItem;
    PageNodes: TPanel;
    Splitter1: TSplitter;
    CBAllowDelete: TCheckBox;
    N12: TMenuItem;
    AligntoGrid2: TMenuItem;
    NewParent1: TMenuItem;
    ShowNames1: TMenuItem;
    Import1: TMenuItem;
    OpenDialog1: TOpenDialog;
    PanelToolButtons: TPanel;
    ButtonNew: TSpeedButton;
    ButtonOpen: TSpeedButton;
    ButtonPrint: TSpeedButton;
    ButtonPrintPreview: TSpeedButton;
    ButtonSave: TSpeedButton;
    ButtonScroll: TSpeedButton;
    TabSheet12: TTabSheet;
    Label15: TLabel;
    BHandlePen: TButtonPen;
    EHandleSize: TEdit;
    UDHandleSize: TUpDown;
    PanelFont: TPanel;
    FontBold: TSpeedButton;
    FontItalic: TSpeedButton;
    FontUnderline: TSpeedButton;
    FontStrike: TSpeedButton;
    FontLeftAlign: TSpeedButton;
    FontCenterAlign: TSpeedButton;
    FontRightAlign: TSpeedButton;
    ShapeFontColor: TShape;
    SBOutline: TSpeedButton;
    ComboFonts: TComboFlat;
    ComboFontSize: TComboFlat;
    EditFontInter: TEdit;
    UDFontInter: TUpDown;
    ImageList1: TImageList;
    N13: TMenuItem;
    Fonttoolbar1: TMenuItem;
    Statusbar2: TMenuItem;
    CBZoomCentered: TCheckBox;
    Toolbar1: TMenuItem;
    PanelToolbar: TPanel;
    Reopen1: TMenuItem;
    N14: TMenuItem;
    Label13: TLabel;
    CBCrossStyle: TComboFlat;
    Label19: TLabel;
    CBBevelInner: TComboFlat;
    Label20: TLabel;
    CBBevelOuter: TComboFlat;
    CBBorder: TCheckBox;
    PanelTree: TPanel;
    Rulers1: TMenuItem;
    Save1: TMenuItem;
    NodeTree: TTree;
    PanelNodes: TPanel;
    PanelNodesInt: TPanel;
    PopupConn: TPopupMenu;
    Edit6: TMenuItem;
    PanelShape: TPanel;
    ShapeBorderColor: TShape;
    ComboPenStyle: TComboFlat;
    BorderWidth: TScrollBar;
    Bordertoolbar1: TMenuItem;
    Delete3: TMenuItem;
    Bevel1: TBevel;
    ShapeBrush: TShape;
    ComboBrush: TComboFlat;
    ComboText: TComboFlat;
    TabControl1: TTabControl;
    PopupNodeTree: TPopupMenu;
    Aligntoleft1: TMenuItem;
    N16: TMenuItem;
    Visible1: TMenuItem;
    PopupPoint: TPopupMenu;
    Delete4: TMenuItem;
    CBTransp: TCheckBox;
    Addnewpoint1: TMenuItem;
    N17: TMenuItem;
    Addnewpoint2: TMenuItem;
    N18: TMenuItem;
    Color1: TMenuItem;
    N19: TMenuItem;
    Pattern1: TMenuItem;
    ClipText1: TMenuItem;
    CBHotTrack: TCheckBox;
    Label1: TLabel;
    CBWheel: TComboFlat;
    N20: TMenuItem;
    Style2: TMenuItem;
    Fixed1: TMenuItem;
    Relativetostartnode1: TMenuItem;
    Relativetoendnode1: TMenuItem;
    AutoScroll1: TMenuItem;
    N110: TMenuItem;
    Sendbyemail1: TMenuItem;
    Timer1: TTimer;
    PanelTools: TPanel;
    BHandleColor: TButtonColor;
    BGridColor: TButtonColor;
    BSelectedColor: TButtonColor;
    BCrossColor: TButtonColor;
    BSelectedText: TButtonColor;
    BUnFocusedColor: TButtonColor;
    PanelInspector: TPanel;
    Splitter2: TSplitter;
    PopupFormat: TPopupMenu;
    PopupMenuPanel: TPopupMenu;
    PanelBackimage: TMenuItem;
    MenuItem2: TMenuItem;
    Lower1: TMenuItem;
    Raise1: TMenuItem;
    None1: TMenuItem;
    PanelBorder: TMenuItem;
    PanelColor: TMenuItem;
    PanelGradient: TMenuItem;
    Image1: TMenuItem;
    HotTrack1: TMenuItem;
    ShowHints1: TMenuItem;
    Border2: TMenuItem;
    Color2: TMenuItem;
    Gradient2: TMenuItem;
    Image2: TMenuItem;
    Transparent2: TMenuItem;
    Font2: TMenuItem;
    Pattern2: TMenuItem;
    TimerButton: TTimer;
    Shadow2: TMenuItem;
    Autosize1: TMenuItem;
    Cliptext2: TMenuItem;
    CrossBox1: TMenuItem;
    Automatic1: TMenuItem;
    Always1: TMenuItem;
    Never1: TMenuItem;
    BGridPen: TButtonPen;
    BGridBigPen: TButtonPen;
    PopupConnFormat: TPopupMenu;
    Border3: TMenuItem;
    Points1: TMenuItem;
    Font3: TMenuItem;
    ButtonZoomIn: TSpeedButton;
    ButtonZoomOut: TSpeedButton;
    Edit7: TEdit;
    UpDown1: TUpDown;
    Inspector1: TMenuItem;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    Fromarrow1: TMenuItem;
    ToArrow1: TMenuItem;
    Text2: TMenuItem;
    GroupBox3: TGroupBox;
    CBShowRulers: TCheckBox;
    CBRulersUnits: TCheckBox;
    Label2: TLabel;
    TabSheet1: TTabSheet;
    Label10: TLabel;
    CBPrinterDefault: TCheckBox;
    EPageWidth: TEdit;
    UDPageWidth: TUpDown;
    Label11: TLabel;
    EPageHeight: TEdit;
    UDPageHeight: TUpDown;
    BPageBorder: TButtonPen;
    ButtonColor1: TButtonColor;
    CBPrintPanel: TCheckBox;
    Toolbars1: TMenuItem;
    Style3: TMenuItem;
    Automatic2: TMenuItem;
    Line1: TMenuItem;
    Sides1: TMenuItem;
    Curve1: TMenuItem;
    CBPrintPageBorder: TCheckBox;
    CBScrollFlat: TCheckBox;
    CBUnits: TComboFlat;
    BackColor1: TMenuItem;
    UDZoom: TUpDown;
    BGradPanel: TButton;
    CBTextEnabled: TCheckBox;
    Label6: TLabel;
    CBTextMode: TComboFlat;
    Label14: TLabel;
    CBTextKey: TComboFlat;
    Label16: TLabel;
    CBTextMouse: TComboFlat;
    CBTextSize: TCheckBox;
    CBTextFormat: TCheckBox;
    RadioGroup1: TRadioGroup;
    CBTextFont: TCheckBox;
    Bevel2: TBevel;
    N21: TMenuItem;
    Sizetogrid1: TMenuItem;
    PaintBox1: TPaintBox;
    N22: TMenuItem;
    Copyaspicture1: TMenuItem;
    HorizRuler: TTreeRuler;
    VertRuler: TTreeRuler;
    Automatic3: TMenuItem;
    TeeInspector1: TTeeInspector;
    TreePageNavigator1: TTreePageNavigator;
    InvertedSides1: TMenuItem;
    N24: TMenuItem;
    Linestyle1: TMenuItem;
    Sidesstyle1: TMenuItem;
    Invertedsidesstyle1: TMenuItem;
    Curve2: TMenuItem;
    Automatic4: TMenuItem;
    SBCloseInspector: TSpeedButton;
    SBCloseNodeTree: TSpeedButton;
    Shadow3: TMenuItem;
    Chamfer1: TMenuItem;
    CBRender: TCheckBox;
    procedure BBackImageClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CBGridClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AddBrother1Click(Sender: TObject);
    procedure AddChild1Click(Sender: TObject);
    procedure BringtoFront1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure PopupNodePopup(Sender: TObject);
    procedure SendtoBack1Click(Sender: TObject);
    procedure CBImageStyleChange(Sender: TObject);
    procedure AddnewRoot2Click(Sender: TObject);
    procedure Prune1Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Aligntogrid1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure CBAllowScrollChange(Sender: TObject);
    procedure CBZoomAnimatedClick(Sender: TObject);
    procedure CBAllowZoomClick(Sender: TObject);
    procedure CBSelectedColorDefClick(Sender: TObject);
    procedure CBSelectedTextDefClick(Sender: TObject);
    procedure CBHorizVisibleClick(Sender: TObject);
    procedure CBVertVisibleClick(Sender: TObject);
    procedure AboutTeeTree101Click(Sender: TObject);
    procedure TeeTree10HomePage1Click(Sender: TObject);
    procedure wwwSteemacom1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure Printpreview1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure Saveas1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Cut2Click(Sender: TObject);
    procedure Copy2Click(Sender: TObject);
    procedure Paste2Click(Sender: TObject);
    procedure Delete2Click(Sender: TObject);
    procedure Selectall1Click(Sender: TObject);
    procedure Search2Click(Sender: TObject);
    procedure N1001Click(Sender: TObject);
    procedure N751Click(Sender: TObject);
    procedure N501Click(Sender: TObject);
    procedure N251Click(Sender: TObject);
    procedure N151Click(Sender: TObject);
    procedure N101Click(Sender: TObject);
    procedure Child1Click(Sender: TObject);
    procedure Brother1Click(Sender: TObject);
    procedure Prunenode1Click(Sender: TObject);
    procedure NewRoot1Click(Sender: TObject);
    procedure Connections1Click(Sender: TObject);
    procedure Images1Click(Sender: TObject);
    procedure Grid1Click(Sender: TObject);
    procedure Text1Click(Sender: TObject);
    procedure Crossboxes1Click(Sender: TObject);
    procedure Shapes1Click(Sender: TObject);
    procedure Color1Click(Sender: TObject);
    procedure Format1Click(Sender: TObject);
    procedure Insert1Click(Sender: TObject);
    procedure Gradient1Click(Sender: TObject);
    procedure Border1Click(Sender: TObject);
    procedure Font1Click(Sender: TObject);
    procedure Shadow1Click(Sender: TObject);
    procedure Style1Click(Sender: TObject);
    procedure Transparent1Click(Sender: TObject);
    procedure Edit4Click(Sender: TObject);
    procedure N2001Click(Sender: TObject);
    procedure N51Click(Sender: TObject);
    procedure View1Click(Sender: TObject);
    procedure Editortabs1Click(Sender: TObject);
    procedure Zoom1Click(Sender: TObject);
    procedure Line2Click(Sender: TObject);
    procedure Triangle2Click(Sender: TObject);
    procedure RoundRectangle1Click(Sender: TObject);
    procedure Rectangle2Click(Sender: TObject);
    procedure Ellipse2Click(Sender: TObject);
    procedure Left1Click(Sender: TObject);
    procedure Top1Click(Sender: TObject);
    procedure Right1Click(Sender: TObject);
    procedure Bottom1Click(Sender: TObject);
    procedure Horizontal1Click(Sender: TObject);
    procedure Vertical1Click(Sender: TObject);
    procedure Diagonal1Click(Sender: TObject);
    procedure InvDiagonal1Click(Sender: TObject);
    procedure Diamond2Click(Sender: TObject);
    procedure Linknodes1Click(Sender: TObject);
    procedure Help1Click(Sender: TObject);
    procedure CBVertAutoClick(Sender: TObject);
    procedure SpeedLinkClick(Sender: TObject);
    procedure PageShapesChange(Sender: TObject);
    procedure SpeedNormalClick(Sender: TObject);
    procedure Shapetabs1Click(Sender: TObject);
    procedure TrackBarZoomChange(Sender: TObject);
    procedure CBHorizAutoClick(Sender: TObject);
    procedure Export1Click(Sender: TObject);
    procedure CBBufferedClick(Sender: TObject);
    procedure CBSnapGridClick(Sender: TObject);
    procedure Edit5Change(Sender: TObject);
    procedure Tools1Click(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure CBScrollToViewClick(Sender: TObject);
    procedure CBShowHintClick(Sender: TObject);
    procedure CBSingleSelectClick(Sender: TObject);
    procedure Editortips1Click(Sender: TObject);
    procedure NodeTheTreeClick(Sender: TObject);
    procedure NodeTreeSelectShape(Sender: TTreeNodeShape);
    procedure NodeTreeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CBAllowDeleteClick(Sender: TObject);
    procedure NodeTreeDeletingShapes(Sender: TSelectedShapeList;
      var AllowDelete: Boolean);
    procedure NodeTreeStopEditing(Sender: TTreeNodeShape);
    procedure NewParent1Click(Sender: TObject);
    procedure AligntoGrid2Click(Sender: TObject);
    procedure ShowNames1Click(Sender: TObject);
    procedure Import1Click(Sender: TObject);
    procedure ButtonNewClick(Sender: TObject);
    procedure ButtonOpenClick(Sender: TObject);
    procedure ButtonPrintClick(Sender: TObject);
    procedure ButtonPrintPreviewClick(Sender: TObject);
    procedure ButtonZoomInClick(Sender: TObject);
    procedure ButtonScrollClick(Sender: TObject);
    procedure EHandleSizeChange(Sender: TObject);
    procedure ShapeFontColorMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Fonttoolbar1Click(Sender: TObject);
    procedure Statusbar2Click(Sender: TObject);
    procedure ComboFontsChange(Sender: TObject);
    procedure ComboFontSizeChange(Sender: TObject);
    procedure FontBoldClick(Sender: TObject);
    procedure EditFontInterChange(Sender: TObject);
    procedure SBOutlineClick(Sender: TObject);
    procedure FontLeftAlignClick(Sender: TObject);
    procedure CBZoomCenteredClick(Sender: TObject);
    procedure Toolbar1Click(Sender: TObject);
    procedure CBShowRulersClick(Sender: TObject);
    procedure Rulers1Click(Sender: TObject);
    procedure CBBevelInnerChange(Sender: TObject);
    procedure CBBevelOuterChange(Sender: TObject);
    procedure CBBorderClick(Sender: TObject);
    procedure CBCrossStyleChange(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure NodeTreeUnSelectShape(Sender: TTreeNodeShape);
    procedure Edit6Click(Sender: TObject);
    procedure ComboPenStyleChange(Sender: TObject);
    procedure ShapeBorderColorMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BorderWidthChange(Sender: TObject);
    procedure ComboPenStyleDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure Bordertoolbar1Click(Sender: TObject);
    procedure Delete3Click(Sender: TObject);
    procedure ShapeBrushMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ComboBrushDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ComboBrushChange(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure Visible1Click(Sender: TObject);
    procedure Aligntoleft1Click(Sender: TObject);
    procedure PageNodesMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ComboTextChange(Sender: TObject);
    procedure Delete4Click(Sender: TObject);
    procedure CBTranspClick(Sender: TObject);
    procedure Addnewpoint1Click(Sender: TObject);
    procedure Pattern1Click(Sender: TObject);
    procedure ClipText1Click(Sender: TObject);
    procedure CBHotTrackClick(Sender: TObject);
    procedure CBWheelChange(Sender: TObject);
    procedure PopupPointPopup(Sender: TObject);
    procedure Fixed1Click(Sender: TObject);
    procedure Relativetostartnode1Click(Sender: TObject);
    procedure Relativetoendnode1Click(Sender: TObject);
    procedure AutoScroll1Click(Sender: TObject);
    procedure N110Click(Sender: TObject);
    procedure Sendbyemail1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure BGridColorClick(Sender: TObject);
    procedure BSelectedColorClick(Sender: TObject);
    procedure BSelectedTextClick(Sender: TObject);
    procedure BUnFocusedColorClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure PopupMenuPanelPopup(Sender: TObject);
    procedure PanelBackimageClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure None1Click(Sender: TObject);
    procedure PanelBorderClick(Sender: TObject);
    procedure PanelColorClick(Sender: TObject);
    procedure PanelGradientClick(Sender: TObject);
    procedure HotTrack1Click(Sender: TObject);
    procedure ShowHints1Click(Sender: TObject);
    procedure Transparent2Click(Sender: TObject);
    procedure TimerButtonTimer(Sender: TObject);
    procedure PopupFormatPopup(Sender: TObject);
    procedure Border2Click(Sender: TObject);
    procedure Color2Click(Sender: TObject);
    procedure Font2Click(Sender: TObject);
    procedure Gradient2Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Pattern2Click(Sender: TObject);
    procedure Autosize1Click(Sender: TObject);
    procedure Cliptext2Click(Sender: TObject);
    procedure Never1Click(Sender: TObject);
    procedure Shadow2Click(Sender: TObject);
    procedure PopupConnFormatPopup(Sender: TObject);
    procedure Border3Click(Sender: TObject);
    procedure Points1Click(Sender: TObject);
    procedure Font3Click(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure ButtonZoomOutClick(Sender: TObject);
    procedure Inspector1Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure PageTreeChange(Sender: TObject);
    procedure Fromarrow1Click(Sender: TObject);
    procedure ToArrow1Click(Sender: TObject);
    procedure Text2Click(Sender: TObject);
    procedure CBRulersUnitsClick(Sender: TObject);
    procedure CBPrintPanelClick(Sender: TObject);
    procedure BPageBorderClick(Sender: TObject);
    procedure BHandleColorClick(Sender: TObject);
    procedure BHandlePenClick(Sender: TObject);
    procedure BGridPenClick(Sender: TObject);
    procedure BGridBigPenClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ButtonColor1Click(Sender: TObject);
    procedure BCrossBorderClick(Sender: TObject);
    procedure BCrossColorClick(Sender: TObject);
    procedure SignPenButtonClick(Sender: TObject);
    procedure CBPrinterDefaultClick(Sender: TObject);
    procedure EPageWidthChange(Sender: TObject);
    procedure EPageHeightChange(Sender: TObject);
    procedure Curve1Click(Sender: TObject);
    procedure CBPrintPageBorderClick(Sender: TObject);
    procedure CBScrollFlatClick(Sender: TObject);
    procedure CBUnitsChange(Sender: TObject);
    procedure BackColor1Click(Sender: TObject);
    procedure ComboFontSizeExit(Sender: TObject);
    procedure UDZoomClick(Sender: TObject; Button: TUDBtnType);
    procedure CBTextEnabledClick(Sender: TObject);
    procedure CBTextModeChange(Sender: TObject);
    procedure CBTextKeyChange(Sender: TObject);
    procedure CBTextMouseChange(Sender: TObject);
    procedure CBTextSizeClick(Sender: TObject);
    procedure CBTextFormatClick(Sender: TObject);
    procedure CBTextFontClick(Sender: TObject);
    procedure SBFontGradClick(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure Copyaspicture1Click(Sender: TObject);
    procedure ComboTextDropDown(Sender: TObject);
    procedure Automatic3Click(Sender: TObject);
    procedure Curve2Click(Sender: TObject);
    procedure PopupConnPopup(Sender: TObject);
    procedure SBCloseInspectorClick(Sender: TObject);
    procedure PanelInspectorResize(Sender: TObject);
    procedure SBCloseNodeTreeClick(Sender: TObject);
    procedure Shadow3Click(Sender: TObject);
    procedure Chamfer1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CBRenderClick(Sender: TObject);
  private
    { Private declarations }
    FRecentFiles   : TRecentFiles;
    TreeClipboard  : TTreeClipboard;

    Creating       : Boolean;
    Deleting       : Boolean;
    OldAlign       : TAlign;
    OldAnchors     : TAnchors;
    OldBounds      : TRect;
    OldDesignState : Boolean;
    OldDragMode    : TDragMode;
    OldGrid        : Boolean;
    OldDblClick    : TNotifyEvent;
    SavedEvents    : TTreeEvents;
    Selecting      : Boolean;
    OldParent      : TWinControl;
    OldPopup       : TPopupMenu;
    OldDesigning   : Boolean;
    OldZoom        : Boolean;
    OldPanning     : TPanningMode;
    OldVisible     : Boolean;
    OldCursorPos   : TPoint;

    ComingFromDoubleClick : Boolean;
    Function AddNewRoot:TTreeNodeShape;
    Procedure CheckPanelNodes;
    Procedure CheckPanelToolBar;
    Procedure CheckPanelTools;
    Procedure CheckSaveDialogFilter;
    procedure ComboFontSizeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    Procedure CreateNewTree;
    Procedure DoLoadTreeImage;
    Procedure DoZoom(Value:Integer);
    procedure EditConnectionPage(NumPage:Integer);
    procedure EnablePageControls;
    procedure NodeTreeDragDrop(Sender:TCustomTree; Dragged,Parent:TTreeNodeShape);
    Procedure UpdateNodeTree;
    Function GetFontAttribute:TFontStyles;
    Function GetFontAlign:THorizTextAlign;
    Function GetFontSize:Integer;
    Function GetNodeTreeShape(ANode:TTreeNodeShape):TTreeNodeShape;
    Procedure MainSetCaption;
    procedure NodeTreeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    Function NodeTreeText(ANode:TTreeNodeShape):String;
    Procedure RefreshStatusBar;
    procedure ReopenFile(Const FileName:String);
    Procedure ResetNodeTreeSelected;
    Procedure SaveOldTreeSettings;
    Function SelectedBorder:TTreePen;
    Function SelectedElement:TCustomTreeElement;
    procedure SetPageControls;
    Procedure SetTreeProperties;
    Procedure SetTreeSettings;
    procedure SpeedClick(Sender: TObject);
    procedure SpeedPolygonClick(Sender: TObject);
    Function TeeEditColor(Var Color:TColor):Boolean;

    { Tree events }
    procedure TheTreeAfterDraw(Sender: TObject);
    procedure TheTreeDeletedShapes(Sender: TObject);
    procedure TheTreeSelectShape(Sender: TTreeNodeShape);
    procedure TheTreeUnSelectShape(Sender: TTreeNodeShape);
    procedure TheTreeSelectConnection(Sender: TTreeConnection);
    procedure TheTreeUnSelectConnection(Sender: TTreeConnection);
    Procedure TheTreeMovingShape(Sender: TTreeNodeShape; Var DeltaX,DeltaY:Integer);
    procedure TheTreeMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure TheTreeMouseUp(Sender: TObject; Button: TMouseButton;
              Shift: TShiftState; X, Y: Integer);
    procedure TheTreeNewPolygon( Sender: TCustomTree; APolygon:TPolygonShape);
    Procedure TheTreeResizingShape( Sender: TTreeNodeShape;
                                    ACorner: TTreeShapeHandle; Var DeltaX,DeltaY:Integer);
    procedure TheTreeStopEditing(Sender: TTreeNodeShape);
    procedure TheTreeClickConnection(Sender: TTreeConnection;
              Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure TheTreeDblClickConnection(Sender: TTreeConnection;
              Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure TheTreeDblClickShape(Sender: TTreeNodeShape;
              Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure TheTreeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TheTreeOnZoomedArea(Const R:TRect);
    procedure TheTreeOnZoom(Sender:TObject);

    procedure ChangeZoom(Value:Integer);
    Procedure RefreshZoomLabel;
    Procedure ChangeStyle(AStyle:TTreeShapeStyle);
    procedure SpeedDouble(Sender: TObject);
    procedure AddNewShape(AClass:PTreeTagShape; Const R:TRect);
    Procedure InternalAddShape( AGroup:Integer;
                                Const AName:String;
                                AClass:TTreeNodeShapeClass;
                                UseStyle:Boolean;
                                AStyle:TTreeShapeStyle);
    Function GetToolBarShape:PTreeTagShape;
    Procedure InternalAddCustomShape( Const AGroup:String;
                                      Const AName:String;
                                      AClass:TTreeNodeShapeClass);
    Procedure TryPopup(ATree:TCustomTree; x,y:Integer);

    procedure ChangeAutoSize(Sender: TTreeNodeShape);
    Function ChangeBevel(ACombo:TComboBox):TPanelBevel;
    procedure ChangeBorderWidth(Sender: TTreeNodeShape);
    procedure ChangeClipText(Sender: TTreeNodeShape);
    procedure ChangeClipText2(Sender: TTreeNodeShape);
    procedure ChangeFontColor(Sender: TTreenodeShape);
    procedure ChangePointStyle(AStyle:TConnectionPointStyle);
    procedure ChangeFont(Sender: TTreeNodeShape);
    procedure ChangeFontAttrib(Sender: TTreeNodeShape);
    procedure ChangeFontSize(Sender: TTreeNodeShape);
    procedure ChangeFontAlign(Sender: TTreeNodeShape);
    procedure ChangeGradient(Sender: TTreeNodeShape);
    procedure ChangeImageIndex(Sender: TTreeNodeShape);
    procedure ChangeInterChar(Sender: TTreeNodeShape);
    procedure ChangeTransparent(Sender: TTreeNodeShape);
    procedure DoAlignToGrid(Sender: TTreeNodeShape);
    procedure DoBringtoFront(Sender: TTreeNodeShape);
    procedure DoPrune(Sender: TTreeNodeShape);
    procedure DoSendToBack(Sender: TTreeNodeShape);

    Procedure DoSelection(Node:TTreeNodeShape; Select:Boolean);
    Procedure DoSetOutLine(Sender:TTreeNodeShape);
    Procedure DoEnableControls(AContainer:TWinControl; IsEnable:Boolean);
    Procedure SelectExpandNode(Node:TTreeNodeShape; Select:Boolean);
    Procedure SetBevelCombo(ABevel:TPanelBevel; ACombo:TComboBox);
    Procedure SetBorderControls;
    Procedure SetFontControls;
    procedure SetOtherControls;
    procedure SetToolBars;
    Procedure RefreshRulers;
  protected
    CaptionFormat : String;
    CurrentFile   : String;
    FModified     : Boolean;
    FSetting      : Boolean;
    TreeUndo      : TTreeUndo;

    Function CheckSave:Boolean;
    Procedure DoSaveTree;
    procedure DoTranslate;
    Procedure FillNodeTree;
    Procedure InternalSaveTree;
    procedure LoadTree(const AFileName: String);
    procedure LoadTreeProc(Reader:TReader; Stream:TStream); dynamic;
    Procedure ResetTree;
    Procedure SetInspectorProperties;
    Procedure SetNewTreeSettings; dynamic;
    Procedure TeeModified(YesNo:Boolean=True);
    class function TeeTreeClass: TTreeClass; virtual;
    Procedure WriteTreeToStream(AStream:TStream); dynamic;
  public
    { Public declarations }
    TheTree : TCustomTree;
    PersistOptions : Boolean;

    Procedure RegisterTreeShape(AGroup:Integer;
                               Const AName:String;
                               AStyle:TTreeShapeStyle);
    Procedure LoadEditorParameters; dynamic;
    Procedure SaveEditorParameters; dynamic;
    procedure StopConnecting;
  end;

  TTreeNotifyEvent=procedure(Sender:TTreeEditor);

  TTreeEditWindow=( teInspector,
                    teNodeTree,
                    teToolbar,
                    teToolShapes,
                    teEditors,
                    teFont,
                    teFormat,
                    teRulers,
                    teStatus,
                    teModeTabs,
                    teMainMenu
                   );

  TTreeEditWindows=set of TTreeEditWindow;

  { Non-visual component to invoke the Tree Editor }
  TTreeEdit=class(TCustomTreeLink)
  private
    { Private declarations }
    FHide      : TTreeEditWindows;
    FMaximized : Boolean;
    FPersist   : Boolean;
    FPosition  : TPosition;
    FTitle     : String;
    FOnClose   : TNotifyEvent;
  protected
    { Protected declarations }
  public
    { Public declarations }
    Constructor Create(AOwner:TComponent); override;

    Procedure Execute; virtual;
  published
    { Published declarations }
    property Hide:TTreeEditWindows read FHide write FHide default [teEditors];
    property Maximized:Boolean read FMaximized write FMaximized default False;
    property PersistOptions:Boolean read FPersist write FPersist default False;
    property Position:TPosition read FPosition write FPosition default poDefault;
    property Title:String read FTitle write FTitle;    
    { events }
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
  end;

  TTreeEditorPanel=class(TCustomPanelTreeLink)
  private
    FEditor : TTreeEditor;
    FHide   : TTreeEditWindows;
    Procedure CreateEditor;
    function GetEditor: TTreeEditor;
    Procedure SetHide(Value:TTreeEditWindows);
  protected
    Procedure Loaded; override;
    procedure SetTree(const Value: TCustomTree); override;
  public
    Constructor Create(AOwner:TComponent); override;
    Destructor Destroy; override;

    Procedure PreviewMode;
    property Editor:TTreeEditor read GetEditor;
  published
    property Align;
    property Anchors;
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BorderStyle;
    property BorderWidth;
    property Color;
    property Enabled;
    property TabOrder;
    property TabStop;
    property HideWindows:TTreeEditWindows read FHide write SetHide default [teEditors];
    property Tree;
  end;

{ Shows the Tree EDITOR dialog }
Procedure EditTree(AOwner:TComponent; ATree:TCustomTree);

{ Shows the Tree EDITOR dialog without about box}
Procedure EditTreeNoAbout(AOwner:TComponent; ATree:TCustomTree);

{ Shows the Tree EDITOR dialog and calls AEvent }
Procedure EditTreeEvent(AOwner:TComponent; ATree:TCustomTree;
                        AEvent:TTreeNotifyEvent);

{ Shows the Tree EXPORT dialog }
Procedure ShowTreeExport(AOwner:TComponent; ATree:TCustomTree);

{ Shows the Tree PRINT PREVIEW dialog }
procedure TreePreview(AOwner:TComponent; Tree:TCustomTree; PrintPanel:Boolean=False);

Procedure LoadTreeChildsFromFile( ANode:TTreeNodeShape; Const AName:String);

{ Shows the About-Box dialog... }
Procedure TeeShowTreeAbout(const BuildNumber:String);

{ internal }
Procedure TreeLogoSetPicture(APicture:TPicture);

{ for help support in editor }
Function GetTeeTreeHelpFile:String;
Function GetTeeTreeUserHelpFile:String;

Procedure CreateColorBitmap(Item: TMenuItem; AColor:TColor);

implementation

{$IFNDEF LCL}
{$R *.DFM}
{$ELSE}
{$R *.lfm}
{$ENDIF}

Uses
  TreeConst, TeePrevi, TreeExport, TeeExport, TeeBrushDlg, TeeConst, TeeEdiGrad,
  TeeShadowEditor, TreeShEd, TreeCoEd, TreeTeEd, TypInfo, Registry, Printers,
  TeeTranslate, TeeAbout, TeeEdiFont;

{$R TreeLogo.res}

const TeeTreeRecentKey=TeeTreeKey+'\RecentFiles';

      stPanelName=0;
      stPanelText=1;
      stPanelCoords=2;
      stPanelPage=3;
      stPanelModified=4;
      stPanelCaps=5;
      stPanelNum=6;
      stPanelScr=7;

      TeeGDIPlusCanvasName='TGDIPlusCanvas';

// Returns Help File path from Windows Registry.
Function GetRegistryHelpPath(Const HelpFile:String):String;
Const WindowsHelp='SOFTWARE\Microsoft\Windows\Help';
begin
  result:='';

  With TRegistry.Create do
  try
    RootKey:=HKEY_LOCAL_MACHINE;

    if OpenKeyReadOnly(WindowsHelp) then
       result:=ReadString(HelpFile)+'\'+HelpFile;
  finally
    Free;
  end;
end;

// Sets TeeTree logo image in APicture parameter.
Procedure TreeLogoSetPicture(APicture:TPicture);
begin
  APicture.Bitmap.LoadFromResourceName(HInstance,'TREELOGOBMP');
end;

// Show TeeTree About... box dialog.
Procedure TeeShowTreeAbout(const BuildNumber:String);
var tmp : TTeeAboutForm;
begin
  tmp:=TTeeAboutForm.Create(nil);
  with tmp do
  try
    LabelVersion.Caption:=TreeMsg_TeeTree+' '+BuildNumber;
    Caption:=Format(TreeMsg_About,[TreeMsg_TeeTree]);

    Image1.Picture:=nil;
    Image1.Transparent:=False;
    Image1.AutoSize:=False;
    Image1.Center:=True;
    TreeLogoSetPicture(Image1.Picture);

    TeeTranslateControl(tmp);
    ShowModal;
  finally
    Free;
  end;
end;

// Show TeeTree Print Preview dialog.
procedure TreePreview(AOwner:TComponent; Tree:TCustomTree; PrintPanel:Boolean=False);
var OldPrintTeePanel : Boolean;
    OldChange        : Boolean;
    OldPage          : Integer;
begin
  OldPrintTeePanel:=PrintTeePanel;
  PrintTeePanel:=PrintPanel;
  OldChange:=TeeChangePaperOrientation;
  OldPage := Tree.Page.Page;

  TeeChangePaperOrientation:=False;
  try
    with TChartPreview.Create(AOwner) do
    try
      PageNavigatorClass:=TTreePageNavigator;

      TeePreviewPanel1.Panel:=Tree;

      Tree.Page.Refresh;

      ShowModal;
    finally
      Free;
      Tree.Page.Page := OldPage;
      Tree.Invalidate;
    end;
  finally
    TeeChangePaperOrientation:=OldChange;
    PrintTeePanel:=OldPrintTeePanel;
  end;
end;

// Show the TeeTree Export dialog.
Procedure ShowTreeExport(AOwner:TComponent; ATree:TCustomTree);
begin
  With TTreeExportForm.Create(AOwner) do
  try
    NativeFilter:=TeeMsg_TreeFiles;
    NativeExtension:=TreeMsg_TeeExtension;
    ExportPanel:=ATree;
    Caption:=TreeMsg_ExportTree;
    ShowModal;
  finally
    Free;
  end;
end;

// Opens "Aname.ttr" file and loads all nodes into a temporary Tree.
// Then adds all childs to "ANode" and frees the temp Tree.
Procedure LoadTreeChildsFromFile( ANode:TTreeNodeShape; Const AName:String);
var t       : Integer;
    tmpTree : TCustomTree;
begin
  tmpTree:=TTree.Create(nil);
  try
    tmpTree.Parent:=ANode.Tree;
    LoadTreeFromFile(tmpTree,AName);
    if tmpTree.Shapes.Count>0 then
         for t:=0 to tmpTree.Shapes.Count-1 do
             ANode.AddChild(tmpTree.Shapes[t].SimpleText);
  finally
    tmpTree.Free;
  end;
end;

// Internal. Show the Tree editor dialog.
Procedure InternalEditTree(AOwner:TComponent; ATree:TCustomTree; AShowAbout:Boolean;
                           AEvent:TTreeNotifyEvent);
var tmp : TTreeEditor;
begin
  tmp:=TTreeEditor.Create(AOwner);
  try
    tmp.TheTree:=ATree;

    if not AShowAbout then
       tmp.N3.Free;

    if Assigned(AEvent) then
       AEvent(tmp);

    tmp.DoTranslate;
    tmp.ShowModal;
  finally
    tmp.Free;
  end;
end;

// Show the TeeTree editor dialog to edit ATree parameter.
Procedure EditTree(AOwner:TComponent; ATree:TCustomTree);
begin
  InternalEditTree(AOwner,ATree,True,nil);
end;

// Shows the Tree EDITOR dialog without About boxes
Procedure EditTreeNoAbout(AOwner:TComponent; ATree:TCustomTree);
begin
  InternalEditTree(AOwner,ATree,False,nil);
end;

// Shows the Tree EDITOR dialog and calls AEvent
Procedure EditTreeEvent(AOwner:TComponent; ATree:TCustomTree;
                        AEvent:TTreeNotifyEvent);
begin
  InternalEditTree(AOwner,ATree,True,AEvent);
end;

// Shows an Open Picture file dialog and then loads it into
// the Tree "BackImage" to fill then Tree background.
Procedure TTreeEditor.DoLoadTreeImage;
begin
  with PictureDialog do
  try
    if Execute then
    begin
      TheTree.BackImage.LoadFromFile(FileName);
      BBackImage.Caption:=TreeMsg_Clear;
      TeeModified;
    end;
  finally
    Free;
  end;
end;

procedure TTreeEditor.BBackImageClick(Sender: TObject);
begin
  if BBackImage.Caption=TreeMsg_Browse then
  begin
    DoLoadTreeImage;
  end
  else
  with TheTree do
  begin
    if HasBackImage then
    begin
      BackImage:=nil;
      Invalidate;
      TeeModified;
    end;
    BBackImage.Caption:=TreeMsg_Browse;
  end;
  CBImageStyle.Enabled:=TheTree.HasBackImage;
end;

type
  TTreeSpeedButton=class(TSpeedButton)
  protected
    procedure Paint; override;
  end;

  TMyCustomTreeShape=class(TTreeNodeShape);

procedure TTreeSpeedButton.Paint;
var tmpC : TTeeCanvas3D;
    tmp  : TTreeNodeShape;
    tmpR : TRect;
    tmpP : PTreeTagShape;
begin
  inherited Paint;

  tmpP:=PTreeTagShape(Tag);

  with tmpP^ do
  begin
    if AInstance=nil then
    begin
      AInstance:=AClass.Create(nil);

      with AInstance.Shadow do
      begin
        HorizSize:=2;
        VertSize:=2;
        Color:=clDkGray;
      end;

      { special trick for TPolygonShape }
      if AInstance is TPolygonShape then
         TPolygonShape(AInstance).FillSample;

      { set shape style }
      if UseStyle then
         AInstance.Style:=Style;
    end;

    tmp:=AInstance;
  end;

  tmpC:=TTeeCanvas3D.Create;
  try
    tmpC.UseBuffer:=False;
    tmpC.InitWindow(Canvas,nil,Color,False,TeeRect(0,0,Width,Height));

    tmpR:=TeeRect(4,4,Self.Width-5,Self.Height-5);
    if tmp is TTextShape then
    begin
      tmpC.Font.Style:=[fsBold];
      tmpC.Font.Size:=16;
      tmpC.TextOut(5,1,'A');
    end
    else
       TMyCustomTreeShape(tmp).DrawShapeCanvas(tmpC,tmpR);
  finally
    tmpC.Free;
  end;
end;

Procedure TTreeEditor.InternalAddCustomShape( Const AGroup:String;
                                              Const AName:String;
                                              AClass:TTreeNodeShapeClass);
var tmp  : Integer;
    t    : Integer;
    tmpP : TTabSheet;
begin
  tmp:=-1;
  with PageShapes do
  for t:=0 to PageCount-1 do
    if Uppercase(Pages[t].Caption)=Uppercase(AGroup) then
    begin
      tmp:=t;
      break;
    end;

  if tmp=-1 then
  begin
    tmpP:=TTabSheet.Create(Self);
    tmpP.Caption:=AGroup;
    tmpP.PageControl:=PageShapes;
    tmp:=PageShapes.PageCount-1;
  end;
  
  InternalAddShape(tmp,AName,AClass,False,tssRectangle);
end;

Procedure TTreeEditor.RegisterTreeShape(AGroup:Integer;
                                        Const AName:String;
                                        AStyle:TTreeShapeStyle);
begin
  InternalAddShape(AGroup,AName,nil,True,AStyle);
end;

Procedure TTreeEditor.InternalAddShape( AGroup:Integer;
                                        Const AName:String;
                                        AClass:TTreeNodeShapeClass;
                                        UseStyle:Boolean;
                                        AStyle:TTreeShapeStyle);
var ATab          : TTabSheet;
    tmp           : TSpeedButton;
    Num           : Integer;
    TagShapeStyle : PTreeTagShape;
begin
  ATab:=PageShapes.Pages[AGroup];
  Num:=ATab.ControlCount;
  if ATab=PageShapes.ActivePage then Dec(Num,2);

  tmp:=TTreeSpeedButton.Create(Self);
  with tmp do
  begin
    Parent:=ATab;
    Flat:=True;
    AllowAllUp:=False;
    GroupIndex:=1;
    Hint:=AName;
    ShowHint:=True;
    SetBounds(SpeedLink.Left+SpeedLink.Width+4+29*Num,SpeedLink.Top,SpeedLink.Width,SpeedLink.Height);

    New(TagShapeStyle);

    TagShapeStyle.UseStyle:=UseStyle;

    if UseStyle then
    begin
      TagShapeStyle.Style:=AStyle;
      TagShapeStyle.AClass:=TTreeNodeShape;
    end
    else TagShapeStyle.AClass:=AClass;

    TagShapeStyle.AInstance:=nil;

    Tag:={$IFDEF D16}NativeInt{$ELSE}Integer{$ENDIF}(TagShapeStyle);

    if (AClass=TPolygonShape) or (AClass=TPolyLineShape) then
       OnClick:=SpeedPolygonClick
    else
       OnClick:=SpeedClick;

    OnDblClick:=SpeedDouble;
  end;
end;

type TTreeAccess=class(TTree);

procedure TTreeEditor.SpeedClick(Sender: TObject);
begin
  SpeedNormalClick(Sender);
  TTreeAccess(TheTree).IZoomPriority:=not ComingFromDoubleClick;

  if ComingFromDoubleClick then
  begin
    ComingFromDoubleClick:=False;
    SpeedNormal.Down:=True;
  end;
end;

type TSpeedButtonAccess=class(TSpeedButton);

procedure TTreeEditor.SpeedDouble(Sender: TObject);
var P : PTreeTagShape;
begin
  P:=PTreeTagShape(TSpeedButton(Sender).Tag);

  if (not (P.AClass=TPolygonShape)) and
     (not (P.AClass=TPolyLineShape)) then
  begin
    AddNewShape(P,TeeRect(0,0,0,0));
    TTreeAccess(TheTree).IZoomPriority:=False;
    FillNodeTree;
    TeeModified;
    TimerButton.Enabled:=True;
    ComingFromDoubleClick:=True;
  end;
end;

Procedure TTreeEditor.RefreshZoomLabel;
begin
  Label5.Caption:=TeeStr(TrackBarZoom.Position)+'%';
end;

type TPanelAccess=class(TCustomPanel);

procedure TTreeEditor.FormShow(Sender: TObject);

  Procedure FillComboBrushes;
  var t : Integer;
  begin
    for t:=0 to TreeImagePool.Count-1 do
        ComboBrush.Add('');
  end;

var tmpLoaded : Boolean;
begin
  DisableAlign;

  tmpLoaded:=False;
  try
    if not Assigned(TheTree) then
    begin
      CreateNewTree;
      if PersistOptions then
      begin
        LoadEditorParameters;
        tmpLoaded:=True;
      end;
    end;

    SaveOldTreeSettings;
  finally
    SetTreeSettings;

    if PersistOptions and (not tmpLoaded) then LoadEditorParameters;

    PageTree.ActivePage:=TabGeneral;

    TheTree.Visible:=True;

    ShowWindow(TheTree.Handle,SW_SHOW);

    ButtonNew.Caption:='';
    ButtonOpen.Caption:='';
    ButtonPrint.Caption:='';
    ButtonPrintPreview.Caption:='';
    ButtonZoomIn.Caption:='';
    ButtonZoomOut.Caption:='';

    if IsWindowsNT then
       ComboPenStyle.Add(TeeMsg_SmallDotsPen);

    FillComboBrushes;

    FillNodeTree;

    Creating:=False;

    MainSetCaption;

    SetInspectorProperties;
    EnableAlign;
  end;
end;

procedure TTreeEditor.DoTranslate;
begin
  TeeTranslateControl(Self,[ComboFonts,CBTextKey,Zoom1]);
end;

procedure TTreeEditor.CBGridClick(Sender: TObject);
begin
  if not Creating then
  begin
    TheTree.Grid.Visible:=CBGrid.Checked;
    TeeModified;
  end;
end;

type TInternalLoadTree=class(TCustomTree);

procedure TTreeEditor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer1.Enabled:=False;

  TheTree.StopConnecting;
  TheTree.StopEditing;

  if PersistOptions then
     SaveEditorParameters; // store at Registry editor options

  // Restore Tree original properties...
  TheTree.SetDesignTime(OldDesignState);

  With TheTree do
  begin
    StopEditing;
    Selected.Clear;

    Visible      :=OldVisible;
    Align        :=OldAlign;
    Anchors      :=OldAnchors;
    Grid.Visible :=OldGrid;
    Designing    :=OldDesigning;
    AllowZoom    :=OldZoom;
    AllowPanning :=OldPanning;
    BoundsRect   :=OldBounds;;
    DragMode     :=OldDragMode;
    PopupMenu    :=OldPopup;

    { events }
    SetEvents(SavedEvents);
    OnZoomedArea:=nil;
    OnDblClick:=OldDblClick;
    Parent:=OldParent;
  end;

  // Store at Registry the list of recently opened files...
  FRecentFiles.WriteRegistry(TeeTreeRecentKey);
end;

procedure TTreeEditor.AddBrother1Click(Sender: TObject);
begin
  if TheTree.Selected.Count>0 then
  With TheTree.Selected.First do
  if Assigned(Parent) then
  begin
    with AddBrother('') do
    begin
      Assign(TheTree.Selected.First);
      Text.Clear;
      Text.Add(TreeMsg_Child+' '+TeeStr(Parent.Childs.Count));
      Selected:=True;
    end;
    Selected:=False;
    FillNodeTree;
    TeeModified;
  end;
end;

procedure TTreeEditor.AddChild1Click(Sender: TObject);
begin
  if TheTree.Selected.Count>0 then
  With TheTree.Selected.First do
  begin
    Expanded:=True;
    AddChild(TreeMsg_Child+' '+TeeStr(Childs.Count+1)).Selected:=True;
    Selected:=False;
    FillNodeTree;
    TeeModified;
  end;
end;

procedure TTreeEditor.DoBringtoFront(Sender: TTreeNodeShape);
begin
  Sender.BringToFront;
end;

// Moves selected nodes to "front"
procedure TTreeEditor.BringtoFront1Click(Sender: TObject);
begin
  TheTree.Selected.ForEach(DoBringToFront);
  TeeModified;
end;

procedure TTreeEditor.Copy1Click(Sender: TObject);
begin
  TreeClipboard.Copy(TheTree);
end;

procedure TTreeEditor.Cut1Click(Sender: TObject);
begin
  TreeClipboard.Cut(TheTree);
  FillNodeTree;
end;

procedure TTreeEditor.Delete1Click(Sender: TObject);
begin
  TheTree.Selected.Delete;
end;

procedure TTreeEditor.Edit1Click(Sender: TObject);
begin
  if TheTree.Selected.Count>0 then
  begin
    EditTreeShape(Self,TheTree.Selected.First);
    SetToolBars;
    TeeModified;
  end;
end;

procedure TTreeEditor.Paste1Click(Sender: TObject);
begin
  TreeClipboard.Paste(TheTree);
  FillNodeTree;
  TeeModified;
end;

procedure TTreeEditor.PopupNodePopup(Sender: TObject);
begin
  Paste1.Enabled:=TreeClipboard.Roots.Count>0;
  AddBrother1.Enabled:=(TheTree.Selected.Count>0) and
                       (TheTree.Selected.First.Parent<>nil);
  Copy1.Enabled:=TheTree.Selected.Count>0;

  Cut1.Enabled:=Copy1.Enabled;
  Delete1.Enabled:=Copy1.Enabled;
  Edit1.Enabled:=Copy1.Enabled;
  BringToFront1.Enabled:=Copy1.Enabled;
  SendToBack1.Enabled:=Copy1.Enabled;
  AlignToGrid1.Enabled:=Copy1.Enabled;
  Sizetogrid1.Enabled:=Copy1.Enabled;
  AddChild1.Enabled:=Copy1.Enabled;

  AddBrother1.Enabled:=Copy1.Enabled and Assigned(TheTree.Selected.First.Parent);
  Prune1.Enabled:=AddBrother1.Enabled;
  ShowNames1.Visible:=TPopupMenu(Sender).PopupComponent=NodeTree;
end;

procedure TTreeEditor.DoSendToBack(Sender: TTreeNodeShape);
begin
  Sender.SendToBack;
end;

procedure TTreeEditor.SendtoBack1Click(Sender: TObject);
begin
  TheTree.Selected.ForEach(DoSendToBack);
  TeeModified;
end;

Procedure TTreeEditor.RefreshStatusBar;
var P       : TPoint;
    tmpNode : TTreeNodeShape;
    tmpConn : TTreeConnection;
begin
  With TheTree do
  begin
    P:=GetCursorPos;

    { show at status bar the shape under the mouse }
    tmpNode:=ClickedShape(P.x,P.y);
    if Assigned(tmpNode) then
    begin
      StatusBar1.Panels[stPanelName].Text:=tmpNode.Name;
      if tmpNode.Text.Count>0 then
         StatusBar1.Panels[stPanelText].Text:=tmpNode.SimpleText
      else
         StatusBar1.Panels[stPanelText].Text:='';

      StatusBar1.Panels[stPanelCoords].Text:=
               TeeStr(tmpNode.x0)+','+TeeStr(tmpNode.y0)+' '+
               TeeStr(tmpNode.Width)+','+TeeStr(tmpNode.Height);
    end
    else
    { try with connections... }
    begin
      tmpConn:=Connections.Clicked(P.x,P.y);
      if Assigned(tmpConn) then
      begin
        StatusBar1.Panels[stPanelName].Text:=tmpConn.Name;
        StatusBar1.Panels[stPanelText].Text:='';
      end
      else
      { clear status bar }
      begin
        StatusBar1.Panels[stPanelName].Text:='';
        StatusBar1.Panels[stPanelText].Text:='';
        Canvas.Calculate2DPosition(P.X,P.Y,0);
        StatusBar1.Panels[stPanelCoords].Text:=TeeStr(P.x)+','+TeeStr(P.y);
      end;
    end;
  end;
end;

procedure TTreeEditor.TheTreeMouseMove(Sender: TObject;
              Shift: TShiftState; X, Y: Integer);
begin
  RefreshStatusBar;
end;

Procedure TTreeEditor.TryPopup(ATree:TCustomTree; x,y:Integer);
var P   : TPoint;
    tmp : TPopupMenu;
begin
  SpeedNormal.Down:=True;

  if Assigned(TheTree.Connections.Selected) then
  begin
    // Show connection popup, or connection point popup
    PopupPoint.Tag:=TheTree.Connections.Selected.Points.Clicked(x,y);

    if PopupPoint.Tag<>-1 then tmp:=PopupPoint
                          else tmp:=PopupConn
  end
  else
     tmp:=PopupNode;  // Node popup menu

  // Show menu
  tmp.PopupComponent:=ATree;
  P:=ATree.ClientToScreen(TeePoint(x,y));

  OldCursorPos := Point(X,Y);
  tmp.Popup(P.x,P.y)
end;

procedure TTreeEditor.ChangeFont(Sender: TTreeNodeShape);
begin
  Sender.Font.Name:=ComboFonts.CurrentItem;
end;

procedure TTreeEditor.ChangeFontAttrib(Sender: TTreeNodeShape);
begin
  Sender.Font.Style:=GetFontAttribute;
end;

Function TTreeEditor.GetFontSize:Integer;
begin
  with ComboFontSize do
  if ItemIndex=-1 then result:=StrToIntDef(Text,0)
                  else result:=StrToInt(Items[ItemIndex]);
end;

procedure TTreeEditor.ChangeFontSize(Sender: TTreeNodeShape);
begin
  Sender.Font.Size:=GetFontSize;
end;

procedure TTreeEditor.ChangeFontAlign(Sender: TTreeNodeShape);
begin
  Sender.HorizTextAlign:=GetFontAlign;
end;

procedure TTreeEditor.ChangeInterChar(Sender: TTreeNodeShape);
begin
  Sender.Font.InterCharSize:=UDFontInter.Position;
end;

Procedure TTreeEditor.DoSetOutLine(Sender:TTreeNodeShape);
begin
  Sender.Font.OutLine.Assign(TheTree.Selected.First.Font.OutLine);
end;

procedure TTreeEditor.TheTreeMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Button=mbRight) and
     TheTree.Designing and
     (not TheTree.Scrolled) and
     (not TheTree.CancelMouse) and
     (not TheTree.Connecting) then

        TryPopup(TheTree,x,y);
end;

procedure TTreeEditor.TheTreeClickConnection(Sender: TTreeConnection;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  TheTree.SelectConnection(Sender);
end;

procedure TTreeEditor.TheTreeDblClickShape(Sender: TTreeNodeShape;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  With TheTree do
  if Designing and (Selected.Count>0) then
  begin
    TheTree.Canvas.Calculate2DPosition(X,Y,0);

    if Selected.First.ClickedImage(x,y) then
       EditTreeShapePage(Self,TheTree.Selected.First,stImage,True)
    else
       EditTreeShape(Self,TheTree.Selected.First);

    SetToolBars;
    CancelMouse:=True; { to not expand / collapse the node... }
    TeeModified;
  end;
end;

Function TTreeEditor.GetToolBarShape:PTreeTagShape;
var t : Integer;
begin
  result:=nil;

  With PageShapes.ActivePage do
  for t:=0 to ControlCount-1 do
  if Controls[t] is TSpeedButton then
  With Controls[t] as TSpeedButton do
  if Down and (Tag>=0) then
  begin
    result:=PTreeTagShape(Tag);
    break;
  end;
end;

procedure TTreeEditor.AddNewShape(AClass:PTreeTagShape; Const R:TRect);
var tmpShape : TTreeNodeShape;
begin
  if OldDesignState then
     TheTree.SetDesignTime(True);

  try
    tmpShape:=TheTree.AddShapeClass(R.Left,R.Top,'',nil,AClass.AClass);
  finally
    if OldDesignState then
       TheTree.SetDesignTime(False);
  end;

  With tmpShape do
  begin
    if R.Left<>0 then X0:=R.Left;
    if R.Top<>0 then  Y0:=R.Top;
    if AClass.UseStyle then Style:=AClass.Style;
    if ((R.Right-R.Left)>0) and ((R.Bottom-R.Top)>0) then
    begin
      X1:=R.Right;
      Y1:=R.Bottom;
      AutoSize:=False;
    end{
     else begin
       X1:=X0;
       Y1:=Y0;
     end};
    if Text.Count=0 then Text.Add(Name);

    Case Style of
      tssTriangleTop   : VertTextAlign  :=vtaBottom;
      tssTriangleBottom: VertTextAlign  :=vtaTop;
      tssTriangleLeft  : HorizTextAlign :=htaRight;
      tssTriangleRight : HorizTextAlign :=htaLeft;
    end;

    if not (tmpShape is TImageShape) then
       ImageIndex:=tiNone;

    Tree.Selected.Clear;
    Selected:=True;
    Expanded:=True;
  end;
end;

procedure TTreeEditor.TheTreeOnZoomedArea(Const R:TRect);
var tmp : PTreeTagShape;
begin
  tmp:=GetToolBarShape;

  if Assigned(tmp) then
  begin
    AddNewShape(tmp,R);
    TheTree.CancelMouse:=True;
    FillNodeTree;
    TeeModified;
    SpeedNormal.Down:=True;
    TTreeAccess(TheTree).IZoomPriority:=False;
  end;
end;

procedure TTreeEditor.CBImageStyleChange(Sender: TObject);
begin
  TheTree.BackImageMode:=TTeeBackImageMode(CBImageStyle.ItemIndex);
  TeeModified;
end;

Function TTreeEditor.AddNewRoot:TTreeNodeShape;
begin
  result:=TheTree.AddRoot(TreeMsg_Root+' '+TeeStr(TheTree.Roots.Count+1));
end;

procedure TTreeEditor.AddnewRoot2Click(Sender: TObject);
begin
  TheTree.Selected.Clear;
  AddNewRoot.Selected:=True;
  FillNodeTree;
  TeeModified;
end;

type
  TTreeRegistry=class(TRegistry)
  public
    Procedure ReadVisible(Const AKey:String; AControl:TWinControl);
  end;

Procedure TTreeRegistry.ReadVisible(Const AKey:String; AControl:TWinControl);
begin
  if ValueExists(AKey) then AControl.Visible:=ReadBool(AKey);
end;

Procedure TTreeEditor.LoadEditorParameters;
var l,t,w,h,s:Integer;
begin
  With TTreeRegistry.Create do
  try
    if OpenKeyReadOnly(TeeTreeKey) then
    begin
      if ValueExists('Left') then
      begin
        l:=ReadInteger('Left');
        t:=ReadInteger('Top');
        w:=ReadInteger('Width');
        h:=ReadInteger('Height');

        Self.SetBounds(l,t,w,h);
      end;

      Self.WindowState:=wsNormal;

      if ValueExists('State') then
      begin
        s:=ReadInteger('State');
        Self.WindowState:=TWindowState(s);

        // Do not allow minimized:
        if Self.WindowState=wsMinimized then Self.WindowState:=wsNormal;
      end;

      ReadVisible('Tabs',PageTree);
      ReadVisible('ShapeTabs',PageShapes);
      ReadVisible('Status',StatusBar1);
      ReadVisible('FontToolBar',PanelFont);
      ReadVisible('BorderToolBar',PanelShape);
      ReadVisible('ToolBar',PanelToolButtons);

      ReadVisible('Rulers',HorizRuler);
      VertRuler.Visible:=HorizRuler.Visible;

      if ValueExists('RulersUnits') then
      begin
        HorizRuler.ShowUnits:=ReadBool('RulersUnits');
        VertRuler.ShowUnits:=HorizRuler.ShowUnits;
      end;

      if ValueExists('NodeTreeWidth') then
         PanelNodes.Width:=ReadInteger('NodeTreeWidth');

      if ValueExists('NodeTree') then
         if ReadBool('NodeTree')<>NodeTheTree.Checked then
            NodeTheTreeClick(Self);

      if ValueExists('NodeTreeLeft') then
         if not ReadBool('NodeTreeLeft') then
            AlignToLeft1Click(Self);
    end;
  finally
    Free;
  end;
end;

Procedure TTreeEditor.SaveEditorParameters;
begin
  With TRegistry.Create do
  try
    if OpenKey(TeeTreeKey,True) then
    begin
      if Self.WindowState=wsNormal then
      begin
        WriteInteger('Left',Self.Left);
        WriteInteger('Top',Self.Top);
        WriteInteger('Width',Self.Width);
        WriteInteger('Height',Self.Height);
      end;

      WriteInteger('State',Ord(Self.WindowState));
      WriteBool('Tabs',PageTree.Visible);
      WriteBool('ShapeTabs',PageShapes.Visible);
      WriteBool('NodeTree',PanelNodesInt.Visible);
      WriteBool('Status',StatusBar1.Visible);
      WriteBool('FontToolBar',PanelFont.Visible);
      WriteBool('BorderToolBar',PanelShape.Visible);
      WriteBool('ToolBar',PanelToolButtons.Visible);
      WriteBool('Rulers',HorizRuler.Visible);
      WriteBool('RulersUnits',HorizRuler.ShowUnits);

      WriteInteger('NodeTreeWidth',PanelNodes.Width);
      WriteBool('NodeTreeLeft',PanelNodes.Align=alLeft);
    end;
  finally
    Free;
  end;
end;

procedure TTreeEditor.DoPrune(Sender: TTreeNodeShape);
begin
  Sender.Parent:=nil;
end;

procedure TTreeEditor.Prune1Click(Sender: TObject);
begin
  TheTree.Selected.ForEach(DoPrune);
  FillNodeTree;
  TeeModified;
end;

procedure TTreeEditor.Button6Click(Sender: TObject);
begin
  if TBrushDialog.Edit(Self,TheTree.CrossBox.Brush) then
     TeeModified;
end;

procedure TTreeEditor.Edit2Change(Sender: TObject);
begin
  if not Creating then
  begin
    TheTree.CrossBox.Size:=UDCrossSize.Position;
    TeeModified;
  end;
end;

const
  ShortCuts: array[0..108] of TShortCut = (
    scNone,
    Byte('A') or scCtrl,
    Byte('B') or scCtrl,
    Byte('C') or scCtrl,
    Byte('D') or scCtrl,
    Byte('E') or scCtrl,
    Byte('F') or scCtrl,
    Byte('G') or scCtrl,
    Byte('H') or scCtrl,
    Byte('I') or scCtrl,
    Byte('J') or scCtrl,
    Byte('K') or scCtrl,
    Byte('L') or scCtrl,
    Byte('M') or scCtrl,
    Byte('N') or scCtrl,
    Byte('O') or scCtrl,
    Byte('P') or scCtrl,
    Byte('Q') or scCtrl,
    Byte('R') or scCtrl,
    Byte('S') or scCtrl,
    Byte('T') or scCtrl,
    Byte('U') or scCtrl,
    Byte('V') or scCtrl,
    Byte('W') or scCtrl,
    Byte('X') or scCtrl,
    Byte('Y') or scCtrl,
    Byte('Z') or scCtrl,
    Byte('A') or scCtrl or scAlt,
    Byte('B') or scCtrl or scAlt,
    Byte('C') or scCtrl or scAlt,
    Byte('D') or scCtrl or scAlt,
    Byte('E') or scCtrl or scAlt,
    Byte('F') or scCtrl or scAlt,
    Byte('G') or scCtrl or scAlt,
    Byte('H') or scCtrl or scAlt,
    Byte('I') or scCtrl or scAlt,
    Byte('J') or scCtrl or scAlt,
    Byte('K') or scCtrl or scAlt,
    Byte('L') or scCtrl or scAlt,
    Byte('M') or scCtrl or scAlt,
    Byte('N') or scCtrl or scAlt,
    Byte('O') or scCtrl or scAlt,
    Byte('P') or scCtrl or scAlt,
    Byte('Q') or scCtrl or scAlt,
    Byte('R') or scCtrl or scAlt,
    Byte('S') or scCtrl or scAlt,
    Byte('T') or scCtrl or scAlt,
    Byte('U') or scCtrl or scAlt,
    Byte('V') or scCtrl or scAlt,
    Byte('W') or scCtrl or scAlt,
    Byte('X') or scCtrl or scAlt,
    Byte('Y') or scCtrl or scAlt,
    Byte('Z') or scCtrl or scAlt,
    VK_F1,
    VK_F2,
    VK_F3,
    VK_F4,
    VK_F5,
    VK_F6,
    VK_F7,
    VK_F8,
    VK_F9,
    VK_F10,
    VK_F11,
    VK_F12,
    VK_F1 or scCtrl,
    VK_F2 or scCtrl,
    VK_F3 or scCtrl,
    VK_F4 or scCtrl,
    VK_F5 or scCtrl,
    VK_F6 or scCtrl,
    VK_F7 or scCtrl,
    VK_F8 or scCtrl,
    VK_F9 or scCtrl,
    VK_F10 or scCtrl,
    VK_F11 or scCtrl,
    VK_F12 or scCtrl,
    VK_F1 or scShift,
    VK_F2 or scShift,
    VK_F3 or scShift,
    VK_F4 or scShift,
    VK_F5 or scShift,
    VK_F6 or scShift,
    VK_F7 or scShift,
    VK_F8 or scShift,
    VK_F9 or scShift,
    VK_F10 or scShift,
    VK_F11 or scShift,
    VK_F12 or scShift,
    VK_F1 or scShift or scCtrl,
    VK_F2 or scShift or scCtrl,
    VK_F3 or scShift or scCtrl,
    VK_F4 or scShift or scCtrl,
    VK_F5 or scShift or scCtrl,
    VK_F6 or scShift or scCtrl,
    VK_F7 or scShift or scCtrl,
    VK_F8 or scShift or scCtrl,
    VK_F9 or scShift or scCtrl,
    VK_F10 or scShift or scCtrl,
    VK_F11 or scShift or scCtrl,
    VK_F12 or scShift or scCtrl,
    VK_INSERT,
    VK_INSERT or scShift,
    VK_INSERT or scCtrl,
    VK_DELETE,
    VK_DELETE or scShift,
    VK_DELETE or scCtrl,
    VK_BACK or scAlt,
    VK_BACK or scShift or scAlt);

procedure TTreeEditor.FormCreate(Sender: TObject);
var t : Integer;
begin
  with TabControl1.Tabs do
  begin
    Add('Design');
    Add('Preview');
  end;

  with CBTextKey do
  begin
    Clear;

    for t:=1 to High(ShortCuts) do
        Add(ShortCutToText(ShortCuts[t]));
  end;

  Edit1.Default:=True;
  Edit6.Default:=True;

  TreeUndo:=TTreeUndo.Create(TTreeUndoItem);

  PersistOptions:=True;
  CaptionFormat:=TeeMsg_Editing;
  NodeTree.DragAndDrop.Automatic:=True;

  NodeTree.OnKeyDown:=NodeTreeKeyDown;
  ComboFontSize.OnKeyDown:=ComboFontSizeKeyDown;
  
  MainMenu1.Images:=ImageList1;

  PageShapes.TabIndex:=0;

  TeeInspector1.Color:=clWhite;
  TeeInspector1.FixedRows:=0;
  TeeInspector1.DoubleBuffered:=True;
  
  PanelFont.DoubleBuffered:=True;
  PanelShape.DoubleBuffered:=True;

  Creating:=True;
  Selecting:=False;
  Deleting:=False;

  { create the "recent files" object }
  FRecentFiles:=TRecentFiles.Create;
  with FRecentFiles do
  begin
    MenuItem:=Reopen1;
    MenuSep:=N14;
    ReOpenFileEvent:=Self.ReOpenFile;
    ReadRegistry(TeeTreeRecentKey);
  end;

  { prepare Helpfile }
  HelpFile:=GetTeeTreeHelpFile;

  { create special clipboard }
  TreeClipboard:=TTreeClipboard.Create(Self);
  TreeClipboard.Name:='TreeClipboard';

  { load bitmaps for font toolbar }
  ImageList1.GetBitmap(14,FontBold.Glyph);
  ImageList1.GetBitmap(15,FontItalic.Glyph);
  ImageList1.GetBitmap(16,FontUnderline.Glyph);
  ImageList1.GetBitmap(17,FontStrike.Glyph);
  ImageList1.GetBitmap(18,FontLeftAlign.Glyph);
  ImageList1.GetBitmap(19,FontCenterAlign.Glyph);
  ImageList1.GetBitmap(20,FontRightAlign.Glyph);

  { get installed font names }
  ComboFonts.Items:=Screen.Fonts;

  { register basic shape styles }
  RegisterTreeShape(sgStandard,'Rectangle',tssRectangle);
  RegisterTreeShape(sgStandard,'Ellipse',tssCircle);
  RegisterTreeShape(sgStandard,'Triangle Top',tssTriangleTop);
  RegisterTreeShape(sgStandard,'Triangle Bottom',tssTriangleBottom);
  RegisterTreeShape(sgStandard,'Triangle Left',tssTriangleLeft);
  RegisterTreeShape(sgStandard,'Triangle Right',tssTriangleRight);
  RegisterTreeShape(sgStandard,'Line',tssLine);
  RegisterTreeShape(sgStandard,'Horiz.Line',tssHorizLine);
  RegisterTreeShape(sgStandard,'Vert.Line',tssVertLine);
  RegisterTreeShape(sgStandard,'Inverted Line',tssInvertLine);
  RegisterTreeShape(sgStandard,'Diamond',tssDiamond);
  RegisterTreeShape(sgStandard,'Round Rectangle',tssRoundRectangle);
  RegisterTreeShape(sgStandard,'Chamfer',tssChamfer);

  { register custom installed shapes }
  TreeForEachCustomShape(InternalAddCustomShape);

  { speed optimization for tree of nodes }
  NodeTree.NoOwnerShapes:=True;
  NodeTree.AssignParent:=False;
  NodeTree.Page.UsePrinter:=False;
  NodeTree.Canvas:=TTeeCanvas3D.Create;

  { Event for drag-drop at Nodes Tree }
  NodeTree.OnDragDropShape:=NodeTreeDragDrop;
end;

// When a drag-drop is finished on the node-tree, change the
// parentship of the dragged node on the edited Tree.
procedure TTreeEditor.NodeTreeDragDrop( Sender:TCustomTree;
                                        Dragged,Parent:TTreeNodeShape);
var tmp : TTreeNodeShape;
begin
  if Assigned(Parent) then tmp:=TTreeNodeShape(Parent.Tag)
                      else tmp:=nil;
  if Assigned(tmp) and TTreeNodeShape(Dragged.Tag).Visible then
     tmp.Expanded:=True;

  TTreeNodeShape(Dragged.Tag).Parent:=tmp;

  TeeModified;
end;

procedure TTreeEditor.DoAlignToGrid(Sender: TTreeNodeShape);
var pX  : Integer;
    pY  : Integer;
    tmp : Integer;
begin
  tmp:=TheTree.Grid.Step;
  With Sender do
  begin
    pX:=X0 mod tmp;
    if pX>0 then
       if pX>(tmp div 2) then pX:=-(tmp-pX);

    pY:=Y0 mod tmp;
    if pY>0 then
       if pY>(tmp div 2) then pY:=-(tmp-pY);

    MoveRelative(-pX,-pY,False);
  end;
end;

procedure TTreeEditor.Aligntogrid1Click(Sender: TObject);
begin
  TheTree.Selected.ForEach(DoAlignToGrid);
  RefreshStatusBar;
  TeeModified;
end;

procedure TTreeEditor.SpeedButton1Click(Sender: TObject);
var t    : Integer;
    tmp  : Integer;
    tmpW : Integer;
begin
  With TheTree do
  if Selected.Count>1 then
  begin
    tmp:=Selected.First.X0;
    for t:=1 to Selected.Count-1 do
    With Selected[t] do
    begin
      tmpW:=X1-X0;
      X0:=tmp;
      X1:=X0+tmpW;
    end;
    TeeModified;
  end;
end;

procedure TTreeEditor.SpeedButton2Click(Sender: TObject);
var t    : Integer;
    tmp  : Integer;
    tmpW : Integer;
begin
  With TheTree do
  if Selected.Count>1 then
  begin
    tmp:=Selected.First.X1;
    for t:=1 to Selected.Count-1 do
    With Selected[t] do
    begin
      tmpW:=X1-X0;
      X1:=tmp;
      X0:=X1-tmpW;
    end;
    TeeModified;
  end;
end;

procedure TTreeEditor.SpeedButton3Click(Sender: TObject);
var t,
    tmp,
    tmpH : Integer;
begin
  With TheTree do
  if Selected.Count>1 then
  begin
    tmp:=Selected.First.Y0;
    for t:=1 to Selected.Count-1 do
    With Selected[t] do
    begin
      tmpH:=Y1-Y0;
      Y0:=tmp;
      Y1:=Y0+tmpH;
    end;
    TeeModified;
  end;
end;

procedure TTreeEditor.SpeedButton4Click(Sender: TObject);
var t,
    tmp,
    tmpH : Integer;
begin
  With TheTree do
  if Selected.Count>1 then
  begin
    tmp:=Selected.First.Y1;
    for t:=1 to Selected.Count-1 do
    With Selected[t] do
    begin
      tmpH:=Y1-Y0;
      Y1:=tmp;
      Y0:=Y1-tmpH;
    end;
    TeeModified;
  end;
end;

procedure TTreeEditor.CBAllowScrollChange(Sender: TObject);
begin
  TheTree.AllowPanning:=TPanningMode(CBAllowScroll.ItemIndex);
  OldPanning:=TheTree.AllowPanning;
  TeeModified;
end;

procedure TTreeEditor.CBZoomAnimatedClick(Sender: TObject);
begin
  TheTree.AnimatedZoom:=CBZoomAnimated.Checked;
  Edit3.Enabled:=TheTree.AnimatedZoom;
  TeeModified;
end;

procedure TTreeEditor.CBAllowZoomClick(Sender: TObject);
begin
  if not FSetting then
  begin
    TheTree.AllowZoom:=CBAllowZoom.Checked;
    OldZoom:=TheTree.AllowZoom;
    TeeModified;
  end;
end;

procedure TTreeEditor.CBSelectedColorDefClick(Sender: TObject);
begin
  if (not FSetting) and CBSelectedColorDef.Checked then
  begin
    TheTree.Selected.Color:=clHighLight;
    BSelectedColor.Repaint;
    TeeModified;
  end;
end;

procedure TTreeEditor.CBSelectedTextDefClick(Sender: TObject);
begin
  if (not FSetting) and CBSelectedTextDef.Checked then
  begin
    TheTree.Selected.TextColor:=clHighLightText;
    BSelectedText.Repaint;
    TeeModified;
  end;
end;

procedure TTreeEditor.CBHorizVisibleClick(Sender: TObject);
begin
  if not Creating then
  begin
    TheTree.HorzScrollBar.Visible:=CBHorizVisible.Checked;
    TeeModified;
  end;
end;

procedure TTreeEditor.CBVertVisibleClick(Sender: TObject);
begin
  if not Creating then
  begin
    TheTree.VertScrollBar.Visible:=CBVertVisible.Checked;
    TeeModified;
  end;
end;

procedure TTreeEditor.AboutTeeTree101Click(Sender: TObject);
begin
  TeeShowTreeAbout('');
end;

procedure TTreeEditor.TeeTree10HomePage1Click(Sender: TObject);
begin
  TeeGotoURL(Handle,TreeMsg_SteemaWWW+'/TheTree');
end;

procedure TTreeEditor.wwwSteemacom1Click(Sender: TObject);
begin
  TeeGotoURL(Handle,TreeMsg_SteemaWWW);
end;

procedure TTreeEditor.New1Click(Sender: TObject);
var tmp : Boolean;
begin { create a new Tree }
  tmp:=False;
  FormCloseQuery(Self,tmp);
  if tmp then
  begin
    ResetTree;
    SetInspectorProperties;
  end;
end;

procedure TTreeEditor.Printpreview1Click(Sender: TObject);
var tmpOld : Boolean;
begin
  tmpOld:=TheTree.Grid.Visible;
  TheTree.Grid.Visible:=False;
  try
    TreePreview(Self,TheTree,CBPrintPanel.Checked);
    if TheTree.Page.UsePrinter then SetPageControls;
  finally
    TheTree.Grid.Visible:=tmpOld;
  end;
end;

procedure TTreeEditor.Close1Click(Sender: TObject);
begin
  Close;
end;

procedure TTreeEditor.Print1Click(Sender: TObject);
begin
  TreePageNavigator1.Print;
end;

procedure TTreeEditor.Saveas1Click(Sender: TObject);
var tmp     : String;
    tmpFile : String;
    t       : Integer;
    tmpExp  : TTeeExportFormat;
begin { show the Save As... dialog }

  CheckSaveDialogFilter;

  if CurrentFile='' then SaveDialog1.FileName:=TreeMsg_Tree1
                    else SaveDialog1.FileName:=CurrentFile;
  if SaveDialog1.Execute and (SaveDialog1.FileName<>'') then
  begin
    tmpFile:=SaveDialog1.FileName;
    if tmpFile<>'' then
    begin
      tmp:=UpperCase(Trim(ExtractFileExt(tmpFile)));
      if (tmp<>'') and (Copy(tmp,1,1)='.') then
         Delete(tmp,1,1);

      // If saving to native *.ttr file:
      if (tmp='') or (tmp=UpperCase(TreeMsg_TeeExtension)) then // *.ttr
      begin
        CurrentFile:=tmpFile;
        DoSaveTree;
      end
      else
      begin // save as other formats: BMP, WMF, PNG, GIF, etc.
        for t:=0 to TeeExportFormats.Count-1 do
        begin
          tmpExp:=TeeExportFormats[t].Create;
          try
            if UpperCase(tmpExp.FileExtension)=tmp then
            begin
              TheTree.Selected.Clear;
              tmpExp.Panel:=TheTree;
              tmpExp.SaveToFile(tmpFile);
              break;
            end;
          finally
            tmpExp.Free;
          end;
        end;
      end;
    end;
  end;
end;

Procedure TTreeEditor.ResetTree;
var tmpEmpty : TTree;
begin { empty the current Tree }

  CurrentFile:='';
  MainSetCaption;

  { clear trees }
  TheTree.Clear;
  NodeTree.Clear;

  { Create an empty Tree }
  tmpEmpty:=TTree.Create(nil);
  try
    { Assign empty to current }
    TheTree.Assign(tmpEmpty);
    TheTree.Cursor:=crDefault;
  finally
    tmpEmpty.Free;
  end;

  SetNewTreeSettings;

  TeeInspector1.SetProperties(nil);
end;

Function TreeCheckExtension(Const AFileName:String):String;
begin  // Append ".ttr" to filename if the extension is missing
  if ExtractFileExt(AFileName)='' then
     result:=AFileName+'.'+TreeMsg_TeeExtension
  else
     result:=AFileName;
end;

procedure TTreeEditor.LoadTreeProc(Reader:TReader; Stream:TStream);
begin
end;

procedure TTreeEditor.LoadTree(const AFileName: String);
begin { load a Tree from file, and setup several things }

  Screen.Cursor:=crHourGlass;
  try
    { first reset the Tree (empty) }
    ResetTree;

    LoadTreeFromFile(TheTree,AFileName,LoadTreeProc);

    SetTreeProperties; // Tree Editor tabs

    CurrentFile:=AFileName;

    MainSetCaption;  // Editor Form Caption

    FillNodeTree;

    { add the loaded filename to "recent files" menu }
    FRecentFiles.Add(TreeCheckExtension(AFileName));

    { Set Design mode }
    TabControl1.TabIndex:=0;
    TabControl1Change(TabControl1);

    { mark the Tree as "not modified" }
    TeeModified(False);

  finally
    Screen.Cursor:=crDefault;
  end;
end;

Function TTreeEditor.CheckSave:Boolean;

  Function CurrentFileName:String;
  begin
    result:=ExtractFileName(CurrentFile);
    if result='' then result:=TreeMsg_Tree1;
  end;

begin { ask the user if wants to Save the current Chart }
  result:=False;

  { Set modified to false if we're inside Delphi at design-time }
  if TheTree.Owner<>Self then FModified:=False;

  if not FModified then
     result:=True
  else
  Case MessageDlg(Format(TeeMsg_WantToSave,[CurrentFileName]),
                  mtConfirmation,[mbYes,mbNo,mbCancel],0) of
    mrYes   : result:=True;
    mrNo    : begin
                TeeModified(False);
                result:=True;
              end;
    mrCancel: result:=False;
  end;
end;

procedure TTreeEditor.Open1Click(Sender: TObject);
begin
  if CheckSave then
     if OpenDialog1.Execute then
        LoadTree(OpenDialog1.FileName);
end;

procedure TTreeEditor.Cut2Click(Sender: TObject);
begin
  Cut1Click(Self);
end;

procedure TTreeEditor.Copy2Click(Sender: TObject);
begin
  Copy1Click(Self);
end;

procedure TTreeEditor.Paste2Click(Sender: TObject);
begin
  Paste1Click(Self);
end;

procedure TTreeEditor.Delete2Click(Sender: TObject);
begin
  Delete1Click(Self);
end;

procedure TTreeEditor.Selectall1Click(Sender: TObject);
begin
  TheTree.Selected.SelectAll;
end;

procedure TTreeEditor.Search2Click(Sender: TObject);
Var S         : String;
    FirstTime : Boolean;
    t         : Integer;
begin
  S:='';

  if InputQuery(TreeMsg_SearchNode,TreeMsg_NodeText,S) then
  begin
    S:=UpperCase(S);
    FirstTime:=True;

    with TheTree do
    for t:=0 to Shapes.Count-1 do
    if Pos(S,UpperCase(Shapes[t].Text.Text))>0 then
    begin
      if FirstTime then
      begin
        TheTree.Selected.Clear;
        FirstTime:=False;
      end;

      Shapes[t].Selected:=True;
    end;
  end;
end;

procedure TTreeEditor.ChangeZoom(Value:Integer);
begin
  TheTree.View3DOptions.Zoom:=Value;
  TrackBarZoom.Position:=TheTree.View3DOptions.Zoom;
  UDZoom.Position:=TrackBarZoom.Position;
  RefreshZoomLabel;
end;

procedure TTreeEditor.N2001Click(Sender: TObject);
begin
  ChangeZoom(200);
end;

procedure TTreeEditor.N1001Click(Sender: TObject);
begin
  ChangeZoom(100);
end;

procedure TTreeEditor.N751Click(Sender: TObject);
begin
  ChangeZoom(75);
end;

procedure TTreeEditor.N501Click(Sender: TObject);
begin
  ChangeZoom(50);
end;

procedure TTreeEditor.N251Click(Sender: TObject);
begin
  ChangeZoom(25);
end;

procedure TTreeEditor.N151Click(Sender: TObject);
begin
  ChangeZoom(15);
end;

procedure TTreeEditor.N101Click(Sender: TObject);
begin
  ChangeZoom(10);
end;

procedure TTreeEditor.N51Click(Sender: TObject);
begin
  ChangeZoom(5);
end;

procedure TTreeEditor.Child1Click(Sender: TObject);
begin
  AddChild1Click(Sender);
end;

procedure TTreeEditor.Brother1Click(Sender: TObject);
begin
  AddBrother1Click(Sender);
end;

procedure TTreeEditor.Prunenode1Click(Sender: TObject);
begin
  Prune1Click(Sender);
end;

procedure TTreeEditor.NewRoot1Click(Sender: TObject);
begin
  AddNewRoot2Click(Sender);
end;

Function Toogle(Item: TMenuItem):Boolean;
begin { change the Checked property of Item and return result }
  Item.Checked:=not Item.Checked;
  result:=Item.Checked;
end;

procedure TTreeEditor.Connections1Click(Sender: TObject);
begin
  TheTree.Connections.Visible:=Toogle(Connections1);
  TeeModified;
end;

procedure TTreeEditor.Images1Click(Sender: TObject);
begin
  TheTree.ShowImages:=Toogle(Images1);
  TheTree.Invalidate;
  TeeModified;
end;

procedure TTreeEditor.Grid1Click(Sender: TObject);
begin
  CBGrid.Checked:=Toogle(Grid1);
  CBGridClick(Self);
end;

procedure TTreeEditor.Crossboxes1Click(Sender: TObject);
begin
  TheTree.CrossBox.Visible:=Toogle(CrossBoxes1);
  TeeModified;
end;

procedure TTreeEditor.Text1Click(Sender: TObject);
begin
  TheTree.ShowText:=Toogle(Text1);
  TheTree.Invalidate;
  TeeModified;
end;

procedure TTreeEditor.Shapes1Click(Sender: TObject);
begin
  TheTree.Shapes.Visible:=Toogle(Shapes1);
  TheTree.Invalidate;
  TeeModified;
end;

Procedure CreateColorBitmap(Item: TMenuItem; AColor:TColor);
begin { create a bitmap for the menu item, filled with AColor }
  with Item.Bitmap do
  begin
    Width:=15;
    Height:=15;
    Canvas.Brush.Color:=AColor;
    Canvas.Rectangle(0,0,14,14);
  end;
  
  Item.Tag:=AColor;
  Item.HelpContext:=2; { set as Color item }
end;

procedure TTreeEditor.Color1Click(Sender: TObject);
begin
  if TheTree.Selected.Count=0 then
  begin
    ButtonColor1.Click;
    TheTree.Gradient.Visible:=False;
  end
  else
  begin
    With TNodeTreeEditor.Create(Self) do
    try
      Tree1:=Self.TheTree;
      FormShow(Self);
      Shape4MouseUp(Self,mbLeft,[],0,0);
      Tree1:=nil;
    finally
      Free;
    end;
    CreateColorBitmap(TMenuItem(Sender),TheTree.Selected.First.Color);
  end;
  SetToolBars;
  TeeModified;
end;

procedure TTreeEditor.Format1Click(Sender: TObject);
var tmp     : Boolean;
    tmpConn : Boolean;
begin
  tmp:=TheTree.Selected.Count>0;
  tmpConn:=Assigned(TheTree.Connections.Selected);

  Style1.Enabled        :=tmp;
  Border1.Enabled       :=tmp or tmpConn;
  Font1.Enabled         :=tmp or tmpConn;
  Pattern1.Enabled      :=tmp;
  Transparent1.Enabled  :=tmp;
  Transparent1.Checked  :=tmp and TheTree.Selected.First.Transparent;
  Gradient1.Checked:=(tmp and TheTree.Selected.First.Gradient.Visible) or
                     ((not tmp) and TheTree.Gradient.Visible);
  ClipText1.Enabled:=tmp;
  ClipText1.Checked:=tmp and TheTree.Selected.First.Text.ClipText;
end;

procedure TTreeEditor.Insert1Click(Sender: TObject);
begin
  Brother1.Enabled:=(TheTree.Selected.Count>0) and
                    Assigned(TheTree.Selected.First.Parent);
  Child1.Enabled:=(TheTree.Selected.Count>0);
  NewParent1.Enabled:=Child1.Enabled;
end;

procedure TTreeEditor.ChangeGradient(Sender: TTreeNodeShape);
begin
  Sender.Gradient.Visible:=Gradient1.Checked;
end;

procedure TTreeEditor.Gradient1Click(Sender: TObject);
begin
  Toogle(Gradient1);

  with TheTree.Selected do
  if Count=0 then
     TheTree.Gradient.Visible:=Gradient1.Checked
  else
     ForEach(ChangeGradient);

  TeeModified;
end;

procedure TTreeEditor.Border1Click(Sender: TObject);
var tmp : Boolean;
begin
  if Assigned(TheTree.Connections.Selected) then
     tmp:=TPenDialog.Edit(Self,TheTree.Connections.Selected.Border)
  else
  if TheTree.Selected.Count=1 then
     tmp:=TPenDialog.Edit(Self,TheTree.Selected.First.Border)
  else
  With TNodeTreeEditor.Create(Self) do
  try
    Tree1:=Self.TheTree;
    FormShow(Self);
    //Button1Click(Self);
    Tree1:=nil;
    tmp:=True;
  finally
    Free;
  end;

  if tmp then
  begin
    TeeModified;
    SetBorderControls;
  end;
end;

procedure TTreeEditor.Font1Click(Sender: TObject);
var t   : Integer;
    tmp : Boolean;
begin
  if Assigned(TheTree.Connections.Selected) then
     tmp:=TTeeFontEditor.Edit(Self,TheTree.Connections.Selected.Font)
  else
  with TheTree.Selected do
  begin
    tmp:=TTeeFontEditor.Edit(Self,Items[0].Font);

    if tmp then
       for t:=1 to Count-1 do
           Items[t].Font.Assign(Items[0].Font);
  end;

  if tmp then
  begin
    TeeModified;
    SetFontControls;
  end;
end;

procedure TTreeEditor.Shadow1Click(Sender: TObject);
begin
  with TheTree.Selected do
  if Count=0 then
  begin
    if EditTeeShadow(Self,TheTree.Shadow) then
       TeeModified;
  end
  else
  begin
    with TNodeTreeEditor.Create(Self) do
    try
      Tree1:=Self.TheTree;
      FormShow(Self);
      PageControl1.ActivePage:=TabShadow;
      ShowModal;
    finally
      Free;
    end;

    TeeModified;
  end;
end;

procedure TTreeEditor.Style1Click(Sender: TObject);
var tmp : TTreeShapeStyle;
begin
  tmp:=TheTree.Selected.First.Style;

  RoundRectangle1.Checked:=tmp=tssRoundRectangle;
  Chamfer1.Checked:=tmp=tssChamfer;

  Rectangle2.Checked:=tmp=tssRectangle;
  Ellipse2.Checked:=tmp=tssCircle;
  Triangle2.Checked:=(tmp=tssTriangleTop) or (tmp=tssTriangleBottom) or
                     (tmp=tssTriangleLeft) or (tmp=tssTriangleRight);
  Line2.Checked:=(tmp=tssVertLine) or (tmp=tssHorizLine) or
                 (tmp=tssLine) or (tmp=tssInvertLine);
  Diamond2.Checked:=tmp=tssDiamond;
end;

procedure TTreeEditor.Transparent1Click(Sender: TObject);
var t : Integer;
begin
  Toogle(TMenuItem(Sender));
  With TheTree.Selected do
  for t:=0 to Count-1 do
  with Items[t] do
  begin
    Transparent:=TMenuItem(Sender).Checked;
    if Transparent then Gradient.Visible:=False;
  end;
  SetToolBars;
  TeeModified;
end;

procedure TTreeEditor.Edit4Click(Sender: TObject);
begin
  Paste2.Enabled:=TreeClipboard.Roots.Count>0;
  Copy2.Enabled:=TheTree.Selected.Count>0;
  Cut2.Enabled:=Copy2.Enabled;
  Delete2.Enabled:=Copy2.Enabled;
end;

Procedure SwitchVisible(AMenuItem:TMenuItem; Const AControls:Array of TControl);
var t : Integer;
begin
  Toogle(AMenuItem);
  for t:=Low(AControls) to High(AControls) do
      AControls[t].Visible:=AMenuItem.Checked;
end;

procedure TTreeEditor.Editortabs1Click(Sender: TObject);
begin
  SwitchVisible(EditorTabs1,[PageTree]);
end;

procedure TTreeEditor.View1Click(Sender: TObject);
begin
  With TheTree do
  begin
    Shapes1.Checked:=Shapes.Visible;
    Connections1.Checked:=Connections.Visible;
    CrossBoxes1.Checked:=CrossBox.Visible;
    Images1.Checked:=ShowImages;
    Text1.Checked:=ShowText;
    Grid1.Checked:=Grid.Visible;
    EditorTabs1.Checked:=PageTree.Visible;
    ShapeTabs1.Checked:=PageShapes.Visible;
    StatusBar2.Checked:=StatusBar1.Visible;
    Fonttoolbar1.Checked:=PanelFont.Visible;
    Bordertoolbar1.Checked:=PanelShape.Visible;
    Toolbar1.Checked:=PanelToolButtons.Visible;
  end;
end;

procedure TTreeEditor.Zoom1Click(Sender: TObject);
begin
  With TheTree.View3DOptions do
  begin
    N2001.Checked:=Zoom=200;
    N1001.Checked:=Zoom=100;
    N751.Checked:=Zoom=75;
    N501.Checked:=Zoom=50;
    N251.Checked:=Zoom=25;
    N151.Checked:=Zoom=15;
    N101.Checked:=Zoom=10;
    N51.Checked:=Zoom=5;
  end;
end;

procedure TTreeEditor.Line2Click(Sender: TObject);
var tmp : TTreeShapeStyle;
begin
  tmp:=TheTree.Selected.First.Style;
  Horizontal1.Checked:=tmp=tssHorizLine;
  Vertical1.Checked:=tmp=tssVertLine;
  Diagonal1.Checked:=tmp=tssLine;
  InvDiagonal1.Checked:=tmp=tssInvertLine;
end;

procedure TTreeEditor.Triangle2Click(Sender: TObject);
var tmp : TTreeShapeStyle;
begin
  tmp:=TheTree.Selected.First.Style;
  Left1.Checked:=tmp=tssTriangleLeft;
  Top1.Checked:=tmp=tssTriangleTop;
  Right1.Checked:=tmp=tssTriangleRight;
  Bottom1.Checked:=tmp=tssTriangleBottom;
end;

Procedure TTreeEditor.ChangeStyle(AStyle:TTreeShapeStyle);
var t : Integer;
begin
  With TheTree.Selected do
  for t:=0 to Count-1 do Items[t].Style:=AStyle;
  TeeModified;
end;

procedure TTreeEditor.RoundRectangle1Click(Sender: TObject);
begin
  ChangeStyle(tssRoundRectangle);
end;

procedure TTreeEditor.Rectangle2Click(Sender: TObject);
begin
  ChangeStyle(tssRectangle);
end;

procedure TTreeEditor.CBVertAutoClick(Sender: TObject);
begin
  if not FSetting then
  begin
    TheTree.VertScrollBar.Automatic:=CBVertAuto.Checked;
    TheTree.Invalidate;
    CBVertVisible.Checked:=TheTree.VertScrollBar.Visible;
    CBVertVisible.Enabled:=not TheTree.VertScrollBar.Automatic;
    TeeModified;
  end;
end;

procedure TTreeEditor.Ellipse2Click(Sender: TObject);
begin
  ChangeStyle(tssCircle);
end;

procedure TTreeEditor.Left1Click(Sender: TObject);
begin
  ChangeStyle(tssTriangleLeft);
end;

procedure TTreeEditor.Top1Click(Sender: TObject);
begin
  ChangeStyle(tssTriangleTop);
end;

procedure TTreeEditor.Right1Click(Sender: TObject);
begin
  ChangeStyle(tssTriangleRight);
end;

procedure TTreeEditor.Bottom1Click(Sender: TObject);
begin
  ChangeStyle(tssTriangleBottom);
end;

procedure TTreeEditor.Horizontal1Click(Sender: TObject);
begin
  ChangeStyle(tssHorizLine);
end;

procedure TTreeEditor.Vertical1Click(Sender: TObject);
begin
  ChangeStyle(tssVertLine);
end;

procedure TTreeEditor.Diagonal1Click(Sender: TObject);
begin
  ChangeStyle(tssLine);
end;

procedure TTreeEditor.InvDiagonal1Click(Sender: TObject);
begin
  ChangeStyle(tssInvertLine);
end;

procedure TTreeEditor.Diamond2Click(Sender: TObject);
begin
  ChangeStyle(tssDiamond);
end;

procedure TTreeEditor.Linknodes1Click(Sender: TObject);
begin
  SpeedLink.Down:=True;
  SpeedLinkClick(Self);
end;

procedure TTreeEditor.Help1Click(Sender: TObject);
begin
  Application.HelpJump('Scribble10');
end;

procedure TTreeEditor.StopConnecting;
begin
  TheTree.StopConnecting;
  StatusBar1.Panels[stPanelText].Text:='';
end;

procedure TTreeEditor.SpeedLinkClick(Sender: TObject);
var tmpC:TTreeConnection;
begin
  { set the Tree in "connecting" mode... }
  if SpeedLink.Down then
  begin
    { start connecting two shapes... }
    StatusBar1.Panels[stPanelText].Text:=TreeMsg_ClickTwoShapes;
    StatusBar1.Update;

    // Initiate mouse linking of nodes...
    TheTree.StartConnecting;

    // if user clicked on two nodes, link them...
    if Assigned(TheTree.ConnectingShape1) and
       Assigned(TheTree.ConnectingShape2) then
    begin
      tmpC:=TheTree.ConnectingShape1.Connections.ToShape(TheTree.ConnectingShape2);
      if Assigned(tmpC) then
      begin
        tmpC.Style:=csLine;

        TheTree.Selected.Clear;
        TheTree.Connections.Selected:=tmpC;
        FillNodeTree;
        TeeModified;
      end;
    end;
  end;
  StopConnecting;
  SpeedNormal.Down:=True;
end;

procedure TTreeEditor.PageShapesChange(Sender: TObject);
begin
  SpeedNormal.Parent:=PageShapes.ActivePage;
  SpeedLink.Parent:=PageShapes.ActivePage;
end;

procedure TTreeEditor.SpeedNormalClick(Sender: TObject);
begin
  TTreeAccess(TheTree).IZoomPriority:=False;
  if Assigned(TTreeAccess(TheTree).IPolygonMode) then
  begin
    TTreeAccess(TheTree).IPolygonMode:=nil; { stop drawing polygon }
    FillNodeTree;
    TeeModified;
  end;

  StopConnecting;
end;

procedure TTreeEditor.Shapetabs1Click(Sender: TObject);
begin
  SwitchVisible(ShapeTabs1,[PageShapes]);
  CheckPanelToolBar;
end;

procedure TTreeEditor.TrackBarZoomChange(Sender: TObject);
begin
  TheTree.View3DOptions.Zoom:=TrackBarZoom.Position;
  UDZoom.Position:=TrackBarZoom.Position;
  RefreshZoomLabel;
end;

procedure TTreeEditor.CBHorizAutoClick(Sender: TObject);
begin
  if not FSetting then
  begin
    TheTree.HorzScrollBar.Automatic:=CBHorizAuto.Checked;
    TheTree.Invalidate;
    CBHorizVisible.Checked:=TheTree.HorzScrollBar.Visible;
    CBHorizVisible.Enabled:=not TheTree.HorzScrollBar.Automatic;
    TeeModified;
  end;
end;

procedure TTreeEditor.Export1Click(Sender: TObject);
var Old       : Boolean;
    OldDesign : Boolean;
begin
  Old:=TheTree.Grid.Visible;
  TheTree.Grid.Visible:=OldGrid;
  OldDesign:=TheTree.Designing;
  TheTree.Designing:=False;

  try
    TreeEd.ShowTreeExport(Self,TheTree);
  finally
    TheTree.Grid.Visible:=Old;
    TheTree.Designing:=OldDesign;
  end;
end;

procedure TTreeEditor.CBBufferedClick(Sender: TObject);
begin
  if not FSetting then
  begin
    TheTree.BufferedDisplay:=CBBuffered.Checked;
    TeeModified;
  end;
end;

procedure TTreeEditor.CBSnapGridClick(Sender: TObject);
begin
  TheTree.SnapToGrid:=CBSnapGrid.Checked;
  TeeModified;
end;

procedure TTreeEditor.Edit5Change(Sender: TObject);
begin
  if not Creating then
  begin
    TheTree.Grid.Step:=UpDown3.Position;
    TheTree.Grid.BigStep:=UpDown1.Position;
    RefreshRulers;
    TeeModified;
  end;
end;

procedure TTreeEditor.Tools1Click(Sender: TObject);
var t : Integer;
begin
  LinkNodes1.Enabled:=TheTree.Shapes.Count>0;

  with TheTree.Selected do
  for t:=0 to Count-1 do
  if Items[t].Parents.Count>0 then
  begin
    PruneNode1.Enabled:=True;
    exit;
  end;
  PruneNode1.Enabled:=False;
end;

procedure TTreeEditor.Edit3Change(Sender: TObject);
begin
  if not Creating then
  begin
    TheTree.AnimatedZoomSteps:=UpDown2.Position;
    TeeModified;
  end;
end;

procedure TTreeEditor.CBScrollToViewClick(Sender: TObject);
begin
  if not FSetting then
  begin
    TheTree.Selected.ScrollToView:=CBScrollToView.Checked;
    TeeModified;
  end;
end;

procedure TTreeEditor.CBShowHintClick(Sender: TObject);
begin
  if not FSetting then
  begin
    TheTree.ShowHintShapes:=CBShowHint.Checked;
    TeeModified;
  end;
end;

procedure TTreeEditor.CBSingleSelectClick(Sender: TObject);
begin
  if not FSetting then
  begin
    TheTree.SingleSelection:=CBSingleSelect.Checked;
    TeeModified;
  end;
end;

Function GetTeeTreeHelpFile:String;
begin
  {$IFDEF TEEOCX}
  result:=GetRegistryHelpPath('TeeTree1X.hlp'); // <- do not translate
  {$ELSE}
  result:=GetRegistryHelpPath('TeeTree1.hlp');  // <- do not translate
  {$ENDIF}
end;

Function GetTeeTreeUserHelpFile:String;
begin
  {$IFDEF TEEOCX}
  result:=GetRegistryHelpPath('TeeTreeUser1X.hlp'); // <- do not translate
  {$ELSE}
  result:=GetRegistryHelpPath('TeeTreeUser1.hlp');  // <- do not translate
  {$ENDIF}
end;

procedure TTreeEditor.Editortips1Click(Sender: TObject);
begin
  ShowMessage(TreeMsg_EditorTips);
end;

Function TTreeEditor.NodeTreeText(ANode:TTreeNodeShape):String;
begin
  result:='';
  if ShowNames1.Checked then
  begin
    result:=ANode.Name;
    if result='' then result:=ANode.SimpleText;
  end
  else
  begin
    result:=ANode.SimpleText;
    if result='' then result:=ANode.Name;
  end;
  if result='' then result:=TeeStr(ANode.Tree.Shapes.IndexOf(ANode));
end;

Procedure TTreeEditor.UpdateNodeTree;
var t : Integer;
begin
  With NodeTree do
  for t:=0 to Shapes.Count-1 do
  begin
    Shapes[t].Text.Clear;
    Shapes[t].Text.Add(NodeTreeText(TTreeNodeShape(Shapes[t].Tag)));
  end;
end;

// Fill the Node Tree with a copy of all nodes in main Tree.
Procedure TTreeEditor.FillNodeTree;

  Procedure AddNodeChilds(ToNode,FromNode:TTreeNodeShape);
  var t       : Integer;
      tmpNode : TTreeNodeShape;
  begin
    ToNode.Tag:=ObjectToTag(FromNode);

    for t:=0 to FromNode.Count-1 do
    begin
      tmpNode:=ToNode.AddChild(NodeTreeText(FromNode.Children[t]));
      AddNodeChilds(tmpNode,FromNode.Children[t]);
    end;
  end;

var t       : Integer;
    tmpRoot : TTreeNodeShape;
begin
  if NodeTheTree.Checked then
  With NodeTree do
  begin
    Selecting:=True;
    BeginUpdate;
    try
      GlobalFormat.Border.Visible:=False;
      GlobalFormat.Transparent:=True;
      Clear;
      for t:=0 to TheTree.Roots.Count-1 do
      begin
        tmpRoot:=AddRoot(NodeTreeText(TheTree.Roots[t]));
        AddNodeChilds(tmpRoot,TheTree.Roots[t]);
      end;
    finally
      Selecting:=False;
      EndUpdate;
      ResetNodeTreeSelected;
    end;
  end;
end;

Procedure TTreeEditor.CheckPanelNodes;
begin
  PanelNodes.Visible:=PanelNodesInt.Visible or PanelInspector.Visible;
  Splitter1.Visible:=PanelNodes.Visible;
  Splitter1.Left:=PanelTree.Left-3;
  Splitter2.Visible:=PanelNodesInt.Visible and PanelInspector.Visible;
  if not PanelInspector.Visible then
  begin
    if PanelNodesInt.Visible then PanelNodesInt.Align:=alClient;
  end
  else
  begin
    if PanelNodesInt.Visible then
    begin
      PanelNodesInt.Align:=alTop;
      PanelNodesInt.Height:=150;
    end
    else
    begin
      PanelInspector.Align:=alClient;
    end;
  end;
end;

procedure TTreeEditor.NodeTheTreeClick(Sender: TObject);
begin
  SwitchVisible(NodeTheTree,[PanelNodesInt]);
  if NodeTheTree.Checked then FillNodeTree;
  CheckPanelNodes;
end;

procedure TTreeEditor.NodeTreeSelectShape(Sender: TTreeNodeShape);
begin
  DoSelection(Sender,True);
end;

Function TTreeEditor.GetNodeTreeShape(ANode:TTreeNodeShape):TTreeNodeShape;
Var t : Integer;
begin
  result:=nil;

  With NodeTree do
  for t:=0 to Shapes.Count-1 do
  if Shapes[t].Tag=TeeNativeInt(ANode) then
  begin
    result:=Shapes[t];
    exit;
  end;
end;

Function TTreeEditor.GetFontAttribute:TFontStyles;
begin
  result:=[];
  if FontBold.Down then Include(result,fsBold);
  if FontItalic.Down then Include(result,fsItalic);
  if FontUnderline.Down then Include(result,fsUnderline);
  if FontStrike.Down then Include(result,fsStrikeOut);
end;

Function TTreeEditor.GetFontAlign:THorizTextAlign;
begin
  if FontLeftAlign.Down then result:=htaLeft else
  if FontCenterAlign.Down then result:=htaCenter else
                               result:=htaRight;
end;

Procedure TTreeEditor.ResetNodeTreeSelected;
var tmpNode : TTreeNodeShape;
    t       : Integer;
begin
  if NodeTheTree.Checked then
  begin
    Selecting:=True;
    try
      NodeTree.Selected.Clear;
      for t:=0 to TheTree.Selected.Count-1 do
      begin
        tmpNode:=GetNodeTreeShape(TheTree.Selected[t]);
        if Assigned(tmpNode) then SelectExpandNode(tmpNode,True);
      end;

      SetInspectorProperties;
    finally
      Selecting:=False;
    end;
  end;
end;

Function TTreeEditor.SelectedElement:TCustomTreeElement;
begin
  result:=TheTree.Connections.Selected;
  if not Assigned(result) then
  With TheTree.Selected do if Count>0 then result:=Items[0];
end;

Procedure TTreeEditor.SetBorderControls;
var tmp : TTreePen;
begin
  tmp:=SelectedBorder;
  if Assigned(tmp) then
  begin
    ShapeBorderColor.Brush.Color:=tmp.Color;
    ShapeBorderColor.Visible:=True;
    if not ComboPenStyle.Enabled then DoEnableControls(PanelShape,True);

    BorderWidth.Position:=tmp.Width;
    if tmp.SmallDots then
    begin
      ComboPenStyle.ItemIndex:=ComboPenStyle.Items.Count-1;
      BorderWidth.Enabled:=False;
    end
    else
    if tmp.Visible then ComboPenStyle.ItemIndex:=1+Ord(tmp.Style)
                   else ComboPenStyle.ItemIndex:=0;
  end
  else
  begin
    ShapeBorderColor.Visible:=False;
    if ComboPenStyle.Enabled then DoEnableControls(PanelShape,False);
  end;
end;

Procedure TTreeEditor.SetFontControls;

  Function SameFontName:Boolean;
  var t : Integer;
  begin
    result:=Assigned(TheTree.Connections.Selected);
    if not result then
    With TheTree.Selected do
    begin
      result:=Count>0;
      if Count>1 then
         for t:=1 to Count-1 do
         if Items[t].Font.Name<>Items[0].Font.Name then
         begin
           result:=False;
           exit;
         end;
    end;
  end;

  Function SameFontSize:Boolean;
  var t : Integer;
  begin
    result:=Assigned(TheTree.Connections.Selected);
    if not result then
    With TheTree.Selected do
    begin
      result:=Count>0;
      if Count>1 then
         for t:=1 to Count-1 do
         if Items[t].Font.Size<>Items[0].Font.Size then
         begin
           result:=False;
           exit;
         end;
    end;
  end;

var tmp : TCustomTreeElement;
begin
  tmp:=SelectedElement;

  if SameFontName then
     with ComboFonts do ItemIndex:=Items.IndexOf(tmp.Font.Name)
  else
     ComboFonts.ItemIndex:=-1;

  if SameFontSize then
     ComboFontSize.Text:=TeeStr(tmp.Font.Size)
  else
     ComboFontSize.Text:='';

  if Assigned(tmp) then
  begin
    ShapeFontColor.Visible:=True;
    if not ComboFonts.Enabled then DoEnableControls(PanelFont,True);

    With tmp do
    begin
      With Font do
      begin
        FontBold.Down:=fsBold in Style;
        FontItalic.Down:=fsItalic in Style;
        FontUnderline.Down:=fsUnderline in Style;
        FontStrike.Down:=fsStrikeOut in Style;
        ShapeFontColor.Brush.Color:=Color;
        UDFontInter.Position:=InterCharSize;
      end;

      FontLeftAlign.Down:=HorizTextAlign=htaLeft;
      FontCenterAlign.Down:=HorizTextAlign=htaCenter;
      FontRightAlign.Down:=HorizTextAlign=htaRight;
    end;
  end
  else
  begin
    ShapeFontColor.Visible:=False;
    if ComboFonts.Enabled then DoEnableControls(PanelFont,False);
  end;
end;

procedure TTreeEditor.TheTreeAfterDraw(Sender: TObject);
var tmp : String;
begin
  with TheTree.Page do tmp:=TeeStr(Page)+'/'+TeeStr(Count);
  StatusBar1.Panels[stPanelPage].Text:=tmp;
end;

procedure TTreeEditor.TheTreeDeletedShapes(Sender: TObject);
begin
  FillNodeTree;
  SetToolBars;
  TeeModified;
end;

procedure TTreeEditor.TheTreeSelectShape(Sender: TTreeNodeShape);
begin
  ResetNodeTreeSelected;
  SetToolBars;
end;

procedure TTreeEditor.TheTreeUnSelectShape(Sender: TTreeNodeShape);
begin
  ResetNodeTreeSelected;
  SetToolBars;
end;

procedure TTreeEditor.NodeTreeMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbRight then TryPopup(NodeTree,x,y);
end;

procedure TTreeEditor.CBAllowDeleteClick(Sender: TObject);
begin
  if not FSetting then
  begin
    TheTree.AllowDelete:=CBAllowDelete.Checked;
    TeeModified;
  end;
end;

procedure TTreeEditor.NodeTreeDeletingShapes(Sender: TSelectedShapeList;
  var AllowDelete: Boolean);
begin
  AllowDelete:=False;
  Delete1Click(Self);
end;

// User pressed F2 twice at NodeTree to stop editing.
procedure TTreeEditor.NodeTreeStopEditing(Sender: TTreeNodeShape);
begin
  With TTreeNodeShape(Sender.Tag) do
  if ShowNames1.Checked then
  begin
    // Rename node:
    if Sender.Text.Count>0 then Name:=Sender.SimpleText;
  end
  else
    Text.Text:=Sender.Text.Text; // Change node Text

  TeeModified;
end;

procedure TTreeEditor.NewParent1Click(Sender: TObject);
var tmp : TTreeNodeShape;
    t   : Integer;
begin
  if TheTree.Selected.Count>0 then
  begin
    tmp:=AddNewRoot;
    for t:=0 to TheTree.Selected.Count-1 do
        tmp.AddConnection(TheTree.Selected[t]).Style:=csLine;
    TheTree.Selected.Clear;
    tmp.Selected:=True;
    FillNodeTree;
    TeeModified;
  end;
end;

procedure TTreeEditor.AligntoGrid2Click(Sender: TObject);
begin
  Aligntogrid1Click(Self);
end;

procedure TTreeEditor.ShowNames1Click(Sender: TObject);
begin
  Toogle(ShowNames1);
  UpdateNodeTree;
end;

procedure TTreeEditor.TheTreeStopEditing(Sender: TTreeNodeShape);
var tmp : TTreeNodeShape;
begin
  if not ShowNames1.Checked then
  begin
    tmp:=GetNodeTreeShape(Sender);
    if Assigned(tmp) then
    With tmp.Text do
    begin
      Clear;
      Add(NodeTreeText(Sender));
      TeeModified;
    end;
  end;
end;

procedure TTreeEditor.Import1Click(Sender: TObject);
begin
  with OpenDialog1 do
  begin
    Title:=TreeMsg_ImportTextFile;
    FilterIndex:=2;

    if Execute then
    begin
      if FilterIndex=2 then
         TheTree.LoadFromTextFile(FileName)
      else
         LoadTreeFromFile(TheTree,FileName);

      TeeModified;
    end;
  end;
end;

procedure TTreeEditor.ButtonNewClick(Sender: TObject);
begin
  New1Click(Self);
end;

procedure TTreeEditor.ButtonOpenClick(Sender: TObject);
begin
  Open1Click(Self);
end;

procedure TTreeEditor.NodeTreeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key=TeeTree_F11Key then
     TheTree.SetFocus;
end;

procedure TTreeEditor.ButtonPrintClick(Sender: TObject);
begin
  Print1Click(Self);
end;

procedure TTreeEditor.ButtonPrintPreviewClick(Sender: TObject);
begin
  Printpreview1Click(Self);
end;

Procedure TTreeEditor.DoZoom(Value:Integer);
begin
  With TrackBarZoom do Position:=Position+Value;
  TrackBarZoomChange(Self);
end;

procedure TTreeEditor.ButtonZoomInClick(Sender: TObject);
begin
  DoZoom(10);
end;

procedure TTreeEditor.ButtonScrollClick(Sender: TObject);
begin
  Export1Click(Sender);
end;

procedure TTreeEditor.EHandleSizeChange(Sender: TObject);
begin
  if not Creating then
  begin
    TheTree.Selected.HandleSize:=UDHandleSize.Position;
    TeeModified;
  end;
end;

Function TTreeEditor.TeeEditColor(Var Color:TColor):Boolean;
var tmpColor : TColor;
begin
  tmpColor:=Color;
  Color:=TButtonColor.Edit(Self,Color);
  result:=tmpColor<>Color;
  if result then TeeModified;
end;

procedure TTreeEditor.ChangeFontColor(Sender: TTreenodeShape);
begin
  Sender.Font.Color:=ShapeFontColor.Brush.Color;
end;

procedure TTreeEditor.ShapeFontColorMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var tmpColor : TColor;
begin
  if Assigned(TheTree.Connections.Selected) or (TheTree.Selected.Count>0) then
  begin
    tmpColor:=ShapeFontColor.Brush.Color;
    if TeeEditColor(tmpColor) then
    begin
      With TheTree do
      if Assigned(Connections.Selected) then
         Connections.Selected.Font.Color:=tmpColor
      else
      begin
        ShapeFontColor.Brush.Color:=tmpColor;
        Selected.ForEach(ChangeFontColor);
      end;
    end;
  end;
end;

Procedure TTreeEditor.CheckPanelTools;
var tmp : Integer;
begin
  PanelTools.Visible:=PanelFont.Visible or PanelShape.Visible;
  if PanelTools.Visible then
  begin
    tmp:=0;
    if PanelFont.Visible then Inc(tmp,PanelFont.Height);
    if PanelShape.Visible then Inc(tmp,PanelShape.Height);
    PanelTools.Height:=tmp;
  end;
end;

procedure TTreeEditor.Fonttoolbar1Click(Sender: TObject);
begin
  SwitchVisible(FontToolbar1,[PanelFont]);
  CheckPanelTools;
end;

Procedure TTreeEditor.CheckPanelToolBar;
begin
  PanelToolBar.Visible:=PanelToolButtons.Visible or PageShapes.Visible;
  if PanelToolBar.Visible then PanelToolBar.Height:=56;
end;

procedure TTreeEditor.Statusbar2Click(Sender: TObject);
begin
  SwitchVisible(StatusBar2,[StatusBar1]);
end;

procedure TTreeEditor.ComboFontsChange(Sender: TObject);
begin
  With TheTree do
  if Assigned(Connections.Selected) then
     Connections.Selected.Font.Name:=ComboFonts.CurrentItem
  else
     Selected.ForEach(ChangeFont);

  TeeModified;
end;

procedure TTreeEditor.ComboFontSizeChange(Sender: TObject);
begin
  With TheTree do
  if Assigned(Connections.Selected) then
     Connections.Selected.Font.Size:=GetFontSize
  else
     Selected.ForEach(ChangeFontSize);

  TeeModified;
end;

procedure TTreeEditor.FontBoldClick(Sender: TObject);
begin
  With TheTree do
  if Assigned(Connections.Selected) then
     Connections.Selected.Font.Style:=GetFontAttribute
  else
     Selected.ForEach(ChangeFontAttrib);
  TeeModified;
end;

procedure TTreeEditor.EditFontInterChange(Sender: TObject);
begin
  if not Creating then
  begin
    With TheTree do
    if Assigned(Connections.Selected) then
       Connections.Selected.Font.InterCharSize:=UDFontInter.Position
    else
       Selected.ForEach(ChangeInterChar);

    TeeModified;
  end;
end;

procedure TTreeEditor.SBOutlineClick(Sender: TObject);
begin
  With TheTree do
  if Assigned(Connections.Selected) then
  begin
    if TPenDialog.Edit(Self,Connections.Selected.Font.OutLine) then
       TeeModified;
  end
  else
  if Selected.Count>0 then
     if TPenDialog.Edit(Self,Selected.First.Font.OutLine) then
     begin
       Selected.ForEach(DoSetOutLine);
       TeeModified;
     end;
end;

procedure TTreeEditor.DoEnableControls(AContainer: TWinControl;
  IsEnable: Boolean);
var t : Integer;
begin
  With AContainer do
  for t:=0 to ControlCount-1 do Controls[t].Enabled:=IsEnable;
end;

procedure TTreeEditor.FontLeftAlignClick(Sender: TObject);
begin
  With TheTree do
  if Assigned(Connections.Selected) then
     Connections.Selected.HorizTextAlign:=GetFontAlign
  else
     Selected.ForEach(ChangeFontAlign);

  TeeModified;
end;

procedure TTreeEditor.CBZoomCenteredClick(Sender: TObject);
begin
  TheTree.ZoomCentered:=CBZoomCentered.Checked;
  TeeModified;
end;

procedure TTreeEditor.Toolbar1Click(Sender: TObject);
begin
  SwitchVisible(Toolbar1,[PanelToolButtons]);
  CheckPanelToolBar;
end;

procedure TTreeEditor.ReopenFile(Const FileName:String);
begin { when clicking the "recent files" menu, open a file }
  if CheckSave then
     LoadTree(FileName);
end;

Procedure TTreeEditor.SetTreeProperties;
begin
  With TheTree do
  begin
    With CrossBox do
    begin
      UDCrossSize.Position   :=Size;
      CBCrossStyle.ItemIndex :=Ord(Style);
    end;

    ButtonColor1.LinkProperty(TheTree,'Color');

    CBZoomCentered.Checked:=ZoomCentered;

    SetBevelCombo(BevelInner,CBBevelInner);
    SetBevelCombo(BevelInner,CBBevelOuter);
    CBBorder.Checked:=BorderStyle=bsSingle;

    BCrossBorder.LinkPen(CrossBox.Border);
    SignPenButton.LinkPen(CrossBox.SignPen);
    BHandlePen.LinkPen(Selected.HandlePen);
    Button7.LinkPen(Selected.Border);
    Button3.LinkPen(Selected.BorderUnFocused);
    BHandleColor.LinkProperty(Selected,'HandleColor');

    BGridColor.LinkProperty(TheTree.Grid,'Color');
    BGridPen.LinkPen(Grid.Pen);
    BGridBigPen.LinkPen(Grid.BigPen);
    BSelectedColor.LinkProperty(Selected,'Color');
    BSelectedText.LinkProperty(Selected,'TextColor');
    BCrossColor.LinkProperty(CrossBox.Brush,'Color');
    BUnFocusedColor.LinkProperty(Selected,'ColorUnFocused');

    CBImageStyle.Enabled  :=HasBackImage;
    
    if HasBackImage then
       BBackImage.Caption:=TreeMsg_Clear
    else
       BBackImage.Caption:=TreeMsg_Browse;

    TrackBarZoom.Position :=View3DOptions.Zoom;
    UDZoom.Position       :=TrackBarZoom.Position;
    RefreshZoomLabel;

    CBImageStyle.ItemIndex:=Ord(BackImageMode);

    CBAllowScroll.ItemIndex:=Ord(AllowPanning);
    CBAllowZoom.Checked:=AllowZoom;
    CBZoomAnimated.Checked:=AnimatedZoom;
    UpDown2.Position:=AnimatedZoomSteps;
    Edit3.Enabled:=AnimatedZoom;

    With Selected do
    begin
      CBSelectedColorDef.Checked:=Color=clHighLight;
      CBSelectedTextDef.Checked:=TextColor=clHighLightText;
      CBScrollToView.Checked:=ScrollToView;
      UDHandleSize.Position:=HandleSize;
    end;

    With HorzScrollBar do
    begin
      CBHorizAuto.Checked:=Automatic;
      CBHorizVisible.Checked:=Visible;
      CBHorizVisible.Enabled:=not Automatic;
    end;
    With VertScrollBar do
    begin
      CBVertAuto.Checked:=Automatic;
      CBVertVisible.Checked:=Visible;
      CBVertVisible.Enabled:=not Automatic;
    end;
    CBScrollFlat.Checked:=HorzScrollBar.Flat or VertScrollBar.Flat;

    CBShowHint.Checked:=ShowHintShapes;
    CBHotTrack.Checked:=HotTrack.Active;

    CBWheel.ItemIndex:=Ord(WheelNavigation);

    CBSingleSelect.Checked:=SingleSelection;
    CBAllowDelete.Checked:=AllowDelete;
    CBBuffered.Checked:=BufferedDisplay;

    CBRender.Checked:=Canvas.ClassName=TeeGDIPlusCanvasName;

    CBSnapGrid.Checked:=SnapToGrid;
    UpDown3.Position:=Grid.Step;
    UpDown1.Position:=Grid.BigStep;

    CBPrintPanel.Checked:=PrintTeePanel;
    CBPrintPageBorder.Checked:=Page.Border.Print;

    BPageBorder.LinkPen(Page.Border);
    CBPrinterDefault.Checked:=Page.UsePrinter;

    { text editor }
    CBTextEnabled.Checked:=TextEditor.Enabled;

    with CBTextKey do
    begin
      Text:=ShortCutToText(TextEditor.ShortCut);
      ItemIndex:=Items.IndexOf(Text);
    end;

    CBTextMode.ItemIndex:=Ord(TextEditor.Mode);
    CBTextMouse.ItemIndex:=Ord(TextEditor.MouseButton);
    CBTextSize.Checked:=TextEditor.UseNodeSize;
    CBTextFont.Checked:=TextEditor.UseNodeFont;
    CBTextFormat.Checked:=TextEditor.UseNodeFormat;

    SetPageControls;
    EnablePageControls;
  end;
end;

Procedure TTreeEditor.SetTreeSettings;
begin
  FSetting:=True;

  HorizRuler.Tree:=TheTree;
  VertRuler.Tree:=TheTree;

  SetTreeProperties;

  CBRulersUnits.Checked:=HorizRuler.ShowUnits;
  CBShowRulers.Checked:=HorizRuler.Visible;
  CBUnits.ItemIndex:=Ord(HorizRuler.Units);

  SetNewTreeSettings;

  FSetting:=False;

  SetToolBars;
end;

procedure TTreeEditor.EnablePageControls;
begin
  with TheTree.Page do
  begin
    UDPageWidth.Enabled:=not UsePrinter;
    EPageWidth.Enabled:=not UsePrinter;
    UDPageHeight.Enabled:=not UsePrinter;
    EPageHeight.Enabled:=not UsePrinter;
  end;
end;

procedure TTreeEditor.TeeModified(YesNo: Boolean=True);
begin { The Tree has been modified (or not) }
  FModified:=YesNo;

  if FModified then
  begin
    StatusBar1.Panels[stPanelModified].Text:=TeeMsg_Modified;
    TeeInspector1.Invalidate;
  end
  else StatusBar1.Panels[stPanelModified].Text:='';
end;

procedure TTreeEditor.CreateNewTree;
begin
  TheTree.Free;  { destroy previous Tree, if any }

  TheTree:=TeeTreeClass.Create(Self); { ask for suitable Tree class and create }

  { important, otherwise nodes will not be saved together with the Tree }
  TheTree.NoOwnerShapes:=False;

  { set parent control }
  TheTree.Parent:=PanelTree;
end;

class Function TTreeEditor.TeeTreeClass: TTreeClass;
begin
  result:=TTree;
end;

Procedure TTreeEditor.WriteTreeToStream(AStream:TStream);
begin
  AStream.WriteComponent(TheTree);
end;

Procedure TTreeEditor.InternalSaveTree;
var OldName    : String;
    tmp        : TFileStream;
    OldVisible : Boolean;
begin
  OldName:=TheTree.Name;
  TheTree.Name:='';
  try
    if ExtractFileExt(CurrentFile)='' then
       CurrentFile:=ChangeFileExt(CurrentFile,'.'+TreeMsg_TeeExtension);

    tmp:=TFileStream.Create(CurrentFile,fmCreate);
    try
      OldVisible:=TheTree.Visible;
      TheTree.Visible:=True;
      try
        WriteTreeToStream(tmp);
      finally
        TheTree.Visible:=OldVisible;
      end;
    finally
      tmp.Free;
    end;
  finally
    TheTree.Name:=OldName;
  end;
end;

Procedure TTreeEditor.DoSaveTree;
begin { save the Tree ! }
  InternalSaveTree;
  FRecentFiles.Add(TreeCheckExtension(CurrentFile));
  MainSetCaption;
  TeeModified(False);
end;

Procedure TTreeEditor.SetBevelCombo(ABevel:TPanelBevel; ACombo:TComboBox);
begin
  Case ABevel of
    bvNone    : ACombo.ItemIndex:=0;
    bvLowered : ACombo.ItemIndex:=1;
    bvRaised  : ACombo.ItemIndex:=2;
  else ACombo.ItemIndex:=3;
  end;
end;

procedure TTreeEditor.CBShowRulersClick(Sender: TObject);
begin
  Rulers1.Checked:=CBShowRulers.Checked;
  HorizRuler.Visible:=Rulers1.Checked;
  VertRuler.Visible:=Rulers1.Checked;
end;

Procedure TTreeEditor.SetNewTreeSettings;
begin
  With TheTree do
  begin
    PopupMenu:=nil;
    AllowZoom:=True;
    DragMode:=dmManual;
    AllowPanning:=pmBoth;
    Align:=alClient;
    if OldParent=PanelTree then OldParent:=nil;
    Parent:=PanelTree;
    Designing:=True;
    Grid.Visible:=True;
    CBGrid.Checked :=True;

    TheTree.SetDesignTime(False);

    { set events }
    TInternalLoadTree(TheTree).OnNewPolygon:=TheTreeNewPolygon;

    OnAfterDraw           :=TheTreeAfterDraw;
    OnMovingShape         :=TheTreeMovingShape;
    OnMouseMove           :=TheTreeMouseMove;
    OnMouseUp             :=TheTreeMouseUp;
    OnDblClick            :=nil;
    OnDblClickConnection  :=TheTreeDblClickConnection;
    OnDblClickShape       :=TheTreeDblClickShape;
    OnDeletedShapes       :=TheTreeDeletedShapes;
    OnKeyDown             :=TheTreeKeyDown;
    OnResizingShape       :=TheTreeResizingShape;
    OnSelectConnection    :=TheTreeSelectConnection;
    OnSelectShape         :=TheTreeSelectShape;
    OnUnSelectShape       :=TheTreeUnSelectShape;
    OnUnSelectConnection  :=TheTreeUnSelectConnection;
    OnStopEditing         :=TheTreeStopEditing;
    OnZoomedArea          :=TheTreeOnZoomedArea;
    OnZoom                :=TheTreeOnZoom;
    OnClickConnection     :=TheTreeClickConnection;
    OnClickShape          :=nil;
    OnExpandedCollapsed   :=nil;
    OnExpandingCollapsing :=nil;
  end;

  TreePageNavigator1.Tree:=TheTree;
end;

procedure TTreeEditor.TheTreeNewPolygon( Sender: TCustomTree;
                                         APolygon:TPolygonShape);
begin { when the user finishes drawing a polygon (pressing the Escape key) }
  FillNodeTree;
  TeeModified;
  SpeedNormal.Down:=True;
end;

Procedure TTreeEditor.MainSetCaption;
var s : String;
begin { set the Caption on the main form }
  if (Caption = '') then
  begin
    if CurrentFile='' then s:=TreeMsg_Tree1
                      else s:=ExtractFileName(CurrentFile);
                      
    Caption:=Format(CaptionFormat,[s]);
  end;
end;

procedure TTreeEditor.Rulers1Click(Sender: TObject);
begin
  SwitchVisible(Rulers1,[HorizRuler,VertRuler]);
end;

procedure TTreeEditor.TheTreeDblClickConnection(Sender: TTreeConnection;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  EditTreeConnection(Self,Sender,ssCtrl in Shift);
  SetToolBars;
  TeeModified;
end;

procedure TTreeEditor.TheTreeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
Const Key_V_Up=Ord('V');
      Key_V_Low=Ord('v');
      Key_C_Up=Ord('C');
      Key_C_Low=Ord('c');
begin
  Case Key of
   TeeTree_DeleteKey: if Assigned(TheTree.Connections.Selected) then
                         TheTree.Connections.Selected.Free;

   TeeTree_F11Key   : if PageNodes.Visible then NodeTree.SetFocus;

   TeeTree_InsertKey: if ssCtrl in Shift then
                         Copy1Click(Self)
                      else
                      if ssShift in Shift then
                         Paste1Click(Self);

   Key_C_Up,
   Key_C_Low : if ssCtrl in Shift then
                  Copy1Click(Self);

   Key_V_Up,
   Key_V_Low : if ssCtrl in Shift then
                  Paste1Click(Self);
  end;
end;

procedure TTreeEditor.RefreshRulers;
begin
  if HorizRuler.Visible then HorizRuler.Invalidate;
  if VertRuler.Visible then VertRuler.Invalidate;
end;

procedure TTreeEditor.TheTreeOnZoom(Sender: TObject);
begin
  TeeModified;
end;

procedure TTreeEditor.SetOtherControls;
var tmp,tmpNode : TTreeNodeShape;
begin
  if TheTree.Selected.Count>0 then
  begin
    tmp:=TheTree.Selected.First;
    ShapeBrush.Brush.Color:=tmp.Brush.Color;
    ShapeBrush.Show;
    ComboBrush.ItemIndex:=Ord(tmp.ImageIndex);
    ComboBrush.Enabled:=True;
    ComboText.Text:=tmp.SimpleText;
    ComboText.Enabled:=True;
    CBTransp.Checked:=tmp.Transparent;
    CBTransp.Enabled:=True;

    if tmp is TTreeNodeShape then
    begin
      tmpNode:=GetNodeTreeShape(TTreeNodeShape(tmp));

      if Assigned(tmpNode) then
      begin
        tmpNode.Text.Clear;
        tmpNode.Text.Add(tmp.SimpleText);
      end
    end;

  end
  else
  begin
    ShapeBrush.Hide;
    ComboBrush.Enabled:=False;
    CBTransp.Enabled:=False;

    if Assigned(TheTree.Connections.Selected) then
    begin
      ComboText.Text:=TheTree.Connections.Selected.SimpleText;
      ComboText.Enabled:=True;
    end
    else
    begin
      ComboText.Text:='';
      ComboText.Enabled:=False;
    end;
  end;
end;

procedure TTreeEditor.SetToolBars;
begin
  FSetting:=True;
  SetFontControls;
  SetBorderControls;
  SetOtherControls;
  FSetting:=False;
end;

procedure TTreeEditor.TheTreeSelectConnection(Sender: TTreeConnection);
begin
  SetToolBars;
  SetInspectorProperties;
end;

procedure TTreeEditor.TheTreeUnSelectConnection(Sender: TTreeConnection);
begin
  SetToolBars;
  SetInspectorProperties;
end;

Procedure TTreeEditor.SaveOldTreeSettings;
begin
  With TheTree do
  begin
    SaveEvents(SavedEvents);

    OldDblClick:=OnDblClick;

    OldPopup:=PopupMenu;
    OldBounds:=BoundsRect;
    OldZoom:=AllowZoom;
    OldDragMode:=DragMode;
    OldPanning:=AllowPanning;
    OldAlign:=Align;
    OldAnchors:=Anchors;
    OldParent:=Parent;
    OldDesigning:=Designing;
    OldDesignState:=csDesigning in ComponentState;
    OldGrid:=Grid.Visible;
    OldVisible:=Visible;
  end;
end;

procedure TTreeEditor.CBBevelInnerChange(Sender: TObject);
begin
  TheTree.BevelInner:=ChangeBevel(CBBevelInner);
  TeeModified;
end;

procedure TTreeEditor.CBBevelOuterChange(Sender: TObject);
begin
  TheTree.BevelOuter:=ChangeBevel(CBBevelOuter);
  TeeModified;
end;

procedure TTreeEditor.CBBorderClick(Sender: TObject);
begin
  if not FSetting then
  begin
    if CBBorder.Checked then TheTree.BorderStyle:=bsSingle
                        else TheTree.BorderStyle:=bsNone;
    TeeModified;
  end;
end;

procedure TTreeEditor.CBCrossStyleChange(Sender: TObject);
begin
  TheTree.CrossBox.Style:=TTreeCrossBoxStyle(CBCrossStyle.ItemIndex);
  TeeModified;
end;

function TTreeEditor.ChangeBevel(ACombo: TComboBox): TPanelBevel;
begin
  Case ACombo.ItemIndex of
    0: result:=bvNone;
    1: result:=bvLowered;
    2: result:=bvRaised;
  else
    result:=bvSpace;
  end;
end;

Procedure TTreeEditor.CheckSaveDialogFilter;
var t      : Integer;
    tmpExp : TTeeExportFormat;
begin
  if SaveDialog1.Filter='' then
  begin
    SaveDialog1.Filter:=TeeMsg_TreeFiles; // native *.ttr

// Can this be used instead?    TeeFillPictureDialog(SaveDialog1,TheTree,nil);

    // Add graphic formats: JPEG, PNG, etc.
    for t:=0 to TeeExportFormats.Count-1 do
    begin
      tmpExp:=TeeExportFormats[t].Create;
      try
        with SaveDialog1 do
             Filter:=Filter+'|'+tmpExp.FileFilter;
      finally
        tmpExp.Free;
      end;
    end;
  end;
end;

procedure TTreeEditor.Save1Click(Sender: TObject);
begin
  if CurrentFile='' then
  begin
    CheckSaveDialogFilter;

    SaveDialog1.FileName:=TreeMsg_Tree1;
    if SaveDialog1.Execute then
       CurrentFile:=SaveDialog1.FileName;
  end;

  if CurrentFile<>'' then DoSaveTree;
end;

Procedure TTreeEditor.SelectExpandNode(Node:TTreeNodeShape; Select:Boolean);
var tmp : TTreeNodeShape;
begin
  Node.Selected:=Select;
  if Select then
  begin
    tmp:=Node.Parent;
    While Assigned(tmp) and (not tmp.Expanded) do
    begin
      tmp.Expanded:=True;
      tmp:=tmp.Parent;
    end;
  end;
end;

Procedure TTreeEditor.DoSelection(Node:TTreeNodeShape; Select:Boolean);
begin
  if not Selecting then
  begin
    if NodeTree.SingleSelection then TheTree.Selected.Clear;
    SelectExpandNode(TTreeNodeShape(Node.Tag),Select);

    SetInspectorProperties;
  end;
end;

Procedure TTreeEditor.SetInspectorProperties;
var tmp : TPopupMenu;
begin
  if TheTree.Selected.Count=0 then
     if Assigned(TheTree.Connections.Selected) then
        tmp:=PopupConnFormat
     else
        tmp:=PopupMenuPanel
  else
      tmp:=PopupFormat;

  with TeeInspector1 do
  begin
    SetProperties(tmp);
    Col:=1;
    if (Row=0) and Header.Visible then Row:=1;
  end;
end;

procedure TTreeEditor.NodeTreeUnSelectShape(Sender: TTreeNodeShape);
begin
  DoSelection(Sender,False);
end;

Procedure TreeHideEditorPanels(Editor:TTreeEditor; HideWindows:TTreeEditWindows);

  Procedure MenuHideWindow(AOption:TTreeEditWindow; AMenu:TMenuItem; AProc:TNotifyEvent);
  begin
    if AOption in HideWindows then
    begin
      if AMenu.Checked then AProc(Editor);
    end
    else
      if not AMenu.Checked then AProc(Editor);
  end;

begin
  if Assigned(Editor) then
  with Editor do
  begin
    { show / hide panels }

    TabControl1.Visible:=not (teModeTabs in HideWindows);

    MenuHideWindow(teFont,FontToolBar1,FontToolBar1Click);
    MenuHideWindow(teFormat,BorderToolBar1,BorderToolBar1Click);
    MenuHideWindow(teRulers,Rulers1,Rulers1Click);
    MenuHideWindow(teToolShapes,ShapeTabs1,ShapeTabs1Click);
    MenuHideWindow(teToolBar,Toolbar1,Toolbar1Click);
    MenuHideWindow(teNodeTree,NodeTheTree,NodeTheTreeClick);
    MenuHideWindow(teInspector,Inspector1,Inspector1Click);
    MenuHideWindow(teStatus,StatusBar2,StatusBar2Click);
    MenuHideWindow(teEditors,EditorTabs1,EditorTabs1Click);

    if teMainMenu in HideWindows then Menu:=nil;
  end;
end;

{ TTreeEdit }
Constructor TTreeEdit.Create(AOwner: TComponent);
begin
  inherited;
  FPosition:=poDefault;
  FHide:=[teEditors];
end;

procedure TTreeEdit.Execute;
var tmp : TTreeEditor;
begin
  if Assigned(FTree) then
  begin
    tmp:=TTreeEditor.Create(nil);

    with tmp do
    try
      if Self.FTitle<>'' then Caption:=Self.FTitle;

      PersistOptions:=Self.FPersist;
      TheTree:=Self.FTree;
      N3.Free;
      Position:=Self.FPosition;

      if Self.FMaximized then
         WindowState:=wsMaximized;

      TreeHideEditorPanels(tmp,FHide);

      tmp.DoTranslate;

      ShowModal;
    finally
      Free;
    end;

    if Assigned(FOnClose) then
       FOnClose(Self);
  end;
end;

procedure TTreeEditor.Edit6Click(Sender: TObject);
begin
  EditTreeConnection(Self,TheTree.Connections.Selected,False);
  SetToolBars;
  TeeModified;
end;

Function TTreeEditor.SelectedBorder:TTreePen;
begin
  with TheTree do
  if Assigned(Connections.Selected) then
     result:=Connections.Selected.Border
  else
  With Selected do
       if Count>0 then result:=Items[0].Border else result:=nil;
end;

procedure TTreeEditor.ComboPenStyleChange(Sender: TObject);
var tmp    : Boolean;
    ThePen : TTreePen;
begin
  ThePen:=SelectedBorder;

  TreeUndo.Add(ThePen,ComboPenStyle.Hint);

  tmp:=False;
  if IsWindowsNT and
     (ComboPenStyle.ItemIndex=ComboPenStyle.Items.Count-1) then
        ThePen.SmallDots:=True
  else
  begin
    if ComboPenStyle.ItemIndex=0 then
    begin
      ThePen.Visible:=False;
    end
    else
    begin
      ThePen.Visible:=True;
      tmp:=True;
      ThePen.Style:=TPenStyle(ComboPenStyle.ItemIndex-1);
      ThePen.SmallDots:=False;
    end;
  end;
  BorderWidth.Enabled:=tmp;
  TeeModified;
end;

procedure TTreeEditor.ShapeBorderColorMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var tmpColor : TColor;
    t        : Integer;
begin
  tmpColor:=SelectedBorder.Color;
  if TeeEditColor(tmpColor) then
  begin
    TreeUndo.Add(SelectedBorder,ShapeBorderColor.Hint);

    if Assigned(TheTree.Connections.Selected) then
       TheTree.Connections.Selected.Border.Color:=tmpColor
    else
    With TheTree.Selected do
    for t:=0 to Count-1 do
       Items[t].Border.Color:=tmpColor;

    ShapeBorderColor.Brush.Color:=tmpColor;
  end;
end;

procedure TTreeEditor.ChangeBorderWidth(Sender: TTreeNodeShape);
begin
  Sender.Border.Width:=BorderWidth.Position;
end;

procedure TTreeEditor.BorderWidthChange(Sender: TObject);
begin
  if not FSetting then
  begin
    TreeUndo.Add(SelectedBorder,BorderWidth.Hint);

    if Assigned(TheTree.Connections.Selected) then
       TheTree.Connections.Selected.Border.Width:=BorderWidth.Position
    else
       TheTree.Selected.ForEach(ChangeBorderWidth);

    TeeModified;
  end;
end;

procedure TTreeEditor.ComboPenStyleDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var tmp : TColor;
begin
  if SelectedBorder<>nil then
  With TControlCanvas(ComboPenStyle.Canvas) do
  begin
    FillRect(Rect);

    if Index>0 then
    begin
      if Index<>ComboPenStyle.Items.Count-1 then
         Pen.Style:=TPenStyle(Index-1);

      Pen.Color:=SelectedBorder.Color;
      if odSelected in State then tmp:=clHighLight
                             else tmp:=ComboPenStyle.Color;
      if Pen.Color=ColorToRGB(tmp) then
         if Pen.Color=clWhite then Pen.Color:=clBlack
                              else Pen.Color:=clWhite;

      if IsWindowsNT and (Index=ComboPenStyle.Items.Count-1) then
         Pen.Handle:=TeeCreatePenSmallDots(Pen.Color);

      MoveTo(Rect.Left+4,Rect.Top+8);
      LineTo(Rect.Right-4,Rect.Top+8);
    end;
  end;
end;

procedure TTreeEditor.Bordertoolbar1Click(Sender: TObject);
begin
  SwitchVisible(BorderToolbar1,[PanelShape]);
  CheckPanelTools;
end;

procedure TTreeEditor.Delete3Click(Sender: TObject);
begin
  TheTree.Connections.Selected.Free;
end;

procedure TTreeEditor.ShapeBrushMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var tmpColor : TColor;
    t        : Integer;
begin
  with TheTree.Selected do
  if Count>0 then
  begin
    tmpColor:=First.Brush.Color;
    if TeeEditColor(tmpColor) then
    begin
      for t:=0 to Count-1 do Items[t].Brush.Color:=tmpColor;
      ShapeBrush.Brush.Color:=tmpColor;
    end;
  end;
end;

procedure TTreeEditor.ComboBrushDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);

  Function ThePicture(AIndex:Integer):TPicture;
  begin
    if (AIndex=-1) or (AIndex=Ord(tiNone)) then result:=nil
    else
    if AIndex=Ord(tiFolderOpenClose) then
       result:=TreeImagePool[Ord(tiFolderOpen)]
    else
       result:=TreeImagePool[{TTreeNodeImageIndex}(AIndex)];
  end;

var tmp : TPicture;
begin
  ComboBrush.Canvas.FillRect(Rect);
  tmp:=ThePicture(Index);
  if Assigned(tmp) then
     if tmp.Height>19 then
        ComboBrush.Canvas.StretchDraw(Rect,tmp.Graphic)
     else
        ComboBrush.Canvas.Draw(Rect.Left+1,Rect.Top+1,tmp.Graphic);
end;

procedure TTreeEditor.ChangeImageIndex(Sender: TTreeNodeShape);
begin
  Sender.ImageIndex:=TTreeNodeImageIndex(ComboBrush.ItemIndex);
end;

procedure TTreeEditor.ComboBrushChange(Sender: TObject);
begin
  TheTree.Selected.ForEach(ChangeImageIndex);
  TeeModified;
end;

procedure TTreeEditor.TabControl1Change(Sender: TObject);
begin
  with TheTree do
  begin
    Designing:=TabControl1.TabIndex=0;
    Grid.Visible:=Designing;
  end;
end;

procedure TTreeEditor.Visible1Click(Sender: TObject);
begin
  NodeTheTreeClick(Self);
end;

procedure TTreeEditor.Aligntoleft1Click(Sender: TObject);
begin
  Toogle(AlignToLeft1);
  if AlignToLeft1.Checked then
  begin
    PanelNodes.Align:=alLeft;
    Splitter1.Left:=PanelNodes.Width+8;
  end
  else PanelNodes.Align:=alRight;
  Splitter1.Align:=PanelNodes.Align;
end;

procedure TTreeEditor.PageNodesMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbRight then
     with PageNodes.ClientToScreen(Point(x,y)) do
          PopupNodeTree.Popup(x,y);
end;

procedure TTreeEditor.ComboTextChange(Sender: TObject);
var tmp     : TCustomTreeElement;
    tmpNode : TTreeNodeShape;
begin
  tmp:=TheTree.Connections.Selected;
  if not Assigned(tmp) then tmp:=TheTree.Selected.First;
   
  if Assigned(tmp) then 
  begin

    with tmp do
    if Text.Count=0 then Text.Add(ComboText.Text)
                   else Text[0]:=ComboText.Text;

    if tmp is TTreeNodeShape then
    begin
      tmpNode:=GetNodeTreeShape(TTreeNodeShape(tmp));

      if Assigned(tmpNode) then
      begin
        tmpNode.Text.Clear;
        tmpNode.Text.Add(ComboText.Text);
      end
      else Exit;
    end;

    TeeModified;
  end;
end;

procedure TTreeEditor.Delete4Click(Sender: TObject);
begin
  TheTree.Connections.Selected.Points.Delete(PopupPoint.Tag);
  TeeModified;
end;

procedure TTreeEditor.ChangeTransparent(Sender: TTreeNodeShape);
begin
  Sender.Transparent:=CBTransp.Checked;
end;

procedure TTreeEditor.CBTranspClick(Sender: TObject);
begin
  if not FSetting then
  begin
    TheTree.Selected.ForEach(ChangeTransparent);
    TeeModified;
  end;
end;

procedure TTreeEditor.Addnewpoint1Click(Sender: TObject);
begin
  with TheTree do
       Connections.Selected.Points.Add(OldCursorPos);

  TheTree.Invalidate;
  TeeModified;
end;

procedure TTreeEditor.Pattern1Click(Sender: TObject);
begin
  With TNodeTreeEditor.Create(Self) do
  try
    Tree1:=Self.TheTree;
    FormShow(Self);
    Button2Click(Self);
    Tree1:=nil;
  finally
    Free;
  end;

  SetBorderControls;
  TeeModified;
end;

procedure TTreeEditor.ChangeClipText(Sender: TTreeNodeShape);
begin
  Sender.Text.ClipText:=ClipText1.Checked;
end;

procedure TTreeEditor.ClipText1Click(Sender: TObject);
begin
  Toogle(ClipText1);
  TheTree.Selected.ForEach(ChangeClipText);
  TeeModified;
end;

procedure TTreeEditor.CBHotTrackClick(Sender: TObject);
begin
  TheTree.HotTrack.Active:=CBHotTrack.Checked;
  TeeModified;
end;

procedure TTreeEditor.CBWheelChange(Sender: TObject);
begin
  TheTree.WheelNavigation:=TTreeWheelNavigation(CBWheel.ItemIndex);
  TeeModified;
end;

procedure TTreeEditor.PopupPointPopup(Sender: TObject);
var tmpConn  : TTreeConnection;
    tmpIndex : Integer;
begin
  Automatic3.Checked:=False;
  Automatic3.Visible:=False;
  Fixed1.Checked:=False;
  Relativetostartnode1.Checked:=False;
  Relativetoendnode1.Checked:=False;

  tmpConn:=TheTree.Connections.Selected;
  tmpIndex:=PopupPoint.Tag;

  // Enable Automatic for first and last points in the connection.
  Automatic3.Visible:=(tmpIndex=0) or (tmpIndex=tmpConn.Points.Count-1);

  // Enable delete point menu item for middle points:
  Delete4.Visible:=(tmpIndex>0) and (tmpIndex<tmpConn.Points.Count-1);

  case TConnectionPoint(tmpConn.Points.Item[PopupPoint.Tag]).XStyle of
       cpsAutoFrom,
       cpsAutoTo       : Automatic3.Checked:=True;
       cpsFromPercent,
       cpsFromRel      : Relativetostartnode1.Checked:=True;
       cpsToPercent,
       cpsToRel        : Relativetoendnode1.Checked:=True;
       cpsFixed        : Fixed1.Checked:=True;
  end;
end;

// Change a connection point X and Y "Style".
procedure TTreeEditor.ChangePointStyle(AStyle:TConnectionPointStyle);
var tmpIndex : Integer;
begin
  tmpIndex:=PopupPoint.Tag;

  with TheTree.Connections.Selected.Points do
  begin
    ChangeXStyle(tmpIndex,AStyle);
    ChangeYStyle(tmpIndex,AStyle);
  end;

  TeeModified;
end;

procedure TTreeEditor.Fixed1Click(Sender: TObject);
begin
  ChangePointStyle(cpsFixed);
end;

procedure TTreeEditor.Relativetostartnode1Click(Sender: TObject);
begin
  ChangePointStyle(cpsFromRel);
end;

procedure TTreeEditor.Relativetoendnode1Click(Sender: TObject);
begin
  ChangePointStyle(cpsToRel);
end;

procedure TTreeEditor.AutoScroll1Click(Sender: TObject);
begin
  NodeTree.Selected.ScrollToView:=Toogle(AutoScroll1);
  TeeModified;
end;

procedure TTreeEditor.N110Click(Sender: TObject);
begin
  ChangeZoom(1);
end;

procedure TTreeEditor.Sendbyemail1Click(Sender: TObject);
var t : Integer;
begin { show the e-mail Send dialog }

  With TTreeExportForm.Create(nil) do
  try
    { set Tree }
    ExportPanel:=Self.TheTree;

    { execute the OnShow event to setup controls }
    FormShow(Self);

    { set JPEG format }
    if UpperCase(RGFormat.ClassName)='TRADIOGROUP' then  // TeeChart v5
    with TRadioGroup(RGFormat) do
    begin
      ItemIndex:=Items.IndexOf(TeeMsg_AsJPEG);
      if ItemIndex=-1 then ItemIndex:=1; { as Bitmap }
    end
    else
    begin  // TeeChart v6
      for t:=0 to RGFormat.ControlCount-1 do
      if RGFormat.Controls[t] is TListBox then
      begin
        with TListBox(RGFormat.Controls[t]) do
        begin
          ItemIndex:=Items.IndexOf(TeeMsg_AsJPEG);
          if ItemIndex=-1 then ItemIndex:=1; { as Bitmap }
        end;
        break;
      end;
    end;

    { Change email subject and attachment file name }
    EmailName:=TeeMsg_TeeTreePalette;

    { emulate click on Send button }
    BSendClick(Self);
  finally
    Free;
  end;
end;

procedure TTreeEditor.Timer1Timer(Sender: TObject);
{$IFNDEF LINUX}

  Procedure CheckKey(AKey,APanel:Integer; Const AText:String);
  begin
    if GetKeyState(AKey)<>0 then StatusBar1.Panels[APanel].Text:=AText
                            else StatusBar1.Panels[APanel].Text:='';
  end;

{$ENDIF}

begin { refresh the status bar key lock panels }
  {$IFNDEF LINUX}
  CheckKey(VK_CAPITAL,stPanelCaps,TreeMsg_Caps);
  CheckKey(VK_NUMLOCK,stPanelNum,TreeMsg_NUM);
  CheckKey(VK_SCROLL, stPanelScr,TreeMsg_SCR);
  {$ENDIF}
end;

procedure TTreeEditor.FormResize(Sender: TObject);
begin
  StatusBar1.Panels[stPanelText].Width:=Width-446;
end;

procedure TTreeEditor.BGridColorClick(Sender: TObject);
begin
  TeeModified;
end;

procedure TTreeEditor.BSelectedColorClick(Sender: TObject);
begin
  CBSelectedColorDef.Checked:=False;
  TeeModified;
end;

procedure TTreeEditor.BSelectedTextClick(Sender: TObject);
begin
  CBSelectedTextDef.Checked:=False;
  TeeModified;
end;

procedure TTreeEditor.BUnFocusedColorClick(Sender: TObject);
begin
  CBSelectedTextDef.Checked:=False;
  TeeModified;
end;

procedure TTreeEditor.TheTreeMovingShape(Sender: TTreeNodeShape;
  var DeltaX, DeltaY: Integer);
begin
  TeeModified;
end;

procedure TTreeEditor.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
  if FModified then
  begin
    CanClose:=CheckSave;
    if CanClose and FModified then
    begin
      Save1Click(Self);
      CanClose:=not FModified;
    end;
  end
  else CanClose:=True;
end;

procedure TTreeEditor.TheTreeResizingShape(Sender: TTreeNodeShape;
  ACorner: TTreeShapeHandle; var DeltaX, DeltaY: Integer);
begin
  AutoSize1.Checked:=False;
  TeeModified;
end;

procedure TTreeEditor.PopupMenuPanelPopup(Sender: TObject);
begin { setup popup menu for Tree Panel options }
  With TheTree do
  begin
    PanelBorder.Checked:=BorderStyle=bsSingle;
    CreateColorBitmap(PanelColor,Color);

    PanelGradient.Tag:=ObjectToTag(Gradient);

    if HasBackImage then
       PanelBackImage.Tag:=ObjectToTag(BackImage)
    else
       PanelBackImage.Tag:=0;

    { bevel }
    Case BevelOuter of
      bvLowered: Lower1.Checked:=True;
      bvRaised: Raise1.Checked:=True;
    else
      None1.Checked:=True;
    end;
  end;
end;

procedure TTreeEditor.PanelBackimageClick(Sender: TObject);
begin
  DoLoadTreeImage;
end;

procedure TTreeEditor.Image1Click(Sender: TObject);
var t : Integer;
begin
  if TheTree.Selected.Count=0 then
     PanelBackImageClick(Sender)
  else
  with PictureDialog do
  try
    if Execute then
    begin
      with TheTree.Selected do
      for t:=0 to Count-1 do Items[t].Image.LoadFromFile(FileName);
      TeeModified;
    end;
  finally
    Free;
  end;
end;

procedure TTreeEditor.None1Click(Sender: TObject);
begin { change the Tree bevel style }
  if Sender=Lower1 then TheTree.BevelOuter:=bvLowered else
  if Sender=Raise1 then TheTree.BevelOuter:=bvRaised else
                        TheTree.BevelOuter:=bvNone;
  TeeModified;
end;

procedure TTreeEditor.PanelBorderClick(Sender: TObject);
begin { show / hide Tree panel border }
  Toogle(PanelBorder);
  CBBorder.Checked:=PanelBorder.Checked;
  if PanelBorder.Checked then TheTree.BorderStyle:=bsSingle
                         else TheTree.BorderStyle:=bsNone;
  TeeModified;
end;

procedure TTreeEditor.PanelColorClick(Sender: TObject);
var tmpColor : TColor;
begin { edit Tree panel color }
  tmpColor:=TheTree.Color;

  if TeeEditColor(tmpColor) then
  begin
    TheTree.Color:=tmpColor;
    TheTree.Gradient.Visible:=False;
    CreateColorBitmap(PanelColor,tmpColor);
    ButtonColor1.Repaint;
    TeeModified;
  end;
end;

procedure TTreeEditor.PanelGradientClick(Sender: TObject);
begin { edit Tree panel gradient... }
  if TTeeGradientEditor.Edit(Self,TheTree.Gradient) then TeeModified;
end;

procedure TTreeEditor.HotTrack1Click(Sender: TObject);
begin { enable / disable HotTracking }
  Toogle(HotTrack1);
  CBHotTrack.Checked:=HotTrack1.Checked;
  TheTree.HotTrack.Active:=HotTrack1.Checked;
  TeeModified;
end;

procedure TTreeEditor.ShowHints1Click(Sender: TObject);
begin { enable / disable HotTracking }
  Toogle(ShowHints1);
  CBShowHint.Checked:=ShowHints1.Checked;
  TheTree.ShowHintShapes:=CBShowHint.Checked;
  TeeModified;
end;

procedure TTreeEditor.Transparent2Click(Sender: TObject);
begin
  Transparent1Click(Sender);
end;

procedure TTreeEditor.TimerButtonTimer(Sender: TObject);
begin
  TimerButton.Enabled:=False;
  SpeedNormal.Down:=True;
end;

procedure TTreeEditor.PopupFormatPopup(Sender: TObject);
begin { setup popup menu for Node format options }
  With TheTree.Selected.First do
  begin
    Border2.Tag:=ObjectToTag(Border);
    Gradient2.Tag:=ObjectToTag(Gradient);
    Image2.Tag:=ObjectToTag(Image);
    Font2.Tag:=ObjectToTag(Font);
    Pattern2.Tag:=ObjectToTag(Brush);

    CreateColorBitmap(Color2,Color);
    CreateColorBitmap(BackColor1,BackColor);
    Transparent2.Checked:=Transparent;
    Autosize1.Checked:=AutoSize;
    Cliptext2.Checked:=Text.ClipText;
    Pattern2.Hint:=IntToStr(BackColor);

    Case ShowCross of
      scAuto   : Automatic1.Checked:=True;
      scAlways : Always1.Checked:=True;
    else
      Never1.Checked:=True;
    end;
  end;
end;

procedure TTreeEditor.Border2Click(Sender: TObject);
begin
  Border1Click(Sender);
end;

procedure TTreeEditor.Color2Click(Sender: TObject);
begin
  Color1Click(Sender);
end;

procedure TTreeEditor.Font2Click(Sender: TObject);
begin
  Font1Click(Sender);
end;

procedure TTreeEditor.Gradient2Click(Sender: TObject);
var t : Integer;
begin
  if TTeeGradientEditor.Edit(nil,TheTree.Selected.First.Gradient) then
     with TheTree.Selected do
          for t:=1 to Count-1 do
              Items[t].Gradient.Assign(First.Gradient);

  TeeModified;
  TheTree.Invalidate;
end;

procedure TTreeEditor.Image2Click(Sender: TObject);
begin
  Image1Click(Sender);
end;

procedure TTreeEditor.Pattern2Click(Sender: TObject);
begin
  Pattern1Click(Sender);
end;

procedure TTreeEditor.ChangeAutoSize(Sender: TTreeNodeShape);
begin
  Sender.AutoSize:=AutoSize1.Checked;
end;

procedure TTreeEditor.Autosize1Click(Sender: TObject);
begin
  Toogle(AutoSize1);
  TheTree.Selected.ForEach(ChangeAutoSize);
  TeeModified;
end;

procedure TTreeEditor.ChangeClipText2(Sender: TTreeNodeShape);
begin
  Sender.Text.ClipText:=ClipText2.Checked;
end;

procedure TTreeEditor.Cliptext2Click(Sender: TObject);
begin
  Toogle(ClipText2);
  TheTree.Selected.ForEach(ChangeClipText2);
  TeeModified;
end;

procedure TTreeEditor.Never1Click(Sender: TObject);
var t : Integer;
begin
  with TheTree.Selected do
  for t:=0 to Count-1 do
    if Sender=Automatic1 then Items[t].ShowCross:=scAuto else
    if Sender=Always1 then Items[t].ShowCross:=scAlways else
       Items[t].ShowCross:=scNever;
  TeeModified;
end;

procedure TTreeEditor.Shadow2Click(Sender: TObject);
begin
  Shadow1Click(Sender);
end;

procedure TTreeEditor.PopupConnFormatPopup(Sender: TObject);
begin
  With TheTree.Connections.Selected do
  begin
    Border3.Tag:=ObjectToTag(Border);
    Font3.Tag:=ObjectToTag(Font);

    case Style of
     csAuto          : Automatic2.Checked:=True;
     csLine          : Line1.Checked:=True;
     csSides         : Sides1.Checked:=True;
     csInvertedSides : InvertedSides1.Checked:=True;
     csCurve         : Curve1.Checked:=True;
    end;
  end;
end;

procedure TTreeEditor.Border3Click(Sender: TObject);
begin
  if TPenDialog.Edit(nil,TheTree.Connections.Selected.Border) then
     TeeModified;
end;

procedure TTreeEditor.EditConnectionPage(NumPage:Integer);
begin
  With TConnectionEditor.Create(Self) do
  try
    Connection:=TheTree.Connections.Selected;
    Multiple:=False;
    PageControl1.ActivePage:=PageControl1.Pages[NumPage];
    PageControl1Change(Self);
    ShowModal;
  finally
    Free;
  end;
end;

procedure TTreeEditor.Points1Click(Sender: TObject);
begin
  EditConnectionPage(4);
end;

procedure TTreeEditor.Font3Click(Sender: TObject);
begin
  if TTeeFontEditor.Edit(Self,TheTree.Connections.Selected.Font) then
     TeeModified;
end;

procedure TTreeEditor.ButtonSaveClick(Sender: TObject);
begin
  Save1Click(Sender);
end;

procedure TTreeEditor.ButtonZoomOutClick(Sender: TObject);
begin
  DoZoom(-10);
end;

procedure TTreeEditor.Inspector1Click(Sender: TObject);
begin
  SwitchVisible(Inspector1,[PanelInspector]);
  CheckPanelNodes;
end;

procedure TTreeEditor.SpeedButton5Click(Sender: TObject);
var t    : Integer;
    tmp  : Integer;
    tmp2 : Integer;
begin
  With TheTree.Selected do
  if Count>1 then
  begin
    tmp:=Items[0].Width;
    for t:=1 to Count-1 do
    begin
      tmp2:=Items[t].Width;
      if Sender=SpeedButton5 then
      begin
        if tmp2<tmp then tmp:=tmp2
      end
      else
        if tmp2>tmp then tmp:=tmp2;
    end;

    for t:=0 to Count-1 do Items[t].Width:=tmp;
    TeeModified;
  end;
end;

procedure TTreeEditor.SpeedButton7Click(Sender: TObject);
var t    : Integer;
    tmp  : Integer;
    tmp2 : Integer;
begin
  With TheTree.Selected do
  if Count>1 then
  begin
    tmp:=Items[0].Height;
    for t:=1 to Count-1 do
    begin
      tmp2:=Items[t].Height;
      if Sender=SpeedButton7 then
      begin
        if tmp2<tmp then tmp:=tmp2
      end
      else
        if tmp2>tmp then tmp:=tmp2;
    end;

    for t:=0 to Count-1 do Items[t].Height:=tmp;
    TeeModified;
  end;
end;

procedure TTreeEditor.PageTreeChange(Sender: TObject);
begin { enable / disable alignment and resizing buttons }
  if PageTree.ActivePage=TabSheet5 then
     EnableControls(TheTree.Selected.Count>1,
        [SpeedButton1,SpeedButton2,SpeedButton3,SpeedButton4,
        SpeedButton5,SpeedButton6,SpeedButton7,SpeedButton8]);
end;

procedure TTreeEditor.Fromarrow1Click(Sender: TObject);
begin
  EditConnectionPage(1);
end;

procedure TTreeEditor.ToArrow1Click(Sender: TObject);
begin
  EditConnectionPage(2);
end;

procedure TTreeEditor.Text2Click(Sender: TObject);
begin
  EditConnectionPage(3);
end;

procedure TTreeEditor.CBRulersUnitsClick(Sender: TObject);
begin
  HorizRuler.ShowUnits:=CBRulersUnits.Checked;
  VertRuler.ShowUnits:=CBRulersUnits.Checked;
end;

procedure TTreeEditor.CBPrintPanelClick(Sender: TObject);
begin
  PrintTeePanel:=CBPrintPanel.Checked;
end;

procedure TTreeEditor.BPageBorderClick(Sender: TObject);
begin
  TeeModified;
end;

procedure TTreeEditor.BHandleColorClick(Sender: TObject);
begin
  TeeModified;
end;

procedure TTreeEditor.BHandlePenClick(Sender: TObject);
begin
  TeeModified;
end;

procedure TTreeEditor.BGridPenClick(Sender: TObject);
begin
  TeeModified;
end;

procedure TTreeEditor.BGridBigPenClick(Sender: TObject);
begin
  TeeModified;
end;

procedure TTreeEditor.Button3Click(Sender: TObject);
begin
  TeeModified;
end;

procedure TTreeEditor.ButtonColor1Click(Sender: TObject);
begin
  TeeModified;
end;

procedure TTreeEditor.BCrossBorderClick(Sender: TObject);
begin
  TeeModified;
end;

procedure TTreeEditor.BCrossColorClick(Sender: TObject);
begin
  TeeModified;
end;

procedure TTreeEditor.SignPenButtonClick(Sender: TObject);
begin
  TeeModified;
end;

procedure TTreeEditor.SetPageControls;
begin
  with TheTree.Page do
  begin
    UDPageWidth.Position:=Width;
    UDPageHeight.Position:=Height;
  end;
end;

procedure TTreeEditor.CBPrinterDefaultClick(Sender: TObject);
begin
  TheTree.Page.UsePrinter:=CBPrinterDefault.Checked;
  EnablePageControls;
  if TheTree.Page.UsePrinter then SetPageControls;
  TeeModified;
end;

procedure TTreeEditor.EPageWidthChange(Sender: TObject);
begin
  if Showing and (not Creating) and
     (TheTree.Page.Width<>UDPageWidth.Position) then
  begin
    TheTree.Page.Width:=UDPageWidth.Position;
    TeeModified;
  end;
end;

procedure TTreeEditor.EPageHeightChange(Sender: TObject);
begin
  if Showing and (not Creating) and
     (TheTree.Page.Height<>UDPageHeight.Position) then
  begin
    TheTree.Page.Height:=UDPageHeight.Position;
    TeeModified;
  end;
end;

procedure TTreeEditor.SpeedPolygonClick(Sender: TObject);
begin
  { start drawing polygon }
  TTreeAccess(TheTree).IPolygonMode:=TPolygonShapeClass(PTreeTagShape(TSpeedButton(Sender).Tag).AClass);
  TTreeAccess(TheTree).IZoomPriority:=False;
end;

procedure TTreeEditor.Curve1Click(Sender: TObject);
begin
  with TheTree.Connections.Selected do
  if Sender=Automatic2 then Style:=csAuto else
  if Sender=Line1 then Style:=csLine else
  if Sender=Sides1 then Style:=csSides else
  if Sender=InvertedSides1 then Style:=csInvertedSides else
  if Sender=Curve1 then Style:=csCurve;
end;

procedure TTreeEditor.CBPrintPageBorderClick(Sender: TObject);
begin
  TheTree.Page.Border.Print:=CBPrintPageBorder.Checked;
  TeeModified;
end;

procedure TTreeEditor.CBScrollFlatClick(Sender: TObject);
begin
  if not FSetting then
  begin
    TheTree.HorzScrollBar.Flat:=CBScrollFlat.Checked;
    TheTree.VertScrollBar.Flat:=CBScrollFlat.Checked;
    TeeModified;
  end;
end;

procedure TTreeEditor.CBUnitsChange(Sender: TObject);
begin
  HorizRuler.Units:=TRulerUnits(CBUnits.ItemIndex);
  VertRuler.Units:=HorizRuler.Units;
end;

procedure TTreeEditor.BackColor1Click(Sender: TObject);
var tmp : TColor;
begin
  With TNodeTreeEditor.Create(Self) do
  try
    Tree1:=Self.TheTree;
    FormShow(Self);
    BBackColor.Click;
    Tree1:=nil;
  finally
    Free;
  end;
  tmp:=TheTree.Selected.First.BackColor;
  Pattern2.Hint:=IntToStr(tmp);
  CreateColorBitmap(TMenuItem(Sender),tmp);
  TeeModified;
end;

procedure TTreeEditor.Copyaspicture1Click(Sender: TObject);
begin
  TheTree.CopyToClipboardBitmap;
end;

procedure TTreeEditor.ComboTextDropDown(Sender: TObject);
var tmp : TCustomTreeElement;
begin
  tmp:=TheTree.Connections.Selected;
  if not Assigned(tmp) then tmp:=TheTree.Selected.First;

  if Assigned(tmp) then
  begin
    TreeEditText(Self,tmp);
    ComboText.Text:=tmp.SimpleText;
    ComboText.Update;
  end;
end;

procedure TTreeEditor.SBFontGradClick(Sender: TObject);
var t : Integer;
begin
  With TheTree do
  if Assigned(Connections.Selected) then
  begin
    if TTeeGradientEditor.Edit(Self,Connections.Selected.Font.Gradient) then
       TeeModified;
  end
  else
  if TTeeGradientEditor.Edit(Self,Selected.First.Font.Gradient) then
  begin
    for t:=1 to Selected.Count-1 do
        Selected[t].Font.Gradient:=Selected.First.Font.Gradient;
        
    TeeModified;
  end;
end;

procedure TTreeEditor.PaintBox1Paint(Sender: TObject);
var tmpCanvas : TTeeCanvas3D;
    tmpG      : TTeeGradient;
begin
  if PaintBox1.Enabled and Assigned(TheTree) then
  begin
    With TheTree do
    if Assigned(Connections.Selected) then
       tmpG:=Connections.Selected.Font.Gradient
    else
    if (Selected.First<>nil) then
       tmpG:=Selected.First.Font.Gradient
    else
    begin
      PaintBox1.Enabled:=False;
      exit;
    end;

    tmpCanvas:=TTeeCanvas3D.Create;
    try
      tmpCanvas.ReferenceCanvas:=PaintBox1.Canvas;
      tmpG.Draw(tmpCanvas,PaintBox1.ClientRect);
    finally
      tmpCanvas.Free;
    end;
  end;
end;

procedure TTreeEditor.ComboFontSizeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key=TeeKey_Return then
     ComboFontSizeChange(Sender);
end;

procedure TTreeEditor.ComboFontSizeExit(Sender: TObject);
begin
  ComboFontSizeChange(Sender);
end;

procedure TTreeEditor.UDZoomClick(Sender: TObject; Button: TUDBtnType);
begin
  TheTree.View3DOptions.Zoom:=UDZoom.Position;
  TrackBarZoom.Position:=UDZoom.Position;
  RefreshZoomLabel;
end;

procedure TTreeEditor.CBTextEnabledClick(Sender: TObject);
begin
  if not Creating then
  begin
    TheTree.TextEditor.Enabled:=CBTextEnabled.Checked;
    TeeModified;
  end;
end;

procedure TTreeEditor.CBTextModeChange(Sender: TObject);
begin
  if not Creating then
  begin
    TheTree.TextEditor.Mode:=TTreeTextEditorMode(CBTextMode.ItemIndex);
    TeeModified;
  end;
end;

procedure TTreeEditor.CBTextKeyChange(Sender: TObject);
begin
  if not Creating then
  begin
    TheTree.TextEditor.ShortCut:=TextToShortCut(CBTextKey.Text);
    TeeModified;
  end;
end;

procedure TTreeEditor.CBTextMouseChange(Sender: TObject);
begin
  if not Creating then
  begin
    TheTree.TextEditor.MouseButton:=TMouseButton(CBTextMouse.ItemIndex);
    TeeModified;
  end;
end;

procedure TTreeEditor.CBTextSizeClick(Sender: TObject);
begin
  if not Creating then
  begin
    TheTree.TextEditor.UseNodeSize:=CBTextSize.Checked;
    TeeModified;
  end;
end;

procedure TTreeEditor.CBTextFormatClick(Sender: TObject);
begin
  if not Creating then
  begin
    TheTree.TextEditor.UseNodeFormat:=CBTextFormat.Checked;
    TeeModified;
  end;
end;

procedure TTreeEditor.CBTextFontClick(Sender: TObject);
begin
  if not Creating then
  begin
    TheTree.TextEditor.UseNodeFont:=CBTextFont.Checked;
    TeeModified;
  end;
end;

procedure TTreeEditor.Automatic3Click(Sender: TObject);
begin
  if PopupPoint.Tag=0 then ChangePointStyle(cpsAutoFrom)
                      else ChangePointStyle(cpsAutoTo);
end;

// Change current connection style
procedure TTreeEditor.Curve2Click(Sender: TObject);
var tmp : TTreeConnectionStyle;
begin
  if Sender=Linestyle1 then tmp:=csLine else
  if Sender=Sidesstyle1 then tmp:=csSides else
  if Sender=Invertedsidesstyle1 then tmp:=csInvertedSides else
  if Sender=Curve2 then tmp:=csCurve else
     tmp:=csAuto;

  TheTree.Connections.Selected.Style:=tmp;
  TeeModified;
end;

procedure TTreeEditor.PopupConnPopup(Sender: TObject);
begin
  case TheTree.Connections.Selected.Style of
    csAuto          : Automatic4.Checked:=True;
    csLine          : Linestyle1.Checked:=True;
    csSides         : SidesStyle1.Checked:=True;
    csInvertedSides : Invertedsidesstyle1.Checked:=True;
    csCurve         : Curve2.Checked:=True;
  end;

  with TheTree.Connections.Selected.ToShape do
       Automatic4.Visible:=AutoPosition.Left and AutoPosition.Top;
end;

{ TTreeUndo }

procedure TTreeUndo.Add(ASource: TPersistent; const AText: String);
begin
  if Assigned(ASource) then 
  with TTreeUndoItem(TCollection(Self).Add) do
  begin
    Source:=ASource;
    Text:=AText;
    StoreCopy;
  end;
end;

Function TTreeUndo.Last:TTreeUndoItem;
begin
  result:=TTreeUndoItem(Items[Count-1]);
end;

procedure TTreeUndo.Undo;
begin
  if Count>0 then
  begin
    Last.Undo;
    Delete(Count-1);
  end;
end;

{ TTreeUndoItem }

destructor TTreeUndoItem.Destroy;
begin
  FStore.Free;
  inherited;
end;

procedure TTreeUndoItem.StoreCopy;
begin
  FStore:=TPersistent(Source.ClassType.Create);
  FStore.Assign(Source);
end;

procedure TTreeUndoItem.Undo;
begin
  Source.Assign(FStore);
end;

{ TTreeEditorPanel }

Constructor TTreeEditorPanel.Create(AOwner: TComponent);
begin
  inherited;
  BevelOuter:=bvNone;
  FHide:=[teEditors];
end;

Procedure TTreeEditorPanel.Loaded;
begin
  inherited;
  if not (csDesigning in ComponentState) then
     CreateEditor;
end;

Destructor TTreeEditorPanel.Destroy;
begin
  FEditor.Free;
  inherited;
end;

procedure TTreeEditorPanel.SetHide(Value: TTreeEditWindows);
begin
  if FHide<>Value then
  begin
    FHide:=Value;
    if not (csDesigning in ComponentState) then
       TreeHideEditorPanels(FEditor,FHide);
  end;
end;

procedure TTreeEditorPanel.SetTree(const Value: TCustomTree);

  Function IsNodeTree:Boolean;
  begin
    result:=Assigned(FEditor) and (Value=FEditor.NodeTree);
  end;

begin
  if (Value=nil) or (not IsNodeTree) then
  begin
    inherited;
    if Assigned(Tree) and Assigned(FEditor) then
       FEditor.TheTree:=Tree;
  end;
end;

Procedure TTreeEditorPanel.CreateEditor;
begin
  FEditor:=TTreeEditor.Create(nil);

  with FEditor do
  begin
    TheTree:=Self.Tree;
    if Assigned(TheTree) then
       TheTree.Parent:=PanelTree;

    DisableAlign;
    BorderStyle:=TeeFormBorderStyle;
    BorderIcons:=[];
    Align:=alClient;
    Parent:=Self;

    if not (csDesigning in ComponentState) then
    begin
      PersistOptions:=False;
      Visible:=True;
      EnableAlign;
    end;
  end;

  TreeHideEditorPanels(FEditor,FHide);
end;

function TTreeEditorPanel.GetEditor: TTreeEditor;
begin
  if not Assigned(FEditor) then CreateEditor;
  result:=FEditor;
end;

procedure TTreeEditorPanel.PreviewMode;
begin
  Editor.TabControl1.TabIndex:=1;
  Editor.TabControl1Change(Editor.TabControl1);
end;

procedure TTreeEditor.SBCloseInspectorClick(Sender: TObject);
begin
  Inspector1Click(Self);
end;

procedure TTreeEditor.PanelInspectorResize(Sender: TObject);
begin
  SBCloseInspector.Left:=PanelInspector.Width-20;
  SBCloseNodeTree.Left:=PanelInspector.Width-20;
end;

procedure TTreeEditor.SBCloseNodeTreeClick(Sender: TObject);
begin
  NodeTheTreeClick(Self);
end;

procedure TTreeEditor.Shadow3Click(Sender: TObject);
begin { edit Tree panel shadow... }
  if EditTeeShadow(Self,TheTree.Shadow) then
     TeeModified;
end;

procedure TTreeEditor.Chamfer1Click(Sender: TObject);
begin
  ChangeStyle(tssChamfer);
end;

procedure TTreeEditor.FormDestroy(Sender: TObject);

  procedure ClearToolShapes;
  var t,tt : Integer;
      ATab : TTabSheet;
  begin
    for t:=0 to PageShapes.PageCount-1 do
    begin
      ATab:=PageShapes.Pages[t];

      for tt:=0 to ATab.ControlCount-1 do
      With ATab.Controls[tt] do
      begin
        if Tag>0 then
        begin
          PTreeTagShape(Tag)^.AInstance.Free;

          Dispose(PTreeTagShape(Tag));
        end;
      end;
    end;
  end;

begin
  { remove and free shapes from toolbar }
  ClearToolShapes;

  FreeAndNil(FRecentFiles);
  TreeUndo.Free;
end;

procedure TTreeEditor.CBRenderClick(Sender: TObject);

  function FindGDIPlus:TCanvas3DClass;
  var t   : Integer;
      tmp : TCanvas3DClass;
  begin
    result:=TTeeCanvas3D;

    for t:=0 to TeeRenderClasses.Count-1 do
    begin
      tmp:={$IFNDEF D18}TCanvas3DClass{$ENDIF}(TeeRenderClasses[t]);

      if tmp.ClassName=TeeGDIPlusCanvasName then
      begin
        result:=tmp;
        break;
      end;
    end;
  end;

begin
  if not FSetting then
  begin
    if CBRender.Checked then
       TheTree.Canvas:=FindGDIPlus.Create
    else
       TheTree.Canvas:=TTeeCanvas3D.Create;

    TeeModified;
  end;
end;

initialization
  RegisterCustomTreeShape('Standard','Polygon',TPolygonShape);
  RegisterCustomTreeShape('Standard','PolyLine',TPolyLineShape);
  RegisterCustomTreeShape('Standard','Image',TImageShape);
  RegisterCustomTreeShape('Standard','Text',TTextShape);
finalization
  UnRegisterCustomTreeShapes([TPolygonShape,TPolyLineShape,TImageShape]);
end.

