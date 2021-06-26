VERSION 5.00
Begin VB.Form Form4 
   Caption         =   "Form4"
   ClientHeight    =   3015
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   4560
   BeginProperty Font 
      Name            =   "宋体"
      Size            =   26.25
      Charset         =   134
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form4"
   ScaleHeight     =   3015
   ScaleWidth      =   4560
   StartUpPosition =   3  '窗口缺省
   Begin VB.CommandButton Command2 
      Caption         =   "结束"
      BeginProperty Font 
         Name            =   "楷体"
         Size            =   26.25
         Charset         =   134
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   900
      Left            =   8000
      TabIndex        =   2
      Top             =   3000
      Width           =   1450
   End
   Begin VB.CommandButton Command1 
      Caption         =   "返回"
      BeginProperty Font 
         Name            =   "楷体"
         Size            =   26.25
         Charset         =   134
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   900
      Left            =   8000
      TabIndex        =   1
      Top             =   500
      Width           =   1450
   End
   Begin VB.TextBox Text1 
      BeginProperty Font 
         Name            =   "楷体"
         Size            =   26.25
         Charset         =   134
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   3500
      Left            =   2000
      MultiLine       =   -1  'True
      TabIndex        =   0
      Top             =   480
      Width           =   5985
   End
End
Attribute VB_Name = "Form4"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
Form4.Hide
Form2.Show
End Sub

Private Sub Command2_Click()
End
End Sub

Private Sub Form_Load()
Form4.Height = 10000
Form4.Width = 15000
Text1.Locked = True
Text1.Text = "黄鹤楼送孟浩然之广陵" & Chr(13) & Chr(10) & "故人西辞黄鹤楼，" & Chr(13) & Chr(10) & "烟花三月下扬州，" & Chr(13) & Chr(10) & _
"孤帆远影碧空尽，" & Chr(13) & Chr(10) & "惟见长江天际流。"
End Sub

