unit Unit_FMX_Mobile_Tree_Settings;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls, FMX.Layouts,
  FMXTee.Tree;

type
  TSettingsForm = class(TForm)
    Layout1: TLayout;
    Button1: TButton;
    CheckBox1: TCheckBox;
    procedure CheckBox1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Tree : TCustomTree;
  end;

var
  SettingsForm: TSettingsForm;

implementation

{$R *.fmx}

procedure TSettingsForm.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TSettingsForm.CheckBox1Change(Sender: TObject);
var t : Integer;
    Manager : TTreeExplorerAlignChild;
begin
  for t := 0 to Tree.Items.Count-1 do
      Tree.Items[t].Connections.Visible:=CheckBox1.IsChecked;

  // Advanced: Change ChildManager properties:
  Manager:=(Tree.GlobalFormat.ChildManager as TTreeExplorerAlignChild);

  if CheckBox1.IsChecked then
     Manager.HorizMargin:=19
  else
     Manager.HorizMargin:=9
end;

end.
