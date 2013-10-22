all:
	dmd stackbeat.d tokenizer.d -release -w -O

clean:
	rm stackbeat.o*
	rm stackbeat || rm stackbeat.exe
