{**********************************************}
{   TTree Component  - Text Editor Dialog      }
{   Copyright (c) 1998-2025 by Steema Software }
{**********************************************}
{$I TeeDefs.inc}
unit TreeTeEd;

{
  Tree Text Editor dialog.
  Used by shapes (TreeShEd.pas) and connections (TreeCoEd.pas)
}
interface

uses
  {$IFNDEF LINUX}
  Windows, Messages,
  {$ENDIF}
  SysUtils, Classes,
  Graphics, Controls, Forms, Dialogs, StdCtrls, ComCtrls, ExtCtrls,

  TeeTree, TeeProcs, TeCanvas, TeePenDlg, TeeEdiFont;

type
  TFormTeeText = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label4: TLabel;
    Edit2: TEdit;
    UpDown2: TUpDown;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    CBHorizAlign: TComboFlat;
    Label7: TLabel;
    CBVertAlign: TComboFlat;
    Edit3: TEdit;
    UpDown3: TUpDown;
    Edit4: TEdit;
    UpDown4: TUpDown;
    Label5: TLabel;
    Edit7: TEdit;
    UpDown7: TUpDown;
    Panel3: TPanel;
    Panel2: TPanel;
    Memo2: TMemo;
    Panel1: TPanel;
    Label3: TLabel;
    Shape5: TShape;
    Button2: TButton;
    CBClip: TCheckBox;
    TabFont: TTabSheet;
    Button3: TButton;
    CBVisible: TCheckBox;
    procedure Button2Click(Sender: TObject);
    procedure Memo2Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CBHorizAlignChange(Sender: TObject);
    procedure Shape5MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Edit2Change(Sender: TObject);
    procedure CBClipClick(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure CBVertAlignChange(Sender: TObject);
    procedure Edit7Change(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure CBVisibleClick(Sender: TObject);
  private
    { Private declarations }
    Changing     : Boolean;
    IsConnection : Boolean;
    IFontEditor  : TTeeFontEditor;
  public
    { Public declarations }
    Tree1       : TCustomTree;
    Connection1 : TTreeConnection;
  end;

Procedure TreeEditText(AOwner:TComponent; AElement:TCustomTreeElement);

implementation

{$IFNDEF LCL}
{$R *.DFM}
{$ELSE}
{$R *.lfm}
{$ENDIF}

Uses
  TeeTranslate, TeeBrushDlg, TeeEdiGrad, TeeStringsEditor;

Procedure TreeEditText(AOwner:TComponent; AElement:TCustomTreeElement);
begin
  with TFormTeeText.Create(AOwner) do
  try
    Align:=alNone;
    BorderStyle:=bsSizeable;
    Position:=poScreenCenter;
    Height:=200;
    Width:=320;

    if AElement is TTreeConnection then
       Connection1:=TTreeConnection(AElement);

    Tree1:=AElement.Tree;
    ShowModal;
  finally
    Free;
  end;
end;

procedure TFormTeeText.Button2Click(Sender: TObject);
var t : Integer;
begin
  if IsConnection then
     TTeeFontEditor.Edit(Self,Connection1.Font)
  else
  With Tree1 do
  if Selected.Count>0 then
  begin
    TTeeFontEditor.Edit(Self,Selected[0].Font);

    for t:=1 to Selected.Count-1 do
        Selected[t].Font.Assign(Selected[0].Font);
  end;
end;

procedure TFormTeeText.Memo2Change(Sender: TObject);
begin
  if not Changing then
     if IsConnection then Connection1.Text.Assign(Memo2.Lines)
     else
     With Tree1 do
     if Selected.Count>0 then
        Selected[0].Text.Assign(Memo2.Lines);
end;

procedure TFormTeeText.FormShow(Sender: TObject);
var tmp:TCustomTreeElement;
begin
  Changing:=True;
  IsConnection:=Assigned(Connection1);
  if IsConnection then tmp:=Connection1
  else
  if Assigned(Tree1) then tmp:=Tree1.Selected[0]
                     else tmp:=nil;

  if Assigned(tmp) then
  With tmp do
  begin
    Shape5.Brush.Color:=Font.Color;

    IFontEditor.RefreshControls(Font);

    Case HorizTextAlign of
      htaLeft   : CBHorizAlign.ItemIndex:=0;
      htaCenter : CBHorizAlign.ItemIndex:=1;
      htaRight  : CBHorizAlign.ItemIndex:=2;
    end;
    Case VertTextAlign of
      vtaTop    : CBVertAlign.ItemIndex:=0;
      vtaCenter : CBVertAlign.ItemIndex:=1;
      vtaBottom : CBVertAlign.ItemIndex:=2;
    end;

    Memo2.Lines.Assign(Text);
    UpDown2.Position:=Text.Angle;

    CBClip.Visible:=not IsConnection;
    if CBClip.Visible then CBClip.Checked:=Text.ClipText;
    CBVisible.Checked := Text.Visible;

    UpDown3.Position:=Text.HorizOffset;
    UpDown4.Position:=Text.VertOffset;
  end;

  PageControl1.ActivePage:=TabSheet1;

  Memo2.SetFocus;
  Changing:=False;
end;

procedure TFormTeeText.FormCreate(Sender: TObject);
begin
  IFontEditor:=TTeeFontEditor.InsertEditor(TabFont);
  TeeTranslateControl(Self);
  Changing:=True;
end;

procedure TFormTeeText.CBHorizAlignChange(Sender: TObject);
var t   : Integer;
    tmp : THorizTextAlign;
begin
  Case CBHorizAlign.ItemIndex of
    0: tmp:=htaLeft;
    1: tmp:=htaCenter;
  else
    {2:} tmp:=htaRight;
  end;
  if IsConnection then Connection1.HorizTextAlign:=tmp
  else
  With Tree1 do
  for t:=0 to Selected.Count-1 do Selected[t].HorizTextAlign:=tmp
end;

procedure TFormTeeText.Shape5MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var t:Integer;
    tmpColor:TColor;
begin
  if IsConnection then
  begin
    tmpColor:=TButtonColor.Edit(Self,Connection1.Font.Color);
    Tree1.Connections.Selected.Font.Color:=tmpColor;
  end
  else
  begin
    tmpColor:=TButtonColor.Edit(Self,Tree1.Selected[0].Font.Color);

    With Tree1.Selected do
    for t:=0 to Count-1 do Items[t].Font.Color:=tmpColor;
  end;

  Shape5.Brush.Color:=tmpColor;
end;

procedure TFormTeeText.Edit2Change(Sender: TObject);
var t : Integer;
begin
  if not Changing then
    if IsConnection then
       Connection1.Text.Angle:=UpDown2.Position
    else
    begin
      With Tree1.Selected do
      for t:=0 to Count-1 do
          Items[t].Text.Angle:=UpDown2.Position;
    end;
end;

procedure TFormTeeText.CBClipClick(Sender: TObject);
var t : Integer;
begin
  if not IsConnection then
  With Tree1.Selected do
    for t:=0 to Count-1 do Items[t].Text.ClipText:=CBClip.Checked;
end;

procedure TFormTeeText.Edit3Change(Sender: TObject);
var t : Integer;
begin
  if not Changing then
    if IsConnection then
       Connection1.Text.HorizOffset:=UpDown3.Position
    else
    With Tree1.Selected do
      for t:=0 to Count-1 do Items[t].Text.HorizOffset:=UpDown3.Position;
end;

procedure TFormTeeText.Edit4Change(Sender: TObject);
var t : Integer;
begin
  if not Changing then
    if IsConnection then
       Connection1.Text.VertOffset:=UpDown4.Position
    else
    With Tree1.Selected do
      for t:=0 to Count-1 do Items[t].Text.VertOffset:=UpDown4.Position;
end;

procedure TFormTeeText.CBVertAlignChange(Sender: TObject);
var t:Integer;
    tmp:TVertTextAlign;
begin
  Case CBVertAlign.ItemIndex of
    0: tmp:=vtaTop;
    1: tmp:=vtaCenter;
  else
    {2:} tmp:=vtaBottom;
  end;
  if IsConnection then Connection1.VertTextAlign:=tmp
  else
  With Tree1 do
  for t:=0 to Selected.Count-1 do Selected[t].VertTextAlign:=tmp
end;

procedure TFormTeeText.Edit7Change(Sender: TObject);
var t : Integer;
begin
  if not Changing then
    if IsConnection then
       Connection1.Text.Transparency:=UpDown7.Position
    else
    With Tree1 do
    for t:=0 to Selected.Count-1 do
        Selected[t].Text.Transparency:=UpDown7.Position;
end;

procedure TFormTeeText.Button3Click(Sender: TObject);
begin
  TStringsEditor.Edit(Self,Memo2.Lines);
end;

procedure TFormTeeText.CBVisibleClick(Sender: TObject);
var t:integer;
begin
  if IsConnection then
    Connection1.Text.Visible :=CBVisible.Checked
  else
    With Tree1.Selected do
      for t:=0 to Count-1 do Items[t].Text.Visible:=CBVisible.Checked;
end;

end.
