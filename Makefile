default:
	clear
	flex src/sylvani.l
	cc lex.yy.c -ll
	./a.out
	# bison -dv sylvani.y 
	# gcc -o sylvani sylvani.tab.c lex.yy.c -lfl
