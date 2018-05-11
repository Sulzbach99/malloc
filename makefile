CC=				gcc
CFLAGS=			-g -Wall

AS=				as
ASFLAGS=		-o

all:			pre-build malloc.o

pre-build:
				mkdir -p usr/lib

malloc.o:
				$(AS) src/malloc.s $(ASFLAGS) usr/lib/malloc.o

clean:
				rm -f usr/lib/*

purge:
				rm -rf usr