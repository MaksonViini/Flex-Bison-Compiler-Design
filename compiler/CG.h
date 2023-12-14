/***************************************************************************
Code Generator for the Mini language
***************************************************************************/

int dataOffset = 0;
int dataLocation() {
    return dataOffset++;
}

int codeOffset = 0;
int genLabel() {
    return codeOffset;
}
int reserveLoc() {
    return codeOffset++;
}

void genCode(enum codeOps operation, int arg)

{
    code[codeOffset].op = operation;
    code[codeOffset++].arg = arg;
}

void backPatch(int addr, enum codeOps operation, int arg) {
    code[addr].op = operation;
    code[addr].arg = arg;
}

void printCode() {


    printf("\n");
    printf("\n-------------------------------------------------");
    printf("\n*****************CODE GENERATOR******************");
    printf("\n-------------------------------------------------");

    printf("\n-------------------------------------------------\n");
    printf("| %-4s | %-10s | %-4s |\n", "Index", "Operation", "Argument");
    printf("-------------------------------------------------\n");

    int i = 0;
    while (i < codeOffset) {
        printf("| %4ld | %-10s | %4ld |\n", i, opName[(int)code[i].op], code[i].arg);
        i++;
    }

    printf("--------------------------------------------------\n");
}
