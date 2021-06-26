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
Dim a$, b$, c$, d$, e$
a = InputBox("请输入姓名", "姓名")
b = InputBox("请输入年龄", "年龄")
c = InputBox("请输入通讯地址", "通讯地址")
d = InputBox("请输入邮政编码", "邮政编码")
e = InputBox("请输入电话", "电话")
Print "姓名："; a
Print "年龄："; b
Print "通讯地址："; c
Print "邮政编码"; d
Print "电话"; e
End Sub

