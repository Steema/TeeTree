unit Unit_FMX_Tree;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Rtti, System.Classes,
  System.Variants, FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs,
  FMX.Layouts, System.Math, FMX.ListBox, System.DateUtils,

  FMXTee.Tree, FMXTee.Procs,
  FMX.StdCtrls, FMX.Objects, FMXTee.Series;

type
  TFireMonkey_TeeTree_Form = class(TForm)
    CheckBox2: TCheckBox;
    Label1: TLabel;
    ComboBox1: TComboBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    Label2: TLabel;
    TrackBar1: TTrackBar;
    Label3: TLabel;
    ComboBox2: TComboBox;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    ListBoxItem7: TListBoxItem;
    CheckBox1: TCheckBox;
    CheckBox3: TCheckBox;
    Label4: TLabel;
    Image1: TImage;
    Label5: TLabel;
    ListBoxItem8: TListBoxItem;
    Label6: TLabel;
    Button1: TButton;
    Label7: TLabel;
    TrackBar2: TTrackBar;
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
  private
    { Private declarations }

    Tree1 : TTree;

    procedure PopulateTree;
    procedure SelectedNode(Sender:TTreeNodeShape);
  public
    { Public declarations }
  end;

var
  FireMonkey_TeeTree_Form: TFireMonkey_TeeTree_Form;

implementation

{$R *.fmx}

uses
  Unit_FMX_Tree_Columns, System.Diagnostics;

procedure TFireMonkey_TeeTree_Form.Button1Click(Sender: TObject);
begin
  with TTreeColumns.Create(Self) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TFireMonkey_TeeTree_Form.CheckBox1Change(Sender: TObject);
begin
  Tree1.Gradient.Visible:=CheckBox1.IsChecked;
end;

// Show or hide node connection lines:
procedure TFireMonkey_TeeTree_Form.CheckBox2Change(Sender: TObject);
var t : Integer;
    Manager : TTreeExplorerAlignChild;
begin
  for t := 0 to Tree1.Items.Count-1 do
      Tree1.Items[t].Connections.Visible:=CheckBox2.IsChecked;

  // Advanced: Change ChildManager properties:
  Manager:=(Tree1.GlobalFormat.ChildManager as TTreeExplorerAlignChild);

  if CheckBox2.IsChecked then
     Manager.HorizMargin:=19
  else
     Manager.HorizMargin:=9
end;

procedure TFireMonkey_TeeTree_Form.CheckBox3Change(Sender: TObject);
begin
  if CheckBox3.IsChecked then
  begin
    Tree1.BevelOuter:=TPanelBevel.bvLowered;
    Tree1.BevelInner:=TPanelBevel.bvLowered;
  end
  else
  begin
    Tree1.BevelOuter:=TPanelBevel.bvNone;
    Tree1.BevelInner:=TPanelBevel.bvNone;
  end;
end;

// Show or hide node images:
procedure TFireMonkey_TeeTree_Form.ComboBox1Change(Sender: TObject);
begin
  case ComboBox1.ItemIndex of
    0: Tree1.CrossBox.SignStyle:=cssCross;
    1: Tree1.CrossBox.SignStyle:=cssTriangle;
  end;

  Tree1.CrossBox.Visible:=ComboBox1.ItemIndex<>2;
end;

// Show or hide node images (Cross, Radio, CheckBox styles)
procedure TFireMonkey_TeeTree_Form.ComboBox2Change(Sender: TObject);
var tmpImageIndex : TTreeNodeImageIndex;
    t : Integer;
begin
  case ComboBox2.ItemIndex of
    0: tmpImageIndex:=TTreeNodeImageIndex.tiFolderOpenClose;
    1: tmpImageIndex:=TTreeNodeImageIndex.tiRadioChecked;
    2: tmpImageIndex:=TTreeNodeImageIndex.tiChecked;
    3: tmpImageIndex:=TTreeNodeImageIndex.tiFolderCloseChecked;
  else
    tmpImageIndex:=TTreeNodeImageIndex.tiNone;
  end;

  for t := 0 to Tree1.Items.Count-1 do
      Tree1.Items[t].ImageIndex:=tmpImageIndex;
