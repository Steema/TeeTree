unit CustomInspector;

interface

uses
  Windows, Messages,
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, ExtCtrls, Grids, TeeInspector, TreeEd,
  StdCtrls, TeeProcs;

type
  TCustomInspectorForm = class(TBaseForm)
    TeeInspector1: TTeeInspector;
    Splitter1: TSplitter;
    TextShape1: TTextShape;
    procedure FormCreate(Sender: TObject);
    procedure TeeInspector1Items0Change(Sender: TObject);
    procedure TeeInspector1Items1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TCustomInspectorForm.FormCreate(Sender: TObject);
begin
  inherited;

  // Initialize inspector values:
  TeeInspector1.Items[0].Value:=Tree1.Color;
  TeeInspector1.Items[1].Value:=TextShape1.Font.Size;
end;

procedure TCustomInspectorForm.TeeInspector1Items0Change(Sender: TObject);
begin
  Tree1.Color:=TeeInspector1.Items[0].Value;
end;

procedure TCustomInspectorForm.TeeInspector1Items1Change(Sender: TObject);
begin
  TextShape1.Font.Size:=TeeInspector1.Items[1].Value;
end;

initialization
  RegisterClass(TCustomInspectorForm);
end.
