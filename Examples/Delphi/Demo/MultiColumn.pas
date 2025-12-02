unit MultiColumn;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, ExtCtrls, TeeProcs, TeeTree, TreeEd, StdCtrls;

type
  TMultiColumnForm = class(TBaseForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

uses TreeFlow;

type
  TMyNode=class(TGridShape)
  protected
    function GetCell(Row, Col: Integer): TGridCellShape; override;
  public
    Constructor Create(AOwner:TComponent); override;
    Constructor CreateWithText( ATree:TCustomTree;
                                const Text1,Text2,Text3:String); virtual;
  end;

procedure TMultiColumnForm.FormCreate(Sender: TObject);
var Usa,
    Spain,
    Nigeria : TMyNode;
begin
  Usa:=TMyNode.CreateWithText(Tree1,'USA','California','Santa Cruz');
  Usa.AddChild('John');
  Usa.AddChild('Lisa');
  Usa.AddChild('Peter');

  Nigeria:=TMyNode.CreateWithText(Tree1,'NIGERIA','Lagos','Lagos');
  Nigeria.AddChild('SystemSpecs');

  Spain:=TMyNode.CreateWithText(Tree1,'SPAIN','Catalonia','Girona');
  Spain.AddChild('Steema Software');
end;

{ TMyNode }

constructor TMyNode.Create(AOwner: TComponent);
begin
  inherited;
  Rows:=1;
  Border.SmallDots:=True;
  Border.Visible:=False;
  Width:=200;
  Height:=16;
end;

function TMyNode.GetCell(Row, Col: Integer): TGridCellShape;
var t : Integer;
begin
  result:=inherited GetCell(Row,Col);
  result.Border.SmallDots:=True;
  result.Border.Visible:=False;
  result.Color:=clSilver;
  result.Transparent:=False;

  if (Col=0) and (SimpleText<>'') then
  begin
    result.SimpleText:=SimpleText;
    for t:=1 to Text.Count-1 do
        GetCell(Row,t).SimpleText:=Text[t];
    Columns:=Text.Count;
    Text.Clear;
  end;
  result.Text.HorizAlign:=htaLeft;
end;

Constructor TMyNode.CreateWithText( ATree:TCustomTree;
                                    const Text1,Text2,Text3:String);
begin
  Create(ATree.Owner);

  Tree:=ATree;
  Cells[0,0].SimpleText:=Text1;
  Cells[0,1].SimpleText:=Text2;
  Cells[0,2].SimpleText:=Text3;
end;

initialization
  RegisterClass(TMultiColumnForm);
end.
