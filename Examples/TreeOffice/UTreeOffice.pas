{*********************************************}
{  TeeTree Office                             }
{  Copyright (c) 2001-2025 by Steema Software }
{*********************************************}
unit UTreeOffice;
{$I TeeDefs.inc}

{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_PLATFORM OFF}

interface

{*
 This unit is an example of TeeTree component library.

 All TeeTree components and objects are used to build an stand-alone
 aplication executable (TeeTreeOffice.exe)

 The main form is derived from TreeEditor form (at TreeEd.pas unit).

 Additional things this example does:
 ------------------------------------

 -Adds a new option in the main menu to show the Animation Editor,
  at "Tools" menu.

 -Creates and displays the Animation Editor when the menu option is
  checked.

 -Creates a TreeAnimate non-visible component so the Animation Editor can
  use it.

 -Registers the "TTR" file extension in Windows Registry so when double-
  clicking a *.ttr file in Windows Explorer, Windows will automatically
  open this project passing the file name as first parameter.

 -Adds a new option in main menu "Tools" for Language selection.
  When Language menu item is selected, a dialog is displayed allowing the
  end user to switch the language.

 -Overrides default behaviour of Save and Load methods, so when saving and
  loading a Tree, it can also store (append) the Animation properties
  at the end of the file.

 -Adds a new menu item to show the Database Wizard dialog.
  This dialog allows connecting a DBTree to a database table to load records
  and add Tree nodes.

 -Adds the "Undo" menu item at main menu "Edit".

 -Overrides Save and Load editor parameters methods, to add a registry entry
  storing the status of the Animation Editor.

 -Tells Windows to accept dragging files from Windows Explorer to this
  application. ( See "DragAcceptFiles" and "WMDropFiles" )

 -Calls TrimWorkingSet to reduce the allocated Windows memory at startup.

 -Shows this executable build number (version information) at About... dialog.

*}

uses
  {$IFNDEF LINUX}
  Windows, Messages,
  {$ENDIF}
  SysUtils, Classes,
  Graphics, Controls, Forms, Dialogs, ImgList, Menus, ComCtrls, StdCtrls,
  ExtCtrls, Buttons, Grids,

  TreeEd, TreeAnimate, TreeAnimateEditor, TeeProcs, TeeTree, TeePenDlg,
  TeCanvas, TeeNavigator, TreeNavigator, TeeInspector, TeeGDIPlus;

type
  TTreeEditor1 = class(TTreeEditor)
    N23: TMenuItem;
    Language1: TMenuItem;
    NewDatabaseTree1: TMenuItem;
    N25: TMenuItem;
    Animation1: TMenuItem;
    N26: TMenuItem;
    Undo1: TMenuItem;
    N27: TMenuItem;
    Updateversion1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Edit4Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure AboutTeeTree101Click(Sender: TObject);
    procedure Language1Click(Sender: TObject);
    procedure NewDatabaseTree1Click(Sender: TObject);
    procedure Animation1Click(Sender: TObject);
    procedure Undo1Click(Sender: TObject);
    procedure Updateversion1Click(Sender: TObject);
  private
    { Private declarations }
    FAnimate       : TTreeAnimate;
    FAnimateEditor : TTreeAnimateEditor;
    FSplitter      : TSplitter;
    AnimationEditorHeight : Integer;

    Function Animate:TTreeAnimate;
    Procedure AnimateEditorClose(Sender: TObject; var Action: TCloseAction);
    Procedure AnimateEditorModified(Sender: TObject);

    {$IFNDEF NOUSE_BDE}
    Procedure NewDataSet(Sender: TObject);
    {$ENDIF}

    Procedure ShowAnimationEditor;
    procedure WMDROPFILES(var Message: TWMDROPFILES); message WM_DROPFILES;
  protected
    procedure LoadTreeProc(Reader:TReader; Stream:TStream); override;
    Procedure SetNewTreeSettings; override;

    {$IFNDEF NOUSE_BDE}
    class Function TeeTreeClass: TTreeClass; override;
    {$ENDIF}

    Procedure WriteTreeToStream(AStream:TStream); override;
  public
    { Public declarations }
    Procedure LoadEditorParameters; override;
    Procedure SaveEditorParameters; override;
  end;

