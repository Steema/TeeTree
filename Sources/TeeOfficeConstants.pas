{**********************************************}
{   TeeChart Office - Constant strings         }
{   Copyright (c) 2001-2025 by Steema Software }
{   All Rights Reserved.                       }
{**********************************************}
unit TeeOfficeConstants;
{$I TeeDefs.inc}

interface

Const
  { DO NOT TRANSLATE ! }
  TeeChartServer             = 'http://www.steema.net/';
  TeeChartWeb                = 'http://www.steema.com/';
  TeeSteemaGetPassword       = TeeChartServer+'scripts/TeeGetPassword.exe';
  TeeSteemaUploadGallery     = TeeChartServer+'scripts/teeupload.exe?login=%s&Password=%s&ID=%s';

var
  TeeMsg_ZoomInstructions,
  TeeMsg_ScrollInstructions,
  TeeMsg_DrawLineInstructions,

  TeeMsg_SureToDeleteDataSet,
  TeeMsg_Select,
  TeeMsg_EMail,
  TeeMsg_Open,
  TeeMsg_New,
  TeeMsg_ImportingWeb,
  TeeMsg_Annotation,
  TeeMsg_Modified,

  TeeMsg_Next,
  TeeMsg_OK,
  TeeMsg_Close,
  TeeMsg_Go,
  TeeMsg_Upload,

  TeeMsg_CannotGetVersion,

  TeeMsg_CannotGetNewVersion,

  TeeMsg_WrongVersion,
  TeeMsg_HasLatestVersion,
  TeeMsg_ClickToUpdateVersion,
  TeeMsg_UpdateButton,
  TeeMsg_WrongZip,
  TeeMsg_VersionReceived,

  TeeMsg_SelectFolder,
  TeeMsg_EmailNotValid,
  TeeMsg_NameNotValid,
  TeeMsg_WrongPassword,

  TeeMsg_WrongChartID,
  TeeMsg_CannotObtainPassword,
  TeeMsg_PasswordSent,
  TeeMsg_Congrats,

  TeeMsg_UploadingWeb,
  TeeMsg_Uploaded,

  TeeMsg_TitleEditor,
  TeeMsg_EnterValue,
  TeeMsg_PointWidth,
  TeeMsg_PointHeight,

  TeeMsg_Position,
  TeeMsg_Size,

  TeeMsg_BetaWarning,

  TeeMsg_Caps,
  TeeMsg_Num,
  TeeMsg_SCR,

  TeeMsg_SaveAs,

  TeeMsg_ShouldClose,
   
  TeeMsg_Table,
  TeeMsg_Query             : String;

Procedure TeeOfficeEnglish;

Procedure TeeOfficeSpanish;
Procedure TeeOfficeCatalan;
Procedure TeeOfficeGalician;
Procedure TeeOfficeGerman;
Procedure TeeOfficeFrench;
Procedure TeeOfficeBrazil;
Procedure TeeOfficeDanish;
Procedure TeeOfficeDutch;
Procedure TeeOfficeSwedish;
Procedure TeeOfficeChinese;
Procedure TeeOfficeChineseSimp;
Procedure TeeOfficePortuguese;
Procedure TeeOfficeRussian;
Procedure TeeOfficeItalian;
Procedure TeeOfficeNorwegian;
Procedure TeeOfficeJapanese;
Procedure TeeOfficePolish;
Procedure TeeOfficeSlovene;
Procedure TeeOfficeTurkish;
Procedure TeeOfficeHungarian;

implementation

Uses TeeSpanish, TeeCatalan, TeeGerman, TeeFrench, TeeDanish, TeeDutch,
     TeeChinese, TeeBrazil, TeeSwedish, TeeChineseSimp, TeePortuguese,
     TeeRussian, TeeItalian, TeeNorwegian, TeeJapanese, TeePolish,
     TeeSlovene, TeeTurkish, TeeHungarian, TeeGalician,
     TeeConst, TeeProCo, SysUtils;

Procedure SetEnglishConstants;
begin
  TeeMsg_ZoomInstructions    :='Drag mouse to right-bottom to zoom. To left-top to unzoom.';
  TeeMsg_ScrollInstructions  :='Drag mouse to scroll Chart contents.';
  TeeMsg_DrawLineInstructions:='Drag mouse to draw, select and move lines.';

  TeeMsg_SureToDeleteDataSet :='Are you sure to delete DataSet?';
  TeeMsg_Select              :='Select';
  TeeMsg_EMail               :='e-mail';
  TeeMsg_Open                :='Open';
  TeeMsg_New                 :='New';
  TeeMsg_ImportingWeb        :='Importing from Web: %s';
  TeeMsg_Annotation          :='Annotation';
  TeeMsg_Modified            :='Modified';

  TeeMsg_Next                :='&Next >';
  TeeMsg_OK                  :='OK';
  TeeMsg_Close               :='Close';
  TeeMsg_Go                  :='&Go !';
  TeeMsg_Upload              :='&Upload !';

  TeeMsg_CannotGetVersion    :='Cannot connect to obtain current version.'+#13+
                              'Error: %d %s';

  TeeMsg_CannotGetNewVersion :='Cannot download current version.'+#13+
                              'Error: %d %s';

  TeeMsg_WrongVersion        :='Wrong version number received.';
  TeeMsg_HasLatestVersion    :='You already have the latest version.';
  TeeMsg_ClickToUpdateVersion:='Click the Update button to receive the latest version.';
  TeeMsg_UpdateButton        :='&Update...';
  TeeMsg_WrongZip            :='Wrong version file received.';
  TeeMsg_VersionReceived     :='Latest version received. Click Ok to Install.';

  TeeMsg_SelectFolder        :='Select Folder';
  TeeMsg_EmailNotValid       :='Email address is not correct.';
  TeeMsg_NameNotValid        :='Your Name is empty. Please type your name.';
  TeeMsg_WrongPassword       :='Password is empty. Please type your password or '+#13+
                              'click the Obtain Password button to receive it by e-mail.';
  TeeMsg_WrongChartID        :='Chart name is empty. Please type a Chart name to '+
                              'identify it at the Web Gallery database.';

  TeeMsg_CannotObtainPassword:='Cannot connect to obtain your Password.';
  TeeMsg_PasswordSent        :='Your Password has been sent to your email address.';
  TeeMsg_Congrats            :='Congratulations.'+#13+'You have been included in TeeChart Office '+
                              'Web Charts Gallery user database.'+#13+
                              TeeMsg_PasswordSent;

  TeeMsg_UploadingWeb        :='Uploading %s to Web Gallery...';
  TeeMsg_Uploaded            :='%s has been uploaded to Web Gallery.';

  TeeMsg_TitleEditor         :='Title Editor';
  TeeMsg_EnterValue          :='Enter value';
  TeeMsg_PointWidth          :='Width';
  TeeMsg_PointHeight         :='Height';

  TeeMsg_Position            :='Position: %d,%d';
  TeeMsg_Size                :='Size: %d x %d';

  TeeMsg_BetaWarning         :='Note: '+
                              'This is Pre-Release Software.'+#13+#13+
                              'Some features might be incomplete or'+#13+
                              'removed in the final product version.'+#13+#13+
                              'Submit problems and suggestions at our web site:'+#13+#13+
                              'www.steema.com';

  TeeMsg_Caps               :='CAPS';
  TeeMsg_Num                :='NUM';
  TeeMsg_SCR                :='SCR';
  TeeMsg_SaveAs             :='Save as...';
  TeeMsg_ShouldClose        :='Please close and restart the application.';
  TeeMsg_Table              :='Table';
  TeeMsg_Query              :='Query';
end;

Procedure TeeOfficeEnglish;
begin
  SetEnglishConstants;
  TeeSetEnglish;
end;

Procedure TeeOfficeSpanish;

Procedure SetSpanishConstants;
begin
  TeeMsg_ZoomInstructions    :='Arrastrar rat�n derecha-abajo para zoom. Izquierda-arriba para quitar zoom.';
  TeeMsg_ScrollInstructions  :='Arrastrar rat�n para desplazar el contenido del gr�fico.';
  TeeMsg_DrawLineInstructions:='Arrastrar rat�n para dibujar, seleccionar y mover lineas.';

  TeeMsg_SureToDeleteDataSet :='�Seguro que desea eliminar la Tabla?';
  TeeMsg_Select              :='Selecciona';
  TeeMsg_EMail               :='e-mail';
  TeeMsg_Open                :='Abrir';
  TeeMsg_New                 :='Nuevo';
  TeeMsg_ImportingWeb        :='Importando del Web: %s';
  TeeMsg_Annotation          :='Anotaci�n';
  TeeMsg_Modified            :='Modific.';

  TeeMsg_Next                :='&Siguiente >';
  TeeMsg_OK                  :='Aceptar';
  TeeMsg_Close               :='Cerrar';
  TeeMsg_Go                  :='&Ir !';
  TeeMsg_Upload              :='&Subir !';

  TeeMsg_CannotGetVersion    :='No se puede obtener la versi�n m�s actual.'+#13+
                              'Error: %d %s';

  TeeMsg_CannotGetNewVersion :='No se puede descargar la versi�n m�s actual.'+#13+
                              'Error: %d %s';

  TeeMsg_WrongVersion        :='N�mero de versi�n recibido err�neo.';
  TeeMsg_HasLatestVersion    :='Ya tiene la �ltima versi�n.';
  TeeMsg_ClickToUpdateVersion:='Pulse Actualizar para recibir la versi�n actualizada.';
  TeeMsg_UpdateButton        :='&Actualizar...';
  TeeMsg_WrongZip            :='Archivo de versi�n recibido incorrecto.';
  TeeMsg_VersionReceived     :='Ultima versi�n recibida. Pulse Aceptar para instalar.';

  TeeMsg_SelectFolder        :='Seleccionar Carpeta';
  TeeMsg_EmailNotValid       :='La direcci�n de Correo no es correcta.';
  TeeMsg_NameNotValid        :='Por favor escriba su Nombre.';
  TeeMsg_WrongPassword       :='La contrase�a est� vacia. Por favor escriba su contrase�a o '+#13+
                               'pulse el bot�n Obtener Contrase�a para recibirla por correo.';
  TeeMsg_WrongChartID        :='El nombre de gr�fico est� vacio. Por favor escriba un nombre de gr�fico para '+
                               'identificarlo en la Galeria Web.';

  TeeMsg_CannotObtainPassword:='No es posible conectar para obtener su contrase�a.';
  TeeMsg_PasswordSent        :='Se ha enviado la Contrase�a a su direcci�n de Correo.';
  TeeMsg_Congrats            :='Felicidades.'+#13+'Ha sido incluido el base de datos de usuarios de '+
                              'la galeria de gr�ficos Web.'+#13+
                              TeeMsg_PasswordSent;

  TeeMsg_UploadingWeb        :='Subiendo %s a la galeria Web...';
  TeeMsg_Uploaded       :='%s ha sido cargado en la galeria Web.';

  TeeMsg_TitleEditor         :='Editor de T�tulo';
  TeeMsg_EnterValue          :='Entrar valor';
  TeeMsg_PointWidth          :='Ancho';
  TeeMsg_PointHeight         :='Alto';

  TeeMsg_Position            :='Posici�n: %d,%d';
  TeeMsg_Size                :='Tama�o: %d x %d';

  TeeMsg_BetaWarning         :='Nota: '+
                              'Este Software es Pre-Release.'+#13+#13+
                              'Algunas funciones pueden ser incompletas o'+#13+
                              'eliminadas en la versi�n final del producto.'+#13+#13+
                              'Envienos preguntas y sugerencias en nuestro web:'+#13+#13+
                              'www.steema.com';

  TeeMsg_Caps               :='MAYU';
  TeeMsg_Num                :='NUM';
  TeeMsg_SCR                :='DES';
  TeeMsg_SaveAs             :='Guardar como...';
  TeeMsg_ShouldClose        :='Por favor cierre y rearranque la aplicaci�n.';
  TeeMsg_Table              :='Tabla';
  TeeMsg_Query              :='Consulta';
end;

begin
  SetSpanishConstants;
  TeeSetSpanish;

  if TeeSpanishLanguage.IndexOf('NEW USING WIZARD')=-1 then
  with TeeSpanishLanguage do
    Text:=Text+#13+
    'NEW USING WIZARD=Nuevo usando Asistente'#13+
    'OPEN=Abrir'+#13+
    'SAVE AS=Guardar como'#13+
    'SAVE AS...=Guardar como...'#13+
    'REOPEN=Reabrir'#13+
    'ABOUT=Acerca de'+#13+
    'PROPERTIES=Propiedades'+#13+
    'CHART TOOLS=Herramientas'+#13+
    'HELP INDEX=Indice de la Ayuda'+#13+
    'WHAT''S THIS ?=Qu� es esto?'+#13+
    'VIEW=Ver'+#13+
    'STATUS BAR=Barra de estado'+#13+
    'GALLERY=Galer�a'+#13+
    'TOOLBARS=Barras de Herramientas'#13+
    'PAGE=P�gina'#13+
    'AS TAB=Como tapeta'#13+
    'AS WINDOW=Como ventana'#13+
    'HIDE=Ocultar'#13+
    'UPDATE VERSION=Actualizar versi�n'#13+
    'TEXT MODE=Modo Texto'#13+
    'ONLINE SUPPORT=Soporte en l�nea'#13+
    'EXIT=Salir'#13+
    'SEND BY E-MAIL=Enviar por Correo'#13+
    'TEXT LABELS=Etiquetas'#13+
    'DUPLICATE=Duplicar'#13+
    'SELECT ALL=Seleccionar Todas'#13+
    'MOVE UP=Mover Arriba'#13+
    'MOVE DOWN=Mover Abajo'#13+
    'HIDE SERIES LIST=Ocultar Lista'#13+
    'VIEW 3D=Ver en 3D'#13+
    'AUTO SIZE=Tama�o Autom.'#13+
    'ADD ANNOTATION=A�adir Anotaci�n'#13+
    'ENABLE ZOOM=Permitir Zoom'#13+
    'ENABLE SCROLL=Permitir Desplazamiento'#13+
    'DRAW LINES=Dibujar Lineas'#13+
    'SHOW HINTS=Ver Ayudas'#13+
    'COLOR EACH POINT=Colorear puntos'#13+
    'PROPERTY=Propiedad'#13+
    'MODIFIED=Modific.'#13+
    'SIDE MARGINS=Margenes laterales'#13+
    'RIGHT SIDE=Lado derecho'#13+
    'ALIGN TO TOP=Alinear arriba'#13+
    'ALIGN TO BOTTOM=Alinear abajo'#13+
    'FONT COLOR=Color de Fuente'#13+
    'FONT NAME=Nombre de Fuente'#13+
    'FONT SIZE=Tama�o de Fuente'#13+
    'BOLD=Negrita'#13+
    'ITALIC=Cursiva'#13+
    'UNDERLINE=Subrayado'#13+
    'STRIKE OUT=Tachado'#13+
    'LEFT JUSTIFY=Ajustar a la Izquierda'#13+
    'RIGHT JUSTIFY=Ajustar a la Derecha'#13+
    'INTER-CHAR SIZE=Espacio entre caracteres'#13+
    'HIDE INSPECTOR=Ocultar Inspector'#13+
    'SELECT=Selecciona'#13+
    'CUSTOM POSITION=Posici�n cust.'#13+
    'CAPS=MAYU'#13+
    'NUM=NUM'#13+
    'SCR=DES'#13+
    'YES=S�'#13+
    'NO=No'#13+
    'CHECK-BOXES=Casillas'#13+
    'ANNOTATION=Anotaci�n'#13+
    'CONNECT TO STEEMA.COM TO UPDATE THIS SOFTWARE.=Conecte a Steema.com para actualizar su versi�n.'#13+
    'CURRENT VERSION=Versi�n actual'#13+
    'LATEST VERSION=Ultima versi�n'#13+
    'CONNECT=Conectar'#13+
    'UPDATE=Actualizar'#13+
    'HANDLES=L�piz'#13+
    'DRAG POINT=Arrastrar puntos'#13+
    'DRAG STYLE=Estilo arrastre'#13+
    'LANGUAGE=Lenguaje'#13+
    'RED=Rojo'#13+
    'GREEN=Verde'#13+
    'BLUE=Azul'#13+
    'WHITE=Blanco'#13+
    'YELLOW=Amarillo'#13+
    'BLACK=Negro'#13+
    'SILVER=Plata'#13+
    'DKGRAY=Gris oscuro'#13+
    'BTNFACE=Gris'#13+
    'GRAY SCALE VISUAL=Grises visual'#13+
    'INVERTED GRAY SCALE=Grises Invertidos'#13+
    'FORMATTING=Formato'#13+
    'FLOATING POINT=Decimal'#13+
    'DATE-TIME=Fecha / Hora'#13+
    'CHOOSE AN OPTION=Escoja una opci�n'#13+
    'IMPORTING FROM WEB: %S=Importando del web: %s'#13+
    'GO !=Ir !'#13+
    'UPLOAD !=Subir !'#13+
    'YOUR NAME=Su Nombre'#13+
    'YOUR E-MAIL=Su e-Mail'#13+
    'PASSWORD=Contrase�a'#13+
    'OBTAIN PASSWORD=Obtener Contrase�a'#13+
    'FIRST=Primera'#13+
    'PRIOR=Anterior'#13+
    'NEXT=Siguiente'#13+
    'LAST=Ultima'#13+
    'CREATE NEW DATASET=Crear nueva Tabla o Consulta'#13+
    'DATASET STYLE=Tipo de Base de Datos'#13+
    'SQL QUERY=Consulta SQL'#13+
    'FROM=Desde'#13+
    'TO=Hasta'#13+
    'STEP=Cada'#13+
    'VALUE=Valor'#13+
    'EXCEL FILE=Archivo Excel'#13+
    'WORKSHEET=Libro'#13+
    'VALUES RANGE=Rango Valores'#13+
    'LABELS RANGE=Rango Textos'#13+
    'FOCUS=Resaltar'#13+
    'EXPLODE=Expandir'#13+
    'AUTOSIZE=Tama�o Auto.'#13
    ;
