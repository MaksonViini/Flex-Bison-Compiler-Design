one:
	bison -dv compiler/Mini_Parser.y 
	gcc -c Mini_Parser.tab.c
	flex compiler/Mini_Lexer.lex
	gcc -c lex.yy.c
	gcc -o Mini Mini_Parser.tab.o lex.yy.o -lm
	./Mini < tests/mini_lang.mini > tests/resultado_mini.txt

all: $(patsubst tests/teste%.mini, tests/resultado%.txt, $(wildcard tests/teste*.mini))

tests/resultado%.txt: tests/teste%.mini
	bison -dv compiler/Mini_Parser.y 
	gcc -c Mini_Parser.tab.c
	flex compiler/Mini_Lexer.lex
	gcc -c lex.yy.c
	gcc -o Mini Mini_Parser.tab.o lex.yy.o -lm
	./Mini < $< > $@
lex:
	flex test1/Mini_Lexer.lex
	gcc -o Mini Mini_Parser.tab.o lex.yy.o -lm
	./scanner < tests/teste1.mini > tests/resultado.txt


clean: 
	rm -rf Mini output.asm tests/resultado*.txt Mini_Parser Mini_Parser.output Mini_Parser.tab.c Mini_Parser.tab.h Mini_Parser.tab.o lex.yy.c lex.yy.o y.tab.c y.tab.h

