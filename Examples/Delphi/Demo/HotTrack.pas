unit HotTrack;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, StdCtrls, TeeTree, TreeEd, ExtCtrls, TeeProcs, TeCanvas, TeePenDlg;

type
  THotTrackForm = class(TBaseForm)
    CheckBox1: TCheckBox;
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeShape1_TreeNodeShape2: TTreeConnection;
    TreeNodeShape3: TTreeNodeShape;
    TreeNodeShape1_TreeNodeShape3: TTreeConnection;
    TreeNodeShape4: TTreeNodeShape;
    TreeNodeShape3_TreeNodeShape4: TTreeConnection;
    TreeNodeShape5: TTreeNodeShape;
    TreeNodeShape3_TreeNodeShape5: TTreeConnection;
    TreeNodeShape6: TTreeNodeShape;
    TreeNodeShape5_TreeNodeShape6: TTreeConnection;
    TreeNodeShape7: TTreeNodeShape;
    TreeNodeShape8: TTreeNodeShape;
    TreeNodeShape7_TreeNodeShape8: TTreeConnection;
    TreeNodeShape9: TTreeNodeShape;
    TreeNodeShape7_TreeNodeShape9: TTreeConnection;
    TreeNodeShape10: TTreeNodeShape;
    TreeNodeShape7_TreeNodeShape10: TTreeConnection;
    TreeNodeShape11: TTreeNodeShape;
    TreeNodeShape10_TreeNodeShape11: TTreeConnection;
    TreeNodeShape12: TTreeNodeShape;
    TreeNodeShape12_TreeNodeShape11: TTreeConnection;
    ButtonPen1: TButtonPen;
    CheckBox2: TCheckBox;
    Button1: TButton;
    CheckBox3: TCheckBox;
    procedure CheckBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

Uses
  TeeBrushDlg, TeeEdiFont;

procedure THotTrackForm.CheckBox1Click(Sender: TObject);
begin
  // Enable / Disable hot-tracking
  Tree1.HotTrack.Active:=CheckBox1.Checked;
end;

procedure THotTrackForm.FormCreate(Sender: TObject);
var t : Integer;
begin
  inherited;

  // Enable default hot-tracking
  Tree1.HotTrack.Active:=True;

  // Remove all nodes border
  Tree1.GlobalFormat.Border.Visible:=False;

  // Set the button pen
  ButtonPen1.LinkPen(Tree1.HotTrack.Border);

  // Set all nodes horizontal text alignment to "left"
  for t:=0 to Tree1.Shapes.Count-1 do
      Tree1[t].Text.HorizAlign:=htaLeft;

  // Set default HotTrack font size
  Tree1.HotTrack.Font.Size:=14;
end;

procedure THotTrackForm.CheckBox2Click(Sender: TObject);
begin
  // Enable / Disable using HotTrack border
  Tree1.HotTrack.UseBorder:=CheckBox2.Checked;
end;

procedure THotTrackForm.Button1Click(Sender: TObject);
begin
  // Edit HotTrack font and enable it
  if TTeeFontEditor.Edit(Self,Tree1.HotTrack.Font) then
  begin
    CheckBox3.Checked:=True;
    Tree1.HotTrack.UseFont:=True;
  end;
end;

procedure THotTrackForm.CheckBox3Click(Sender: TObject);
begin
  // Enable / Disable using HotTrack font
  Tree1.HotTrack.UseFont:=CheckBox3.Checked;
end;

initialization
  RegisterClass(THotTrackForm);
end.
