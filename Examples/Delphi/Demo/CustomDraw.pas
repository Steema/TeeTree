unit CustomDraw;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs;

type
  TCustomDrawForm = class(TBaseForm)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeShape3: TTreeNodeShape;
    TreeNodeShape4: TTreeNodeShape;
    procedure Tree1AfterDraw(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Tree1BeforeDraw(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TCustomDrawForm.Tree1AfterDraw(Sender: TObject);
var t : Integer;
begin
  if CheckBox2.Checked then
     with Tree1.Canvas do
     begin
       Pen.Style:=psSolid;
       Pen.Color:=clBlack;
       Pen.Width:=2;

       for t:=1 to 10 do
           LineWithZ(0,0,t*Random(40),t*Random(30),0);
     end;
end;

procedure TCustomDrawForm.CheckBox2Click(Sender: TObject);
begin
  Tree1.Invalidate;
end;

procedure TCustomDrawForm.CheckBox1Click(Sender: TObject);
begin
  Tree1.Invalidate;
end;

procedure TCustomDrawForm.Tree1BeforeDraw(Sender: TObject);
var t : Integer;
begin
  if CheckBox1.Checked then
     with Tree1.Canvas do
     begin
       Pen.Style:=psSolid;
       Pen.Color:=clRed;
       Pen.Width:=2;

       for t:=1 to 10 do
           LineWithZ( Tree1.Width, Tree1.Height,
                      Tree1.Width-(t*Random(40)),
                      Tree1.Height-(t*Random(30)),0);
     end;
end;

initialization
  RegisterClass(TCustomDrawForm);
end.