end;

// Populate Tree with many nodes in 3 levels:
procedure TFireMonkey_TeeTree_Form.PopulateTree;
var
  t: Integer;
  tt: Integer;
  ttt: Integer;

  Root, Child : TTreeNodeShape;
begin

  // Add 20500 sample nodes (500x10x3 + 500x10 + 500) :
  Tree1.BeginUpdate;
  try

    // Add 50 root nodes:
    for t := 0 to 499 do
    begin
      Root:=Tree1.AddRoot('Node '+IntToStr(t));

      // Add 10 Child nodes:
      for tt := 0 to 9 do
      begin
        Child:=Root.Add('Child '+IntToStr(tt));

        // Add 3 Grand Child nodes:
        for ttt := 0 to 2 do
            Child.Add('Grand Child '+IntToStr(ttt));
      end;
    end;

  finally
    Tree1.EndUpdate;
  end;
end;

// Create a TTree control
procedure TFireMonkey_TeeTree_Form.FormCreate(Sender: TObject);
var t1 : TStopWatch;
begin
  // Create a Tree control manually:
  Tree1:=TTree.Create(Self);
  Tree1.BoundsRect:=RectF(20,50,250,350);
  Tree1.Parent:=Self;

  // Define default node formatting ***BEFORE ADDING ITEMS***
  Tree1.GlobalFormat.Border.Hide;
  Tree1.GlobalFormat.Transparent:=True;
  Tree1.GlobalFormat.Connection.ArrowTo.Style:=TConnectionArrowStyle.casNone;

  t1:=TStopWatch.StartNew;
  PopulateTree;
  t1.Stop;

  Label4.Text:='Time to add '+IntToStr(Tree1.Items.Count)+' nodes: '+
               FormatFloat('0.###',t1.ElapsedMilliseconds)+' milliseconds';

  // More Tree cosmetics:
  Tree1.Gradient.Visible:=True;
  Tree1.Gradient.StartColor:=TAlphaColors.Silver;
  Tree1.Gradient.EndColor:=TAlphaColors.Cream;

  // Disable right-mouse scroll drag
  Tree1.AllowPanning:=TPanningMode.pmNone;

  // Disable left-mouse zoom drag
  Tree1.Zoom.Allow:=False;

  // Per-node settings:
  Tree1.Roots[3].Font.Color:=TAlphaColors.Red;
  Tree1.Roots[6].ImageIndex:=TTreeNodeImageIndex.tiComputer;

  // Example settings:
  TrackBar1.Value:=Tree1.GlobalFormat.Font.Size;

  // Example event:
  Tree1.OnSelectShape:=SelectedNode;
end;

procedure TFireMonkey_TeeTree_Form.Image1Click(Sender: TObject);
begin
  TeeGotoURL(0,'http://www.steema.com');
end;

// Called when a node is selected by mouse or keyboard:
procedure TFireMonkey_TeeTree_Form.SelectedNode(Sender:TTreeNodeShape);
var tmp : Integer;
begin
  tmp:=Tree1.Items.IndexOf(Sender);

  Label4.Text:='Selected node: '+Sender.SimpleText+' Index: '+IntToStr(tmp);
end;

// Change all nodes Font size:
procedure TFireMonkey_TeeTree_Form.TrackBar1Change(Sender: TObject);
var t : Integer;
begin
  for t := 0 to Tree1.Items.Count-1 do
      Tree1[t].Font.Size:=TrackBar1.Value;
end;

procedure TFireMonkey_TeeTree_Form.TrackBar2Change(Sender: TObject);
begin
  (Tree1.GlobalFormat.ChildManager as TTreeExplorerAlignChild).VertMargin:=Round(TrackBar2.Value);
  Tree1.Invalidate;
end;

end.
