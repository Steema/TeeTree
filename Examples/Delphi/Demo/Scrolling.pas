unit Scrolling;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Base, StdCtrls, TeeTree, TreeEd, ExtCtrls, TeeProcs;

type
  TScrollingForm = class(TBaseForm)
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    Label1: TLabel;
    ComboBox2: TComboBox;
    TreeNodeShape1: TTreeNodeShape;
    TreeNodeShape2: TTreeNodeShape;
    TreeNodeShape3: TTreeNodeShape;
    TreeNodeShape4: TTreeNodeShape;
    TreeNodeShape5: TTreeNodeShape;
    procedure Tree1Scroll(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TScrollingForm.Tree1Scroll(Sender: TObject);
begin
  // Event called when Tree is scrolled:

  with TreeNodeShape1.Text do  // show scrolling values in text
  begin
    Clear;
    Add('Scroll amount:');
    Add('Horizontal: '+IntToStr(Tree1.View3DOptions.HorizOffset));
    Add('Vertical: '+IntToStr(Tree1.View3DOptions.VertOffset));
  end;
end;

procedure TScrollingForm.FormCreate(Sender: TObject);
begin
  inherited;
  // Disable zoom:
  Tree1.Zoom.Allow:=False;

  ComboBox1.ItemIndex:=2;
  ComboBox2.ItemIndex:=2;
end;

procedure TScrollingForm.ComboBox1Change(Sender: TObject);
begin
  // Change scrolling direction
  Case ComboBox1.ItemIndex of
    0: Tree1.AllowPanning:=pmHorizontal;
    1: Tree1.AllowPanning:=pmVertical;
    2: Tree1.AllowPanning:=pmBoth;
  end;

  CheckBox1.Checked:=True;
end;

procedure TScrollingForm.CheckBox1Click(Sender: TObject);
begin
  ComboBox1.Enabled:=CheckBox1.Checked;

  // Enable or disable scrolling

  if CheckBox1.Checked then
  begin
    Case ComboBox1.ItemIndex of
      0: Tree1.AllowPanning:=pmHorizontal;
      1: Tree1.AllowPanning:=pmVertical;
      2: Tree1.AllowPanning:=pmBoth;
    end;
  end
  else Tree1.AllowPanning:=pmNone;  // disable scroll
end;

procedure TScrollingForm.ComboBox2Change(Sender: TObject);
begin
  // Change scrolling mouse button
  Case ComboBox2.ItemIndex of
    0: Tree1.ScrollMouseButton:=mbLeft;
    1: Tree1.ScrollMouseButton:=mbMiddle;
    2: Tree1.ScrollMouseButton:=mbRight;
  end;
end;

initialization
  RegisterClass(TScrollingForm);
end.
