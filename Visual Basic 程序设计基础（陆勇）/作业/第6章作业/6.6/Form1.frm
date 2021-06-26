VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   4815
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   9810
   LinkTopic       =   "Form1"
   ScaleHeight     =   4815
   ScaleWidth      =   9810
   StartUpPosition =   3  '窗口缺省
   Begin VB.Timer Timer2 
      Left            =   360
      Top             =   3720
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Start"
      Height          =   495
      Left            =   6960
      TabIndex        =   1
      Top             =   1080
      Width           =   1215
   End
   Begin VB.Timer Timer1 
      Enabled         =   0   'False
      Interval        =   1000
      Left            =   8040
      Top             =   3480
   End
   Begin VB.Label Label1 
      Caption         =   "0"
      BeginProperty Font 
         Name            =   "宋体"
         Size            =   42
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1695
      Left            =   2640
      TabIndex        =   0
      Top             =   720
      Width           =   2175
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Command1_Click()
Timer2.Interval = InputBox("设置时钟触发代码的时间(毫秒)")
Timer1.Enabled = True
End Sub

Private Sub Form_Load()
Dim s As String

s = Str(0)
 Label1.Caption = s
End Sub

Private Sub Timer1_Timer()
Dim s As String
Dim a As Integer
s = Label1.Caption
a = Val(s)
a = a + 1
s = Str(a)
Label1.Caption = s
End Sub

Private Sub Timer2_Timer()
 Beep
 Timer1.Enabled = False
End Sub
