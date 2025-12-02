unit TextAngle;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, ComCtrls, StdCtrls, TeeTree, TreeEd, ExtCtrls, TeeProcs;

type
  TTextAngleForm = class(TBaseForm)
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeShape3: TTreeNodeShape;
    TreeNodeShape4: TTreeNodeShape;
    TreeNodeShape5: TTreeNodeShape;
    Label1: TLabel;
    TrackBar1: TTrackBar;
    Label2: TLabel;
    procedure TrackBar1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TTextAngleForm.TrackBar1Change(Sender: TObject);
begin
  TreeNodeShape5.Text.Angle:=TrackBar1.Position;
  Label2.Caption:=IntToStr(TrackBar1.Position)+' degree';
end;

procedure TTextAngleForm.FormCreate(Sender: TObject);
begin
  inherited;
  TreeNodeShape1.Text.HorizOffset:=10;
end;

initialization
  RegisterClass(TTextAngleForm);
end.
