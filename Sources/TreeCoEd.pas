{**********************************************}
{   TTree Component - Connections Editor       }
{   Copyright (c) 1998-2025 by Steema Software }
{**********************************************}
{$I TeeDefs.inc}
unit TreeCoEd;

interface

uses
  {$IFNDEF LINUX}
  Windows, Messages,
  {$ENDIF}
  SysUtils, Classes,

  Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons,
  TeeTree, TeCanvas, TeeProcs, TeePenDlg, TeeEdiGrad, TeeCustomShapeEditor;

type
  TConnectionEditorProc=Procedure(Sender:TTreeConnection) of object;

  TConnectionEditor = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    RGStyle: TRadioGroup;
    TabSheet2: TTabSheet;
    RGFromStyle: TRadioGroup;
    Button4: TButton;
    Label1: TLabel;
    UpDownFrom: TUpDown;
    Edit1: TEdit;
    TabSheet3: TTabSheet;
    RGToStyle: TRadioGroup;
    Button6: TButton;
    Label2: TLabel;
    Edit2: TEdit;
    UpDownTo: TUpDown;
    TabSheet4: TTabSheet;
    BFromColor: TButtonColor;
    BToColor: TButtonColor;
    ButtonPen1: TButtonPen;
    CheckBox1: TCheckBox;
    ButtonPen2: TButtonPen;
    ButtonPen3: TButtonPen;
    TabSheet5: TTabSheet;
    LBPoints: TListBox;
    Label3: TLabel;
    GroupX: TGroupBox;
    GroupY: TGroupBox;
    Label4: TLabel;
    EXValue: TEdit;
    Label5: TLabel;
    EYValue: TEdit;
    RBFixedX: TRadioButton;
    RBRelFromX: TRadioButton;
    RBPrevX: TRadioButton;
    RBNextX: TRadioButton;
    RBNextY: TRadioButton;
    RBPrevY: TRadioButton;
    RBRelFromY: TRadioButton;
    RBFixedY: TRadioButton;
    UDX: TUpDown;
    UDY: TUpDown;
    SpeedButton1: TSpeedButton;
    BDeletePoint: TSpeedButton;
    RBRelToX: TRadioButton;
    RBRelToY: TRadioButton;
    CBAutoPoint: TCheckBox;
    Panel1: TPanel;
    Button1: TButton;
    BBack: TButton;
    CBBack: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure RGStyleClick(Sender: TObject);
    procedure RGFromStyleClick(Sender: TObject);
    procedure RGToStyleClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure LBPointsClick(Sender: TObject);
    procedure RBAutoXClick(Sender: TObject);
    procedure EXValueChange(Sender: TObject);
    procedure EYValueChange(Sender: TObject);
    procedure RBAutoYClick(Sender: TObject);
    procedure BDeletePointClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure CBAutoPointClick(Sender: TObject);
    procedure BBackClick(Sender: TObject);
    procedure CBBackClick(Sender: TObject);
  private
    { Private declarations }
    Creating : Boolean;
    procedure ClearAllRadios;
    Procedure FillPoints;
    Procedure SetArrowFromBorder(Sender:TTreeConnection);
    Procedure SetArrowFromBrush(Sender:TTreeConnection);
    Procedure SetArrowFromSize(Sender:TTreeConnection);
    Procedure SetArrowFromStyle(Sender:TTreeConnection);
    Procedure SetArrowToBorder(Sender:TTreeConnection);
    Procedure SetArrowToBrush(Sender:TTreeConnection);
    Procedure SetArrowToSize(Sender:TTreeConnection);
    Procedure SetArrowToStyle(Sender:TTreeConnection);
    Procedure SetConnectionBorder(Sender:TTreeConnection);
    Procedure SetConnectionStyle(Sender:TTreeConnection);
    Procedure SetOther(Proc:TConnectionEditorProc);
    procedure SetStyleControls;
  public
    { Public declarations }
    Multiple   : Boolean;
    Connection : TTreeConnection;
  end;

Procedure EditTreeConnection( AOwner:TComponent;
                              AConnection:TTreeConnection;
                              ChangeMultiple:Boolean=False);

implementation

{$IFNDEF LCL}
{$R *.DFM}
{$ELSE}
{$R *.lfm}
{$ENDIF}

Uses
  TeeConst, TreeConst, TeeBrushDlg, TreeTeEd;

