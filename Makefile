default:
	/usr/local/opt/bison/bin/bison -o sylcc src/sylvani.y

report:
	/usr/local/opt/bison/bin/bison src/sylvani.y --report=all
		
clean:
	clear
	rm -r *.output
	rm -r *.tab.c
	rm sylc