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
a = Val(InputBox("请输入第一个数字"))
b = Val(InputBox("请输入第二个数字"))
For i = a To b
    s = 1
    For j = 2 To i \ 2
        If i Mod j = 0 Then s = s + j
    Next j
    If i = s Then Print i
Next i
End Sub
