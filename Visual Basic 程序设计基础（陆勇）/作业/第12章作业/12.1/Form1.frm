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
   Begin VB.CommandButton Command1 
      Caption         =   "打开可执行文件"
      Height          =   495
      Left            =   720
      TabIndex        =   0
      Top             =   1440
      Width           =   1575
   End
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   2160
      Top             =   600
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
Private Sub Command1_Click()
CommonDialog1.FileName = ""
CommonDialog1.Flags = vbOFNFileMustExist
CommonDialog1.Filter = "(*.exe)|*.exe|"
CommonDialog1.DialogTitle = "Open File(*.EXE) "
CommonDialog1.Action = 1
If CommonDialog1.FileName = "" Then
    MsgBox "No exe selectd", 37, "Checking"
Else
    Shell CommonDialog1.FileName, 1
End If
End Sub
