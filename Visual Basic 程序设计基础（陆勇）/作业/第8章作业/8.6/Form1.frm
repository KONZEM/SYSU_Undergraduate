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
Dim a(1 To 10) As Double
Dim b(1 To 10) As String
a(1) = 13.7
b(1) = "122ºÅ"
a(2) = 13.9
b(2) = "276ºÅ"
a(3) = 14.2
b(3) = "156ºÅ"
a(4) = 14.5
b(4) = "207ºÅ"
a(5) = 14.5
b(5) = "302ºÅ"
a(6) = 14.7
b(6) = "231ºÅ"
a(7) = 14.9
b(7) = "339ºÅ"
a(8) = 15.1
b(8) = "077ºÅ"
a(9) = 15.2
b(9) = "453ºÅ"
a(10) = 15.7
b(10) = "096ºÅ"
Print "Ãû´Î"; Tab(8); "ÔË¶¯Ô±ºÅ"; Tab(20); "³É¼¨"
For i = 1 To 10
Print i; Tab(8); b(i); Tab(20); a(i)
Next i
End Sub
