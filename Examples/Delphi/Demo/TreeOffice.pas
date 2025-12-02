unit TreeOffice;
{$I TeeDefs.inc}

interface

uses
  {$IFNDEF LINUX}
  Windows, Messages, 
  {$ENDIF}
  SysUtils, Classes, 
  Graphics, Controls, Forms, Dialogs, ExtCtrls,
  TeeTree, TeeProcs, TeeGDIPlus;

type
  TTreeOfficeForm = class(TForm)
    Tree1: TTree;
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeShape3: TTreeNodeShape;
    TreeNodeShape4: TTreeNodeShape;
    PolyLineShape1: TPolyLineShape;
    procedure TreeNodeShape4Click(Sender: TTreeNodeShape;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TTreeOfficeForm.TreeNodeShape4Click(Sender: TTreeNodeShape;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  TeeGotoURL(Handle,'http://www.steema.com/products/TeeTreeOffice');
end;

procedure TTreeOfficeForm.FormCreate(Sender: TObject);
begin
  Tree1.Selected.Color:=clNone;
end;

initialization
  RegisterClass(TTreeOfficeForm);
end.
