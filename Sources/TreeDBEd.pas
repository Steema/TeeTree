{**********************************************}
{   TTree Component  - DBTree Editor dialog    }
{   Copyright (c) 1998-2025 by Steema Software }
{**********************************************}
{$I TeeDefs.inc}
unit TreeDBEd;

interface

uses
  {$IFNDEF LINUX}
  Windows, Messages, 
  {$ENDIF}
  SysUtils, Classes,
  Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls, Menus,

  {$IFDEF D10}
  {$IFNDEF D15}
  WideStrings,
  {$ENDIF}
  {$ENDIF}
  
  TeeTree, TeeProcs, TeeDBTre, DB, TeCanvas, TeePenDlg;

type
  TFormDBTree = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Panel2: TPanel;
    Label1: TLabel;
    RadioButton1: TRadioButton;
    Memo2: TMemo;
    RadioButton2: TRadioButton;
    Memo4: TMemo;
    RadioButton3: TRadioButton;
    Memo6: TMemo;
    Panel3: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    CBDataSet: TComboFlat;
    ComboBox2: TComboFlat;
    ComboBox3: TComboFlat;
    ComboBox4: TComboFlat;
    Label6: TLabel;
    ComboBox5: TComboFlat;
    Label7: TLabel;
    ComboBox6: TComboFlat;
    Button4: TButton;
    Button5: TButton;
    BApply: TButton;
    Button7: TButton;
    CheckBox1: TCheckBox;
    Panel4: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    Memo1: TMemo;
    Memo3: TMemo;
    Memo5: TMemo;
    TreePreview: TTree;
    TreeShape1: TTreeNodeShape;
    TreeShape2: TTreeNodeShape;
    TreeShape3: TTreeNodeShape;
    TreeShape4: TTreeNodeShape;
    TreeShape1_TreeShape2: TTreeConnection;
    TreeShape1_TreeShape3: TTreeConnection;
    TreeShape1_TreeShape4: TTreeConnection;
    BNewDataSet: TButton;
    Button6: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Memo2Click(Sender: TObject);
    procedure Memo4Click(Sender: TObject);
    procedure Memo6Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CBDataSetChange(Sender: TObject);
    procedure ComboBox5Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure ComboBox6Change(Sender: TObject);
    procedure BApplyClick(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    ADataSet       : TDataSet;
    ACodeField     : String;
    AParentField   : String;
    ATextFields    : String;
    ADetail        : TDataSet;
    ADetailFields  : String;
    AFormatMaster  : TTreeNodeShape;
    AHeaderMaster  : TTreeNodeShape;
    AFormatDetail  : TTreeNodeShape;
    AHeaderDetail  : TTreeNodeShape;
    Procedure Changed;
    procedure EditShape(AShape:TTreeNodeShape);
    Procedure FillDataSets(AItems:TStrings; MastersOnly:Boolean; AMaster:TDataSet);
    Procedure FillFields(tmpDataSet:TDataSet; AItems:TStrings; OnlyNumeric:Boolean);
    procedure OnShowEditor(Sender:TObject);
  public
    { Public declarations }
    Tree1 : TCustomDBTree;
    Procedure FillControls;
    procedure FillTree;
  end;

Const
   TreeMsg_FieldSeparator = ';';

Procedure EditDBTree(Owner:TComponent; ATree:TCustomDBTree);
Procedure ShowDBTreeEditor(Owner:TComponent; ADBTree:TCustomDBTree);


Function ChooseFields( Const AText:String; AItems:TStrings;
                       Const ACaption:String):String; overload;

{$IFDEF D10}
{$IFNDEF D15}
Function ChooseFields( Const AText:String; AItems:TWideStrings;
                       Const ACaption:String):String; overload;
{$ENDIF}
{$ENDIF}

implementation

{$IFNDEF LCL}
{$R *.DFM}
{$ELSE}
{$R *.lfm}
{$ENDIF}

uses
  {$IFDEF D17}
  System.Generics.Collections,
  {$ENDIF}
  TreeConst, TreeShEd, TreeEd, TeeSelectList, TeeTranslate;

Procedure ShowDBTreeEditor(Owner:TComponent; ADBTree:TCustomDBTree);
begin
  With TFormDBTree.Create(Owner) do
  try
    Tree1:=ADBTree;
    ShowModal;
  finally
    Free;
  end;
end;

type TDBTreeMenuItem=class(TMenuItem)
     private
       Procedure ClickedDBItem(Sender:TObject);
     end;

Procedure TDBTreeMenuItem.ClickedDBItem(Sender:TObject);
Var AOwner:TComponent;
begin
  AOwner:=TComponent(Sender).Owner;
  ShowDBTreeEditor(AOwner,TCustomDBTree(TTreeEditor(AOwner).TheTree));
end;

Procedure DBTreeNotifyEdit(Sender:TTreeEditor);
var m:TDBTreeMenuItem;
begin
  With Sender do
  begin
    m:=TDBTreeMenuItem.Create(Sender);
    m.Caption:=TeeMsg_TreeDBWizard;
    m.OnClick:=m.ClickedDBItem;
    Tools1.Add(m);
  end;
end;

Procedure EditDBTree(Owner:TComponent; ATree:TCustomDBTree);
begin
  EditTreeEvent(Owner,ATree as TCustomTree,DBTreeNotifyEdit);
end;

procedure TFormDBTree.RadioButton1Click(Sender: TObject);
begin
  Memo1.Visible:=True;
  Memo3.Visible:=False;
  Memo5.Visible:=False;
  ADetail:=nil;
  ADetailFields:='';
  FillTree;
  if Panel3.Visible then FillControls;
end;

procedure TFormDBTree.RadioButton2Click(Sender: TObject);
begin
  ACodeField:='';
  ADetail:=nil;
  ADetailFields:='';
  ComboBox2.Text:='';
  ComboBox2.ItemIndex:=-1;
  Memo1.Visible:=False;
  Memo3.Visible:=True;
  Memo5.Visible:=False;
  FillTree;
  if Panel3.Visible then FillControls;
end;

procedure TFormDBTree.FillTree;
begin
  With TreePreview do
  if RadioButton1.Checked then
  begin
    Clear;
    With AddRoot('Continents') do
    begin
      With AddChild('Africa') do
           AddChild('SouthAfrica');
      With AddChild('America') do
      begin
        With AddChild('USA') do
             AddChild('California');
      end;
      With AddChild('Australia') do
           AddChild('Sydney');
    end;
  end
  else
  if RadioButton2.Checked then
  begin
    Clear;
    With AddRoot('Country') do
    begin
      With AddChild('Australia') do
      begin
        AddChild('Camberra');
        AddChild('Sydney');
      end;
      With AddChild('UK') do
      begin
        AddChild('Manchester');
        AddChild('Liverpool');
        AddChild('London');
      end;
      With AddChild('USA') do
      begin
        AddChild('Chicago');
        AddChild('Michigan');
        AddChild('New York');
      end;
    end;
  end
  else
  if RadioButton3.Checked then
  begin
    Clear;
    With AddRoot('Department') do
    begin
      With AddChild('Accounting') do
           With AddChild('John') do
                AddChild('April $1000');
      With AddChild('Management') do
           With AddChild('Chris') do
           begin
             AddChild('March $900');
             AddChild('April $700');
           end;
      With AddChild('Sales') do
           With AddChild('Anne') do
                AddChild('June $500');
    end;
  end;
  TreePreview.FullExpandCollapse(True);
end;

procedure TFormDBTree.Button3Click(Sender: TObject);
begin
  if (not BApply.Enabled) or TeeYesNo(TreeMsg_SureToCancel) then
     ModalResult:=mrCancel;
end;

procedure TFormDBTree.FormShow(Sender: TObject);
begin
  if Assigned(Tree1) then
  With Tree1 do
  begin
    ADataSet      :=DataSet;
    ACodeField    :=CodeField;
    AParentField  :=ParentField;
    ATextFields   :=TextFields;
    ADetail       :=Detail;
    ADetailFields :=DetailFields;

    AFormatMaster :=TTreeNodeShape.Create(nil);
    AFormatDetail :=TTreeNodeShape.Create(nil);
    AHeaderMaster :=TTreeNodeShape.Create(nil);
    AHeaderDetail :=TTreeNodeShape.Create(nil);

    if Layout.Count>0 then
    begin
      AFormatMaster.Assign(Layout[0].Format);
      AHeaderMaster.Assign(Layout[0].HeaderFormat);

      if Layout.Count>1 then
      begin
        AFormatDetail.Assign(Layout[1].Format);
        AHeaderDetail.Assign(Layout[1].HeaderFormat);
      end;
    end;

    CheckBox1.Checked:=MultiLineText;
  end;

  if ACodeField<>'' then
     RadioButton1.Checked:=True
  else
  if Assigned(ADetail) then
     RadioButton3.Checked:=True
  else
     RadioButton2.Checked:=True;

  if Assigned(ADataSet) then Button1Click(Self)
                        else FillTree;

  BApply.Enabled:=False;
end;

procedure TFormDBTree.RadioButton3Click(Sender: TObject);
begin
  Memo1.Visible:=False;
  Memo3.Visible:=False;
  Memo5.Visible:=True;
  FillTree;
  if Panel3.Visible then FillControls;
end;

procedure TFormDBTree.FormCreate(Sender: TObject);
begin
  TeeTranslateControl(Self);

  BApply.Enabled:=False;
  Button2.Enabled:=False;
  Panel3.Visible:=False;
  Panel4.Visible:=True;
  Panel3.SendToBack;
  Panel4.BringToFront;
  Panel4.Align:=alClient;

  with TreePreview.GlobalFormat do
  begin
    Border.Visible:=False;
    Transparent:=True;
  end;
end;

procedure TFormDBTree.Memo2Click(Sender: TObject);
begin
  RadioButton1.Checked:=True;
  RadioButton1Click(Sender);
end;

procedure TFormDBTree.Memo4Click(Sender: TObject);
begin
  RadioButton2.Checked:=True;
  RadioButton2Click(Sender);
end;

procedure TFormDBTree.Memo6Click(Sender: TObject);
begin
  RadioButton3.Checked:=True;
  RadioButton3Click(Sender);
end;

Procedure TFormDBTree.FillControls;

  Procedure SetComboIndex(ACombo:TComboBox; Const AText:String);
  var tmp:Integer;
  begin
    ACombo.ItemIndex:=-1;

    if AText='' then ACombo.Text:=''
    else
    begin
      tmp:=ACombo.Items.IndexOf(AText);

      if tmp<>-1 then ACombo.ItemIndex:=tmp
                 else ACombo.Text:=AText;
    end;
  end;

begin
  TreePreview.Visible:=False;
  Panel4.Visible:=False;
  Panel4.SendToBack;
  Panel3.Visible:=True;
  Panel3.BringToFront;
  Panel3.Align:=alClient;
  Button1.Caption:=TreeMsg_Finish;
  Button2.Enabled:=True;

  Label3.Visible:=RadioButton1.Checked;
  ComboBox2.Visible:=Label3.Visible;

  if RadioButton1.Checked then Label4.Caption:=TreeMsg_ParentField
                          else Label4.Caption:=TreeMsg_GroupField;
  if RadioButton3.Checked then Label5.Caption:=TreeMsg_MasterFields
                          else Label5.Caption:=TreeMsg_TextFields;
  if RadioButton3.Checked then Label2.Caption:=TreeMsg_MasterDataSet
                          else Label2.Caption:=TreeMsg_DataSet;

  TTeeVCL.ShowControls(RadioButton3.Checked,
     [Label6,Label7,ComboBox5,ComboBox6,Button5,Button9,Button10]);

  FillDataSets(CBDataSet.Items,RadioButton3.Checked,nil);

  if Assigned(ADataSet) then
  begin
    CBDataSet.ItemIndex:=CBDataSet.Items.IndexOfObject(ADataSet);
    CBDataSetChange(Self);
    if ACodeField<>'' then
       ComboBox2.ItemIndex:=ComboBox2.Items.IndexOf(ACodeField);
    SetComboIndex(ComboBox3,AParentField);
    SetComboIndex(ComboBox4,ATextFields);
  end;

  if Assigned(ADetail) then
  begin
    ComboBox5.ItemIndex:=ComboBox5.Items.IndexOfObject(ADetail);
    ComboBox5Change(Self);
    SetComboIndex(ComboBox6,ADetailFields);
  end;
end;

procedure TFormDBTree.Button1Click(Sender: TObject);
begin
  if Panel3.Visible then
  begin
    if BApply.Enabled then BApplyClick(Self);
    ModalResult:=mrOk;
  end
  else FillControls;
end;

procedure TFormDBTree.Button2Click(Sender: TObject);
begin
  TreePreview.Visible:=True;
  Panel3.Visible:=False;
  Panel3.SendToBack;
  Panel4.Visible:=True;
  Panel4.BringToFront;
  Panel4.Align:=alClient;
  Button1.Caption:=TreeMsg_Next;
  Button2.Enabled:=False;
end;

Procedure TFormDBTree.FillFields(tmpDataSet:TDataSet; AItems:TStrings; OnlyNumeric:Boolean);

  Function IsNumber(AField:TFieldType):Boolean;
  begin
    Case AField of
      ftSmallint,
      ftInteger,
      ftWord,
      ftFloat,
      ftCurrency,
      ftBCD,
      ftAutoInc: result:=True;
    else result:=False;
    end;
  end;

Var t : Integer;
Begin
  AItems.Clear;
  With tmpDataSet do
  begin
    if FieldCount>0 then
       for t:=0 to FieldCount-1 do
       begin
         if (not OnlyNumeric) or IsNumber(Fields[t].DataType) then
            AItems.AddObject(Fields[t].FieldName,Fields[t])
       end
    else
    begin
      FieldDefs.Update;

      for t:=0 to FieldDefs.Count-1 do
         if (not OnlyNumeric) or IsNumber(FieldDefs[t].DataType) then
             AItems.AddObject(FieldDefs[t].Name,FieldDefs[t]);
    end;
  end;
end;

procedure TFormDBTree.CBDataSetChange(Sender: TObject);
begin
  if (CBDataSet.Text<>'') and (CBDataSet.ItemIndex>=0) then
  begin
    ADataSet:=TDataSet(CBDataSet.SelectedObject);

    FillFields(ADataSet,ComboBox2.Items,True);
    FillFields(ADataSet,ComboBox3.Items,RadioButton1.Checked);
    FillFields(ADataSet,ComboBox4.Items,False);

    if ComboBox5.Visible then
       FillDataSets(ComboBox5.Items,False,ADataSet);
  end
  else
    ADataSet:=nil;

  Changed;
end;

Procedure TFormDBTree.FillDataSets(AItems:TStrings; MastersOnly:Boolean; AMaster:TDataSet);
var tmpList : {$IFDEF D17}System.Generics.Collections.TList<TDataSet>{$ELSE}TList{$ENDIF};

  Procedure FillSourcesForm(AOwner:TComponent; AItems:TStrings);

    Function IsDetailDataSet(SomeDataSet:TDataSet):Boolean;
    begin
      result:=Assigned(tmpList) and (tmpList.IndexOf(SomeDataSet)<>-1);
    end;

  var t   : Longint;
      tmp,
      tmpFormName:String;
  begin
    With AOwner do
    for t:=0 to ComponentCount-1 do
    if Components[t] is TDataSet then
    if (not Assigned(AMaster)) or IsDetailDataSet(TDataSet(Components[t])) then
    With Components[t] do
    begin
       tmp:=Name;

       if (Tree1.Owner<>Owner) and Assigned(Owner) then
       begin
         tmpFormName:=Owner.Name;

         if tmpFormName<>'' then tmp:=tmpFormName+'.'+tmp;
       end;

       AItems.AddObject(tmp,AOwner.Components[t]);
    end;
  end;

var t : Integer;
begin
  AItems.Clear;

  if Assigned(AMaster) then
  begin
    tmpList:={$IFDEF D17}System.Generics.Collections.TList<TDataSet>{$ELSE}TList{$ENDIF}.Create;
    AMaster.GetDetailDataSets(tmpList);
  end
  else
    tmpList:=nil;

  With Screen do
      for t:=0 to DataModuleCount-1 do
          FillSourcesForm(DataModules[t], AItems);

  if Assigned(Tree1.Owner) then
     FillSourcesForm(Tree1.Owner, AItems);

  tmpList.Free;
end;

procedure TFormDBTree.ComboBox5Change(Sender: TObject);
begin
  if (ComboBox5.Text<>'')  and (ComboBox5.ItemIndex>=0) then
  begin
    ADetail:=TDataSet(ComboBox5.SelectedObject);
    FillFields(ADetail,ComboBox6.Items,False);
  end
  else
    ADetail:=nil;

  Changed;
end;

procedure TFormDBTree.ComboBox2Change(Sender: TObject);
begin
  if (ComboBox2.Text<>'')  and (ComboBox2.ItemIndex>=0) then
     ACodeField:=ComboBox2.CurrentItem
  else
     ACodeField:='';

  Changed;
end;

procedure TFormDBTree.ComboBox3Change(Sender: TObject);
begin
  AParentField:=ComboBox3.Text;
  Changed;
end;

procedure TFormDBTree.ComboBox4Change(Sender: TObject);
begin
  ATextFields:=ComboBox4.Text;
  Changed;
end;

procedure TFormDBTree.ComboBox6Change(Sender: TObject);
begin
  ADetailFields:=ComboBox6.Text;
  Changed;
end;

procedure TFormDBTree.BApplyClick(Sender: TObject);

  Procedure RaiseExceptionField(AControl:TWinControl; Const AMessage:String);
  begin
    AControl.SetFocus;
    Raise Exception.Create(AMessage);
  end;

var tmp:TTreeNodeShape;
begin
  if Assigned(ADataSet) then
  begin
     if RadioButton1.Checked then
     begin
        if ACodeField='' then RaiseExceptionField(ComboBox2,TreeMsg_DBCodeNeeded);
        if AParentField='' then RaiseExceptionField(ComboBox3,TreeMsg_DBCodeNeeded);
        if ATextFields='' then RaiseExceptionField(ComboBox4,TreeMsg_DBCodeNeeded);
     end;
     if RadioButton2.Checked then
        if ATextFields='' then
           RaiseExceptionField(ComboBox4,TreeMsg_DBTextNeeded);
     if RadioButton3.Checked then
     begin
        if ATextFields='' then RaiseExceptionField(ComboBox4,TreeMsg_MasterNeed);
        if (not Assigned(ADetail)) or (ADetailFields='') then
           RaiseExceptionField(ComboBox6,TreeMsg_DetailNeed);
     end;
  end;
  With Tree1 do
  begin
    DataSet      :=ADataSet;
    CodeField    :=ACodeField;
    ParentField  :=AParentField;
    TextFields   :=ATextFields;
    Detail       :=ADetail;
    DetailFields :=ADetailFields;
    MultiLineText:=CheckBox1.Checked;

    if Layout.Count>0 then
    begin
      Layout[0].Format.Assign(AFormatMaster);
      Layout[0].HeaderFormat.Assign(AHeaderMaster);

      if Layout.Count>2 then
      begin
        Layout[1].Format.Assign(AFormatDetail);
        Layout[1].HeaderFormat.Assign(AHeaderDetail);
      end;
    end;

    Screen.Cursor:=crHourGlass;
    try
      Refresh;
    finally
      Screen.Cursor:=crDefault;
    end;

    { Expand first Root... }
    if Roots.Count>0 then
    begin
      tmp:=Roots[0];
      Repeat
        tmp.Expanded:=True;
        if tmp.Childs.Count>0 then
           tmp:=tmp.Childs[0]
        else
           tmp:=nil;
      Until not Assigned(tmp);
    end;         
  end;
  BApply.Enabled:=False;
end;

Procedure TFormDBTree.Changed;
begin
  BApply.Enabled:=True;
end;

{$IFDEF D10}
{$IFNDEF D15}
Function ChooseFields( Const AText:String; AItems:TWideStrings;
                       Const ACaption:String):String; overload;
var tmp : TStrings;
begin
  tmp:=TStringList.Create;
  try
    tmp.Assign(AItems);
    result:=ChooseFields(AText,tmp,ACaption);
  finally
    tmp.Free;
  end;
end;
{$ENDIF}
{$ENDIF}

Function ChooseFields( Const AText:String; AItems:TStrings;
                       Const ACaption:String):String;

  Function SeparateItems(SomeItems:TStrings):String;
  var t : Integer;
  begin
    result:='';
    if SomeItems.Count>0 then
    begin
      result:=SomeItems[0];
      for t:=1 to SomeItems.Count-1 do
          result:=result+TreeMsg_FieldSeparator+SomeItems[t];
    end;
  end;

var t,
    tmpIndex : Integer;
    tmpSt    : String;
    s        : TSelectListForm;
    tmp      : TPanel;
    b        : TButton;
    c        : TButton;
begin
  result:=AText;
  s:=TSelectListForm.Create(nil);
  with s do
  try
    Caption:=ACaption;
    Align:=alNone;
    BorderStyle:=TeeBorderStyle;
    Position:=poScreenCenter;
    Height:=300;
    Width:=400;

    FromList.Items.Assign(AItems);
    if AText<>'' then
    begin
      for t:=1 to TeeNumFields(AText) do
      begin
        tmpSt:=TeeExtractField(AText,t);
        tmpIndex:=FromList.Items.IndexOf(tmpSt);
        if tmpIndex<>-1 then
        begin
          ToList.Items.Add(tmpSt);
          FromList.Items.Delete(tmpIndex);
        end;
      end;
    end;

    tmp:=TPanel.Create(s);
    with tmp do
    begin
      Align:=alBottom;
      Caption:='';
      Parent:=s;
    end;
    b:=TButton.Create(s);
    with b do
    begin
      Left:=s.Width-186;
      Top:=6;
      Caption:='OK';
      Parent:=tmp;
      ModalResult:=mrOk;
      Default:=True;
    end;

    c:=TButton.Create(s);
    with c do
    begin
      Left:=s.Width-90;
      Top:=6;
      Caption:='Cancel';
      Parent:=tmp;
      ModalResult:=mrCancel;
      Cancel:=True;
    end;

    if ShowModal=mrOk then
       result:=SeparateItems(ToList.Items);
  finally
    Free;
  end;
end;

procedure TFormDBTree.Button7Click(Sender: TObject);
begin
  With ComboBox3 do Text:=ChooseFields(Text,Items,Label4.Caption);
  ComboBox3Change(Sender);
end;

procedure TFormDBTree.Button4Click(Sender: TObject);
begin
  With ComboBox4 do Text:=ChooseFields(Text,Items,Label5.Caption);
  ComboBox4Change(Sender);
end;

procedure TFormDBTree.Button5Click(Sender: TObject);
begin
  With ComboBox6 do Text:=ChooseFields(Text,Items,Label7.Caption);
  ComboBox6Change(Sender);
end;

procedure TFormDBTree.CheckBox1Click(Sender: TObject);
begin
  Changed;
end;

procedure TFormDBTree.OnShowEditor(Sender:TObject);
begin
  with TNodeTreeEditor(Sender) do
       TTeeVCL.ShowControls(False,[Label22,CBConnStyle,CheckBox8,Label20,ComboBox5]);
end;

procedure TFormDBTree.EditShape(AShape:TTreeNodeShape);
begin
  TNodeTreeEditor.InternalEdit(nil,AShape,stFormat,False,OnShowEditor);
  Changed;
end;

procedure TFormDBTree.Button6Click(Sender: TObject);
begin
  EditShape(AFormatMaster);
end;

procedure TFormDBTree.Button8Click(Sender: TObject);
begin
  EditShape(AHeaderMaster);
end;

procedure TFormDBTree.Button9Click(Sender: TObject);
begin
  EditShape(AFormatDetail);
end;

procedure TFormDBTree.Button10Click(Sender: TObject);
begin
  EditShape(AHeaderDetail);
end;

procedure TFormDBTree.FormDestroy(Sender: TObject);
begin
  AFormatMaster.Free;
  AFormatDetail.Free;
  AHeaderMaster.Free;
  AHeaderDetail.Free;
end;

end.
