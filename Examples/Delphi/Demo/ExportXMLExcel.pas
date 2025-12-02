unit ExportXMLExcel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, StdCtrls, TeCanvas, TeeTree, TreeEd, ExtCtrls, TeeProcs,
  TreeExport, TeeExport;

type
  TExportXMLExcelForm = class(TBaseForm)
    Label1: TLabel;
    Memo2: TMemo;
    ComboFlat1: TComboFlat;
    Button1: TButton;
    Node1: TTreeNodeShape;
    Node2: TTreeNodeShape;
    TreeNodeShape1_TreeNodeShape2: TTreeConnection;
    Node3: TTreeNodeShape;
    TreeNodeShape1_TreeNodeShape3: TTreeConnection;
    Node4: TTreeNodeShape;
    TreeNodeShape1_TreeNodeShape4: TTreeConnection;
    Node5: TTreeNodeShape;
    TreeNodeShape1_TreeNodeShape5: TTreeConnection;
    Node6: TTreeNodeShape;
    TreeNodeShape1_TreeNodeShape6: TTreeConnection;
    Splitter1: TSplitter;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ComboFlat1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

uses
  TeePenDlg, ShellApi;

procedure TExportXMLExcelForm.Button1Click(Sender: TObject);
begin
  ShowTreeExport(Self,Tree1);
end;

procedure TExportXMLExcelForm.FormShow(Sender: TObject);
begin
  inherited;
  ComboFlat1.ItemIndex:=0;
  ComboFlat1Change(Self);
end;

Function GetTempFileName:String;
begin
  result:=TTeeExportFormBase.GetTempFolder;

  if result<>'' then
  begin
    if result[Length(result)]<>'\' then
       result:=result+'\';
  end
  else
    result:='c:\';
end;

procedure TExportXMLExcelForm.ComboFlat1Change(Sender: TObject);
var tmp : TTreeData;
    FileName : String;
begin
  // Create an exporting object:

  Case ComboFlat1.ItemIndex of
    0: tmp:=TTreeDataText.Create(Tree1);
    1: tmp:=TTreeDataHTML.Create(Tree1);
    2: tmp:=TTreeDataXML.Create(Tree1);
  else
    tmp:=TTreeDataXLS.Create(Tree1);
  end;

  try
    Memo2.Clear;

    if not (tmp is TTreeDataXLS) then
       Memo2.Lines.Text:=tmp.AsString // Show results in Memo
    else
    begin
      // Only for Excel, ask the user if we should start Excel
      // to show the resulting exported file

      if TeeYesNo('Do you want to start Excel?') then
      begin
        FileName:=GetTempFileName+'TeeTree2Demo.xls';
        tmp.SaveToFile(FileName);

        // Start Excel
        TeeGotoURL(Handle,FileName);
      end;
    end;
  finally
    tmp.Free;
  end;
end;

initialization
  RegisterClass(TExportXMLExcelForm);
end.
