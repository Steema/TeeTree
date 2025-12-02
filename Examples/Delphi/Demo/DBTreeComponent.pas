unit DBTreeComponent;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  BaseDB, Db, DBTables, StdCtrls, TeeProcs, TeeTree, TeeDBTre, ExtCtrls;

type
  TDBTreeComponentForm = class(TBaseDBForm)
    Button1: TButton;
    Table1: TTable;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TDBTreeComponentForm.Button1Click(Sender: TObject);
begin
  Table1.Open;
  DBTree1.Refresh;
end;

initialization
  RegisterClass(TDBTreeComponentForm);
end.
