locals
.286
.model large, WINDOWS PASCAL

GLOBAL  ReadCMOS:PROC
GLOBAL  WriteCMOS:PROC
GLOBAL  ReadCMOSW:PROC
GLOBAL  WriteCMOSW:PROC
GLOBAL  CalculateChecksum:PROC

.data
.code

;*************************************
; CMOS Accessing routines
;*************************************
ReadCMOS PROC PASCAL
        ARG     CMOSfunc:BYTE

        xor     ax, ax

        mov     al, [CMOSfunc]
        out     70h, al
        in      al, 71h

        ret
ENDP ReadCMOS


WriteCMOS PROC PASCAL
        ARG     Location:BYTE, Value:BYTE
        USES    ax

        mov     al, [Location]
        out     70h, al
        mov     al, [Value]
        out     71h, al

        ret
ENDP WriteCMOS


ReadCMOSW PROC PASCAL
        ARG     Location:WORD
        USES    bx

        push    [Location]
        call    ReadCMOS
        mov     bh, al

        inc     [Location]

        push    [Location]
        call    ReadCMOS
        mov     bl, al

        mov     ax, bx

        ret
ENDP ReadCMOSW


WriteCMOSW PROC PASCAL
        ARG     Location:WORD, Value:WORD
        USES    ax, bx

        push    [Location]
        push    [WORD PTR Value+1]
        call    WriteCMOS

        inc     [Location]

        push    [Location]
        push    [WORD PTR Value+0]
        call    WriteCMOS

        ret
ENDP WriteCMOSW


;*************************************
; CMOS Checksum routines
;*************************************
CalculateChecksum PROC PASCAL
        ARG     From:BYTE, To:BYTE
        USES    bx, cx

        xor     bx, bx
        mov     cl, [From]
        jmp     short CheckEnd

Looping:
        push    cx
        call    ReadCMOS

        add     bx, ax
        inc     cl

CheckEnd:
        cmp     cl, [To]
        jle     short Looping

        mov     ax, bx

        ret
ENDP CalculateChecksum

END
