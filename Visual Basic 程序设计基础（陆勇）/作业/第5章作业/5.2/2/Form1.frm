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
Option Explicit

Private Sub Form_Click()
Dim a$, b$, c$, d$, e$
a = InputBox("����������", "����")
b = InputBox("����������", "����")
c = InputBox("������ͨѶ��ַ", "ͨѶ��ַ")
d = InputBox("��������������", "��������")
e = InputBox("������绰", "�绰")
Print "������"; a
Print "���䣺"; b
Print "ͨѶ��ַ��"; c
Print "��������"; d
Print "�绰"; e
End Sub