Procedure EditTreeConnection( AOwner:TComponent;
                              AConnection:TTreeConnection;
                              ChangeMultiple:Boolean=False);
begin
  With TConnectionEditor.Create(AOwner) do
  try
    Connection:=AConnection;
    Multiple:=ChangeMultiple;
    ShowModal;
  finally
    Free;
  end;
end;

procedure TConnectionEditor.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TConnectionEditor.FormCreate(Sender: TObject);
begin
  Multiple:=False;
  Creating:=True;
  PageControl1.ActivePage:=TabSheet1;
  TreeTranslateControl(Self);
end;

procedure TConnectionEditor.SetStyleControls;
begin
  RGStyle.Enabled:=not CheckBox1.Checked;

  if RGStyle.Enabled then
     Case Connection.Style of
       csLine          : RGStyle.ItemIndex:=0;
       csSides         : RGStyle.ItemIndex:=1;
       csInvertedSides : RGStyle.ItemIndex:=2;
       csCurve         : RGStyle.ItemIndex:=3;
     end;
end;

procedure TConnectionEditor.FormShow(Sender: TObject);
begin
  if Assigned(Connection) then
  With Connection do
  begin
    CheckBox1.Checked:=Style=csAuto;

    SetStyleControls;

    ButtonPen1.LinkPen(Border);

    With ArrowFrom do
    begin
      ButtonPen2.LinkPen(Border);
      RGFromStyle.ItemIndex:=Ord(Style);
      UpDownFrom.Position:=Size;
    end;

    With ArrowTo do
    begin
      ButtonPen3.LinkPen(Border);
      RGToStyle.ItemIndex:=Ord(Style);
      UpDownTo.Position:=Size;
    end;

    Self.Caption:=SysUtils.Format(TeeMsg_Editing,[Name]);
    BFromColor.LinkProperty(ArrowFrom,'BackColor');
    BToColor.LinkProperty(ArrowTo,'BackColor');

    CBBack.Checked:=Format.Visible;

    FillPoints;
  end;

  Creating:=False;
end;

Procedure TConnectionEditor.SetConnectionBorder(Sender:TTreeConnection);
begin
  Sender.Border.Assign(Connection.Border);
end;

procedure TConnectionEditor.Button2Click(Sender: TObject);
begin
  SetOther(SetConnectionBorder);
end;

Procedure TConnectionEditor.SetArrowFromBorder(Sender:TTreeConnection);
begin
  Sender.ArrowFrom.Border.Assign(Connection.ArrowFrom.Border);
end;

procedure TConnectionEditor.Button3Click(Sender: TObject);
begin
  SetOther(SetArrowFromBorder);
end;

Procedure TConnectionEditor.SetArrowToBorder(Sender:TTreeConnection);
begin
  Sender.ArrowTo.Border.Assign(Connection.ArrowTo.Border);
end;

procedure TConnectionEditor.Button5Click(Sender: TObject);
begin
  SetOther(SetArrowToBorder);
end;

Procedure TConnectionEditor.SetArrowToBrush(Sender:TTreeConnection);
begin
  Sender.ArrowTo.Brush.Assign(Connection.ArrowTo.Brush);
end;

procedure TConnectionEditor.Button6Click(Sender: TObject);
begin
  TBrushDialog.Edit(Self,Connection.ArrowTo.Brush);
  SetOther(SetArrowToBrush);
end;

Procedure TConnectionEditor.SetArrowFromBrush(Sender:TTreeConnection);
begin
  Sender.ArrowFrom.Brush.Assign(Connection.ArrowFrom.Brush);
end;

procedure TConnectionEditor.Button4Click(Sender: TObject);
begin
  TBrushDialog.Edit(Self,Connection.ArrowFrom.Brush);
  SetOther(SetArrowFromBrush);
end;

Procedure TConnectionEditor.SetArrowFromSize(Sender:TTreeConnection);
begin
  Sender.ArrowFrom.Size:=Connection.ArrowFrom.Size;
end;

procedure TConnectionEditor.Edit1Change(Sender: TObject);
begin
  if not Creating then
  begin
    Connection.ArrowFrom.Size:=UpDownFrom.Position;
    SetOther(SetArrowFromSize);
  end;
end;

