VPATH=			../$(LIB):../$(BUILD)

CC=				gcc
CFLAGS=			-g -Wall

AS=				as
ASFLAGS=		-g

.PHONY:			all

all:			$(EXE)

$(EXE):			main.o malloc.o

main.o:			main.c
malloc.o:
				$(AS) malloc.s -o malloc.o $(ASFLAGS)