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
Dim s#, a#, b#
Open "1.txt" For Output As #1
s = Val(InputBox("��ǰ���", "����"))
Do While b <> -1
a = Val(InputBox("1������մ�2����۳�֧��", "ѡ����մ��or�۳�֧��"))
b = Val(InputBox("����������", "����-1����"))
If a = 1 Then s = s + b
If a = 2 Then s = s - b
Print Format(s, "###,###,###,###.000")
Print #1, Format(s, "###,###,###,###.000")
Loop
Close #1
End Sub