end;

Procedure TeeOfficeGalician;

Procedure SetGalicianConstants;
begin
  TeeMsg_ZoomInstructions    :='Arrastrar rat�n derecha-abajo para zoom. Izquierda-arriba para quitar zoom.';
  TeeMsg_ScrollInstructions  :='Arrastrar rat�n para desplazar el contenido del gr�fico.';
  TeeMsg_DrawLineInstructions:='Arrastrar rat�n para dibujar, seleccionar y mover lineas.';

  TeeMsg_SureToDeleteDataSet :='�Seguro que desea eliminar la Tabla?';
  TeeMsg_Select              :='Selecciona';
  TeeMsg_EMail               :='e-mail';
  TeeMsg_Open                :='Abrir';
  TeeMsg_New                 :='Nuevo';
  TeeMsg_ImportingWeb        :='Importando del Web: %s';
  TeeMsg_Annotation          :='Anotaci�n';
  TeeMsg_Modified            :='Modific.';

  TeeMsg_Next                :='&Siguiente >';
  TeeMsg_OK                  :='Aceptar';
  TeeMsg_Close               :='Cerrar';
  TeeMsg_Go                  :='&Ir !';
  TeeMsg_Upload              :='&Subir !';

  TeeMsg_CannotGetVersion    :='No se puede obtener la versi�n m�s actual.'+#13+
                              'Error: %d %s';

  TeeMsg_CannotGetNewVersion :='No se puede descargar la versi�n m�s actual.'+#13+
                              'Error: %d %s';

  TeeMsg_WrongVersion        :='N�mero de versi�n recibido err�neo.';
  TeeMsg_HasLatestVersion    :='Ya tiene la �ltima versi�n.';
  TeeMsg_ClickToUpdateVersion:='Pulse Actualizar para recibir la versi�n actualizada.';
  TeeMsg_UpdateButton        :='&Actualizar...';
  TeeMsg_WrongZip            :='Archivo de versi�n recibido incorrecto.';
  TeeMsg_VersionReceived     :='Ultima versi�n recibida. Pulse Aceptar para instalar.';

  TeeMsg_SelectFolder        :='Seleccionar Carpeta';
  TeeMsg_EmailNotValid       :='La direcci�n de Correo no es correcta.';
  TeeMsg_NameNotValid        :='Por favor escriba su Nombre.';
  TeeMsg_WrongPassword       :='La contrase�a est� vacia. Por favor escriba su contrase�a o '+#13+
                               'pulse el bot�n Obtener Contrase�a para recibirla por correo.';
  TeeMsg_WrongChartID        :='El nombre de gr�fico est� vacio. Por favor escriba un nombre de gr�fico para '+
                               'identificarlo en la Galeria Web.';

  TeeMsg_CannotObtainPassword:='No es posible conectar para obtener su contrase�a.';
  TeeMsg_PasswordSent        :='Se ha enviado la Contrase�a a su direcci�n de Correo.';
  TeeMsg_Congrats            :='Felicidades.'+#13+'Ha sido incluido el base de datos de usuarios de '+
                              'la galeria de gr�ficos Web.'+#13+
                              TeeMsg_PasswordSent;

  TeeMsg_UploadingWeb        :='Subiendo %s a la galeria Web...';
  TeeMsg_Uploaded       :='%s ha sido cargado en la galeria Web.';

  TeeMsg_TitleEditor         :='Editor de T�tulo';
  TeeMsg_EnterValue          :='Entrar valor';
  TeeMsg_PointWidth          :='Ancho';
  TeeMsg_PointHeight         :='Alto';

  TeeMsg_Position            :='Posici�n: %d,%d';
  TeeMsg_Size                :='Tama�o: %d x %d';

  TeeMsg_BetaWarning         :='Nota: '+
                              'Este Software es Pre-Release.'+#13+#13+
                              'Algunas funciones pueden ser incompletas o'+#13+
                              'eliminadas en la versi�n final del producto.'+#13+#13+
                              'Envienos preguntas y sugerencias en nuestro web:'+#13+#13+
                              'www.steema.com';

  TeeMsg_Caps               :='MAYU';
  TeeMsg_Num                :='NUM';
  TeeMsg_SCR                :='DES';
  TeeMsg_SaveAs             :='Guardar como...';
  TeeMsg_ShouldClose        :='Por favor cierre y rearranque la aplicaci�n.';
  TeeMsg_Table              :='Tabla';
  TeeMsg_Query              :='Consulta';
end;

begin
  SetGalicianConstants;
  TeeSetGalician;

  if TeeGalicianLanguage.IndexOf('NEW USING WIZARD')=-1 then
  with TeeGalicianLanguage do
    Text:=Text+#13+
    'NEW USING WIZARD=Nuevo usando Asistente'#13+
    'OPEN=Abrir'+#13+
    'SAVE AS=Guardar como'#13+
    'SAVE AS...=Guardar como...'#13+
    'REOPEN=Reabrir'#13+
    'ABOUT=Acerca de'+#13+
    'PROPERTIES=Propiedades'+#13+
    'CHART TOOLS=Herramientas'+#13+
    'HELP INDEX=Indice de la Ayuda'+#13+
    'WHAT''S THIS ?=Qu� es esto?'+#13+
    'VIEW=Ver'+#13+
    'STATUS BAR=Barra de estado'+#13+
    'SERIES LIST=Lista de Series'#13+
    'GALLERY=Galer�a'+#13+
    'TOOLBARS=Barras de Herramientas'#13+
    'PAGE=P�gina'#13+
    'AS TAB=Como tapeta'#13+
    'AS WINDOW=Como ventana'#13+
    'HIDE=Ocultar'#13+
    'WEB CHARTS GALLERY=Galer�a de Gr�ficos en Web'#13+
    'UPDATE VERSION=Actualizar versi�n'#13+
    'TEXT MODE=Modo Texto'#13+
    'TEECHART WEB=Web de TeeChart'#13+
    'ONLINE SUPPORT=Soporte en l�nea'#13+
    'EXIT=Salir'#13+
    'SEND BY E-MAIL=Enviar por Correo'#13+
    'TEXT LABELS=Etiquetas'#13+
    'X VALUES=Valores X'#13+
    'DUPLICATE=Duplicar'#13+
    'SELECT ALL=Seleccionar Todas'#13+
    'MOVE UP=Mover Arriba'#13+
    'MOVE DOWN=Mover Abajo'#13+
    'HIDE SERIES LIST=Ocultar Lista'#13+
    'VIEW 3D=Ver en 3D'#13+
    'AUTO SIZE=Tama�o Autom.'#13+
    'ADD ANNOTATION=A�adir Anotaci�n'#13+
    'ENABLE ZOOM=Permitir Zoom'#13+
    'ENABLE SCROLL=Permitir Desplazamiento'#13+
    'DRAW LINES=Dibujar Lineas'#13+
    'SHOW HINTS=Ver Ayudas'#13+
    'COLOR EACH POINT=Colorear puntos'#13+
    'SHOW AT LEGEND=Ver en Leyenda'#13+
    'SHOW SERIES MARKS=Ver Marcas en puntos'#13+
    'PROPERTY=Propiedad'#13+
    'MODIFIED=Modific.'#13+
    'WALL=Pared'#13+
    'SERIES MARKS=Marcas de Series'#13+
    'SIDE MARGINS=Margenes laterales'#13+
    'RIGHT SIDE=Lado derecho'#13+
    'ALIGN TO TOP=Alinear arriba'#13+
    'ALIGN TO BOTTOM=Alinear abajo'#13+
    'FONT COLOR=Color de Fuente'#13+
    'FONT NAME=Nombre de Fuente'#13+
    'FONT SIZE=Tama�o de Fuente'#13+
    'BOLD=Negrita'#13+
    'ITALIC=Cursiva'#13+
    'UNDERLINE=Subrayado'#13+
    'STRIKE OUT=Tachado'#13+
    'LEFT JUSTIFY=Ajustar a la Izquierda'#13+
    'RIGHT JUSTIFY=Ajustar a la Derecha'#13+
    'INTER-CHAR SIZE=Espacio entre caracteres'#13+
    'HIDE INSPECTOR=Ocultar Inspector'#13+
    'SELECT=Selecciona'#13+
    'CUSTOM POSITION=Posici�n cust.'#13+
    'AXIS LINE=Linea de Eje'+#13+
    'MINOR GRID=Rejilla menor'#13+
    'CAPS=MAYU'#13+
    'NUM=NUM'#13+
    'SCR=DES'#13+
    'YES=S�'#13+
    'NO=No'#13+
    'CHECK-BOXES=Casillas'#13+
    'ANNOTATION=Anotaci�n'#13+
    'CONNECT TO STEEMA.COM TO UPDATE YOUR TEECHART OFFICE VERSION.=Conecte a Steema.com para actualizar su versi�n.'#13+
    'CURRENT VERSION=Versi�n actual'#13+
    'LATEST VERSION=Ultima versi�n'#13+
    'CONNECT=Conectar'#13+
    'UPDATE=Actualizar'#13+
    'HANDLES=L�piz'#13+
    'AXIS DIVIDER=Divisor de Ejes'#13+
    'DRAG POINT=Arrastrar puntos'#13+
    'PIE SLICES=Porciones de Pastel'#13+
    'DRAG STYLE=Estilo arrastre'#13+
    'TEECHART OFFICE OPTIONS=Opciones de TeeChart Office'#13+
    'LANGUAGE=Lenguaje'#13+
    'RED=Rojo'#13+
    'GREEN=Verde'#13+
    'BLUE=Azul'#13+
    'WHITE=Blanco'#13+
    'YELLOW=Amarillo'#13+
    'BLACK=Negro'#13+
    'SILVER=Plata'#13+
    'DKGRAY=Gris oscuro'#13+
    'BTNFACE=Gris'#13+
    'GRAY SCALE VISUAL=Grises visual'#13+
    'INVERTED GRAY SCALE=Grises Invertidos'#13+
    'LEFT WALL=Pared Izquierda'#13+
    'BOTTOM WALL=Pared Inferior'#13+
    'RIGHT WALL=Pared Derecha'#13+
    'BACK WALL=Pared Trasera'#13+
    'STAIRS INVERTED=Escalera Inv.'#13+
    'FORMATTING=Formato'#13+
    'FLOATING POINT=Decimal'#13+
    'DATE-TIME=Fecha / Hora'#13+
    'CHOOSE AN OPTION=Escoja una opci�n'#13+
    'IMPORTING FROM WEB: %S=Importando del web: %s'#13+
    'LOAD CHART FROM WEB ADDRESS=Cargar gr�fico de Web'#13+
    'BROWSE THE TEECHART GALLERY AT WWW.STEEMA.COM=Ver la Galer�a de Gr�ficos en www.Steema.com'#13+
    'GO !=Ir !'#13+
    'UPLOAD !=Subir !'#13+
    'UPLOAD CURRENT CHART TO WEB GALLERY=Subir su Gr�fico a la Galer�a en el Web'#13+
    'TEECHART OFFICE WEB GALLERY=Galer�a de Gr�ficos en el Web'#13+
    'YOUR NAME=Su Nombre'#13+
    'YOUR E-MAIL=Su e-Mail'#13+
    'PASSWORD=Contrase�a'#13+
    'OBTAIN PASSWORD=Obtener Contrase�a'#13+
    'CHART NAME=Nombre Gr�fico'#13+
    'FIRST=Primera'#13+
    'PRIOR=Anterior'#13+
    'NEXT=Siguiente'#13+
    'LAST=Ultima'#13+
    'CREATE NEW DATASET=Crear nueva Tabla o Consulta'#13+
    'DATASET STYLE=Tipo de Base de Datos'#13+
    'SQL QUERY=Consulta SQL'#13+
    'FROM=Desde'#13+
    'TO=Hasta'#13+
    'STEP=Cada'#13+
    'VALUE=Valor'#13+
    'EXCEL FILE=Archivo Excel'#13+
    'WORKSHEET=Libro'#13+
    'VALUES RANGE=Rango Valores'#13+
    'LABELS RANGE=Rango Textos'#13+
    'FOCUS=Resaltar'#13+
    'EXPLODE=Expandir'#13+
    'AUTOSIZE=Tama�o Auto.'#13+
    'AXIS 2=Eje 2'
    ;
end;

Procedure TeeOfficeCatalan;

Procedure SetCatalanConstants;
begin
  TeeMsg_ZoomInstructions    :='Drag mouse to right-bottom to zoom. To left-top to unzoom.';
  TeeMsg_ScrollInstructions  :='Drag mouse to scroll Chart contents.';
  TeeMsg_DrawLineInstructions:='Drag mouse to draw, select and move lines.';

  TeeMsg_SureToDeleteDataSet :='Are you sure to delete DataSet?';
  TeeMsg_Select              :='Selecciona';
  TeeMsg_EMail               :='e-mail';
  TeeMsg_Open                :='Obrir';
  TeeMsg_New                 :='Nou';
  TeeMsg_ImportingWeb        :='Important del Web: %s';
  TeeMsg_Annotation          :='Anotaci�';
  TeeMsg_Modified            :='Modificat';

  TeeMsg_Next                :='&Seguent >';
  TeeMsg_OK                  :='Aceptar';
  TeeMsg_Close               :='Tancar';
  TeeMsg_Go                  :='&Anar !';
  TeeMsg_Upload              :='&Pujar !';

  TeeMsg_CannotGetVersion    :='Cannot connect to obtain current version.'+#13+
                              'Error: %d %s';

  TeeMsg_CannotGetNewVersion :='Cannot download current version.'+#13+
                              'Error: %d %s';

  TeeMsg_WrongVersion        :='Wrong version number received.';
  TeeMsg_HasLatestVersion    :='Ja t� l''�ltima versi�.';
  TeeMsg_ClickToUpdateVersion:='Premi Actualitzar per rebre la versi� actualitzada.';
  TeeMsg_UpdateButton        :='&Actualitza...';
  TeeMsg_WrongZip            :='Wrong version file received.';
  TeeMsg_VersionReceived     :='Latest version received. Click Ok to Install.';

  TeeMsg_SelectFolder        :='Seleccionar carpeta';
  TeeMsg_EmailNotValid       :='L''adre�a de Correu no �s correcte.';
  TeeMsg_NameNotValid        :='Si us plau escrigui el seu Nom.';
  TeeMsg_WrongPassword       :='Password is empty. Please type your password or '+#13+
                               'click the Obtain Password button to receive it by e-mail.';
  TeeMsg_WrongChartID        :='Chart name is empty. Please type a Chart name to '+
                               'identify it at the Web Gallery database.';

  TeeMsg_CannotObtainPassword:='Cannot connect to obtain your Password.';
  TeeMsg_PasswordSent        :='La Clau s''ha enviat a la seva adre�a de Correu.';
  TeeMsg_Congrats            :='Congratulations.'+#13+'You have been included in TeeChart Office '+
                              'Web Charts Gallery user database.'+#13+
                              TeeMsg_PasswordSent;

  TeeMsg_UploadingWeb        :='Uploading %s to Web Gallery...';
  TeeMsg_Uploaded            :='%s has been uploaded to Web Gallery.';

  TeeMsg_TitleEditor         :='Editor de T�tol';
  TeeMsg_EnterValue          :='Entrar valor';
  TeeMsg_PointWidth          :='Ample';
  TeeMsg_PointHeight         :='Alt';

  TeeMsg_Position            :='Posici�: %d,%d';
  TeeMsg_Size                :='Tamany: %d x %d';

  TeeMsg_BetaWarning         :='Nota: '+
                              'This is Pre-Release Software.'+#13+#13+
                              'Some features might be incomplete or'+#13+
                              'removed in the final product version.'+#13+#13+
                              'Submit problems and suggestions at our web site:'+#13+#13+
                              'www.steema.com';

  TeeMsg_Caps               :='MAJU';
  TeeMsg_Num                :='NUM';
  TeeMsg_SCR                :='DES';
  TeeMsg_SaveAs             :='Guardar com...';

  TeeMsg_ShouldClose        :='Si us plau tanqui i tornir a arrencar el programari.';
  TeeMsg_Table              :='Taula';
  TeeMsg_Query              :='Consulta';
