unit NodeEvents;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, TeeTree, TreeEd, ExtCtrls, StdCtrls, TeeProcs, TreeFlow;

type
  TNodeEventsForm = class(TBaseForm)
    Node1: TTreeNodeShape;
    Node2: TTreeNodeShape;
    Node3: TTreeNodeShape;
    Node4: TTreeNodeShape;
    Node5: TTreeNodeShape;
    Node6: THouseShape;
    Label1: TLabel;
    Label2: TLabel;
    LabelName: TLabel;
    LabelEvent: TLabel;
    Label3: TLabel;
    LabelButton: TLabel;
    Label4: TLabel;
    LabelWheel: TLabel;
    procedure Node1Click(Sender: TTreeNodeShape; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Node1DblClick(Sender: TTreeNodeShape; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Node1MouseEnter(Sender: TTreeNodeShape; Shift: TShiftState;
      X, Y: Integer);
    procedure Node1MouseLeave(Sender: TTreeNodeShape; Shift: TShiftState;
      X, Y: Integer);
    procedure Node1MouseMove(Sender: TTreeNodeShape; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure Tree1MouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure Tree1MouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure Tree1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure Tree1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

// Return a textual representation of Button
Function ButtonName(Button:TMouseButton):String;
begin
  Case Button of
    mbLeft   : result:='Left';
    mbMiddle : result:='Middle';
    mbRight  : result:='Right';
  end;
end;

procedure TNodeEventsForm.Node1Click(Sender: TTreeNodeShape;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  LabelName.Caption:=Sender.Name;
  LabelEvent.Caption:='On Click';
  LabelButton.Caption:=ButtonName(Button);
end;

procedure TNodeEventsForm.Node1DblClick(Sender: TTreeNodeShape;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  LabelName.Caption:=Sender.Name;
  LabelEvent.Caption:='On Double Click';
  LabelButton.Caption:=ButtonName(Button);
end;

procedure TNodeEventsForm.Node1MouseEnter(Sender: TTreeNodeShape;
  Shift: TShiftState; X, Y: Integer);
begin
  LabelName.Caption:=Sender.Name;
  LabelEvent.Caption:='On Mouse Enter';
  LabelButton.Caption:='';

  // Change node font color when entering...
  Sender.Font.Color:=clBlue;
end;

procedure TNodeEventsForm.Node1MouseLeave(Sender: TTreeNodeShape;
  Shift: TShiftState; X, Y: Integer);
begin
  LabelName.Caption:=Sender.Name;
  LabelEvent.Caption:='On Mouse Leave';
  LabelButton.Caption:='';

  // Change node font color when leaving...
  Sender.Font.Color:=clBlack;
end;

procedure TNodeEventsForm.Node1MouseMove(Sender: TTreeNodeShape;
  Shift: TShiftState; X, Y: Integer);
begin
  LabelName.Caption:=Sender.Name;
  LabelEvent.Caption:='On Mouse Move';
  LabelButton.Caption:='';
end;

procedure TNodeEventsForm.FormCreate(Sender: TObject);

  Procedure SetNodeEvents(ANode:TTreeNodeShape);
  begin
    with ANode do
    begin
      OnClick:=Node1Click;
      OnDblClick:=Node1DblClick;
      OnMouseEnter:=Node1MouseEnter;
      OnMouseLeave:=Node1MouseLeave;
      OnMouseMove:=Node1MouseMove;
    end;
  end;

begin
  inherited;

  LabelButton.Caption:='';
  LabelName.Caption:='';
  LabelEvent.Caption:='';

  if Mouse.WheelPresent then
     LabelWheel.Caption:=''
  else
     LabelWheel.Caption:='(not present)';

  // Set all Node events

  SetNodeEvents(Node1);
  SetNodeEvents(Node2);
  SetNodeEvents(Node3);
  SetNodeEvents(Node4);
  SetNodeEvents(Node5);
  SetNodeEvents(Node6);
end;

procedure TNodeEventsForm.Tree1MouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  LabelWheel.Caption:='Wheel Down';
end;

procedure TNodeEventsForm.Tree1MouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  LabelWheel.Caption:='Wheel Up';
end;

procedure TNodeEventsForm.Tree1MouseWheel(Sender: TObject;
  Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint;
  var Handled: Boolean);
begin
  LabelWheel.Caption:='Wheel Move';
end;

procedure TNodeEventsForm.Tree1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  LabelButton.Caption:=ButtonName(Button);
end;

procedure TNodeEventsForm.FormShow(Sender: TObject);
begin
  inherited;
  Tree1.SetFocus;
end;

initialization
  RegisterClass(TNodeEventsForm);
end.
