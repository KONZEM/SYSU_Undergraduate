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
Option Explicit

Private Sub Form_Click()
Dim a#, b#, c#, d#
a = Val(InputBox("请输入第一个数", "输入第一个数字"))
b = Val(InputBox("请输入第二个数", "输入第二个数字"))
c = Val(InputBox("请输入第三个数", "输入第三个数字"))
d = Val(InputBox("请输入第四个数", "输入第四个数字"))
Print a + b + c + d
Print (a + b + c + d) / 4
End Sub

