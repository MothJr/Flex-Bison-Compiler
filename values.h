// CMSC 430
// Duane J. Jarc

// This file contains function definitions for the evaluation functions

typedef char* CharPtr;

enum Operators {LESS, ADD, MULTIPLY, SUBTRACT, DIVIDE, EQUALS, ASSIGNQUOTIENT, GREATER, GREATEROREQUAL, LESSOREQUAL, TO, 
                AND, OR, NOT, EXPONENT, REMAINDER};

int evaluateReduction(Operators operator_, int head, int tail);
int evaluateRelational(int left, Operators operator_, int right);
int evaluateArithmetic(int left, Operators operator_, int right);
int evaluateLogical(int left, Operators operator_, int right);

