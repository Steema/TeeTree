unit TreeExport;
{$I TeeDefs.inc}

interface

uses
  {$IFNDEF LINUX}
  Windows, Messages,
  {$ENDIF}
  SysUtils, Classes,
  Graphics, Controls, Forms, Dialogs, StdCtrls, ComCtrls, ExtCtrls, Buttons,

  TeeExport, TeeTree, TeCanvas, TeeProcs;

type
  TTreeExportForm = class(TTeeExportFormBase)
    CBFullSize: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure CBFullSizeClick(Sender: TObject);
  private
    { Private declarations }
  protected
    Function CreateData:TTeeExportData; override;
    Function ExistData:Boolean; override;
  public
    { Public declarations }
    class function ModalShow(const AOwner:TComponent; const ATree:TCustomTree):Boolean;
  end;

   TTreeData=class(TTeeExportData)
   private
     FTree : TCustomTree;
   protected
     Procedure WriteNode(ANode:TTreeNodeShape; AStream:TStream); virtual; abstract;
     Procedure WriteText(const AStr:String; const AStream:TStream);

     Function GetHeader: String; virtual;
     Function GetFooter: String; virtual;
   public
     Constructor Create(ATree:TCustomTree); virtual;

     Procedure SaveToStream(AStream:TStream); override;
     Function AsString:String; override;

     property Tree:TCustomTree read FTree write FTree;
   end;

   TTreeDataText=class(TTreeData)
   private
     FTextDelimiter : Char;
     FTextQuotes    : String;
   protected
     Procedure WriteNode(ANode:TTreeNodeShape; AStream:TStream); override;
   public
     Constructor Create(ATree:TCustomTree); override;
   published
     property TextDelimiter:Char read FTextDelimiter write FTextDelimiter default TeeTabDelimiter;
     property TextQuotes:String read FTextQuotes write FTextQuotes;
   end;

   TTreeDataXML=class(TTreeData)
   private
     FCompact  : Boolean;
     FEncoding : String;
   protected
     Procedure WriteNode(ANode:TTreeNodeShape; AStream:TStream); override;
     Function GetHeader: String; override;
     Function GetFooter: String; override;
   public
     Constructor Create(ATree:TCustomTree); override;

     property Compact:Boolean read FCompact write FCompact default False;
     property Encoding:String read FEncoding write FEncoding;
   end;

   TTreeDataHTML=class(TTreeData)
   protected
     Procedure WriteNode(ANode:TTreeNodeShape; AStream:TStream); override;
     Function GetHeader: String; override;
     Function GetFooter: String; override;
   end;

   TTreeDataXLS=class(TTreeData)
   private
     Buf : Array[0..4] of Word;
     Row : Integer;
     Col : Integer;

     Procedure WriteBuf(AStream:TStream; Value,Size:Word);
   protected
     Procedure WriteNode(ANode:TTreeNodeShape; AStream:TStream); override;
   public
     Procedure SaveToStream(AStream:TStream); override;
   end;

   TTreeDataJSON=class(TTreeData)
   protected
     Procedure WriteNode(ANode:TTreeNodeShape; AStream:TStream); override;
     Function GetHeader: String; override;
     Function GetFooter: String; override;
   end;

implementation

{$IFNDEF LCL}
{$R *.DFM}
{$ELSE}
{$R *.lfm}
{$ENDIF}

Function TTreeExportForm.CreateData:TTeeExportData;

  function Tree: TCustomTree;
  begin
    result:=TCustomTree(ExportPanel);
  end;

begin
  Case RGText.ItemIndex of
    0: begin
         result:=TTreeDataText.Create(Tree);

         TTreeDataText(result).TextDelimiter:=GetSeparator;
         TTreeDataText(result).TextQuotes:=EQuotes.Text;

         {$IFDEF D12}
         TTreeDataText(result).FileEncoding:=SelectedEncoding; // 9.0
         {$ENDIF}
       end;

    1: begin
         result:=TTreeDataXML.Create(Tree);

         TTreeDataXML(result).Encoding:=CBXMLEncoding.Text;

         {$IFDEF D12}
         TTreeDataXML(result).FileEncoding:=SelectedEncoding; // 9.0
         {$ENDIF}
       end;

    2: result:=TTreeDataHTML.Create(Tree);
    3: result:=TTreeDataXLS.Create(Tree);
  else
    result:=TTreeDataJSON.Create(Tree);
  end;
end;

function TTreeExportForm.ExistData: Boolean;
begin
  result:=(ExportPanel is TCustomTree) and
          (TCustomTree(ExportPanel).Shapes.Count>0);
end;

procedure TTreeExportForm.FormShow(Sender: TObject);
begin
  inherited;

  TabData.TabVisible:=True;
  TabInclude.TabVisible:=False;

  CBFullSizeClick(Sender);
end;

class function TTreeExportForm.ModalShow(const AOwner:TComponent; const ATree:TCustomTree):Boolean;
begin
  with TTreeExportForm.Create(AOwner) do
  try
    ExportPanel:=ATree;

    result:=ShowModal=mrOk;
  finally
    Free;
  end;
