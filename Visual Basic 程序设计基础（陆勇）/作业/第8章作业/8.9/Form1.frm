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
   StartUpPosition =   3  '´°¿ÚÈ±Ê¡
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Form_Load()
Show
FontSize = 15
Form1.Height = 5000
Form1.Width = 8000
Dim a(1 To 11, 1 To 11) As Integer
For i = 1 To 11
    For j = 1 To i
    If j = 1 Then
    a(i, j) = 1
    ElseIf j = i Then
    a(i, j) = 1
    Else
    a(i, j) = a(i - 1, j - 1) + a(i - 1, j)
    End If
    Next j
Next i
For i = 1 To 11
    For j = 1 To i
    Print a(i, j);
    Next j
    Print
Next i
End Sub
