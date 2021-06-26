VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   5055
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   11850
   LinkTopic       =   "Form1"
   ScaleHeight     =   5055
   ScaleWidth      =   11850
   StartUpPosition =   3  '窗口缺省
   Begin VB.CommandButton Command2 
      Caption         =   "删除"
      Height          =   615
      Left            =   5280
      TabIndex        =   3
      Top             =   2640
      Width           =   1575
   End
   Begin VB.CommandButton Command1 
      Caption         =   "添加"
      Height          =   615
      Left            =   5280
      TabIndex        =   2
      Top             =   1320
      Width           =   1575
   End
   Begin VB.ListBox List2 
      BeginProperty Font 
         Name            =   "宋体"
         Size            =   18
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   3570
      ItemData        =   "Form1.frx":0000
      Left            =   7560
      List            =   "Form1.frx":0002
      Sorted          =   -1  'True
      Style           =   1  'Checkbox
      TabIndex        =   1
      Top             =   600
      Width           =   2895
   End
   Begin VB.ListBox List1 
      BeginProperty Font 
         Name            =   "宋体"
         Size            =   18
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   3660
      ItemData        =   "Form1.frx":0004
      Left            =   1800
      List            =   "Form1.frx":001D
      Sorted          =   -1  'True
      TabIndex        =   0
      Top             =   600
      Width           =   2895
   End
   Begin VB.Label Label2 
      Caption         =   "style:checkbox    sorted:true"
      Height          =   375
      Left            =   7680
      TabIndex        =   5
      Top             =   4560
      Width           =   2895
   End
   Begin VB.Label Label1 
      Caption         =   "style:standard    sorted:true"
      Height          =   375
      Left            =   1800
      TabIndex        =   4
      Top             =   4560
      Width           =   2895
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Command1_Click()
 Dim i As Integer, f As Boolean
 f = False
 For i = List1.ListCount - 1 To 0 Step -1
    If List1.Selected(i) Then
        f = True
        List2.AddItem (List1.List(i))
        List1.RemoveItem i
        'i = i - 1
    End If
Next i
End Sub

Private Sub Command2_Click()
    Dim i As Integer
  For i = List2.ListCount - 1 To 0 Step -1
  If List2.Selected(i) Then
    List1.AddItem (List2.List(i))
    List2.RemoveItem i
   'i = i - 1
    End If
    Next i

End Sub

Private Sub Form_Load()

End Sub
