GCC = gcc -m32
EXE = telemetry
temp = $(shell find src/ -type f |  sed 's|^.*/|obj/|')
objs = $(temp:.c=.o)

all: bin/$(EXE)	

bin/$(EXE): $(objs:.s=.o)
	$(GCC) -no-pie $(objs:.s=.o) -o bin/$(EXE)

obj/%.o: src/%.c	
	$(GCC) -c $< -o $@

obj/%.o: src/%.s	
	$(GCC) -c $< -o $@

clean:
	rm -f obj/* bin/*