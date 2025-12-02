unit Monochrome;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs;

type
  TMonochromeForm = class(TBaseForm)
    TreeNodeShape1: TTreeNodeShape;
    CheckBox1: TCheckBox;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeShape1_TreeNodeShape2: TTreeConnection;
    procedure CheckBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TMonochromeForm.CheckBox1Click(Sender: TObject);
begin
  Tree1.Monochrome:=CheckBox1.Checked;
end;

procedure TMonochromeForm.FormCreate(Sender: TObject);
begin
  inherited;
  Tree1.Monochrome:=True;
  CheckBox1.Checked:=True;
end;

initialization
  RegisterClass(TMonochromeForm);
end.
