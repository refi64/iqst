// To try it: run "clang -E logic-gate-preprocessor.c"

// NOTE: Usually when you see indirection, it's so the arguments get fully expanded.

// CONCAT(x,y): Concatenate x and y, making sure they're fully expanded.
#define CONCAT2(x,y) x##y
#define CONCAT(x,y) CONCAT2(x,y)

// EXPAND(b): Expands to a comma if b is 1, else nothing.
#define EXPAND_1 ,
#define EXPAND_0
#define EXPAND(b) CONCAT(EXPAND_,b)

// SELECT_THIRD2(a,b,c,...): Returns the third argument (after full expansion).
#define SELECT_THIRD2(a,b,c,...) c
#define SELECT_THIRD(...) SELECT_THIRD2(__VA_ARGS__)

// IF(cond,t,f): If cond is 1, return the value of t, else return the value of f.
// This works by doing EXPAND(cond); if it's a 1, then the arguments to SELECT_THIRD
// will get shifted down by 1, so the true value will be selected.
#define IF(cond,t,f) SELECT_THIRD(EXPAND(cond),t,f,)

// Logic gate implementations.
#define LOGIC_AND(x,y) IF(x,y,0)
#define LOGIC_OR(x,y) IF(x,1,y)
#define LOGIC_NOT(x) IF(x,0,1)
#define LOGIC_NAND(x,y) LOGIC_NOT(LOGIC_AND(x,y))
#define LOGIC_NOR(x,y) LOGIC_NOT(LOGIC_OR(x,y))
#define LOGIC_XOR(x,y) IF(x,IF(y,0,1),y)
#define LOGIC_XNOR(x,y) LOGIC_NOT(LOGIC_XOR(x,y))

// LOGIC_GATE(op,...) Calls LOGIC_<op>(...).
#define LOGIC_GATE(op,...) CONCAT(LOGIC_,op)(__VA_ARGS__)

// This is just for "unit testing".
#define TEST_BASE(c,s) IF(LOGIC_NOT(c),Test failed: s,)
// TEST_T(x): Expands to a failure message if
#define TEST_T(x) TEST_BASE(x,#x)
#define TEST_F(x) TEST_BASE(LOGIC_NOT(x),not #x)

If you see no output below, then all the tests passed!

TEST_T(LOGIC_GATE(AND, 1,1))
TEST_F(LOGIC_GATE(AND, 1,0))
TEST_F(LOGIC_GATE(AND, 0,1))
TEST_F(LOGIC_GATE(AND, 0,0))

TEST_T(LOGIC_GATE(OR, 1,1))
TEST_T(LOGIC_GATE(OR, 1,0))
TEST_T(LOGIC_GATE(OR, 0,1))
TEST_F(LOGIC_GATE(OR, 0,0))

TEST_T(LOGIC_GATE(NOT, 0))
TEST_F(LOGIC_GATE(NOT, 1))

TEST_F(LOGIC_GATE(NAND, 1,1))
TEST_T(LOGIC_GATE(NAND, 1,0))
TEST_T(LOGIC_GATE(NAND, 0,1))
TEST_T(LOGIC_GATE(NAND, 0,0))

TEST_F(LOGIC_GATE(NOR, 1,1))
TEST_F(LOGIC_GATE(NOR, 1,0))
TEST_F(LOGIC_GATE(NOR, 0,1))
TEST_T(LOGIC_GATE(NOR, 0,0))

TEST_F(LOGIC_GATE(XOR, 1,1))
TEST_T(LOGIC_GATE(XOR, 1,0))
TEST_T(LOGIC_GATE(XOR, 0,1))
TEST_F(LOGIC_GATE(XOR, 0,0))

TEST_T(LOGIC_GATE(XNOR, 1,1))
TEST_F(LOGIC_GATE(XNOR, 1,0))
TEST_F(LOGIC_GATE(XNOR, 0,1))
TEST_T(LOGIC_GATE(XNOR, 0,0))
