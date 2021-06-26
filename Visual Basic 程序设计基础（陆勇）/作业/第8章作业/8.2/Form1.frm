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
Dim c(7) As Integer
a = Array(2, 8, 7, 6, 4, 28, 70, 25)
b = Array(79, 27, 32, 41, 57, 66, 78, 80)
For i = 0 To 7
c(i) = a(i) + b(i)
Next i
For i = 0 To 7
Print c(i);
Next i
Print
End Sub
