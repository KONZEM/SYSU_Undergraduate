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
Open "1.txt" For Output As #1
Print #1, "SUN   "; "MON   "; "TUE   "; "WED   "; "THu   "; "FRI   "; "SAT"
Print #1, Str("1"); Spc(4); Str("2"); Spc(4); Str("3"); Spc(4); _
Str("4"); Spc(4); Str("5"); Spc(4); Str("6"); Spc(4); Str("7")

Print #1, Str("8"); Spc(4); Str("9"); Spc(3); Str("10"); Spc(3); _
Str("11"); Spc(3); Str("12"); Spc(3); Str("13"); Spc(3); Str("14")

Print #1, "15"; Spc(4); "16"; Spc(4); "17"; Spc(4); _
"18"; Spc(4); "19"; Spc(4); "20"; Spc(4); "21"

Print #1, "22"; Spc(4); "23"; Spc(4); "24"; Spc(4); _
"25"; Spc(4); "26"; Spc(4); "27"; Spc(4); "28"

Print #1, "29"; Spc(4); "30"; Spc(4); "31"

Close #1
End Sub