var
  TreeEditor1: TTreeEditor1;

{ Add the *.ttr file extension to Windows registry }
Procedure RegisterTeeTreeOffice;

{ Reduce allocated memory at startup under Windows }
Procedure TrimWorkingSet;

implementation

{$IFNDEF LCL}
{$R *.DFM}
{$ELSE}
{$R *.lfm}
{$ENDIF}

Uses {$IFNDEF NOUSE_BDE}
     TreeDBEd, TeeDBTre, DB,
     {$ENDIF}

     TeeJPEG, TeePNG, TeeVMLCanvas,
     TeePDFCanvas, TeeSVGCanvas, TeePSCanvas, TeeXAMLCanvas, 

     TeeTranslate, TeeTranslateEditor,
     TreeConst, TeeConst, TeeProCo, TeeOfficeConstants, TreeOfficeConstants,

     {$IFNDEF LINUX}
     ShellAPI, ShlObj, Registry, TeeUpdateVersion,
     {$ENDIF}

     {$IFNDEF NOUSE_BDE}
     TeeNewDataSet,
     {$ENDIF}

     TeeGIF, TeePCX, Math, TreeUML, TreeElectric, TreeFlow, TreeTransit;

Const
  sAniEditorHeight='AnimationEditorHeight';

{ Add the *.ttr file extension to Windows registry }
Procedure RegisterTeeTreeOffice;
Const
  TeeTree_MIME='\MIME\Database\Content Type\application/teechart';
  TeeTreeExtension='.'+TreeMsg_TeeExtension;

{$IFNDEF LINUX}
Var tmp : TRegistry;
{$ENDIF}

  {$IFNDEF LINUX}
  Function ExistExtension:Boolean;
  begin { Returns True if the *.ttr extension is correctly registered }
    result:=tmp.KeyExists(TeeTreeExtension);

    if result then
       if tmp.OpenKey('TeeTree\DefaultIcon',True) then
          result:=tmp.ReadString('')=ParamStr(0)+',0';
  end;
  {$ENDIF}

begin  { register the *.ttr file extension to allow using TeeTreeOffice
         when double-clicking a *.ttr file in Windows Explorer }

  {$IFNDEF LINUX}
  tmp:=TRegistry.Create;
  with tmp do
  try
    RootKey:=HKEY_CLASSES_ROOT;

    if not ExistExtension then { check if exists... }
    begin
      { extension }
      if OpenKey(TeeTreeExtension,True) then
      try
        WriteString('','TeeTree');
        WriteString('Content Type','application/teetree');
      finally
        CloseKey;
      end;

      { application }
      if OpenKey('TeeTree',True) then
      begin
        WriteString('','TeeTree file');
        if OpenKey('DefaultIcon',True) then
        begin
          WriteString('',ParamStr(0)+',0');
          CloseKey;
        end;

        if OpenKey('TeeTree',True) then
        if OpenKey('Shell',True) then
           if OpenKey('Open',True) then
           begin
             WriteString('',TeeMsg_OpenWithTeeTreeOffice);

             if OpenKey('Command',True) then
                WriteString('',ParamStr(0)+' "%1"');
           end;
      end;

      { notify Windows on creating file *.ttr association }
      SHChangeNotify(SHCNE_ASSOCCHANGED,SHCNF_IDLIST,nil,nil);
    end;

    { Add MIME content-type to registry database... }
    if not KeyExists(TeeTree_MIME) then
    begin
      if OpenKey(TeeTree_MIME,True) then
         WriteString('Extension',TeeTreeExtension);
    end;
  finally
    Free;
  end;

  {$ENDIF}
end;

// Similar to TeeChart Office, adding TeeTree constants
// Change Language, reading from Registry last saved.
Procedure TreeOfficeSetLanguage(English:Boolean);

  function GuessLanguage:Integer;
  {$IFDEF LINUX}
  begin
    result:=-1;
  end;
  {$ELSE}
  var tmp : Integer;
  begin
    tmp:=StrToIntDef('$'+GetLocaleStr(GetThreadLocale, LOCALE_ILANGUAGE, '0'),0);
    case tmp of
      $0403 : result:=2;
      $0407 : result:=8;
      $0406 : result:=5;
      $0416 : result:=1;
      $040C : result:=7;
      $040E : result:=19;
      $0410 : result:=9;
      $0c0a : result:=12;
      $041D : result:=13;
      $0414,
      $0814 : result:=14;
    else
      result:=-1;
    end;
  end;
  {$ENDIF}