end;

{ TTreeData }

function TTreeData.AsString: String;
var StrStream : TStringStream;
begin
  StrStream:=TStringStream.Create('');
  try
    SaveToStream(StrStream);
    result := StrStream.DataString;
  finally
    FreeAndNil(StrStream);
  end;
end;

Constructor TTreeData.Create(ATree: TCustomTree);
begin
  inherited Create;
  FTree:=ATree;
end;

Function TTreeData.GetHeader: String;
begin
  result:='';
end;

Function TTreeData.GetFooter: String;
begin
  result:='';
end;

Procedure TTreeData.SaveToStream(AStream:TStream);
var t: integer;
begin
  WriteText(GetHeader, AStream);

  for t:=0 to Tree.Roots.Count-1 do
      WriteNode(Tree.Roots[t], AStream);

  WriteText(GetFooter, AStream);
end;

procedure TTreeData.WriteText(const AStr: String; const AStream:TStream);
begin
  AStream.Write(Pointer(AStr)^,Length(AStr)*SizeOf(char));
end;

{ TTreeDataText }

Constructor TTreeDataText.Create(ATree: TCustomTree);
begin
  inherited;
  FTextDelimiter:=TeeTabDelimiter;
end;

procedure TTreeDataText.WriteNode(ANode: TTreeNodeShape; AStream: TStream);
var t: integer;
    tmpText: String;
begin
  if ANode <> ANode.Tree.Roots[0] then
     WriteText(TeeTextLineSeparator, AStream);

  // Delimiters

  tmpText:='';

  for t:=1 to ANode.Level do
      tmpText:=tmpText+FTextDelimiter;

  // Node Text

  tmpText:=tmpText+TextQuotes+ANode.SimpleText;

  for t:=1 to ANode.Text.Count-1 do
      tmpText:=tmpText+' '+ANode.Text[t];

  tmpText:=tmpText+TextQuotes;

  WriteText(tmpText, AStream);

  // Node Childs

  for t:=0 to ANode.Children.Count-1 do
      WriteNode(ANode.Children[t], AStream);
end;

{ TTreeDataXML }

Constructor TTreeDataXML.Create(ATree:TCustomTree);
begin
  inherited;
  FCompact:=False;
end;

Function TTreeDataXML.GetHeader: String;
var tmp : String;
begin
  tmp:=Encoding;

  if tmp='' then
     tmp:=TeeDefaultXMLEncoding;

  result:=TeeXMLHeader(tmp);

  if not FCompact then
     result := result+TeeTextLineSeparator;

  result:=result+'<tree>';

  if not FCompact then
     result := result+TeeTextLineSeparator;
end;

Function TTreeDataXML.GetFooter: String;
begin
  result:='</tree>';
end;

procedure TTreeDataXML.WriteNode(ANode: TTreeNodeShape; AStream:TStream);
var
  t : Integer;
  tmpTab: String;
begin
  if not FCompact then
  begin
    tmpTab := '';

    for t:=1 to ANode.Level do
        tmpTab:=tmpTab+TeeTabDelimiter;

    WriteText(tmpTab, AStream);
  end;

  WriteText(
    '<node name="'+ANode.Name+'" class="'+ ANode.ClassName+'">'+Trim(ANode.Text.Text)
    , AStream
  );

  if ANode.HasChildren then
  begin
     if not FCompact then
        WriteText(TeeTextLineSeparator, AStream);

     for t:=0 to ANode.Children.Count-1 do
         WriteNode(ANode.Children[t], AStream);

    if not FCompact then
       WriteText(tmpTab, AStream);
  end;

  WriteText('</node>', AStream);

  if not FCompact then
     WriteText(TeeTextLineSeparator, AStream);
end;

{ TTreeDataHTML }

Function TTreeDataHTML.GetHeader: String;
begin
  result:='<table border="1">'+TeeTextLineSeparator;
end;

Function TTreeDataHTML.GetFooter: String;
begin
  result := TeeTextLineSeparator+'</table>';
end;

procedure TTreeDataHTML.WriteNode(ANode: TTreeNodeShape; AStream: TStream);
var t : Integer;
    tmpText: String;
begin
  if ANode <> ANode.Tree.Roots[0] then
     WriteText(TeeTextLineSeparator, AStream);

  tmpText:='<tr>';

  for t:=1 to ANode.Level do
      tmpText:=tmpText+'<td></td>';

  tmpText:=tmpText+'<td>'+ANode.SimpleText;

  for t:=1 to ANode.Text.Count-1 do
      tmpText:=tmpText+' '+ANode.Text[t];

  tmpText:=tmpText+'</td></tr>';

  WriteText(tmpText, AStream);

  for t:=0 to ANode.Children.Count-1 do
      WriteNode(ANode.Children[t], AStream);
end;

{ TTreeDataXLS }

