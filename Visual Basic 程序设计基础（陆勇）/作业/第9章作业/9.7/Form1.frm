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
   StartUpPosition =   3  '窗口缺省
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Form_Load()
Show
Dim a%, b%
a = Val(InputBox("输入八进制数"))
Print "八进制" & Str(a) & "的十进制数是"; ReadOctal(a)
b = Val(InputBox("输入十进制数"))
Print "十进制" & Str(b) & "的八进制数是"; WriteOctal(b)
End Sub
Private Function ReadOctal(a)
Dim i%, j%
i = 0
Do While a > 0
j = a Mod 10
a = a \ 10
ReadOctal = ReadOctal + j * (8 ^ i)
i = i + 1
Loop
End Function
Private Function WriteOctal(b)
Dim i%, j%
i = 0
Do While b > 0
j = b Mod 8
b = b \ 8
WriteOctal = WriteOctal + j * (10 ^ i)
i = i + 1
Loop
End Function