end;

begin
  SetCatalanConstants;
  TeeSetCatalan;

  if TeeLanguage.IndexOfName('NEW USING WIZARD')=-1 then
  with TeeCatalanLanguage do
    Text:=Text+#13+
    'NEW USING WIZARD=Nou amb Asistent'#13+
    'OPEN=Obrir'+#13+
    'SAVE AS=Guardar com'#13+
    'SAVE AS...=Guardar com...'#13+
    'REOPEN=Reobrir'#13+
    'ABOUT=A prop�sit de'+#13+
    'PROPERTIES=Propietats'+#13+
    'CHART TOOLS=Eines'+#13+
    'HELP INDEX=Index de l''Ajuda'+#13+
    'WHAT''S THIS ?=Qu� �s aix�?'+#13+
    'VIEW=Veure'+#13+
    'STATUS BAR=Barra d''estat'+#13+
    'SERIES LIST=Llista de Series'#13+
    'GALLERY=Galer�a'+#13+
    'TOOLBARS=Barres d''Eines'#13+
    'PAGE=P�gina'#13+
    'AS TAB=Com tapeta'#13+
    'AS WINDOW=Com finestre'#13+
    'HIDE=Ocultar'#13+
    'WEB CHARTS GALLERY=Galer�a de Gr�fics al Web'#13+
    'UPDATE VERSION=Actualitzar versi�'#13+
    'TEXT MODE=Modus Texte'#13+
    'TEECHART WEB=Web de TeeChart'#13+
    'ONLINE SUPPORT=Suport en l�nea'#13+
    'EXIT=Sortir'#13+
    'SEND BY E-MAIL=Enviar per Correu'#13+
    'TEXT LABELS=Etiquetes'#13+
    'X VALUES=Valors X'#13+
    'DUPLICATE=Duplicar'#13+
    'SELECT ALL=Seleccionar Totes'#13+
    'MOVE UP=Moure a dalt'#13+
    'MOVE DOWN=Moure a baix'#13+
    'HIDE SERIES LIST=Ocultar Llista'#13+
    'VIEW 3D=Veure en 3D'#13+
    'AUTO SIZE=Tamany Autom.'#13+
    'ADD ANNOTATION=Afegir Anotaci�'#13+
    'ENABLE ZOOM=Permetre Zoom'#13+
    'ENABLE SCROLL=Permetre Desplazament'#13+
    'DRAW LINES=Dibuixar Linees'#13+
    'SHOW HINTS=Veure Ajudes'#13+
    'COLOR EACH POINT=Colorejar punts'#13+
    'SHOW AT LEGEND=Veure a Legenda'#13+
    'SHOW SERIES MARKS=Veure Marques a punts'#13+
    'PROPERTY=Propietat'#13+
    'MODIFIED=Modificat'#13+
    'WALL=Paret'#13+
    'SERIES MARKS=Marques de Series'#13+
    'SIDE MARGINS=Marges laterals'#13+
    'RIGHT SIDE=Costat dret'#13+
    'ALIGN TO TOP=Alinear a dalt'#13+
    'ALIGN TO BOTTOM=Alinear a baix'#13+
    'FONT COLOR=Color de Font'#13+
    'FONT NAME=Nom de Font'#13+
    'FONT SIZE=Tamany de Font'#13+
    'BOLD=Negreta'#13+
    'ITALIC=Cursiva'#13+
    'UNDERLINE=Subrallat'#13+
    'STRIKE OUT=Taxat'#13+
    'LEFT JUSTIFY=Ajustar a la Esquerra'#13+
    'RIGHT JUSTIFY=Ajustar a la Dreta'#13+
    'INTER-CHAR SIZE=Espai entre caracters'#13+
    'HIDE INSPECTOR=Ocultar Inspector'#13+
    'SELECT=Selecciona'#13+
    'CUSTOM POSITION=Posici� person.'#13+
    'AXIS LINE=Linea d''Eix'+#13+
    'MINOR GRID=Rejilla menor'#13+
    'CAPS=MAJU'#13+
    'NUM=NUM'#13+
    'SCR=DES'#13+
    'YES=S�'#13+
    'NO=No'#13+
    'CHECK-BOXES=Casillas'#13+
    'ANNOTATION=Anotaci�'#13+
    'CONNECT TO STEEMA.COM TO UPDATE YOUR TEECHART OFFICE VERSION.=Conecti a Steema.com per actualitzar la versi�.'#13+
    'CURRENT VERSION=Versi� actual'#13+
    'LATEST VERSION=Ultima versi�'#13+
    'CONNECT=Conectar'#13+
    'UPDATE=Actualitzar'#13+
    'HANDLES=Ll�pis'#13+
    'AXIS DIVIDER=Divisor d''Eixos'#13+
    'DRAG POINT=Arrastrar punts'#13+
    'PIE SLICES=Porcions de Pastel'#13+
    'DRAG STYLE=Estil arrastre'#13+
    'TEECHART OFFICE OPTIONS=Opcions de TeeChart Office'#13+
    'LANGUAGE=Llenguatje'#13+
    'RED=Vermell'#13+
    'GREEN=Verd'#13+
    'BLUE=Blau'#13+
    'WHITE=Blanco'#13+
    'YELLOW=Groc'#13+
    'BLACK=Negre'#13+
    'SILVER=Plata'#13+
    'DKGRAY=Gris fosc'#13+
    'BTNFACE=Gris'#13+
    'GRAY SCALE VISUAL=Grisos visual'#13+
    'INVERTED GRAY SCALE=Grisos Invertits'#13+
    'LEFT WALL=Paret Esquerra'#13+
    'BOTTOM WALL=Paret Inferior'#13+
    'RIGHT WALL=Paret Dreta'#13+
    'BACK WALL=Paret Darrera'#13+
    'STAIRS INVERTED=Escala Inv.'#13+
    'FORMATTING=Format'#13+
    'FLOATING POINT=Decimal'#13+
    'DATE-TIME=Data / Hora'#13+
    'CHOOSE AN OPTION=Escolli una opci�'+#13+
    'IMPORTING FROM WEB: %S=Agafant del web: %s'#13+
    'LOAD CHART FROM WEB ADDRESS=Agafar gr�fic del Web'#13+
    'BROWSE THE TEECHART GALLERY AT WWW.STEEMA.COM=Veure la Galer�a de Gr�fics a www.Steema.com'#13+
    'GO !=Anar !'#13+
    'UPLOAD !=Pujar !'#13+
    'UPLOAD CURRENT CHART TO WEB GALLERY=Pujar el seu Gr�fic a la Galer�a al Web'#13+
    'TEECHART OFFICE WEB GALLERY=Galer�a de Gr�fics al Web'#13+
    'YOUR NAME=El seu Nom'#13+
    'YOUR E-MAIL=El seu e-Mail'#13+
    'PASSWORD=Mot de clau'#13+
    'OBTAIN PASSWORD=Obtenir Clau'#13+
    'CHART NAME=Nom Gr�fic'#13+
    'FIRST=Primera'#13+
    'PRIOR=Anterior'#13+
    'NEXT=Seguent'#13+
    'LAST=Ultima'#13+
    'CREATE NEW DATASET=Crear nova Taula o Consulta'#13+
    'DATASET STYLE=Tipus de Base de Dades'#13+
    'SQL QUERY=Consulta SQL'#13+
    'FROM=Desde'#13+
    'TO=Fins'#13+
    'STEP=Cada'#13+
    'VALUE=Valor'#13+
    'EXCEL FILE=Arxiu Excel'#13+
    'WORKSHEET=Llibre'#13+
    'VALUES RANGE=Rang Valors'#13+
    'LABELS RANGE=Rang Textes'#13+
    'FOCUS=Resaltar'#13+
    'EXPLODE=Expandir';
end;

Procedure TeeOfficeGerman;

Procedure SetGermanConstants;
begin
  TeeMsg_ZoomInstructions    :='Ziehen Sie die Maus nach rechts unten f�r Zoom.';
  TeeMsg_ScrollInstructions  :='Ziehen Sie die Maus, um die Chartinhalte zu srollen.';
  TeeMsg_DrawLineInstructions:='Ziehen Sie die Maus, um Linien zu zeichnen, auszuw�hlen und zu bewegen.';

  TeeMsg_SureToDeleteDataSet :='Soll der Datensatz wirklich gel�scht werden?';
  TeeMsg_Select              :='Ausw�hlen'; 
  TeeMsg_EMail               :='e-mail';
  TeeMsg_Open                :='�ffnen';
  TeeMsg_New                 :='Neu'; 
  TeeMsg_ImportingWeb        :='Aus dem Web importieren: %s'; 
  TeeMsg_Annotation          :='Kommentar';
  TeeMsg_Modified            :='Modifiziert'; 
 
  TeeMsg_Next                :='&N�chster>'; 
  TeeMsg_OK                  :='OK'; 
  TeeMsg_Close               :='Schlie�en'; 
  TeeMsg_Go                  :='&Go !'; 
  TeeMsg_Upload              :='&Upload !';

  TeeMsg_CannotGetVersion    :='Kann nicht verbinden, um aktuelle Version zu erhalten.' 
                                +#13+'Fehler: %d %s'; 
 
  TeeMsg_CannotGetNewVersion :='Kann aktuelle Version nicht herunterladen.'+#13+'Fehler: %d %s'; 
 
  TeeMsg_WrongVersion        :='Falsche Version erhalten.'; 
  TeeMsg_HasLatestVersion    :='Sie besitzen bereits die letzte Version.';
  TeeMsg_ClickToUpdateVersion:='Klicken Sie die Schaltfl�che ''Update'', um die letzt Version zu erhalten.';
  TeeMsg_UpdateButton        :='&Update...';
  TeeMsg_WrongZip            :='Falscher File der Version empfangen.';
  TeeMsg_VersionReceived     :='Letzte Version empfangen. Klicken Sie OK zur Installation.';

  TeeMsg_SelectFolder        :='Ordner ausw�hlen';
  TeeMsg_EmailNotValid       :='Email-Adresse ist nicht korrekt.';
  TeeMsg_NameNotValid        :='Ihr Name ist leer. Bitte geben Sie Ihren Namen an.';
  TeeMsg_WrongPassword       :='Pa�wort ist leer. Bitte geben Sie Ihr Pa�wort an oder'
                                +#13+'klicken Sie auf ''Pa�wort erhalten'', um es als e-mail zu empfangen.';
  TeeMsg_WrongChartID        :='Chartname ist leer. Bitte geben Sie einen Chartnamen an, um ihn '+' in der Datenbank der Web-Galerie zu identifizieren.';
 
  TeeMsg_CannotObtainPassword:='Kann nicht verbinden, um Ihr Pa�wort zu erhalten.'; 
  TeeMsg_PasswordSent        :='Ihr Pa�wort wurde an Ihre  e-mail Adresse gesendet.';
  TeeMsg_Congrats            :='Gratulation.'+#13+'Sie stehen in der Anwender-Datenbank der TeeChart Office'+'Web Charts-Galerie.'+#13+TeeMsg_PasswordSent;
 
  TeeMsg_UploadingWeb        :='Speichern von %s in die Web Galerie...'; 
  TeeMsg_Uploaded            :='%s wurde in die Web Galerie gespeichert.';

  TeeMsg_TitleEditor         :='Titel Editor'; 
  TeeMsg_EnterValue          :='Wert eingeben';
  TeeMsg_PointWidth          :='Breite';
  TeeMsg_PointHeight         :='H�he'; 
 
  TeeMsg_Position            :='Position: %d,%d'; 
  TeeMsg_Size                :='Gr��e: %d x %d'; 

  TeeMsg_BetaWarning         :='Achtung: '+'Das ist eine Pre-Release Software.'+#13+#13+
                               'Einige Features k�nnen unvollst�ndig oder'+#13+
                               ' in der sp�teren Produkt-Version entfernt sein.'+#13+#13+
                               'Geben Sie Probleme und Vorschl�ge in unsere Website:'+#13+#13+
                               'www.steema.com';
 
  TeeMsg_Caps               :='CAPS';
  TeeMsg_Num                :='NUM';
  TeeMsg_SCR                :='SCR';
  TeeMsg_SaveAs             :='Speichern unter...';
  TeeMsg_ShouldClose        :='Bitte schlie�en und starten Sie TeeChart Office neu.';

  { pending }
  TeeMsg_Table              :='Table';
  TeeMsg_Query              :='Query';
end;