Procedure TConnectionEditor.SetArrowToSize(Sender:TTreeConnection);
begin
  Sender.ArrowTo.Size:=Connection.ArrowTo.Size;
end;

procedure TConnectionEditor.Edit2Change(Sender: TObject);
begin
  if not Creating then
  begin
    Connection.ArrowTo.Size:=UpDownTo.Position;
    SetOther(SetArrowToSize);
  end;
end;

Procedure TConnectionEditor.SetConnectionStyle(Sender:TTreeConnection);
begin
  Sender.Style:=Connection.Style;
end;

procedure TConnectionEditor.RGStyleClick(Sender: TObject);
begin
  case RGStyle.ItemIndex of
    0: Connection.Style:=csLine;
    1: Connection.Style:=csSides;
    2: Connection.Style:=csInvertedSides;
    3: Connection.Style:=csCurve;
  end;

  SetOther(SetConnectionStyle);

  Application.ProcessMessages;
  FillPoints;
end;

Procedure TConnectionEditor.SetArrowFromStyle(Sender:TTreeConnection);
begin
  Sender.ArrowFrom.Style:=Connection.ArrowFrom.Style;
end;

procedure TConnectionEditor.RGFromStyleClick(Sender: TObject);
begin
  Connection.ArrowFrom.Style:=TConnectionArrowStyle(RGFromStyle.ItemIndex);
  SetOther(SetArrowFromStyle);
end;

Procedure TConnectionEditor.SetArrowToStyle(Sender:TTreeConnection);
begin
  Sender.ArrowTo.Style:=Connection.ArrowTo.Style;
end;

procedure TConnectionEditor.RGToStyleClick(Sender: TObject);
begin
  if not Creating then
  begin
    Connection.ArrowTo.Style:=TConnectionArrowStyle(RGToStyle.ItemIndex);
    SetOther(SetArrowToStyle);
  end;
end;

Procedure TConnectionEditor.SetOther(Proc:TConnectionEditorProc);
var t : Integer;
begin
  if Multiple then
  With Connection.FromShape do
  for t:=0 to Connections.Count-1 do
      if Connection<>Connections[t] then Proc(Connections[t]);
end;

procedure TConnectionEditor.PageControl1Change(Sender: TObject);
var tmp : TFormTeeText;
begin
  if PageControl1.ActivePage=TabSheet4 then
  With TabSheet4 do
  if ControlCount=0 then
  begin
    tmp:=TFormTeeText.Create(Self);
    tmp.Tree1:=Self.Connection.Tree;
    tmp.Connection1:=Self.Connection;

    TTeeVCL.AddFormTo(tmp,TabSheet4);
    tmp.PageControl1.ActivePage:=tmp.TabSheet1;
    tmp.ReAlign;
  end;
end;

procedure TConnectionEditor.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked then Connection.Style:=csAuto
                       else Connection.Style:=csLine;
  SetStyleControls;
  SetOther(SetConnectionStyle);
end;

procedure TConnectionEditor.LBPointsClick(Sender: TObject);
begin
  Creating:=True;

  GroupX.Enabled:=True;
  GroupY.Enabled:=True;

  with Connection.Points.Item[LBPoints.ItemIndex] do
  begin
    UDX.Position:=XValue;
    UDY.Position:=YValue;

    ClearAllRadios;

    CBAutoPoint.Enabled:=(LBPoints.ItemIndex=0) or
                         (LBPoints.ItemIndex=Connection.Points.Count-1);

    CBAutoPoint.Checked:= (XStyle=cpsAutoFrom) or (XStyle=cpsAutoTo) or
                          (YStyle=cpsAutoFrom) or (YStyle=cpsAutoTo);


    GroupX.Enabled:=not CBAutoPoint.Checked;
    GroupY.Enabled:=GroupX.Enabled;

    case XStyle of
      cpsFromPercent,
      cpsFromRel   : RBRelFromX.Checked:=True;
      cpsToPercent,
      cpsToRel     : RBRelToX.Checked:=True;
      cpsPrevious  : RBPrevX.Checked:=True;
      cpsNext      : RBNextX.Checked:=True;
      cpsFixed     : RBFixedX.Checked:=True;
    end;

    case YStyle of
      cpsFromPercent,
      cpsFromRel   : RBRelFromY.Checked:=True;
      cpsToPercent,
      cpsToRel     : RBRelToY.Checked:=True;
      cpsPrevious  : RBPrevY.Checked:=True;
      cpsNext      : RBNextY.Checked:=True;
      cpsFixed     : RBFixedY.Checked:=True;
    end;
  end;

  // Enable deleting points when there are at least 2
  BDeletePoint.Enabled:=LBPoints.Items.Count>1;

  Creating:=False;
