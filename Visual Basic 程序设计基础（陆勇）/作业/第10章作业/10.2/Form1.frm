VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3015
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   4560
   LinkTopic       =   "Form1"
   ScaleHeight     =   3015
   ScaleWidth      =   4560
   StartUpPosition =   3  '窗口缺省
   Begin VB.TextBox Text1 
      Height          =   1215
      Left            =   960
      TabIndex        =   0
      Text            =   "Text1"
      Top             =   600
      Width           =   2055
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Form_Load()
Text1.Text = ""
End Sub

Private Sub Text1_KeyDown(KeyCode As Integer, Shift As Integer)
If Shift = 5 And KeyCode = &H75 Then Print "再见！"
End Sub
