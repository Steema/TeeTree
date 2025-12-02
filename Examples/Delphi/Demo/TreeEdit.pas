unit TreeEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, StdCtrls, TeeTree, TreeEd, ExtCtrls, TeeProcs;

type
  TTreeEditForm = class(TBaseForm)
    Button1: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    TextShape1: TTextShape;
    procedure Button1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TTreeEditForm.Button1Click(Sender: TObject);
begin
  TreeEdit1.Execute;
end;

procedure TTreeEditForm.CheckBox1Click(Sender: TObject);
begin
  TreeEdit1.Maximized:=CheckBox1.Checked;
end;

procedure TTreeEditForm.CheckBox2Click(Sender: TObject);
Const TreeAllWindows:TTreeEditWindows=[
                    teInspector,
                    teNodeTree,
                    teToolbar,
                    teToolShapes,
                    teEditors,
                    teFont,
                    teFormat,
                    teRulers,
                    teStatus,
                    teModeTabs,
                    teMainMenu
                    ];
begin
  if CheckBox2.Checked then
     TreeEdit1.Hide:=TreeAllWindows  // hide all editor windows
  else
     TreeEdit1.Hide:=[];   // hide nothing
end;

initialization
  RegisterClass(TTreeEditForm);
end.
