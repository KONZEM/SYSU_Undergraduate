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
   StartUpPosition =   3  '����ȱʡ
   Begin VB.CommandButton Command2 
      Caption         =   "����"
      BeginProperty Font 
         Name            =   "����"
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
      Caption         =   "����"
      BeginProperty Font 
         Name            =   "����"
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
         Name            =   "����"
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
Text1.Text = "    �ƺ�¥" & Chr(13) & Chr(10) & "�����ѳ˻ƺ�ȥ��" & Chr(13) & Chr(10) & "�˵ؿ���ƺ�¥��" & Chr(13) & Chr(10) & _
"�ƺ�һȥ��������" & Chr(13) & Chr(10) & "����ǧ�ؿ����ơ�" & Chr(13) & Chr(10) & "�紨������������" & Chr(13) & Chr(10) & _
"�������������ޡ�" & Chr(13) & Chr(10) & "��ĺ��غδ��ǣ�" & Chr(13) & Chr(10) & "�̲�����ʹ�˳"
End Sub

