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
   Begin VB.TextBox Text6 
      Height          =   1000
      Left            =   6120
      TabIndex        =   6
      Top             =   5000
      Width           =   5000
   End
   Begin VB.TextBox Text5 
      Height          =   1000
      Left            =   500
      TabIndex        =   5
      Top             =   5000
      Width           =   5000
   End
   Begin VB.TextBox Text4 
      Height          =   1000
      Left            =   6120
      TabIndex        =   4
      Top             =   3300
      Width           =   5000
   End
   Begin VB.TextBox Text3 
      Height          =   1000
      Left            =   500
      TabIndex        =   3
      Top             =   3240
      Width           =   5000
   End
   Begin VB.TextBox Text2 
      Height          =   1000
      Left            =   6120
      TabIndex        =   2
      Top             =   1600
      Width           =   5000
   End
   Begin VB.TextBox Text1 
      Height          =   1000
      Left            =   500
      TabIndex        =   1
      Top             =   1600
      Width           =   5000
   End
   Begin VB.Label Label1 
      Height          =   855
      Left            =   495
      TabIndex        =   0
      Top             =   480
      Width           =   2085
   End
   Begin VB.Menu mn0 
      Caption         =   "风景"
      Visible         =   0   'False
      Begin VB.Menu mnu1 
         Caption         =   "北京"
      End
      Begin VB.Menu mnu2 
         Caption         =   "南京"
      End
      Begin VB.Menu mnu3 
         Caption         =   "西安"
      End
      Begin VB.Menu mnu4 
         Caption         =   "昆明"
      End
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Form_Load()
MsgBox "按右键弹出菜单", , "提示"
Form1.Height = 10000
Form1.Width = 15000
Label1.FontSize = 40
Text1.FontSize = 20
Text2.FontSize = 20
Text3.FontSize = 20
Text4.FontSize = 20
Text5.FontSize = 20
Text6.FontSize = 20
Text1.Locked = True
Text2.Locked = True
Text3.Locked = True
Text4.Locked = True
Text5.Locked = True
Text6.Locked = True
End Sub

Private Sub Form_Mouseup(Button As Integer, Shift As Integer, X As Single, Y As Single)
If Button = 2 Then PopupMenu mn0
End Sub

Private Sub mnu1_Click()
Text6.Visible = True
Label1.Caption = "北京"
Text1.Text = "天安门广场"
Text2.Text = "故宫"
Text3.Text = "北海公园"
Text4.Text = "颐和园"
Text5.Text = "香山"
Text6.Text = "天坛"
End Sub

Private Sub mnu2_Click()
Text6.Visible = True
Label1.Caption = "南京"
Text1.Text = "雨花台"
Text2.Text = "中山陵"
Text3.Text = "明孝陵"
Text4.Text = "灵谷寺"
Text5.Text = "栖霞山"
Text6.Text = "莫愁湖"
End Sub

Private Sub mnu3_Click()
Text6.Visible = True
Label1.Caption = "西安"
Text1.Text = "钟楼"
Text2.Text = "大雁楼"
Text3.Text = "小雁塔"
Text4.Text = "半坡博物馆"
Text5.Text = "秦始皇陵"
Text6.Text = "兵马俑"
End Sub

Private Sub mnu4_Click()
Label1.Caption = "昆明"
Text1.Text = "金殿"
Text2.Text = "西山龙门"
Text3.Text = "安宁温泉"
Text4.Text = "滇池"
Text5.Text = "大观公园"
Text6.Visible = False
End Sub
