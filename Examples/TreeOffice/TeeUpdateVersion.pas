{************************************************}
{   Tee Office -      Automatic Version Update   }
{   Copyright (c) 2001-2025 by Steema Software   }
{   All Rights Reserved.                         }
{************************************************}
unit TeeUpdateVersion;
{$I TeeDefs.inc}

interface

uses
  {$IFNDEF LINUX}
  Windows, Messages,
  {$ENDIF}
  Graphics, Controls, Forms, Dialogs, ExtCtrls, StdCtrls, SysUtils, Classes;

type
  TUpdateVersion = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    LabelVersion: TLabel;
    Label4: TLabel;
    Bevel1: TBevel;
    LabelLatest: TLabel;
    ButtonOk: TButton;
    Button2: TButton;
    LabelMessage: TLabel;
    Bevel2: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure ButtonOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FZIPURL     : String;
    FVersionURL : String;
    FTemp       : String;
    FMagic      : String;
    Procedure GetLatestVersion;

    Function HasLatestVersion:Boolean;
  public
    { Public declarations }
    class function GetVersionFromSteema(const VersionURL,Magic:String; out AVersion,ADate,AURL:String):Boolean;
  end;

{ Show the Update Version dialog to retrieve a new release }
Procedure UpdateVersion(Const Version, VersionURL, Magic:String);

{ Download file from URL and return a memory stream }
Function TeeDownloadFile(Const URL,ErrorMessage:String):TMemoryStream;

implementation

{$IFNDEF LCL}
{$R *.DFM}
{$ELSE}
{$R *.lfm}
{$ENDIF}

Uses TeEngine,

     {$IFNDEF LINUX}
     ShellApi,
     {$ENDIF}
     TeeOfficeConstants, TeeURL, TeeConst, TeeProcs;

Procedure UpdateVersion(Const Version,VersionURL,Magic:String);
begin { show the Update Version dialog }
  With TUpdateVersion.Create(nil) do
  try
    FVersionURL:=VersionURL;
    FMagic:=Magic;
    LabelVersion.Caption:=Version;
    ShowModal;
  finally
    Free;
  end;
end;

procedure TUpdateVersion.FormCreate(Sender: TObject);
begin
  LabelLatest.Caption:='';
  LabelMessage.Caption:='';
end;

procedure ExecuteFile(Const FileName:String);
var
  tmpFileName,
  tmpParams,
  tmpDir      : Array[0..79] of Char;
begin  { execute a file (exe file or any other type) }
  ShellExecute(Application.MainForm.Handle,
               nil,
               StrPCopy(tmpFileName, FileName),
               StrPCopy(tmpParams, ''),
               StrPCopy(tmpDir,''),
               SW_SHOWNORMAL);
end;

procedure TUpdateVersion.ButtonOkClick(Sender: TObject);
var AVersion,
    ADate,
    AURL : String;
begin { check if we have the latest version of TeeChartOffice }
  if LabelMessage.Caption=TeeMsg_VersionReceived then
  begin
    ExecuteFile(FTemp);
    Application.Terminate;
  end
  else
  if ButtonOk.Caption=TeeMsg_OK then { we should close }
     Close
  else
  begin
    if ButtonOk.Caption=TeeMsg_UpdateButton then
    begin { lets get the latest version ... }
      ButtonOk.Caption:=TeeMsg_OK;
      LabelMessage.Caption:='';
      GetLatestVersion;
    end
    else
    begin { check the latest version ... }
      ButtonOk.Caption:=TeeMsg_OK;

      if GetVersionFromSteema(FVersionURL,FMagic,AVersion,ADate,AURL) then
      begin
        { show the latest version number and date }
        LabelLatest.Caption:=AVersion;
        LabelLatest.Caption:=LabelLatest.Caption+' '+ADate;
        FZIPURL:=AURL;

        if HasLatestVersion then { already has latest }
           LabelMessage.Caption:=TeeMsg_HasLatestVersion
        else
        begin { change button to download latest }
          LabelMessage.Font.Color:=clGreen;
          LabelMessage.Caption:=TeeMsg_ClickToUpdateVersion;
          ButtonOk.Caption:=TeeMsg_UpdateButton;
        end;
      end;
    end;
  end;