Procedure TTreeDataXLS.WriteBuf(AStream:TStream; Value,Size:Word);
begin
  Buf[0]:=Value;
  Buf[1]:=Size;
  AStream.Write(Buf,2*SizeOf(Word));
end;

procedure TTreeDataXLS.WriteNode(ANode:TTreeNodeShape; AStream:TStream);
Const Attr:Array[0..2] of Byte=(0,0,0);

  Procedure WriteParams(Value,Size:Word);
  begin
    WriteBuf(AStream,Value,Size+2*SizeOf(Word)+SizeOf(Attr));
    AStream.Write(Attr,SizeOf(Attr));
  end;

  procedure WriteDouble(Const Value:Double);
  begin
    WriteParams(3,SizeOf(Double));
    AStream.WriteBuffer(Value,SizeOf(Double));
  end;

  {$IFDEF D12}
  {$DEFINE D12Win32}
  {$ENDIF}

  {$IFDEF D12Win32}

  procedure WriteText(Const Value:String);
  var tmpAnsi : ShortString;
  begin
    tmpAnsi:=ShortString(Value);
    WriteParams(4,Length(tmpAnsi)+1);
    AStream.Write(tmpAnsi,Length(tmpAnsi)+1);
  end;

  {$ELSE}

  procedure WriteText(Const Value:ShortString);
  begin
    WriteParams(4,Length(Value)+1);
    AStream.Write(Value,Length(Value)+1)
  end;

  {$ENDIF}

  procedure WriteNull;
  begin
    WriteParams(1,0);
  end;

var t : Integer;
    s : String;
begin
  for t:=0 to ANode.Level-1 do
  begin
    Col:=t;
    WriteNull;
  end;

  Col:=ANode.Level;

  s:=ANode.SimpleText;
  for t:=1 to ANode.Text.Count-1 do
      s:=s+' '+ANode.Text[t];

  WriteText({$IFNDEF D12}ShortString{$ENDIF}(s));
  Inc(Row);

  for t:=0 to ANode.Children.Count-1 do
      WriteNode(ANode.Children[t],AStream);
end;

procedure TTreeDataXLS.SaveToStream(AStream: TStream);

  Function MaxLevel:Integer;
  var t   : Integer;
      tmp : Integer;
  begin
    result:=0;

    for t:=0 to Tree.Shapes.Count-1 do
    begin
      tmp:=Tree.Shapes[t].Level;

      if tmp>result then
         result:=tmp;
    end;
  end;

const
  BeginExcel : Array[0..5] of Word=($809,8,0,$10,0,0);
  EndExcel   : Array[0..1] of Word=($A,0);

var t : Integer;
begin
  AStream.WriteBuffer(BeginExcel,SizeOf(BeginExcel)); { begin and BIF v5 }

  WriteBuf(AStream,$0200,5*SizeOf(Word));  { row x col }

  Buf[0]:=0;
  Buf[2]:=0;
  Buf[3]:=MaxLevel+1; { columns }
  Buf[4]:=0;

  Buf[1]:=Tree.Shapes.Count; { rows }

  AStream.Write(Buf,5*SizeOf(Word));

  Row:=0;
  for t:=0 to Tree.Roots.Count-1 do
      WriteNode(Tree.Roots[t],AStream);

  AStream.WriteBuffer(EndExcel,SizeOf(EndExcel)); { end }
end;

procedure TTreeExportForm.CBFullSizeClick(Sender: TObject);
begin
  if Assigned(ExportPanel) then
  begin
    UDHeight.Position:=ExportPanel.GetRectangle.Bottom;
    UDWidth.Position:=ExportPanel.GetRectangle.Right;
  end;

  EnableControls(not CBFullSize.Checked, [UDHeight,UDWidth,EHeight,EWidth]);

  inherited;
end;

{ TTreeDataJSON }

function TTreeDataJSON.GetFooter: String;
begin
  result:=' ]'+TeeTextLineSeparator+'}';
end;

function TTreeDataJSON.GetHeader: String;
begin
  result:='{ "tree": ['+TeeTextLineSeparator;
end;

procedure TTreeDataJSON.WriteNode(ANode: TTreeNodeShape; AStream: TStream);
var t : Integer;
begin
  WriteText('  { "text": "'+ANode.SimpleText+'" ', AStream);

  if ANode.HasChildren then
  begin
    WriteText(', "items": ['+TeeTextLineSeparator, AStream);

    for t:=0 to ANode.Children.Count-1 do
        WriteNode(ANode.Children[t], AStream);

    WriteText('  ]'+TeeTextLineSeparator, AStream);
  end;

  WriteText('  }', AStream);

  if ANode.Parent=nil then
  begin
    if ANode.Tree.Roots.IndexOf(ANode)<ANode.Tree.Roots.Count-1 then
       WriteText(',', AStream)
  end
  else
    if ANode.BrotherIndex<ANode.Parent.Children.Count-1 then
       WriteText(',', AStream);

  WriteText(TeeTextLineSeparator, AStream);
end;

end.
