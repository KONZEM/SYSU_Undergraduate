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
Private Type inf
    id As Integer
    name As String * 10
    gender As String * 10
    age As Integer
    g1 As Integer
    g2 As Integer
    g3 As Integer
    g4 As Integer
    g5 As Integer
End Type

Private Type pj
    msg As String * 10
    p As Double
End Type



Private Sub Form_Load()
Dim temp As inf
Dim arr(1 To 100) As inf
Dim a(1 To 5) As Integer
Dim j As Integer
Dim sum As Double
Dim count1 As Integer
Dim count2 As Integer
Dim count3 As Integer
Dim count4 As Integer
Dim count5 As Integer
j = 1

Randomize

Open "1.txt" For Random As #1 Len = Len(temp)
Open "2.txt" For Random As #2 Len = Len(temp)
Open "3.txt" For Random As #3 Len = Len(temp)
Open "4.txt" For Random As #4 Len = Len(temp)
Open "5.txt" For Output As #5

For i = 1 To 100

    temp.id = i
    temp.name = CStr(i)
    If i Mod 2 = 0 Then temp.gender = "male"
    If i Mod 2 = 1 Then temp.gender = "female"
    temp.age = Int(3 * Rnd + 18)
    temp.g1 = Int(91 * Rnd + 10)
    temp.g2 = Int(91 * Rnd + 10)
    temp.g3 = Int(91 * Rnd + 10)
    temp.g4 = Int(91 * Rnd + 10)
    temp.g5 = Int(91 * Rnd + 10)
    
    Put #1, i, temp
    
    arr(i) = temp
Next i


For i = 1 To 100

    Get #1, i, temp
    If temp.gender = "female" Then
        Put #2, j, temp
        j = j + 1
    End If
    
    a(1) = temp.g1
    a(2) = temp.g2
    a(3) = temp.g3
    a(4) = temp.g4
    a(5) = temp.g5
    Dim b As pj
    b.msg = "平均分："
    b.p = (a(1) + a(2) + a(3) + a(4) + a(5)) / 5
    Dim t As Integer
    For m = 1 To 4
        For n = 1 To 4
            If a(n) < a(n + 1) Then
                t = a(n)
                a(n) = a(n + 1)
                a(n + 1) = t
            End If
        Next n
    Next m
    temp.g1 = a(1)
    temp.g2 = a(2)
    temp.g3 = a(3)
    temp.g4 = a(4)
    temp.g5 = a(5)
    Put #3, i, temp
    Put #3, i, b
Next i


For i = 1 To 99
    For k = 1 To 99
        If arr(k).age > arr(k + 1).age Then
            temp = arr(k)
            arr(k) = arr(k + 1)
            arr(k + 1) = arr(k)
            End If
    Next k
Next i
For i = 1 To 100
    Put #4, i, arr(i)
Next i


For i = 1 To 5
    sum = 0
    count1 = 0
    count2 = 0
    count3 = 0
    count4 = 0
    count5 = 0
    For k = 1 To 100
        If i = 1 Then
            sum = sum + arr(k).g1
            If arr(k).g1 < 60 Then count1 = count1 + 1
            If arr(k).g1 >= 60 And arr(k).g1 <= 70 Then count2 = count2 + 1
            If arr(k).g1 > 70 And arr(k).g1 <= 80 Then count3 = count3 + 1
            If arr(k).g1 > 80 And arr(k).g1 <= 90 Then count4 = count4 + 1
            If arr(k).g1 > 90 Then count5 = count5 + 1
        ElseIf i = 2 Then
            sum = sum + arr(k).g2
            If arr(k).g2 < 60 Then count1 = count1 + 1
            If arr(k).g2 >= 60 And arr(k).g2 <= 70 Then count2 = count2 + 1
            If arr(k).g2 > 70 And arr(k).g2 <= 80 Then count3 = count3 + 1
            If arr(k).g2 > 80 And arr(k).g2 <= 90 Then count4 = count4 + 1
            If arr(k).g2 > 90 Then count5 = count5 + 1
        ElseIf i = 3 Then
            sum = sum + arr(k).g3
            If arr(k).g3 < 60 Then count1 = count1 + 1
            If arr(k).g3 >= 60 And arr(k).g3 <= 70 Then count2 = count2 + 1
            If arr(k).g3 > 70 And arr(k).g3 <= 80 Then count3 = count3 + 1
            If arr(k).g3 > 80 And arr(k).g3 <= 90 Then count4 = count4 + 1
            If arr(k).g3 > 90 Then count5 = count5 + 1
        ElseIf i = 4 Then
            sum = sum + arr(k).g4
            If arr(k).g4 < 60 Then count1 = count1 + 1
            If arr(k).g4 >= 60 And arr(k).g4 <= 70 Then count2 = count2 + 1
            If arr(k).g4 > 70 And arr(k).g4 <= 80 Then count3 = count3 + 1
            If arr(k).g4 > 80 And arr(k).g4 <= 90 Then count4 = count4 + 1
            If arr(k).g4 > 90 Then count5 = count5 + 1
        ElseIf i = 5 Then
            sum = sum + arr(k).g5
            If arr(k).g5 < 60 Then count1 = count1 + 1
            If arr(k).g5 >= 60 And arr(k).g5 <= 70 Then count2 = count2 + 1
            If arr(k).g5 > 70 And arr(k).g5 <= 80 Then count3 = count3 + 1
            If arr(k).g5 > 80 And arr(k).g5 <= 90 Then count4 = count4 + 1
            If arr(k).g5 > 90 Then count5 = count5 + 1
        End If
    Next k
    If i = 1 Then
        Print #5, "g1分数段", "60分以下："; count1, "60－70："; count2, "71－80："; count3, "8l－90："; count4, "90分以上："; count5, "平均分："; sum / 100
    ElseIf i = 2 Then
        Print #5, "g2分数段", "60分以下："; count1, "60－70："; count2, "71－80："; count3, "8l－90："; count4, "90分以上："; count5, "平均分："; sum / 100
    ElseIf i = 3 Then
        Print #5, "g3分数段", "60分以下："; count1, "60－70："; count2, "71－80："; count3, "8l－90："; count4, "90分以上："; count5, "平均分："; sum / 100
    ElseIf i = 4 Then
        Print #5, "g4分数段", "60分以下："; count1, "60－70："; count2, "71－80："; count3, "8l－90："; count4, "90分以上："; count5, "平均分："; sum / 100
    ElseIf i = 5 Then
        Print #5, "g5分数段", "60分以下："; count1, "60－70："; count2, "71－80："; count3, "8l－90："; count4, "90分以上："; count5, "平均分："; sum / 100
    End If
Next i

Close

End Sub
