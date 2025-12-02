unit Main;
{$I TeeDefs.inc}

interface

uses
  Windows, Messages, 
  SysUtils, Classes, 
  {$IFDEF D16}
  System.UITypes,
  {$ENDIF}
  Graphics, Controls, Forms, Dialogs,
  TeeTree, ExtCtrls, TeeProcs, TreeFlow, TreeAnimate, TeeGDIPlus,
  TeeAnimate;

type
  TWelcomeForm = class(TForm)
    Tree1: TTree;
    TriangleLeft: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TriangleRight: TTreeNodeShape;
    TreeNodeShape4: TTreeNodeShape;
    TreeNodeShape5: TTreeNodeShape;
    TreeNodeShape6: TTreeNodeShape;
    TreeNodeShape7: TTreeNodeShape;
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape3: TTreeNodeShape;
    TreeNodeShape8: TTreeNodeShape;
    TreeNodeShape9: TTreeNodeShape;
    TreeNodeShape10: TTreeNodeShape;
    TreeNodeShape11: TTreeNodeShape;
    TreeAnimate1: TTreeAnimate;
    TransparencyAnimation1: TTransparencyAnimation;
    TransparencyAnimation2: TTransparencyAnimation;
    TextTranspAnimation3: TTextTranspAnimation;
    CustomAnimation4: TCustomAnimation;
    NodeColorAnimation5: TNodeColorAnimation;
    NodeColorAnimation6: TNodeColorAnimation;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CustomAnimation4Frame(Sender: TTeeAnimation;
      const Fraction: Single);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TWelcomeForm.FormCreate(Sender: TObject);
begin
  // Example: send big rectangle to back
  TreeNodeShape1.SendToBack;
end;

procedure TWelcomeForm.FormShow(Sender: TObject);
begin
  TreeAnimate1.Play;
end;

procedure TWelcomeForm.CustomAnimation4Frame(Sender: TTeeAnimation;
  const Fraction: Single);
begin
  with TreeNodeShape5.Font do Style:=Style+[fsBold]
end;

initialization
  RegisterClass(TWelcomeForm);
end.
