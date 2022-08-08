GCC = gcc -Wall -g -m32 -I inc/ -no-pie
EXE = test
objs = $(shell find ../src/ -type f -not -name '*.c' |  sed 's|^.*/|../src/|')

all: bin/$(EXE)	

bin/$(EXE):
	$(GCC) $(objs) ../src/main.c -o bin/$(EXE)

clean:
	rm -f bin/*