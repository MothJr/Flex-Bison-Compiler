.SILENT: test
.SILENT: test_error

default:
	make test

compile: scanner.o parser.o listing.o types.o
	g++ -o compile scanner.o parser.o listing.o types.o
	rm *.o
	
scanner.o: scanner.c types.h listing.h tokens.h
	g++ -c scanner.c

scanner.c: scanner.l
	flex scanner.l
	mv lex.yy.c scanner.c

parser.o: parser.c types.h listing.h symbols.h
	g++ -c parser.c

parser.c tokens.h: parser.y
	bison -d -v parser.y
	mv parser.tab.c parser.c
	cp parser.tab.h tokens.h

listing.o: listing.cc listing.h
	g++ -c listing.cc

types.o: types.cc types.h
	g++ -c types.cc

test1:
	make compile
	./compile < Test_Files/test1.txt

test2:
	make compile
	./compile < Test_Files/test2.txt

test3:
	make compile
	./compile < Test_Files/test3.txt

test4:
	make compile
	./compile < Test_Files/test4.txt

test5:
	make compile
	./compile < Test_Files/test5.txt

test: 
	echo  "***** BUILDING EXECUTABLE *****"
	echo
	make compile
	echo
	echo "***** RUNNING TEST CASE 1 *****"
	echo
	./compile < Test_Files/test1.txt
	echo
	echo "***** RUNNING TEST CASE 2 *****"
	echo
	./compile < Test_Files/test2.txt
	echo
	echo "***** RUNNING TEST CASE 3 *****"
	echo
	./compile < Test_Files/test3.txt
	echo
	echo "***** RUNNING TEST CASE 4 *****"
	echo
	./compile < Test_Files/test4.txt
	echo
	echo "***** RUNNING TEST CASE 5 *****"
	echo
	./compile < Test_Files/test5.txt
	

test_log: 
	make test > test_results.txt


test1_error:
	make compile
	./compile < Test_Files_Errors/test1_error.txt

test2_error:
	make compile
	./compile < Test_Files_Errors/test2_error.txt

test3_error:
	make compile
	./compile < Test_Files_Errors/test3_error.txt

test4_error:
	make compile
	./compile < Test_Files_Errors/test4_error.txt

test5_error:
	make compile
	./compile < Test_Files_Errors/test5_error.txt

test6_error:
	make compile
	./compile < Test_Files_Errors/test6_error.txt

test_error: 
	echo  "***** BUILDING EXECUTABLE *****"
	echo
	make compile
	echo
	echo "***** RUNNING TEST_ERROR CASE 1 *****"
	echo
	./compile < Test_Files_Errors/test1_error.txt
	echo
	echo "***** RUNNING TEST_ERROR CASE 2 *****"
	echo
	./compile < Test_Files_Errors/test2_error.txt
	echo
	echo "***** RUNNING TEST_ERROR CASE 3 *****"
	echo
	./compile < Test_Files_Errors/test3_error.txt
	echo
	echo "***** RUNNING TEST_ERROR CASE 4 *****"
	echo
	./compile < Test_Files_Errors/test4_error.txt
	echo
	echo "***** RUNNING TEST_ERROR CASE 5 *****"
	echo
	./compile < Test_Files_Errors/test5_error.txt
	echo
	echo "***** RUNNING TEST_ERROR CASE 6 *****"
	echo
	./compile < Test_Files_Errors/test6_error.txt
	
test_error_log: 
	make test_error > test_errors_results.txt