var tmp : Integer;
begin
  tmp:=TeeLanguageRegistry;
  if (not English) and (tmp=-1) then
     tmp:=GuessLanguage;

  Case tmp of
    1: TreeOfficeBrazil;
    2: TreeOfficeCatalan;
    3: TreeOfficeChineseSimp;
    4: TreeOfficeChinese;
    5: TreeOfficeDanish;
    6: TreeOfficeDutch;
    7: TreeOfficeFrench;
    8: TreeOfficeGerman;
    9: TreeOfficeItalian;
   10: TreeOfficePortuguese;
   11: TreeOfficeRussian;
   12: TreeOfficeSpanish;
   13: TreeOfficeSwedish;
   14: TreeOfficeNorwegian;
   15: TreeOfficeJapanese;
   16: TreeOfficePolish;
   17: TreeOfficeSlovene;
   18: TreeOfficeTurkish;
   19: TreeOfficeHungarian;
   20: TreeOfficeGalician;
  else
    if English then TreeOfficeEnglish;
  end;
end;

procedure TTreeEditor1.FormCreate(Sender: TObject);
begin
  inherited;

  AnimationEditorHeight:=140; // default height for Animation Editor

  CaptionFormat:=TeeMsg_TeeTreeOffice+' - %s';
  Caption:=TeeTreeOfficeVersion;

  { Read current language from registry }
  TreeOfficeSetLanguage(False);

  { Translate using current language }
  DoTranslate;

  { tell Windows to accept dragged files from Explorer }
  DragAcceptFiles(Handle,True);
end;

// Override default TTree class with TDBTree class
{$IFNDEF NOUSE_BDE}
class Function TTreeEditor1.TeeTreeClass: TTreeClass;
begin
  result:=TDBTree;
end;
{$ENDIF}

// Create and return the Animate object
Function TTreeEditor1.Animate:TTreeAnimate;
begin
  if not Assigned(FAnimate) then
  begin
    FAnimate:=TTreeAnimate.Create(Self);
    FAnimate.Tree:=TheTree;
  end;
  result:=FAnimate;
end;

// Called when closing the AnimateEditor window
Procedure TTreeEditor1.AnimateEditorClose(Sender: TObject; var Action: TCloseAction);
begin
  FAnimateEditor:=nil;
  FSplitter.Free;
  Action:=caFree;
end;

// Called when something in the Animate is modified
Procedure TTreeEditor1.AnimateEditorModified(Sender: TObject);
begin
  TeeModified; // Call default modified method.
end;

Procedure TTreeEditor1.ShowAnimationEditor;
begin
  if not Assigned(FAnimateEditor) then
  begin
    // Create splitter
    FSplitter:=TSplitter.Create(Self);
    with FSplitter do
    begin
      Parent:=Self;
      Top:=Self.StatusBar1.Top-1;
      Align:=alBottom;
    end;

    // Create Animation editor window
    FAnimateEditor:=TTreeAnimateEditor.Create(Self);
    with FAnimateEditor do
    begin
      OnClose:=AnimateEditorClose;
      OnModified:=AnimateEditorModified;
      Animate:=Self.Animate;
      BorderIcons:=[];
      BorderStyle:=TeeFormBorderStyle;
      Top:=FSplitter.Top-1;
      Height:=AnimationEditorHeight;
      Parent:=Self;
      Align:=alBottom;
    end;

    // Move status bar to bottom, after adding the above controls:
    StatusBar1.Top:=Height-StatusBar1.Height;
  end;

  FAnimateEditor.Show;
  FSplitter.Show;

  Animation1.Checked:=True;
end;

