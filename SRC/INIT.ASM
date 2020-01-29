

;
;       Copyright (C) 2020 Joseph Combs - All Rights
;
;   INFO
;

	EXTERN _INIT_BEGIN
	EXTERN _INIT_END
	EXTERN _DATA_BEGIN
	EXTERN _STACK

	SECTION .INIT
	GLOBAL DosMain
	USE16

; skip system initialization data
DosMain:
	JMP  SHORT InitEnv
	NOP
	
STARTUPMSG:	DB 10, "Starting . . .", 10, 10, 13, 0

;
; Initialize the system's base
; state.
;
InitEnv:
	MOV  AH, 14
	MOV  AL, '&'
	INT  16
	
	MOV  AX, WORD [_DATA_BEGIN]
	MOV  CL, 4
	SHR  AX, BYTE CL
	MOV  DS, AX
	LEA  SI, [STARTUPMSG]
PRINT:
	LODSB
	OR   AL, 0
	JZ   SHORT RET001
	MOV  AH, 14
	MOV  BX, 7
	INT  16
	JMP  SHORT PRINT
RET001:
	JMP $
