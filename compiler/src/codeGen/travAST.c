#include "internalASM.h"
#include "memory.h"
#include "symbol.h"
#include "tree.h"
#include "typecheck.h"
#include <string.h>


int IRcreateInternalRep( SymbolTable *table, bodyList *mainBody){
  //TODO
  return 0;
}

int IRtravStmtList( SymbolTable *table, STATEMENT_LIST *statements){
  IRtravStmt(table, statements->statement);
  if(statements->statementList != NULL){
    return IRtravStmtList(table, statements->statementList);
  }
  return 0;
}

OPERAND* IRtravTerm(SymbolTable *t, TERM *term){
  OPERAND *op;
  switch(term->kind){
    case varK:
      op = IRtravVar(t, term->val.var);
      return op;
      break;
    case idTermK:
      //TODO call create function call Scheme
      break;
    case expTermK:
      break;
    case notTermK:
      break;
    case expCardK:
      break;
    case numK:
      op = IRmakeConstantOPERAND(term->val.num);
      return op;
      break;
    case trueK:
      break;
    case falseK:
      break;
    case nullK:
      break;
    default:
      fprintf(stderr, "IRtravTerm ERROR, term has no kind\n");
  }
}




int IRtravStmt(SymbolTable *t, STATEMENT *stmt){
  OPERAND *op1;
  OPERAND *op2;
  switch(stmt->kind){
    case assiK:
      op1 = IRtravVar(t, stmt->val.assign.var);
      op2 = IRtravExp(t, stmt->val.assign.exp);
      //move expression into variabel -> source->destination
      IRappendINSTR(IRmakeMovINSTR(IRappendOPERAND(op2, op1)));
      break;
    default:
      break;
  }
}

OPERAND* IRtravVar(SymbolTable *t, VARIABLE *var){
  SYMBOL *sym;
  OPERAND *op;
  switch (var->kind) {
  case idVarK:
    sym = getSymbol(t, var->val.id);
    //todo check if operand already exists: if not make one

    if(sym->operand == NULL){
      //todo: create and save operand
      sym->operand = IRmakeTemporaryOPERAND(IRcreateNextTemp());
    }
    op = sym->operand;
    return op;
    //TODO: check if the type is a (userdefined) record or array type
    //i dont know if this works
    //recursiveSymbolRetrieval(sym->defScope, sym->val.id, NULL);
    break;
  case expK:
    printf("not yet implemented 12\n");
    break;
  case dotK:
    printf("not yet implemented 232\n");
    break;

  }
}

OPERAND* IRtravExp(SymbolTable *t, EXP *exp){
  OPERAND *op1, *op2;
  switch(exp->kind){
    case termK:
      IRtravTerm(t, exp->val.term);
      break;
    case minusK:
      op1 = IRtravExp(t, exp->val.binOP.left);
      op2 = IRtravExp(t, exp->val.binOP.left);
      IRappendINSTR(IRmakeSubINSTR(IRappendOPERAND(op1, op2)));
    case plusK:
      op1 = IRtravExp(t, exp->val.binOP.left);
      op2 = IRtravExp(t, exp->val.binOP.left);
      IRappendINSTR(IRmakeAddINSTR(IRappendOPERAND(op1, op2)));
    case divK:
      op1 = IRtravExp(t, exp->val.binOP.left);
      op2 = IRtravExp(t, exp->val.binOP.left);
      IRappendINSTR(IRmakeDivINSTR(IRappendOPERAND(op1, op2)));
    case timesK:
      op1 = IRtravExp(t, exp->val.binOP.left);
      op2 = IRtravExp(t, exp->val.binOP.left);
      IRappendINSTR(IRmakeTimINSTR(IRappendOPERAND(op1, op2)));
    case andK:
      op1 = IRtravExp(t, exp->val.binOP.left);
      op2 = IRtravExp(t, exp->val.binOP.left);
      IRappendINSTR(IRmakeAndINSTR(IRappendOPERAND(op1, op2)));
    case orK:
      op1 = IRtravExp(t, exp->val.binOP.left);
      op2 = IRtravExp(t, exp->val.binOP.left);
      IRappendINSTR(IRmakeOrINSTR(IRappendOPERAND(op1, op2)));
    case leK:
      op1 = IRtravExp(t, exp->val.binOP.left);
      op2 = IRtravExp(t, exp->val.binOP.left);
      IRappendINSTR(IRmakeLeINSTR(IRappendOPERAND(op1, op2)));
    case eqK:
      op1 = IRtravExp(t, exp->val.binOP.left);
      op2 = IRtravExp(t, exp->val.binOP.left);
      IRappendINSTR(IRmakeEqINSTR(IRappendOPERAND(op1, op2)));
    case geK:
      op1 = IRtravExp(t, exp->val.binOP.left);
      op2 = IRtravExp(t, exp->val.binOP.left);
      IRappendINSTR(IRmakeGeINSTR(IRappendOPERAND(op1, op2)));
    case greatK:
      op1 = IRtravExp(t, exp->val.binOP.left);
      op2 = IRtravExp(t, exp->val.binOP.left);
      IRappendINSTR(IRmakeGreINSTR(IRappendOPERAND(op1, op2)));
    case lessK:
      op1 = IRtravExp(t, exp->val.binOP.left);
      op2 = IRtravExp(t, exp->val.binOP.left);
      IRappendINSTR(IRmakeLesINSTR(IRappendOPERAND(op1, op2)));
    case neK:
      op1 = IRtravExp(t, exp->val.binOP.left);
      op2 = IRtravExp(t, exp->val.binOP.left);
      IRappendINSTR(IRmakeNeINSTR(IRappendOPERAND(op1, op2)));
      break;
  }
}