begin
  SetGermanConstants;

  if TeeGermanLanguage=nil then
  begin
    TeeCreateGerman;
    with TeeGermanLanguage do
    Text:=Text+#13+
    'NEW USING WIZARD=Neuer Assistent'#13+
    'OPEN=�ffnen'+#13+
    'SAVE AS=Speichern unter'#13+
    'REOPEN=Wiederherstellen'#13+
    'ABOUT=�ber'+#13+
    'PROPERTIES=Eigenschaft'+#13+
    'CHART TOOLS=Werkzeuge'+#13+
    'HELP INDEX=Hilfe Index'+#13+
    'WHAT''S THIS ?=Was ist das?'+#13+
    'VIEW=Sehen'+#13+
    'STATUS BAR=Statusbalken'+#13+
    'SERIES LIST=Liste der Reihen'#13+
    'GALLERY=Galerie'+#13+
    'TOOLBARS=Toolbox'#13+
    'PAGE=Seite'#13+
    'AS TAB=Als Register'#13+
    'AS WINDOW=Als Fenster'#13+
    'HIDE=Verbergen'#13+
    'WEB CHARTS GALLERY=Web Charts Galerie'#13+
    'UPDATE VERSION=Version aktualisieren'#13+
    'TEXT MODE=Textmodus'#13+
    'TEECHART WEB=TeeChart Web'#13+
    'ONLINE SUPPORT=Online Support'#13+
    'EXIT=Verlassen'#13+
    'SEND BY E-MAIL=Als E-mail senden'#13+
    'TEXT LABELS=Text Labels'#13+
    'X VALUES=X Werte'#13+
    'DUPLICATE=Dublizieren'#13+
    'SELECT ALL=Alles ausw�hlen'#13+
    'MOVE UP=Nach oben bewegen'#13+
    'MOVE DOWN=Nach unten bewegen'#13+
    'HIDE SERIES LIST=Reihenliste verbergen'#13+
    'VIEW 3D=3D Ansicht'#13+
    'AUTO SIZE=Autom. Gr��e'#13+
    'ADD ANNOTATION=Kommentar hinzuf�gen'#13+
    'ENABLE ZOOM=Zoom erlauben'#13+
    'ENABLE SCROLL=Scroll erlauben'#13+
    'DRAW LINES=Linien zeichnen'#13+
    'SHOW HINTS=Hinweise anzeigen'#13+
    'COLOR EACH POINT=Jeder Punkt farbig'#13+
    'SHOW AT LEGEND=In Legende anzeigen'#13+
    'SHOW SERIES MARKS=ReihenMarks anzeigen'#13+
    'PROPERTY=Eigenschaft'#13+
    'MODIFIED=Ver�ndert'#13+
    'WALL=Wand'#13+
    'SERIES MARKS=ReihenMarks'#13+
    'SIDE MARGINS=Randabst�nde'#13+
    'RIGHT SIDE=Rechte Seite'#13+
    'ALIGN TO TOP=Obere Ausrichtung'#13+
    'ALIGN TO BOTTOM=Untere Ausrichtung'#13+
    'FONT COLOR=Schriftfarbe'#13+
    'FONT NAME=Schriftname'#13+
    'FONT SIZE=Schriftgr��e'#13+
    'BOLD=Fett'#13+
    'ITALIC=Kursiv'#13+
    'UNDERLINE=Unterstrichen'#13+
    'STRIKE OUT=Durchgestrichen'#13+
    'LEFT JUSTIFY=Linksb�ndig'#13+
    'RIGHT JUSTIFY=Rechsb�ndig'#13+
    'INTER-CHAR SIZE=Abstand zwischen Buchstaben'#13+
    'HIDE INSPECTOR=Inspector verbergen'#13+
    'SELECT=Ausw�hlen'#13+
    'CUSTOM POSITION=Benutzerdef. Position'#13+
    'AXIS LINE=Achslinie'+#13+
    'MINOR GRID=Untergitter'#13+
    'CAPS=Gro�buchstabe'#13+
    'NUM=NUM'#13+
    'SCR=SCR'#13+
    'YES=Ja'#13+
    'NO=Nein'#13+
    'CHECK-BOXES=Kontrollk�stchen'#13+
    'ANNOTATION=Kommentar'#13+
    'CONNECT TO STEEMA.COM TO UPDATE YOUR TEECHART OFFICE VERSION.=Verbinden mit Steema.com zur Aktualisierung ihrer TeeChart Office Version.'#13+
    'CURRENT VERSION=Aktuelle Version'#13+
    'LATEST VERSION=Letzte Version'#13+
    'CONNECT=Verbinden'#13+
    'UPDATE=Aktualisieren'#13+
    'HANDLES=L�piz'#13+
    'AXIS DIVIDER=Achsteiler'#13+
    'DRAG POINT=Punkte ziehen'#13+
    'PIE SLICES=Kreisscheiben'#13+
    'DRAG STYLE=Stil ziehen'#13+
    'TEECHART OFFICE OPTIONS=TeeChart Office Optionen'#13+
    'LANGUAGE=Sprache'#13+
    'RED=Rot'#13+
    'GREEN=Green'#13+
    'BLUE=Blau'#13+
    'WHITE=Wei�'#13+
    'YELLOW=Gelb'#13+
    'BLACK=Schwarz'#13+
    'SILVER=Silber'#13+
    'DKGRAY=Dunkelgrau'#13+
    'BTNFACE=Grau'#13+
    'GRAY SCALE VISUAL=Graustufen'#13+
    'INVERTED GRAY SCALE=Inverse Graustufen'#13+
    'LEFT WALL=Linke Wand'#13+
    'BOTTOM WALL=Untere Wand'#13+
    'RIGHT WALL=Rechte Wand'#13+
    'BACK WALL=Hintere Wand'#13+
    'STAIRS INVERTED=Inv. Treppen'#13+
    'FORMATTING=Formatieren'#13+
    'FLOATING POINT=Dezimal'#13+
    'DATE-TIME=Datum/Uhrzeit'#13+
    'CHOOSE AN OPTION=Option ausw�hlen'#13+
    'IMPORTING FROM WEB: %S=Aus dem Web importieren: %s'#13+
    'LOAD CHART FROM WEB ADDRESS=Chart aus Web-Adresse laden'#13+
    'BROWSE THE TEECHART GALLERY AT WWW.STEEMA.COM=TeeChart Galerie unter www.Steema.com durchsuchen'#13+
    'GO !=Los !'#13+
    'UPLOAD !=Hochladen !'#13+
    'UPLOAD CURRENT CHART TO WEB GALLERY=Aktuellen Chart zur Web-Galerie hochladen'#13+
    'TEECHART OFFICE WEB GALLERY=TeeChart Office Web Galerie'#13+
    'YOUR NAME=Ihr Name'#13+
    'YOUR E-MAIL=Ihre E-mail'#13+
    'PASSWORD=Pa�wort'#13+
    'OBTAIN PASSWORD=Pa�wort erhalten'#13+
    'CHART NAME=Chart-Name'#13
    ;
  end;
  TeeSetGerman;
end;

Procedure SetFrenchConstants;
begin
  TeeMsg_ZoomInstructions    :='Drag mouse to right-bottom to zoom. To left-top to unzoom.';
  TeeMsg_ScrollInstructions  :='Drag mouse to scroll Chart contents.';
  TeeMsg_DrawLineInstructions:='Drag mouse to draw, select and move lines.';

  TeeMsg_SureToDeleteDataSet :='Are you sure to delete DataSet?';
  TeeMsg_Select              :='Select';
  TeeMsg_EMail               :='e-mail';
  TeeMsg_Open                :='Open';
  TeeMsg_New                 :='New';
  TeeMsg_ImportingWeb        :='Importing from Web: %s';
  TeeMsg_Annotation          :='Annotation';
  TeeMsg_Modified            :='Modified';

  TeeMsg_Next                :='&Next >';
  TeeMsg_OK                  :='OK';
  TeeMsg_Close               :='Close';
  TeeMsg_Go                  :='&Go !';
  TeeMsg_Upload              :='&Upload !';

  TeeMsg_CannotGetVersion    :='Cannot connect to obtain current version.'+#13+
                              'Error: %d %s';

  TeeMsg_CannotGetNewVersion :='Cannot download current version.'+#13+
                              'Error: %d %s';

  TeeMsg_WrongVersion        :='Wrong version number received.';
  TeeMsg_HasLatestVersion    :='You already have the latest version.';
  TeeMsg_ClickToUpdateVersion:='Click the Update button to receive the latest version.';
  TeeMsg_UpdateButton        :='&Update...';
  TeeMsg_WrongZip            :='Wrong version file received.';
  TeeMsg_VersionReceived     :='Latest version received. Click Ok to Install.';

  TeeMsg_SelectFolder        :='Select Folder';
  TeeMsg_EmailNotValid       :='Email address is not correct.';
  TeeMsg_NameNotValid        :='Your Name is empty. Please type your name.';
  TeeMsg_WrongPassword       :='Password is empty. Please type your password or '+#13+
                              'click the Obtain Password button to receive it by e-mail.';
  TeeMsg_WrongChartID        :='Chart name is empty. Please type a Chart name to '+
                              'identify it at the Web Gallery database.';

  TeeMsg_CannotObtainPassword:='Cannot connect to obtain your Password.';
  TeeMsg_PasswordSent        :='Your Password has been sent to your email address.';
  TeeMsg_Congrats            :='Congratulations.'+#13+'You have been included in TeeChart Office '+
                              'Web Charts Gallery user database.'+#13+
                              TeeMsg_PasswordSent;

  TeeMsg_UploadingWeb        :='Uploading %s to Web Gallery...';
  TeeMsg_Uploaded            :='%s has been uploaded to Web Gallery.';

  TeeMsg_TitleEditor         :='Title Editor';
  TeeMsg_EnterValue          :='Enter value';
  TeeMsg_PointWidth          :='Width';
  TeeMsg_PointHeight         :='Height';

  TeeMsg_Position            :='Position: %d,%d';
  TeeMsg_Size                :='Size: %d x %d';

  TeeMsg_BetaWarning         :='Note: '+
                              'This is Pre-Release Software.'+#13+#13+
                              'Some features might be incomplete or'+#13+
                              'removed in the final product version.'+#13+#13+
                              'Submit problems and suggestions at our web site:'+#13+#13+
                              'www.steema.com';

  TeeMsg_Caps               :='CAPS';
  TeeMsg_Num                :='NUM';
  TeeMsg_SCR                :='SCR';
  TeeMsg_SaveAs             :='Save as...';
  TeeMsg_ShouldClose        :='Please close and restart the application.';

  { pending }
  TeeMsg_Table              :='Table';
  TeeMsg_Query              :='Query';
end;

Procedure TeeOfficeFrench;
begin
  SetFrenchConstants;

  if TeeFrenchLanguage=nil then
  begin
    TeeCreateFrench;
    with TeeFrenchLanguage do ;
  end;
  TeeSetFrench;
end;

Procedure SetBrazilConstants;
begin
  TeeMsg_ZoomInstructions    :='Drag mouse to right-bottom to zoom. To left-top to unzoom.';
  TeeMsg_ScrollInstructions  :='Drag mouse to scroll Chart contents.';
  TeeMsg_DrawLineInstructions:='Drag mouse to draw, select and move lines.';

  TeeMsg_SureToDeleteDataSet :='Are you sure to delete DataSet?';
  TeeMsg_Select              :='Select';
  TeeMsg_EMail               :='e-mail';
  TeeMsg_Open                :='Open';
  TeeMsg_New                 :='New';
  TeeMsg_ImportingWeb        :='Importing from Web: %s';
  TeeMsg_Annotation          :='Annotation';
  TeeMsg_Modified            :='Modified';

  TeeMsg_Next                :='&Next >';
  TeeMsg_OK                  :='OK';
  TeeMsg_Close               :='Close';
  TeeMsg_Go                  :='&Go !';
  TeeMsg_Upload              :='&Upload !';

  TeeMsg_CannotGetVersion    :='Cannot connect to obtain current version.'+#13+
                              'Error: %d %s';

  TeeMsg_CannotGetNewVersion :='Cannot download current version.'+#13+
                              'Error: %d %s';

  TeeMsg_WrongVersion        :='Wrong version number received.';
  TeeMsg_HasLatestVersion    :='You already have the latest version.';
  TeeMsg_ClickToUpdateVersion:='Click the Update button to receive the latest version.';
  TeeMsg_UpdateButton        :='&Update...';
  TeeMsg_WrongZip            :='Wrong version file received.';
  TeeMsg_VersionReceived     :='Latest version received. Click Ok to Install.';

  TeeMsg_SelectFolder        :='Select Folder';
  TeeMsg_EmailNotValid       :='Email address is not correct.';
  TeeMsg_NameNotValid        :='Your Name is empty. Please type your name.';
  TeeMsg_WrongPassword       :='Password is empty. Please type your password or '+#13+
                              'click the Obtain Password button to receive it by e-mail.';
  TeeMsg_WrongChartID        :='Chart name is empty. Please type a Chart name to '+
                              'identify it at the Web Gallery database.';

  TeeMsg_CannotObtainPassword:='Cannot connect to obtain your Password.';
  TeeMsg_PasswordSent        :='Your Password has been sent to your email address.';
  TeeMsg_Congrats            :='Congratulations.'+#13+'You have been included in TeeChart Office '+
                              'Web Charts Gallery user database.'+#13+
                              TeeMsg_PasswordSent;

  TeeMsg_UploadingWeb        :='Uploading %s to Web Gallery...';
  TeeMsg_Uploaded            :='%s has been uploaded to Web Gallery.';

  TeeMsg_TitleEditor         :='Title Editor';
  TeeMsg_EnterValue          :='Enter value';
  TeeMsg_PointWidth          :='Width';
  TeeMsg_PointHeight         :='Height';

  TeeMsg_Position            :='Position: %d,%d';
  TeeMsg_Size                :='Size: %d x %d';

  TeeMsg_BetaWarning         :='Note: '+
                              'This is Pre-Release Software.'+#13+#13+
                              'Some features might be incomplete or'+#13+
                              'removed in the final product version.'+#13+#13+
                              'Submit problems and suggestions at our web site:'+#13+#13+
                              'www.steema.com';

  TeeMsg_Caps               :='CAPS';
  TeeMsg_Num                :='NUM';
  TeeMsg_SCR                :='SCR';
  TeeMsg_SaveAs             :='Save as...';
  TeeMsg_ShouldClose        :='Please close and restart the application.';

  { pending }
  TeeMsg_Table              :='Table';
  TeeMsg_Query              :='Query';
end;

Procedure TeeOfficeBrazil;
begin
  SetBrazilConstants;

  if TeeBrazilLanguage=nil then
  begin
    TeeCreateBrazil;
    with TeeBrazilLanguage do ;
  end;
  TeeSetBrazil;
end;

Procedure TeeOfficeDanish;

Procedure SetDanishConstants;
begin
  TeeMsg_ZoomInstructions    :='Drag mouse to right-bottom to zoom. To left-top to unzoom.';
  TeeMsg_ScrollInstructions  :='Drag mouse to scroll Chart contents.';
  TeeMsg_DrawLineInstructions:='Drag mouse to draw, select and move lines.';

  TeeMsg_SureToDeleteDataSet :='Are you sure to delete DataSet?';
  TeeMsg_Select              :='Select';
  TeeMsg_EMail               :='e-mail';
  TeeMsg_Open                :='Open';
  TeeMsg_New                 :='New';
  TeeMsg_ImportingWeb        :='Importing from Web: %s';
  TeeMsg_Annotation          :='Annotation';
  TeeMsg_Modified            :='Modified';

  TeeMsg_Next                :='&Next >';
  TeeMsg_OK                  :='OK';
  TeeMsg_Close               :='Close';
  TeeMsg_Go                  :='&Go !';
  TeeMsg_Upload              :='&Upload !';

  TeeMsg_CannotGetVersion    :='Cannot connect to obtain current version.'+#13+
                              'Error: %d %s';

  TeeMsg_CannotGetNewVersion :='Cannot download current version.'+#13+
                              'Error: %d %s';

  TeeMsg_WrongVersion        :='Wrong version number received.';
  TeeMsg_HasLatestVersion    :='You already have the latest version.';
  TeeMsg_ClickToUpdateVersion:='Click the Update button to receive the latest version.';
  TeeMsg_UpdateButton        :='&Update...';
  TeeMsg_WrongZip            :='Wrong version file received.';
  TeeMsg_VersionReceived     :='Latest version received. Click Ok to Install.';

  TeeMsg_SelectFolder        :='Select Folder';
  TeeMsg_EmailNotValid       :='Email address is not correct.';
  TeeMsg_NameNotValid        :='Your Name is empty. Please type your name.';
  TeeMsg_WrongPassword       :='Password is empty. Please type your password or '+#13+
                              'click the Obtain Password button to receive it by e-mail.';
  TeeMsg_WrongChartID        :='Chart name is empty. Please type a Chart name to '+
                              'identify it at the Web Gallery database.';

  TeeMsg_CannotObtainPassword:='Cannot connect to obtain your Password.';
  TeeMsg_PasswordSent        :='Your Password has been sent to your email address.';
  TeeMsg_Congrats            :='Congratulations.'+#13+'You have been included in TeeChart Office '+
                              'Web Charts Gallery user database.'+#13+
                              TeeMsg_PasswordSent;

  TeeMsg_UploadingWeb        :='Uploading %s to Web Gallery...';
  TeeMsg_Uploaded            :='%s has been uploaded to Web Gallery.';

  TeeMsg_TitleEditor         :='Title Editor';
  TeeMsg_EnterValue          :='Enter value';
  TeeMsg_PointWidth          :='Width';
  TeeMsg_PointHeight         :='Height';

  TeeMsg_Position            :='Position: %d,%d';
  TeeMsg_Size                :='Size: %d x %d';

  TeeMsg_BetaWarning         :='Note: '+
                              'This is Pre-Release Software.'+#13+#13+
                              'Some features might be incomplete or'+#13+
                              'removed in the final product version.'+#13+#13+
                              'Submit problems and suggestions at our web site:'+#13+#13+
                              'www.steema.com';

  TeeMsg_Caps               :='CAPS';
  TeeMsg_Num                :='NUM';
  TeeMsg_SCR                :='SCR';
  TeeMsg_SaveAs             :='Save as...';
  TeeMsg_ShouldClose        :='Please close and restart the application.';

  { pending }
  TeeMsg_Table              :='Table';
  TeeMsg_Query              :='Query';
end;

