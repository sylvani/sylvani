all:
	flex -o scanner.cpp sylvani.l
	bison -o parser.cpp sylvani.y 
	g++ -g -o a.out scanner.cpp parser.cpp main.cpp
		
clean:
	rm -r scanner.cpp parser.cpp parser.hpp
	rm -r location.hh position.hh stack.hh
	rm -r a.out