unit TreeBackImage;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, StdCtrls, TeeTree, TreeEd, ExtCtrls, TeeProcs;

type
  TBackImageForm = class(TBaseForm)
    Label1: TLabel;
    ComboBox1: TComboBox;
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeShape3: TTreeNodeShape;
    TreeNodeShape4: TTreeNodeShape;
    procedure FormShow(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TBackImageForm.FormShow(Sender: TObject);
begin
  inherited;
  ComboBox1.ItemIndex:=1;
end;

procedure TBackImageForm.ComboBox1Change(Sender: TObject);
begin
  // Change BackImage display mode...
  Case ComboBox1.ItemIndex of
    0: Tree1.BackImageMode:=pbmCenter;
    1: Tree1.BackImageMode:=pbmStretch;
    2: Tree1.BackImageMode:=pbmTile;
  end;
end;

procedure TBackImageForm.FormCreate(Sender: TObject);
begin
  inherited;

  // To set a Back image at run-time:
  //
  // Tree1.BackImage:=Image1
  // or...
  // Tree1.BackImage.LoadFromFile('c:\mypicture.bmp'); etc, etc..
end;

initialization
  RegisterClass(TBackImageForm);
end.
