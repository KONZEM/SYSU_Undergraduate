VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   4665
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   8775
   LinkTopic       =   "Form1"
   ScaleHeight     =   4665
   ScaleWidth      =   8775
   StartUpPosition =   3  '窗口缺省
   Begin VB.TextBox Text1 
      Height          =   495
      IMEMode         =   3  'DISABLE
      Left            =   3960
      PasswordChar    =   "*"
      TabIndex        =   3
      Top             =   720
      Width           =   3015
   End
   Begin VB.CommandButton Command3 
      Caption         =   "结束"
      Height          =   615
      Left            =   720
      TabIndex        =   2
      Top             =   2760
      Width           =   1575
   End
   Begin VB.CommandButton Command2 
      Caption         =   "检查口令"
      Height          =   615
      Left            =   720
      TabIndex        =   1
      Top             =   1680
      Width           =   1575
   End
   Begin VB.CommandButton Command1 
      Caption         =   "开始"
      Height          =   615
      Left            =   720
      TabIndex        =   0
      Top             =   600
      Width           =   1575
   End
   Begin VB.Image Image1 
      Height          =   1095
      Left            =   4320
      Stretch         =   -1  'True
      Top             =   2400
      Width           =   2295
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Command1_Click()
Text1.Text = ""
Text1.SetFocus

End Sub

Private Sub Command2_Click()
If (Text1.Text = "123456") Then
 Image1.Picture = LoadPicture(App.Path & "\1.jpg")
 Else
  MsgBox ("口令不对，请重新输入")
  End If
End Sub

Private Sub Command3_Click()
End
End Sub

