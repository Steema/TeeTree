{********************************************}
{ TeeTree exporting to Javascript HTML5      }
{ Copyright (c) 2012-2025 by Steema Software }
{ All Rights Reserved                        }
{********************************************}
unit TeeTreeJavaScript;
{$I TeeDefs.inc}

interface

uses
  SysUtils, Classes,

  {$IFDEF FMX}
  FMX.Types, FMX.Forms, FMXTee.Canvas, FMXTee.Procs,
  FMXTee.Editor.Export, FMX.ListBox,
  FMXTee.Canvas.JavaScript, FMXTee.Tree
  {$ELSE}
  Graphics, Controls, Forms,
  TeCanvas, TeeProcs, TeeExport, TeeJavaScript, TeeTree
  {$ENDIF}
  ;

type
  TTreeJavascriptExportFormat=class(TCustomJSExportFormat)
  private
    procedure AddHeader(const S:TStrings);
    function GetTreeName:String;
    procedure SetTreeName(const Value: String);
    function Tree:TCustomTree;
  protected
    procedure DoAddStrings(const S:TStrings); override;
  public
    property TreeName:String read GetTreeName write SetTreeName;
  end;

procedure TeeSaveToJavascriptFile( const APanel:TCustomTree; const FileName: String;
                                   AWidth:Integer=0; AHeight: Integer=0;
                                   AMinify:Boolean=False); overload;

implementation

procedure TTreeJavascriptExportFormat.AddHeader(const S: TStrings);
begin
  S.Add('<!DOCTYPE html>');
  S.Add('<HTML>');
  S.Add('<HEAD>');

  S.Add('<title>'+Tree.Name+'</title>');

  S.Add('<link rel="StyleSheet" href="'+SourceScriptPath+'/3rd_party/dtree/dtree.css" type="text/css" />');
  S.Add('<script src="'+SourceScriptPath+'/3rd_party/dtree/dtree.js" type="text/javascript"></script>');
end;

procedure TTreeJavascriptExportFormat.DoAddStrings(const S:TStrings);
var
  TempString : String;

  procedure AddScript(const St:String);
  begin
    if Minify then
    begin
      TempString:=TempString+St;

      if Length(TempString)>200 then
      begin
        s.Add(TempString);
        TempString:='';
      end;
    end
    else
      s.Add('  '+St);
  end;

var
  Tabs: String;

  procedure EmitNodes(const Tag:String; const AShapeList: TTreeShapeList);
  var i : Integer;
      tmpCall : String;
      tmp : TTreeNodeShape;
  begin
    AddScript(Tabs+'function '+Tag+'add(index,parent,text,expanded) {');
    AddScript(Tabs+'  '+Tag+'.add(index,parent,text,"","","",'+Tag+'.icon.folder,'+Tag+'.icon.folderOpen,expanded)');
    AddScript(Tabs+'}');

    for i:=0 to AShapeList.Count-1 do
    begin
      tmp:=AShapeList[i];

      tmpCall:=Tabs+Tag+'add('+InttoStr(i)+','+ //id
               IntToStr(AShapeList.IndexOf(tmp.Parent))+ //pid
               ',"'+Trim(tmp.Text.Text)+'"'; //name

      if tmp.Expanded then
         tmpCall:=tmpCall+',true';

      AddScript(tmpCall+');');
    end;
  end;

var tmpIcon : String;
begin
  if DoFullPage Then
  Begin
    AddHeader(s);

    s.Add('</HEAD>');
    s.Add('<BODY>');
  end;

  AddScript('<div id="tree">');

  Tabs:='  ';

  AddScript(Tabs+'<script type="text/javascript">');

  Tabs:=Tabs+'  ';

  AddScript(Tabs+'var '+TreeName+'=new dTree("'+TreeName+'"), '+TreeName+'icon='+TreeName+'.icon;');
  AddScript(Tabs+'var images="'+SourceScriptPath+'/3rd_party/dtree/img";');

  tmpIcon:=Tabs+TreeName+'icon.';

  //AddScript(tmpIcon+'root=images+"/base.gif";');
  AddScript(tmpIcon+'folder=images+"/folder.gif";');
  AddScript(tmpIcon+'folderOpen=images+"/folderopen.gif";');
  //AddScript(tmpIcon+'node=images+"/page.gif";');
  AddScript(tmpIcon+'empty=images+"/empty.gif";');
  AddScript(tmpIcon+'line=images+"/line.gif";');
  AddScript(tmpIcon+'join=images+"/join.gif";');
  AddScript(tmpIcon+'joinBottom=images+"/joinbottom.gif";');
  AddScript(tmpIcon+'plus=images+"/plus.gif";');
  AddScript(tmpIcon+'plusBottom=images+"/plusbottom.gif";');
  AddScript(tmpIcon+'minus=images+"/minus.gif";');
  AddScript(tmpIcon+'minusBottom=images+"/minusbottom.gif";');
  AddScript(tmpIcon+'nlPlus=images+"/nolines_plus.gif";');
  AddScript(tmpIcon+'nlMinus=images+"/nolines_minus.gif";');
  //AddScript(Tabs+TreeName+'.config.useCookies=false;');

  EmitNodes(TreeName, Tree.Shapes);

  AddScript(Tabs+'document.write('+TreeName+');');

  AddScript('  </script>');
  AddScript('</div>');

  if TempString<>'' then
     s.Add(TempString);

  if DoFullPage then
  begin
    s.Add('</BODY>');
    s.Add('</HTML>');
  end;
end;

function TTreeJavascriptExportFormat.Tree: TCustomTree;
begin
  result:=TCustomTree(Panel);
end;

function TTreeJavascriptExportFormat.GetTreeName:String;
begin
  if PanelName='' then
     result:='Tree1'
  else
     result:=PanelName;
end;

procedure TTreeJavascriptExportFormat.SetTreeName(const Value: String);
begin
  PanelName := Value;
end;

procedure TeeSaveToJavascriptFile( const APanel:TCustomTree; const FileName: String;
                                   AWidth:Integer=0; AHeight: Integer=0;
                                   AMinify:Boolean=False);
var st : TStrings;
begin
  st:=TStringList.Create;
  try
    with TTreeJavascriptExportFormat.Create do
    try
      Width:=AWidth;
      Height:=AHeight;

      Panel:=APanel;

      CheckSize;

      Minify:=AMinify;

      AddStrings(st);
    finally
      Free;
    end;

    st.SaveToFile(FileName);
  finally
    st.Free;
  end;
end;

end.
