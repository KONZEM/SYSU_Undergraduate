VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3015
   ClientLeft      =   225
   ClientTop       =   870
   ClientWidth     =   4560
   LinkTopic       =   "Form1"
   ScaleHeight     =   3015
   ScaleWidth      =   4560
   StartUpPosition =   3  '窗口缺省
   Begin VB.TextBox Text1 
      Height          =   2895
      Left            =   600
      MultiLine       =   -1  'True
      TabIndex        =   0
      Top             =   1080
      Width           =   3855
   End
   Begin VB.Menu mnu10 
      Caption         =   "输入信息"
      Begin VB.Menu mnu11 
         Caption         =   "输入信息"
      End
      Begin VB.Menu mnu12 
         Caption         =   "退出"
      End
   End
   Begin VB.Menu mnu20 
      Caption         =   "显示信息"
      Begin VB.Menu mnu21 
         Caption         =   "显示"
      End
      Begin VB.Menu mnu22 
         Caption         =   "清除"
      End
   End
   Begin VB.Menu mnu30 
      Caption         =   "格式"
      Begin VB.Menu mnu31 
         Caption         =   "正常"
      End
      Begin VB.Menu mnu32 
         Caption         =   "粗体"
      End
      Begin VB.Menu mnu33 
         Caption         =   "斜体"
      End
      Begin VB.Menu mnu34 
         Caption         =   "下划线"
      End
      Begin VB.Menu mnu35 
         Caption         =   "Font20"
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim s$
Private Sub Form_Load()
Text1.Locked = True
Text1.Text = ""
End Sub

Private Sub mnu11_Click()
s = InputBox("请输入一段文字", "输入")
End Sub

Private Sub mnu12_Click()
End
End Sub

Private Sub mnu21_Click()
If s = "" Then
MsgBox "请先输入文字", , "提示"
Exit Sub
End If
If Text1.Text = "" Then
Text1.Text = Text1.Text & s
Else
Text1.Text = Text1.Text & Chr(13) & Chr(10) & s
End If
s = ""
End Sub

Private Sub mnu22_Click()
Text1.Text = ""
End Sub

Private Sub mnu31_Click()
Text1.FontName = "正常"
End Sub


Private Sub mnu32_Click()
Text1.FontName = "粗体"
End Sub

Private Sub mnu33_Click()
Text1.FontName = "斜体"
End Sub

Private Sub mnu34_Click()
Text1.FontName = "下划线"
End Sub

Private Sub mnu35_Click()
Text1.FontSize = 20
End Sub
