VERSION 5.00
Begin VB.Form Form5 
   Caption         =   "Form5"
   ClientHeight    =   3015
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   4560
   LinkTopic       =   "Form5"
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
      Top             =   500
      Width           =   5500
   End
End
Attribute VB_Name = "Form5"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
Form5.Hide
Form2.Show
End Sub

Private Sub Command2_Click()
End
End Sub

Private Sub Form_Load()
Form5.Height = 10000
Form5.Width = 15000
Text1.Locked = True
Text1.Text = "    黄鹤楼" & Chr(13) & Chr(10) & "昔人已乘黄鹤去，" & Chr(13) & Chr(10) & "此地空余黄鹤楼。" & Chr(13) & Chr(10) & _
"黄鹤一去不复返，" & Chr(13) & Chr(10) & "白云千载空悠悠。" & Chr(13) & Chr(10) & "晴川历历汉阳树，" & Chr(13) & Chr(10) & _
"芳草萋萋鹦鹉洲。" & Chr(13) & Chr(10) & "日暮乡关何处是？" & Chr(13) & Chr(10) & "烟波江上使人愁。"
End Sub

