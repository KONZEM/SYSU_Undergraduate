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
   StartUpPosition =   3  '����ȱʡ
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Form_Load()
Show
a = Val(InputBox("�������a"))
b = Val(InputBox("�������b"))
c = Val(InputBox("�������c"))
Dim x1 As Double, x2 As Double, d%
f a, b, c, d, x1, x2
If d = -1 Then
Print "�޽�"
ElseIf d = 0 Then
Print "ֻ��һ����"; x1
Else
Print "��������"; x1; x2
End If
End Sub
Private Sub f(ByVal a As Integer, ByVal b As Integer, ByVal c As Integer, d As Integer, x1 As Double, x2 As Double)
If Sqr(b * b - 4 * a * c) < 0 Then
d = -1
ElseIf Sqr(b * b - 4 * a * c) = 0 Then
x1 = x2 = -b / 2 * a
d = 0
Else
x1 = (-b + Sqr(b * b - 4 * a * c)) / 2 * a
x2 = (-b - Sqr(b * b - 4 * a * c)) / 2 * a
d = 1
End If
End Sub
