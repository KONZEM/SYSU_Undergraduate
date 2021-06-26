VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   9420
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   14760
   LinkTopic       =   "Form1"
   ScaleHeight     =   9420
   ScaleWidth      =   14760
   StartUpPosition =   3  '窗口缺省
   Begin VB.CommandButton Command5 
      Caption         =   "确定"
      Height          =   615
      Left            =   3600
      TabIndex        =   13
      Top             =   3720
      Width           =   975
   End
   Begin VB.CommandButton Command4 
      Caption         =   "确定"
      Height          =   615
      Left            =   840
      TabIndex        =   12
      Top             =   3720
      Width           =   975
   End
   Begin VB.CommandButton Command3 
      Caption         =   "结束"
      Height          =   495
      Left            =   4920
      TabIndex        =   11
      Top             =   2760
      Width           =   975
   End
   Begin VB.CommandButton Command2 
      Caption         =   "继续选择"
      Height          =   495
      Left            =   4920
      TabIndex        =   10
      Top             =   1080
      Width           =   855
   End
   Begin VB.VScrollBar VScroll1 
      Height          =   735
      Left            =   10560
      TabIndex        =   9
      Top             =   3120
      Width           =   855
   End
   Begin VB.HScrollBar HScroll1 
      Height          =   735
      Left            =   7920
      TabIndex        =   8
      Top             =   3120
      Width           =   975
   End
   Begin VB.Frame Frame1 
      Caption         =   "Frame1"
      Height          =   495
      Left            =   11880
      TabIndex        =   7
      Top             =   1800
      Width           =   1095
   End
   Begin VB.OptionButton Option1 
      Caption         =   "Option1"
      Height          =   495
      Left            =   9960
      TabIndex        =   6
      Top             =   1800
      Width           =   1095
   End
   Begin VB.CheckBox Check1 
      Caption         =   "Check1"
      Height          =   615
      Left            =   7800
      TabIndex        =   5
      Top             =   1920
      Width           =   1215
   End
   Begin VB.TextBox Text1 
      Height          =   735
      Left            =   11880
      TabIndex        =   4
      Text            =   "Text1"
      Top             =   360
      Width           =   975
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Command1"
      Height          =   855
      Left            =   9840
      TabIndex        =   3
      Top             =   240
      Width           =   975
   End
   Begin VB.ListBox List2 
      Height          =   2580
      Left            =   840
      TabIndex        =   1
      Top             =   960
      Width           =   1695
   End
   Begin VB.ListBox List1 
      Height          =   2580
      Left            =   3240
      TabIndex        =   0
      Top             =   960
      Width           =   1575
   End
   Begin VB.Label Label1 
      Caption         =   "Label1"
      Height          =   735
      Left            =   7800
      TabIndex        =   2
      Top             =   240
      Width           =   975
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim a%
Private Sub Command2_Click()
a = -1
List1.Visible = True
Command4.Visible = True
List2.Visible = True
Command5.Visible = True
Form1.MouseIcon = 0
Command1.Visible = False
Command1.MousePointer = 0
Text1.Visible = False
Text1.MousePointer = 0
Label1.Visible = False
Label1.MousePointer = 0
Frame1.Visible = False
Frame1.MousePointer = 0
Check1.Visible = False
Check1.MousePointer = 0
Option1.Visible = False
Option1.MousePointer = 0
HScroll1.Visible = False
HScroll1.MousePointer = 0
VScroll1.Visible = False
VScroll1.MousePointer = 0
MsgBox "左边选择控件或窗体，右边选择鼠标移到该控件或窗体时的形状"
End Sub

Private Sub Command3_Click()
End
End Sub

Private Sub Command4_Click()
List2.Visible = False
Command4.Visible = False
Dim i%
For i = 0 To 8
If List2.Selected(i) Then a = i
Next i
If List2.Selected(1) Then Command1.Visible = True
If List2.Selected(2) Then Text1.Visible = True
If List2.Selected(3) Then Label1.Visible = True
If List2.Selected(4) Then Frame1.Visible = True
If List2.Selected(5) Then Check1.Visible = True
If List2.Selected(6) Then Option1.Visible = True
If List2.Selected(7) Then HScroll1.Visible = True
If List2.Selected(8) Then VScroll1.Visible = True
End Sub

Private Sub Command5_Click()
If a = -1 Then MsgBox "请先选择控件或窗体"
If a <> -1 Then
List1.Visible = False
Command5.Visible = False
Dim i%
For i = 0 To 14
If List1.Selected(i) Then
    If a = 0 Then Form1.MousePointer = i + 1
    If a = 1 Then Command1.MousePointer = i + 1
    If a = 2 Then Text1.MousePointer = i + 1
    If a = 3 Then Label1.MousePointer = i + 1
    If a = 4 Then Frame1.MousePointer = i + 1
    If a = 5 Then Check1.MousePointer = i + 1
    If a = 6 Then Option1.MousePointer = i + 1
    If a = 7 Then HScroll1.MousePointer = i + 1
    If a = 8 Then VScroll1.MousePointer = i + 1
Exit For
End If
Next i
End If
End Sub

Private Sub Form_Load()
a = -1
Command1.Visible = False
Text1.Visible = False
Label1.Visible = False
Frame1.Visible = False
Check1.Visible = False
Option1.Visible = False
HScroll1.Visible = False
VScroll1.Visible = False
MsgBox "左边选择控件或窗体，右边选择鼠标移到该控件或窗体时的形状"
List1.List(0) = "箭头"
List1.List(1) = "十字线"
List1.List(2) = "I型"
List1.List(3) = "图标"
List1.List(4) = "尺寸线"
List1.List(5) = "右上左下尺寸线"
List1.List(6) = "垂直尺寸线"
List1.List(7) = "左上右下尺寸线"
List1.List(8) = "水平尺寸线"
List1.List(9) = "向上的箭头"
List1.List(10) = "沙漏"
List1.List(11) = "圆形记号"
List1.List(12) = "箭头和沙漏"
List1.List(13) = "箭头和文号"
List1.List(14) = "四向尺寸线"
List2.List(0) = "Form1"
List2.List(1) = "Command1"
List2.List(2) = "Text1"
List2.List(3) = "Label1"
List2.List(4) = "Frame1"
List2.List(5) = "Check1"
List2.List(6) = "Option1"
List2.List(7) = "HScroll1"
List2.List(8) = "VScroll1"
End Sub


