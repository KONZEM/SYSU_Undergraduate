DATA SEGMENT
NUM EQU 8
BUFFER DB NUM DUP(0)
DATA ENDS

CODE SEGMENT
ASSUME CS:CODE, DS:DATA
BEGIN:
      MOV AX, CS
      MOV DS, AX
      MOV DX, OFFSET SUB_PROC
      MOV AX, 250BH
      INT 21H
      MOV AX, DATA
      MOV DS, AX
      LEA BX, BUFFER
      MOV CX, NUM
      CLI
      MOV DX, 21H
      IN AL, DX
      AND AL, 0F7H
      OUT DX, AL
      STI
      MOV DX, 298H
      OUT DX, AL
      HLT
SUB_PROC:
      IN AL, DX
      MOV [BX], AL
      INC DX
      INC BX
      OUT DX, AL
      MOV AL, 20H
      OUT 20H, AL
      DEC CX
      JNZ NEXT
      IN AL, 21H
      OR AL, 08H
      OUT 21H, AL
      STI
      MOV AH, 4CH
      INT 21H
NEXT: IRET
CODE ENDS
      END BEGIN