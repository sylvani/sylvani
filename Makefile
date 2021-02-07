all:
	cd src; \
	flex -o scanner.cpp sylvani.l; \
	bison -o parser.cpp sylvani.y; \
	g++ -g -o sylc scanner.cpp parser.cpp main.cpp; \
	# ./sylc
		
clean:
	cd src; \
	rm -r sylc*; \
	rm -r scanner.cpp parser.cpp parser.hpp; \
	rm -r location.hh position.hh stack.hh