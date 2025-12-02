unit InspectorComponent;
{$I TeeDefs.inc}

interface

uses
  {$IFNDEF LINUX}
  Windows, Messages,
  {$ENDIF}
  SysUtils, Classes,
  Graphics, Controls, Forms, Dialogs, Grids, ExtCtrls, StdCtrls, ExtDlgs,

  Base, TeeTree, TeeInspector, TreeEd, TeeProcs, TreeShEd;

// Example on using TeeInspector component.

type
  TTeeInspectorForm = class(TBaseForm)
    TeeInspector1: TTeeInspector;
    Shape1: TTreeNodeShape;
    OpenPictureDialog1: TOpenPictureDialog;
    Splitter1: TSplitter;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure ChangeTransparent(Sender:TObject);
    procedure ChangeColor(Sender:TObject);
    procedure ChangeText(Sender:TObject);
    procedure ChangeStyle(Sender:TObject);
    procedure ChangeImage(Sender:TObject);
    procedure ChangeHeight(Sender:TObject);
    procedure ChangeWidth(Sender:TObject);
    procedure EditShape(Sender:TObject);
    procedure GetStyles(Sender:TInspectorItem; Proc:TGetItemProc);
  public
    { Public declarations }
  end;

implementation

{$IFNDEF LCL}
{$R *.DFM}
{$ELSE}
{$R *.lfm}
{$ENDIF}

procedure TTeeInspectorForm.FormCreate(Sender: TObject);
begin
  inherited;
  Tree1.Designing:=True;

  // The code below is optional. It can also be done at design-time
  // changing properties using Delphi Object Inspector.

  with TeeInspector1.Items do
  begin
    Clear;

    //  Type          Caption      Value               Notify Event
    Add(iiBoolean,  'Transparent', Shape1.Transparent, ChangeTransparent);
    Add(iiColor,    'Color',       Shape1.Color,       ChangeColor);
    Add(iiString,   'Text',        Shape1.SimpleText,  ChangeText);
    Add(iiImage,    'Image',       Shape1.Image,       ChangeImage);
    Add(iiInteger,  'Height',      Shape1.Height,      ChangeHeight);
    Add(iiInteger,  'Width',       Shape1.Width,       ChangeWidth);

    // The following items do not need an "OnChange" event. It is optional.
    // The appropiate dialog is displayed internally (pen dialog, font, etc).

    Add(iiPen,      'Border',      Shape1.Border);
    Add(iiBrush,    'Pattern',     Shape1.Brush);
    Add(iiGradient, 'Gradient',    Shape1.Gradient);
    Add(iiFont,     'Font',        Shape1.Font);
    Add(iiButton,   'Edit',        EditShape);

    // Special case for selection style:
    Add(iiSelection,'Style','Rectangle',ChangeStyle).OnGetItems:=GetStyles;
  end;
end;

procedure TTeeInspectorForm.ChangeColor(Sender: TObject);
begin
  Shape1.Color:=TInspectorItem(Sender).Value;

  // Repaint Inspector, maybe other items have changed:
  TeeInspector1.Invalidate;
end;

procedure TTeeInspectorForm.ChangeImage(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then
     Shape1.Image.LoadFromFile(OpenPictureDialog1.FileName);
end;

procedure TTeeInspectorForm.ChangeHeight(Sender:TObject);
begin
  Shape1.Height:=TInspectorItem(Sender).Value;
end;

procedure TTeeInspectorForm.ChangeWidth(Sender:TObject);
begin
  Shape1.Width:=TInspectorItem(Sender).Value;
end;

procedure TTeeInspectorForm.ChangeStyle(Sender: TObject);
begin
  with TInspectorItem(Sender) do
  if Value='Rectangle' then Shape1.Style:=tssRectangle else
  if Value='Ellipse'   then Shape1.Style:=tssCircle else
  if Value='Diamond'   then Shape1.Style:=tssDiamond;
end;

procedure TTeeInspectorForm.GetStyles(Sender:TInspectorItem; Proc:TGetItemProc);
begin
  // Calling Proc several times, one for each item in the selection combobox.

  // It is Optional to pass an object parameter to "Proc".
  // This object is then returned in the Data property of the inspector item
  // when the selection in the list is changed.

  Proc('Rectangle');
  Proc('Ellipse');
  Proc('Diamond');
end;

procedure TTeeInspectorForm.ChangeText(Sender: TObject);
begin
  Shape1.SimpleText:=TInspectorItem(Sender).Value;
end;

procedure TTeeInspectorForm.ChangeTransparent(Sender: TObject);
begin
  Shape1.Transparent:=TInspectorItem(Sender).Value;
end;

procedure TTeeInspectorForm.EditShape(Sender: TObject);
begin
  EditTreeShape(Self,Shape1);

  // Repaint Inspector, because the above line might modify items:
  TeeInspector1.Invalidate;
end;

initialization
  RegisterClass(TTeeInspectorForm);
end.
