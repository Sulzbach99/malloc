CC=				gcc
CFLAGS=			-g -Wall

AS=				as
ASFLAGS=		-g

.PHONY:			all

all:			$(EXE)

$(EXE):			$(EXE).o common.o malloc.o memmap.o

$(EXE).o:		$(EXE).c common.h

common.o:		common.s
				$(AS) $< -o $@ $(ASFLAGS)

malloc.o:		malloc.s
				$(AS) $< -o $@ $(ASFLAGS)

memmap.o:		memmap.s
				$(AS) $< -o $@ $(ASFLAGS)