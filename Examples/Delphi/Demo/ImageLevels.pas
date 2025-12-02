unit ImageLevels;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs, ImgList;

type
  TImageLevelsForm = class(TBaseForm)
    ImageLevels1: TImageLevels;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ImageLevelsForm: TImageLevelsForm;

implementation

{$R *.DFM}

procedure TImageLevelsForm.FormCreate(Sender: TObject);
begin
  inherited;

  // Add sample nodes...

  with Tree1.Add('Level 0') do
  begin
    AddChild('Level 1').AddChild('Level 2');
    AddChild('Level 1');
  end;

  with Tree1.Add('Level 0') do
  begin
    AddChild('Level 1');
    AddChild('Level 1').AddChild('Level 2');
    AddChild('Level 1').AddChild('Level 2').AddChild('Level 3');
  end;

  // Recursive expand all nodes...
  Tree1.FullExpandCollapse(True);

  // Set ImageLevels
  ImageLevels1.Tree:=Tree1;
end;

procedure TImageLevelsForm.Button1Click(Sender: TObject);
begin
  // exchange images...
  ImageLevels1.Move(0,2);
  ImageLevels1.Move(1,3);

  // repaint Tree...
  Tree1.Invalidate;
end;

initialization
  RegisterClass(TImageLevelsForm);
end.
