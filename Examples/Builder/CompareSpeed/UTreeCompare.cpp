//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "UTreeCompare.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "TeeTree"
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
        : TForm(Owner)
{
}

//---------------------------------------------------------------------------
void TForm1::Test(int NumNodes)
{
  Screen->Cursor=crHourGlass;
  try
  {
    if (CheckBox1->Checked) {
       Label5->Caption="Testing...";
    }
    else {
       Label5->Caption="(not tested)";
    };
    if (CheckBox2->Checked) {
       Label6->Caption="Testing...";
    }
    else {
       Label6->Caption="(not tested)";
    };

    Label5->Update();
    Label6->Update();

    if (CheckBox1->Checked) {
      Label5->Caption=IntToStr(AddTeeTree(NumNodes))+" msec";
      Label5->Update();
    };

    if (CheckBox2->Checked) {
      Label6->Caption=IntToStr(AddTreeView(NumNodes))+" msec";
      Label6->Update();
    };
  }
  __finally
  {
    Screen->Cursor=crDefault;
  }
}

//---------------------------------------------------------------------------
int TForm1::AddTeeTree(int NumNodes)
{
  int t1,t2,t;
  TTreeNodeShape *Root;

  Tree1->Clear();

  t1=GetTickCount();

  Tree1->GlobalFormat.Border->Visible=False;   // <---
  Tree1->GlobalFormat.Transparent=True;
  Tree1->GlobalFormat.ImageIndex=tiNone;
  Tree1->GlobalFormat.Connection->ArrowTo->Style=casNone;  // <---

  // add nodes
  Tree1->BeginUpdate();

  Root = Tree1->AddRoot("Root");
  for (int t=1; t<NumNodes+1; t++)
  {
    Root->AddChild("Node "+IntToStr(t));
  }

  Tree1->EndUpdate();

  t2=GetTickCount();

  return (t2-t1);
}

//---------------------------------------------------------------------------
int TForm1::AddTreeView(int NumNodes)
{
  int t1,t2,t;
  TTreeNode *Root;

  TreeView1->Items->BeginUpdate();
  TreeView1->Items->Clear();
  TreeView1->Items->EndUpdate();

  t1=GetTickCount();

  TreeView1->Items->BeginUpdate();
  Root=TreeView1->Items->Add(NULL,"Root");
  for (int t=1; t<NumNodes+1; t++)
  {
    TreeView1->Items->AddChild(Root,"Node "+IntToStr(t));
  }
  TreeView1->Items->EndUpdate();

  t2=GetTickCount();
  return (t2-t1);

}

//---------------------------------------------------------------------------
void __fastcall TForm1::Button1Click(TObject *Sender)
{
  Test(5000);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Button2Click(TObject *Sender)
{
  Test(10000);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Button3Click(TObject *Sender)
{
  Test(50000);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Button4Click(TObject *Sender)
{
  Cardinal t1,t2;
  // Add 10000 nodes so we can Clear them later.
  Test(10000);

  // Clear TeeTree
  t1=GetTickCount();
  Tree1->Clear();
  t2=GetTickCount();
  Label5->Caption=IntToStr(t2-t1)+ " msec";

  // Clear TreeView
  t1=GetTickCount();
  TreeView1->Items->BeginUpdate();
  TreeView1->Items->Clear();
  TreeView1->Items->EndUpdate();
  t2=GetTickCount();
  Label6->Caption=IntToStr(t2-t1)+" msec";
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Button5Click(TObject *Sender)
{
  Close();
}
//---------------------------------------------------------------------------
