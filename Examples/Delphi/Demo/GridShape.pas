unit GridShape;

interface

uses
  Windows, Messages,
  SysUtils, Classes,
  Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs,
  TreeFlow, ComCtrls;

type
  TGridShapeForm = class(TBaseForm)
    Edit1: TEdit;
    UpDown1: TUpDown;
    Edit2: TEdit;
    UpDown2: TUpDown;
    Label1: TLabel;
    Label2: TLabel;
    GridShape1: TGridShape;
    Button1: TButton;
    CheckBox1: TCheckBox;
    Panel2: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Shape1: TShape;
    Edit3: TEdit;
    procedure Edit2Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Tree1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Edit3Change(Sender: TObject);
    procedure GridShape1DblClick(Sender: TTreeNodeShape;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

uses TeCanvas;

procedure TGridShapeForm.Edit2Change(Sender: TObject);
begin
  GridShape1.Columns:=UpDown2.Position;
end;

procedure TGridShapeForm.Edit1Change(Sender: TObject);
begin
  GridShape1.Rows:=UpDown1.Position;
end;

procedure TGridShapeForm.FormCreate(Sender: TObject);
var Row, Column : Integer;
begin
  inherited;

  // Set the Text Font Color of selected nodes to "none":
  Tree1.Selected.TextColor:=clNone;

  // Add text to grid cells:
  with GridShape1 do
  begin
    Cells[0,0].SimpleText:='Red';    Cells[0,0].Color:=clRed;
    Cells[0,1].SimpleText:='Blue';   Cells[0,1].Color:=clBlue;
    Cells[0,2].SimpleText:='Green';  Cells[0,2].Color:=clGreen;
    Cells[1,0].SimpleText:='Yellow'; Cells[1,0].Color:=clYellow;
    Cells[1,1].SimpleText:='White';  Cells[1,1].Color:=clWhite;
    Cells[1,2].SimpleText:='Lime';   Cells[1,2].Color:=clLime;
    Cells[2,0].SimpleText:='Aqua';   Cells[2,0].Color:=clAqua;
    Cells[2,1].SimpleText:='Silver'; Cells[2,1].Color:=clSilver;
    Cells[2,2].SimpleText:='Black';  Cells[2,2].Color:=clBlack;
                                     Cells[2,2].Font.Color:=clWhite;

    // Set all cells to opaque (not transparent) to fill color:
    for Row:=0 to Rows-1 do
        for Column:=0 to Rows-1 do
            Cells[Row,Column].Transparent:=False;

    // Example: make middle cell font size bigger:
    Cells[1,1].Font.Size:=14;

    // Example: show gradient in lower bottom cell:
    Cells[2,0].Gradient.Visible:=True;
    Cells[2,0].Gradient.EndColor:=clRed;
  end;

  // Change default selection format:
  Tree1.Selected.Border.Width:=2;
  Tree1.Selected.Border.SmallDots:=False;
  Tree1.Selected.Color:=clNone;   // transparent selection
end;

procedure TGridShapeForm.Button1Click(Sender: TObject);
begin
  // Resize rows and columns according to cell text dimensions:
  GridShape1.AutoSize:=True;
end;

procedure TGridShapeForm.CheckBox1Click(Sender: TObject);
begin
  Tree1.Designing:=CheckBox1.Checked;
end;

procedure TGridShapeForm.Tree1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var tmp : TGridCellShape;
begin
  // Find the specific cell under XY:
  tmp:=GridShape1.CellAt(x,y);

  // If ok :
  if Assigned(tmp) then
  begin
    // Show Row and Colum:
    Label4.Caption:=IntToStr(tmp.Row)+','+IntToStr(tmp.Column);

    // Show Cell text:
    Edit3.Tag:=0;
    Edit3.Text:=tmp.SimpleText;
    Edit3.Tag:=Integer(tmp);
    Edit3.Enabled:=True;

    // Show Cell color:
    Shape1.Visible:=True;
    Shape1.Brush.Color:=tmp.Color;
  end
  else
  begin
    Label4.Caption:='';

    Edit3.Tag:=0;
    Edit3.Text:='';
    Edit3.Enabled:=False;

    Shape1.Visible:=False;
  end;
end;

procedure TGridShapeForm.Edit3Change(Sender: TObject);
begin
  // Change an individual cell text with Edit3 contents:
  if Edit3.Tag>0 then
     TGridCellShape(Edit3.Tag).SimpleText:=Edit3.Text;
end;

procedure TGridShapeForm.GridShape1DblClick(Sender: TTreeNodeShape;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var tmp : TGridCellShape;
begin
  // Show the color dialog to change the double-clicked cell color:
  tmp:=GridShape1.CellAt(x,y);
  if Assigned(tmp) then
  begin
    // Show Color dialog and change color:
    tmp.Color:=TButtonColor.Edit(Self,tmp.Color);

    // Remove transparency:
    tmp.Transparent:=False;
  end;
end;

initialization
  RegisterClass(TGridShapeForm);
end.
