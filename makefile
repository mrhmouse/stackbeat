all: pegged
	dmd parser.d lib/Pegged/libpegged.a -I./lib/Pegged

pegged:
	make -C lib/Pegged

clean:
	rm parser.o parser
