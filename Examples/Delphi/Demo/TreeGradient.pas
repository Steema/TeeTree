unit TreeGradient;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, StdCtrls, TeeTree, TreeEd, ExtCtrls, TeeProcs;

type
  TTreeGradientForm = class(TBaseForm)
    Button1: TButton;
    Label1: TLabel;
    CBDirection: TComboBox;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CBDirectionChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

Uses TeCanvas,  // <-- important, to access Gradient Direction constants
     TeeEdiGrad  // <-- gradient editor dialog
     ;

procedure TTreeGradientForm.Button1Click(Sender: TObject);
begin
  // Show the Gradient editor dialog
  TTeeGradientEditor.Edit(Self,Tree1.Gradient);

  // Refresh combo-box
  CBDirection.ItemIndex:=Ord(Tree1.Gradient.Direction);
end;

procedure TTreeGradientForm.FormCreate(Sender: TObject);
begin
  inherited;

  // Display gradient background

  Tree1.Gradient.Visible     :=True;
  Tree1.Gradient.StartColor  :=clNavy;
  Tree1.Gradient.MidColor    :=clRed;
  Tree1.Gradient.EndColor    :=clGreen;
  Tree1.Gradient.Direction   :=gdLeftRight;

  CBDirection.ItemIndex:=2;
end;

procedure TTreeGradientForm.CBDirectionChange(Sender: TObject);
begin
  // Change gradient Direction :
  Tree1.Gradient.Direction:=TGradientDirection(CBDirection.ItemIndex);
end;

initialization
  RegisterClass(TTreeGradientForm);
end.
