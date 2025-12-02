unit NodeCursor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, StdCtrls, TreeFlow, TeeTree, TreeEd, ExtCtrls, TeeProcs;

type
  TNodeCursorForm = class(TBaseForm)
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeShape3: TTreeNodeShape;
    TreeNodeShape4: TTreeNodeShape;
    TreeNodeShape5: TTreeNodeShape;
    TreeNodeShape6: TTreeNodeShape;
    TreeNodeShape7: TTreeNodeShape;
    TreeNodeShape8: TTreeNodeShape;
    PolygonShape1: TPolygonShape;
    TitleShape1: TTitleShape;
    CardShape1: TCardShape;
    Label1: TLabel;
    Label2: TLabel;
    ComboBox1: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure Tree1MouseEnterShape(Sender: TTreeNodeShape;
      Shift: TShiftState; X, Y: Integer);
    procedure Tree1MouseLeaveShape(Sender: TTreeNodeShape;
      Shift: TShiftState; X, Y: Integer);
    procedure ComboBox1Change(Sender: TObject);
  private
    { Private declarations }
    procedure AddCursor(const S:String);
    Function CursorIndex(Index:Integer):Integer;
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

Uses Math;

procedure TNodeCursorForm.AddCursor(const S:String);
begin
  ComboBox1.Items.Add(S);
end;

procedure TNodeCursorForm.FormCreate(Sender: TObject);
begin
  inherited;
  GetCursorValues(AddCursor);
end;

Function TNodeCursorForm.CursorIndex(Index:Integer):Integer;
begin
  if not IdentToCursor(ComboBox1.Items[Index], result) then
     result:=StrToInt(ComboBox1.Items[Index]);
end;

procedure TNodeCursorForm.ComboBox1DrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var CursorHandle: THandle;
begin
  with ComboBox1.Canvas do
  begin
    FillRect(Rect);
    CursorHandle:=Screen.Cursors[CursorIndex(Index)];
    if CursorHandle<>0 then
      DrawIconEx(Handle, Succ(Rect.Left), Succ(Rect.Top), CursorHandle,0,0,0,0,
                 DI_NORMAL or DI_DEFAULTSIZE);
    TextOut(Rect.Left+32,Rect.Top+2,ComboBox1.Items[Index]);
  end;
end;

procedure TNodeCursorForm.Tree1MouseEnterShape(Sender: TTreeNodeShape;
  Shift: TShiftState; X, Y: Integer);
var tmp : String;
begin
  if CursorToIdent(Sender.Cursor,tmp) then
     ComboBox1.ItemIndex:=ComboBox1.Items.IndexOf(tmp)
  else
     ComboBox1.ItemIndex:=-1;
end;

procedure TNodeCursorForm.Tree1MouseLeaveShape(Sender: TTreeNodeShape;
  Shift: TShiftState; X, Y: Integer);
begin
  ComboBox1.ItemIndex:=-1;
end;

procedure TNodeCursorForm.ComboBox1Change(Sender: TObject);
var Node : TTreeNodeShape;
begin
  Node:=Tree1.Selected.First;
  if Assigned(Node) then
     if ComboBox1.ItemIndex<>-1 then
        Node.Cursor:=CursorIndex(ComboBox1.ItemIndex);
end;

initialization
  RegisterClass(TNodeCursorForm);
end.
