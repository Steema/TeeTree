{**********************************************}
{   TeeTree library                            }
{   Component Registration Unit                }
{       TTree                                  }
{       TTreeEdit                              }
{       TImageLevels                           }
{       TTreePageNavigator                     }
{       TTreeMapNavigator                      }
{                                              }
{   Copyright (c) 1996-2025 by Steema Software }
{   All Rights Reserved                        }
{                                              }
{**********************************************}
{$I TeeDefs.inc}
unit TreeReg;

// See TreeDBReg.pas unit for TDBTree component.

interface

uses
  DesignIntf, DesignEditors,
  Classes;

type
  TTreeCompEditor=class(TComponentEditor)
  public
    procedure Edit; override;
    procedure ExecuteVerb( Index : Integer ); override;
    function GetVerbCount : Integer; override;
    function GetVerb( Index : Integer ) : string; override;
  end;

  TTreeProperty=class(TClassProperty)
  public
    function GetAttributes : TPropertyAttributes; override;
    function GetValue: string; override;
  end;

Procedure Register;

implementation

{$IFNDEF C5}
{$DEFINE TEESTRINGSPROPERTY}
{$ENDIF}

Uses
     Forms, Dialogs, Graphics,

     {$IFDEF TEESTRINGSPROPERTY}
     StrEdit,
     {$ENDIF}

     TeeTree, TeePrevi, TeeAbout,

     TreeConst, TreeEd, TreeShEd,
     TreeFlow, TreeElectric, TreeUML, TreeTransit,

     TeeConst,

     {$IF TeeMsg_TeeChartPalette='TeeChart'}
     {$DEFINE TEEPRO} // <-- TeeChart Lite or Pro ?
     {$ENDIF}

     {$IFDEF TEEPRO}
     TeeAnimate, TreeAnimate,
     TreeAnimateEditor,
     TeeTranslate,
     {$ENDIF}

     TreeNavigator,

     TeeBrushDlg, TeCanvas, SysUtils,
     TeeEdiGrad, TeeProcs, TeePenDlg,
     TreeMapNavigator;

type
  TTreeEditCompEditor=class(TComponentEditor)
  public
    procedure ExecuteVerb( Index : Integer ); override;
    function GetVerbCount : Integer; override;
    function GetVerb( Index : Integer ) : string; override;
  end;

  {$IFDEF TEEPRO}
  TTreeAnimateCompEditor=class(TComponentEditor)
  public
    procedure Edit; override;
    procedure ExecuteVerb( Index : Integer ); override;
    function GetVerbCount : Integer; override;
    function GetVerb( Index : Integer ) : string; override;
  end;
  {$ENDIF}

{ TTreeCompEditor }

procedure TTreeCompEditor.Edit;
begin
  EditTree(nil,TCustomTree(Component));
  Designer.Modified;
end;

procedure TTreeCompEditor.ExecuteVerb( Index : Integer );
var ATree : TCustomTree;
begin
  ATree:=TCustomTree(Component);
  Case Index of
    0,1,3: TeeShowTreeAbout('');
    4: Edit;
    5: begin
         LoadTreeFromFile(ATree);
         Designer.Modified;
       end;
    6: begin
         TreePreview(nil,ATree,PrintTeePanel);
         Designer.Modified;
       end;
    7: ShowTreeExport(nil,ATree);
    8: TreeLanguageHook;
  else
    inherited;
  end;
end;

function TTreeCompEditor.GetVerbCount : Integer;
begin
  Result := 8;
  Inc(Result);
end;

function TTreeCompEditor.GetVerb( Index : Integer ) : string;
begin
  result:='';
  Case Index of
    0: result:=TreeMsg_TeeTree;
    1: result:=TeeMsg_TreeCopyright;
    2: result:='-';  { <--- do not change or translate... }
    3: result:=TeeMsg_TreeAbout;
    4: result:=TeeMsg_TreeEdit;
    5: result:=TeeMsg_TreeLoad;
    6: result:=TeeMsg_TreePrintPreview;
    7: result:=TeeMsg_TreeExportChart;
    8: result:=TeeMsg_AskLanguage;
  end;
