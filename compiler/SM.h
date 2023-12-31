/***************************************************************************
Stack Machine for the Mini language
***************************************************************************/

enum codeOps {
    HALT,
    STORE,
    JMP_FALSE,
    GOTO,
    DATA,
    LD_INT,
    LD_VAR,
    READ_INT,
    WRITE_INT,
    LT,
    EQ,
    GT,
    ADD,
    SUB,
    MULT,
    _MOD,
    DIV,
    PWR
};
/* OPERATIONS: External Representation */
char * opName[] = {
    "halt",
    "store",
    "jmp_false",
    "goto",
    "data",
    "ld_int",
    "ld_var",
    "in_int",
    "out_int",
    "lt",
    "eq",
    "gt",
    "add",
    "sub",
    "mult",
    "_mod",
    "div",
    "pwr"
};
struct instruction {
    enum codeOps op;
    int arg;
};

struct instruction code[999];

int stack[999];
/*-------------------------------------------------------------------------
Registers
-------------------------------------------------------------------------*/
int pc = 0;
struct instruction ir;
int ar = 0;
int top = 0;
char ch;
/*=========================================================================
Fetch Execute Cycle
=========================================================================*/
void fetchExecuteCycle() {
    do {
        ir = code[pc++];
        switch (ir.op) {
        case HALT:
            printf("halt\n");
            break;
        case READ_INT:
            printf("Input: ");
            scanf("%ld", & stack[ar + ir.arg]);
            break;
        case WRITE_INT:
            printf("Output: %d\n", stack[top--]);
            break;
        case STORE:
            stack[ir.arg] = stack[top--];
            break;
        case JMP_FALSE:
            if (stack[top--] == 0)
                pc = ir.arg;
            break;
        case GOTO:
            pc = ir.arg;
            break;
        case DATA:
            top = top + ir.arg;
            break;
        case LD_INT:
            stack[++top] = ir.arg;
            break;
        case LD_VAR:
            stack[++top] = stack[ar + ir.arg];
            break;
        case LT:
            if (stack[top - 1] < stack[top])
                stack[--top] = 1;
            else stack[--top] = 0;
            break;
        case EQ:
            if (stack[top - 1] == stack[top])
                stack[--top] = 1;
            else stack[--top] = 0;
            break;
        case GT:
            if (stack[top - 1] > stack[top])
                stack[--top] = 1;
            else stack[--top] = 0;
            break;
        case ADD:
            stack[top - 1] = stack[top - 1] + stack[top];
            top--;
            break;
        case SUB:
            stack[top - 1] = stack[top - 1] - stack[top];
            top--;
            break;
        case MULT:
            stack[top - 1] = stack[top - 1] * stack[top];
            top--;
            break;
        case _MOD:
            stack[top - 1] = stack[top - 1] * stack[top];
            top--;
            break;
        case DIV:
            stack[top - 1] = stack[top - 1] / stack[top];
            top--;
            break;
        case PWR:
            stack[top - 1] = stack[top - 1] * stack[top];
            top--;
            break;
        default:
            printf("%sInternal Error: Memory Dump\n");
            break;
        }
    }
    while (ir.op != HALT);
}
