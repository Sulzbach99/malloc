CC=				gcc
CFLAGS=			-g -Wall

AS=				as
ASFLAGS=		-g

.PHONY:			all

all:			$(EXE)

$(EXE):			$(EXE).o malloc.o memmap.o

$(EXE).o:		$(EXE).c common.h

malloc.o:		malloc.s
				$(AS) $< -o $@ $(ASFLAGS)

memmap.o:		memmap.s
				$(AS) $< -o $@ $(ASFLAGS)