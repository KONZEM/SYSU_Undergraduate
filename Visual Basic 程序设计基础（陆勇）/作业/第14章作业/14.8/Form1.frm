VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   8565
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   14820
   LinkTopic       =   "Form1"
   ScaleHeight     =   8565
   ScaleWidth      =   14820
   StartUpPosition =   3  '窗口缺省
   Begin VB.DirListBox Dir1 
      BeginProperty Font 
         Name            =   "宋体"
         Size            =   15
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1410
      Left            =   5500
      TabIndex        =   12
      Top             =   2505
      Width           =   4815
   End
   Begin VB.FileListBox File1 
      BeginProperty Font 
         Name            =   "宋体"
         Size            =   15
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   1590
      Left            =   480
      TabIndex        =   11
      Top             =   2400
      Width           =   4440
   End
   Begin VB.DriveListBox Drive1 
      BeginProperty Font 
         Name            =   "宋体"
         Size            =   15
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      Left            =   5500
      TabIndex        =   10
      Top             =   5200
      Width           =   2895
   End
   Begin VB.TextBox Text2 
      Height          =   5175
      Left            =   11000
      MultiLine       =   -1  'True
      TabIndex        =   9
      Top             =   1320
      Width           =   3615
   End
   Begin VB.TextBox Text1 
      BeginProperty Font 
         Name            =   "宋体"
         Size            =   15
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   500
      Left            =   500
      TabIndex        =   8
      Top             =   1300
      Width           =   3000
   End
   Begin VB.ComboBox Combo1 
      BeginProperty Font 
         Name            =   "宋体"
         Size            =   15
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   420
      ItemData        =   "Form1.frx":0000
      Left            =   480
      List            =   "Form1.frx":000D
      Style           =   2  'Dropdown List
      TabIndex        =   7
      Top             =   5200
      Width           =   3360
   End
   Begin VB.CommandButton Command2 
      Caption         =   "保存"
      BeginProperty Font 
         Name            =   "宋体"
         Size            =   15
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   600
      Left            =   4680
      TabIndex        =   6
      Top             =   6500
      Width           =   1200
   End
   Begin VB.CommandButton Command1 
      Caption         =   "读文件"
      BeginProperty Font 
         Name            =   "宋体"
         Size            =   15
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   600
      Left            =   1200
      TabIndex        =   5
      Top             =   6480
      Width           =   1200
   End
   Begin VB.Label Label6 
      BeginProperty Font 
         Name            =   "宋体"
         Size            =   15
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   495
      Left            =   5500
      TabIndex        =   13
      Top             =   1320
      Width           =   3480
   End
   Begin VB.Label Label5 
      Caption         =   "磁盘驱动器："
      BeginProperty Font 
         Name            =   "宋体"
         Size            =   15
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   5500
      TabIndex        =   4
      Top             =   4500
      Width           =   1935
   End
   Begin VB.Label Label4 
      Caption         =   "文件类型："
      BeginProperty Font 
         Name            =   "宋体"
         Size            =   15
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   500
      TabIndex        =   3
      Top             =   4500
      Width           =   1920
   End
   Begin VB.Label Label3 
      Caption         =   "文件编辑："
      BeginProperty Font 
         Name            =   "宋体"
         Size            =   15
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   11000
      TabIndex        =   2
      Top             =   480
      Width           =   1695
   End
   Begin VB.Label Label2 
      Caption         =   "目录："
      BeginProperty Font 
         Name            =   "宋体"
         Size            =   15
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   5500
      TabIndex        =   1
      Top             =   495
      Width           =   975
   End
   Begin VB.Label Label1 
      Caption         =   "文件名称："
      BeginProperty Font 
         Name            =   "宋体"
         Size            =   15
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   500
      TabIndex        =   0
      Top             =   500
      Width           =   1575
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
Text2.Locked = False
Dim s As String
Open Label6.Caption & "\" & Text1.Text For Input As #1
Do While Not EOF(1)
    Line Input #1, s
    Text2.Text = s & vbCrLf
Loop
Close #1
End Sub

Private Sub Command2_Click()
Dim s As String
s = Text2.Text
Open Label6.Caption & "\" & Text1.Text For Output As #2
    Print #2, s
Close #2
End Sub

Private Sub Dir1_change()
Label6.Caption = Dir1.Path
File1.Path = Dir1.Path
End Sub

Private Sub Drive1_Change()
Dir1.Path = Drive1.Drive
End Sub

Private Sub File1_Click()
Text1.Text = File1.FileName
Combo1.Text = Combo1.List(0)
If InStr(1, File1.FileName, "txt", 1) Then
    Combo1.Text = Combo1.List(1)
ElseIf InStr(1, File1.FileName, "doc", 1) Then
    Combo1.Text = Combo1.List(2)
End If
End Sub

Private Sub Form_Load()
Label6.Caption = Dir1.Path
Text1.Locked = True
Text2.Locked = True
End Sub
