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
Dim a%, b%
a = Val(InputBox("�����뼦���õ���ͷ��", "�����õ���ͷ��"))
b = Val(InputBox("�����뼦���õ��ܽ���", "�����õ��ܽ���"))
Print "�õ�������"; (b - 2 * a) / 2
Print "��������"; (4 * a - b) / 2
End Sub