/**
 * create hash index value for the string
 *
 * - note: something fishy with the .h files, created my own stuff.
 */
int IRtemporaryHash(char *str){
  unsigned int sum = 0;
  for (unsigned int i = 0; i < strlen(str); i++){
    char c = str[i];
    sum += c;
    if(i < strlen(str)-1){
      sum <<= 1;
    }
  } return sum % HashSize;
}

TempLocMap *IRinitTempLocMap(){
  TempLocMap* table = NEW(TempLocMap);
  memset(table->table, 0, sizeof(table->table));
  return table;
}

/**
 * create new TempNode and put into table
 */
TempNode *IRputTempNode(TempLocMap *t, char *tempName){
  TempNode *newNode = NEW(TempNode);
  newNode->name = Malloc(strlen(tempName)+1);
  memcpy(newNode->name, tempName, strlen(tempName)+1);
  newNode->next = NULL;
  newNode->graphNodeId = UNUSED_GRAPH_ID;
  newNode->reg = NA; //NA = not assigned

  //find index via hash value
  int hashIndex = IRtemporaryHash(tempName);

  //insert into table
  TempLocMap **table = t->table;
  if(table[hashIndex] == NULL){
    table[hashIndex] = newNode;
  } else {
    TempNode *temp = table[hashIndex];
    while(temp != NULL){
      if(!strcmp(tempName,temp->name)){
        //name is already in this table
        fprintf(stderr, "IRputTempNode: Node already in table\n", tempName);
        free(newNode->name);
        free(newNode);
        return NULL;
      }
      if(temp->next != NULL){//as long as there is a next, check the next one.
        temp = temp->next;
      }
    }
    temp->next = newNode;
  }
  return newNode;
}

TempLocMap* IRsetupTemporaries(bodyListElm *bodyList, SymbolTable *mainSymbolTable){
  //TODO setup map
  //TODO call traverse of declarations
  //TODO possibly traverse statements
}

/**
 * traverse decleration list to find variables
 * and insert into TempNodeMap
 */
int IRtraverseDeclerationList(DECL_LIST *declerations){
  //TODO
}


TEMPORARY* IRcreateNextTemp(){
  return NULL;
}




/*
 * comfort space for mads
 * just because my editor removes extra white space
 * and I like my whitespace
 * I LIKE TRAINS
 * I like them taco's!
 */

//****Paramter functions*****//
OPERAND *IRmakeConstantOPERAND(int conVal){
  OPERAND *par = NEW(OPERAND);
  par->operandKind = constantO;
  par->val.constant = conVal;
  par->next = NULL;
}

OPERAND *IRmakeTemporaryOPERAND(TEMPORARY *temp){
  OPERAND *par = NEW(OPERAND);
  par->operandKind = temporaryO;
  par->val.temp = temp;
  par->next = NULL;
}

