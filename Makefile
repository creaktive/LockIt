NAME = lockit
CORE = core
CMOS = cmos
STUB = stub
OBJS = $(CORE).obj $(CMOS).obj
DEF  = $(NAME).def
RES  = $(NAME).res

!if $d(DEBUG)
TASMDEBUG=/zi
LINKDEBUG=/v
!else
TASMDEBUG=
LINKDEBUG=
!endif

!if $d(MAKEDIR)
IMPORT=$(MAKEDIR)\..\lib\import
THEINCLUDE=/i$(MAKEDIR)\..\include
!else
IMPORT=import
THEINCLUDE=
!endif

$(NAME).EXE: $(NAME).obj $(OBJS) $(STUB).exe
  brc -k -r $(NAME)
  tlink /x /Twe /Oc /Oi /Oa /Or $(LINKDEBUG) $(NAME).obj $(OBJS),$(NAME),, \
        $(IMPORT), $(DEF), $(RES)
  del stub.exe

$(STUB).EXE: $(STUB).obj $(OBJS)
  tlink /x /Tde $(LINKDEBUG) $(STUB).obj $(OBJS),$(STUB)

.ASM.OBJ:
  tasm $(TASMDEBUG) /ml $(THEINCLUDE) $&.asm
