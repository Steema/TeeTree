{**********************************************}
{   TeeChart Office / TeeTree                  }
{   Recent Files class.                        }
{   Copyright (c) 2001-2025 by Steema Software }
{**********************************************}
{$I TeeDefs.inc}
unit TeeRecentFiles;

interface

uses
  Menus, Classes;

type
  TRecentFilesNotifyEvent=procedure(Const FileName:String) of object;

  TRecentFiles=class
  private
    procedure ReopenFile(Sender:TObject);
    Function GetFileName(Item:TMenuItem):String;
  public
    MenuItem : TMenuItem;
    MenuSep  : TMenuItem;
    ReOpenFileEvent:TRecentFilesNotifyEvent;
    procedure Add(Const FileName:String);
    Procedure ReadRegistry(Const Key:String);
    Procedure WriteRegistry(Const Key:String);
  end;

implementation

Uses
  {$IFNDEF LINUX}
  Registry, Windows,
  {$ENDIF}
  SysUtils;

Const TeeMaxRecentFiles=10;

{ TRecentFiles }
Function TRecentFiles.GetFileName(Item:TMenuItem):String;
var i : Integer;
begin { obtain a "recent file" file name from menu item }
  result:=Item.Caption;
  i:=Pos(' ',result);
  if i>0 then Delete(result,1,i);
  result:=StripHotkey(result);
end;

Procedure TRecentFiles.WriteRegistry(Const Key:String);
{$IFNDEF LINUX}
var t : Integer;
{$ENDIF}
begin { store into registry the "recent files" list }
  {$IFNDEF LINUX}
  With TRegistry.Create do
  try
    if OpenKey(Key,True) then
    begin
      WriteInteger('Count',MenuItem.Count);
      for t:=MenuItem.Count downto 1 do
          WriteString('File'+IntToStr(MenuItem.Count-t+1),GetFileName(MenuItem.Items[t-1]));
    end;
  finally
    Free;
  end;
  {$ENDIF}
end;

procedure TRecentFiles.Add(Const FileName:String);

  Function ExistsName(St:String):Boolean;
  var t : Integer;
  begin
    result:=False;
    St:=Uppercase(St);
    for t:=1 to MenuItem.Count do
        if St=UpperCase(GetFileName(MenuItem.Items[t-1])) then
        begin
          result:=True;
          break;
        end;
  end;

var tmp : TMenuItem;
begin { add a new "recent file" to menu }
  if FileName<>'' then
  begin
    if (not ExistsName(FileName)) and FileExists(FileName) then
    begin
      While MenuItem.Count>TeeMaxRecentFiles-1 do
            MenuItem.Items[TeeMaxRecentFiles-2].Free;

      tmp:=TMenuItem.Create(MenuItem.Owner);
      tmp.Caption:='&'+IntToStr(MenuItem.Count)+' '+FileName;
      tmp.OnClick:=ReOpenFile;
      MenuItem.Insert(0,tmp);
      MenuItem.Visible:=True;
      MenuSep.Visible:=True;
    end;
  end;
end;

Procedure TRecentFiles.ReadRegistry(Const Key:String);
{$IFNDEF LINUX}
var t : Integer;
{$ENDIF}
begin  { read the recent files from registry }
  {$IFNDEF LINUX}
  With TRegistry.Create do
  try
    if OpenKeyReadOnly(Key) then
    begin
      while MenuItem.Count>0 do
            MenuItem[0].Free;

      for t:=1 to ReadInteger('Count') do
          Add(ReadString('File'+IntToStr(t)));
    end;
  finally
    Free;
  end;
  {$ENDIF}
end;

procedure TRecentFiles.ReopenFile(Sender: TObject);
begin  { re-open a "recent" file }
  ReopenFileEvent(GetFileName(TMenuItem(Sender)));
end;

end.
