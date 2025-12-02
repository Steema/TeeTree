unit TreeRuler;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, StdCtrls, TeeTree, TreeEd, ExtCtrls, TeeProcs, ComCtrls, TeCanvas,
  TreeElectric, TreeFlow;

type
  TTreeRulerForm = class(TBaseForm)
    TreeRuler1: TTreeRuler;
    TreeRuler2: TTreeRuler;
    CheckBox1: TCheckBox;
    CBRulersUnits: TCheckBox;
    CBUnits: TComboFlat;
    Edit1: TEdit;
    UpDown1: TUpDown;
    Label1: TLabel;
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TextShape1: TTextShape;
    TextShape2: TTextShape;
    TreeNodeShape3: TTreeNodeShape;
    TextShape3: TTextShape;
    PolygonShape1: TPolygonShape;
    ManualOperationShape1: TManualOperationShape;
    DocumentShape1: TDocumentShape;
    GroundShape1: TGroundShape;
    Button1: TButton;
    FontDialog1: TFontDialog;
    procedure CheckBox1Click(Sender: TObject);
    procedure CBRulersUnitsClick(Sender: TObject);
    procedure CBUnitsChange(Sender: TObject);
    procedure Tree1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Tree1Scroll(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TTreeRulerForm.CheckBox1Click(Sender: TObject);
begin
  // Show / Hide rulers
  TreeRuler1.Visible:=CheckBox1.Checked;
  TreeRuler2.Visible:=CheckBox1.Checked;
end;

procedure TTreeRulerForm.CBRulersUnitsClick(Sender: TObject);
begin
  // Show / Hide ruler units
  TreeRuler1.ShowUnits:=CBRulersUnits.Checked;
  TreeRuler2.ShowUnits:=CBRulersUnits.Checked;
end;

procedure TTreeRulerForm.CBUnitsChange(Sender: TObject);
begin
  // Change display units (pixels, centimeters or inches)
  // For custom ruler units, see TreeRuler OnGetUnit event
  TreeRuler1.Units:=TRulerUnits(CBUnits.ItemIndex);
  TreeRuler2.Units:=TreeRuler1.Units;
end;

procedure TTreeRulerForm.Tree1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  // When the mouse is moved inside Tree, tell rulers to
  // repaint the red marker
  TreeRuler1.DoMouseMove(x,y);
  TreeRuler2.DoMouseMove(x,y);
end;

procedure TTreeRulerForm.FormCreate(Sender: TObject);
begin
  inherited;

  // Dont forget to set the Rulers Tree property
  TreeRuler1.Tree:=Tree1;
  TreeRuler2.Tree:=Tree1;

  CBUnits.ItemIndex:=0;
end;

procedure TTreeRulerForm.Edit1Change(Sender: TObject);
begin
  // Change Tree Grid Step (in pixels)
  Tree1.Grid.Step:=UpDown1.Position;
  TreeRuler1.Invalidate;
  TreeRuler2.Invalidate;
end;

procedure TTreeRulerForm.Tree1Scroll(Sender: TObject);
begin
  // When the Tree is scrolled, repaint rulers
  TreeRuler1.Invalidate;
  TreeRuler2.Invalidate;
end;

procedure TTreeRulerForm.Button1Click(Sender: TObject);
begin
  with FontDialog1 do
  begin
    Font:=TreeRuler1.Font;
    if Execute then
    begin
      TreeRuler1.Font:=Font;
      TreeRuler2.Font:=Font;
    end;
  end;
end;

initialization
  RegisterClass(TTreeRulerForm);
end.
