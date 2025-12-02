unit DBTreeFormat;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  BaseDB, StdCtrls, TeeProcs, TeeTree, TeeDBTre, ExtCtrls, Db, DBTables;

type
  TDBTreeFormatForm = class(TBaseDBForm)
    CheckBox1: TCheckBox;
    Button2: TButton;
    Table1: TTable;
    procedure CheckBox1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

uses TreeShEd;

procedure TDBTreeFormatForm.CheckBox1Click(Sender: TObject);
begin
  Table1.Active:=CheckBox1.Checked;

  DBTree1.Clear;
  DBTree1.Refresh;
end;

procedure TDBTreeFormatForm.Button2Click(Sender: TObject);
begin
  EditTreeShape(Self,DBTree1.Layout[0].Format);
  DBTree1.Refresh;
end;

initialization
  RegisterClass(TDBTreeFormatForm);
end.
