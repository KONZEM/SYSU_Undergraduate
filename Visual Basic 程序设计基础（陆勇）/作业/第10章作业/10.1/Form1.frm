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
   Begin VB.TextBox Text1 
      Height          =   855
      Left            =   960
      TabIndex        =   0
      Text            =   "Text1"
      Top             =   840
      Width           =   1695
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Form_Load()
Text1.Text = ""
End Sub

Private Sub Text1_KeyPress(KeyAscii As Integer)
If Chr(KeyAscii) = "A" Then
KeyAscii = 0
Text1.Text = "E"
End If
If Chr(KeyAscii) = "B" Then
KeyAscii = 0
Text1.Text = "F"
End If
If Chr(KeyAscii) = "C" Then
KeyAscii = 0
Text1.Text = "D"
End If
If Chr(KeyAscii) = "D" Then
KeyAscii = 0
Text1.Text = "H"
End If
End Sub
