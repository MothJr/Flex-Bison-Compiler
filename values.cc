// CMSC 430
// Duane J. Jarc

// This file contains the bodies of the evaluation functions

#include <string>
#include <vector>
#include <cmath>

using namespace std;

#include "values.h"
#include "listing.h"

int evaluateReduction(Operators operator_, int head, int tail)
{
	if (operator_ == ADD)
		return head + tail;
	return head * tail;
}

int evaluateLogical(int left, Operators operator_, int right)
{
	int result;
	switch(operator_)
	{
		case AND:
			result = left && right;
			break;
		case OR:
			result = left || right;
			break;
	}
	return result;
}

int evaluateRelational(int left, Operators operator_, int right)
{
	int result;
	switch (operator_)
	{
		case LESS:
			result = left < right;
			break;
		case TO:
			if (left == true)
			{
				right;
			}
			break;
		case EQUALS:
			result = left == right;
			break;
		case ASSIGNQUOTIENT:
			if (right != 0)
			{
				result = left /= right;
			}
			break;
		case GREATER: 
			result = left > right;
			break;
		case GREATEROREQUAL:
			result = left >= right;
			break;
		case LESSOREQUAL:
			result = left <= right;
			break;
	}
	return result;
}

int evaluateArithmetic(int left, Operators operator_, int right)
{
	int result;
	switch (operator_)
	{
		case ADD:
			result = left + right;
			break;
		case MULTIPLY:
			result = left * right;
			break;
		case SUBTRACT:
			result = left - right;
			break;
		case DIVIDE:
			if (right != 0) 
			{
				result = left / right;
			}
			break;
		case REMAINDER:
			if (right != 0) 
			{
				result = left % right;
			} 
			break;
	}
	return result;
}

