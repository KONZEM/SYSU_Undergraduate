DATA SEGMENT
STRING DB 'AbCdEfGhIjKlMnOpQrStUvWxYz','$'
COUNT EQU $-STRING
DATA ENDS

CODE SEGMENT
ASSUME CS:CODE, DS:DATA
BEGIN:
    MOV AX, DATA
    MOV DS, AX
    LEA SI, STRING
    MOV CX, COUNT
    DEC CX
L:  
    MOV AL, [SI]   ;żУ??
    ADD AL, 0
    JP  NEXT
    OR 	AL, 80H
    MOV [SI], AL
NEXT:    
    INC SI
    LOOP L
    MOV AH, 4CH
    INT 21H
CODE ENDS
    END BEGIN