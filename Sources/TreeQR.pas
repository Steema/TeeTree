{**********************************************}
{  TeeTree --> QuickReports                    }
{  Copyright (c) 1996-2025 by Steema Software  }
{  All Rights Reserved                         }
{**********************************************}
{$I TeeDefs.inc}
unit TreeQR;

interface

uses
  {$IFNDEF LINUX}
  Windows, Messages,
  {$ENDIF}
  SysUtils, Classes,
  Graphics, Controls, Forms, Dialogs, StdCtrls, Menus, ExtCtrls,

  TeeProcs, TeeTree, QuickRpt, TeCanvas, TeeDBTre;

type
  TTeeQuickMethod=(qtmBitmap,qtmMetafile);

  TQuickReportTree=class(TCustomDBTree)
  public
    constructor Create(AOwner : TComponent); override;
    Function GetRectangle:TRect; override;
    procedure Invalidate; override;
    procedure Paint; override;
  published
    property AllowPanning;
    property AllowZoom;
    property AnimatedZoom;
    property AnimatedZoomSteps;
    property BackImage;
    property BackImageMode;
    property BufferedDisplay;
    property CrossBox;
    property Designing;
    property Gradient;
    property GridColor;
    property GridStep;
    property PrintProportional;
    property Selected;
    property SnapToGrid;
    property View3DOptions;
    property HorzScrollBar;
    property VertScrollBar;

    property OnAfterDraw;
    property OnBeforeDraw;
    property OnNewConnection;
    property OnNewShape;
    property OnSelectShape;
    property OnUnSelectShape;

    { TCustomDBTree }
    property CodeField;
    property DataSet;
    property Detail;
    property DetailFields;
    property MultiLineText;
    property ParentField;
    property TextFields;

    { TPanel properties }
    property Align;
    property BevelInner;
    property BevelOuter default bvNone;
    property BevelWidth;
    property BorderWidth;
    property BorderStyle default bsSingle;
    property Color default clWhite;
    property DragCursor;
    property DragMode;
    property Enabled;
    property ParentColor;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint default True;
    property TabOrder;
    property TabStop;
    property Visible;

    { TPanel events }
    property OnResize;
  end;

  TQRTree=class;

  TPrintQRTreeEvent = procedure( Sender: TQRTree;
                                 var PaperRect,TreeRect:TRect ) of object;

  TQRTree = class(TQRPrintable)
  private
    { Private declarations }
    FOnPrint        : TPrintQRTreeEvent;
    FTeePrintMethod : TTeeQuickMethod;

    procedure CreateTree;
    Function GetTree:TQuickReportTree;
    Procedure SetPrintMethod(Value:TTeeQuickMethod);
  protected
    { Protected declarations }
    procedure ReadState(Reader: TReader); override;
  public
    { Public declarations }
    Constructor Create(AOwner : TComponent); override;

    procedure Print(OfsX, OfsY : integer); override;
    procedure Paint; override;
  published
    { Published declarations }
    property Tree : TQuickReportTree read GetTree;
    property TeePrintMethod:TTeeQuickMethod read FTeePrintMethod
                                            write SetPrintMethod default qtmMetafile;
    { Published QR events }
    property OnPrint:TPrintQRTreeEvent read FOnPrint write FOnPrint;
  end;

implementation

Uses
  TeeConst;

Const TeeMsg_DefaultQRTree='QuickReportTree'; { <-- dont translate }

{ TQuickReportTree }

Constructor TQuickReportTree.Create(AOwner : TComponent);
begin
  inherited;

  Color:=clWhite;
  BevelOuter:=bvNone;
  BorderStyle:=bsNone;
  BufferedDisplay:=False;
  SetBounds(-1,-1,1,1);
  Hide;
end;

Function TQuickReportTree.GetRectangle:TRect;

  Function InternalGetRectangle(const AControl:TControl; Const AZoom:Double):TRect;
  begin
    result:=TeeRect(0,0, Round(AControl.ClientWidth*AZoom),
                         Round(AControl.ClientHeight*AZoom) );
  end;

Var tmpZoomFactor : Double;
begin
  if Assigned(Parent) then
  begin
    if Parent is TQRTree then
    With TQRTree(Parent) do
    begin
      if Assigned(ParentReport) then tmpZoomFactor:=100.0/ParentReport.Zoom
                                else tmpZoomFactor:=1;
      result:=InternalGetRectangle(Self.Parent,tmpZoomFactor);
    end
    else result:=InternalGetRectangle(Parent,1);
  end
  else result:=InternalGetRectangle(Self,1);
end;

procedure TQuickReportTree.Paint;
var Meta   : TMetaFile;
    Bitmap : TBitmap;
