unit OtherComponents;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, StdCtrls, TeCanvas, TeeTree, TeePenDlg, TreeEd, ExtCtrls, TeeProcs;

type
  TOtherComponentsForm = class(TBaseForm)
    Label1: TLabel;
    ButtonColor1: TButtonColor;
    Label2: TLabel;
    ButtonPen1: TButtonPen;
    TreeNodeShape1: TTreeNodeShape;
    ComboFlat1: TComboFlat;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ComboFlat1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TOtherComponentsForm.FormCreate(Sender: TObject);
begin
  inherited;

  // Setup components:
  
  ButtonColor1.LinkProperty(TreeNodeShape1,'Color');

  ButtonPen1.LinkPen(TreeNodeShape1.Border);

  ComboFlat1.ItemIndex:=0;
end;

procedure TOtherComponentsForm.ComboFlat1Change(Sender: TObject);
begin
  Case ComboFlat1.ItemIndex of
    0: TreeNodeShape1.Style:=tssRectangle;
    1: TreeNodeShape1.Style:=tssCircle;
    2: TreeNodeShape1.Style:=tssDiamond;
  end;
end;

initialization
  RegisterClass(TOtherComponentsForm);
end.
