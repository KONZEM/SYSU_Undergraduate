VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3015
   ClientLeft      =   225
   ClientTop       =   1170
   ClientWidth     =   4560
   LinkTopic       =   "Form1"
   ScaleHeight     =   3015
   ScaleWidth      =   4560
   StartUpPosition =   3  '����ȱʡ
   Begin VB.TextBox Text1 
      ForeColor       =   &H00000000&
      Height          =   5895
      Left            =   1440
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   0
      Top             =   600
      Width           =   11535
   End
   Begin VB.Menu InQuit 
      Caption         =   "�������˳�"
      Begin VB.Menu Input 
         Caption         =   "������Ϣ"
      End
      Begin VB.Menu Quit 
         Caption         =   "�˳�"
      End
   End
   Begin VB.Menu FontFace 
      Caption         =   "�������"
      Begin VB.Menu FontBold 
         Caption         =   "����"
      End
      Begin VB.Menu FontItalic 
         Caption         =   "б��"
      End
      Begin VB.Menu FontUnder 
         Caption         =   "���»���"
      End
      Begin VB.Menu FontStri 
         Caption         =   "���л���"
      End
   End
   Begin VB.Menu FontName 
      Caption         =   "��������"
      Begin VB.Menu FontS 
         Caption         =   "����"
      End
      Begin VB.Menu FontL 
         Caption         =   "����"
      End
      Begin VB.Menu FontW 
         Caption         =   "κ��"
      End
      Begin VB.Menu FontY 
         Caption         =   "��Բ"
      End
   End
   Begin VB.Menu FontSize 
      Caption         =   "�����С"
      Begin VB.Menu Font14 
         Caption         =   "14"
      End
      Begin VB.Menu Font22 
         Caption         =   "22"
      End
      Begin VB.Menu Font24 
         Caption         =   "24"
      End
      Begin VB.Menu Font32 
         Caption         =   "32"
      End
   End
   Begin VB.Menu FontColor 
      Caption         =   "������ɫ"
      Begin VB.Menu FontRed 
         Caption         =   "��ɫ"
      End
      Begin VB.Menu FontBlue 
         Caption         =   "��ɫ"
      End
      Begin VB.Menu FontBlack 
         Caption         =   "��ɫ"
      End
      Begin VB.Menu FontYellow 
         Caption         =   "��ɫ"
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim s$
Private Sub Font14_Click()
Text1.FontSize = 14
End Sub

Private Sub Font22_Click()
Text1.FontSize = 22
End Sub

Private Sub Font24_Click()
Text1.FontSize = 24
End Sub

Private Sub Font32_Click()
Text1.FontSize = 32
End Sub

Private Sub FontBlack_Click()
Text1.ForeColor = vbBlack
End Sub

Private Sub FontBlue_Click()
Text1.ForeColor = vbBlue
End Sub

Private Sub FontBold_Click()
Text1.FontBold = True
End Sub

Private Sub FontItalic_Click()
Text1.FontItalic = True
End Sub

Private Sub FontL_Click()
Text1.FontName = "����"
End Sub

Private Sub FontRed_Click()
Text1.ForeColor = vbRed
End Sub

Private Sub FontS_Click()
Text1.FontName = "����"
End Sub

Private Sub FontStri_Click()
Text1.FontUnderline = True
End Sub

Private Sub FontUnder_Click()
Text1.FontUnderline = True
End Sub

Private Sub FontW_Click()
Text1.FontName = "κ��"
End Sub

Private Sub FontY_Click()
Text1.FontName = "��Բ"
End Sub

Private Sub FontYellow_Click()
Text1.ForeColor = vbYellow
End Sub

Private Sub Form_Load()
Form1.Height = 10000
Form1.Width = 15000
Text1.Locked = True
End Sub

Private Sub Input_Click()
s = ""
s = InputBox("������һ�λ�", "����")
If Text1.Text = "" Then
Text1.Text = s
Else
Text1.Text = Text1.Text & Chr(13) & Chr(10) & s
End If
End Sub

Private Sub Quit_Click()
End
End Sub
