unit Starting;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, StdCtrls, ExtCtrls, TeeProcs, TeeTree, TreeEd;

type
  TStartingForm = class(TBaseForm)
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TStartingForm.Button2Click(Sender: TObject);
begin
  TreeEdit1.Execute;
end;

procedure TStartingForm.Button1Click(Sender: TObject);
begin
  // Add one node and one child...

  Tree1.Add('Hello').AddChild('World !');

  // Expand first node...
  Tree1.Roots[0].Expanded:=True;

  // Select first node...
  Tree1.Roots[0].Selected:=True;

  // Set Tree1 focus...
  Tree1.SetFocus;
end;

procedure TStartingForm.CheckBox1Click(Sender: TObject);
var t : Integer;
begin
  // Show / Hide all nodes Border...
  for t:=0 to Tree1.Shapes.Count-1 do
      Tree1.Shapes[t].Border.Visible:=CheckBox1.Checked;
end;

initialization
  RegisterClass(TStartingForm);
end.
