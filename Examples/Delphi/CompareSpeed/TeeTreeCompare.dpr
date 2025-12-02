program TeeTreeCompare;
{$I TeeDefs.inc}

uses
  Forms,
  UTreeCompare in 'UTreeCompare.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'TeeTree speed compared to TreeView';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
