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
FontSize = 15
Form1.Height = 10000
Form1.Width = 10000
Dim a(3, 3) As Integer
a(0, 0) = 25
a(0, 1) = 36
a(0, 2) = 78
a(0, 3) = 13
a(1, 0) = 12
a(1, 1) = 26
a(1, 2) = 88
a(1, 3) = 93
a(2, 0) = 75
a(2, 1) = 18
a(2, 2) = 22
a(2, 3) = 32
a(3, 0) = 56
a(3, 1) = 44
a(3, 2) = 36
a(3, 3) = 58
Print "(1)"
For i = 0 To 3
Print a(i, i);
Next i
Print
For i = 0 To 3
Print a(i, 3 - i);
Next i
Print
Print "(2)"
For i = 0 To 3
    s = 0
    For j = 0 To 3
        s = s + a(i, j)
    Next j
    Print "第" & Chr(i + 49) & "行之和为"; s
Next i
For i = 0 To 3
    s = 0
    For j = 0 To 3
        s = s + a(j, i)
    Next j
    Print "第" & Chr(i + 49) & "列和为"; s
Next i
For i = 0 To 3
    temp = a(0, i)
    a(0, i) = a(2, i)
    a(2, i) = temp
Next i
For i = 0 To 3
    temp = a(i, 1)
    a(i, 1) = a(i, 3)
    a(i, 3) = temp
Next i
Print "(5)"
For i = 0 To 3
    For j = 0 To 3
    Print a(i, j);
    Next j
    Print
Next i
Print
End Sub
