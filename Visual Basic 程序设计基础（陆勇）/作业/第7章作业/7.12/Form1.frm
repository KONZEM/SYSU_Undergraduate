VERSION 5.00
Begin VB.Form Form1 
   AutoRedraw      =   -1  'True
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
Form1.Height = 20000
Show
For i = 10 To 99
    For j = i To 99
    If i Mod 10 = 0 Then
        c = i / 10
    Else
        c = i \ 10 + (i Mod 10) * 10
    End If
    If j Mod 10 = 0 Then
        d = j / 10
    Else
        d = j \ 10 + (j Mod 10) * 10
    End If
    If i + d = c + j Then Print i; "+ ("; d; ") = "; "("; c; ") +"; j
    Next j
Next i
End Sub
