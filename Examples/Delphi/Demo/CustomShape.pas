unit CustomShape;
{$I TeeDefs.inc}

interface

uses
  Windows, Messages,
  SysUtils, Classes,
  {$IFDEF D16}
  System.UITypes,
  {$ENDIF}
  Graphics, Controls, Forms, Dialogs, ExtCtrls, StdCtrls, ComCtrls,
  Base, TeeTree, TreeEd, TeeProcs, TeCanvas, TeeBrushDlg, TeePenDlg;

type
  TCustomShapeForm = class(TBaseForm)
    ButtonPen1: TButtonPen;
    Label1: TLabel;
    Edit1: TEdit;
    UpDown1: TUpDown;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ButtonPen1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

type
  // Contains global formatting options for all nodes
  // created using TSpecialShape class. (See below).
  TSpecialShapeFormat=class
  public
    MaxLevel   : Integer;
    VertOffset : Integer;
    Brush      : TTeeBrush;
    Border     : TTeePen;

    Constructor Create;
    Destructor Destroy; override;
  end;

  // Special custom shape class to fill nodes using the Format
  // properties (brush, border, etc).
  TSpecialShape=class(TTreeNodeShape)
  public
    Constructor Create(AOwner:TComponent); override;

    procedure Draw; override;  // to draw the background...
    class Function Format:TSpecialShapeFormat;
  end;

procedure TCustomShapeForm.FormCreate(Sender: TObject);
begin
  inherited;

  // Here we set our "special" shape class to be the default
  // node class used when adding new nodes.
  Tree1.GlobalFormat.NodeClass:=TSpecialShape;

  // Link with Border
  ButtonPen1.LinkPen(TSpecialShape.Format.Border);

  // Sample nodes
  Tree1.Add('Africa').Add('Kenia');
  Tree1.Add('America').Add('USA').Add('Los Angeles');
  Tree1.Add('Asia').Add('Japan').Add('Tokyo');
  Tree1.Add('Australia').Add('Sydney');
  Tree1.Add('Europe').Add('Norway').Add('Oslo');

  // Another way to add a "special" shape:
  Tree1.AddShapeClass(0,0,'Universe',nil,TSpecialShape);
end;

procedure TCustomShapeForm.ButtonPen1Click(Sender: TObject);
begin
  Tree1.Invalidate;
end;

procedure TCustomShapeForm.Edit1Change(Sender: TObject);
begin
  TSpecialShape.Format.VertOffset:=UpDown1.Position;
  Tree1.Invalidate;
end;

procedure TCustomShapeForm.Button1Click(Sender: TObject);
begin
  if TBrushDialog.Edit(Self,TSpecialShape.Format.Brush) then
     Tree1.Invalidate;
end;

// Global variable used in this example.
// This variable is returned by our SpecialShape Format function.
var SpecialShapeFormat:TSpecialShapeFormat=nil;

{ TSpecialShape }

constructor TSpecialShape.Create(AOwner: TComponent);
begin
  inherited;
  Transparent:=True;
  Border.Visible:=False;
end;

// Draws a rectangle under node
procedure TSpecialShape.Draw;
var R:TRect;
begin
  if Level<=Format.MaxLevel then  // only for nodes with desired Level
  with Tree.Canvas do
  begin
    AssignBrush(Format.Brush);
    AssignVisiblePen(Format.Border);

    R:=Bounds;
    Rectangle(0,R.Top,Tree.ClientWidth,R.Bottom+Format.VertOffset);
  end;

  // Draw shape text, image, etc, as usually
  inherited;
end;

// Returns a global unique instance
class function TSpecialShape.Format: TSpecialShapeFormat;
begin
  if not Assigned(SpecialShapeFormat) then
     SpecialShapeFormat:=TSpecialShapeFormat.Create;
  result:=SpecialShapeFormat;
end;

{ TSpecialShapeFormat }

constructor TSpecialShapeFormat.Create;
Const clOrange=33023; { Red 255, Green 128, Blue 0 }
begin
  inherited;
  MaxLevel:=0;
  VertOffset:=1;
  Brush:=TTeeBrush.Create(nil);
  Brush.Style:=bsSolid;
  Brush.Color:=clDkGray;
  Border:=TTeePen.Create(nil);
  Border.Visible:=True;
  Border.Color:=clOrange;
end;

destructor TSpecialShapeFormat.Destroy;
begin
  SpecialShapeFormat.Border.Free;
  SpecialShapeFormat.Brush.Free;
  inherited;
end;

initialization
  RegisterClass(TCustomShapeForm);
finalization
  SpecialShapeFormat.Free;  // destroy global variable
end.
