unit TreeImageList;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, ImgList, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs;

type
  TTreeImageListForm = class(TBaseForm)
    ImageList1: TImageList;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TTreeImageListForm.FormCreate(Sender: TObject);
begin
  inherited;

  // Use image list :
  Tree1.Images:=ImageList1;

  // Add sample nodes :

  Tree1.Add('First picture in image list').ImageListIndex:=0;
  Tree1.Add('Second picture in image list').ImageListIndex:=1;
  Tree1.Add('Third picture in image list').ImageListIndex:=2;
  Tree1.Add('Fourth picture in image list').ImageListIndex:=3;
end;

initialization
  RegisterClass(TTreeImageListForm);
end.
