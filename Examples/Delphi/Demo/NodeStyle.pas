unit NodeStyle;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TreeFlow, StdCtrls, TeeTree, ExtCtrls, TeeProcs, ComCtrls, TreeUML,
  TreeTransit, TreeElectric;

type
  TNodeStyleForm = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Tree2: TTree;
    TreeNodeShape10: TTreeNodeShape;
    TreeNodeShape11: TTreeNodeShape;
    TreeNodeShape12: TTreeNodeShape;
    TreeNodeShape13: TTreeNodeShape;
    TreeNodeShape14: TTreeNodeShape;
    TreeNodeShape15: TTreeNodeShape;
    TreeNodeShape16: TTreeNodeShape;
    TreeNodeShape17: TTreeNodeShape;
    TreeNodeShape18: TTreeNodeShape;
    PolygonShape1: TPolygonShape;
    PolyLineShape1: TPolyLineShape;
    ImageShape2: TImageShape;
    Memo1: TMemo;
    TabSheet2: TTabSheet;
    Tree1: TTree;
    ConditionShape1: TConditionShape;
    TitleShape1: TTitleShape;
    ProcessShape1: TProcessShape;
    SelectShape1: TSelectShape;
    DocumentShape1: TDocumentShape;
    CardShape1: TCardShape;
    DelayShape1: TDelayShape;
    ManualShape1: TManualShape;
    AndShape1: TAndShape;
    OrShape1: TOrShape;
    DataShape1: TDataShape;
    TapeShape1: TTapeShape;
    TabSheet3: TTabSheet;
    Tree3: TTree;
    PentagonShape1: TPentagonShape;
    HexagonShape1: THexagonShape;
    OctagonShape1: TOctagonShape;
    CrossShape1: TCrossShape;
    TriangleRectRightShape1: TTriangleRectRightShape;
    TriangleRectLeftShape1: TTriangleRectLeftShape;
    HouseShape1: THouseShape;
    EnvelopeShape1: TEnvelopeShape;
    RingShape1: TRingShape;
    ArrowUpShape1: TArrowUpShape;
    ArrowDownShape1: TArrowDownShape;
    ArrowLeftShape1: TArrowLeftShape;
    ArrowRightShape1: TArrowRightShape;
    CallOutShape1: TCallOutShape;
    StarShape1: TStarShape;
    GridShape1: TGridShape;
    BevelShape1: TBeveledShape;
    TabSheet4: TTabSheet;
    Tree4: TTree;
    PackageShape1: TPackageShape;
    ClassShape1: TClassShape;
    InterfaceShape1: TInterfaceShape;
    ActionShape1: TActionShape;
    ActorShape1: TActorShape;
    TabSheet5: TTabSheet;
    Tree5: TTree;
    ResistorShape1: TResistorShape;
    SolidResistorShape1: TSolidResistorShape;
    FuseShape1: TFuseShape;
    CapacitorShape1: TCapacitorShape;
    DiodeShape1: TDiodeShape;
    GroundShape1: TGroundShape;
    SourceShape1: TSourceShape;
    ChasisShape1: TChasisShape;
    OrGateShape1: TOrGateShape;
    AndGateShape1: TAndGateShape;
    LampShape1: TLampShape;
    TabSheet6: TTabSheet;
    Tree6: TTree;
    StopShape1: TStopShape;
    YieldShape1: TYieldShape;
    SlowShape1: TSlowShape;
    ProcShape1: TProcShape;
    NoteShape1: TNoteShape;
    StoreShape1: TStoreShape;
    TextShape1: TTextShape;
    PredefinedProcessShape1: TPredefinedProcessShape;
    TerminalShape1: TTerminalShape;
    ConnectorShape1: TConnectorShape;
    PunchTapeShape1: TPunchTapeShape;
    DangerShape1: TDangerShape;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TNodeStyleForm.FormCreate(Sender: TObject);
begin
  GridShape1.Cells[1,1].SimpleText:='Grid';
end;

procedure TNodeStyleForm.FormShow(Sender: TObject);
begin
  PageControl1.ActivePage:=TabSheet1;
end;

initialization
  RegisterClass(TNodeStyleForm);
end.