begin
  if Assigned(Parent) and (Parent is TQRTree) then
  With TQRTree(Parent) do
  Case FTeePrintMethod of
  qtmMetafile: begin
                 Meta:=TeeCreateMetafile(True,GetRectangle);
                 try
                   Canvas.StretchDraw(GetClientRect,Meta);
                 finally
                   Meta.Free;
                 end;
               end;
  qtmBitmap:   begin
                 Bitmap:=TeeCreateBitmap(clWhite,GetRectangle);
                 try
                   Canvas.StretchDraw(GetClientRect,Bitmap);
                 finally
                   Bitmap.Free;
                 end;
               end;
  end
  else inherited Paint;
end;

procedure TQuickReportTree.Invalidate;
begin
  if Assigned(Parent) then
     if Parent is TQRTree then
     begin
       if AutoRepaint then
       begin
         // Prevent re-entrancy when a XP Theme is enabled.
         // ( Parent TWinControl.CMInvalidate calls back again here )
         AutoRepaint:=False;
         try
           Parent.Invalidate;
         finally
           AutoRepaint:=True;
         end;
       end;
     end
     else inherited Invalidate;
end;

{ TQRTree }

Constructor TQRTree.Create(AOwner : TComponent);
begin
  inherited;

  FTeePrintMethod:=qtmMetafile;
  Width :=350;
  Height:=200;

  if csDesigning in ComponentState then
     CreateTree;
end;

procedure TQRTree.CreateTree;
begin
  if not (csLoading in Owner.ComponentState) then
  With TQuickReportTree.Create(Owner) do
  begin
    Parent:=TWinControl(Self);
    Name:=TeeGetUniqueName(Owner,TeeMsg_DefaultQRTree);
  end;
end;

procedure TQRTree.ReadState(Reader: TReader);
var tmpTree : TQuickReportTree;
begin
  tmpTree:=Tree;

  if Assigned(tmpTree) and
     (not (csLoading in tmpTree.ComponentState))
     and (not (csAncestor in tmpTree.ComponentState))
        then
          tmpTree.Free;

  inherited ReadState(Reader);
end;

Procedure TQRTree.SetPrintMethod(Value:TTeeQuickMethod);
begin
  if Value<>FTeePrintMethod then
  begin
    FTeePrintMethod:=Value;
    Repaint;
  end;
end;

procedure TQRTree.Print(OfsX, OfsY : Integer);
Var tmpMeta   : TMetafile;
    QuickRect : TRect;
    tmpRect   : TRect;
    tmpTree   : TQuickReportTree;
    tmpBitmap : TBitmap;
begin
  tmpTree:=Tree;

  if Assigned(tmpTree) then
  begin
    With ParentReport.QRPrinter do
    begin
      QuickRect:=TeeRect( Xpos(OfsX+Size.Left),
                          Ypos(OfsY+Size.Top),
                          Xpos(OfsX+Size.Left+Size.Width),
                          Ypos(OfsY+Size.Top+Size.Height));

      tmpRect:=tmpTree.GetRectangle;

      if Assigned( FOnPrint ) then FOnPrint( Self, QuickRect, tmpRect );

      Case FTeePrintMethod of
      qtmMetafile: begin
                     tmpMeta:=tmpTree.TeeCreateMetafile(True, tmpRect);
                     try
                       Canvas.StretchDraw(QuickRect,tmpMeta);
                     finally
                       tmpMeta.Free;
                     end;
                   end;
        qtmBitmap: begin
                     tmpBitmap:=tmpTree.TeeCreateBitmap(clWhite, tmpRect);
                     try
                       Canvas.StretchDraw(QuickRect,tmpBitmap);
                     finally
                       tmpBitmap.Free;
                     end;
                   end;
      end;
    end;
  end;

  inherited Print(OfsX,OfsY);
end;

procedure TQRTree.Paint;
begin
  if Assigned(Tree) then
  begin
    Tree.AutoRepaint:=False;
    try
       Tree.Paint;
    finally
      Tree.AutoRepaint:=True;
    end;
  end;

  if Assigned(ParentReport) then
     inherited Paint;
end;

Function TQRTree.GetTree:TQuickReportTree;
begin
  if ControlCount=0 then
     CreateTree;

  result:=TQuickReportTree(Controls[0]);
end;

initialization
  TeeActivateGroup;

  {$IFDEF FMX}
    GroupDescendentsWith(TCustomTreeElement,TFMXObject);
  {$ELSE}
    GroupDescendentsWith(TCustomTreeElement,TControl);
  {$ENDIF}

  RegisterClass( TQuickReportTree );
finalization
  TeeActivateGroup;
  UnRegisterClass( TQuickReportTree );
end.
