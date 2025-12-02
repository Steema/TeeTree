unit NodeImageIndex;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs;

type
  TNodeImageIndexForm = class(TBaseForm)
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

Uses TreeChildManagers;

procedure TNodeImageIndexForm.FormCreate(Sender: TObject);
var tmpIndex : TTreeNodeImageIndex;
begin
  inherited;

  with Tree1 do
  begin
    GlobalFormat.Border.Visible:=False;  // hide border

    // Add sample nodes
    Add('My PC').ImageIndex          :=tiMyPC;
    Add('Folder Close').ImageIndex   :=tiFolderClose;
    Add('Folder Open').ImageIndex    :=tiFolderOpen;
    Add('Desktop').ImageIndex        :=tiDesktop;
    Add('Network').ImageIndex        :=tiNetworkNei;
    Add('Floppy').ImageIndex         :=tiFloppy3;
    Add('Recicle Bin').ImageIndex    :=tiRecycleBin;
    Add('Hard Disk').ImageIndex      :=tiHardDisk;
    Add('Net Share').ImageIndex      :=tiNetShare;
    Add('Computer').ImageIndex       :=tiComputer;
    Add('World').ImageIndex          :=tiWorld;
    Add('Checked').ImageIndex        :=tiChecked;
    Add('UnChecked').ImageIndex      :=tiUnChecked;
    Add('Radio Checked').ImageIndex  :=tiRadioChecked;
    Add('Radio UnChecked').ImageIndex:=tiRadioUnChecked;

    Add('Folder Closed Checked').ImageIndex  :=tiFolderCloseChecked;
    Add('Folder Closed UnChecked').ImageIndex:=tiFolderCloseUnChecked;
    Add('Folder Radio Checked').ImageIndex   :=tiFolderRadioChecked;
    Add('Folder Radio UnChecked').ImageIndex :=tiFolderRadioUnChecked;

    // Add a custom image to list:
    tmpIndex:=TreeImagePool.Add(Image1.Picture);

    // Add a new node using the above image index:
    Add('Custom image (Euro)').ImageIndex:=tmpIndex;

    // Use a "ListView" child manager...
    GlobalFormat.ChildManager.Free;
    GlobalFormat.ChildManager:=TTreeListViewAlignChild.Create;

    // Change default column width :
    TTreeListViewAlignChild(GlobalFormat.ChildManager).ColWidth:=120;
  end;
end;

initialization
  RegisterClass(TNodeImageIndexForm);
end.
