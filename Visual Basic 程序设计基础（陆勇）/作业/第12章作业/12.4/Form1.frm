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
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   8880
      Top             =   1200
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.CommandButton Command3 
      Caption         =   "背景色"
      Height          =   800
      Left            =   6000
      TabIndex        =   3
      Top             =   3240
      Width           =   1000
   End
   Begin VB.CommandButton Command2 
      Caption         =   "字颜色"
      Height          =   855
      Left            =   6000
      TabIndex        =   2
      Top             =   1680
      Width           =   1000
   End
   Begin VB.CommandButton Command1 
      Caption         =   "字体字形"
      Height          =   800
      Left            =   6000
      TabIndex        =   1
      Top             =   120
      Width           =   1000
   End
   Begin VB.TextBox Text1 
      Height          =   3975
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   5175
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub Command1_Click()
CommonDialog1.Flags = 3
CommonDialog1.ShowFont
Text1.FontName = CommonDialog1.FontName
Text1.FontSize = CommonDialog1.FontSize
Text1.FontBold = CommonDialog1.FontBold
Text1.FontItalic = CommonDialog1.FontItalic
Text1.FontUnderline = CommonDialog1.FontUnderline
Text1.FontStrikethru = CommonDialog1.FontStrikethru
End Sub

Private Sub Command2_Click()
CommonDialog1.Flags = vbCCRGBInit
CommonDialog1.Color = BackColor
CommonDialog1.Action = 3
Text1.ForeColor = CommonDialog1.Color
End Sub

Private Sub Command3_Click()
CommonDialog1.Flags = vbCCRGBInit
CommonDialog1.Color = BackColor
CommonDialog1.Action = 3
Text1.BackColor = CommonDialog1.Color
End Sub

Private Sub Form_Load()
Form1.Height = 8000
Form1.Width = 10000
End Sub
