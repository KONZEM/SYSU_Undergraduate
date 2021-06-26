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
Option Explicit

Private Sub Form_Click()
Dim s#, d#, h%, m%
d = 0: h = 0: m = 0
s = Val(InputBox("", ""))
While s >= 86400
s = s - 86400
d = d + 1
Wend
While s >= 3600
s = s - 3600
h = h + 1
Wend
While s >= 60
s = s - 60
m = m + 1
Wend
Print d; "day(s)"; h; "hour(s)"; m; "mminute(s)"; s; "second(s)"
End Sub

