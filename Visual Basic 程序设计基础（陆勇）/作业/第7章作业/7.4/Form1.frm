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
   Begin VB.CommandButton Command1 
      Caption         =   "确定"
      Height          =   615
      Left            =   4080
      TabIndex        =   4
      Top             =   840
      Width           =   1215
   End
   Begin VB.TextBox Text2 
      Height          =   375
      Left            =   2400
      TabIndex        =   3
      Text            =   "Text2"
      Top             =   1320
      Width           =   735
   End
   Begin VB.TextBox Text1 
      Height          =   495
      Left            =   2280
      TabIndex        =   2
      Text            =   "Text1"
      Top             =   360
      Width           =   735
   End
   Begin VB.Label Label2 
      Caption         =   "纳税金额"
      Height          =   615
      Left            =   840
      TabIndex        =   1
      Top             =   1440
      Width           =   855
   End
   Begin VB.Label Label1 
      Caption         =   "收入为"
      Height          =   375
      Left            =   720
      TabIndex        =   0
      Top             =   360
      Width           =   495
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
a = Val(Text1.Text)
If a <= 200 Then Text2.Text = 0
If a > 200 And a <= 400 Then Text2.Text = (a - 200) * 0.03
If a > 400 And a < 5000 Then Text2.Text = (a = 200) * 0.03 + (a - 400) * 0.04
If a > 5000 Then Text2.Text = (a = 200) * 0.03 + (a - 400) * 0.05
End Sub

Private Sub Form_Load()
Label1.Top = 100
Label1.Left = 100
Label1.Height = 200
Label1.Width = 800
Label2.Top = 1000
Label2.Left = 100
Label2.Height = 200
Label2.Width = 800
Text1.Text = ""
Text2.Text = ""
Text1.Top = 100
Text1.Left = 1000
Text1.Height = 200
Text1.Width = 2000
Text2.Top = 1000
Text2.Left = 1000
Text2.Height = 200
Text2.Width = 2000
Command1.Top = 220
Command1.Left = 3200
Command1.Height = 800
Command1.Width = 800
End Sub

