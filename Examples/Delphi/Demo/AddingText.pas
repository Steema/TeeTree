unit AddingText;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs;

type
  TAddingTextForm = class(TBaseForm)
    SampleMemo: TMemo;
    TextShape1: TTextShape;
    Node1: TTreeNodeShape;
    Label1: TLabel;
    Button1: TButton;
    TextShape2: TTextShape;
    procedure FormCreate(Sender: TObject);
    procedure SampleMemoChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Tree1StartEditing(Shape: TTreeNodeShape;
      var AllowEditing: Boolean);
    procedure Tree1StopEditing(Sender: TTreeNodeShape);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TAddingTextForm.FormCreate(Sender: TObject);
begin
  inherited;

  // Assign text from Memo
  TextShape1.Text.Assign(SampleMemo.Lines);

  // Manually add Text to a node:
  Node1.Text.Clear;
  Node1.Text.Add('Hello');
  Node1.Text.Add('World.');
end;

procedure TAddingTextForm.SampleMemoChange(Sender: TObject);
begin
  TextShape1.Text.Assign(SampleMemo.Lines);
end;

procedure TAddingTextForm.Button1Click(Sender: TObject);
begin
  Tree1.StartEditing(Node1);
end;

procedure TAddingTextForm.Tree1StartEditing(Shape: TTreeNodeShape;
  var AllowEditing: Boolean);
begin
  TextShape2.Visible:=True;  // show "hint" text...
end;

procedure TAddingTextForm.Tree1StopEditing(Sender: TTreeNodeShape);
begin
  TextShape2.Visible:=False;  // hide "hint" text...
end;

initialization
  RegisterClass(TAddingTextForm);
end.