begin
  SetDanishConstants;

  if TeeDanishLanguage=nil then
  begin
    TeeCreateDanish;
    with TeeDanishLanguage do ;
  end;

  TeeSetDanish;
end;

Procedure TeeOfficeDutch;

Procedure SetDutchConstants;
begin
  TeeMsg_ZoomInstructions    :='Drag mouse to right-bottom to zoom. To left-top to unzoom.';
  TeeMsg_ScrollInstructions  :='Drag mouse to scroll Chart contents.';
  TeeMsg_DrawLineInstructions:='Drag mouse to draw, select and move lines.';

  TeeMsg_SureToDeleteDataSet :='Are you sure to delete DataSet?';
  TeeMsg_Select              :='Select';
  TeeMsg_EMail               :='e-mail';
  TeeMsg_Open                :='Open';
  TeeMsg_New                 :='New';
  TeeMsg_ImportingWeb        :='Importing from Web: %s';
  TeeMsg_Annotation          :='Annotation';
  TeeMsg_Modified            :='Modified';

  TeeMsg_Next                :='&Next >';
  TeeMsg_OK                  :='OK';
  TeeMsg_Close               :='Close';
  TeeMsg_Go                  :='&Go !';
  TeeMsg_Upload              :='&Upload !';

  TeeMsg_CannotGetVersion    :='Cannot connect to obtain current version.'+#13+
                              'Error: %d %s';

  TeeMsg_CannotGetNewVersion :='Cannot download current version.'+#13+
                              'Error: %d %s';

  TeeMsg_WrongVersion        :='Wrong version number received.';
  TeeMsg_HasLatestVersion    :='You already have the latest version.';
  TeeMsg_ClickToUpdateVersion:='Click the Update button to receive the latest version.';
  TeeMsg_UpdateButton        :='&Update...';
  TeeMsg_WrongZip            :='Wrong version file received.';
  TeeMsg_VersionReceived     :='Latest version received. Click Ok to Install.';

  TeeMsg_SelectFolder        :='Select Folder';
  TeeMsg_EmailNotValid       :='Email address is not correct.';
  TeeMsg_NameNotValid        :='Your Name is empty. Please type your name.';
  TeeMsg_WrongPassword       :='Password is empty. Please type your password or '+#13+
                              'click the Obtain Password button to receive it by e-mail.';
  TeeMsg_WrongChartID        :='Chart name is empty. Please type a Chart name to '+
                              'identify it at the Web Gallery database.';

  TeeMsg_CannotObtainPassword:='Cannot connect to obtain your Password.';
  TeeMsg_PasswordSent        :='Your Password has been sent to your email address.';
  TeeMsg_Congrats            :='Congratulations.'+#13+'You have been included in TeeChart Office '+
                              'Web Charts Gallery user database.'+#13+
                              TeeMsg_PasswordSent;

  TeeMsg_UploadingWeb        :='Uploading %s to Web Gallery...';
  TeeMsg_Uploaded            :='%s has been uploaded to Web Gallery.';

  TeeMsg_TitleEditor         :='Title Editor';
  TeeMsg_EnterValue          :='Enter value';
  TeeMsg_PointWidth          :='Width';
  TeeMsg_PointHeight         :='Height';

  TeeMsg_Position            :='Position: %d,%d';
  TeeMsg_Size                :='Size: %d x %d';

  TeeMsg_BetaWarning         :='Note: '+
                              'This is Pre-Release Software.'+#13+#13+
                              'Some features might be incomplete or'+#13+
                              'removed in the final product version.'+#13+#13+
                              'Submit problems and suggestions at our web site:'+#13+#13+
                              'www.steema.com';

  TeeMsg_Caps               :='CAPS';
  TeeMsg_Num                :='NUM';
  TeeMsg_SCR                :='SCR';
  TeeMsg_SaveAs             :='Save as...';
  TeeMsg_ShouldClose        :='Please close and restart the application.';

  { pending }
  TeeMsg_Table              :='Table';
  TeeMsg_Query              :='Query';
end;

begin
  SetDutchConstants;

  if TeeDutchLanguage=nil then
  begin
    TeeCreateDutch;
    with TeeDutchLanguage do ;
  end;

  TeeSetDutch;
end;

Procedure TeeOfficeSwedish;

Procedure SetSwedishConstants;
begin
  TeeMsg_ZoomInstructions    :='Drag mus till h�ger-botten f�r att zooma. Till v�nster-upp f�r att zooma ut.';
  TeeMsg_ScrollInstructions  :='Drag mus f�r att skrolla kartans inneh�ll.';
  TeeMsg_DrawLineInstructions:='Drag mus f�r att rita, v�lja och flytta linjer.';

  TeeMsg_SureToDeleteDataSet :='�r du s�ker p� att du vill radera data set?';
  TeeMsg_Select              :='V�lj';
  TeeMsg_EMail               :='e-mail';
  TeeMsg_Open                :='�ppna';
  TeeMsg_New                 :='Nytt';
  TeeMsg_ImportingWeb        :='Importera fr�n Web: %s';
  TeeMsg_Annotation          :='Kommentar';
  TeeMsg_Modified            :='Modifierad';

  TeeMsg_Next                :='&N�sta >';
  TeeMsg_OK                  :='OK';
  TeeMsg_Close               :='St�ng';
  TeeMsg_Go                  :='&K�r !';
  TeeMsg_Upload              :='&Ladda upp!';

  TeeMsg_CannotGetVersion    :='Kan inte koppla upp f�r att erh�lla aktuell version.'+#13+
                              'Fel: %d %s';

  TeeMsg_CannotGetNewVersion :='Kan inte ladda ner aktuell version.'+#13+
                              'Fel: %d %s';

  TeeMsg_WrongVersion        :='Erh�llet version nummer �r fel.';
  TeeMsg_HasLatestVersion    :='Du har redan senaste versionen.';
  TeeMsg_ClickToUpdateVersion:='Klicka Uppdatera f�r att erh�lla senaste versionen.';
  TeeMsg_UpdateButton        :='&Uppdatera...';
  TeeMsg_WrongZip            :='Fel version fil erh�llen.';
  TeeMsg_VersionReceived     :='Senaste versionen erh�llen. Klicka OK f�r att installera.';

  TeeMsg_SelectFolder        :='V�lj mapp';
  TeeMsg_EmailNotValid       :='Email adress �r inte korrekt.';
  TeeMsg_NameNotValid        :='Ditt namn �r tomt. Skriv in ditt namn.';
  TeeMsg_WrongPassword       :='L�senord �r tomt. Skriv in ditt l�senord eller klicka Erh�ll L�senord f�r att erh�lla det med email';
  TeeMsg_WrongChartID        :='Kart namn �r tomt. Skriv in ett namn f�r att identifiera karta i Web galleriets data bas';

  TeeMsg_CannotObtainPassword:='Kan inte koppla upp f�r att erh�lla ditt l�senord.';
  TeeMsg_PasswordSent        :='Ditt l�senord har skickats till din email adress.';
  TeeMsg_Congrats            :='Gratulerar.'+#13+'Du har blivit inkluderad i TeeChart Office '+
                              'Web Charts Galleri anv�ndar data bas.';


  TeeMsg_UploadingWeb        :='Laddar upp till Web galleriet...';
  TeeMsg_Uploaded            :='%s har blivit uppladdat till Web Galleriet.';

  TeeMsg_TitleEditor         :='Titel Editor';
  TeeMsg_EnterValue          :='Skriv in v�rde';
  TeeMsg_PointWidth          :='Bredd';
  TeeMsg_PointHeight         :='H�jd';

  TeeMsg_Position            :='Position: %d,%d';
  TeeMsg_Size                :='Storlek: %d x %d';

  TeeMsg_BetaWarning         :='Kommentar: '+
                              'Detta �r beta mjukvara.'+#13+#13+
                              'Vissa egenskaper kan vara inkompletta eller borttagna i den slutliga produktversionen'+#13+
                              'Skicka problem och f�rslag till v�r Web plats:'+#13+#13+
                              'www.steema.com';

  TeeMsg_Caps               :='CAPS';
  TeeMsg_Num                :='NUM';
  TeeMsg_SCR                :='SCR';
  TeeMsg_SaveAs             :='Spara som...';
  TeeMsg_ShouldClose        :='St�ng och starta om TeeTreeOffice.';

  TeeMsg_Table              :='Table';
  TeeMsg_Query              :='Query';
end;

begin
  SetSwedishConstants;

  if TeeSwedishLanguage=nil then
  begin
    TeeCreateSwedish;
    with TeeSwedishLanguage do ;
  end;

  TeeSetSwedish;
end;

Procedure TeeOfficeChinese;

Procedure SetChineseConstants;
begin
  TeeMsg_ZoomInstructions    :='Drag mouse to right-bottom to zoom. To left-top to unzoom.';
  TeeMsg_ScrollInstructions  :='Drag mouse to scroll Chart contents.';
  TeeMsg_DrawLineInstructions:='Drag mouse to draw, select and move lines.';

  TeeMsg_SureToDeleteDataSet :='Are you sure to delete DataSet?';
  TeeMsg_Select              :='Select';
  TeeMsg_EMail               :='e-mail';
  TeeMsg_Open                :='Open';
  TeeMsg_New                 :='New';
  TeeMsg_ImportingWeb        :='Importing from Web: %s';
  TeeMsg_Annotation          :='Annotation';
  TeeMsg_Modified            :='Modified';

  TeeMsg_Next                :='&Next >';
  TeeMsg_OK                  :='OK';
  TeeMsg_Close               :='Close';
  TeeMsg_Go                  :='&Go !';
  TeeMsg_Upload              :='&Upload !';

  TeeMsg_CannotGetVersion    :='Cannot connect to obtain current version.'+#13+
                              'Error: %d %s';

  TeeMsg_CannotGetNewVersion :='Cannot download current version.'+#13+
                              'Error: %d %s';

  TeeMsg_WrongVersion        :='Wrong version number received.';
  TeeMsg_HasLatestVersion    :='You already have the latest version.';
  TeeMsg_ClickToUpdateVersion:='Click the Update button to receive the latest version.';
  TeeMsg_UpdateButton        :='&Update...';
  TeeMsg_WrongZip            :='Wrong version file received.';
  TeeMsg_VersionReceived     :='Latest version received. Click Ok to Install.';

  TeeMsg_SelectFolder        :='Select Folder';
  TeeMsg_EmailNotValid       :='Email address is not correct.';
  TeeMsg_NameNotValid        :='Your Name is empty. Please type your name.';
  TeeMsg_WrongPassword       :='Password is empty. Please type your password or '+#13+
                              'click the Obtain Password button to receive it by e-mail.';
  TeeMsg_WrongChartID        :='Chart name is empty. Please type a Chart name to '+
                              'identify it at the Web Gallery database.';

  TeeMsg_CannotObtainPassword:='Cannot connect to obtain your Password.';
  TeeMsg_PasswordSent        :='Your Password has been sent to your email address.';
  TeeMsg_Congrats            :='Congratulations.'+#13+'You have been included in TeeChart Office '+
                              'Web Charts Gallery user database.'+#13+
                              TeeMsg_PasswordSent;

  TeeMsg_UploadingWeb        :='Uploading %s to Web Gallery...';
  TeeMsg_Uploaded            :='%s has been uploaded to Web Gallery.';

  TeeMsg_TitleEditor         :='Title Editor';
  TeeMsg_EnterValue          :='Enter value';
  TeeMsg_PointWidth          :='Width';
  TeeMsg_PointHeight         :='Height';

  TeeMsg_Position            :='Position: %d,%d';
  TeeMsg_Size                :='Size: %d x %d';

  TeeMsg_BetaWarning         :='Note: '+
                              'This is Pre-Release Software.'+#13+#13+
                              'Some features might be incomplete or'+#13+
                              'removed in the final product version.'+#13+#13+
                              'Submit problems and suggestions at our web site:'+#13+#13+
                              'www.steema.com';

  TeeMsg_Caps               :='CAPS';
  TeeMsg_Num                :='NUM';
  TeeMsg_SCR                :='SCR';
  TeeMsg_SaveAs             :='Save as...';
  TeeMsg_ShouldClose        :='Please close and restart the application.';

  { pending }
  TeeMsg_Table              :='Table';
  TeeMsg_Query              :='Query';
end;

begin
  SetChineseConstants;

  if TeeChineseLanguage=nil then
  begin
    TeeCreateChinese;
    with TeeChineseLanguage do ;
  end;

  TeeSetChinese;
end;

Procedure TeeOfficeChineseSimp;

Procedure SetChineseSimpConstants;
begin
  TeeMsg_ZoomInstructions    :='Drag mouse to right-bottom to zoom. To left-top to unzoom.';
  TeeMsg_ScrollInstructions  :='Drag mouse to scroll Chart contents.';
  TeeMsg_DrawLineInstructions:='Drag mouse to draw, select and move lines.';

  TeeMsg_SureToDeleteDataSet :='Are you sure to delete DataSet?';
  TeeMsg_Select              :='Select';
  TeeMsg_EMail               :='e-mail';
  TeeMsg_Open                :='Open';
  TeeMsg_New                 :='New';
  TeeMsg_ImportingWeb        :='Importing from Web: %s';
  TeeMsg_Annotation          :='Annotation';
  TeeMsg_Modified            :='Modified';

  TeeMsg_Next                :='&Next >';
  TeeMsg_OK                  :='OK';
  TeeMsg_Close               :='Close';
  TeeMsg_Go                  :='&Go !';
  TeeMsg_Upload              :='&Upload !';

  TeeMsg_CannotGetVersion    :='Cannot connect to obtain current version.'+#13+
                              'Error: %d %s';

  TeeMsg_CannotGetNewVersion :='Cannot download current version.'+#13+
                              'Error: %d %s';

  TeeMsg_WrongVersion        :='Wrong version number received.';
  TeeMsg_HasLatestVersion    :='You already have the latest version.';
  TeeMsg_ClickToUpdateVersion:='Click the Update button to receive the latest version.';
  TeeMsg_UpdateButton        :='&Update...';
  TeeMsg_WrongZip            :='Wrong version file received.';
  TeeMsg_VersionReceived     :='Latest version received. Click Ok to Install.';

  TeeMsg_SelectFolder        :='Select Folder';
  TeeMsg_EmailNotValid       :='Email address is not correct.';
  TeeMsg_NameNotValid        :='Your Name is empty. Please type your name.';
  TeeMsg_WrongPassword       :='Password is empty. Please type your password or '+#13+
                              'click the Obtain Password button to receive it by e-mail.';
  TeeMsg_WrongChartID        :='Chart name is empty. Please type a Chart name to '+
                              'identify it at the Web Gallery database.';

  TeeMsg_CannotObtainPassword:='Cannot connect to obtain your Password.';
  TeeMsg_PasswordSent        :='Your Password has been sent to your email address.';
  TeeMsg_Congrats            :='Congratulations.'+#13+'You have been included in TeeChart Office '+
                              'Web Charts Gallery user database.'+#13+
                              TeeMsg_PasswordSent;

  TeeMsg_UploadingWeb        :='Uploading %s to Web Gallery...';
  TeeMsg_Uploaded            :='%s has been uploaded to Web Gallery.';

  TeeMsg_TitleEditor         :='Title Editor';
  TeeMsg_EnterValue          :='Enter value';
  TeeMsg_PointWidth          :='Width';
  TeeMsg_PointHeight         :='Height';

  TeeMsg_Position            :='Position: %d,%d';
  TeeMsg_Size                :='Size: %d x %d';

  TeeMsg_BetaWarning         :='Note: '+
                              'This is Pre-Release Software.'+#13+#13+
                              'Some features might be incomplete or'+#13+
                              'removed in the final product version.'+#13+#13+
                              'Submit problems and suggestions at our web site:'+#13+#13+
                              'www.steema.com';

  TeeMsg_Caps               :='CAPS';
  TeeMsg_Num                :='NUM';
  TeeMsg_SCR                :='SCR';
  TeeMsg_SaveAs             :='Save as...';
  TeeMsg_ShouldClose        :='Please close and restart the application.';

  { pending }
  TeeMsg_Table              :='Table';
  TeeMsg_Query              :='Query';
end;

begin
  SetChineseSimpConstants;

  if TeeChineseSimpLanguage=nil then
  begin
    TeeCreateChineseSimp;
    with TeeChineseSimpLanguage do ;
  end;

  TeeSetChineseSimp;
