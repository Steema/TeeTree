{**********************************************}
{   TeeTree Office - Constant strings          }
{   Copyright (c) 2001-2025 by Steema Software }
{   All Rights Reserved.                       }
{**********************************************}
unit TreeOfficeConstants;
{$I TeeDefs.inc}

interface

Uses TeeOfficeConstants;

Const
  { DO NOT TRANSLATE ! }
  TeeTreeOfficeKey           = '\Software\Steema Software\TeeTree Office';
  TeeTreeOfficeVersion       = 'TeeTree Office 2.0';
  TeeMsg_TeeTreeOffice       = 'TeeTree Office';
  TeeSteemaMainURL           = TeeChartWeb+'products/TeeTree';
  TeeSteemaSupportURL        = TeeChartWeb+'support/TeeTree';
  TTreeOfficeVersionURL      = TeeChartServer+'TeeTreeOffice/version.txt';
  TeeSteemaWebGallerySite    = TeeChartWeb+'products/TeeTreeOffice/WebGallery';
  TeeMsg_URLMagic            = 'TEETREEOFFICE';

var
  TeeMsg_SureToUploadTree,
  TeeMsg_ShouldClose,
  TeeMsg_OpenWithTeeTreeOffice : String;

Procedure TreeOfficeEnglish;
Procedure TreeOfficeSpanish;
Procedure TreeOfficeCatalan;
Procedure TreeOfficeGerman;
Procedure TreeOfficeFrench;
Procedure TreeOfficeBrazil;
Procedure TreeOfficeDanish;
Procedure TreeOfficeDutch;
Procedure TreeOfficeSwedish;
Procedure TreeOfficeChinese;
Procedure TreeOfficeChineseSimp;
Procedure TreeOfficePortuguese;
Procedure TreeOfficeRussian;
Procedure TreeOfficeItalian;
Procedure TreeOfficeNorwegian;
Procedure TreeOfficeJapanese;
Procedure TreeOfficePolish;
Procedure TreeOfficeSlovene;
Procedure TreeOfficeTurkish;
Procedure TreeOfficeHungarian;
Procedure TreeOfficeGalician;

implementation

Uses TreeConst, TeeConst, SysUtils;

Procedure TreeOfficeSpanish;
begin
  TeeMsg_SureToUploadTree   :='�Seguro que desea subir el diagrama a la Galeria Web?';
  TeeMsg_OpenWithTeeTreeOffice :='Abrir con &TeeTree Office';
  TeeMsg_ShouldClose        :='Por favor cierre y rearranque TeeTree Office.';

  TeeOfficeSpanish;
  TreeSetSpanish;
end;

Procedure TreeOfficeCatalan;
begin
  TeeMsg_SureToUploadTree   :='�Segur que vols pujar el Tree a la galeria Web?';
  TeeMsg_OpenWithTeeTreeOffice :='Obrir amb &TeeTree Office';
  TeeMsg_ShouldClose        :='Si us plau tanqui i tornir a arrencar TeeTree Office.';

  TeeOfficeCatalan;
  TreeSetCatalan;
end;

Procedure SetEnglishConstants;
begin
  TeeMsg_SureToUploadTree   :='Are you sure to upload the current Tree to Web Gallery?';
  TeeMsg_OpenWithTeeTreeOffice :='Open with &TeeTree Office';
  TeeMsg_ShouldClose        :='Please close and restart TeeTree Office.';
end;

Procedure TreeOfficeEnglish;
begin
  TeeOfficeEnglish;
  SetEnglishConstants;
  TreeSetEnglishConstants;
end;

Procedure TreeOfficeGerman;
begin
  TeeMsg_SureToUploadTree   :='Sind Sie sicher, den aktuellen Tree zur Web Galerie zu speichern?';
  TeeMsg_OpenWithTeeTreeOffice :='�ffnen mit &TeeTree Office';
  TeeMsg_ShouldClose        :='Bitte schlie�en und starten Sie TeeTree Office neu.';

  TeeOfficeGerman;
  TreeSetGerman;
end;

Procedure TreeOfficeFrench;
begin
  TeeMsg_SureToUploadTree :='�tes-vous s�r de vouloir envoyer l''arbre actuel vers la galerie Web ?';
  TeeMsg_OpenWithTeeTreeOffice :='Ouvrir avec &TeeTree Office';
  TeeMsg_ShouldClose :='Fermez et red�marrez TeeTree Office.'; 

  TeeOfficeFrench;
  TreeSetFrench;
end;

Procedure TreeOfficeBrazil;
begin
  TeeMsg_SureToUploadTree   :='Are you sure to upload the current Tree to Web Gallery?';
  TeeMsg_OpenWithTeeTreeOffice :='Open with &TeeTree Office';
  TeeMsg_ShouldClose        :='Please close and restart TeeTree Office.';

  TeeOfficeBrazil;
  TreeSetBrazil;
end;

Procedure TreeOfficeDanish;
begin
  TeeMsg_SureToUploadTree   :='Are you sure to upload the current Tree to Web Gallery?';
  TeeMsg_OpenWithTeeTreeOffice :='Open with &TeeTree Office';
  TeeMsg_ShouldClose        :='Please close and restart TeeTree Office.';

  TeeOfficeDanish;
  TreeSetDanish;
end;

Procedure TreeOfficeDutch;
begin
  TeeMsg_SureToUploadTree   :='Are you sure to upload the current Tree to Web Gallery?';
  TeeMsg_OpenWithTeeTreeOffice:='Open with &TeeTree Office';
  TeeMsg_ShouldClose        :='Please close and restart TeeTree Office.';

  TeeOfficeDutch;
  TreeSetDanish;
