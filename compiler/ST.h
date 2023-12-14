/***************************************************************************
Symbol Table for the Mini language
***************************************************************************/

struct symRec {
    char * name; /* name of symbol */
    int offset; /* data offset */
    char *type;
    struct symRec * next; /* link field */
};
typedef struct symRec symRec;

symRec * identifier;

symRec * symTable = (symRec * ) 0; /* The pointer to the Symbol Table */

symRec * putSym(char * symName) {
    symRec * ptr;
    ptr = (symRec * ) malloc(sizeof(symRec));
    ptr -> name = (char * ) malloc(strlen(symName) + 1);
    strcpy(ptr -> name, symName);
    ptr->type = (char *)malloc(strlen("INTEGER") + 1);
    strcpy(ptr->type, "INTEGER");
    ptr -> offset = dataLocation();
    ptr -> next = (struct symRec * ) symTable;
    symTable = ptr;
    return ptr;
}
symRec * getSym(char * symName) {
    symRec * ptr;
    for (ptr = symTable; ptr != (symRec * ) 0; ptr = (symRec * ) ptr -> next)
        if (strcmp(ptr -> name, symName) == 0)
            return ptr;
    return 0;
}


void printSymTable()
{
    printf("\n");
    printf("\n-------------------------------------------------");
    printf("\n*****************SYMBOL TABLE********************");
    printf("\n-------------------------------------------------");
    printf("\n-------------------------------------------------");
    printf("\n| %-20s | %-20s |", "Name", "Type");
    printf("\n-------------------------------------------------");

    symRec *ptr;
    for (ptr = symTable; ptr != (symRec *)0; ptr = (symRec *)ptr->next)
        printf("\n| %-20s | %-20s |", ptr->name, ptr->type);

    printf("\n-------------------------------------------------\n");
}
