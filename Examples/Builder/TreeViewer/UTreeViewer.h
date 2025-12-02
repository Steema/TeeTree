//---------------------------------------------------------------------------

#ifndef UTreeViewerH
#define UTreeViewerH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "TeeTree.hpp"
#include "TreeAnimate.hpp"
#include <Buttons.hpp>
#include <Dialogs.hpp>
#include <ExtCtrls.hpp>
#include <TeeProcs.hpp>
//---------------------------------------------------------------------------
class TViewer : public TForm
{
__published:	// IDE-managed Components
        TPanel *Panel1;
        TSpeedButton *SBOpen;
        TSpeedButton *ButtonPrint;
        TSpeedButton *ButtonPrintPreview;
        TBevel *Bevel1;
        TSpeedButton *SBGrid;
        TSpeedButton *SpeedButton2;
        TSpeedButton *SBScroll;
        TBevel *Bevel2;
        TTree *Tree1;
        TTreeAnimate *TreeAnimate1;
        TOpenDialog *OpenDialog1;

        void __fastcall SBOpenClick(TObject *Sender);
        void __fastcall FormShow(TObject *Sender);
        void __fastcall ButtonPrintPreviewClick(TObject *Sender);
        void __fastcall ButtonPrintClick(TObject *Sender);
        void __fastcall SBGridClick(TObject *Sender);
        void __fastcall SpeedButton2Click(TObject *Sender);
        void __fastcall SBScrollClick(TObject *Sender);
private:	// User declarations
        void LoadTree(const String FileName);
        void ResetTree();
public:		// User declarations
        __fastcall TViewer(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TViewer *Viewer;
//---------------------------------------------------------------------------

void TreePrintDialog(TCustomTree *Tree);
void TreePreview( TComponent *AOwner, TCustomTree *Tree, bool PrintPanel=False);

void InitializeUnit();
void FinalizeUnit();

#endif
