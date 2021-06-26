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
a = Val(InputBox("请输入星期几", "输入"))
Do While a > -1 And a < 7
If a = 0 Then Print "休息"
If a = 1 Or a = 3 Then Print "讲计算机课"
If a = 2 Or a = 4 Then Print "讲程序设计课"
If a = 5 Then Print "进修英语"
If a = 6 Then Print "政治学习"
a = Val(InputBox("请输入星期几", "输入"))
Loop
End Sub
