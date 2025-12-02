unit PolygonShape;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, StdCtrls, TeeTree, TreeEd, ExtCtrls, TeeProcs, TeeGDIPlus;

type
  TPolygonShapeForm = class(TBaseForm)
    PolygonShape1: TPolygonShape;
    Button1: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Tree1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TPolygonShapeForm.Button1Click(Sender: TObject);
var MyPolygon : TPolygonShape;
    SomeX     : Integer;
    SomeY     : Integer;
begin
  MyPolygon:=TPolygonShape.Create(Self);
  MyPolygon.Tree:=Tree1;

  SomeX:=Random(Tree1.ClientWidth);
  SomeY:=Random(Tree1.ClientHeight);

  with MyPolygon do
  begin
    Add(SomeX+15,SomeY-20);  // one way to add a point

    // another way:
    with Points.Add do
    begin
      x:=SomeX+50;
      y:=SomeY;
    end;

    Add(SomeX+30,SomeY+10);
    Add(SomeX+50,SomeY+40);
    Add(SomeX,SomeY+40);

    Color:=clNavy;
    Border.Color:=clLime;

  end;
end;

procedure TPolygonShapeForm.Tree1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var t        : Integer;
    SomeText : String;
    Num      : Integer;
begin
  // Example:
  // When moving the mouse, find if it is over a Polygon Point...

  for t:=0 to Tree1.Shapes.Count-1 do
  begin

    Tree1.Canvas.Calculate2DPosition(x,y,0);  // convert xy coordinates

    Num:=(Tree1[t] as TPolygonShape).ClickedPoint(x,y);

    if Num<>-1 then // ok !
    begin
      SomeText:='Polygon: '+IntToStr(t)+' Point clicked: '+IntToStr(Num);
      if Label1.Caption<>SomeText then Label1.Caption:=SomeText;

      exit;
    end;
  end;

  Label1.Caption:='';
end;

initialization
  RegisterClass(TPolygonShapeForm);
end.
