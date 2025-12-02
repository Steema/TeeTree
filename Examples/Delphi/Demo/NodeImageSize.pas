unit NodeImageSize;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, ComCtrls, StdCtrls, TeeTree, TreeEd, ExtCtrls, TeeProcs;

type
  TNodeImageSizeForm = class(TBaseForm)
    Label1: TLabel;
    CBDefault: TCheckBox;
    Edit1: TEdit;
    UpDown1: TUpDown;
    Label2: TLabel;
    Edit2: TEdit;
    UpDown2: TUpDown;
    TreeNodeShape1: TTreeNodeShape;
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Tree1AfterDraw(Sender: TObject);
    procedure CBDefaultClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TNodeImageSizeForm.Edit1Change(Sender: TObject);
begin
  CBDefault.Checked:=False;

  // Set custom image width
  TreeNodeShape1.ImageWidth:=UpDown1.Position;
end;

procedure TNodeImageSizeForm.Edit2Change(Sender: TObject);
begin
  CBDefault.Checked:=False;

  // Set custom image height
  TreeNodeShape1.ImageHeight:=UpDown2.Position;
end;

procedure TNodeImageSizeForm.FormCreate(Sender: TObject);
begin
  inherited;

  // Actual image size
  UpDown1.Position:=TreeNodeShape1.Image.Width;
  UpDown2.Position:=TreeNodeShape1.Image.Height;
end;

procedure TNodeImageSizeForm.Tree1AfterDraw(Sender: TObject);
begin
  // Draw a red rectangle around the node image :

  with Tree1.Canvas do
  begin
    Pen.Color:=clRed;
    Pen.Width:=2;
    Pen.Style:=psSolid;

    Brush.Style:=bsClear;

    with TreeNodeShape1.ImageRect do
         Rectangle( Left, Top, Right+2, Bottom+2 );
  end;
end;

procedure TNodeImageSizeForm.CBDefaultClick(Sender: TObject);
begin
  // Set back the image size to default
  // ( default = original image size )

  TreeNodeShape1.ImageWidth:=0;
  TreeNodeShape1.ImageHeight:=0;
end;

initialization
  RegisterClass(TNodeImageSizeForm);
end.
