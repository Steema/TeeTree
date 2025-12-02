unit Exporting;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, StdCtrls, TeeTree, TreeEd, ExtCtrls, TeeProcs, TeCanvas;

type
  TExportingForm = class(TBaseForm)
    Label1: TLabel;
    Button1: TButton;
    ComboFlat1: TComboFlat;
    Button2: TButton;
    SaveDialog1: TSaveDialog;
    ImageShape1: TImageShape;
    ImageShape2: TImageShape;
    ImageShape3: TImageShape;
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeShape3: TTreeNodeShape;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

uses TeeExport,
     TeeJPEG, TeeGIF, TeePNG, TeePCX,
     TeeBMPOptions, TeeEMFOptions, TeeHTML5Canvas, TeePDFCanvas;

procedure TExportingForm.Button1Click(Sender: TObject);
begin
  // Show Export dialog:
  ShowTreeExport(Self,Tree1);
end;

procedure TExportingForm.FormCreate(Sender: TObject);
begin
  inherited;
  ComboFlat1.ItemIndex:=0;
end;

procedure TExportingForm.Button2Click(Sender: TObject);
var ExportClass  : TTeeExportFormatClass;
    ExportFormat : TTeeExportFormat;
begin
  // Choose a graphic export format:
  Case ComboFlat1.ItemIndex of
    0: ExportClass := TBMPExportFormat;
    1: ExportClass := TEMFExportFormat;
    2: ExportClass := TJPEGExportFormat;
    3: ExportClass := TPNGExportFormat;
    4: ExportClass := TPCXExportFormat;
  else
    ExportClass := TGIFExportFormat;
  end;

  // Create exporting format
  ExportFormat:=ExportClass.Create;
  try
    ExportFormat.Panel:=Tree1;  // set Tree

    // use maximum bounds (including non-visible Tree nodes)
    ExportFormat.Width:=Tree1.TotalBounds.Right;
    ExportFormat.Height:=Tree1.TotalBounds.Bottom;

    with SaveDialog1 do
    begin
      // prepare Save dialog
      DefaultExt:=ExportFormat.FileExtension;
      Filter:=ExportFormat.FileFilter;
      FileName:='TeeTree';

      // Use Exporting format to save:
      if Execute then
         ExportFormat.SaveToFile(FileName);
    end;
  finally
    ExportFormat.Free;  // destroy temporary Export format
  end;
end;

initialization
  RegisterClass(TExportingForm);
end.