{$IFNDEF NOUSE_BDE}
Procedure TTreeEditor1.NewDataSet(Sender: TObject);
var tmp : TDataSet;
begin { create a new DataSet dialog }
  With TNewDataSet.Create(nil) do
  try
    if ShowModal=mrOk then
    begin
      Self.TeeModified;
      tmp:=CreateDataSet(Self);
      with TFormDBTree(TComponent(Sender).Owner) do
      begin
        FillControls;
        CBDataSet.ItemIndex:=CBDataSet.Items.IndexOfObject(tmp);
        CBDataSetChange(CBDataSet);
      end;
    end;
  finally
    Free;
  end;
end;
{$ENDIF}

procedure TTreeEditor1.FormShow(Sender: TObject);
begin
  inherited;
  if ParamCount>0 then
  try
    LoadTree(ParamStr(1)); { load Tree parameter }
  finally
    SetInspectorProperties;
  end;
end;

Procedure TrimWorkingSet;
{$IFNDEF LINUX}
var MainHandle : THandle;
{$ENDIF}
begin  { reduce allocated memory at startup }
  {$IFNDEF LINUX}
  MainHandle:=OpenProcess(PROCESS_ALL_ACCESS,False,GetCurrentProcessID);
  SetProcessWorkingSetSize(MainHandle,$ffffffff,$ffffffff);
  CloseHandle(MainHandle);
  {$ENDIF}
end;

procedure TTreeEditor1.WMDROPFILES(var Message: TWMDROPFILES);
var FileName : Array[0..255] of Char;
begin { open *.tee files mouse-dropped from Windows Explorer }
  if DragQueryFile(Message.Drop,$FFFFFFFF,nil,0)>0 then
  begin
    DragQueryFile(Message.Drop,0,@FileName,SizeOf(FileName));

    if CheckSave then
       LoadTree(FileName); { load dropped file }
  end;
end;

procedure TTreeEditor1.SetNewTreeSettings;
begin
  inherited;
  if Assigned(FAnimate) then
     FAnimate.Animations.Clear;
end;

procedure TTreeEditor1.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Animate.Stop;
  if Assigned(FAnimateEditor) then
     FAnimateEditor.FormClose(FAnimateEditor,Action);
  inherited;
end;

procedure TTreeEditor1.Edit4Click(Sender: TObject);
begin
  inherited;
  with Edit4.Items[0] do
  begin
    Caption:='Undo';
    Enabled:=TreeUndo.Count>0;
    if Enabled then
       Caption:=Caption+' '+TreeUndo.Last.Text;
  end;
end;

Procedure TTreeEditor1.WriteTreeToStream(AStream:TStream);
begin
  inherited;  // Call inherited to save Tree
  if Assigned(FAnimate) then
     AStream.WriteComponent(FAnimate); // Append Animate component to stream
end;

// Called when loading a Tree from stream or file
procedure TTreeEditor1.LoadTreeProc(Reader: TReader; Stream: TStream);
var tmp : TComponent;
begin
  inherited;
  FreeAndNil(FAnimate);

  // Is there an Animate component appended to stream ?
  if Reader.Position<Stream.Size then
  begin
    // Read component from stream
    tmp:=Reader.ReadRootComponent(nil);
    if tmp is TTreeAnimate then
    begin
      // Set Animate component
      FAnimate:=TTreeAnimate(tmp);
      FAnimate.Tree:=TheTree;
    end;
  end;

  // Set AnimateEditor.Animate property:
  if Assigned(FAnimateEditor) then
     if Assigned(FAnimate) then
        FAnimateEditor.Animate:=FAnimate
     else
     begin
       FreeAndNil(FAnimateEditor);
       Animation1.Checked:=False;
     end;
end;

procedure TTreeEditor1.LoadEditorParameters;
begin
  inherited;

  With TRegistry.Create do
  try
    if OpenKeyReadOnly(TeeTreeKey) then
    begin
      // Before creating the Animation Editor, read Height:
      if ValueExists(sAniEditorHeight) then
         AnimationEditorHeight:=Math.Max(1,ReadInteger(sAniEditorHeight));

      if ValueExists('AnimationEditor') then
         if ReadBool('AnimationEditor') then
            ShowAnimationEditor;

    end;
  finally
    Free;
  end;
end;

