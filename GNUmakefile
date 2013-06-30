.PHONY: all clean

all: map

map: fun.S map.c
	gcc fun.S map.c -O3 -o map

clean:
	rm -rf map
