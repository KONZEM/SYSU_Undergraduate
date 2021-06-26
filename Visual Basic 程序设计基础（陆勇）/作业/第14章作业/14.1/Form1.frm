VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   5265
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   9825
   LinkTopic       =   "Form1"
   ScaleHeight     =   5265
   ScaleWidth      =   9825
   StartUpPosition =   3  '´°¿ÚÈ±Ê¡
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Form_Load()
Dim x%, s%
Open "1.txt" For Input As #1
Open "2.txt" For Output As #2
Do While Not EOF(1)
    Input #1, x
    s = s + x
Loop
Write #2, s
Close
End Sub
