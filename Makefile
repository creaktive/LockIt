NAME = lockit
CMOS = cmos
OBJS = $(NAME).obj $(CMOS).obj
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

$(NAME).EXE: $(OBJS) $(DEF)
  brc -k -r $(NAME)
  tlink /x /Twe /Oc /Oi /Oa /Or $(LINKDEBUG) $(OBJS),$(NAME),, $(IMPORT), $(DEF), $(RES)

.ASM.OBJ:
   tasm $(TASMDEBUG) /ml $(THEINCLUDE) $&.asm

$(CMOS).OBJ: $(CMOS).asm
