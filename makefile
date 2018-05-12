SRC=			src
LIB=			usr/lib
EXE=			main
BUILD=			build

.PHONY:			all $(SRC) clean purge

all:			$(SRC)

$(SRC):
				$(MAKE) LIB=$(LIB) EXE=$(EXE) BUILD=$(BUILD) --directory=$@
				-mv -f $@/*.o $(LIB) 2>/dev/null ; true
				-mkdir -p $(BUILD)
				-mv -f $@/$(EXE) $(BUILD) 2>/dev/null ; true

clean:
				-rm -f $(SRC)/*.o
				-rm -f $(LIB)/*.o

purge:			clean
				-rm -f $(SRC)/$(EXE)
				-rm -rf $(BUILD)