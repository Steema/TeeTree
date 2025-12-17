//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("DclTree2C5Tee9.res");
USEPACKAGE("TeeTree2C5Tee9.bpi");
USEUNIT("TreeReg.pas");
USEUNIT("TreeDBReg.pas");
USEPACKAGE("vcl50.bpi");
USEPACKAGE("Vcldb50.bpi");
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------

//   Package source.
//---------------------------------------------------------------------------

#pragma argsused
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
        return 1;
}
//---------------------------------------------------------------------------
