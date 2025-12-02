unit TextExportImport;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs;

type
  TTextExportImportForm = class(TBaseForm)
    Memo2: TMemo;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TTextExportImportForm.Button1Click(Sender: TObject);
var tmp : TStringStream;
begin
  // Create temporary stream...
  tmp:=TStringStream.Create('');
  try
    // Store all nodes into stream...
    SaveTreeTextToStream(tmp,Tree1);

    // Reset stream position to 0 ( start of stream )
    tmp.Position:=0;

    // Load stream into Memo...
    Memo2.Lines.LoadFromStream(tmp);
  finally
    tmp.Free;  // destroy temporary stream
  end;
end;

procedure TTextExportImportForm.Button2Click(Sender: TObject);
begin
  Tree1.Clear;
  Tree1.LoadFromStrings(Memo2.Lines);

  // To import from text file:
  //   Tree1.LoadFromTextFile('c:\mytext.txt');

  // Format of text file:

  // root1
  //  children1
  //  children2
  // root2
  // ...etc

end;

procedure TTextExportImportForm.FormCreate(Sender: TObject);
var t : Integer;
begin
  inherited;

  // Default format:
  Tree1.GlobalFormat.Border.Visible:=False;

  // Add sample nodes...
  with Tree1.Add('Root1') do
    for t:=1 to 10 do AddChild('Child'+IntToStr(t));

  with Tree1.Add('Root2') do
    for t:=1 to 5 do AddChild('Child'+IntToStr(t));

  Tree1.Roots[0].Expanded:=True;
end;

initialization
  RegisterClass(TTextExportImportForm);
end.
