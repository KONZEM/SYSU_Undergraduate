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
   Begin VB.Timer Timer1 
      Left            =   840
      Top             =   480
   End
   Begin VB.TextBox Text1 
      BackColor       =   &H00000000&
      BeginProperty Font 
         Name            =   "宋体"
         Size            =   36
         Charset         =   134
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF00FF&
      Height          =   870
      Left            =   4680
      TabIndex        =   0
      Text            =   "古诗选读"
      Top             =   2040
      Width           =   3015
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Declare Sub sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

Private Sub Form_Load()
Form1.Height = 10000
Form1.Width = 15000
Text1.Locked = True
Text1.Left = (Form1.Width - Text1.Width) / 2
Text1.Top = (Form1.Height - Text1.Height) / 2 - 1000
Timer1.Interval = 2000
End Sub

Private Sub Timer1_Timer()
Form1.Hide
Form2.Show
Timer1.Enabled = False
End Sub