end;

Procedure TeeOfficePortuguese;

Procedure SetPortugueseConstants;
begin
  TeeMsg_ZoomInstructions    :='Drag mouse to right-bottom to zoom. To left-top to unzoom.';
  TeeMsg_ScrollInstructions  :='Drag mouse to scroll Chart contents.';
  TeeMsg_DrawLineInstructions:='Drag mouse to draw, select and move lines.';
  TeeMsg_SureToDeleteDataSet :='Are you sure to delete DataSet?';
  TeeMsg_Select              :='Select';
  TeeMsg_EMail               :='e-mail';
  TeeMsg_Open                :='Open';
  TeeMsg_New                 :='New';
  TeeMsg_ImportingWeb        :='Importing from Web: %s';
  TeeMsg_Annotation          :='Annotation';
  TeeMsg_Modified            :='Modified';

  TeeMsg_Next                :='&Next >';
  TeeMsg_OK                  :='OK';
  TeeMsg_Close               :='Close';
  TeeMsg_Go                  :='&Go !';
  TeeMsg_Upload              :='&Upload !';

  TeeMsg_CannotGetVersion    :='Cannot connect to obtain current version.'+#13+
                              'Error: %d %s';

  TeeMsg_CannotGetNewVersion :='Cannot download current version.'+#13+
                              'Error: %d %s';

  TeeMsg_WrongVersion        :='Wrong version number received.';
  TeeMsg_HasLatestVersion    :='You already have the latest version.';
  TeeMsg_ClickToUpdateVersion:='Click the Update button to receive the latest version.';
  TeeMsg_UpdateButton        :='&Update...';
  TeeMsg_WrongZip            :='Wrong version file received.';
  TeeMsg_VersionReceived     :='Latest version received. Click Ok to Install.';

  TeeMsg_SelectFolder        :='Select Folder';
  TeeMsg_EmailNotValid       :='Email address is not correct.';
  TeeMsg_NameNotValid        :='Your Name is empty. Please type your name.';
  TeeMsg_WrongPassword       :='Password is empty. Please type your password or '+#13+
                              'click the Obtain Password button to receive it by e-mail.';
  TeeMsg_WrongChartID        :='Chart name is empty. Please type a Chart name to '+
                              'identify it at the Web Gallery database.';

  TeeMsg_CannotObtainPassword:='Cannot connect to obtain your Password.';
  TeeMsg_PasswordSent        :='Your Password has been sent to your email address.';
  TeeMsg_Congrats            :='Congratulations.'+#13+'You have been included in TeeChart Office '+
                              'Web Charts Gallery user database.'+#13+
                              TeeMsg_PasswordSent;

  TeeMsg_UploadingWeb        :='Uploading %s to Web Gallery...';
  TeeMsg_Uploaded            :='%s has been uploaded to Web Gallery.';

  TeeMsg_TitleEditor         :='Title Editor';
  TeeMsg_EnterValue          :='Enter value';
  TeeMsg_PointWidth          :='Width';
  TeeMsg_PointHeight         :='Height';

  TeeMsg_Position            :='Position: %d,%d';
  TeeMsg_Size                :='Size: %d x %d';

  TeeMsg_BetaWarning         :='Note: '+
                              'This is Pre-Release Software.'+#13+#13+
                              'Some features might be incomplete or'+#13+
                              'removed in the final product version.'+#13+#13+
                              'Submit problems and suggestions at our web site:'+#13+#13+
                              'www.steema.com';

  TeeMsg_Caps               :='CAPS';
  TeeMsg_Num                :='NUM';
  TeeMsg_SCR                :='SCR';
  TeeMsg_SaveAs             :='Save as...';
  TeeMsg_ShouldClose        :='Please close and restart the application.';

  { pending }
  TeeMsg_Table              :='Table';
  TeeMsg_Query              :='Query';
end;

begin
  SetPortugueseConstants;

  if TeePortugueseLanguage=nil then
  begin
    TeeCreatePortuguese;
    with TeePortugueseLanguage do ;
  end;

  TeeSetPortuguese;
end;

Procedure TeeOfficeRussian;

Procedure SetRussianConstants;
begin
  TeeMsg_ZoomInstructions    :='����������� ���� ������ ���� ��� ����������. ����� ����� ��� ����������.';
  TeeMsg_ScrollInstructions  :='����������� ���� ��� ��������� ����������� ���������.';
  TeeMsg_DrawLineInstructions:='����������� ���� ��� ���������, ��������� � ����������� �����.';

  TeeMsg_SureToDeleteDataSet :='�� ������������� ������ ������� ������?';
  TeeMsg_Select              :='��������';
  TeeMsg_EMail               :='"����������� �����';
  TeeMsg_Open                :='�������';
  TeeMsg_New                 :='�����';
  TeeMsg_ImportingWeb        :='�������� �� ���������: %s';
  TeeMsg_Annotation          :='�����������';
  TeeMsg_Modified            :='��������';

  TeeMsg_Next                :='&��������� >';
  TeeMsg_OK                  :='OK';
  TeeMsg_Close               :='�������';
  TeeMsg_Go                  :='&������ !';
  TeeMsg_Upload              :='&��������� !';

  TeeMsg_CannotGetVersion    :='���������� ����� ������������ ������.'+#13+
                              '������: %d %s';

  TeeMsg_CannotGetNewVersion :='���������� �������� ������������ ������.'+#13+
                              '������: %d %s';

  TeeMsg_WrongVersion        :='������� ������������ ����� ������.';
  TeeMsg_HasLatestVersion    :='�� ��� ������ ��������� ������.';
  TeeMsg_ClickToUpdateVersion:='������� ������ �������� ��� ��������� ��������� ������.';
  TeeMsg_UpdateButton        :='&����������...';
  TeeMsg_WrongZip            :='������ ���� ������������ ������.';
  TeeMsg_VersionReceived     :='��������� ������ ��������. ������� Ok ��� ���������.';

  TeeMsg_SelectFolder        :='����� �����';
  TeeMsg_EmailNotValid       :='������������ ����� ����������� �����.';
  TeeMsg_NameNotValid        :='���� ������ ����� �����. ����������, ������� ���� ���.';
  TeeMsg_WrongPassword       :='���� ������ �����. ����������, ������� ������ ��� '+#13+
                              '������� ������ �������� ������ ��� ��������� ������ �� ����������� �����.';
  TeeMsg_WrongChartID        :='��� ��������� �����. ����������, ������� ��� ��������� ��� '+
                              '������������� � ���� ������ Web Gallery.';

  TeeMsg_CannotObtainPassword:='���������� ������������ � ���� ��� ��������� ������ ������.';
  TeeMsg_PasswordSent        :='��� ������ ������� �� ��� ����� ����������� �����.';
  TeeMsg_Congrats            :='�����������.'+#13+'�� �������� � ���������������� ���� ������ TeeChart Office '+
                              'Web Charts Gallery.'+#13+
                              TeeMsg_PasswordSent;

  TeeMsg_UploadingWeb        :='�������� %s � Web Gallery...';
  TeeMsg_Uploaded            :='%s ��������� � Web Gallery.';

  TeeMsg_TitleEditor         :='�������� ��������';

  TeeMsg_EnterValue          :='������� ��������';
  TeeMsg_PointWidth          :='������';
  TeeMsg_PointHeight         :='������';

  TeeMsg_Position            :='���������: %d,%d';
  TeeMsg_Size                :='������: %d x %d';

  TeeMsg_BetaWarning         :='��������: '+
                              '��� �� ��������� ������� ����������� �����������.'+#13+#13+
                              '��������� ����������� ����� ���� ��������� ���'+#13+
                              '����� ��������� �� ��������� ������ ���������.'+#13+#13+
                              '������� � ��������� ����������� �� ��� ����:'+#13+#13+
                              'www.steema.com';

  TeeMsg_Caps               :='CAPS';
  TeeMsg_Num                :='NUM';
  TeeMsg_SCR                :='SCR';
  TeeMsg_SaveAs             :='��������� ���...';
  TeeMsg_ShouldClose        :='����������, ������������� TeeChartOffice.';
  TeeMsg_Table              :='�������';
  TeeMsg_Query              :='������';
end;

begin
  SetRussianConstants;
  TeeSetRussian;

  if TeeRussianLanguage.IndexOf('NEW USING WIZARD')=-1 then
  with TeeRussianLanguage do
    Text:=Text+#13+
    'NEW USING WIZARD=����� ������'#13+
    'OPEN=�������'+#13+
    'SAVE AS=���������'#13+
    'SAVE AS...=��������� ���...'#13+
    'REOPEN=������� �����'#13+
    'ABOUT=� ���������'+#13+
    'PROPERTIES=��������'+#13+
    'CHART TOOLS=�����������'+#13+
    'HELP INDEX=���������'+#13+
    'WHAT''S THIS ?=��� ���?'+#13+
    'VIEW=���'+#13+
    'STATUS BAR=������ �������'+#13+
    'SERIES LIST=������ �������������������'#13+
    'GALLERY=�������'+#13+
    'TOOLBARS=������ ������������'#13+
    'PAGE=�������'#13+
    'AS TAB=��� �������'#13+
    'AS WINDOW=��� ����'#13+
    'HIDE=������'#13+
    'WEB CHARTS GALLERY=��������� WEB Gallery'#13+
    'UPDATE VERSION=��������'#13+
    'TEXT MODE=��������� �����'#13+
    'TEECHART WEB=��������� �� ���������'#13+
    'ONLINE SUPPORT=���������'#13+
    'EXIT=�����'#13+
    'SEND BY E-MAIL=�������� �� ����������� �����'#13+
    'TEXT LABELS=�����'#13+
    'X VALUES=�������� �� X'#13+
    'DUPLICATE=�����������'#13+
    'SELECT ALL=Seleccionar Todas'#13+
    'MOVE UP=�����'#13+
    'MOVE DOWN=����'#13+
    'HIDE SERIES LIST=������ ������ �������������������'#13+
    'VIEW 3D=��������� ���'#13+
    'AUTO SIZE=�����������'#13+
    'ADD ANNOTATION=������ �������'#13+
    'ENABLE ZOOM=��������� ����������'#13+
    'ENABLE SCROLL=��������� ���������'#13+
    'DRAW LINES=�������� �����'#13+
    'SHOW HINTS=���������� ���������'#13+
    'COLOR EACH POINT=������� �����'#13+
    'SHOW AT LEGEND=���������� � �������'#13+
    'SHOW SERIES MARKS=���������� ����� ������������������'#13+
    'PROPERTY=��������'#13+
    'MODIFIED=�������'#13+
    'WALL=�������'#13+
    'SERIES MARKS=����� ������������������'#13+
    'SIDE MARGINS=����'#13+
    'RIGHT SIDE=������ �������'#13+
    'ALIGN TO TOP=����������� � ������'#13+
    'ALIGN TO BOTTOM=����������� �����'#13+
    'FONT COLOR=���� ������'#13+
    'FONT NAME=�����'#13+
    'FONT SIZE=������ ������'#13+
    'BOLD=������'#13+
    'ITALIC=���������'#13+
    'UNDERLINE=������������'#13+
    'STRIKE OUT=�����������'#13+
    'LEFT JUSTIFY=������������ �� ������ ����'#13+
    'RIGHT JUSTIFY=������������ �� ������� ����'#13+
    'INTER-CHAR SIZE=������������'#13+
    'HIDE INSPECTOR=������ ����������'#13+
    'SELECT=��������'#13+
    'CUSTOM POSITION=������������ ���������'#13+
    'AXIS LINE=����� ���'+#13+
    'MINOR GRID=��������� �������'#13+
    'CAPS=CAPS'#13+
    'NUM=NUM'#13+
    'SCR=SCR'#13+
    'YES=��'#13+
    'NO=���'#13+
    'CHECK-BOXES=�������'#13+
    'ANNOTATION=�������'#13+
    'CONNECT TO STEEMA.COM TO UPDATE THIS SOFTWARE.=����������� �� Steema.com ��� ���������� ���������.'#13+
    'CURRENT VERSION=������� ������'#13+
    'LATEST VERSION=��������� ������'#13+
    'CONNECT=����������'#13+
    'UPDATE=����������'#13+
    'HANDLES=���������'#13+
    'AXIS DIVIDER=�������� ���'#13+
    'PIE SLICES=�������'#13+
    'DRAG STYLE=���������� �����'#13+
    'TEECHART OFFICE OPTIONS=��������� TeeChart Office'#13+
    'LANGUAGE=����'#13+
    'RED=�������'#13+
    'GREEN=�������'#13+
    'BLUE=�����'#13+
    'WHITE=�����'#13+
    'YELLOW=������'#13+
    'BLACK=������'#13+
    'SILVER=����������'#13+
    'DKGRAY=����� �����'#13+
    'BTNFACE=����������� ������'#13+
    'GRAY SCALE VISUAL=�������� ������'#13+
    'INVERTED GRAY SCALE=���. �������� ������'#13+
    'LEFT WALL=����� �������'#13+
    'BOTTOM WALL=����� �������'#13+
    'RIGHT WALL=������ �������'#13+
    'BACK WALL=������ �������'#13+
    'STAIRS INVERTED=���. ��������'#13+
    'FORMATTING=��������������'#13+
    'FLOATING POINT=����. �����'#13+
    'DATE-TIME=����-�����'#13+
    'CHOOSE AN OPTION=�������� �����'#13+
    'IMPORTING FROM WEB: %S=������������� �� ���������: %s'#13+
    'LOAD CHART FROM WEB ADDRESS=��������� � ������:'#13+
    'BROWSE THE TEECHART GALLERY AT WWW.STEEMA.COM=�������� WEB GALLERY �� WWW.STEEMA.COM'#13+
    'GO !=������ !'#13+
    'UPLOAD !=��������� !'#13+
    'UPLOAD CURRENT CHART TO WEB GALLERY=��������� �������� ��������� � Web Gallery '#13+
    'TEECHART OFFICE WEB GALLERY=Web Gallery TeeChart Office'#13+
    'YOUR NAME=���� ���'#13+
    'YOUR E-MAIL=��� ����� ����������� �����'#13+
    'PASSWORD=������'#13+
    'OBTAIN PASSWORD=�������� ������'#13+
    'CHART NAME=�������� ���������'#13+
    'FIRST=������'#13+
    'PRIOR=����������'#13+
    'NEXT=���������'#13+
    'LAST=���������'#13+
    'CREATE NEW DATASET=������� ����� ����� ������'#13+
    'DATASET STYLE=����� ������ ������'#13+
    'SQL QUERY=SQL ������'#13+
    'FROM=��'#13+
    'TO=��'#13+
    'STEP=���'#13+
    'VALUE=��������'#13+
    'EXCEL FILE=���� Excel'#13+
    'WORKSHEET=����'#13+
    'VALUES RANGE=�������� ��������'#13+
    'LABELS RANGE=�������� �����'#13+
    'FOCUS=�����'#13+
    'EXPLODE=���������'#13+
    'AUTOSIZE=����������'#13+
    'AXIS 2=��� 2';
end;

Procedure TeeOfficeItalian;

