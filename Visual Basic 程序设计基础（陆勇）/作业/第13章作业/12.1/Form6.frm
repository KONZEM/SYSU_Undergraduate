VERSION 5.00
Begin VB.Form Form6 
   Caption         =   "Form6"
   ClientHeight    =   3015
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   4560
   LinkTopic       =   "Form6"
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
      Left            =   2040
      MultiLine       =   -1  'True
      TabIndex        =   0
      Top             =   480
      Width           =   5500
   End
End
Attribute VB_Name = "Form6"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub Command1_Click()
Form6.Hide
Form2.Show
End Sub

Private Sub Command2_Click()
End
End Sub

Private Sub Form_Load()
Form6.Height = 10000
Form6.Width = 15000
Text1.Locked = True
Text1.Text = "    蜀相" & Chr(13) & Chr(10) & "丞相祠堂何处寻，" & Chr(13) & Chr(10) & "锦官城外柏森森。" & Chr(13) & Chr(10) & _
"映阶碧草自春色，" & Chr(13) & Chr(10) & "隔叶黄鹂空好音。" & Chr(13) & Chr(10) & "三顾频烦天下计，" & Chr(13) & Chr(10) & _
"两朝开济老臣心。" & Chr(13) & Chr(10) & "出师未捷身先死，" & Chr(13) & Chr(10) & "长使英雄泪满襟。"
End Sub

