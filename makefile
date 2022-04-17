.SILENT: test

default:
	make test

compile: scanner.o listing.o
	g++ -o compile scanner.o listing.o
	rm *.o
	
scanner.o: scanner.c listing.h tokens.h
	g++ -c scanner.c

scanner.c: scanner.l
	flex scanner.l
	mv lex.yy.c scanner.c

listing.o: listing.cc listing.h
	g++ -c listing.cc

test1:
	make compile
	./compile < test1.txt

test2:
	make compile
	./compile < test2.txt

test3:
	make compile
	./compile < test3.txt

test: 
	echo  "***** BUILDING EXECUTABLE *****"
	echo
	make compile
	echo
	echo "***** RUNNING TEST CASE 1 *****"
	echo
	./compile < test1.txt
	echo "***** RUNNING TEST CASE 2 *****"
	echo
	./compile < test2.txt
	echo
	echo "***** RUNNING TEST CASE 3 *****"
	echo
	./compile < test3.txt

test_log: 
	make test > test_results.txt