OPERAND *IRmakeAddrOPERAND(int addrVal){
  OPERAND *par = NEW(OPERAND);
  par->operandKind = heapAddrO;
  par->val.address = addrVal;
  par->next = NULL;
}

OPERAND *IRmakeLabelOPERAND(char *labelName){
  OPERAND *par = NEW(OPERAND);
  par->operandKind = labelIDO;
  par->val.label = labelName;
  par->next = NULL;
}

OPERAND *IRmakeRegOPERAND(registers reg){
  OPERAND *par = NEW(OPERAND);
  par->operandKind = registerO;
  par->val.reg = reg;
  par->next = NULL;
}

OPERAND *IRappendOPERAND(OPERAND *tail, OPERAND *next){
  if(tail->next = NULL){
    fprintf(stderr, "tail->next is NULL\n");
  }
  tail->next = next;
}



INSTRE IRmakeINSTR(OPERAND *params){
  INSTR* ins = NEW(INSTR);
  //ins->instrKind = addI;
  ins->paramList = params;
  ins->next = NULL;
  return ins;
}

INSTR* IRmakeMovINSTR(OPERAND *params){
  INSTR* instr = IRmakeINSTR(params)
  instr->instrKIND = movI
}


INSTR* IRmakeAddINSTR(OPERAND *params){
  INSTR* instr = IRmakeINSTR(params)
  instr->instrKIND = addI
}

INSTR* IRmakeSubINSTR(OPERAND *params){
  INSTR* instr = IRmakeINSTR(params)
  instr->instrKIND = subI
}

INSTR* IRmakeDivINSTR(OPERAND *params){
  INSTR* instr = IRmakeINSTR(params)
  instr->instrKIND = divI
}

INSTR* IRmakeTimINSTR(OPERAND *params){
  INSTR* instr = IRmakeINSTR(params)
  instr->instrKIND = mulI
}

INSTR* IRmakeAndINSTR(OPERAND *params){
  INSTR* instr = IRmakeINSTR(params)
  instr->instrKIND = andI
}

INSTR* IRmakeOrINSTR(OPERAND *params){
  INSTR* instr = IRmakeINSTR(params)
  instr->instrKIND = orI
}

INSTR* IRmakeLeINSTR(OPERAND *params){
  INSTR* instr = IRmakeINSTR(params)
  instr->instrKIND = jmpleI
}

INSTR* IRmakeEqINSTR(OPERAND *params){
  INSTR* instr = IRmakeINSTR(params)
  instr->instrKIND = jmpeqI
}

INSTR* IRmakeGeINSTR(OPERAND *params){
  INSTR* instr = IRmakeINSTR(params)
  instr->instrKIND = jmpgeI
}

INSTR* IRmakeGreINSTR(OPERAND *params){
  INSTR* instr = IRmakeINSTR(params)
  instr->instrKIND = jmpgreatI
}

INSTR* IRmakeLesINSTR(OPERAND *params){
  INSTR* instr = IRmakeINSTR(params)
  instr->instrKIND = jmplessI
}

INSTR* IRmakeNeINSTR(OPERAND *params){
  INSTR* instr = IRmakeINSTR(params)
  instr->instrKIND = jmpneqI
}

INSTR* IRmakeLabelINSTR(OPERAND *params){
  INSTR* instr = IRmakeINSTR(params)
  instr->instrKIND = labelI
}

INSTR* IRmakePushINSTR(OPERAND *params){
  INSTR* instr = IRmakeINSTR(params)
  instr->instrKIND = pushI
}

INSTR* IRmakePopINSTR(OPERAND *params){
  INSTR* instr = IRmakeINSTR(params)
  instr->instrKIND = popI
}

INSTR* IRmakeCallINSTR(OPERAND *params){
  INSTR* instr = IRmakeINSTR(params)
  instr->instrKIND = callI
}

INSTR* IRmakeRetINSTR(OPERAND *params){
  INSTR* instr = IRmakeINSTR(params)
  instr->instrKIND = retI
}

