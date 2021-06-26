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
Dim a(10, 10) As Integer
For i = 0 To 9
    For j = 0 To 9
        If i = j Or i + j = 9 Then
            a(i, j) = 1
        Else
            a(i, j) = 0
        End If
        Next j
Next i
For i = 0 To 9
    For j = 0 To 9
    Print a(i, j);
    Next j
Print
Next i
End Sub
