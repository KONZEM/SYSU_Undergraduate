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
Print "����-1����"
a = Val(InputBox("�������һ���߳�", "��һ���߳�"))
b = Val(InputBox("������ڶ����߳�", "�ڶ����߳�"))
c = Val(InputBox("������������߳�", "�������߳�"))
Do While a <> -1 And b <> -1 And c <> -1
If a + b > c And a + c > b And b + c > a Then
Print 0.25 * Sqr((a + b + c) * (a + b - c) * (a + c - b) * (b + c - a))
Else
Print "�޷�����������"
End If
Print "����-1����"
a = Val(InputBox("�������һ���߳�", "��һ���߳�"))
b = Val(InputBox("������ڶ����߳�", "�ڶ����߳�"))
c = Val(InputBox("������������߳�", "�������߳�"))
Loop
End Sub
