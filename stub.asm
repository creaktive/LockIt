locals
.286
.model small, PASCAL
.stack 256

INCLUDE lockit.inc

.data
.code

Start:
        mov     ax, @data
        mov     ds, ax

        call    Main


Exit    PROC
        mov     ax, 4C00h
        int     21h
ENDP Exit

KillOS  PROC
        mov     al, 0FEh
        out     64h, al
ENDP KillOS

HangOS  PROC
        cli
        hlt
ENDP HangOS

END Start
