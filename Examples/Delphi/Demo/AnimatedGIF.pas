unit AnimatedGIF;
{$I TeeDefs.inc}

interface

uses
  Windows, Messages,
  SysUtils, Classes,
  Graphics, Controls, Forms, Dialogs,
  Base,

  {$IFDEF D105}
  GIFImg,
  {$ELSE}
  GIFImage,
  {$ENDIF}

  TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs, ComCtrls;

type
  TAnimatedGIFForm = class(TBaseForm)
    TreeNodeShape1: TTreeNodeShape;
    ImageShape1: TImageShape;
    CheckBox1: TCheckBox;
    TreeNodeShape2: TTreeNodeShape;
    Label1: TLabel;
    TrackBar1: TTrackBar;
    procedure CheckBox1Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TAnimatedGIFForm.CheckBox1Click(Sender: TObject);
begin
  if ImageShape1.Image.Graphic is TGIFImage then
  with TGIFImage(ImageShape1.Image.Graphic) do
  begin
        {$IFDEF D105}
         Animate:=CheckBox1.Checked;    // New GIFImage unit (2007)
        {$ELSE}      
 
        if CheckBox1.Checked then
           DrawOptions:=DrawOptions+[goAnimate]
        else
           DrawOptions:=DrawOptions-[goAnimate]

        {$ENDIF}
  end;
end;

procedure TAnimatedGIFForm.TrackBar1Change(Sender: TObject);
begin
  if ImageShape1.Image.Graphic is TGIFImage then
  with TGIFImage(ImageShape1.Image.Graphic) do
       AnimationSpeed:=TrackBar1.Position;
end;

procedure TAnimatedGIFForm.FormCreate(Sender: TObject);
begin
  inherited;
  ImageShape1.Border.Visible:=True;
end;

initialization
  RegisterClass(TAnimatedGIFForm);
end.
