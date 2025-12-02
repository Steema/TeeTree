unit NodeShadow;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TreeFlow, TeeTree, TreeTransit, ComCtrls, StdCtrls, TeCanvas,
  TreeEd, ExtCtrls, TeeProcs;

type
  TNodeShadowForm = class(TBaseForm)
    ButtonColor1: TButtonColor;
    Label1: TLabel;
    Edit1: TEdit;
    UpDown1: TUpDown;
    Label2: TLabel;
    Edit2: TEdit;
    UpDown2: TUpDown;
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    CrossShape1: TCrossShape;
    EnvelopeShape1: TEnvelopeShape;
    ArrowRightShape1: TArrowRightShape;
    CallOutShape1: TCallOutShape;
    StopShape1: TStopShape;
    GridShape1: TGridShape;
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonColor1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TNodeShadowForm.Edit1Change(Sender: TObject);
var t: Integer;
begin
  for t:=0 to Tree1.Shapes.Count-1 do
      Tree1[t].Shadow.HorizSize:=UpDown1.Position;
end;

procedure TNodeShadowForm.Edit2Change(Sender: TObject);
var t: Integer;
begin
  for t:=0 to Tree1.Shapes.Count-1 do
      Tree1[t].Shadow.VertSize:=UpDown2.Position;
end;

procedure TNodeShadowForm.FormCreate(Sender: TObject);
begin
  inherited;
  ButtonColor1.LinkProperty(TreeNodeShape1.Shadow,'Color');
end;

procedure TNodeShadowForm.ButtonColor1Click(Sender: TObject);
var t: Integer;
begin
  for t:=0 to Tree1.Shapes.Count-1 do
      Tree1[t].Shadow.Color:=ButtonColor1.SymbolColor;
end;

initialization
  RegisterClass(TNodeShadowForm);
end.
