unit PrintPreviewPanel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, StdCtrls, TeePreviewPanel, TeeTree, TreeEd, ExtCtrls, TeeProcs,
  TreeFlow, TeCanvas, TeePenDlg, TeeGDIPlus;

type
  TPrintPreviewPanelForm = class(TBaseForm)
    TeePreviewPanel1: TTeePreviewPanel;
    Label1: TLabel;
    ComboBox1: TComboFlat;
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeShape3: TTreeNodeShape;
    ArrowDownShape1: TArrowDownShape;
    TreeNodeShape4: TTreeNodeShape;
    TreeNodeShape5: TTreeNodeShape;
    ButtonColor1: TButtonColor;
    ButtonPen1: TButtonPen;
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TPrintPreviewPanelForm.FormCreate(Sender: TObject);
begin
  inherited;

  TeePreviewPanel1.Panel:=Tree1;
  Tree1.Page.Width:=Tree1.ClientWidth;
  Tree1.Page.Height:=Tree1.ClientHeight;

  // Setup buttons:
  ButtonColor1.LinkProperty(TeePreviewPanel1,'PaperColor');
  ButtonPen1.LinkPen(TeePreviewPanel1.Margins);

  ComboBox1.ItemIndex:=0;
end;

procedure TPrintPreviewPanelForm.ComboBox1Change(Sender: TObject);
begin
  Case ComboBox1.ItemIndex of
    0: TeePreviewPanel1.Orientation:=ppoDefault;
    1: TeePreviewPanel1.Orientation:=ppoPortrait;
    2: TeePreviewPanel1.Orientation:=ppoLandscape;
  end;
end;

initialization
  RegisterClass(TPrintPreviewPanelForm);
end.
