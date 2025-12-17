//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("TeeTree2C5Tee9.res");
USEPACKAGE("vcl50.bpi");
USEFORMNS("TreeEd.pas", Treeed, TreeEditor);
USEUNIT("TeeTree.pas");
USEFORMNS("TreeCoEd.pas", Treecoed, ConnectionEditor);
USEUNIT("TeeDBTre.pas");
USEUNIT("TreeFlow.pas");
USEFORMNS("TreeShEd.pas", Treeshed, NodeTreeEditor);
USEFORMNS("TreeTeEd.pas", Treeteed, FormTeeText);
USEUNIT("TreeChildManagers.pas");
USEUNIT("TeeRecentFiles.pas");
USEUNIT("TreeAnimate.pas");
USEFORMNS("TreeAnimateEditor.pas", Treeanimateeditor, TreeAnimateEditor);
USEFORMNS("TreeAnimationGallery.pas", Treeanimationgallery, AnimationGallery);
USEUNIT("TeeOfficeConstants.pas");
USEUNIT("TreeConst.pas");
USEFORMNS("TreeDBEd.pas", Treedbed, FormDBTree);
USEUNIT("TreeElectric.pas");
USEUNIT("TreeExport.pas");
USEUNIT("TreeNavigator.pas");
USEUNIT("TreeTransit.pas");
USEUNIT("TreeUML.pas");
USEPACKAGE("TeeLanguage9C5.bpi");
USEPACKAGE("Vcldb50.bpi");
USEPACKAGE("Tee9C5.bpi");
USEPACKAGE("TeeUI9C5.bpi");
USEPACKAGE("TeePro9C5.bpi");
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
