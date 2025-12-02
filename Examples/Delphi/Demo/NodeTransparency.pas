unit NodeTransparency;
{$I TeeDefs.inc}

interface

uses
  Windows, Messages,
  SysUtils, Classes,
  Graphics, Controls, Forms, Dialogs, ExtCtrls, StdCtrls,
  Base, TeeTree, TreeFlow, TreeEd, TeeProcs;

type
  TNodeTranspForm = class(TBaseForm)
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    CrossShape1: TCrossShape;
    StarShape1: TStarShape;
    TreeNodeShape3: TTreeNodeShape;
    PolygonShape1: TPolygonShape;
    CheckBox1: TCheckBox;
    Timer1: TTimer;
    procedure CheckBox1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TNodeTranspForm.CheckBox1Click(Sender: TObject);
begin
  Timer1.Enabled:=CheckBox1.Checked;
end;

procedure TNodeTranspForm.Timer1Timer(Sender: TObject);
var t : Integer;
begin
  // Animate transparency.
  for t:=0 to Tree1.Shapes.Count-1 do
  with Tree1[t] do
  begin
    if Tag=0 then Tag:=4;

    if (Transparency<4) or (Transparency>96) then
       Tag:=-Tag;

    Transparency:=Transparency+Tag;
  end;
end;

initialization
  RegisterClass(TNodeTranspForm);
end.
