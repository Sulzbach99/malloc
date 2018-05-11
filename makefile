all:
				cd src; make; cd ..
				mv src/*.o usr/lib
				mkdir -p build
				mv src/main build

clean:
				rm -f src/*.o
				rm -f usr/lib/*

purge:			clean
				rm -f src/main
				rm -rf build