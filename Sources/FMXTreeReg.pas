{*******************************************}
{  TeeTree library for Firemonkey           }
{  Component Registration Unit              }
{      TTree                                }
{      TTreeEdit                            }
{      TImageLevels                         }
{      TTreePageNavigator                   }
{                                           }
{  Copyright (c) 1996-2025 Steema Software  }
{  All Rights Reserved                      }
{                                           }
{*******************************************}
{$I TeeDefs.inc}
unit FMXTreeReg;

// For VCL only:
// See TreeDBReg.pas unit for TDBTree component.

interface

uses
  DesignIntf,
  DesignEditors,
  System.Classes;

type
  TTreeProperty=class(TClassProperty)
  public
    function GetAttributes : TPropertyAttributes; override;
    function GetValue: string; override;
  end;

Procedure Register;

implementation

uses
   FMX.Forms, FMX.Dialogs, FMX.Types,

   FMXTee.Tree,

   FMXTee.Editor.Brush,
   FMXTee.Canvas,

   System.SysUtils,

   FMXTee.Constants,
   FMXTee.Editor.Gradient, FMXTee.Procs, FMXTee.Editor.Stroke;

type
  TTreeBrushProperty=class(TTreeProperty)
  public
    procedure Edit; override;
  end;

{ TTreeProperty }

function TTreeProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paSubProperties,paDialog];
end;

function TTreeProperty.GetValue: string;
begin
  FmtStr(Result, '(%s)', [GetPropType^.Name]);
end;

{ TreeBrush Editor }

procedure TTreeBrushProperty.Edit;
begin
  if TBrushEditor.Edit(nil,TTeeBrush(GetOrdValue)) then
     Designer.Modified;
end;

Procedure Register;
begin
  TeeActivateGroup;

  RegisterNoIcon([TTreeNodeShape,TTreeConnection]);
  RegisterComponents('TeeTree',[TTree]);
  RegisterPropertyEditor(TypeInfo(TTreeBrush), nil, '',TTreeBrushProperty);
end;

end.
