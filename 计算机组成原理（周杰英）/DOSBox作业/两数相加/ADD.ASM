DATA SEGMENT
NUM1 DB 10, ?, 10 DUP('$')
NUM2 DB 10, ?, 10 DUP('$')
ANS DW 0
DATA ENDS

CODE SEGMENT
ASSUME CS:CODE, DS:DATA
MAIN PROC FAR
BEGIN:
     PUSH DS
     MOV AX, 0
     PUSH AX
     MOV AX, DATA
     MOV DS, AX

     LEA DX, NUM1
     MOV AH, 0AH
     INT 21H		;输入第一个数字
     CALL LF
     LEA DX, NUM2
     MOV AH, 0AH
     INT 21H
     CALL LF		;输入第二个数字

     LEA DI, NUM1+2
     LEA SI, NUM2+2
     MOV CX, 4
L1:
     MOV AL, [DI]
     MOV BL, [SI]
     SUB AL, 30H
     SUB BL, 30H
     MOV [DI], AL
     MOV [SI], BL
     INC DI
     INC SI
     LOOP L1		;去 ''

     LEA DI, NUM1+2
     LEA SI, NUM2+2
     MOV CX, 3
     MOV DX,10
     MOV AX, 0
     MOV BX, 0
     ADD BL, [DI]
     ADD BL, [SI]
     ADD AX, BX
     INC DI
     INC SI
L2:
     MUL DX
     MOV DX, 10		;此时DX=0，必须重新赋值
     MOV BX, 0    
     ADD BL, [DI]
     ADD BL, [SI]
     ADD AX, BX
     INC DI
     INC SI
     LOOP L2		  
     LEA DI, ANS
     MOV [DI], AX
     ;INT 03H		;算出结果
     
     MOV CX, 16
     MOV BX, AX		;要用到AX
L3:
     SHL BX, 1
     JNC ZERO
     MOV DL, 31H
     JMP NEXT
ZERO:
     MOV DL, 30H
NEXT:
     MOV AH, 02H
     INT 21H     
     LOOP L3		;二进制
     CALL CR_LF

     MOV DL, [DI+1]
     MOV CL, 4
     SHR DL, CL
     CALL SHOW_HEX
     MOV DL, [DI+1]
     AND DL, 0FH
     CALL SHOW_HEX
     MOV DL, [DI]
     ;AND DL, 0F0H	;错误
     MOV CL, 4
     SHR DL, CL
     CALL SHOW_HEX
     MOV DL, [DI]
     AND DL, 0FH
     CALL SHOW_HEX	;十六进制
     CALL CR_LF

     RET
MAIN ENDP

LF PROC NEAR
     MOV DL, 0AH
     MOV AH, 02H
     INT 21H
     RET
LF ENDP

CR_LF PROC NEAR
     MOV DL, 0DH
     MOV AH, 02H
     INT 21H
     CALL LF
     RET
CR_LF ENDP

SHOW_HEX PROC NEAR
     CMP DL, 9
     JBE DIGIT
     ADD DL, 7
DIGIT:
     ADD DL, 30H
     MOV AH, 02H
     INT 21H
     RET
SHOW_HEX ENDP

CODE ENDS
     END MAIN