end;

procedure TConnectionEditor.RBAutoXClick(Sender: TObject);
var tmpStyle : TConnectionPointStyle;
begin
  if Sender=RBPrevX then tmpStyle:=cpsPrevious else
  if Sender=RBNextX then tmpStyle:=cpsNext else
  if Sender=RBRelFromX then tmpStyle:=cpsFromRel else
  if Sender=RBRelToX then tmpStyle:=cpsToRel
  else
    tmpStyle:=cpsFixed;

  Connection.Points.ChangeXStyle(LBPoints.ItemIndex,tmpStyle);
end;

procedure TConnectionEditor.EXValueChange(Sender: TObject);
begin
  if not Creating then
  begin
    Connection.Points.Item[LBPoints.ItemIndex].XValue:=UDX.Position;
    Connection.Repaint;
  end;
end;

procedure TConnectionEditor.EYValueChange(Sender: TObject);
begin
  if not Creating then
  begin
    Connection.Points.Item[LBPoints.ItemIndex].YValue:=UDY.Position;
    Connection.Repaint;
  end;
end;

procedure TConnectionEditor.RBAutoYClick(Sender: TObject);
var tmpStyle : TConnectionPointStyle;
begin
  if Sender=RBPrevY then tmpStyle:=cpsPrevious else
  if Sender=RBNextY then tmpStyle:=cpsNext else
  if Sender=RBRelFromY then tmpStyle:=cpsFromRel else
  if Sender=RBRelToY then tmpStyle:=cpsToRel
  else
     tmpStyle:=cpsFixed;

  Connection.Points.ChangeYStyle(LBPoints.ItemIndex,tmpStyle);
end;

procedure TConnectionEditor.BDeletePointClick(Sender: TObject);
begin
  Connection.Points.Delete(LBPoints.ItemIndex);
  FillPoints;
end;

Procedure TConnectionEditor.FillPoints;
var t : Integer;
begin
  LBPoints.Clear;
  for t:=0 to Connection.Points.Count-1 do
      LBPoints.Items.Add(TreeMsg_Point+' '+TeeStr(t));

  if LBPoints.Items.Count>0 then
  begin
    LBPoints.ItemIndex:=0;
    LBPointsClick(Self);
  end;
end;

procedure TConnectionEditor.SpeedButton1Click(Sender: TObject);
begin
  Connection.Points.Add(0,0);
  FillPoints;
  LBPoints.ItemIndex:=LBPoints.Items.Count-1;
  LBPointsClick(Self);
end;

procedure TConnectionEditor.ClearAllRadios;
begin
  RBFixedX.Checked:=False;
  RBRelFromX.Checked:=False;
  RBPrevX.Checked:=False;
  RBNextX.Checked:=False;
  RBRelToX.Checked:=False;
  RBFixedY.Checked:=False;
  RBRelFromY.Checked:=False;
  RBPrevY.Checked:=False;
  RBNextY.Checked:=False;
  RBRelToY.Checked:=False;
end;

procedure TConnectionEditor.CBAutoPointClick(Sender: TObject);
var tmpStyle : TConnectionPointStyle;
begin
  if CBAutoPoint.Checked then
  begin
    if LBPoints.ItemIndex=0 then tmpStyle:=cpsAutoFrom
                            else tmpStyle:=cpsAutoTo
  end
  else
    if LBPoints.ItemIndex=0 then tmpStyle:=cpsFromRel
                            else tmpStyle:=cpsToRel;

  Connection.Points.ChangeXStyle(LBPoints.ItemIndex,tmpStyle);
  Connection.Points.ChangeYStyle(LBPoints.ItemIndex,tmpStyle);

  LBPointsClick(Self);
end;

procedure TConnectionEditor.BBackClick(Sender: TObject);
begin
  TFormTeeShape.Edit(Self, Connection.Format, True);
end;

procedure TConnectionEditor.CBBackClick(Sender: TObject);
begin
  Connection.Format.Visible:=CBBack.Checked;
end;

end.
