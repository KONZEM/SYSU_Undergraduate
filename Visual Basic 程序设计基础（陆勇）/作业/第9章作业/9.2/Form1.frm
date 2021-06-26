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
Dim a%, b%, c%
a = Val(InputBox("输入第1个数字"))
b = Val(InputBox("输入第2个数字"))
c = Val(InputBox("输入第3个数字"))
Dim d&
s a, b, c, d
Print d
End Sub
Private Sub s(a As Integer, b As Integer, c As Integer, d As Long)
d = f(a) + f(b) + f(c)
End Sub
Private Function f(a)
Dim i%, s&
s = 1
For i = 1 To a
s = s * i
Next i
f = s
End Function
