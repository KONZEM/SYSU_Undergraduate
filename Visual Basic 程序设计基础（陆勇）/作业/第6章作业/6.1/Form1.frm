VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   5820
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   11175
   LinkTopic       =   "Form1"
   ScaleHeight     =   5820
   ScaleWidth      =   11175
   StartUpPosition =   3  '窗口缺省
   Begin VB.TextBox Text1 
      Height          =   2175
      Left            =   2160
      MultiLine       =   -1  'True
      TabIndex        =   0
      Top             =   2880
      Width           =   6615
   End
   Begin VB.Image Image3 
      Height          =   1095
      Left            =   4080
      Picture         =   "Form1.frx":0000
      Stretch         =   -1  'True
      Top             =   720
      Width           =   975
   End
   Begin VB.Image Image4 
      Height          =   1035
      Left            =   6960
      Picture         =   "Form1.frx":D4D3
      Stretch         =   -1  'True
      Top             =   720
      Width           =   960
   End
   Begin VB.Image Image2 
      Height          =   1035
      Left            =   2640
      Picture         =   "Form1.frx":19DF0
      Stretch         =   -1  'True
      Top             =   720
      Width           =   960
   End
   Begin VB.Image Image1 
      Height          =   1035
      Left            =   5520
      Picture         =   "Form1.frx":21A53
      Stretch         =   -1  'True
      Top             =   720
      Width           =   960
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Image1_Click()
Text1.Text = ""
Text1.Text = "单击向上箭头"
End Sub

Private Sub Image2_Click()
Text1.Text = ""
Text1.Text = "单击向下箭头"

End Sub

Private Sub Image3_Click()
Text1.Text = ""
Text1.Text = "单击向左箭头"
End Sub

Private Sub Image4_Click()

Text1.Text = ""
Text1.Text = "单击向右箭头"
End Sub
