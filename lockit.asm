locals
.286
.model large, WINDOWS PASCAL
INCLUDE windows.inc

EXTRN   InitTask:PROC
EXTRN   ExitWindows:PROC

INCLUDE lockit.inc

.data

                DB 16 dup (0)

.code

Start:
        call    InitTask
        call    Main


Exit    PROC
        mov     ax, 4C00h
        int     21h
ENDP Exit

KillOS  PROC
	push	0
	push	0
	push	0
	call	ExitWindows
        call    Exit
ENDP KillOS

HangOS  PROC
        cli
        jmp     short HangOS
ENDP HangOS

END Start