end;

Function TeeDownloadFile(Const URL,ErrorMessage:String):TMemoryStream;
var tmp : Integer;
begin { retrieve a file from web URL into the resulting Stream }
  result:=TMemoryStream.Create;

  Screen.Cursor:=crHourGlass;
  try
    tmp:=DownloadURL(URL,result);
  finally
    Screen.Cursor:=crDefault;
  end;

  if tmp<>0 then { show error message exception }
     Raise ChartException.CreateFmt(ErrorMessage,
           [tmp,URL+' '+TeeURLErrorMessage(tmp)]);
end;

class Function TUpdateVersion.GetVersionFromSteema(const VersionURL,Magic:String; out AVersion,ADate,AURL:String):Boolean;
var tmpS   : TStringList;
    Stream : TMemoryStream;
begin { retrieves the latest version number from Steema.com }
  result:=False;

  Stream:=TeeDownloadFile(VersionURL,TeeMsg_CannotGetVersion);
  try
    tmpS:=TStringList.Create;
    try
      tmpS.LoadFromStream(Stream);

      if (tmpS.Count>4) and
         (UpperCase(tmpS[0])=Magic) and
         (UpperCase(tmpS[1])='VERSION') then
      begin
        AVersion:=tmpS[2];
        ADate:=tmpS[3];

        {$IFDEF WIN64}
        AURL:=tmpS[5];
        {$ELSE}
        AURL:=tmpS[4];
        {$ENDIF}
        
        result:=True;
      end
      else
         Raise ChartException.Create(TeeMsg_WrongVersion);
    finally
      tmpS.Free;
    end;
  finally
    Stream.Free;
  end;
end;

type
  TPathName=array[0..MAX_PATH] of Char;

procedure TUpdateVersion.GetLatestVersion;
var Stream : TMemoryStream;
    tmp    : Integer;
    tmpPath: TPathName;
begin { retrieve the latest executable version of TeeChartOffice }
  Stream:=TeeDownloadFile(FZIPURL,TeeMsg_CannotGetNewVersion);
  try
    if Stream.Size>100000 then
    begin
      { create a temporary filename }
      FTemp:=FZIPURL;
      tmp:=LastDelimiter('/',FTemp);
      if tmp>0 then Delete(FTemp,1,tmp);

      GetTempPath(MAX_PATH,tmpPath);
      FTemp:=String(tmpPath)+'\'+FTemp;

      { save file to disk }
      Stream.SaveToFile(FTemp);

      { notify user }
      LabelMessage.Font.Color:=clRed;
      LabelMessage.Caption:=TeeMsg_VersionReceived;
    end
    else
       Raise ChartException.Create(TeeMsg_WrongZip);
  finally
    Stream.Free;
  end;
end;

function TUpdateVersion.HasLatestVersion: Boolean;

  Function TeeStrToFloat(Const S:String):Double;
  var Old: Char;
  begin { convert a string with "." as decimal separator, to double }
    Old:={$IFDEF D15}FormatSettings.{$ENDIF}DecimalSeparator;
    {$IFDEF D15}FormatSettings.{$ENDIF}DecimalSeparator:='.';
    try
      result:=StrToFloat(S);
    finally
      {$IFDEF D15}FormatSettings.{$ENDIF}DecimalSeparator:=Old;
    end;
  end;

var tmpVersion : Double;
    tmpLatest  : Double;
    tmpS       : String;
begin { returns True if this version is the latest available }

  { current version }
  tmpS:=LabelVersion.Caption;
  While Pos(' ',tmpS)>0 do Delete(tmpS,1,Pos(' ',tmpS));
  tmpVersion:=TeeStrToFloat(tmpS);

  { latest version at Steema.com }
  tmpS:=LabelLatest.Caption;
  if Pos(' ',tmpS)>0 then Delete(tmpS,Pos(' ',tmpS),Length(tmpS));
  tmpLatest:=TeeStrToFloat(tmpS);

  { compare versions }
  result:=tmpVersion>=tmpLatest;
end;

procedure TUpdateVersion.FormShow(Sender: TObject);
begin
  { Translate }
  TeeTranslateControl(Self);
end;

end.
