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
t = Val(InputBox("比较数字的个数"))
Dim a(7) As Integer
Dim max%, min%
Dim x%, y%
Dim m%, n%
For i = 1 To t
a(i) = Val(InputBox("请输入" & Str(i) & "个数字"))
Next i
If t = 3 Then
com a(1), a(2), a(3), max, min
Print "max:"; max, "min:"; min
Print
ElseIf t = 5 Then
com a(0), a(1), a(2), max, min
x = max
y = min
com a(4), a(5), x, max, min
com a(4), a(5), y, x, min
Print "max:"; max, "min:"; min
Print
ElseIf t = 7 Then
com a(1), a(2), a(3), max, min
com a(4), a(5), a(6), x, y
m = max: n = min
com a(7), x, m, max, min
com a(7), y, n, m, min
Print "max:"; max, "min:"; min
Print
End If
End Sub
Sub com(a As Integer, b As Integer, c As Integer, max As Integer, min As Integer)
If a < b Then
min = a
max = b
Else
min = b
max = a
End If
If max < c Then max = c
If min > c Then min = c
End Sub
