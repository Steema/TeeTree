unit NodeImageAlign;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs;

type
  TNodeImageAlignForm = class(TBaseForm)
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeShape3: TTreeNodeShape;
    TreeNodeShape4: TTreeNodeShape;
    TreeNodeShape5: TTreeNodeShape;
    TreeNodeShape6: TTreeNodeShape;
    TreeNodeShape7: TTreeNodeShape;
    TreeNodeShape8: TTreeNodeShape;
    TreeNodeShape9: TTreeNodeShape;
    TreeNodeShape10: TTreeNodeShape;
    TreeNodeShape10_TreeNodeShape8: TTreeConnection;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

initialization
  RegisterClass(TNodeImageAlignForm);
end.
