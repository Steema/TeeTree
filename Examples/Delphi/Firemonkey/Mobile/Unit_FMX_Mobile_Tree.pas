unit Unit_FMX_Mobile_Tree;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs,
  FMXTee.Tree, FMX.StdCtrls, System.DateUtils, FMXTee.Procs, FMX.Objects,
  FMX.Layouts;

type
  TTeeTree_Mobile_Form = class(TForm)
    Label4: TLabel;
    Image1: TImage;
    Layout1: TLayout;
    TrackBar1: TTrackBar;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    Tree1 : TTree;

    procedure PopulateTree;
    procedure TreeScroll(Sender:TObject);
  public
    { Public declarations }
  end;

var
  TeeTree_Mobile_Form: TTeeTree_Mobile_Form;

implementation

{$R *.fmx}

uses Unit_FMX_Mobile_Tree_Settings;

procedure TTeeTree_Mobile_Form.PopulateTree;
var
  t: Integer;
  tt: Integer;
  ttt: Integer;

  Root, Child : TTreeNodeShape;
begin
  // Add 20050 sample nodes (50x10x3 + 50x10 + 50) :
  Tree1.BeginUpdate;
  try

    // Add 500 root nodes:
    for t := 0 to 49 do
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

    {$IFDEF IOS}

    // Resize for iOS:
    for t := 0 to Tree1.Items.Count-1 do
    with Tree1.Items[t] do
    begin
      ImageHeight:=24;
      ImageWidth:=24;
    end;

    Tree1.CrossBox.Size:=8;

    {$ENDIF}
  finally
    Tree1.EndUpdate;
  end;
end;

procedure TTeeTree_Mobile_Form.TrackBar1Change(Sender: TObject);
var tmp : Single;
begin
  tmp:=TrackBar1.Value*0.01;
//  Tree1.Scale.X:=tmp;
//  Tree1.Scale.Y:=tmp;

  Tree1.View3DOptions.ZoomFloat:=tmp*100;
end;

procedure TTeeTree_Mobile_Form.Button1Click(Sender: TObject);
begin
  SettingsForm.Tree:=Tree1;
  SettingsForm.Show;
end;

procedure TTeeTree_Mobile_Form.FormCreate(Sender: TObject);
// Create a TTree control
var t1 : TDateTime;
begin
  // Create a Tree control manually:
  Tree1:=TTree.Create(Self);
  //Tree1.BoundsRect:=RectF(20,50,250,350);
  Tree1.Align:=TAlignLayout.alClient;
  Tree1.Parent:=Self;

  Tree1.Zoom.Allow:=False;
  Tree1.AllowPanning:=TPanningMode.pmVertical;
  Tree1.ScrollMouseButton:=TMouseButton.mbLeft;

  Tree1.OnScroll:=TreeScroll;

//  Tree1.Touch.InteractiveGestures:=[TInteractiveGesture.igPan];

  // Define default node formatting ***BEFORE ADDING ITEMS***
  Tree1.GlobalFormat.Border.Hide;
  Tree1.GlobalFormat.Transparent:=True;
  Tree1.GlobalFormat.Connection.ArrowTo.Style:=TConnectionArrowStyle.casNone;

  Tree1.GlobalFormat.ImageIndex:=tiNone;

  Tree1.CrossBox.SignStyle:=cssTriangle;

  (Tree1.GlobalFormat.ChildManager as TTreeExplorerAlignChild).VertMargin:=4;

  {$IFDEF IOS}
  Tree1.GlobalFormat.Font.Size:=20;
  {$ENDIF}

  //TreeImagePool.Image[Ord(tiFolderClose)].Assign(Image1.Bitmap);

  t1:=Now;
  PopulateTree;
  Label4.Text:='Time to add '+IntToStr(Tree1.Items.Count)+' nodes: '+
               FormatFloat('0.###',MilliSecondSpan(Now,t1))+' milliseconds';

  // More cosmetics:
  Tree1.Gradient.Visible:=True;
  Tree1.Gradient.StartColor:=TAlphaColors.Silver;
  Tree1.Gradient.EndColor:=TAlphaColors.Cream;

  // Per-node settings:
  Tree1.Roots[3].Font.Color:=TAlphaColors.Red;
  Tree1.Roots[6].ImageIndex:=TTreeNodeImageIndex.tiComputer;

  // Example settings:
  //TrackBar1.Value:=Tree1.GlobalFormat.Font.Size;

  // Example event:
//  Tree1.OnSelectShape:=SelectedNode;
end;

procedure TTeeTree_Mobile_Form.TreeScroll(Sender:TObject);
var tmp : Single;
begin
  with Tree1.View3DOptions do
  begin
    if VertOffsetFloat>0 then
       VertOffsetFloat:=0
    else
    begin
      tmp:=Tree1.TotalBounds.Height-Tree1.Height;

      if VertOffsetFloat<-tmp then
         VertOffsetFloat:=-tmp;
    end;
  end;
end;

end.
