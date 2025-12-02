unit NodeDataTag;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, Buttons, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs;

type
  TNodeDataForm = class(TBaseForm)
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Tree1SelectShape(Sender: TTreeNodeShape);
    procedure Tree1UnSelectShape(Sender: TTreeNodeShape);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NodeDataForm: TNodeDataForm;

implementation

{$R *.DFM}

procedure TNodeDataForm.SpeedButton1Click(Sender: TObject);
var t : Integer;
begin
  // When a button is clicked, select the corresponding
  // Tree node...

  Tree1.Selected.Clear;  // clear Tree selection

  for t:=0 to Tree1.Shapes.Count-1 do // traverse all nodes

      if Tree1[t].Data=Sender then  // if the node "Data" equals sender ...
      begin
        Tree1[t].Selected:=True; // select node and quit
        break;
      end;

end;

procedure TNodeDataForm.FormCreate(Sender: TObject);
begin
  inherited;

  // Add four nodes, setting the node "Data" property

  Tree1.AddRootObject('Button 1',SpeedButton1);
  Tree1.AddRootObject('Button 2',SpeedButton2);
  Tree1.AddRootObject('Button 3',SpeedButton3);
  Tree1.AddRootObject('Button 4',SpeedButton4);
end;

procedure TNodeDataForm.Tree1SelectShape(Sender: TTreeNodeShape);
begin
  // When a node is selected, use the "Data" property
  // to push the associated SpeedButton

  TSpeedButton(Sender.Data).Down:=True;
end;

procedure TNodeDataForm.Tree1UnSelectShape(Sender: TTreeNodeShape);
begin
  // When a node is un-selected, use the "Data" property
  // to un-selected the associated SpeedButton

  TSpeedButton(Sender.Data).Down:=False;
end;

initialization
  RegisterClass(TNodeDataForm);
end.
