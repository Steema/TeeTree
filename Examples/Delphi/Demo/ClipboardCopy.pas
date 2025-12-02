unit ClipboardCopy;

interface

uses
  Windows, Messages,
  SysUtils, Classes,
  Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs, TeCanvas, TreeUML,
  TreeFlow, TeeExport, TeeGIF, TeePNG, TeeJPEG, TeePCX, TeeGDIPlus;

type
  TClipboardCopyForm = class(TBaseForm)
    Label1: TLabel;
    Button1: TButton;
    ComboBox1: TComboFlat;
    BeveledShape1: TBeveledShape;
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    BeveledShape2: TBeveledShape;
    BeveledShape3: TBeveledShape;
    BeveledShape4: TBeveledShape;
    BeveledShape5: TBeveledShape;
    BeveledShape6: TBeveledShape;
    BeveledShape7: TBeveledShape;
    NoteShape1: TNoteShape;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Procedure DoCopy(Format:TTeeExportFormatClass);
  end;

implementation

{$R *.DFM}

Procedure TClipboardCopyForm.DoCopy(Format:TTeeExportFormatClass);
begin
  with Format.Create do
  try
    Panel:=Self.Tree1;

    // Set picture size:
    Width :=400;
    Height:=400;
    
    CopyToClipboard;  // copy !
  finally
    Free;
  end;
end;

procedure TClipboardCopyForm.Button1Click(Sender: TObject);
begin
  Case ComboBox1.ItemIndex of
    0: Tree1.CopyToClipboardBitmap;
    1: Tree1.CopyToClipboardMetafile(True);
    2: DoCopy(TGIFExportFormat);
    3: DoCopy(TPNGExportFormat);
    4: DoCopy(TJPEGExportFormat);
    5: DoCopy(TPCXExportFormat);
  end;
end;

procedure TClipboardCopyForm.FormCreate(Sender: TObject);
begin
  inherited;
  ComboBox1.ItemIndex:=0;  // default = Bitmap format

  // Setup Tree size for exporting to Bitmap and Metafile:
  Tree1.Page.Width :=400;
  Tree1.Page.Height:=400;
end;

initialization
  RegisterClass(TClipboardCopyForm);
end.
