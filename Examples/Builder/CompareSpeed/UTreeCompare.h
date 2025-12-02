//---------------------------------------------------------------------------

#ifndef UTreeCompareH
#define UTreeCompareH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "TeeTree.hpp"
#include <ComCtrls.hpp>
#include <ExtCtrls.hpp>
#include <TeeProcs.hpp>
//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
        TLabel *Label1;
        TLabel *Label2;
        TLabel *Label5;
        TLabel *Label6;
        TTreeView *TreeView1;
        TButton *Button1;
        TButton *Button2;
        TButton *Button3;
        TButton *Button4;
        TCheckBox *CheckBox1;
        TCheckBox *CheckBox2;
        TButton *Button5;
        TTree *Tree1;
        void __fastcall Button1Click(TObject *Sender);
        void __fastcall Button2Click(TObject *Sender);
        void __fastcall Button3Click(TObject *Sender);
        void __fastcall Button4Click(TObject *Sender);
        void __fastcall Button5Click(TObject *Sender);
private:	// User declarations
        void Test(int NumNodes);
        int AddTeeTree(int NumNodes);
        int AddTreeView(int NumNodes);

public:		// User declarations
        __fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
