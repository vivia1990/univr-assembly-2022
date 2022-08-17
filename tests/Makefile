GCC = gcc -Wall -g -m32 -I inc/ -no-pie
EXE = test
objs = $(shell find ../src/ -type f -not -name '*.c' |  sed 's|^.*/|../src/|')
tests = $(shell find src/ -type f -name '*.c')

all: bin/$(EXE)	

bin/$(EXE):
	$(GCC) $(objs) $(tests) -o bin/$(EXE)

clean:
	rm -f bin/*