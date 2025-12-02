unit DBTreeMasterDetail;
{$I TeeDefs.inc}

interface

uses
  Windows, Messages, SysUtils, Classes,
  {$IFDEF D16}
  System.UITypes,
  {$ENDIF}
  Graphics, Controls, Forms, Dialogs,
  BaseDB, StdCtrls, TeeProcs, TeeTree, TeeDBTre, ExtCtrls, Db, DBTables;

type
  TDBTreeMasterDetailForm = class(TBaseDBForm)
    CheckBox1: TCheckBox;
    Customer: TTable;
    Orders: TTable;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    Items: TTable;
    procedure CheckBox1Click(Sender: TObject);
    procedure DBTree1UnSelectShape(Sender: TTreeNodeShape);
    procedure DBTree1SelectShape(Sender: TTreeNodeShape);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TDBTreeMasterDetailForm.CheckBox1Click(Sender: TObject);
begin
  // Open or Close datasets:
  Customer.Active:=CheckBox1.Checked;
  Orders.Active:=CheckBox1.Checked;
  Items.Active:=CheckBox1.Checked;

  DBTree1.Clear;
  DBTree1.Refresh;
end;

procedure TDBTreeMasterDetailForm.DBTree1UnSelectShape(
  Sender: TTreeNodeShape);
begin
  with Sender.Font do Style:=Style-[fsBold];  // when unselecting, remove bold
end;

procedure TDBTreeMasterDetailForm.DBTree1SelectShape(
  Sender: TTreeNodeShape);
begin
  with Sender.Font do Style:=Style+[fsBold];  // when selecting, set font bold
end;

initialization
  RegisterClass(TDBTreeMasterDetailForm);
end.
