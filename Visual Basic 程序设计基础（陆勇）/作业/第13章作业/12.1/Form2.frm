VERSION 5.00
Begin VB.Form Form2 
   Caption         =   "Form2"
   ClientHeight    =   3015
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   4560
   LinkTopic       =   "Form2"
   ScaleHeight     =   3015
   ScaleWidth      =   4560
   StartUpPosition =   3  '����ȱʡ
   Begin VB.ListBox List1 
      BeginProperty Font 
         Name            =   "����"
         Size            =   18
         Charset         =   134
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1860
      Left            =   3480
      TabIndex        =   0
      Top             =   960
      Width           =   4215
   End
End
Attribute VB_Name = "Form2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub Form_Load()
Form2.Height = 10000
Form2.Width = 15000
List1.AddItem ("������ɽ")
List1.AddItem ("�ƺ�¥���Ϻ�Ȼ֮����")
List1.AddItem ("�ƺ�¥")
List1.AddItem ("����")
End Sub

Private Sub List1_DblClick()
If List1.Selected(0) Then
Form2.Hide
Form3.Show
End If
If List1.Selected(1) Then
Form2.Hide
Form4.Show
End If
If List1.Selected(2) Then
Form2.Hide
Form5.Show
End If
If List1.Selected(3) Then
Form2.Hide
Form6.Show
End If
End Sub
