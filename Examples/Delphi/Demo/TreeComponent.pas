unit TreeComponent;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TreeAnimate, TeeTree, ExtCtrls, TeeProcs, StdCtrls;

type
  TTreeComponentForm = class(TForm)
    Memo1: TMemo;
    Tree1: TTree;
    TextShape1: TTextShape;
    TreeAnimate1: TTreeAnimate;
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeShape1_TreeNodeShape2: TTreeConnection;
    TreeNodeShape3: TTreeNodeShape;
    TreeNodeShape1_TreeNodeShape3: TTreeConnection;
    TreeNodeShape4: TTreeNodeShape;
    TreeNodeShape5: TTreeNodeShape;
    TreeNodeShape4_TreeNodeShape5: TTreeConnection;
    TreeNodeShape6: TTreeNodeShape;
    TreeNodeShape4_TreeNodeShape6: TTreeConnection;
    TreeNodeShape7: TTreeNodeShape;
    TransparencyAnimation1: TTransparencyAnimation;
    TextFlashAnimation3: TTextFlashAnimation;
    MovementAnimation4: TMovementAnimation;
    TextColorAnimation5: TTextColorAnimation;
    TreeColorAnimation6: TTreeColorAnimation;
    TextAngleAnimation7: TTextAngleAnimation;
    MovementAnimation7: TMovementAnimation;
    TextColorAnimation8: TTextColorAnimation;
    TreeNodeShape8: TTreeNodeShape;
    NodeZoomAnimation9: TNodeZoomAnimation;
    MovementAnimation10: TMovementAnimation;
    MovementAnimation11: TMovementAnimation;
    TransparencyAnimation12: TTransparencyAnimation;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TTreeComponentForm.FormShow(Sender: TObject);
begin
  TreeAnimate1.Play;
end;

initialization
  RegisterClass(TTreeComponentForm);
end.
