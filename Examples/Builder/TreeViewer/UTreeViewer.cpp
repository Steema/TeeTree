//---------------------------------------------------------------------------

#include <vcl.h>

#pragma hdrstop

#include "UTreeViewer.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "TeeTree"
#pragma link "TreeAnimate"

#pragma link "TreeFlow"
#pragma link "TreeElectric"
#pragma link "TreeUML"
#pragma link "TreeTransit"

#include <TreeNavigator.hpp>
#include <TeePrevi.hpp>
#include <TreeFlow.hpp>
#include <TreeElectric.hpp>
#include <TreeUML.hpp>
#include <TreeTransit.hpp>
#include <TeeAbout.hpp>
#include <TreeConst.hpp>

#pragma resource "*.dfm"
#pragma resource "TreeLogo.res"

TViewer *Viewer;
//---------------------------------------------------------------------------
__fastcall TViewer::TViewer(TComponent* Owner)
        : TForm(Owner)
{
}

//---------------------------------------------------------------------------
void TViewer::ResetTree()
{
  TTree *tmpEmpty;
  Tree1->Clear();

  /* Create an empty Tree */
  tmpEmpty = new TTree(Unassigned);
  try
  {
    /* Assign empty to current */
    Tree1->Assign(tmpEmpty);
  }
  __finally
  {
    tmpEmpty->Free();
  }
}

//---------------------------------------------------------------------------
void TViewer::LoadTree(const String FileName)
{
  LoadTreeFromFile(Tree1,FileName);
  SBGrid->Down=Tree1->Grid->Visible;  // <-- AV
}

//---------------------------------------------------------------------------
void __fastcall TViewer::SBOpenClick(TObject *Sender)
{
  if (OpenDialog1->Execute()) {
    ResetTree();
    LoadTree(OpenDialog1->FileName);
  }
}
//---------------------------------------------------------------------------

void __fastcall TViewer::FormShow(TObject *Sender)
{
  if (ParamCount()>0){
   LoadTree(ParamStr(1));
  }
}
//---------------------------------------------------------------------------

// Show TeeTree Print Preview dialog.
void TreePreview( TComponent *AOwner, TCustomTree *Tree, bool PrintPanel)
{
  bool OldPrintTeePanel;
  bool OldChange;
  TChartPreview *tmpChartPreview;

  OldPrintTeePanel=PrintTeePanel;
  PrintTeePanel=PrintPanel;
  OldChange=TeeChangePaperOrientation;
  TeeChangePaperOrientation=False;
  try
  {
    tmpChartPreview = new TChartPreview(AOwner);
    try
    {
      tmpChartPreview->PageNavigatorClass=__classid(TTreePageNavigator);
      tmpChartPreview->TeePreviewPanel1->Panel=Tree; // <-- EList error when a Tree is shown
      tmpChartPreview->ShowModal();
    }
    __finally
    {
      tmpChartPreview->Free();
      Tree->Invalidate();
    }
  }
  __finally
  {
    TeeChangePaperOrientation=OldChange;
    PrintTeePanel=OldPrintTeePanel;
  }
}

//---------------------------------------------------------------------------


void __fastcall TViewer::ButtonPrintPreviewClick(TObject *Sender)
{
  bool tmpOld;
  tmpOld=Tree1->Grid->Visible;  // <-- AV
  Tree1->Grid->Visible=False;   // <-- AV
  try
  {
    ::TreePreview(this,Tree1);
  }
  __finally
  {
    Tree1->Grid->Visible=tmpOld; // <-- AV
  }
}

//---------------------------------------------------------------------------
void TreePrintDialog(TCustomTree *Tree)
{
  int t;
  TPrintDialog *tmpPrintDialog;
  tmpPrintDialog = new TPrintDialog(NULL);
  try
  {
    if (Tree->Page->Count>1) {                             // <-- AV
      tmpPrintDialog->Options<<poPageNums;
      tmpPrintDialog->MinPage=1;
      tmpPrintDialog->MaxPage=Tree->Page->Count;
      tmpPrintDialog->FromPage=tmpPrintDialog->MinPage;
      tmpPrintDialog->ToPage=tmpPrintDialog->MaxPage;
    };

    if (tmpPrintDialog->Execute()) {
       for (t=1; t<tmpPrintDialog->Copies+1; t++) {
         Tree->Print();
       }
    }
  }
  __finally
  {
    tmpPrintDialog->Free();
  }
}

//---------------------------------------------------------------------------
void __fastcall TViewer::ButtonPrintClick(TObject *Sender)
{
  ::TreePrintDialog(Tree1);
}
//---------------------------------------------------------------------------

void __fastcall TViewer::SBGridClick(TObject *Sender)
{
  Tree1->Grid->Visible=SBGrid->Down; // <-- AV
}
//---------------------------------------------------------------------------

void __fastcall TViewer::SpeedButton2Click(TObject *Sender)
{
  TTeeAboutForm *Dialog;
  Dialog = new TTeeAboutForm(Application);
  try
  {
    Dialog->LabelVersion->Caption=TreeMsg_TeeTree;
    Dialog->Caption=Format(TreeMsg_About,ARRAYOFCONST((TreeMsg_TeeTree)));
    Dialog->Image1->Picture->Bitmap->LoadFromResourceName((int)HInstance,(AnsiString)"TREELOGOBMP");
    Dialog->ShowModal();
  }
  __finally
  {
    Dialog->Free();
  }
}
//---------------------------------------------------------------------------

void __fastcall TViewer::SBScrollClick(TObject *Sender)
{
  if (SBScroll->Down) {
    Tree1->ScrollMouseButton=mbLeft;
    Tree1->Zoom->MouseButton=mbRight;  // <-- AV
  }
  else {
    Tree1->ScrollMouseButton=mbRight;
    Tree1->Zoom->MouseButton=mbLeft;   // <-- AV
  };
}



//---------------------------------------------------------------
void InitializeUnit(void)
{
  RegisterCustomTreeShape("Standard","Polygon",__classid(TPolygonShape));
  RegisterCustomTreeShape("Standard","PolyLine",__classid(TPolyLineShape));
  RegisterCustomTreeShape("Standard","Image",__classid(TImageShape));
  RegisterCustomTreeShape("Standard","Text",__classid(TTextShape));
} // end of InitCodeGeneration()

//---------------------------------------------------------------
void FinalizeUnit(void)
{
  TComponentClass custshapes[4] = {__classid(TPolygonShape),
                                   __classid(TPolyLineShape),
                                   __classid(TImageShape),
                                   __classid(TTextShape)};

  UnRegisterCustomTreeShapes(custshapes,3);
} // end of DoneCodeGeneration()

#pragma startup InitializeUnit 64
#pragma exit FinalizeUnit 64
