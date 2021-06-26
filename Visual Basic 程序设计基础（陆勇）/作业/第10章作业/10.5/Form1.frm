VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   12375
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   9765
   LinkTopic       =   "Form1"
   ScaleHeight     =   12375
   ScaleWidth      =   9765
   StartUpPosition =   3  '窗口缺省
   Begin VB.CommandButton Command2 
      Caption         =   "rubbish2"
      Height          =   1095
      Left            =   9360
      TabIndex        =   1
      Top             =   3360
      Width           =   1335
   End
   Begin VB.CommandButton Command1 
      Caption         =   "rubbish1"
      Height          =   975
      Left            =   9360
      TabIndex        =   0
      Top             =   1080
      Width           =   1215
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub Command1_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
If Button = 1 Then Command1.Move X, Y
If Sqr((X - 4000) * (X - 4000) + (Y - 4000) * (Y - 4000)) <= 2000 Then
a = MsgBox("是否将该对象放入回收站", 52)
    If a = 6 Then
    Command1.Visible = False
    Else
    Command1.Top = 2000
    Command1.Left = 8000
    End If
End If
Form1.Circle (4000, 4000), 2000, RGB(255, 0, 0)
End Sub

Private Sub Command2_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
If Button = 1 Then Command2.Move X, Y
If Sqr((X - 4000) * (X - 4000) + (Y - 4000) * (Y - 4000)) <= 2000 Then
a = MsgBox("是否将该对象放入回收站", 52)
    If a = 6 Then
    Command2.Visible = False
    Else
    Command2.Top = 8000
    Command2.Left = 8000
    End If
End If
Form1.Circle (4000, 4000), 2000, RGB(255, 0, 0)
End Sub

Private Sub Form_Load()
Show
Form1.Circle (4000, 4000), 2000, RGB(255, 0, 0)
Command1.Top = 2000
Command1.Left = 8000
Command2.Top = 8000
Command2.Left = 8000
End Sub
