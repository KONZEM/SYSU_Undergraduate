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
   StartUpPosition =   3  '窗口缺省
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Form_Load()
Show
Dim s#, a#, b#
Open "1.txt" For Output As #1
s = Val(InputBox("当前结存", "输入"))
Do While b <> -1
a = Val(InputBox("1代表接收存款，2代表扣除支出", "选择接收存款or扣除支出"))
b = Val(InputBox("请输入数额", "输入-1结束"))
If a = 1 Then s = s + b
If a = 2 Then s = s - b
Print Format(s, "###,###,###,###.000")
Print #1, Format(s, "###,###,###,###.000")
Loop
Close #1
End Sub
