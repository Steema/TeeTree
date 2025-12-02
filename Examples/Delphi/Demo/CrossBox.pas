unit CrossBox;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs, TeCanvas, TeePenDlg,
  ComCtrls, TeeBrushDlg;

type
  TCrossBoxForm = class(TBaseForm)
    CheckBox1: TCheckBox;
    ButtonPen1: TButtonPen;
    ButtonPen2: TButtonPen;
    Panel2: TPanel;
    RadioGroup1: TRadioGroup;
    Label1: TLabel;
    LabelNode: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    UpDown1: TUpDown;
    ComboFlat1: TComboFlat;
    Label3: TLabel;
    Label4: TLabel;
    Edit2: TEdit;
    UpDown2: TUpDown;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Tree1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure CheckBox1Click(Sender: TObject);
    procedure Tree1SelectShape(Sender: TTreeNodeShape);
    procedure Tree1UnSelectShape(Sender: TTreeNodeShape);
    procedure RadioGroup1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure ComboFlat1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TCrossBoxForm.FormCreate(Sender: TObject);
begin
  inherited;

  Tree1.GlobalFormat.Border.Visible:=False;

  // Sample nodes:
  Tree1.Add('Africa').Add('Kenia');
  Tree1.Add('America').Add('USA').Add('Los Angeles');
  Tree1.Add('Asia').Add('Japan').Add('Tokyo');
  Tree1.Add('Australia').Add('Sydney');
  Tree1.Add('Europe').Add('Norway').Add('Oslo');

  // Set-up buttons:
  ButtonPen1.LinkPen(Tree1.CrossBox.Border);
  ButtonPen2.LinkPen(Tree1.CrossBox.SignPen);

  // Set-up UpDowns:
  UpDown1.Position:=TeeDefaultBoxSize;
  UpDown2.Position:=TeeCrossBoxHorizMargin;

  ComboFlat1.ItemIndex:=0;
end;

procedure TCrossBoxForm.Tree1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var t : Integer;
begin
  Tree1.Canvas.Calculate2DPosition(x,y,0);

  Tree1.Cursor:=crDefault;

  for t:=0 to Tree1.Shapes.Count-1 do
      if Tree1[t].CrossBoxClicked(x,y) then
      begin
        Tree1.Cursor:=crHandPoint;
        break;
      end;

  Tree1.OriginalCursor:=Tree1.Cursor;
end;

procedure TCrossBoxForm.CheckBox1Click(Sender: TObject);
begin
  Tree1.ShowRootCross:=CheckBox1.Checked;
end;

procedure TCrossBoxForm.Tree1SelectShape(Sender: TTreeNodeShape);
begin
  LabelNode.Caption:=Sender.SimpleText;
  RadioGroup1.Enabled:=True;
  RadioGroup1.ItemIndex:=Ord(Sender.ShowCross);
end;

procedure TCrossBoxForm.Tree1UnSelectShape(Sender: TTreeNodeShape);
begin
  LabelNode.Caption:='';
  RadioGroup1.Enabled:=False;
  RadioGroup1.ItemIndex:=-1;
end;

procedure TCrossBoxForm.RadioGroup1Click(Sender: TObject);
begin
  Case RadioGroup1.ItemIndex of
    0: Tree1.Selected.First.ShowCross:=scAuto;
    1: Tree1.Selected.First.ShowCross:=scAlways;
    2: Tree1.Selected.First.ShowCross:=scNever;
  end;
end;

procedure TCrossBoxForm.Edit1Change(Sender: TObject);
begin
  Tree1.CrossBox.Size:=UpDown1.Position;
end;

procedure TCrossBoxForm.ComboFlat1Change(Sender: TObject);
begin
  Case ComboFlat1.ItemIndex of
    0: Tree1.CrossBox.Style:=cbsSquare;
    1: Tree1.CrossBox.Style:=cbsDiamond;
    2: Tree1.CrossBox.Style:=cbsCircle;
  end;
end;

procedure TCrossBoxForm.Edit2Change(Sender: TObject);
begin
  with TTreeExplorerAlignChild(Tree1.GlobalFormat.ChildManager) do
       CrossMargin:=UpDown2.Position;
  Tree1.Invalidate;
end;

procedure TCrossBoxForm.Button1Click(Sender: TObject);
begin
  TBrushDialog.Edit(Self,Tree1.CrossBox.Brush);
end;

initialization
  RegisterClass(TCrossBoxForm);
end.
