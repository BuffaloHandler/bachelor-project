%{
#include <stdio.h>
#include "tree.h"

extern char *yytext;
extern EXP *theexpression;

void yyerror() {
   printf("syntax error before %s\n",yytext);
}
%}


//Denne union angiver typen af associeret data
//det vil sige typen af $x og $$.
//da der ikke er noget nvanv for union er den kaldet YYSTYPE
//Jeg tror at dette er stak typen
%union {
  struct FUNCTION* ufunc;
  struct HEAD* uhead;
  struct BODY* ubody;
  struct TAIL* utail;
  struct TYPE* utype;
  struct PAR_DECL_LIST* upardecllist;
  struct VAR_DECL_LIST* uvardecllist;
  struct STATEMENT_LIST* ustatementlist;
  //struct STATEMENT* ustatement;
  void* uvoid; //default for testing
  struct EXP* uexp;

  int uint;
  TERM* uterm;
  char* uid;





   //int intconst;
   //char *stringconst;
   //struct EXPRESSION *exp;

   //jeg tror at jeg skal lave en variable af hver type som JEFF laver
   //Måske primitive typer er undtaget
}

//da %union er brugt til at definere type, skal den præcise type/variable angives i < >
//tokens er terminal symboler
//%token <intconst> tINTCONST
//%token <stringconst> tIDENTIFIER

/*
%token <> tID
%token <> tEND
%token <> tINT
%token <> tBOOL
%token <> tARRAY
%token <> tOF
%token <> tRECORD
%token <> tTYPE
%token <> tVAR
%token <> tRETURN
%token <> tWRITE
%token <> tALLOC
%token <> tLEN
%token <> tIF
%token <> tTHEN
%token <> tWHILE
%token <> tDO
%token <unum> tNUM
%token <> tTRUE
%token <> tFALSE
%token <> tNULL
*/

%token <uint> tINT
%token tPLUS tMINUS tTIMES tDIV tEQ tNE tLE tGE tLESS tGREAT tAND tOR tLPAR tRPAR tLSQ tRSQ tLCURL tRCURL
%token tEND tBOOL tARRAYTYPE tOF tRECORDTYPE tTYPE tVAR tRETURN tWRITE tALLOC tLEN tIF tTHEN tELSE tWHILE tDO tNULL
%token tTRUE tFALSE
%token tASSI tNEG tDOT
%token tFUNC
%token tBAR tCOL tCOM tSEMI


//%token <utype> tINTTYPE tBOOLTYPE tARRAYTYPE tRECORDTYPE

%token <uid> tID


//type er non-terminal symboler
//bruges kun til at definere typen af non-terminalen


%type <uexp> program exp


%type <ufunc> func
%type <uhead> head
%type <ubody> body
%type <utail> tail
%type <utype> type //gad vide om jeg må kalde den type??
%type <upardecllist> par_decl_list
%type <uvardecllist> var_decl_list


//Only for temporary testing below
%type <uvoid> var_type
%type <uvoid> decl_list
%type <uvoid> decl
%type <uvoid> stmt_list
%type <uvoid> stmt
%type <uvoid> var
%type <uvoid> act_list
%type <uvoid> exp_list
/*%type <uvoid> exp*/
%type <uterm> term

/*
%type <> var_type
%type <> decl_list
%type <> decl
%type <ustatementlist> stmt_list
%type <ustatement> stmt
%type <> var
%type <> exp
%type <> term
%type <> act_list
%type <> exp_list
*/

/*
%type <> exp
%type <> term
%type <> act_list
%type <> exp_list
*/

%start program

/*
%left '+' '-'
%left '*' '/'
*/



%%
program: exp
         { theexpression = $1;}
;



func :  head body head { $$ = makeFUNCTION($1, $2, $3);}

head :  tFUNC tID tLPAR par_decl_list tRPAR tCOL type {$$ = makeHEAD($2, $4, $7);}

body :  decl_list stmt_list {$$ = makeBODY($1, $2);}

tail :  tEND tID {$$ = makeTAIL($2);}

