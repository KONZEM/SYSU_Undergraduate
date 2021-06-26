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
Dim a(1 To 10) As Integer
For i = 1 To 10
a(i) = Val(InputBox("输入数字"))
Next i
For i = 1 To 10
Print a(i);
Next i
Print
For i = 1 To 5
temp = a(i)
a(i) = a(11 - i)
a(11 - i) = temp
Next i
For i = 1 To 10
Print a(i);
Next i
Print
End Sub
