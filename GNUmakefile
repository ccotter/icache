.PHONY: all clean

all: map pic

pic: pic.S unprot.c
	gcc pic.S unprot.c -O3 -o pic

map: fun.S map.c
	gcc fun.S map.c -O3 -o map -m32

clean:
	rm -rf map
