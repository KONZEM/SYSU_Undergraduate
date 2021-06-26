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
Dim a%, b%
a = Val(InputBox("请输入鸡和兔的总头数", "鸡和兔的总头数"))
b = Val(InputBox("请输入鸡和兔的总脚数", "鸡和兔的总脚数"))
Print "兔的数量："; (b - 2 * a) / 2
Print "鸡的数量"; (4 * a - b) / 2
End Sub


