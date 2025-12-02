unit ConnectionText;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, StdCtrls, TeCanvas, TeeTree, TreeEd, ExtCtrls, TeeProcs,
  TreeCoEd;

type
  TConnectionTextForm = class(TBaseForm)
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeShape3: TTreeNodeShape;
    TreeNodeShape4: TTreeNodeShape;
    TreeNodeShape1_TreeNodeShape3: TTreeConnection;
    TreeNodeShape4_TreeNodeShape2: TTreeConnection;
    TreeNodeShape3_TreeNodeShape4: TTreeConnection;
    TreeNodeShape2_TreeNodeShape1: TTreeConnection;
    Label1: TLabel;
    ComboFlat1: TComboFlat;
    Button1: TButton;
    Edit1: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ComboFlat1Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    { Private declarations }
    Function Connection:TTreeConnection;
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TConnectionTextForm.FormCreate(Sender: TObject);
var tmp : TTreeConnection;
    t   : Integer;
begin
  inherited;

  // Fill the combobox with all connections:
  ComboFlat1.Clear;
  for t:=0 to Tree1.Connections.Count-1 do
  begin
    tmp:=Tree1.Connections[t];
    ComboFlat1.Items.AddObject(tmp.SimpleText,tmp);
  end;

  ComboFlat1.ItemIndex:=0;
  ComboFlat1Change(ComboFlat1);

  // Set Tree design-mode:
  Tree1.Designing:=True;
end;

procedure TConnectionTextForm.Button1Click(Sender: TObject);
begin
  EditTreeConnection(Self,Connection);

  Edit1.Text:=Connection.SimpleText;
end;

procedure TConnectionTextForm.ComboFlat1Change(Sender: TObject);
begin
  Edit1.Text:=Connection.SimpleText;
end;

procedure TConnectionTextForm.Edit1Change(Sender: TObject);
var old : Integer;
begin
  Connection.SimpleText:=Edit1.Text;

  old:=ComboFlat1.ItemIndex;
  ComboFlat1.Items[ComboFlat1.ItemIndex]:=Edit1.Text;
  ComboFlat1.ItemIndex:=old;
end;

Function TConnectionTextForm.Connection:TTreeConnection;
begin
  result:=TTreeConnection(ComboFlat1.Items.Objects[ComboFlat1.ItemIndex]);
end;

initialization
  RegisterClass(TConnectionTextform);
end.
