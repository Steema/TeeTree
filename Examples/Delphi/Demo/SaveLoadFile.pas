unit SaveLoadFile;
{$I TeeDefs.inc}

interface

uses
  Windows, Messages,
  SysUtils, Classes,
  Graphics, Controls, Forms, Dialogs, ExtCtrls, StdCtrls,
  Base, TeeTree, TreeEd, TeeProcs, TeeExport;

type
  TSaveLoadFileForm = class(TBaseForm)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TSaveLoadFileForm.FormCreate(Sender: TObject);
var St : String;
begin
  inherited;

  // Set Edit1 to a temporary file name, with TTR extension:

  St:=TTeeExportFormBase.GetTempFolder;

  if St<>'' then
  begin
    Edit1.Text:=St;

    if Edit1.Text[Length(Edit1.Text)]<>'\' then
       Edit1.Text:=Edit1.Text+'\';
  end
  else
     Edit1.Text:='c:\';

  Edit1.Text:=Edit1.Text+'Tree1.ttr';
end;

procedure TSaveLoadFileForm.Button1Click(Sender: TObject);
var MyTree : TTree;
begin

  // Create a hidden Tree, and then save it to a file.
  MyTree:=TTree.Create(Self);

  try

    // Important:
    // At runtime, set this property to False so new nodes are owned
    // by the Tree. Owned nodes will then be saved, otherwise not.

    MyTree.NoOwnerShapes:=False;

    // Add sample nodes:
    MyTree.Add('Hello');
    MyTree.Add('World');

    // Cosmetic:
    MyTree.Color:=clAqua;

    // Save tree:
    SaveTreeToFile(MyTree,Edit1.Text);

  finally
    MyTree.Free; // destroy temporary Tree
  end;


  // After saving the Tree to a file, load it back into
  // the existing Tree1 :

  LoadTreeFromFile(TCustomTree(Tree1),Edit1.Text);

  // See also:

  //  LoadTreeFromFileDialog(TCustomTree(Tree1));

  //  LoadTreeChildsFromFile(Tree1.Roots[0],'c:\Sample.ttr');

  //  LoadTreeFromStream(TCustomTree(Tree1),MyStream);

  //  SaveTeeToStream(Tree1,MyStream);
end;

initialization
  RegisterClass(TSaveLoadFileForm);
end.
