//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#pragma link "UTreeOffice"
USERES("TeeTreeOffice.res");
USEFORMNS("UTreeOffice.pas", Utreeoffice, TreeEditor1);
USEFORMNS("TeeNewDataSet.pas", Teenewdataset, NewDataSet);
USEFORMNS("TreeEd.pas", Treeed, TreeEditor);
//---------------------------------------------------------------------------
WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int)
{
        try
        {
          TTreeEditor1 *TreeEditor1;

                 Application->Initialize();
  		 Application->HelpFile = "TeeTreeOffice.hlp";
                 Application->Title = "TeeTree Office";
                 Application->CreateForm(__classid(TTreeEditor1), &TreeEditor1);
                 Application->Run();
        }
        catch (Exception &exception)
        {
                 Application->ShowException(&exception);
        }
        return 0;
}
//---------------------------------------------------------------------------
