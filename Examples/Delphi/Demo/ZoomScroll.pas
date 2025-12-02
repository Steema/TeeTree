unit ZoomScroll;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs;

type
  TZoomScrollForm = class(TBaseForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

initialization
  RegisterClass(TZoomScrollForm);
end.