INSTR* IRappendINSTR(INSTR *newINSTR){
  if(intermediateTail==NULL){
    intermediateTail = newINSTR;
  }

/*INSTR* IRmakeLabelINSTR(OPERAND *params){
  INSTR* ins = NEW(INSTR);
  ins->instrKind = labelI;
  ins->paramList = params;
  ins->next = NULL;
  return ins;
}

INSTR* IRmakePushINSTR(OPERAND *params){
  INSTR* ins = NEW(INSTR);
  ins->instrKind = pushI;
  ins->paramList = params;
  ins->next = NULL;
  return ins;
}

INSTR* IRmakePopINSTR(OPERAND *params){
  INSTR* ins = NEW(INSTR);
  ins->instrKind = popI;
  ins->paramList = params;
  ins->next = NULL;
  return ins;
}

INSTR* IRmakeCallINSTR(OPERAND *params){
  INSTR* ins = NEW(INSTR);
  ins->instrKind = callI;
  ins->paramList = params;
  ins->next = NULL;
  return ins;
}

INSTR* IRmakeRetINSTR(OPERAND *params){
  INSTR* ins = NEW(INSTR);
  ins->instrKind = retI;
  ins->paramList = params;
  ins->next = NULL;
  return ins;
}

INSTR* IRappendINSTR(INSTR *newINSTR){
  if(intermediateTail==NULL){
    intermediateTail = newINSTR;
  }

  */
}

/**
 * Makes a function call
 * The first parameter is the instruction giving the label to where to jump
 * The Second paramater is the list of parameters to this function
 *  - This list may be arbitrarily long
 */
int IRmakeFunctionCallScheme(INSTR *labelINSTR, OPERAND *paramList){
  if(labelINSTR->instrKind != labelI){
    fprintf(stderr, "IRmakeFunctionCallScheme%s\n");
  }
  INSTR *ins; //Is this thingy used - Maybe I should jus delete things instead of making weird comments - but naaah
  //Caller save registers
  IRappendINSTR(IRmakePushINSTR(IRmakeRegOPERAND(RCX)));
  IRappendINSTR(IRmakePushINSTR(IRmakeRegOPERAND(RDX)));
  IRappendINSTR(IRmakePushINSTR(IRmakeRegOPERAND(RSI)));
  IRappendINSTR(IRmakePushINSTR(IRmakeRegOPERAND(RDI)));
  IRappendINSTR(IRmakePushINSTR(IRmakeRegOPERAND(R8)));
  IRappendINSTR(IRmakePushINSTR(IRmakeRegOPERAND(R9)));
  IRappendINSTR(IRmakePushINSTR(IRmakeRegOPERAND(R10)));
  IRappendINSTR(IRmakePushINSTR(IRmakeRegOPERAND(R11)));
  int ParamCount = 1; //static link already inkluded
  while(paramList != NULL){
    IRappendINSTR(IRmakePushINSTR(paramList));
    paramList = paramList->next;
    ParamCount += 1;
  }
  IRappendINSTR(IRmakePushINSTR(IRmakeConstantOPERAND(0))); //Static link field
  //do the actual call
  IRappendINSTR(IRmakeCallINSTR(labelINSTR->paramList));

  //remove static link and parameters
  IRappendINSTR(IRmakeAddINSTR(IRappendOPERAND(IRmakeConstantOPERAND(ParamCount),IRmakeRegOPERAND(RSP))));


  //caller save registers
  IRappendINSTR(IRmakePopINSTR(IRmakeRegOPERAND(R11)));
  IRappendINSTR(IRmakePopINSTR(IRmakeRegOPERAND(R10)));
  IRappendINSTR(IRmakePopINSTR(IRmakeRegOPERAND(R9)));
  IRappendINSTR(IRmakePopINSTR(IRmakeRegOPERAND(R8)));
  IRappendINSTR(IRmakePopINSTR(IRmakeRegOPERAND(RDI)));
  IRappendINSTR(IRmakePopINSTR(IRmakeRegOPERAND(RSI)));
  IRappendINSTR(IRmakePopINSTR(IRmakeRegOPERAND(RDX)));
  IRappendINSTR(IRmakePopINSTR(IRmakeRegOPERAND(RCX)));

  return 0;








  //ins = IRmakePushINSTR(IRmakeRegOPERAND(RAX)); //dafuq s this??


}









 //comfort space
