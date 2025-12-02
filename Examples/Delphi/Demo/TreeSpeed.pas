unit TreeSpeed;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, StdCtrls, TeeTree, TreeEd, ExtCtrls, TeeProcs;

type
  TTreeSpeedForm = class(TBaseForm)
    Button1: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    LabelTime: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TTreeSpeedForm.Button1Click(Sender: TObject);
var StartTime,
    EndTime,
    NumNodes,
    t           : Integer;
begin
  Screen.Cursor:=crHourGlass;

  // Obtain how many nodes to add...
  NumNodes:=StrToInt(Edit1.Text);

  // Remove all existing nodes in Tree
  Tree1.Clear;

  // Optional settings to accelerate:
  // Tree1.NoOwnerShapes:=True;
  // Tree1.AssignParent:=False;

  // Get initial time
  StartTime:=GetTickCount;

  // Add nodes !!

  Tree1.BeginUpdate;  // optional (a little faster)

  with Tree1.AddRoot('Test') do
  begin
    Expanded:=True;
    for t:=1 to NumNodes do AddChild('Child '+IntToStr(t));
  end;

  Tree1.EndUpdate;   // optional

  // Get final time
  EndTime:=GetTickCount;

  // Show time difference (milliseconds)
  LabelTime.Caption:=IntToStr(EndTime-StartTime)+' msec.';

  Screen.Cursor:=crDefault;
end;

procedure TTreeSpeedForm.FormCreate(Sender: TObject);
begin
  inherited;

  // Default Format settings:
  Tree1.GlobalFormat.Border.Visible:=False;
  Tree1.GlobalFormat.Transparent:=True;

end;

initialization
  RegisterClass(TTreeSpeedForm);
end.
