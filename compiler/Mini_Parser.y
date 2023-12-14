/***************************************************************************
Parser for the Mini language
***************************************************************************/

%{
    #include <stdio.h> 
    #include <stdlib.h> 
    #include <string.h> 
    #include "compiler/ST.h"     /* Symbol Table */
    #include "compiler/SM.h"     /* Stack Machine */
    #include "compiler/CG.h"     /* Code Generator */
    #include <stdlib.h>
    #include <stdarg.h>
    #include <string.h>

    #define YYDEBUG 1 
    int errors; 
   
    struct lbs /* Labels for data, if and while */ {
        int for_goto;
        int for_jmp_false;
    };

    struct lbs * newlblrec() /* Allocate space for the labels */ {
        return (struct lbs * ) malloc(sizeof(struct lbs));
    }

   
    install(char * symName) {
        symRec * s;
        s = getSym(symName);
        if (s == 0)
            s = putSym(symName);
        else {
            errors++;
            printf("%s is already defined\n", symName);
        }
    }
    
    context_check(enum codeOps operation, char * symName) {
        symRec * identifier;
        identifier = getSym(symName);
        if (identifier == 0) {
            errors++;
            printf("%s", symName);
            printf("%s\n", " is an undeclared identifier");
        } else genCode(operation, identifier -> offset);
    }

%}


%union semRec /* The Semantic Records */ {
    int intval; 
    char * id; /* Identifiers */
    struct lbs * lbls; /* For backpatching */
    char *strval;
}


%start program_initial
%token <intval> NUMBER
%token <strval> STRING
%token <id> IDENTIFIER 
%token <lbls> IF WHILE 
%token THEN ELSE DO END AND
%token INTEGER READ WRITE DECLARE BEGN PROGRAM MOD 
%token ASSGNOP

%left '-' '+' 
%left '*' '/' '%'
%right '^'

%%
program_initial: 
    PROGRAM declarate_initial
    DECLARE
        declarations
    BEGN {genCode(DATA, dataLocation() - 1);}
        commands
    END {genCode(HALT, 0);YYACCEPT;};


declarate_initial: /* empty */
            | IDENTIFIER


declarations: | /* empty */
        declarations INTEGER id_seq IDENTIFIER ';' {install($4);};
            


id_seq: /* empty */
    | id_seq IDENTIFIER ',' {install($2);};


commands: /* empty */
    | commands command ';';


command: READ '(' IDENTIFIER ')' {context_check(READ_INT, $3);} 
    | WRITE '(' exp ')' {genCode(WRITE_INT, 0);}
    | IDENTIFIER ASSGNOP exp {context_check(STORE, $1);}
    | IF '(' exp ')' {
        $1 = (struct lbs * ) newlblrec();
        $1 -> for_jmp_false = reserveLoc();
    }
    THEN commands {
        $1 -> for_goto = reserveLoc();
    }
    
    ELSE {
    backPatch($1 -> for_jmp_false,
        JMP_FALSE,
        genLabel());
    }
    commands
    DO
        commands
    WHILE {$1 = (struct lbs * ) newlblrec();
            $1 -> for_goto = genLabel();
    } 
    '(' exp ')' {
        $1 -> for_jmp_false = reserveLoc();
    }

exp : NUMBER { genCode(LD_INT, $1); }
| STRING 
| IDENTIFIER { context_check(LD_VAR, $1); }
| exp AND exp { genCode(LT, 0); }
| exp '<' exp { genCode(LT, 0); }
| exp '=' exp { genCode(EQ, 0); }
| exp '>' exp { genCode(GT, 0); }
| exp '+' exp { genCode(ADD, 0); }
| exp '-' exp { genCode(SUB, 0); }
| exp '*' exp { genCode(MULT, 0); }
| exp '/' exp { genCode(DIV, 0); }
| exp MOD exp { genCode(MOD, 0); } 
| exp '^' exp { genCode(PWR, 0); }
| '(' exp ')' ;



%%


main(int argc, char * argv[]) {

    FILE *output = fopen("output.asm", "w");
    fprintf(output, "\t  jump.i #trab0\n");

    extern FILE * yyin;
    ++argv;
    --argc;
    yyin = fopen(argv[0], "r");
    errors = 0;
    yyparse();
    printSymTable();
    printf("\nParse Completed\n");
    if (errors == 0) {
        printCode();
        fetchExecuteCycle();
    }
}

extern char *yytext;



yyerror(char * s) /* Called by yyparse on error */ {
    errors++;
    printf("%s\n", s);
    printf("error: unexpected token '%s'", yytext);
}


