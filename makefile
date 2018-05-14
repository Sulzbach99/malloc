SRC=			src
BUILD=			usr/bin
INCLUDE=		usr/include
LIB=			usr/lib
EXE=			main

.PHONY:			all pre $(SRC) post clean purge

all:			pre $(SRC) post

pre:
				-mkdir -p $(BUILD) $(INCLUDE) $(LIB)

$(SRC):
				$(MAKE) VPATH=../$(BUILD):../$(INCLUDE):../$(LIB) EXE=$(EXE) --directory=$@

post:
				-mv -f $(SRC)/*.o $(LIB) 2>/dev/null ; true
				-mv -f $(SRC)/$(EXE) $(BUILD) 2>/dev/null ; true

clean:
				-rm -f $(SRC)/*.o
				-rm -f $(LIB)/*.o

purge:			clean
				-rm -f $(SRC)/$(EXE)
				-rm -f $(BUILD)/*