{************************************************}
{   TeeChart Office - DataSet Creation / Editing }
{   Copyright (c) 2015-2025 by Steema Software   }
{   All Rights Reserved.                         }
{************************************************}
unit TeeNewDataSet;
{$I TeeDefs.inc}

interface

{$IFDEF WIN64}
{$DEFINE NOUSE_BDE} // No BDE available for x64
{$ENDIF}

uses
  {$IFNDEF LINUX}
  Windows, Messages,
  {$ENDIF}
  Graphics, Controls, Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  {$IFDEF TEEENTERPRISE}
  {$IFNDEF LINUX}
  ADODB,
  {$ENDIF}
  {$ENDIF}
  Db, SysUtils, Classes, TeCanvas, TeeProcs, Grids, DBGrids, DBCtrls, TeePenDlg;

type
  TNewDataSet = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel1: TPanel;
    DatabaseStyle: TRadioGroup;
    TabBDE: TTabSheet;
    Label1: TLabel;
    ComboAlias: TComboFlat;
    SpeedButton1: TSpeedButton;
    ButtonBack: TButton;
    ButtonNext: TButton;
    Button3: TButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    ComboTables: TComboFlat;
    Memo1: TMemo;
    TabADO: TTabSheet;
    Label2: TLabel;
    ADOConnection: TMemo;
    Button4: TButton;
    RadioButton3: TRadioButton;
    ComboADOTables: TComboFlat;
    RadioButton4: TRadioButton;
    MemoADO: TMemo;
    PanelGrid: TPanel;
    BPreview: TButton;
    DBNavigator1: TDBNavigator;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    procedure ButtonNextClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ButtonBackClick(Sender: TObject);
    procedure ComboAliasChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure Memo1Enter(Sender: TObject);
    procedure ComboTablesEnter(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure ComboTablesChange(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure RadioButton4Click(Sender: TObject);
    procedure MemoADOEnter(Sender: TObject);
    procedure ComboADOTablesEnter(Sender: TObject);
    procedure BPreviewClick(Sender: TObject);
  private
    { Private declarations }

    FSource : TComponent;

    {$IFDEF TEEENTERPRISE}
    ADOConnection1: TADOConnection;
    procedure CheckADOConnection;
    procedure SetConnectionString;
    {$ENDIF}

    procedure UpdateSource;
  public
    { Public declarations }
    Function CreateDataSet(AOwner:TComponent):TDataSet;
    property CurrentSource:TComponent read FSource;
    Procedure SetOptions(ASource:TComponent);
  end;

implementation

{$IFNDEF LCL}
{$R *.DFM}
{$ELSE}
{$R *.lfm}
{$ENDIF}

{$WARN UNIT_PLATFORM OFF}

Uses {$IFNDEF NOUSE_BDE}
     DbTables,
     {$ENDIF}
     {$IFDEF TEEENTERPRISE}
     ADOConEd,
     {$ENDIF}
     {$IFNDEF LINUX}
     FileCtrl,
     {$ENDIF}
     {$IFDEF TEETRANSLATE}
     TeeTranslate,
     {$ENDIF}
     TeeOfficeConstants;

procedure TNewDataSet.ButtonNextClick(Sender: TObject);
begin { Go Next }
  with PageControl1 do
  begin
    if ActivePage=TabSheet1 then
    begin
      TabSheet1.TabVisible:=False;

      {$IFDEF TEEENTERPRISE}
      Case DatabaseStyle.ItemIndex of
        0: ActivePage:=TabADO;
        1: ActivePage:=TabBDE;
      end;
      {$ELSE}
      ActivePage:=TabBDE;
      {$ENDIF}

      BPreview.Visible:=True;
      ActivePage.TabVisible:=True;
      PageControl1Change(Self);
    end
    else
    begin
      UpdateSource;
      ModalResult:=mrOk;
    end;
  end;

  ButtonBack.Enabled:=True;
end;

procedure TNewDataSet.UpdateSource;
var tmp : TComponent;
    tmpName : String;
begin
  if Assigned(FSource) then
  begin
    tmp:=FSource.Owner;
    tmpName:=FSource.Name;
    FSource.Free;
    FSource:=CreateDataSet(tmp);
    FSource.Name:=tmpName;
  end;
end;

procedure TNewDataSet.PageControl1Change(Sender: TObject);
begin { Go Next }
  {$IFNDEF NOUSE_BDE}
  if PageControl1.ActivePage=TabBDE then
     Session.GetAliasNames(ComboAlias.Items)
  {$ENDIF}

  {$IFDEF TEEENTERPRISE}
  else
  if PageControl1.ActivePage=TabADO then
     if Assigned(ADOConnection1) then
        ADOConnection1.GetTableNames(ComboADOTables.Items)
  {$ENDIF}
  ;
     
  if PageControl1.ActivePage<>TabSheet1 then
     ButtonNext.Caption:=TeeMsg_Close;
end;

Function TNewDataSet.CreateDataSet(AOwner:TComponent):TDataSet;
begin
  { create a data-set object }
  if PageControl1.ActivePage=TabADO then
  begin
     {$IFDEF TEEENTERPRISE}
     if RadioButton3.Checked then
     begin
       { ADO Table }
       result:=TADOTable.Create(AOwner);
       with TADOTable(result) do
       begin
         Name:=TeeGetUniqueName(AOwner,'ADOTable');
         ConnectionString:=ADOConnection.Text;
         TableName:=ComboADOTables.Text;
         ReadOnly:=True;
       end;
     end
     else
     begin
       { ADO SQL Query }
       result:=TADOQuery.Create(AOwner);
       with TADOQuery(result) do
       begin
         Name:=TeeGetUniqueName(AOwner,'ADOQuery');
         ConnectionString:=ADOConnection.Text;
         SQL.Assign(MemoADO.Lines);
       end;
     end
     {$ELSE}
     result:=nil;
     {$ENDIF}
  end
  else
  begin
     {$IFNDEF NOUSE_BDE}
     if RadioButton1.Checked then
     begin
       { BDE Table }
       result:=TTable.Create(AOwner);
       with TTable(result) do
       begin
         Name:=TeeGetUniqueName(AOwner,TeeMsg_Table);
         DatabaseName:=ComboAlias.Text;
         TableName:=ComboTables.Text;
         ReadOnly:=True;
       end;
     end
     else
     begin
       { BDE SQL Query }
       result:=TQuery.Create(AOwner);
       with TQuery(result) do
       begin
         Name:=TeeGetUniqueName(AOwner,TeeMsg_Query);
         DatabaseName:=ComboAlias.Text;
         SQL.Assign(Memo1.Lines);
       end;
     end;
     {$ENDIF}
  end;

  {$IFDEF NOUSE_BDE}
  result:=nil;
  {$ELSE}
  result.Open;
  {$ENDIF}
end;

procedure TNewDataSet.SpeedButton1Click(Sender: TObject);
var tmp : String;
begin { Select a BDE folder }
  if SelectDirectory(TeeMsg_SelectFolder,'',tmp) then
     with ComboAlias do ItemIndex:=Items.Add(tmp);
end;

procedure TNewDataSet.Button3Click(Sender: TObject);
begin { cancel dialog }
  ModalResult:=mrCancel;
end;

procedure TNewDataSet.ButtonBackClick(Sender: TObject);
begin { Go Back }
  with PageControl1 do
  begin
    TabADO.TabVisible:=False;
    TabBDE.TabVisible:=False;
    ActivePage:=TabSheet1;
    ActivePage.TabVisible:=True;
  end;
end;

procedure TNewDataSet.ComboAliasChange(Sender: TObject);
begin { fill BDE Table names for selected BDE Alias }
  {$IFNDEF NOUSE_BDE}
  Session.GetTableNames(ComboAlias.Text,'',True,True,ComboTables.Items);
  {$ENDIF}
  ComboTables.Enabled:=ComboTables.Items.Count>0;
end;

procedure TNewDataSet.FormCreate(Sender: TObject);
begin
  PanelGrid.Visible:=False;
  Width:=400;

  {$IFDEF TEEENTERPRISE}
  ADOConnection1:=nil;
  {$ELSE}
  DatabaseStyle.Items.Delete(0); { remove "ADO" option }
  {$ENDIF}
  TabADO.TabVisible:=False;
  TabBDE.TabVisible:=False;
  {$IFDEF TEETRANSLATE}
  TeeTranslateControl(Self);
  {$ENDIF}
end;

procedure TNewDataSet.RadioButton2Click(Sender: TObject);
begin
  Memo1.SetFocus;
end;

procedure TNewDataSet.Memo1Enter(Sender: TObject);
begin
  RadioButton2.Checked:=True;
end;

procedure TNewDataSet.ComboTablesEnter(Sender: TObject);
begin
  RadioButton1.Checked:=True;
end;

procedure TNewDataSet.RadioButton1Click(Sender: TObject);
begin
  if ComboTables.CanFocus then
     ComboTables.SetFocus;
end;

procedure TNewDataSet.ComboTablesChange(Sender: TObject);
begin
  ButtonNext.Enabled:=True;
end;

procedure TNewDataSet.Memo1Change(Sender: TObject);
begin
  ButtonNext.Enabled:=True;
end;

{$IFDEF TEEENTERPRISE}
procedure TNewDataSet.SetConnectionString;
begin
  ADOConnection.Text:=ADOConnection1.ConnectionString;
  ADOConnection1.GetTableNames(ComboADOTables.Items);
end;

procedure TNewDataSet.CheckADOConnection;
begin
  if not Assigned(ADOConnection1) then
  begin
    ADOConnection1:=TADOConnection.Create(Self);
    ADOConnection1.LoginPrompt:=False;
  end;
end;
{$ENDIF}

procedure TNewDataSet.Button4Click(Sender: TObject);
begin { Select a new ADO Connection string }
  {$IFDEF TEEENTERPRISE}
  CheckADOConnection;
  if EditConnectionString(ADOConnection1) then
     SetConnectionString;
  {$ENDIF}
end;

procedure TNewDataSet.RadioButton3Click(Sender: TObject);
begin
  ComboADOTables.SetFocus;
end;

procedure TNewDataSet.RadioButton4Click(Sender: TObject);
begin
  MemoADO.SetFocus;
end;

procedure TNewDataSet.MemoADOEnter(Sender: TObject);
begin
  RadioButton4.Checked:=True;
end;

procedure TNewDataSet.ComboADOTablesEnter(Sender: TObject);
begin
  RadioButton3.Checked:=True;
end;

procedure TNewDataSet.SetOptions(ASource: TComponent);
begin
  FSource:=ASource;

  {$IFDEF TEEENTERPRISE}
  if ASource is TCustomADODataSet then
  begin
    DatabaseStyle.ItemIndex:=0;
    CheckADOConnection;
    ADOConnection1.ConnectionString:=TCustomADODataSet(ASource).ConnectionString;
    SetConnectionString;

    if ASource is TADOTable then
    begin
      ComboADOTables.Text:=TADOTable(ASource).TableName;
      ComboADOTables.ItemIndex:=ComboTables.Items.IndexOf(TADOTable(ASource).TableName);
    end
    else
       MemoADO.Lines.Assign(TADOQuery(ASource).SQL);
  end
  else
  {$ENDIF}
  begin
    DatabaseStyle.ItemIndex:=1;

    {$IFNDEF NOUSE_BDE}
    ComboAlias.Text:=TDBDataSet(ASource).DatabaseName;
    ComboAliasChange(Self);

    if ASource is TTable then
    begin
      ComboTables.Text:=TTable(ASource).TableName;
      ComboTables.ItemIndex:=ComboTables.Items.IndexOf(TTable(ASource).TableName);
    end
    else
       Memo1.Lines:=TQuery(ASource).SQL;
    {$ENDIF}
  end;
end;

procedure RegisterDBClasses;
var t : Integer;
begin
  {$IFNDEF NOUSE_BDE}
  RegisterClass(TTable);
  RegisterClass(TQuery);
  {$ENDIF}

  {$IFDEF TEEENTERPRISE}
  RegisterClass(TADOTable);
  RegisterClass(TADOQuery);
  {$ENDIF}

  for t:=0 to Ord(High(TFieldType)) do
  if Assigned(DefaultFieldClasses[TFieldType(t)]) then
     RegisterClass(DefaultFieldClasses[TFieldType(t)]);
end;

procedure TNewDataSet.BPreviewClick(Sender: TObject);
begin
  PanelGrid.Visible:=not PanelGrid.Visible;

  if PanelGrid.Visible then
  begin
     Width:=800;
     UpdateSource;

     if Assigned(FSource) then
     begin
       DataSource1.DataSet:=FSource as TDataSet;
       DataSource1.DataSet.Open;
     end
     else
        DataSource1.DataSet:=nil;
  end
  else
     Width:=400;
end;

initialization
  RegisterDBClasses;
end.
