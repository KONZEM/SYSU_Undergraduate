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

For i = 1 To 1000
If f(i) = 1 Then Print i
Next i
End Sub
Private Function f(ByVal m)
f = 1
If m Mod 10 = 1 Or m Mod 10 = 5 Or m Mod 10 = 6 Then
Dim a&, c&, b&
c = m * m
Do While m > 0
a = m Mod 10
b = c Mod 10
m = m \ 10
c = c \ 10
If a <> b Then
f = 0
Exit Do
End If
Loop
Else
f = 0
End If
End Function
