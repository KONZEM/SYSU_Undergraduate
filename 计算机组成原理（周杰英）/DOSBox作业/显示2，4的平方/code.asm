DATA SEGMENT
TABLE DB 0,1, 4, 9, 16, 25, 36, 49, 64, 81
DATA ENDS

CODE SEGMENT
ASSUME CS:CODE, DS:DATA
BEGIN:
      MOV AX, DATA
      MOV DS, AX
      LEA BX, TABLE
      MOV AL, 2
      XLAT
      MOV DL, 30H
      ADD DL, AL
      MOV AH, 02H
      INT 21H
      MOV DL, 0DH
      MOV AH, 02H
      INT 21H
      MOV DL, 0AH
      MOV AH, 02H
      INT 21H
      MOV AL, 4
      XLAT
      AAM
      MOV DL, 30H
      ADD DL, AH
      MOV AH, 02H
      INT 21H
      MOV AL, 4
      XLAT
      AAM
      MOV DL, 30H
      ADD DL, AL
      MOV AH, 02H
      INT 21H
      MOV AH, 4CH
      INT 21H
CODE ENDS
     END BEGIN