unit UTreeCompare;
{$I TeeDefs.inc}

interface

uses
  {$IFNDEF LINUX}
  Windows, Messages,
  {$ENDIF} 
  SysUtils, Classes,
  Graphics, Controls, Forms, Dialogs, StdCtrls, ComCtrls, ExtCtrls,

  TeeProcs, TeeTree;

{ This project compares the speed of TeeTree versus TreeView }

type
  TForm1 = class(TForm)
    Tree1: TTree;
    TreeView1: TTreeView;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label5: TLabel;
    Label6: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Button5: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
    procedure Test(NumNodes:Integer);
    function AddTeeTree(NumNodes:Integer):Integer;
    function AddTreeView(NumNodes:Integer):Integer;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$IFNDEF LCL}
{$R *.DFM}
{$ELSE}
{$R *.lfm}
{$ENDIF}

procedure TForm1.Test(NumNodes:Integer);
begin
  Screen.Cursor:=crHourGlass;
  try
    if CheckBox1.Checked then
       Label5.Caption:='Testing...'
    else
       Label5.Caption:='(not tested)';

    if CheckBox2.Checked then
       Label6.Caption:='Testing...'
    else
       Label6.Caption:='(not tested)';
       
    Label5.Update;
    Label6.Update;

    if CheckBox1.Checked then
    begin
      Label5.Caption:=IntToStr(AddTeeTree(NumNodes))+' msec';
      Label5.Update;
    end;

    if CheckBox2.Checked then
    begin
      Label6.Caption:=IntToStr(AddTreeView(NumNodes))+' msec';
      Label6.Update;
    end;

  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Test(5000);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Test(10000);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Test(50000);
end;

function TForm1.AddTeeTree(NumNodes:Integer):Integer;
var t1,t2,t:Integer;
begin
  Tree1.Clear;

  t1:=GetTickCount;

  with Tree1.GlobalFormat do
  begin
    Border.Visible:=False;
    Transparent:=True;
    ImageIndex:=tiNone;
    Connection.ArrowTo.Style:=casNone;
  end;

  // add nodes
  Tree1.BeginUpdate;

  with Tree1.AddRoot('Root') do
  for t:=1 to NumNodes do AddChild('Node '+IntToStr(t));

  Tree1.EndUpdate;

  t2:=GetTickCount;

  result:=t2-t1;
end;

function TForm1.AddTreeView(NumNodes:Integer):Integer;
var t1,t2,t:Integer;
    Root:TTreeNode;
begin
  TreeView1.Items.BeginUpdate;
  TreeView1.Items.Clear;
  TreeView1.Items.EndUpdate;

  t1:=GetTickCount;

  TreeView1.Items.BeginUpdate;

  Root:=TreeView1.Items.Add(nil,'Root');
  for t:=1 to NumNodes do
      TreeView1.Items.AddChild(Root,'Node '+IntToStr(t));

  TreeView1.Items.EndUpdate;

  t2:=GetTickCount;
  result:=t2-t1;
end;

procedure TForm1.Button4Click(Sender: TObject);
var t1,t2: Integer;
begin
  // Add 10000 nodes so we can Clear them later.
  Test(10000);

  // Clear TeeTree
  t1:=GetTickCount;
  Tree1.Clear;
  t2:=GetTickCount;
  Label5.Caption:=IntToStr(t2-t1)+' msec';

  // Clear TreeView
  t1:=GetTickCount;
  with TreeView1.Items do
  begin
    BeginUpdate;
    Clear;
    EndUpdate;
  end;

  t2:=GetTickCount;
  Label6.Caption:=IntToStr(t2-t1)+' msec';
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  Close;
end;

end.
