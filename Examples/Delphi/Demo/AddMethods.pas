unit AddMethods;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs;

type
  TAddMethodsForm = class(TBaseForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TAddMethodsForm.FormCreate(Sender: TObject);
var MyNode      : TTreeNodeShape;
    AnotherNode : TTreeNodeShape;
begin
  inherited;

  // 1. Simple way to add a root node:
        Tree1.Add('1.Simple');

  // 2. Same as above, but preserving the resulting node
        MyNode:=Tree1.Add('2.MyNode');

  // 3. One way to add a children node to MyNode:
        Tree1.Add('3.Children',MyNode);

  // 4. Same as 3, but specifying X and Y positions and no parent:
        Tree1.Add(200,100,'4.At 100,100',nil);

  // 5. Same as 3, but using MyNode:
        MyNode.Add('5.Children');

  // 6. Adding a brother:
        MyNode.AddBrother('6.Brother');

  // 7. Adding a child to a node:
        Tree1.Shapes.AddChild(MyNode,'7.AddChild');

  // 8. Adding a child using default index property:
        AnotherNode:=Tree1[0].Add('8.Add Child');

  // 9. Using the node Parent property:
        AnotherNode.Parent.Add('9.Another Brother');

  // 10. Adding nodes and children in the same line:
        Tree1.Add('10.Another Root').Add('Child').Add('Sub-Child');

end;

initialization
  RegisterClass(TAddMethodsForm);
end.
