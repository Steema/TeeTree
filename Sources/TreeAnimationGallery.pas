{**********************************************}
{   TTreeAnimate Gallery Dialog                }
{   Copyright (c) 2001-2025 by Steema Software }
{**********************************************}
{$I TeeDefs.inc}
unit TreeAnimationGallery;

interface

uses
  {$IFNDEF LINUX}
  Windows, Messages,
  {$ENDIF}
  SysUtils, Classes,

  Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  TeeAnimate, TreeAnimate, TeeTree, TeeProcs, TeeGDIPlus;

type
  TTreeAnimationGallery = class(TForm)
    ListBox1: TListBox;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Tree1: TTree;
    TreeAnimate1: TTreeAnimate;
    procedure FormCreate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    Procedure PreviewAnimation;
  public
    { Public declarations }
    class Function Select:TTeeAnimationClass;
    Function SelectedClass:TTeeAnimationClass;
  end;

implementation

{$IFNDEF LCL}
{$R *.DFM}
{$ELSE}
{$R *.lfm}
{$ENDIF}

Uses
  TeeTranslate;

procedure TTreeAnimationGallery.FormCreate(Sender: TObject);
var t : Integer;
    tmp : TTeeAnimationClass;
begin
  // Add available animation classes:
  for t:=0 to TeeAnimationClasses.Count-1 do
  begin
    tmp:=TTeeAnimationClass(GetClass(TeeAnimationClasses[t]));

    if (csDesigning in ComponentState) or (not (tmp=TCustomAnimation)) then
       ListBox1.Items.AddObject(tmp.Description,TObject(t));
  end;
end;

// Show the Gallery modally, returns nil or a selected animation class.
class function TTreeAnimationGallery.Select: TTeeAnimationClass;
begin
  result:=nil;

  with TTreeAnimationGallery.Create(Application) do
  try
    if ShowModal=mrOk then
       result:=SelectedClass;
  finally
    Free;
  end;
end;

Function TTreeAnimationGallery.SelectedClass:TTeeAnimationClass;
begin
  result:=TTeeAnimationClass(GetClass(TeeAnimationClasses[Integer(ListBox1.Items.Objects[ListBox1.ItemIndex])]));
end;

procedure TTreeAnimationGallery.ListBox1Click(Sender: TObject);
begin
  Button1.Enabled:=ListBox1.ItemIndex<>-1;
  PreviewAnimation;
end;

procedure TTreeAnimationGallery.ListBox1DblClick(Sender: TObject);
begin
  if ListBox1.ItemIndex<>-1 then
     ModalResult:=mrOk;
end;

// Show the animation in the preview Tree:
Procedure TTreeAnimationGallery.PreviewAnimation;
var tmp : TTeeAnimation;
    tmpPause : TCustomAnimation;
begin
  TreeAnimate1.Stop;
  Tree1.Clear;
  TreeAnimate1.Animations.Clear;

  with Tree1.Add('Hello World !') do
  begin
    ImageIndex:=tiNone;
    X0:=Tree1.ChartXCenter-(Width div 2);
    Y0:=Tree1.ChartYCenter-(Height div 2);
    Border.Visible:=False;
    Transparent:=True;
    AutoSize:=False;
  end;

  TreeAnimate1.Speed:=15;
  TreeAnimate1.Loop:=True;

  tmp:=SelectedClass.Create(Self);
  TreeAnimate1.Animations.Add(tmp);
  tmp.Preview;

  tmpPause:=TCustomAnimation.Create(Self);
  tmpPause.StartFrame:=tmp.EndFrame;
  tmpPause.Duration:=10;
  TreeAnimate1.Animations.Add(tmpPause);

  TreeAnimate1.Play;
end;

procedure TTreeAnimationGallery.FormShow(Sender: TObject);
begin
  TeeTranslateControl(Self);
end;

end.