Procedure SetItalianConstants;
begin
  TeeMsg_ZoomInstructions    :='Drag mouse to right-bottom to zoom. To left-top to unzoom.';
  TeeMsg_ScrollInstructions  :='Drag mouse to scroll Chart contents.';
  TeeMsg_DrawLineInstructions:='Drag mouse to draw, select and move lines.';

  TeeMsg_SureToDeleteDataSet :='Are you sure to delete DataSet?';
  TeeMsg_Select              :='Select';
  TeeMsg_EMail               :='e-mail';
  TeeMsg_Open                :='Open';
  TeeMsg_New                 :='New';
  TeeMsg_ImportingWeb        :='Importing from Web: %s';
  TeeMsg_Annotation          :='Annotation';
  TeeMsg_Modified            :='Modified';

  TeeMsg_Next                :='&Next >';
  TeeMsg_OK                  :='OK';
  TeeMsg_Close               :='Close';
  TeeMsg_Go                  :='&Go !';
  TeeMsg_Upload              :='&Upload !';

  TeeMsg_CannotGetVersion    :='Cannot connect to obtain current version.'+#13+
                              'Error: %d %s';

  TeeMsg_CannotGetNewVersion :='Cannot download current version.'+#13+
                              'Error: %d %s';

  TeeMsg_WrongVersion        :='Wrong version number received.';
  TeeMsg_HasLatestVersion    :='You already have the latest version.';
  TeeMsg_ClickToUpdateVersion:='Click the Update button to receive the latest version.';
  TeeMsg_UpdateButton        :='&Update...';
  TeeMsg_WrongZip            :='Wrong version file received.';
  TeeMsg_VersionReceived     :='Latest version received. Click Ok to Install.';

  TeeMsg_SelectFolder        :='Select Folder';
  TeeMsg_EmailNotValid       :='Email address is not correct.';
  TeeMsg_NameNotValid        :='Your Name is empty. Please type your name.';
  TeeMsg_WrongPassword       :='Password is empty. Please type your password or '+#13+
                              'click the Obtain Password button to receive it by e-mail.';
  TeeMsg_WrongChartID        :='Chart name is empty. Please type a Chart name to '+
                              'identify it at the Web Gallery database.';

  TeeMsg_CannotObtainPassword:='Cannot connect to obtain your Password.';
  TeeMsg_PasswordSent        :='Your Password has been sent to your email address.';
  TeeMsg_Congrats            :='Congratulations.'+#13+'You have been included in TeeChart Office '+
                              'Web Charts Gallery user database.'+#13+
                              TeeMsg_PasswordSent;

  TeeMsg_UploadingWeb        :='Uploading %s to Web Gallery...';
  TeeMsg_Uploaded            :='%s has been uploaded to Web Gallery.';

  TeeMsg_TitleEditor         :='Title Editor';
  TeeMsg_EnterValue          :='Enter value';
  TeeMsg_PointWidth          :='Width';
  TeeMsg_PointHeight         :='Height';

  TeeMsg_Position            :='Position: %d,%d';
  TeeMsg_Size                :='Size: %d x %d';

  TeeMsg_BetaWarning         :='Note: '+
                              'This is Pre-Release Software.'+#13+#13+
                              'Some features might be incomplete or'+#13+
                              'removed in the final product version.'+#13+#13+
                              'Submit problems and suggestions at our web site:'+#13+#13+
                              'www.steema.com';

  TeeMsg_Caps               :='CAPS';
  TeeMsg_Num                :='NUM';
  TeeMsg_SCR                :='SCR';
  TeeMsg_SaveAs             :='Save as...';
  TeeMsg_ShouldClose        :='Please close and restart the application.';

  { pending }
  TeeMsg_Table              :='Table';
  TeeMsg_Query              :='Query';
end;

begin
  SetItalianConstants;

  if TeeItalianLanguage=nil then
  begin
    TeeCreateItalian;
    with TeeItalianLanguage do ;
  end;

  TeeSetItalian;
end;

Procedure TeeOfficeNorwegian;

Procedure SetNorwegianConstants;
begin
  TeeMsg_ZoomInstructions    :='Drag mouse to right-bottom to zoom. To left-top to unzoom.';
  TeeMsg_ScrollInstructions  :='Drag mouse to scroll Chart contents.';
  TeeMsg_DrawLineInstructions:='Drag mouse to draw, select and move lines.';

  TeeMsg_SureToDeleteDataSet :='Are you sure to delete DataSet?';
  TeeMsg_Select              :='Select';
  TeeMsg_EMail               :='e-mail';
  TeeMsg_Open                :='Open';
  TeeMsg_New                 :='New';
  TeeMsg_ImportingWeb        :='Importing from Web: %s';
  TeeMsg_Annotation          :='Annotation';
  TeeMsg_Modified            :='Modified';

  TeeMsg_Next                :='&Next >';
  TeeMsg_OK                  :='OK';
  TeeMsg_Close               :='Close';
  TeeMsg_Go                  :='&Go !';
  TeeMsg_Upload              :='&Upload !';

  TeeMsg_CannotGetVersion    :='Cannot connect to obtain current version.'+#13+
                              'Error: %d %s';

  TeeMsg_CannotGetNewVersion :='Cannot download current version.'+#13+
                              'Error: %d %s';

  TeeMsg_WrongVersion        :='Wrong version number received.';
  TeeMsg_HasLatestVersion    :='You already have the latest version.';
  TeeMsg_ClickToUpdateVersion:='Click the Update button to receive the latest version.';
  TeeMsg_UpdateButton        :='&Update...';
  TeeMsg_WrongZip            :='Wrong version file received.';
  TeeMsg_VersionReceived     :='Latest version received. Click Ok to Install.';

  TeeMsg_SelectFolder        :='Select Folder';
  TeeMsg_EmailNotValid       :='Email address is not correct.';
  TeeMsg_NameNotValid        :='Your Name is empty. Please type your name.';
  TeeMsg_WrongPassword       :='Password is empty. Please type your password or '+#13+
                              'click the Obtain Password button to receive it by e-mail.';
  TeeMsg_WrongChartID        :='Chart name is empty. Please type a Chart name to '+
                              'identify it at the Web Gallery database.';

  TeeMsg_CannotObtainPassword:='Cannot connect to obtain your Password.';
  TeeMsg_PasswordSent        :='Your Password has been sent to your email address.';
  TeeMsg_Congrats            :='Congratulations.'+#13+'You have been included in TeeChart Office '+
                              'Web Charts Gallery user database.'+#13+
                              TeeMsg_PasswordSent;

  TeeMsg_UploadingWeb        :='Uploading %s to Web Gallery...';
  TeeMsg_Uploaded            :='%s has been uploaded to Web Gallery.';

  TeeMsg_TitleEditor         :='Title Editor';
  TeeMsg_EnterValue          :='Enter value';
  TeeMsg_PointWidth          :='Width';
  TeeMsg_PointHeight         :='Height';

  TeeMsg_Position            :='Position: %d,%d';
  TeeMsg_Size                :='Size: %d x %d';

  TeeMsg_BetaWarning         :='Note: '+
                              'This is Pre-Release Software.'+#13+#13+
                              'Some features might be incomplete or'+#13+
                              'removed in the final product version.'+#13+#13+
                              'Submit problems and suggestions at our web site:'+#13+#13+
                              'www.steema.com';

  TeeMsg_Caps               :='CAPS';
  TeeMsg_Num                :='NUM';
  TeeMsg_SCR                :='SCR';
  TeeMsg_SaveAs             :='Save as...';
  TeeMsg_ShouldClose        :='Please close and restart the application.';

  { pending }
  TeeMsg_Table              :='Table';
  TeeMsg_Query              :='Query';
end;

begin
  SetNorwegianConstants;

  if TeeNorwegianLanguage=nil then
  begin
    TeeCreateNorwegian;
    with TeeNorwegianLanguage do ;
  end;

  TeeSetNorwegian;
end;

Procedure TeeOfficeJapanese;

Procedure SetJapaneseConstants;
begin
  TeeMsg_ZoomInstructions    :='Drag mouse to right-bottom to zoom. To left-top to unzoom.';
  TeeMsg_ScrollInstructions  :='Drag mouse to scroll Chart contents.';
  TeeMsg_DrawLineInstructions:='Drag mouse to draw, select and move lines.';

  TeeMsg_SureToDeleteDataSet :='Are you sure to delete DataSet?';
  TeeMsg_Select              :='Select';
  TeeMsg_EMail               :='e-mail';
  TeeMsg_Open                :='Open';
  TeeMsg_New                 :='New';
  TeeMsg_ImportingWeb        :='Importing from Web: %s';
  TeeMsg_Annotation          :='Annotation';
  TeeMsg_Modified            :='Modified';

  TeeMsg_Next                :='&Next >';
  TeeMsg_OK                  :='OK';
  TeeMsg_Close               :='Close';
  TeeMsg_Go                  :='&Go !';
  TeeMsg_Upload              :='&Upload !';

  TeeMsg_CannotGetVersion    :='Cannot connect to obtain current version.'+#13+
                              'Error: %d %s';

  TeeMsg_CannotGetNewVersion :='Cannot download current version.'+#13+
                              'Error: %d %s';

  TeeMsg_WrongVersion        :='Wrong version number received.';
  TeeMsg_HasLatestVersion    :='You already have the latest version.';
  TeeMsg_ClickToUpdateVersion:='Click the Update button to receive the latest version.';
  TeeMsg_UpdateButton        :='&Update...';
  TeeMsg_WrongZip            :='Wrong version file received.';
  TeeMsg_VersionReceived     :='Latest version received. Click Ok to Install.';

  TeeMsg_SelectFolder        :='Select Folder';
  TeeMsg_EmailNotValid       :='Email address is not correct.';
  TeeMsg_NameNotValid        :='Your Name is empty. Please type your name.';
  TeeMsg_WrongPassword       :='Password is empty. Please type your password or '+#13+
                              'click the Obtain Password button to receive it by e-mail.';
  TeeMsg_WrongChartID        :='Chart name is empty. Please type a Chart name to '+
                              'identify it at the Web Gallery database.';

  TeeMsg_CannotObtainPassword:='Cannot connect to obtain your Password.';
  TeeMsg_PasswordSent        :='Your Password has been sent to your email address.';
  TeeMsg_Congrats            :='Congratulations.'+#13+'You have been included in TeeChart Office '+
                              'Web Charts Gallery user database.'+#13+
                              TeeMsg_PasswordSent;

  TeeMsg_UploadingWeb        :='Uploading %s to Web Gallery...';
  TeeMsg_Uploaded            :='%s has been uploaded to Web Gallery.';

  TeeMsg_TitleEditor         :='Title Editor';
  TeeMsg_EnterValue          :='Enter value';
  TeeMsg_PointWidth          :='Width';
  TeeMsg_PointHeight         :='Height';

  TeeMsg_Position            :='Position: %d,%d';
  TeeMsg_Size                :='Size: %d x %d';

  TeeMsg_BetaWarning         :='Note: '+
                              'This is Pre-Release Software.'+#13+#13+
                              'Some features might be incomplete or'+#13+
                              'removed in the final product version.'+#13+#13+
                              'Submit problems and suggestions at our web site:'+#13+#13+
                              'www.steema.com';

  TeeMsg_Caps               :='CAPS';
  TeeMsg_Num                :='NUM';
  TeeMsg_SCR                :='SCR';
  TeeMsg_SaveAs             :='Save as...';
  TeeMsg_ShouldClose        :='Please close and restart the application.';

  { pending }
  TeeMsg_Table              :='Table';
  TeeMsg_Query              :='Query';
end;

begin
  SetJapaneseConstants;

  if TeeJapaneseLanguage=nil then
  begin
    TeeCreateJapanese;
    with TeeJapaneseLanguage do ;
  end;

  TeeSetJapanese;
end;

Procedure TeeOfficePolish;

Procedure SetPolishConstants;
begin
  TeeMsg_ZoomInstructions    :='Przesu� myszk� do g�ry w lewo aby powi�kszy�, a do do�u w prawo aby zmniejszy�.';
  TeeMsg_ScrollInstructions  :='Przesu� myszk� aby przewin�� zawarto�� wykresu.';
  TeeMsg_DrawLineInstructions:='Przesu� myszk� aby rysowa�, wybiera� i przesuwa� linie.';

  TeeMsg_SureToDeleteDataSet :='Jeste� pewien, �e chcesz usun�� �r�d�o danych?';
  TeeMsg_Select              :='Wybierz';
  TeeMsg_EMail               :='e-mail';
  TeeMsg_Open                :='Otw�rz';
  TeeMsg_New                 :='Nowy';
  TeeMsg_ImportingWeb        :='Import z sieci: %s';
  TeeMsg_Annotation          :='Notatka';
  TeeMsg_Modified            :='Zmodyfikowany';

  TeeMsg_Next                :='&Dalej >';
  TeeMsg_OK                  :='OK';
  TeeMsg_Close               :='Zamknij';
  TeeMsg_Go                  :='&Wykonaj !';
  TeeMsg_Upload              :='W&y�lij !';

  TeeMsg_CannotGetVersion    :='Nie mo�na pobra� nowej wersji.'+#13+
                              'B��d: %d %s';

  TeeMsg_CannotGetNewVersion :='Nie mo�na �ci�gn�� be��cej wersji.'+#13+
                              'B��d: %d %s';

  TeeMsg_WrongVersion        :='Odebrano nieprawid�owy numer wersji.';
  TeeMsg_HasLatestVersion    :='Masz ju� najnowsz� wersj�.';
  TeeMsg_ClickToUpdateVersion:='Kliknij klawisz Od�wie� aby pobra� najnowsz� wersj�.';
  TeeMsg_UpdateButton        :='&Od�wie�...';
  TeeMsg_WrongZip            :='Odebrano nieprawid�ow� wersj�.';
  TeeMsg_VersionReceived     :='Odebrano najnowsz� wersj�. Kliknij OK aby zainstalowa�.';

  TeeMsg_SelectFolder        :='Wybierz folder';
  TeeMsg_EmailNotValid       :='Nieprawid�owy adres internetowy.';
  TeeMsg_NameNotValid        :='Brak identyfikatora. Podaj sw�j identyfikator.';
  TeeMsg_WrongPassword       :='Brak has�a. Podaj swoje has�o lub '+#13+
                              'kliknij Pobierz Has�o aby je odebra� przez poczt�.';
  TeeMsg_WrongChartID        :='Brak nazwy wykresu. Podaj nazw� wykresu aby '+
                              'go identyfikowa� w galerii sieciowej.';

  TeeMsg_CannotObtainPassword:='Nie mo�na si� po��czy� aby odebra� has�o.';
  TeeMsg_PasswordSent        :='Has�o zosta�o ci wys�ane na adres email.';
  TeeMsg_Congrats            :='Gratulacje.'+#13+'Zosta�e� wprowadzony do bazy galerii TeeChart '+
                              'sieciowej bazy wykres�w.'+#13+
                              TeeMsg_PasswordSent;

  TeeMsg_UploadingWeb        :='Wysy�anie %s Galerii Wykres�w...';
  TeeMsg_Uploaded            :='%s zosta� wys��ny do Galerii Wykres�w.';

  TeeMsg_TitleEditor         :='Edytor tytu�u';
  TeeMsg_EnterValue          :='Podaj warto��';
  TeeMsg_PointWidth          :='Szeroko��';
  TeeMsg_PointHeight         :='Wysoko��';

  TeeMsg_Position            :='Pozycja: %d,%d';
  TeeMsg_Size                :='Rozmiar: %d x %d';

  TeeMsg_BetaWarning         :='Notatka: '+
                              'To jest wczesna wersja programu.'+#13+#13+
                              'Niekt�re mo�liwo�ci mag� by� niekompletne lub'+#13+
                              'zostan� usuni�te w wersji finalnej.'+#13+#13+
                              'Informuj nas o problemach i sugestiach na naszej stronie:'+#13+#13+
                              'www.steema.com';

  TeeMsg_Caps               :='CAPS';
  TeeMsg_Num                :='NUM';
  TeeMsg_SCR                :='SCR';
  TeeMsg_SaveAs             :='Zapisz jako...';
  TeeMsg_ShouldClose        :='Zamknij i uruchom ponownie Biuro TeeTree.';

  { pending }
  TeeMsg_Table              :='Table';
  TeeMsg_Query              :='Query';
end;

