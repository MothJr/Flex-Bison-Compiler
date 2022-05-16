// Compiler Theory and Design
// Tim McNeill
// 14 May 2022
// This file contains type definitions and the function
// prototypes for the type checking functions

#include <vector>
typedef char* CharPtr;

enum Types {MISMATCH, INT_TYPE, BOOL_TYPE, REAL_TYPE, NAN_TYPE};

void checkAssignment(Types lValue, Types rValue, string message);
Types checkArithmetic(Types left, Types right);
Types checkLogical(Types left, Types right);
Types checkRelational(Types left, Types right);
Types checkNegation(Types right);
Types checkIfThen(Types expression, Types left, Types right);
Types checkExpression(Types expression);
Types checkReturns(Types cases_, Types others);
Types checkCases(Types statement1, Types statement2);
Types checkRemainder(Types left, Types right);
