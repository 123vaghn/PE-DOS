
;
;       Copyright (C) 2020 Joseph Combs - All Rights Reserved
;

	ORG 7C00H
	USE16

	JMP  SHORT INITREGS
	NOP

		DB "IBM  5.0"
BYTPERSEC:	DW 512		; total bytes per sector on this volume
SECPERCLUST:	DB 1		; total sectors per cluster on this volume
RESERVED:	DW 1		; unused
FATCNT:		DB 2		; total FATs on this volume
ROOTCNT:	DW 224		; total entries in the Root Directory
		DW 80 * 36
		DB 240
SECPERFAT:	DW 9		; total sectors per FAT on this volume
SECPERTRACK:	DW 18		; total sectors per track on this idks
CYLHEADCNT:	DW 2		; total heads per cyliner on this idks
		DD 0
		DD 0
		DB 0
		DB 0
		DB 41
		DD 0
		DB "           "
		DB "FAT12   "

;
; PEDOS MEMORY MAP
;
;   -   |  ROM / VIDEO  -- A000:0
;   -   -----------------
;   -   |  BIOS DATA    -- 8000:0
;   -   -----------------
;   -   |  FREE         -- ????:?
;   -   -----------------
;   -   |  BOOT / FREE  -- 0000:7C00
;   -   -----------------
;   -   |  FREE         -- ????:?
;   -   -----------------
;   -   |  DRIVERS      -- ????:?
;   -   -----------------
;   -   |  SYSTEM       -- 0050:0
;   -   -----------------
;   -   |  BIOS BATA    -- 0000:400
;   -   -----------------
;   -   |  IVT          -- 0000:0
;

LOADSEG	EQU 50H	; READ TO THIS SEGMENT
		; (NULL OFFSET)

INITREGS:
	CLI
	XOR  AX, AX
	MOV  DS, AX
	MOV  ES, AX
	MOV  SS, AX
	MOV  SP, 7C00H
	MOV  BP, SP
	STI
SETCODE:
	PUSH DS
	PUSH WORD FNDROOTSZ
	RETF
;
; Load the Root Directory, then search
; for DOSBIOS.sys.
FNDROOTSZ:
	MOV  AL, BYTE [FATCNT]
	MOV  BX, WORD [SECPERFAT]
	MUL  BX
	ADD  AX, WORD [RESERVED]
	PUSH AX
LOADROOT:
	MOV  DI, 1
	MOV  BX, 500H
	MOV  BP, BX	; BP now contains our load offset
	CALL READSEC
;
; Load DOSBIOS.sys from the fixed
; location on the disk.
FINDFLE:
	MOV  CX, 11
	MOV  DI, BP
	LEA  SI, [FILE]
	CLD
	REPE CMPSB
	JE   LOADFILE
	LEA  SI, [FNFMSG]
	JMP  PRINT
;
; Since we are sure of DOSBIOS.sys'
; existence, read it into memory.
LOADFILE:	
	MOV  AX, 32
	MOV  BX, WORD [ROOTCNT]
	MUL  BX
	MOV  BX, WORD [BYTPERSEC]
	DIV  BX
	MOV  BX, AX
	POP  AX
	ADD  AX, BX
	MOV  DI, 1
	MOV  BX, BP	; ^BP = load offset
	CALL READSEC
;
; Finally, transfer CPU execution to
; DOSBIOS.sys.
RUNDOS:
	PUSH WORD LOADSEG
	PUSH 0
	RETF

;
; READ THE SPECIFIED SECTORS INTO MEMORY
; AT LOGICAL ES:BX       
;
; IN:	AX:DX	= HEAD, TRACK, SECTOR NUMBER
;	DI	= SECTOR COUNT
;

READSEC:
	PUSHA
	DIV  WORD [SECPERTRACK]
	;
	; AX = LBA / SECPERTRACK
	; DX = LBA % SECPERTRACK
	;
	MOV  CX, DX
	INC  CX		; CX = LBA 1
	XOR  DX, DX
	DIV  WORD [CYLHEADCNT]
	;
	; AX = (LBA / SECPERTRACK) / CYLHEADCNT = CYLINDER
	; DX = (LBA / SECPERTRACK) % CYLHEADCNT = HEAD
	;
	MOV  CH, AL
	SHL  AH, 6
	OR   CL, AH
	MOV  DH, DL
	MOV  DL, 0
	;
	; DH = HEAD HUMBER
	; DL = DRIVE
	;
	MOV  AH, 2
	MOV  AL, 1
	INT  19
	JNC  NEXTSEC		; IN CASE OF ERRORS, FOLLOW
	LEA  SI, [IOEMSG]	; BELOW SUBROUTE
	JMP  PRINT
NEXTSEC:
	POPA
	DEC  DI
	JZ   RET001
	ADD  BX, WORD [BYTPERSEC]
	ADD  AX, 1
	ADC  DX, 0
	JMP  READSEC
RET001:
	RET

;
; Write the specified character string to 
; video memory: NOTE: This subroutine does
; not return.
;
; IN:
;	DS:SI = address of string
;

PRINT:
	LODSB
	OR   AL, 0
	JZ   HALT
	MOV  AH, 14
	MOV  BX, 7
	INT  16
	JMP  PRINT
HALT:
	CLI
	HLT
	JMP  HALT
	NOP

	TIMES ((512 - 2) - (MARKER - IOEMSG)) - ($ - $$) DB 0

; Error Messages
IOEMSG:	DB 10, "Disk read error.", 13, 10, 0
FNFMSG:	DB 10, "DOSBIOS.sys is missing.", 13, 10, 0
; System file
FILE:	DB "DOSBIOS SYS"
; BIOS boot flag
MARKER:	DW 0AA55H
