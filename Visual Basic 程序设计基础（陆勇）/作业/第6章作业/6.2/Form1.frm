VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   5355
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   13125
   LinkTopic       =   "Form1"
   ScaleHeight     =   5355
   ScaleWidth      =   13125
   StartUpPosition =   3  '窗口缺省
   Begin VB.CommandButton Command1 
      Caption         =   "start"
      Height          =   855
      Left            =   5280
      TabIndex        =   3
      Top             =   3480
      Width           =   2415
   End
   Begin VB.TextBox Text3 
      Height          =   1455
      Left            =   8520
      TabIndex        =   2
      Top             =   1080
      Width           =   3015
   End
   Begin VB.TextBox Text2 
      Height          =   1455
      Left            =   4560
      TabIndex        =   1
      Top             =   1080
      Width           =   3135
   End
   Begin VB.TextBox Text1 
      Height          =   1455
      Left            =   840
      TabIndex        =   0
      Top             =   1080
      Width           =   2895
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Command1_Click()
Dim s As String
 s = InputBox("请输入一些英文字母")
 Text1.Text = s
End Sub

Private Sub Text1_Change()
    's = Text1.Text
    Text2.Text = UCase(Text1.Text)
    Text3.Text = LCase(Text1.Text)
End Sub
