VERSION 5.00
Begin VB.Form Form3 
   Caption         =   "Form3"
   ClientHeight    =   3015
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   4560
   BeginProperty Font 
      Name            =   "����"
      Size            =   26.25
      Charset         =   134
      Weight          =   700
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form3"
   ScaleHeight     =   3015
   ScaleWidth      =   4560
   StartUpPosition =   3  '����ȱʡ
   Begin VB.CommandButton Command2 
      Caption         =   "����"
      Height          =   900
      Left            =   8000
      TabIndex        =   2
      Top             =   3000
      Width           =   1450
   End
   Begin VB.CommandButton Command1 
      Caption         =   "����"
      Height          =   900
      Left            =   8000
      TabIndex        =   1
      Top             =   480
      Width           =   1450
   End
   Begin VB.TextBox Text1 
      Height          =   3500
      Left            =   2000
      MultiLine       =   -1  'True
      TabIndex        =   0
      Top             =   480
      Width           =   5500
   End
End
Attribute VB_Name = "Form3"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
Form3.Hide
Form2.Show
End Sub

Private Sub Command2_Click()
End
End Sub

Private Sub Form_Load()
Form3.Height = 10000
Form3.Width = 15000
Text1.Locked = True
Text1.Text = "   ������ɽ" & Chr(13) & Chr(10) & "�����жϳ�������" & Chr(13) & Chr(10) & "��ˮ�������˻ء�" & Chr(13) & Chr(10) & _
"������ɽ��Գ���" & Chr(13) & Chr(10) & "�·�һƬ�ձ�����"
End Sub
