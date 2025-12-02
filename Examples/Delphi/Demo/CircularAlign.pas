unit CircularAlign;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, ComCtrls, StdCtrls, TeeTree, TreeEd, ExtCtrls, TeeProcs,
  TreeChildManagers;

type
  TCircularAlignForm = class(TBaseForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Edit1: TEdit;
    UpDown1: TUpDown;
    Edit2: TEdit;
    UpDown2: TUpDown;
    Button1: TButton;
    Edit3: TEdit;
    UpDown3: TUpDown;
    Edit4: TEdit;
    UpDown4: TUpDown;
    Edit5: TEdit;
    UpDown5: TUpDown;
    Panel2: TPanel;
    TrackBar1: TTrackBar;
    Panel3: TPanel;
    TrackBar2: TTrackBar;
    procedure FormCreate(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure Edit5Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Circular : TTreeCircularAlignChild;
  end;

implementation

{$R *.DFM}

procedure TCircularAlignForm.FormCreate(Sender: TObject);
begin
  inherited;

  // Set to True.
  // New nodes will be assigned the same format as Parent node:
  Tree1.AssignParent:=True;

  with Tree1.AddRoot('Start') do
  begin
    // Size:
    Width:=40;
    Height:=40;

    // Position:
    X0:=200;
    Y0:=90;

    // Format:
    Style:=tssCircle;
    Color:=clRed;
    Border.Color:=clNavy;
    Border.Width:=2;
    ImageIndex:=tiNone;
    Font.Color:=clWhite;
    Font.Style:=[fsBold];
    Shadow.HorizSize:=5;
    Shadow.VertSize:=5;
    Shadow.Color:=clDkGray;

    // Expand
    Expanded:=True;
  end;

  // Change manager:
  Tree1.GlobalFormat.ChildManager.Free;
  Circular:=TTreeCircularAlignChild.Create;
  Tree1.GlobalFormat.ChildManager:=Circular;

  Circular.XRadius:=60;
  Circular.YRadius:=60;
  
  // Prepare track-bars:
  TrackBar1.Position:=Circular.XRadius;
  TrackBar2.Position:=Circular.YRadius;
end;

procedure TCircularAlignForm.Edit3Change(Sender: TObject);
begin
  Circular.TotalAngle:=UpDown3.Position;
  Tree1.Invalidate;
end;

procedure TCircularAlignForm.Edit2Change(Sender: TObject);
begin
  Circular.AngleOffset:=UpDown2.Position;
  Tree1.Invalidate;
end;

procedure TCircularAlignForm.Edit4Change(Sender: TObject);
begin
  Circular.XOffset:=UpDown4.Position;
  Tree1.Invalidate;
end;

procedure TCircularAlignForm.Edit5Change(Sender: TObject);
begin
  Circular.YOffset:=UpDown5.Position;
  Tree1.Invalidate;
end;

procedure TCircularAlignForm.Button1Click(Sender: TObject);
begin
  TreeEdit1.Execute;
end;

procedure TCircularAlignForm.TrackBar1Change(Sender: TObject);
begin
  Circular.XRadius:=TrackBar1.Position;
  Tree1.Invalidate;
end;

procedure TCircularAlignForm.TrackBar2Change(Sender: TObject);
begin
  Circular.YRadius:=TrackBar2.Position;
  Tree1.Invalidate;
end;

procedure TCircularAlignForm.Edit1Change(Sender: TObject);
var t : Integer;
begin
  // Remove children (if decrementing)
  While Tree1.Roots[0].Count>UpDown1.Position do
        Tree1.Roots[0].Children.Last.Free;

  for t:=Tree1.Roots[0].Count+1 to UpDown1.Position do
      with Tree1.Roots[0].AddChild(IntToStr(t)) do  // add child
      begin
        Width:=24;
        Height:=24;
        Color:=clGreen;
      end;
end;

initialization
  RegisterClass(TCircularAlignForm);
end.
