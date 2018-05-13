SRC=			src
BUILD=			usr/bin
INCLUDE=		usr/include
LIB=			usr/lib
EXE=			main

.PHONY:			all $(SRC) clean purge

all:			$(SRC)

$(SRC):
				$(MAKE) VPATH=../$(BUILD):../$(INCLUDE):../$(LIB) EXE=$(EXE) --directory=$@
				-mv -f $@/*.o $(LIB) 2>/dev/null ; true
				-mv -f $@/$(EXE) $(BUILD) 2>/dev/null ; true

clean:
				-rm -f $(SRC)/*.o
				-rm -f $(LIB)/*.o

purge:			clean
				-rm -f $(SRC)/$(EXE)
				-rm -f $(BUILD)/*