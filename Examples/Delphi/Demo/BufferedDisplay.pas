unit BufferedDisplay;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, ExtCtrls, StdCtrls, TeeTree, TreeEd, TeeProcs;

type
  TBufferedDisplayForm = class(TBaseForm)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Timer1: TTimer;
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeShape1_TreeNodeShape2: TTreeConnection;
    TreeNodeShape3: TTreeNodeShape;
    TreeNodeShape1_TreeNodeShape3: TTreeConnection;
    TreeNodeShape4: TTreeNodeShape;
    TreeNodeShape5: TTreeNodeShape;
    TreeNodeShape6: TTreeNodeShape;
    TreeNodeShape5_TreeNodeShape6: TTreeConnection;
    TreeNodeShape7: TTreeNodeShape;
    TreeNodeShape6_TreeNodeShape7: TTreeConnection;
    TreeNodeShape8: TTreeNodeShape;
    TreeNodeShape6_TreeNodeShape8: TTreeConnection;
    TreeNodeShape9: TTreeNodeShape;
    TreeNodeShape6_TreeNodeShape9: TTreeConnection;
    TreeNodeShape10: TTreeNodeShape;
    TreeNodeShape11: TTreeNodeShape;
    procedure Timer1Timer(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TBufferedDisplayForm.Timer1Timer(Sender: TObject);
var tmp : Integer;
begin

  // randomly change a node font size...

  tmp:=Random(Tree1.Shapes.Count);

  with Tree1[tmp].Font do
       if Random(100)<50 then
       begin
         if Size<24 then Size:=Size+1;
       end
       else
       begin
         if Size>6 then Size:=Size-1;
       end;
end;

procedure TBufferedDisplayForm.CheckBox2Click(Sender: TObject);
begin
  Timer1.Enabled:=CheckBox2.Checked;
end;

procedure TBufferedDisplayForm.CheckBox1Click(Sender: TObject);
begin
  Tree1.BufferedDisplay:=CheckBox1.Checked;
end;

initialization
  RegisterClass(TBufferedDisplayForm);
end.
