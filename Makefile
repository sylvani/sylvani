report:
	bison src/sylvani.y --report=all
		
clean:
	clear
	rm -r *.output
	rm -r *.tab.c