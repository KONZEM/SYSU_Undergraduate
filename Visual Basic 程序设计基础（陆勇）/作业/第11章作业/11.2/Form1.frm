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
   StartUpPosition =   3  '����ȱʡ
   Begin VB.TextBox Text6 
      Height          =   1000
      Left            =   6120
      TabIndex        =   6
      Top             =   5000
      Width           =   5000
   End
   Begin VB.TextBox Text5 
      Height          =   1000
      Left            =   500
      TabIndex        =   5
      Top             =   5000
      Width           =   5000
   End
   Begin VB.TextBox Text4 
      Height          =   1000
      Left            =   6120
      TabIndex        =   4
      Top             =   3300
      Width           =   5000
   End
   Begin VB.TextBox Text3 
      Height          =   1000
      Left            =   500
      TabIndex        =   3
      Top             =   3240
      Width           =   5000
   End
   Begin VB.TextBox Text2 
      Height          =   1000
      Left            =   6120
      TabIndex        =   2
      Top             =   1600
      Width           =   5000
   End
   Begin VB.TextBox Text1 
      Height          =   1000
      Left            =   500
      TabIndex        =   1
      Top             =   1600
      Width           =   5000
   End
   Begin VB.Label Label1 
      Height          =   855
      Left            =   495
      TabIndex        =   0
      Top             =   480
      Width           =   2085
   End
   Begin VB.Menu mn0 
      Caption         =   "�羰"
      Visible         =   0   'False
      Begin VB.Menu mnu1 
         Caption         =   "����"
      End
      Begin VB.Menu mnu2 
         Caption         =   "�Ͼ�"
      End
      Begin VB.Menu mnu3 
         Caption         =   "����"
      End
      Begin VB.Menu mnu4 
         Caption         =   "����"
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Form_Load()
MsgBox "���Ҽ������˵�", , "��ʾ"
Form1.Height = 10000
Form1.Width = 15000
Label1.FontSize = 40
Text1.FontSize = 20
Text2.FontSize = 20
Text3.FontSize = 20
Text4.FontSize = 20
Text5.FontSize = 20
Text6.FontSize = 20
Text1.Locked = True
Text2.Locked = True
Text3.Locked = True
Text4.Locked = True
Text5.Locked = True
Text6.Locked = True
End Sub

Private Sub Form_Mouseup(Button As Integer, Shift As Integer, X As Single, Y As Single)
If Button = 2 Then PopupMenu mn0
End Sub

Private Sub mnu1_Click()
Text6.Visible = True
Label1.Caption = "����"
Text1.Text = "�찲�Ź㳡"
Text2.Text = "�ʹ�"
Text3.Text = "������԰"
Text4.Text = "�ú�԰"
Text5.Text = "��ɽ"
Text6.Text = "��̳"
End Sub

Private Sub mnu2_Click()
Text6.Visible = True
Label1.Caption = "�Ͼ�"
Text1.Text = "�껨̨"
Text2.Text = "��ɽ��"
Text3.Text = "��Т��"
Text4.Text = "�����"
Text5.Text = "��ϼɽ"
Text6.Text = "Ī���"
End Sub

Private Sub mnu3_Click()
Text6.Visible = True
Label1.Caption = "����"
Text1.Text = "��¥"
Text2.Text = "����¥"
Text3.Text = "С����"
Text4.Text = "���²����"
Text5.Text = "��ʼ����"
Text6.Text = "����ٸ"
End Sub

Private Sub mnu4_Click()
Label1.Caption = "����"
Text1.Text = "���"
Text2.Text = "��ɽ����"
Text3.Text = "������Ȫ"
Text4.Text = "���"
Text5.Text = "��۹�԰"
Text6.Visible = False
End Sub