begin
  SetPolishConstants;
  TeeSetPolish;

  if TeeLanguage.IndexOfName('NEW USING WIZARD')=-1 then
  with TeePolishLanguage do
  Text:=Text+
    'FLOWCHART=Wykresy'#13+
    'INSERT=Wstawianie'#13+
    'NODES=W�z�y'#13+
    'DESIGN=Projekt'#13+
    'PREVIEW=Podgl�d'#13+
    'ABOUT TEETREE=O TeeTree'#13+
    'EDITOR TIPS=Porady dla edytora'#13+
    'TEETREE WEB SITE=Strona TeeTree'#13+
    'LINK NODES=Po��czone w�z�y'#13+
    'PRUNE NODES=Roz��czone w�z�y'#13+
    'CLIP TEXT=Obszar tekstu'#13+
    'SHADOW COLOR=Kolor cienia'#13+
    'NEW CHILD=Nowy potomek'#13+
    'NEW BROTHER=Nowy brat'#13+
    'NEW ROOT=Nowy korze�'#13+
    'NEW PARENT=Nowy przodek'#13+
    'CONNECTIONS=Po��czenia'#13+
    'IMAGES=Obrazki'#13+
    'CROSS BOXES=Rozszerzone obszary'#13+
    'EDITOR TABS=Edytor odst�p�w'#13+
    'SHAPE TABS=Edytor kszta�t�w'#13+
    'RULERS=Linijki'#13+
    'TOOLBAR=Pasek narz�dzi'#13+
    'FONT TOOLBAR=Pasek czcionek'#13+
    'BORDER TOOLBAR=Pasek ramek'#13+
    'NODE TREE=Uk�ad w�z��w'#13+
    'CUT=Wytnij'#13+
    'PASTE=Wklej'#13+
    'SEARCH=Szukaj'#13+
    'ALIGN TO GRID=Wyr�wnaj do siatki'#13+
    'IMPORT=Import'#13+
    'NEW TREE=Nowe drzewo'#13+
    'PRINT TREE=Drukuj drzewo'#13+
    'ZOOM IN=Powieksz'#13+
    'ZOOM OUT=Pomniejsz'#13+
    'CONNECT NODES=Po��cz w�z�y'#13+
    'ADD CHILD=Dodaj potomka'#13+
    'ADD BROTHER=Dodaj brata'#13+
    'PRUNE=Roz��cz'#13+
    'BRING TO FRONT=Przesu� na wierzch'#13+
    'SEND TO BACK=Przesu� pod sp�d'#13+
    'ADD NEW ROOT=Dodaj nowy korze�'#13+
    'SHOW NAMES=Pokazuj nazwy'#13+
    'ALIGN TO LEFT=Wyr�wnaj do lewej'#13+
    'AUTO SCROLL=Automat. przewijanie'#13+
    'BORDER STYLE=Styl ramki'#13+
    'BORDER COLOR=Kolor ramki'#13+
    'BORDER WIDTH=Grubo�� ramki'#13+
    'DESIGN MODE=Tryb projektowania'#13+
    'BUFFERED DISPLAY=Buforowanie wy�wietlania'#13+
    'PRINT PANEL=Drukuj panel'#13+
    'ZOOM FROM CENTER=Powi�ksz od �rodka'#13+
    'CROSS BOX=Krzy�yki'#13+
    'SIGN PEN=Znacznik'#13+
    'MODE=Tryb'#13+
    'STRETCHED=Rozci�gaj'#13+
    'ALIGN=Wyr�wnanie'#13+
    'MOUSE=Mysz'#13+
    'ALLOW ZOOM=Pozw�l powi�ksza�'#13+
    'HOTTRACK=�ledzenie'#13+
    'MOUSE WHEEL=Pokr�t�o myszki'#13+
    'SELECT NODES=Wybierz w�z�y'#13+
    'SCROLL VERT.=Przesuw pionowy'#13+
    'SCROLL HORIZ.=Przesuw poziomy'#13+
    'TEXT COLOR=Kolor tekstu'#13+
    'SCROLL TO VIEW=Przesu� na widok'#13+
    'UNFOCUSED COLOR=Kolor nieaktywny'#13+
    'UNFOCUSED BORDER=Ramka nieaktywna'#13+
    'ALLOW DELETE=Pozw�l usuwa�'#13+
    'SINGLE SELECTION=Pojedynczy wyb�r'#13+
    'SCROLL BARS=Paski przesuwu'#13+
    'GRID VISIBLE=Siatka widoczna'#13+
    'SNAP TO GRID=Wyr�wnaj do siatki'#13+
    'SHOW RULERS=Poka� linijki'#13+
    'INTERCHAR SPACING=Odst�p liter'#13+
    'VERT. ALIGN=Wyr�wnanie pionowe'#13+
    'ARROW FROM=Start strza�ki'#13+
    'ARROW TO=Koniec strza�ki'#13+
    'SIDES=Strony'#13+
    'CURVE=Krzywa'#13+
    'CHILDREN CONNECTIONS=Po��czenia'#13+
    'CROSS-BOX=Krzy�yk'#13+
    'HORIZONTAL ALIGNMENT=Wyr�wnanie poziome'#13+
    'DEFAULT IMAGE=Domy�lny obrazek'#13+
    'HORIZONTAL SIZE=Rozmiar poziomy'#13+
    'VERTICAL SIZE=Rozmiar pionowy'#13+
    'MOVE HORIZ=Przesuw poziomy.'#13+
    'MOVE VERT=Przesuw pionowy'#13+
    'EDIT CONNECTION=Edycja po�acze�'#13+
    'DELETE CONNECTION=Usu� po��czenia'#13+
    'ADD NEW POINT=Dodaj punkt'#13+
    'DELETE POINT=Usu� punkt'#13+
    'FIXED=Sta�y'
    ;
end;

Procedure TeeOfficeSlovene;

Procedure SetSloveneConstants;
begin
  TeeMsg_ZoomInstructions    :='Drag mouse to right-bottom to zoom. To left-top to unzoom.';
  TeeMsg_ScrollInstructions  :='Drag mouse to scroll Chart contents.';
  TeeMsg_DrawLineInstructions:='Drag mouse to draw, select and move lines.';

  TeeMsg_SureToDeleteDataSet :='Are you sure to delete DataSet?';
  TeeMsg_Select              :='Select';
  TeeMsg_EMail               :='e-mail';
  TeeMsg_Open                :='Open';
  TeeMsg_New                 :='New';
  TeeMsg_ImportingWeb        :='Importing from Web: %s';
  TeeMsg_Annotation          :='Annotation';
  TeeMsg_Modified            :='Modified';

  TeeMsg_Next                :='&Next >';
  TeeMsg_OK                  :='OK';
  TeeMsg_Close               :='Close';
  TeeMsg_Go                  :='&Go !';
  TeeMsg_Upload              :='&Upload !';

  TeeMsg_CannotGetVersion    :='Cannot connect to obtain current version.'+#13+
                              'Error: %d %s';

  TeeMsg_CannotGetNewVersion :='Cannot download current version.'+#13+
                              'Error: %d %s';

  TeeMsg_WrongVersion        :='Wrong version number received.';
  TeeMsg_HasLatestVersion    :='You already have the latest version.';
  TeeMsg_ClickToUpdateVersion:='Click the Update button to receive the latest version.';
  TeeMsg_UpdateButton        :='&Update...';
  TeeMsg_WrongZip            :='Wrong version file received.';
  TeeMsg_VersionReceived     :='Latest version received. Click Ok to Install.';

  TeeMsg_SelectFolder        :='Select Folder';
  TeeMsg_EmailNotValid       :='Email address is not correct.';
  TeeMsg_NameNotValid        :='Your Name is empty. Please type your name.';
  TeeMsg_WrongPassword       :='Password is empty. Please type your password or '+#13+
                              'click the Obtain Password button to receive it by e-mail.';
  TeeMsg_WrongChartID        :='Chart name is empty. Please type a Chart name to '+
                              'identify it at the Web Gallery database.';

  TeeMsg_CannotObtainPassword:='Cannot connect to obtain your Password.';
  TeeMsg_PasswordSent        :='Your Password has been sent to your email address.';
  TeeMsg_Congrats            :='Congratulations.'+#13+'You have been included in TeeChart Office '+
                              'Web Charts Gallery user database.'+#13+
                              TeeMsg_PasswordSent;

  TeeMsg_UploadingWeb        :='Uploading %s to Web Gallery...';
  TeeMsg_Uploaded            :='%s has been uploaded to Web Gallery.';

  TeeMsg_TitleEditor         :='Title Editor';
  TeeMsg_EnterValue          :='Enter value';
  TeeMsg_PointWidth          :='Width';
  TeeMsg_PointHeight         :='Height';

  TeeMsg_Position            :='Position: %d,%d';
  TeeMsg_Size                :='Size: %d x %d';

  TeeMsg_BetaWarning         :='Note: '+
                              'This is Pre-Release Software.'+#13+#13+
                              'Some features might be incomplete or'+#13+
                              'removed in the final product version.'+#13+#13+
                              'Submit problems and suggestions at our web site:'+#13+#13+
                              'www.steema.com';

  TeeMsg_Caps               :='CAPS';
  TeeMsg_Num                :='NUM';
  TeeMsg_SCR                :='SCR';
  TeeMsg_SaveAs             :='Save as...';
  TeeMsg_ShouldClose        :='Please close and restart the application.';

  { pending }
  TeeMsg_Table              :='Table';
  TeeMsg_Query              :='Query';
end;

begin
  SetSloveneConstants;

  if TeeSloveneLanguage=nil then
  begin
    TeeCreateSlovene;
    with TeeSloveneLanguage do ;
  end;

  TeeSetSlovene;
end;

Procedure TeeOfficeTurkish;

Procedure SetTurkishConstants;
begin
  TeeMsg_ZoomInstructions    :='Drag mouse to right-bottom to zoom. To left-top to unzoom.';
  TeeMsg_ScrollInstructions  :='Drag mouse to scroll Chart contents.';
  TeeMsg_DrawLineInstructions:='Drag mouse to draw, select and move lines.';

  TeeMsg_SureToDeleteDataSet :='Are you sure to delete DataSet?';
  TeeMsg_Select              :='Select';
  TeeMsg_EMail               :='e-mail';
  TeeMsg_Open                :='Open';
  TeeMsg_New                 :='New';
  TeeMsg_ImportingWeb        :='Importing from Web: %s';
  TeeMsg_Annotation          :='Annotation';
  TeeMsg_Modified            :='Modified';

  TeeMsg_Next                :='&Next >';
  TeeMsg_OK                  :='OK';
  TeeMsg_Close               :='Close';
  TeeMsg_Go                  :='&Go !';
  TeeMsg_Upload              :='&Upload !';

  TeeMsg_CannotGetVersion    :='Cannot connect to obtain current version.'+#13+
                              'Error: %d %s';

  TeeMsg_CannotGetNewVersion :='Cannot download current version.'+#13+
                              'Error: %d %s';

  TeeMsg_WrongVersion        :='Wrong version number received.';
  TeeMsg_HasLatestVersion    :='You already have the latest version.';
  TeeMsg_ClickToUpdateVersion:='Click the Update button to receive the latest version.';
  TeeMsg_UpdateButton        :='&Update...';
  TeeMsg_WrongZip            :='Wrong version file received.';
  TeeMsg_VersionReceived     :='Latest version received. Click Ok to Install.';

  TeeMsg_SelectFolder        :='Select Folder';
  TeeMsg_EmailNotValid       :='Email address is not correct.';
  TeeMsg_NameNotValid        :='Your Name is empty. Please type your name.';
  TeeMsg_WrongPassword       :='Password is empty. Please type your password or '+#13+
                              'click the Obtain Password button to receive it by e-mail.';
  TeeMsg_WrongChartID        :='Chart name is empty. Please type a Chart name to '+
                              'identify it at the Web Gallery database.';

  TeeMsg_CannotObtainPassword:='Cannot connect to obtain your Password.';
  TeeMsg_PasswordSent        :='Your Password has been sent to your email address.';
  TeeMsg_Congrats            :='Congratulations.'+#13+'You have been included in TeeChart Office '+
                              'Web Charts Gallery user database.'+#13+
                              TeeMsg_PasswordSent;

  TeeMsg_UploadingWeb        :='Uploading %s to Web Gallery...';
  TeeMsg_Uploaded            :='%s has been uploaded to Web Gallery.';

  TeeMsg_TitleEditor         :='Title Editor';
  TeeMsg_EnterValue          :='Enter value';
  TeeMsg_PointWidth          :='Width';
  TeeMsg_PointHeight         :='Height';

  TeeMsg_Position            :='Position: %d,%d';
  TeeMsg_Size                :='Size: %d x %d';

  TeeMsg_BetaWarning         :='Note: '+
                              'This is Pre-Release Software.'+#13+#13+
                              'Some features might be incomplete or'+#13+
                              'removed in the final product version.'+#13+#13+
                              'Submit problems and suggestions at our web site:'+#13+#13+
                              'www.steema.com';

  TeeMsg_Caps               :='CAPS';
  TeeMsg_Num                :='NUM';
  TeeMsg_SCR                :='SCR';
  TeeMsg_SaveAs             :='Save as...';
  TeeMsg_ShouldClose        :='Please close and restart the application.';

  { pending }
  TeeMsg_Table              :='Table';
  TeeMsg_Query              :='Query';
end;

begin
  SetTurkishConstants;

  if TeeTurkishLanguage=nil then
  begin
    TeeCreateTurkish;
    with TeeTurkishLanguage do ;
  end;

  TeeSetTurkish;
end;

Procedure TeeOfficeHungarian;

Procedure SetHungarianConstants;
begin
  TeeMsg_ZoomInstructions    :='Drag mouse to right-bottom to zoom. To left-top to unzoom.';
  TeeMsg_ScrollInstructions  :='Drag mouse to scroll Chart contents.';
  TeeMsg_DrawLineInstructions:='Drag mouse to draw, select and move lines.';

  TeeMsg_SureToDeleteDataSet :='Are you sure to delete DataSet?';
  TeeMsg_Select              :='Select';
  TeeMsg_EMail               :='e-mail';
  TeeMsg_Open                :='Open';
  TeeMsg_New                 :='New';
  TeeMsg_ImportingWeb        :='Importing from Web: %s';
  TeeMsg_Annotation          :='Annotation';
  TeeMsg_Modified            :='Modified';

  TeeMsg_Next                :='&Next >';
  TeeMsg_OK                  :='OK';
  TeeMsg_Close               :='Close';
  TeeMsg_Go                  :='&Go !';
  TeeMsg_Upload              :='&Upload !';

  TeeMsg_CannotGetVersion    :='Cannot connect to obtain current version.'+#13+
                              'Error: %d %s';

  TeeMsg_CannotGetNewVersion :='Cannot download current version.'+#13+
                              'Error: %d %s';

  TeeMsg_WrongVersion        :='Wrong version number received.';
  TeeMsg_HasLatestVersion    :='You already have the latest version.';
  TeeMsg_ClickToUpdateVersion:='Click the Update button to receive the latest version.';
  TeeMsg_UpdateButton        :='&Update...';
  TeeMsg_WrongZip            :='Wrong version file received.';
  TeeMsg_VersionReceived     :='Latest version received. Click Ok to Install.';

  TeeMsg_SelectFolder        :='Select Folder';
  TeeMsg_EmailNotValid       :='Email address is not correct.';
  TeeMsg_NameNotValid        :='Your Name is empty. Please type your name.';
  TeeMsg_WrongPassword       :='Password is empty. Please type your password or '+#13+
                              'click the Obtain Password button to receive it by e-mail.';
  TeeMsg_WrongChartID        :='Chart name is empty. Please type a Chart name to '+
                              'identify it at the Web Gallery database.';

  TeeMsg_CannotObtainPassword:='Cannot connect to obtain your Password.';
  TeeMsg_PasswordSent        :='Your Password has been sent to your email address.';
  TeeMsg_Congrats            :='Congratulations.'+#13+'You have been included in TeeChart Office '+
                              'Web Charts Gallery user database.'+#13+
                              TeeMsg_PasswordSent;

  TeeMsg_UploadingWeb        :='Uploading %s to Web Gallery...';
  TeeMsg_Uploaded            :='%s has been uploaded to Web Gallery.';

  TeeMsg_TitleEditor         :='Title Editor';
  TeeMsg_EnterValue          :='Enter value';
  TeeMsg_PointWidth          :='Width';
  TeeMsg_PointHeight         :='Height';

  TeeMsg_Position            :='Position: %d,%d';
  TeeMsg_Size                :='Size: %d x %d';

  TeeMsg_BetaWarning         :='Note: '+
                              'This is Pre-Release Software.'+#13+#13+
                              'Some features might be incomplete or'+#13+
                              'removed in the final product version.'+#13+#13+
                              'Submit problems and suggestions at our web site:'+#13+#13+
                              'www.steema.com';

  TeeMsg_Caps               :='CAPS';
  TeeMsg_Num                :='NUM';
  TeeMsg_SCR                :='SCR';
  TeeMsg_SaveAs             :='Save as...';

  { pending }
  TeeMsg_Table              :='Table';
  TeeMsg_Query              :='Query';
end;

begin
  SetHungarianConstants;

  if TeeHungarianLanguage=nil then
  begin
    TeeCreateHungarian;
    with TeeHungarianLanguage do ;
  end;

  TeeSetHungarian;
end;
     
initialization
  SetEnglishConstants;
end.
