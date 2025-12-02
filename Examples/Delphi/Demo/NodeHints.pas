unit NodeHints;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, StdCtrls, TeeTree, TreeEd, ExtCtrls, TeeProcs, TeeGDIPlus;

type
  TNodeHintsForm = class(TBaseForm)
    CheckBox1: TCheckBox;
    Panel2: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    Splitter1: TSplitter;
    procedure Tree1ShowHint(Sender: TCustomTree; Shape: TTreeNodeShape;
      var Text: String);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TNodeHintsForm.Tree1ShowHint(Sender: TCustomTree;
  Shape: TTreeNodeShape; var Text: String);
begin
  // Example: Add an exclamation to hint text.
  // To disable displaying hint, set Text to empty string ( Text:='' )
  Text:=Text+' !';

  // Show hint text in label3...
  Label3.Caption:=Text;
end;

procedure TNodeHintsForm.CheckBox1Click(Sender: TObject);
begin
  Tree1.ShowHintShapes:=CheckBox1.Checked;
end;

procedure TNodeHintsForm.FormCreate(Sender: TObject);
begin
  inherited;

  // Format options...
  Application.HintColor:=clLime;
  Tree1.GlobalFormat.Border.Visible:=False;
  Tree1.GlobalFormat.Font.Size:=10;

  // Add some sample nodes

  with Tree1.Add('5 Continents') do
  begin
    AddChild('The Africa continent').AddChild('Kenia');
    AddChild('The America continent').AddChild('Argentina');
    AddChild('The Asia continent').AddChild('China');
    AddChild('The Australia continent').AddChild('New Zealand');
    AddChild('The Europe continent').AddChild('Slovenia');
  end;

  Tree1.FullExpandCollapse(True);
end;

procedure TNodeHintsForm.FormResize(Sender: TObject);
begin
  inherited;

  // Force a small Tree size to show the effect of "Hints"
  // when passing the mouse over a node that can not be fully displayed.
  Tree1.Width:=125;
end;

initialization
  RegisterClass(TNodeHintsForm);
end.
