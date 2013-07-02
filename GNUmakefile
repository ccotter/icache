.PHONY: all clean

all: map pic

pic: pic.S unprot.c
	gcc pic.S unprot.c -O3 -o pic

map: fun.S map.c
	gcc map.c -O3 -m32 -Wl,-no_pie -S
	gcc fun.S map.c -O3 -o map -m32 -Wl,-no_pie

clean:
	rm -rf map
