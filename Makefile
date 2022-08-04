GCC = gcc -Wall -g
EXE = telemetry
INC_DIR = -I inc/
temp = $(shell find src/ -type f |  sed 's|^.*/|obj/|')
objs = $(temp:.c=.o)

all: bin/$(EXE)	

bin/$(EXE): $(objs:.s=.o)
	$(GCC) $(objs:.s=.o) -o bin/$(EXE)

obj/%.o: src/%.c	
	$(GCC) -c $(INC_DIR) $< -o $@

obj/%.o: src/%.s	
	$(GCC) -c $(INC_DIR) $< -o $@

clean:
	rm -f obj/* bin/*%