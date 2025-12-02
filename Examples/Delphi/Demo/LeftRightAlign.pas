unit LeftRightAlign;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, StdCtrls, TeeTree, TreeEd, ExtCtrls, TeeProcs, TreeChildManagers,
  TeCanvas;

type
  TLeftRightAlignForm = class(TBaseForm)
    Panel2: TPanel;
    ScrollBar2: TScrollBar;
    ScrollBar1: TScrollBar;
    procedure FormCreate(Sender: TObject);
    procedure ScrollBar2Change(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
  private
    { Private declarations }
    procedure CosmeticProperties;
  public
    { Public declarations }
    SideAlign : TTreeSideAlignChild;
  end;

implementation

{$R *.DFM}

procedure TLeftRightAlignForm.FormCreate(Sender: TObject);
begin
  inherited;

  // Create and replace the default child manager:
  SideAlign:=TTreeLeftRightAlignChild.Create;
  Tree1.ChangeManager(SideAlign);

  // Set this to True to make new children copy formatting properties
  // from parent node.
  Tree1.AssignParent:=True;

  // Add sample nodes, with some nice formatting:

  with Tree1.AddRoot('Start') do
  begin
    Width:=30;
    Height:=30;
    X0:=15;
    Y0:=(Tree1.Height div 2)+15;

    Style:=tssRectangle;
    Color:=clLime;
    Border.Color:=clRed;
    Border.Width:=2;
    Border.EndStyle:=esFlat;
    ImageIndex:=tiNone;
    Font.Color:=clBlue;
    Font.Style:=[fsBold];
    Expanded:=True;

    with AddChild('a') do
    begin
      Color:=clAqua;
      AddChild('1').Style:=tssCircle;
      AddChild('2').Style:=tssDiamond;
      with AddChild('3') do
      begin
        Style:=tssTriangleBottom;
        with AddChild('abc') do
        begin
          Style:=tssRoundRectangle;
          Color:=clRed;
          Border.Color:=clYellow;
          Font.Color:=clWhite;
        end;
        AddChild('def').Style:=tssRectangle;
      end;
    end;

    AddChild('b');
    AddChild('c');
    AddChild('d');
    AddChild('e');
  end;

  CosmeticProperties;
end;

procedure TLeftRightAlignForm.CosmeticProperties;
begin
  Tree1.Color:=clSilver;

  Tree1.GlobalFormat.Connection.Border.Color:=clBlack;

  with Tree1.HotTrack do
  begin
    Active:=True;
    UseFont:=True;
    Font.Size:=12;
    Border.Width:=2;
    Border.EndStyle:=esFlat;
    UseBorder:=True;
  end;
end;

procedure TLeftRightAlignForm.ScrollBar2Change(Sender: TObject);
begin
  SideAlign.VertMargin:=ScrollBar2.Position;
  Tree1.Invalidate;
end;

procedure TLeftRightAlignForm.ScrollBar1Change(Sender: TObject);
begin
  SideAlign.HorizMargin:=ScrollBar1.Position;
  Tree1.Invalidate;
end;

initialization
  RegisterClass(TLeftRightAlignForm);
end.
