unit DBTreeGroup;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  BaseDB, StdCtrls, Db, DBTables, TeeProcs, TeeTree, TeeDBTre, ExtCtrls,
  TeCanvas;

type
  TDBTreeGroupForm = class(TBaseDBForm)
    Table1: TTable;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    ComboFlat1: TComboFlat;
    ComboFlat2: TComboFlat;
    ComboFlat3: TComboFlat;
    procedure CheckBox1Click(Sender: TObject);
    procedure ComboFlat3Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TDBTreeGroupForm.CheckBox1Click(Sender: TObject);
begin
  Table1.Active:=CheckBox1.Checked;

  DBTree1.Clear;
  DBTree1.Refresh;
end;

procedure TDBTreeGroupForm.ComboFlat3Change(Sender: TObject);
begin
  with DBTree1.Layout[0] do
    ParentField:= ComboFlat1.Items[ComboFlat1.ItemIndex]+';'+
                  ComboFlat2.Items[ComboFlat2.ItemIndex]+';'+
                  ComboFlat3.Items[ComboFlat3.ItemIndex];

  DBTree1.Refresh;
end;

procedure TDBTreeGroupForm.FormShow(Sender: TObject);
begin
  inherited;
  ComboFlat1.ItemIndex:=0;
  ComboFlat2.ItemIndex:=1;
  ComboFlat3.ItemIndex:=2;
end;

initialization
  RegisterClass(TDBTreeGroupForm);
end.
