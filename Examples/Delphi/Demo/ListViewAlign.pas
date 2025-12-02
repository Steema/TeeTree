unit ListViewAlign;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs, TreeChildManagers,
  ComCtrls;

type
  TListViewAlignForm = class(TBaseForm)
    Label1: TLabel;
    Edit1: TEdit;
    UpDown1: TUpDown;
    Label2: TLabel;
    Edit2: TEdit;
    UpDown2: TUpDown;
    procedure FormCreate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ListView : TTreeListViewAlignChild;
  end;

implementation

{$R *.DFM}

procedure TListViewAlignForm.FormCreate(Sender: TObject);
var t : Integer;
begin
  inherited;

  // Replace child manager:
  ListView:=TTreeListViewAlignChild.Create;
  Tree1.ChangeManager(ListView);

  // Add 100 sample nodes
  for t:=0 to 99 do
      Tree1.Add('Node '+IntToStr(t));

  // Cosmetic
  Tree1.GlobalFormat.Border.Visible:=False;

  // Select first node:
  Tree1[0].Selected:=True;
end;

procedure TListViewAlignForm.Edit1Change(Sender: TObject);
begin
  ListView.HorizMargin:=UpDown1.Position;
  Tree1.Invalidate;
end;

procedure TListViewAlignForm.Edit2Change(Sender: TObject);
begin
  ListView.VertMargin:=UpDown2.Position;
  Tree1.Invalidate;
end;

initialization
  RegisterClass(TListViewAlignForm);
end.
