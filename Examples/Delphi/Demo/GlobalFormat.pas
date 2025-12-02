unit GlobalFormat;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeFlow, TreeUML, StdCtrls, TreeEd, ExtCtrls, TeeProcs;

type
  TGlobalFormatForm = class(TBaseForm)
    CheckBox1: TCheckBox;
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeShape3: TTreeNodeShape;
    ActionShape1: TActionShape;
    CrossShape1: TCrossShape;
    HexagonShape1: THexagonShape;
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TGlobalFormatForm.CheckBox1Click(Sender: TObject);
begin
  Tree1.GlobalFormat.Border.Visible:=CheckBox1.Checked;
end;

initialization
  RegisterClass(TGlobalFormatForm);
end.
