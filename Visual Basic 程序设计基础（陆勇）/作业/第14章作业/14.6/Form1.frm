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
Private Type book
    a1 As String * 10
    a As String * 10 'ͼ������
    b1 As String * 10
    b As String * 10 '�ǼǺ�
    c1 As String * 10
    c As String * 10 '������
    d1 As String * 10
    d As String * 10 '����
    e1 As String * 10
    e As String * 10 '������
    f1 As String * 10
    f As String * 10 '�����
    g1 As String * 10
    g As String * 10 '��������
    h1 As String * 10
    h As String * 10 '����������
End Type

Private Sub Form_Load()
Dim temp As book
Dim arr(1 To 1000) As book
Open "1.txt" For Random As #1 Len = Len(temp)
Open "2.txt" For Output As #2
t = Val(InputBox("ͼ��ı���", "����Ҫ����ͼ��ı���"))
For i = 1 To t
    temp.a1 = "ͼ�����ţ�"
    temp.b1 = "�ǼǺţ�"
    temp.c1 = "���ߺţ�"
    temp.d1 = "���ۣ�"
    temp.e1 = "��������"
    temp.f1 = "�������"
    temp.g1 = "�������ڣ�"
    temp.h1 = "���������ƣ�"
    temp.a = InputBox("ͼ������", "������ͼ������")
    temp.b = InputBox("�ǼǺ�", "������ǼǺ�")
    temp.c = InputBox("���ߺ�", "���������ߺ�")
    temp.d = InputBox("����", "�����뵥��")
    temp.e = InputBox("������", "�����빺����")
    temp.f = InputBox("�����", "����������")
    temp.g = InputBox("��������", "�������������")
    temp.h = InputBox("����������", "���������������")
    arr(i) = temp
    Put #1, i, temp
Next i

For i = 1 To t - 1
    For j = 1 To t - 1
        If arr(i).b > arr(i + 1).b Then
            temp = arr(i)
            arr(i) = arr(i + 1)
            arr(i + 1) = temp
        End If
    Next j
Next i

For i = 1 To t
    Print #2, arr(i).a1; arr(i).a, arr(i).b1; arr(i).b, arr(i).c1; arr(i).c, arr(i).d1; arr(i).d _
    , arr(i).e1; arr(i).e, arr(i).f1; arr(i).f, arr(i).g1; arr(i).g, arr(i).h1; arr(i).h
Next i
End Sub