type :  tID {$$ = makeID($1);}
      | tINTTYPE {$$ = makeINT();}
      | tBOOLTYPE {$$ = makeBOOL();}
      | tARRAYTYPE tOF type {$$ = makeARRAY($3);}
      | tRECORDTYPE tOF tLCURL var_decl_list tRCURL {$$ = makeRECORD($4);}

par_decl_list : var_decl_list {printf("par_decl_list\n");}
      | {printf("par_decl_list empty\n");};//empty string

var_decl_list : var_type tCOM var_decl_list {printf("var_decl_list\n");}
      | var_type {printf("var_decl_list empty\n");}

var_type : tID tCOL type {printf("var_typ tID\n");}

decl_list : decl decl_list {printf("decl_list\n");}
      | {printf("decl_list empty\n");}//empty string

decl :  tTYPE tID tASSI type tSEMI {printf("decl assi\n");}
      | func {printf("decl func\n");}
      | tVAR var_decl_list tSEMI {printf("decl var\n");}

stmt_list : stmt {printf("stmt_list stmt\n");}
      | stmt stmt_list {printf("stmt_list list\n");}

stmt :  tRETURN exp tSEMI {$$ = makeSTMreturn($2)}
      | tWRITE exp tSEMI { $$ = makeSTMwrite($2)}
      | tALLOC var tSEMI {$$ = makeSTMallocate($2)}
      | tALLOC var tOF tLEN exp tSEMI {$$ = makeSTMallocateLength($2,$5)}
      | var tASSI exp tSEMI {}
      | tIF exp tTHEN stmt {$$ = makeSTMif_($2,$4)}
      | tIF exp tTHEN stmt tELSE stmt {$$ = makeSTMthen_($2,$4,$6)}
      | tWHILE exp tDO stmt {$$ = makeSTMdo_($2,$4)}
      | tLCURL stmt_list tRCURL {$$ makeSTMlist($2)}

var :   tID {}
      | var tLSQ exp tRSQ {}
      | var tDOT tID {}

exp :   exp tPLUS exp {$$ = makeEXPplus($1,$3);}
      | exp tMINUS exp {$$ = makeEXPminus($1,$3);}
      | exp tTIMES exp {$$ = makeEXPtimes($1,$3);}
      | exp tDIV exp {$$ = makeEXPdiv($1,$3);}
      | exp tEQ exp {$$ = makeEXPeq($1,$3);}
      | exp tNE exp {$$ = makeEXPne($1,$3);}
      | exp tLE exp {$$ = makeEXPle($1,$3);}
      | exp tGE exp {$$ = makeEXPge($1,$3);}
      | exp tLESS exp {$$ = makeEXPless($1,$3);}
      | exp tGREAT exp {$$ = makeEXPgreat($1,$3);}
      | exp tAND exp {$$ = makeEXPand($1,$3);}
      | exp tOR exp {$$ = makeEXPor($1,$3);}
      | term {$$ = makeEXPterm($1,$3);}

term :  var {$$ = makeTERMvar($1);}
      | tID tLPAR act_list tRPAR {$$ = makeTERMaclt_list($1,$3);}
      | tLPAR exp_list tRPAR {$$ = makeTERMexp($2);}
      | tNEG term {$$ = makeTERMnotTerm($2)}
      | tBAR exp tBAR {$$ = makeTERMCard($2)}
      | tINT {$$ = makeTERMnum($2)}
      | tTRUE {$$ = makeTERMtrue();}
      | tFALSE {$$ = makeTERMfalse();}
      | tNULL {$$ = makeTERMnull();}

act_list : exp_list {printf("act_list exp_list\n");}
      | {printf("act_list empty\n");}

exp_list : exp {printf("exp_list exp\n");}
      | exp tCOM exp_list {printf("exp_list list\n");}


/*
exp : tIDENTIFIER
      {$$ = makeEXPid($1);}
    | tINTCONST
      {$$ = makeEXPintconst($1);}
    | exp '*' exp
      {$$ = makeEXPtimes($1,$3);}
    | exp '/' exp
      {$$ = makeEXPdiv($1,$3);}
    | exp '+' exp
      {$$ = makeEXPplus($1,$3);}
    | exp '-' exp
      {$$ = makeEXPminus($1,$3);}
    | '(' exp ')'
      {$$ = $2;}
;
*/

%%
