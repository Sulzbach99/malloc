CC=				gcc
CFLAGS=			-g -Wall

AS=				as
ASFLAGS=		-g

all:			main

main:			main.o malloc.o

main.o:			main.c
malloc.o:
				$(AS) malloc.s -o malloc.o $(ASFLAGS)