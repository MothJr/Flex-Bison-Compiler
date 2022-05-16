// Compiler Theory and Design
// Tim McNeill
// 14 May 2022
// This file contains the bodies of the type checking functions

#include <string>
#include <vector>

using namespace std;

#include "types.h"
#include "listing.h"

void checkAssignment(Types lValue, Types rValue, string message)
{
	if (lValue == BOOL_TYPE && rValue != BOOL_TYPE) 
	{
		appendError(GENERAL_SEMANTIC, "Type Mismatch on " + message);
	}
	 if (lValue != BOOL_TYPE && rValue == BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Type Mismatch on " + message);
	}
	if (lValue != MISMATCH && rValue != MISMATCH && lValue != rValue)
	{
		appendError(GENERAL_SEMANTIC, "Type Mismatch on " + message);
	}
}

Types checkArithmetic(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left == BOOL_TYPE || right == BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Numeric Type Required");
		return MISMATCH;
	}
	if (left == REAL_TYPE || right == REAL_TYPE)
	{
		return REAL_TYPE;
	}
	return INT_TYPE;
	
}


Types checkLogical(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left != BOOL_TYPE || right != BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Boolean Type Required");
		return MISMATCH;
	}	
		return BOOL_TYPE;
	return MISMATCH;
}

Types checkRelational(Types left, Types right)
{
	if (checkArithmetic(left, right) == MISMATCH)
		return MISMATCH;
	return BOOL_TYPE;
}

Types checkNegation(Types right)
{
	if (right != BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Boolean Type Required");
		return MISMATCH;
	}
	return BOOL_TYPE;
}

Types checkIfThen(Types expression, Types left, Types right)
{
	if (expression != BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Boolean Type Required for condition");
		return MISMATCH;
	}
	if ( left != right)
	{
		appendError(GENERAL_SEMANTIC, "Type Mismatch");
		return MISMATCH;
	}
	return left;
}

Types checkReturns(Types cases, Types others)
{
	if (others != INT_TYPE)
	{	
		appendError(GENERAL_SEMANTIC, "Other Expression Requires Integer");
		return others;
	}
	if (cases != NAN_TYPE || cases != INT_TYPE)
	{
		return cases;
	}	
	return INT_TYPE;
}

Types checkExpression(Types expression)
{
	if (expression != INT_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Case Expression Requires Integer");
		return MISMATCH;
	}
	return INT_TYPE;
}

Types checkCases(Types statement1, Types statement2)
{
	if (statement1 != BOOL_TYPE && statement2 != BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Case Statement Type Mismatch");
		return MISMATCH;
	}
	if ((statement1 == BOOL_TYPE && statement2 != BOOL_TYPE) || (statement1 != BOOL_TYPE && statement2 == BOOL_TYPE))
	{
		appendError(GENERAL_SEMANTIC, "Case Type Mismatch");
		return MISMATCH;
	}
	if (statement1 != INT_TYPE && statement2 != REAL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Case Statement Type Mismatch");
		return MISMATCH;

	} else {
		return REAL_TYPE;
	}
	if (statement1 != REAL_TYPE && statement2 != INT_TYPE) 
	{
		appendError(GENERAL_SEMANTIC, "Case Statement Type Mismatch");
		return MISMATCH;
	} else {
		return INT_TYPE;
	}
	return BOOL_TYPE;
		
}

Types checkRemainder(Types left, Types right)
{
	if (left == MISMATCH || right == MISMATCH)
		return MISMATCH;
	if (left == BOOL_TYPE || right == BOOL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Remainder Operator Requires Integer");
		return MISMATCH;
	}
	if (left == REAL_TYPE || right == REAL_TYPE)
	{
		appendError(GENERAL_SEMANTIC, "Remainder Operator Requires Integer");
		return MISMATCH;
	}
	return INT_TYPE;
}


