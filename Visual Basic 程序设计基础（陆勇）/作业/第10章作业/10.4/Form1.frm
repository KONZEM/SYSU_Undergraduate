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
   Begin VB.TextBox Text1 
      Height          =   735
      Left            =   1680
      TabIndex        =   2
      Text            =   "Text1"
      Top             =   2040
      Width           =   975
   End
   Begin VB.PictureBox Picture1 
      Height          =   615
      Left            =   600
      ScaleHeight     =   555
      ScaleWidth      =   795
      TabIndex        =   1
      Top             =   840
      Width           =   855
   End
   Begin VB.CommandButton Command1 
      Height          =   495
      Left            =   2760
      TabIndex        =   0
      Top             =   960
      Width           =   855
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub Command1_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
Command1.MousePointer = 5
If Button = 1 Then MsgBox "���������λ�����ť��"
End Sub

Private Sub Form_Load()
Text1.Text = ""
End Sub

Private Sub Form_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
If Button = 1 Then MsgBox "���������λ�ڴ�����"
End Sub

Private Sub Picture1_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
Picture1.MousePointer = 3
If Button = 1 Then MsgBox "���������λ��ͼƬ��"
End Sub

Private Sub Text1_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
If Button = 1 Then MsgBox "���������λ���ı�����"
End Sub
