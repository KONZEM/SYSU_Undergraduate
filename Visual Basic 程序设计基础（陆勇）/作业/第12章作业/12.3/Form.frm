VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   6480
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   10650
   LinkTopic       =   "Form1"
   ScaleHeight     =   6480
   ScaleWidth      =   10650
   StartUpPosition =   3  '窗口缺省
   Begin VB.CommandButton Command2 
      Caption         =   "Cancel"
      BeginProperty Font 
         Name            =   "华文行楷"
         Size            =   24
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   825
      Left            =   5640
      TabIndex        =   2
      Top             =   2760
      Width           =   1575
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Accept"
      BeginProperty Font 
         Name            =   "华文行楷"
         Size            =   24
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   825
      Left            =   1200
      TabIndex        =   1
      Top             =   2760
      Width           =   1575
   End
   Begin VB.TextBox Text2 
      BeginProperty Font 
         Name            =   "华文行楷"
         Size            =   36
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      IMEMode         =   3  'DISABLE
      Left            =   4500
      PasswordChar    =   "*"
      TabIndex        =   0
      Top             =   1000
      Width           =   3615
   End
   Begin VB.Label Label1 
      Caption         =   "请输入命令"
      BeginProperty Font 
         Name            =   "华文行楷"
         Size            =   36
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   200
      TabIndex        =   3
      Top             =   1000
      Width           =   3615
   End
   Begin VB.Image Image2 
      Height          =   825
      Left            =   7320
      Picture         =   "Form.frx":0000
      Stretch         =   -1  'True
      Top             =   2760
      Width           =   850
   End
   Begin VB.Image Image1 
      Height          =   825
      Left            =   2880
      Picture         =   "Form.frx":142C
      Stretch         =   -1  'True
      Top             =   2760
      Width           =   850
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub Command1_Click()
If Text2.Text = "12345678" Then
    Image1.Picture = LoadPicture(App.Path & "\2.jpg")
    Image2.Picture = LoadPicture(App.Path & "\2.jpg")
    MsgBox "口令正确，继续执行"
    End
Else
    MsgBox "错误"
    End
End If
End Sub


Private Sub Command2_Click()
Text2.Text = ""
End Sub

