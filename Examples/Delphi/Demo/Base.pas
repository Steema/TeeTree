unit Base;

{ TeeTree 2 Demo - Base Form }
{ This form is inherited by most of the example forms in this demo. }

{ It only contains a Tree control, a Memo and a TreeEditor component. }
{ When double-clicking the Memo the TreeEditor is shown. }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, TeeProcs, TeeTree, StdCtrls, TreeEd, TeeGDIPlus, TeCanvas;

type
  TBaseForm = class(TForm)
    Tree1: TTree;
    Memo1: TMemo;
    Panel1: TPanel;
    TreeEdit1: TTreeEdit;
    procedure Memo1DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TNewCanvasStyle=(ncGDI, ncOpenGL, ncAntiAlias, ncGDIPlus);

var
  TeeNewCanvas : TNewCanvasStyle = ncGDIPlus;

implementation

{$R *.DFM}

Uses
  TeeGLCanvas, TeeOpenGL, TeeAntiAlias;

procedure TBaseForm.Memo1DblClick(Sender: TObject);
begin
  TreeEdit1.Execute  // Show TTree editor dialog
end;

procedure TBaseForm.FormCreate(Sender: TObject);
var GL : TTeeOpenGL;
    tmp : TCanvas3DClass;
begin
  case TeeNewCanvas of
    ncOpenGL    : tmp:=TGLCanvas;
    ncAntiAlias : tmp:=TAntiAliasCanvas;
    ncGDIPlus   : tmp:=TGDIPlusCanvas;
  else
    {ncGDI       :} tmp:=TTeeCanvas3D;
  end;

  if Tree1.Canvas.ClassType<>tmp then
    if tmp=TGLCanvas then
    begin
      GL:=TTeeOpenGL.Create(Self);
      GL.TeePanel:=Tree1;
      GL.Active:=True;

      // Force zoom
      Tree1.View3DOptions.Zoom:=40;
      Tree1.View3DOptions.Perspective:=50;
    end
    else
      Tree1.Canvas:=tmp.Create;
end;

initialization
  RegisterClass(TBaseForm);
end.
