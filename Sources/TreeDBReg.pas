{********************************************}
{   TeeTree library                          }
{   Component Registration Unit              }
{                                            }
{       TDBTree                              }
{                                            }
{ Copyright (c) 1996-2025 by Steema Software }
{ All Rights Reserved                        }
{                                            }
{********************************************}
{$I TeeDefs.inc}
unit TreeDBReg;

interface

Procedure Register;

implementation

uses 
  DesignIntf, DesignEditors,

  Classes, SysUtils,

  {$IFDEF D10}
  WideStrings,
  {$ENDIF}

  TeCanvas, TreeReg, TreeConst, TeeDBTre, TreeDBEd, TreeShEd, TeeTree, TeePenDlg;

type
  TDBTreeCompEditor=class(TTreeCompEditor)
  protected
  public
    procedure Edit; override;
    procedure ExecuteVerb( Index : Integer ); override;
    function GetVerbCount : Integer; override;
    function GetVerb( Index : Integer ) : string; override;
  end;

{ TDBTreeCompEditor }
procedure TDBTreeCompEditor.ExecuteVerb( Index : Integer );
var tmp : Integer;
begin
  tmp:=GetVerbCount;
  if Index=4 then
  begin
    EditDBTree(nil,TCustomDBTree(Component));
    Designer.Modified;
  end
  else
  if Index=tmp-2 then TCustomDBTree(Component).Refresh
  else
  if Index=tmp-1 then
  begin
    ShowDBTreeEditor(nil,TCustomDBTree(Component));
    Designer.Modified;
  end
  else inherited;
end;

function TDBTreeCompEditor.GetVerbCount : Integer;
begin
  Result:=inherited GetVerbCount+2;
end;

function TDBTreeCompEditor.GetVerb( Index : Integer ) : string;
var tmp : Integer;
begin
  tmp:=GetVerbCount;
  if Index=tmp-2 then result:=TeeMsg_TreeDBRefresh
  else
  if Index=tmp-1 then result:=TeeMsg_TreeDBWizard
                 else result:=inherited GetVerb(Index);
end;

procedure TDBTreeCompEditor.Edit;
begin
  EditDBTree(nil,TCustomDBTree(Component));
  Designer.Modified;
end;

type
  TDBLayoutFormatProperty=class(TClassProperty)
  private
    procedure OnShowEditor(Sender:TObject);
  public
    function GetAttributes : TPropertyAttributes; override;
    function GetValue: string; override;
    procedure Edit; override;
  end;

  TDBLayoutFieldsProperty=class(TStringProperty)
  public
    function GetAttributes : TPropertyAttributes; override;
    procedure Edit; override;
  end;

{ TDBLayoutFormatProperty }

procedure TDBLayoutFormatProperty.OnShowEditor(Sender:TObject);
begin
  with TNodeTreeEditor(Sender) do
  begin
    TTeeVCL.ShowControls(False,[Label22,CBConnStyle,CheckBox8,Label20,ComboBox5]);
  end;
end;

procedure TDBLayoutFormatProperty.Edit;
begin
  TNodeTreeEditor.InternalEdit(nil, TTreeNodeShape(GetOrdValue),
                            stFormat,False,OnShowEditor);
  Designer.Modified;
end;

function TDBLayoutFormatProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

function TDBLayoutFormatProperty.GetValue: string;
begin
  FmtStr(Result, '(%s)', [GetPropType^.Name]);
end;

{ TDBLayoutFieldsProperty }

procedure TDBLayoutFieldsProperty.Edit;
var tmp   : {$IFDEF D15}
            TStrings;
            {$ELSE}
              {$IFDEF D10}
              TWideStrings;
              {$ELSE}
              TStrings;
              {$ENDIF}
            {$ENDIF}

    tmpSt : String;
begin
  with GetComponent(0) as TDBLayout do
  if Assigned(DataSet) then
  begin

    // In BDS 5.0 (RAD 2007, D11) up to RAD 8.0 (D15),
    // GetFieldNames must be called with TWideStrings param
    tmp:={$IFDEF D15}
         TStringList
         {$ELSE}
           {$IFDEF D10}
           TWideStringList
           {$ELSE}
           TStringList
           {$ENDIF}
         {$ENDIF}
         .Create;
    try
      DataSet.GetFieldNames(tmp);

      tmpSt:=ChooseFields(Fields,tmp,DataSet.Name);

      if Fields<>tmpSt then
      begin
        Fields:=tmpSt;
        Designer.Modified;
      end;
    finally
      tmp.Free;
    end;
  end;
end;

function TDBLayoutFieldsProperty.GetAttributes: TPropertyAttributes;
begin
  Result:=inherited GetAttributes + [paDialog];
end;

Procedure Register;
begin
  TeeActivateGroup;

  RegisterComponents(TeeMsg_TeeTreePalette,[ TDBTree ]);
  RegisterComponentEditor(TCustomDBTree, TDBTreeCompEditor);
  RegisterPropertyEditor(TypeInfo(String), TDBLayout, 'Fields',TDBLayoutFieldsProperty);
  RegisterPropertyEditor(TypeInfo(TTreeNodeShape), TDBLayout, '',TDBLayoutFormatProperty);
end;

end.
