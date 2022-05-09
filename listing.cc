/**
 * File: listing.cc
 * Author: Tim M
 * Date: 3 April 2022
 * Purpose: This file contains the bodies of the functions that produces the compilation listing.
 */


#include <cstdio>
#include <string>
//#include <iostream>

using namespace std;

#include "listing.h" // references listing.h 

static int lineNumber;
static string error = "";
static int totalErrors = 0;
static int lexical = 0;
static int semantic = 0;
static int syntactic = 0;

static void displayErrors();

/**
 * This function the first line.
 */
void firstLine()
{
	lineNumber = 1;
	printf("\n%4d  ",lineNumber);
}

/**
 * This function calls displayError(),
 * increments line number, and displays
 * the line number.
 */
void nextLine()
{
	displayErrors();
	lineNumber++;
	printf("%4d  ",lineNumber);
}

/**
 * This function displays each type of error and its
 * number of occurences. If there are no errors, the message "Compiled
 * Successfully" is displayed.
 */
void printFileErrors()
{
	if (totalErrors)
	{
		printf("Lexical Errors: %d\n", lexical);
		printf("Semantic Errors: %d\n", semantic);
		printf("Syntactical Errors: %d\n", syntactic);
	} else
	{
		printf("Compiled Successfully\n\n");	
	}
}

/**
 * This function calls printFileErrors() and prints
 * the message on the space between line numbers. This 
 * function returns the total amount of errors. 
 */
int lastLine()
{
	printf("\r");
	displayErrors();
	printf("     \n");

	printFileErrors();

	return totalErrors;
}

/**
 * This function increments each type of error as 
 * they are recognized by the analyzer. 
 */
void incrementErrorType(ErrorCategories errorCategory)
{
	switch (errorCategory)
	{
	case ErrorCategories::LEXICAL:
		lexical++;
		break;
	case ErrorCategories::GENERAL_SEMANTIC:
		semantic++;
		break;
	case ErrorCategories::SYNTAX:
		syntactic++;
		break;
	case ErrorCategories::UNDECLARED:
		semantic++;
		break;
	default:
		break;
	}
}

/**
 * This function calls incrementErrorType and updates 
 * the error message.
 */
void appendError(ErrorCategories errorCategory, string message)
{
	string messages[] = { "Lexical Error, Invalid Character ", "",
		"Semantic Error, ", "Semantic Error, Duplicate Identifier: ",
		"Semantic Error, Undeclared " };

	error = messages[errorCategory] + message;
	totalErrors++;

	incrementErrorType(errorCategory);
}

/**
 * This function displays the error message 
 * for each line.
 */
void displayErrors()
{
	if (error != "")
		printf("%s\n", error.c_str());
	error = "";
}
