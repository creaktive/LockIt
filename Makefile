OBJS = core.obj cmos.obj
DEF  = lockit.def
RES  = lockit.res

!if $d(DEBUG)
TASMDEBUG=/zi
LINKDEBUG=/v
CCDEBUG=/v
!else
TASMDEBUG=
LINKDEBUG=
CCDEBUG=
!endif

!if $d(MAKEDIR)
IMPORT=$(MAKEDIR)\..\lib\import
THEINCLUDE=/i$(MAKEDIR)\..\include
!else
IMPORT=import
THEINCLUDE=
!endif


!if $d(SETDOWNONLY)
LOCKIT=
!else
LOCKIT=lockit.exe
!endif

!if $d(LOCKITONLY)
SETDOWN=
!else
SETDOWN=setdown.exe
!endif


Main: $(LOCKIT) $(SETDOWN)

LOCKIT.EXE: lockit.obj $(OBJS) stub.exe
  brc -k -r lockit
  tlink /x /Twe /Oc /Oi /Oa /Or $(LINKDEBUG) lockit.obj $(OBJS),lockit,, \
        $(IMPORT), $(DEF), $(RES)

STUB.EXE: stub.obj $(OBJS)
  tlink /x /Tde $(LINKDEBUG) stub.obj $(OBJS),stub

.ASM.OBJ:
  tasm $(TASMDEBUG) /ml $(THEINCLUDE) $&.asm

SETDOWN.EXE:
  tcc $(CCDEBUG) -O -G setdown.c
