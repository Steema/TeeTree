//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USEFORMNS("TreeEd.pas", Treeed, TreeEditor);
USEFORMNS("TreeCoEd.pas", Treecoed, ConnectionEditor);
USEFORMNS("TreeShEd.pas", Treeshed, NodeTreeEditor);
USEFORMNS("TreeTeEd.pas", Treeteed, FormTeeText);
USEFORMNS("TreeAnimateEditor.pas", Treeanimateeditor, TreeAnimateEditor);
USEFORMNS("TreeAnimationGallery.pas", Treeanimationgallery, AnimationGallery);
USEFORMNS("TreeDBEd.pas", Treedbed, FormDBTree);
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
