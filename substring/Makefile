substring: substring.o
	ld -o $@ $<

substring.o: substring.asm
	nasm -f elf64 -o $@ $<