procedure TTreeEditor1.SaveEditorParameters;
begin
  inherited;

  With TRegistry.Create do
  try
    if OpenKey(TeeTreeKey,True) then
    begin
      WriteBool('AnimationEditor',Assigned(FAnimateEditor) and FAnimateEditor.Visible);
      if Assigned(FAnimateEditor) then
         WriteInteger(sAniEditorHeight,FAnimateEditor.Height);
    end;
  finally
    Free;
  end;
end;

procedure TTreeEditor1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FAnimateEditor);
  inherited;
end;

// Returns an string containing the build number (version information)
// of this executable.
function BuildNumber: String;
{$IFNDEF LINUX}
var tmpSize   : Cardinal;
    tmpHandle : Cardinal;
    tmpInfo   : Pointer;
    tmpName   : PChar;
    tmpFileInfo : PVSFixedFileInfo;
    tmpFileSize : Cardinal;
{$ENDIF}
begin
  result:='';
  {$IFNDEF LINUX}
  tmpName:=PChar(Application.ExeName);
  tmpSize:=GetFileVersionInfoSize(tmpName,tmpHandle);
  if tmpSize>0 then
  begin
    GetMem(tmpInfo,tmpSize);
    try
      Win32Check(GetFileVersionInfo(tmpName,0,tmpSize,tmpInfo));
      Win32Check(VerQueryValue(tmpInfo,'\',Pointer(tmpFileInfo),tmpFileSize));

      with tmpFileInfo^ do
           result:=IntToStr(LongRec(dwFileVersionMS).Hi)+'.'+
                   IntToStr(LongRec(dwFileVersionMS).Lo)+'.'+
                   IntToStr(LongRec(dwFileVersionLS).Hi)+'.'+
                   IntToStr(LongRec(dwFileVersionLS).Lo);
    finally
      FreeMem(tmpInfo);
    end;
  end;
  {$ENDIF}
end;

procedure TTreeEditor1.AboutTeeTree101Click(Sender: TObject);
var tmp, tmpH : String;
begin
  tmp:='Build';
  tmpH:='';
  TeeCanTranslate(tmp,tmpH);

  TeeShowTreeAbout('  '+tmp+': '+BuildNumber); // add version info to About...
end;

procedure TTreeEditor1.Language1Click(Sender: TObject);
var WasEnglish : Boolean;
begin { show the Options dialog }
  WasEnglish:=not Assigned(TeeLanguage);

  if TeeAskLanguage then
  begin
    { Set new language }
    TreeOfficeSetLanguage(True);

    { Translate current main form }
    if WasEnglish and Assigned(TeeLanguage) then
    begin
      DoTranslate;

      { Translate Inspector header and repaint }
      TeeInspector1.Header.Update;

      { Change "Save as..." dialog title }
      SaveDialog1.Title:=TeeMsg_SaveAs;

      { Re-fill inspector grid with translated properties }
      SetInspectorProperties;
    end
    else ShowMessage(TeeMsg_ShouldClose);
  end;
end;

procedure TTreeEditor1.NewDatabaseTree1Click(Sender: TObject);
begin
  {$IFNDEF NOUSE_BDE}
  With TFormDBTree.Create(Owner) do
  try
    Tree1:=TCustomDBTree(TheTree);
    BNewDataSet.Visible:=True;
    BNewDataSet.OnClick:=NewDataSet;
    if ShowModal=mrOk then
    begin
      FillNodeTree;
      TeeModified;
    end;
  finally
    Free;
  end;
  {$ENDIF}
end;

procedure TTreeEditor1.Animation1Click(Sender: TObject);
begin
  with TMenuItem(Sender) do Checked:=not Checked;
  if TMenuItem(Sender).Checked then
  begin
    ShowAnimationEditor;
  end
  else
  begin
    if Assigned(FAnimateEditor) then
    begin
      FAnimateEditor.Hide;
      FSplitter.Hide;
    end;
  end;
end;

procedure TTreeEditor1.Undo1Click(Sender: TObject);
begin
  TreeUndo.Undo;
end;

procedure TTreeEditor1.Updateversion1Click(Sender: TObject);
begin
  {$IFNDEF LINUX}
  if CheckSave then
     UpdateVersion(TeeTreeOfficeVersion,TTreeOfficeVersionURL,TeeMsg_URLMagic);
  {$ENDIF}
end;

initialization
  RegisterClass(TTreeAnimate);
end.


