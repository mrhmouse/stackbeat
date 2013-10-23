DMD = dmd
FLAGS = -release -inline -w -O -ofstackbeat -odbin
SOURCES = stackbeat.d tokenizer.d

all:
	mkdir bin
	$(DMD) $(FLAGS) $(SOURCES)

clean:
	rm -rf bin
	rm stackbeat
