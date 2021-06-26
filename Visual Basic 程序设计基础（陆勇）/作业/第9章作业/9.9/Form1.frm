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
FontSize = 20
Print f(100)
Print f(500)
Print f(5000)
End Sub
Private Function f(n)
Dim s As Double
For i = 1 To n Step 2
If i Mod 4 = 1 Then s = s + 1 / i
If i Mod 4 = 3 Then s = s - 1 / i
Next i
f = s
End Function
