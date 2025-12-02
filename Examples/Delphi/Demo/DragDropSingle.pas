unit DragDropSingle;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, StdCtrls, TeeTree, TreeEd, ExtCtrls, TeeProcs;

type
  TDragDropSingleForm = class(TBaseForm)
    CheckBox1: TCheckBox;
    procedure CheckBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TDragDropSingleForm.CheckBox1Click(Sender: TObject);
begin
  Tree1.DragAndDrop.Automatic:=CheckBox1.Checked;
end;

procedure TDragDropSingleForm.FormCreate(Sender: TObject);
begin
  inherited;
  // Add some sample nodes...

  Tree1.Add('abc').Add('123');
  Tree1.Add('Hello').Add('World');
  Tree1.Add('2002').Add('January').Add('14th');

  // Enable drag and drop of nodes:

  Tree1.DragAndDrop.Automatic:=True;
end;

initialization
  RegisterClass(TDragDropSingleForm);
end.
