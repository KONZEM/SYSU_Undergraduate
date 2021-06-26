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
   StartUpPosition =   3  '窗口缺省
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
      Caption         =   "输入与退出"
      Begin VB.Menu Input 
         Caption         =   "输入信息"
      End
      Begin VB.Menu Quit 
         Caption         =   "退出"
      End
   End
   Begin VB.Menu FontFace 
      Caption         =   "字体外观"
      Begin VB.Menu FontBold 
         Caption         =   "粗体"
      End
      Begin VB.Menu FontItalic 
         Caption         =   "斜体"
      End
      Begin VB.Menu FontUnder 
         Caption         =   "加下划线"
      End
      Begin VB.Menu FontStri 
         Caption         =   "加中划线"
      End
   End
   Begin VB.Menu FontName 
      Caption         =   "字体名称"
      Begin VB.Menu FontS 
         Caption         =   "宋体"
      End
      Begin VB.Menu FontL 
         Caption         =   "隶书"
      End
      Begin VB.Menu FontW 
         Caption         =   "魏碑"
      End
      Begin VB.Menu FontY 
         Caption         =   "幼圆"
      End
   End
   Begin VB.Menu FontSize 
      Caption         =   "字体大小"
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
      Caption         =   "字体颜色"
      Begin VB.Menu FontRed 
         Caption         =   "红色"
      End
      Begin VB.Menu FontBlue 
         Caption         =   "蓝色"
      End
      Begin VB.Menu FontBlack 
         Caption         =   "黑色"
      End
      Begin VB.Menu FontYellow 
         Caption         =   "黄色"
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
Text1.FontName = "隶书"
End Sub

Private Sub FontRed_Click()
Text1.ForeColor = vbRed
End Sub

Private Sub FontS_Click()
Text1.FontName = "宋体"
End Sub

Private Sub FontStri_Click()
Text1.FontUnderline = True
End Sub

Private Sub FontUnder_Click()
Text1.FontUnderline = True
End Sub

Private Sub FontW_Click()
Text1.FontName = "魏碑"
End Sub

Private Sub FontY_Click()
Text1.FontName = "幼圆"
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
s = InputBox("请输入一段话", "输入")
If Text1.Text = "" Then
Text1.Text = s
Else
Text1.Text = Text1.Text & Chr(13) & Chr(10) & s
End If
End Sub

Private Sub Quit_Click()
End
End Sub
