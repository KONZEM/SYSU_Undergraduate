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
   StartUpPosition =   3  '����ȱʡ
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
b(1) = "122��"
a(2) = 13.9
b(2) = "276��"
a(3) = 14.2
b(3) = "156��"
a(4) = 14.5
b(4) = "207��"
a(5) = 14.5
b(5) = "302��"
a(6) = 14.7
b(6) = "231��"
a(7) = 14.9
b(7) = "339��"
a(8) = 15.1
b(8) = "077��"
a(9) = 15.2
b(9) = "453��"
a(10) = 15.7
b(10) = "096��"
Print "����"; Tab(8); "�˶�Ա��"; Tab(20); "�ɼ�"
For i = 1 To 10
Print i; Tab(8); b(i); Tab(20); a(i)
Next i
End Sub
