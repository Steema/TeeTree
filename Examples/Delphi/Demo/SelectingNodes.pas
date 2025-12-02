unit SelectingNodes;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs, TreeFlow,
  TreeTransit, TreeUML;

type
  TSelectingNodesForm = class(TBaseForm)
    Button1: TButton;
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    NoteShape1: TNoteShape;
    StoreShape1: TStoreShape;
    SlowShape1: TSlowShape;
    InputOutputShape1: TInputOutputShape;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TSelectingNodesForm.Button1Click(Sender: TObject);
begin
  Tree1.Selected.SelectAll;
end;

initialization
  RegisterClass(TSelectingNodesForm);
end.