end;

Procedure TreeOfficeSwedish;
begin
  TeeMsg_SureToUploadTree   :='�r du s�ker p� att du vill ladda upp aktuellt tr�d till Web galleriet?';
  TeeMsg_OpenWithTeeTreeOffice :='�ppna med &TeeTree Office';
  TeeMsg_ShouldClose        :='St�ng och starta om TeeTree Office.';

  TeeOfficeSwedish;
  TreeSetSwedish;
end;

Procedure TreeOfficeChinese;
begin
  TeeMsg_SureToUploadTree   :='Are you sure to upload the current Tree to Web Gallery?';
  TeeMsg_OpenWithTeeTreeOffice:='Open with &TeeTree Office';
  TeeMsg_ShouldClose        :='Please close and restart TeeTree Office.';

  TeeOfficeChinese;
  TreeSetChinese;
end;

Procedure TreeOfficeChineseSimp;
begin
  TeeMsg_SureToUploadTree   :='Are you sure to upload the current Tree to Web Gallery?';
  TeeMsg_OpenWithTeeTreeOffice:='Open with &TeeTree Office';
  TeeMsg_ShouldClose        :='Please close and restart TeeTree Office.';

  TeeOfficeChineseSimp;
  TreeSetChineseSimp;
end;

Procedure TreeOfficePortuguese;
begin
  TeeMsg_SureToUploadTree   :='Are you sure to upload the current Tree to Web Gallery?';
  TeeMsg_OpenWithTeeTreeOffice:='Open with &TeeTree Office';
  TeeMsg_ShouldClose        :='Please close and restart TeeTree Office.';

  TeeOfficePortuguese;
  TreeSetPortuguese;
end;

Procedure TreeOfficeRussian;
begin
  TeeMsg_SureToUploadTree   :='Are you sure to upload the current Tree to Web Gallery?';
  TeeMsg_OpenWithTeeTreeOffice:='Open with &TeeTree Office';
  TeeMsg_ShouldClose        :='Please close and restart TeeTree Office.';

  TeeOfficeRussian;
  TreeSetRussian;
end;

Procedure TreeOfficeItalian;
begin
  TeeMsg_SureToUploadTree   :='Are you sure to upload the current Tree to Web Gallery?';
  TeeMsg_OpenWithTeeTreeOffice:='Open with &TeeTree Office';
  TeeMsg_ShouldClose        :='Please close and restart TeeTree Office.';

  TeeOfficeItalian;
  TreeSetItalian;
end;

Procedure TreeOfficeNorwegian;
begin
  TeeMsg_SureToUploadTree   :='Are you sure to upload the current Tree to Web Gallery?';
  TeeMsg_OpenWithTeeTreeOffice:='Open with &TeeTree Office';
  TeeMsg_ShouldClose        :='Please close and restart TeeTree Office.';

  TeeOfficeNorwegian;
  TreeSetNorwegian;
end;

Procedure TreeOfficeJapanese;
begin
  TeeMsg_SureToUploadTree   :='Are you sure to upload the current Tree to Web Gallery?';
  TeeMsg_OpenWithTeeTreeOffice:='Open with &TeeTree Office';
  TeeMsg_ShouldClose        :='Please close and restart TeeTree Office.';

  TeeOfficeJapanese;
  TreeSetJapanese;
end;

Procedure TreeOfficePolish;
begin
  TeeMsg_SureToUploadTree   :='Na pewno chcesz wys�a� aktualne drzewko do galerii sieciowej?';
  TeeMsg_OpenWithTeeTreeOffice :='Otw�rz z Biurem &TeeTree';
  TeeMsg_ShouldClose        :='Zamknij i uruchom ponownie Biuro TeeTree.';

  TeeOfficePolish;
  TreeSetPolish;
end;

Procedure TreeOfficeSlovene;
begin
  TeeMsg_SureToUploadTree   :='Are you sure to upload the current Tree to Web Gallery?';
  TeeMsg_OpenWithTeeTreeOffice:='Open with &TeeTree Office';
  TeeMsg_ShouldClose        :='Please close and restart TeeTree Office.';

  TeeOfficeSlovene;
  TreeSetSlovene;
end;

Procedure TreeOfficeTurkish;
begin
  TeeMsg_SureToUploadTree   :='Are you sure to upload the current Tree to Web Gallery?';
  TeeMsg_OpenWithTeeTreeOffice:='Open with &TeeTree Office';
  TeeMsg_ShouldClose        :='Please close and restart TeeTree Office.';

  TeeOfficeTurkish;
  TreeSetTurkish;
end;

Procedure TreeOfficeHungarian;
begin
  TeeMsg_SureToUploadTree   :='Are you sure to upload the current Tree to Web Gallery?';
  TeeMsg_OpenWithTeeTreeOffice:='Open with &TeeTree Office';
  TeeMsg_ShouldClose        :='Please close and restart TeeTree Office.';

  TeeOfficeHungarian;
  TreeSetHungarian;
end;

Procedure TreeOfficeGalician;
begin
  TeeMsg_SureToUploadTree   :='�Seguro que desea subir el diagrama a la Galeria Web?';
  TeeMsg_OpenWithTeeTreeOffice :='Abrir con &TeeTree Office';
  TeeMsg_ShouldClose        :='Por favor cierre y rearranque TeeTree Office.';

  TeeOfficeGalician;
  TreeSetGalician;
end;

initialization
  SetEnglishConstants;
end.