end;

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
  if TBrushDialog.Edit(nil,TTeeBrush(GetOrdValue)) then
     Designer.Modified;
end;

{ TTreeEditCompEditor }
procedure TTreeEditCompEditor.ExecuteVerb( Index : Integer );
begin
  if Index=0 then TTreeEdit(Component).Execute
             else inherited;
end;

function TTreeEditCompEditor.GetVerbCount : Integer;
begin
  Result := inherited GetVerbCount+1;
end;

function TTreeEditCompEditor.GetVerb( Index : Integer ) : string;
begin
  if Index=0 then result:=TeeMsg_Test
             else result:=inherited GetVerb(Index);
end;

{$IFDEF TEESTRINGSPROPERTY}
type
  TTreeStringsProperty=class(TStringListProperty)
  public
    function GetAttributes : TPropertyAttributes; override;
  end;

{ TTreeStrings }

function TTreeStringsProperty.GetAttributes: TPropertyAttributes;
begin
  Result:=inherited GetAttributes + [paSubProperties];
end;
{$ENDIF}

{$IFDEF TEEPRO}
{ TTreeAnimateCompEditor }

procedure TTreeAnimateCompEditor.Edit;
begin
  if TTreeAnimate(Component).Tree<>nil then
  begin
    TTreeAnimateEditor.ModalShow(nil,TTreeAnimate(Component));
    Designer.Modified;
  end
  else Raise Exception.Create(TreeMsg_TreeNil);
end;

procedure TTreeAnimateCompEditor.ExecuteVerb(Index: Integer);
begin
  if Index=0 then Edit else inherited;
end;

function TTreeAnimateCompEditor.GetVerb(Index: Integer): string;
begin
  if Index=0 then result:=TeeMsg_TreeEdit
             else result:='';
end;

function TTreeAnimateCompEditor.GetVerbCount: Integer;
begin
  result:=inherited GetVerbCount+1;
end;

type
  TAnimationsProperty=class(TClassProperty)
  public
    procedure Edit; override;
    function GetAttributes : TPropertyAttributes; override;
  end;

{ TAnimationsProperty }

procedure TAnimationsProperty.Edit;
var Animate : TTreeAnimate;
begin
  Animate:=TTreeAnimate(TAnimations(GetOrdValue).Animate);
  TTreeAnimateEditor.ModalShow(nil,Animate);
  Designer.Modified;
end;

function TAnimationsProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;
{$ENDIF}

Procedure Register;
begin
  TeeActivateGroup;

  RegisterNoIcon( [ TTreeNodeShape, TTreeConnection

                  {$IFDEF TEEPRO}, TTeeAnimation{$ENDIF} ]);

  RegisterComponents(TeeMsg_TeeTreePalette,[ TTree,
                                             TTreeEdit,
                                             TImageLevels,
                                             TTreePageNavigator,
                                             {$IFDEF TEEPRO}TTreeAnimate,{$ENDIF}
                                             TTreeEditorPanel,
                                             TTreeRuler,
                                             TTreeNavigator
                                           ]);

  RegisterComponentEditor(TCustomTree, TTreeCompEditor);
  RegisterComponentEditor(TTreeEdit, TTreeEditCompEditor);

  {$IFDEF TEEPRO}
  RegisterComponentEditor(TTreeAnimate, TTreeAnimateCompEditor);
  RegisterPropertyEditor(TypeInfo(TAnimations), TTreeAnimate, 'Animations',
                         TAnimationsProperty);
  {$ENDIF}

  RegisterPropertyEditor(TypeInfo(TTreeBrush), nil, '',TTreeBrushProperty);

  {$IFDEF TEESTRINGSPROPERTY}
  RegisterPropertyEditor(TypeInfo(TTreeStrings), nil, '',TTreeStringsProperty);
  {$ENDIF}

  TreeSetLanguage(False);

  RegisterNonActiveX( [TCustomTree] , axrIncludeDescendants );
end;

end.
