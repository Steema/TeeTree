unit EditorPanel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TreeEd, StdCtrls, ExtCtrls;

type
  TEditorPanelForm = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Label1: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    TreeEditorPanel1: TTreeEditorPanel;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure CheckBox6Click(Sender: TObject);
    procedure CheckBox7Click(Sender: TObject);
    procedure CheckBox8Click(Sender: TObject);
    procedure CheckBox9Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TEditorPanelForm.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked then
     TreeEditorPanel1.HideWindows:=TreeEditorPanel1.HideWindows-[teNodeTree]
  else
     TreeEditorPanel1.HideWindows:=TreeEditorPanel1.HideWindows+[teNodeTree];
end;

procedure TEditorPanelForm.CheckBox2Click(Sender: TObject);
begin
  if CheckBox2.Checked then
     TreeEditorPanel1.HideWindows:=TreeEditorPanel1.HideWindows-[teInspector]
  else
     TreeEditorPanel1.HideWindows:=TreeEditorPanel1.HideWindows+[teInspector];
end;

procedure TEditorPanelForm.CheckBox3Click(Sender: TObject);
begin
  if CheckBox3.Checked then
     TreeEditorPanel1.HideWindows:=TreeEditorPanel1.HideWindows-[teToolbar]
  else
     TreeEditorPanel1.HideWindows:=TreeEditorPanel1.HideWindows+[teToolbar];
end;

procedure TEditorPanelForm.CheckBox4Click(Sender: TObject);
begin
  if CheckBox4.Checked then
     TreeEditorPanel1.HideWindows:=TreeEditorPanel1.HideWindows-[teStatus]
  else
     TreeEditorPanel1.HideWindows:=TreeEditorPanel1.HideWindows+[teStatus];
end;

procedure TEditorPanelForm.CheckBox5Click(Sender: TObject);
begin
  if CheckBox5.Checked then
     TreeEditorPanel1.HideWindows:=TreeEditorPanel1.HideWindows-[teToolShapes]
  else
     TreeEditorPanel1.HideWindows:=TreeEditorPanel1.HideWindows+[teToolShapes];
end;

procedure TEditorPanelForm.CheckBox6Click(Sender: TObject);
begin
  if CheckBox6.Checked then
     TreeEditorPanel1.HideWindows:=TreeEditorPanel1.HideWindows-[teRulers]
  else
     TreeEditorPanel1.HideWindows:=TreeEditorPanel1.HideWindows+[teRulers];
end;

procedure TEditorPanelForm.CheckBox7Click(Sender: TObject);
begin
  if CheckBox7.Checked then
     TreeEditorPanel1.HideWindows:=TreeEditorPanel1.HideWindows-[teModeTabs]
  else
     TreeEditorPanel1.HideWindows:=TreeEditorPanel1.HideWindows+[teModeTabs];
end;

procedure TEditorPanelForm.CheckBox8Click(Sender: TObject);
begin
  if CheckBox8.Checked then
     TreeEditorPanel1.HideWindows:=TreeEditorPanel1.HideWindows-[teFont]
  else
     TreeEditorPanel1.HideWindows:=TreeEditorPanel1.HideWindows+[teFont];
end;

procedure TEditorPanelForm.CheckBox9Click(Sender: TObject);
begin
  if CheckBox9.Checked then
     TreeEditorPanel1.HideWindows:=TreeEditorPanel1.HideWindows-[teFormat]
  else
     TreeEditorPanel1.HideWindows:=TreeEditorPanel1.HideWindows+[teFormat];
end;

initialization
  RegisterClass(TEditorPanelForm);
end.
