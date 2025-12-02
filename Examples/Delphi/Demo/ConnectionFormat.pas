unit ConnectionFormat;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, StdCtrls, TeCanvas, TeePenDlg, TeeTree, TreeEd, ExtCtrls, TeeProcs,
  TreeCoEd;

type
  TConnectionFormatForm = class(TBaseForm)
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeShape3: TTreeNodeShape;
    TreeNodeShape4: TTreeNodeShape;
    Connection_AC: TTreeConnection;
    Connection_BD: TTreeConnection;
    Label1: TLabel;
    ComboFlat1: TComboFlat;
    ButtonPen1: TButtonPen;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ComboFlat1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Tree1ClickConnection(Sender: TTreeConnection;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    Function Connection:TTreeConnection;
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TConnectionFormatForm.FormCreate(Sender: TObject);
var t : Integer;
    tmp : String;
begin
  inherited;

  // Fill the combobox with all connections:

  ComboFlat1.Clear;
  for t:=0 to Tree1.Connections.Count-1 do
  begin
    tmp:=Tree1.Connections[t].FromShape.SimpleText;
    tmp:=tmp+' -> ';
    tmp:=tmp+Tree1.Connections[t].ToShape.SimpleText;
    ComboFlat1.Items.AddObject(tmp,Tree1.Connections[t]);
  end;

  ComboFlat1.ItemIndex:=0;
  ComboFlat1Change(ComboFlat1);
end;

procedure TConnectionFormatForm.ComboFlat1Change(Sender: TObject);
begin
  ButtonPen1.LinkPen(Connection.Border);
end;

procedure TConnectionFormatForm.Button1Click(Sender: TObject);
begin
  EditTreeConnection(Self,Connection);
end;

procedure TConnectionFormatForm.Tree1ClickConnection(
  Sender: TTreeConnection; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  with ComboFlat1 do ItemIndex:=Items.IndexOfObject(Sender);
  ComboFlat1Change(Self);
end;

Function TConnectionFormatForm.Connection:TTreeConnection;
begin
  result:=TTreeConnection(ComboFlat1.Items.Objects[ComboFlat1.ItemIndex]);
end;

initialization
  RegisterClass(TConnectionFormatForm);
end.
