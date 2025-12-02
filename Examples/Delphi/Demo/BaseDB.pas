unit BaseDB;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TeeProcs, TeeTree, TeeDBTre, ExtCtrls, StdCtrls;

type
  TBaseDBForm = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    DBTree1: TDBTree;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

end.
