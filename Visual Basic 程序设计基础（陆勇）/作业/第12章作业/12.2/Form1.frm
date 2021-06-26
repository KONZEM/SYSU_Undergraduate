VERSION 5.00
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   3015
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   4560
   LinkTopic       =   "Form1"
   ScaleHeight     =   3015
   ScaleWidth      =   4560
   StartUpPosition =   3  '窗口缺省
   Begin VB.CommandButton Command2 
      Caption         =   "字体字形"
      Height          =   735
      Left            =   1200
      TabIndex        =   1
      Top             =   1920
      Width           =   1815
   End
   Begin VB.CommandButton Command1 
      Caption         =   "颜色"
      Height          =   735
      Left            =   1200
      TabIndex        =   0
      Top             =   600
      Width           =   1815
   End
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   3960
      Top             =   240
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim s$
Private Sub Command1_Click()
CommonDialog1.Flags = vbCCRGBInit
CommonDialog1.Action = 3
Form1.ForeColor = CommonDialog1.Color
Form1.Cls
Print s
End Sub

Private Sub Command2_Click()
CommonDialog1.Flags = 3
CommonDialog1.ShowFont
Form1.FontName = CommonDialog1.FontName
Form1.FontSize = CommonDialog1.FontSize
Form1.FontBold = CommonDialog1.FontBold
Form1.FontItalic = CommonDialog1.FontItalic
Form1.FontUnderline = CommonDialog1.FontUnderline
Form1.FontStrikethru = CommonDialog1.FontStrikethru
Form1.Cls
Print s
End Sub

Private Sub Form_Load()
Show
s = InputBox("输入一段文字", "输入")
Print s
End Sub
