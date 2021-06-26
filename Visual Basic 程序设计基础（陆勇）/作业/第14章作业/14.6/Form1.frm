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
Private Type book
    a1 As String * 10
    a As String * 10 '图书分类号
    b1 As String * 10
    b As String * 10 '登记号
    c1 As String * 10
    c As String * 10 '作者名
    d1 As String * 10
    d As String * 10 '单价
    e1 As String * 10
    e As String * 10 '购进数
    f1 As String * 10
    f As String * 10 '借出数
    g1 As String * 10
    g As String * 10 '出版日期
    h1 As String * 10
    h As String * 10 '出版社名称
End Type

Private Sub Form_Load()
Dim temp As book
Dim arr(1 To 1000) As book
Open "1.txt" For Random As #1 Len = Len(temp)
Open "2.txt" For Output As #2
t = Val(InputBox("图书的本数", "输入要输入图书的本数"))
For i = 1 To t
    temp.a1 = "图书分类号："
    temp.b1 = "登记号："
    temp.c1 = "作者号："
    temp.d1 = "单价："
    temp.e1 = "购进数："
    temp.f1 = "借出数："
    temp.g1 = "出版日期："
    temp.h1 = "出版社名称："
    temp.a = InputBox("图书分类号", "请输入图书分类号")
    temp.b = InputBox("登记号", "请输入登记号")
    temp.c = InputBox("作者号", "请输入作者号")
    temp.d = InputBox("单价", "请输入单价")
    temp.e = InputBox("购进数", "请输入购进数")
    temp.f = InputBox("借出数", "请输入借出数")
    temp.g = InputBox("出版日期", "请输入出版日期")
    temp.h = InputBox("出版社名称", "请输入出版社名称")
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
