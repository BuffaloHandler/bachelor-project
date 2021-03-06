#include "symbol.h"
#include "memory.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

/**
 * very basic hash
 */
int Hash(char *str){
  unsigned int sum = 0;
  for (unsigned int i = 0; i < strlen(str); i++){
    char c = str[i];
    sum += c;
    if(i < strlen(str)-1){
      sum <<= 1;
    }
  } return sum % HashSize;
}

/**
 * creates symboltable
 */
SymbolTable *initSymbolTable(){
  SymbolTable* table = Malloc(sizeof(SymbolTable));
  memset(table->table, 0, sizeof(table->table));
  table->next = NULL;
  table->ParamHead = NULL;
  table->ParamTail = NULL;
  return table;
}

/**
 * creates new symboltable as "child" of *t
 */
SymbolTable *scopeSymbolTable(SymbolTable *t){
  SymbolTable* newt = initSymbolTable();
  newt->next = t;
  return newt;
}

/**
 * used by putParam, creates symbol wrapper
 */
ParamSymbol *createParamSymbol(SYMBOL *sym){
  ParamSymbol *newParSym = NEW(ParamSymbol);
  newParSym->data = sym;
  newParSym->next = NULL;
  return newParSym;
}

/**
 * creates a new symbol which stores the name and value
 * from the arguments in table t
 *
 * return NULL* if the name is already in the table
 * return SYMBOL* to the new symbol on success
 */
SYMBOL *putSymbol(SymbolTable *t, char *name,
                int kind, int type, SymbolTable *scope, TYPE* arrayType){
  SYMBOL *newSym = Malloc(sizeof(SYMBOL));
  newSym->kind = kind;
  newSym->typeVal = type;
  newSym->name = Malloc(strlen(name)+1);
  memcpy(newSym->name, name, strlen(name)+1);
  newSym->scope = scope;
  newSym->typePtr = arrayType;
  newSym->defScope = t;
  newSym->typePtr->scope = t;
  newSym->visited = false;
  newSym->next = NULL;
  TYPE *ty = newSym->typePtr;
  while(ty->kind == arrayK){
    ty = ty->val.arrayType;
    ty->scope = t;
  }
  newSym->cgu = NULL;

  //find index via hash value
  int hashIndex = Hash(name);

  //insert into table
  SYMBOL **table = t->table;
  if(table[hashIndex] == NULL){
    table[hashIndex] = newSym;
  } else {
    SYMBOL *temp = table[hashIndex];

    while(temp != NULL){
      if(!strcmp(name,temp->name)){
        //name is already in this table
        fprintf(stderr, "putSymbol(): SYMBOL name: %s alredy in table\n", name);
        free(newSym->name);
        free(newSym);
        return NULL;
      }
      if(temp->next == NULL){
        //we are at the end;
        break;
      } else {
        temp = temp->next;
      }
    }
    temp->next = newSym;
  }

  return newSym;
}

/**
 * used to attatch parameters to functions.
 * useful in codegeneration when we need to know if
 * something is a parameter
 */
SYMBOL *putParam(SymbolTable *t, char *name,
                          int kind, int type, TYPE* arrayType){
  SYMBOL* s = putSymbol(t, name, kind, type, NULL, arrayType);
  if(s == NULL){
    fprintf(stderr, "putParam(): The id: %s already exists\n", name);
    return NULL;
  }

  ParamSymbol *pSym = createParamSymbol(s);
  if(t->ParamHead == NULL){
    t->ParamHead = pSym;
    t->ParamTail = pSym;
  }
  else {
    t->ParamTail->next = pSym;
    t->ParamTail = pSym;
  }
  return s;
}

/**
 * used to find symbols in record, not allowed to jump scopes
 */
SYMBOL *getRecordSymbol(SymbolTable *t, char* name){
    int hashIndex = Hash(name);
    SYMBOL **table = t->table;
    SYMBOL *temp = table[hashIndex];
    while(temp != NULL){
      if(!strcmp(temp->name, name)){
        return temp;
      } else {
        temp = temp->next;
      }
    }
    return NULL;
}

/**
 * returns closest symbol with name char *name
 */
SYMBOL *getSymbol(SymbolTable *t, char *name){
  int hashIndex = Hash(name);
  SYMBOL **table = t->table;
  SYMBOL *temp = table[hashIndex];
  while(temp != NULL){
    if(!strcmp(temp->name, name)){
      return temp;
    } else {
      temp = temp->next;
    }
  }
  //navigate to next hashtable if there is one
  if(t->next != NULL){
    return getSymbol(t->next, name);
  } else {
    return NULL;
  }
}

/**
 * used by code generation, nr jumps
 * is used to know how many static links we
 * need to follow
 */
SYMBOL *IRgetSymbol(SymbolTable *t, char *name, int *nrJumps){
  int hashIndex = Hash(name);

  //search in current table
  SYMBOL **table = t->table;
  SYMBOL *temp = table[hashIndex];
  while(temp != NULL){
    if(!strcmp(temp->name, name)){
      return temp;
    } else {
      temp = temp->next;
    }
  }
  //navigate to next hashtable if there is one
  if(t->next != NULL){
    int intTemp = *nrJumps;
    intTemp = intTemp + 1;
    *nrJumps = intTemp;
    return IRgetSymbol(t->next, name, nrJumps);
  } else {
    return NULL;
  }
}
/**
 * debug function, prints symboltable
 */
void dumpSymbolTable(SymbolTable *t){
  if(t == NULL){
    return;
  }

  dumpSymbolTable(t->next);
  if(t->next != NULL){
    fprintf(stderr,"\n%8s\n","/\\ ");
    fprintf(stderr,"%8s\n","/||\\");
    fprintf(stderr,"%8s\n"," || ");
    fprintf(stderr,"%8s\n"," || ");
    fprintf(stderr,".:childnode:.\n");
  } else {
    fprintf(stderr,".:root:.\n");
  }
  SYMBOL **table = t->table;
  fprintf(stderr,"%-9s %-15s %-10s %s\n", "hashIndex", "name", "value",
   "chained pairs->");
  for(int i=0; i<HashSize; i++){
    if(table[i]!=NULL){
      SYMBOL *elm = table[i];
      fprintf(stderr,"%9d %-15s %-10d", i, elm->name, 0);
      elm = elm->next;
      while(elm != NULL){
        fprintf(stderr," -> (%s,%d)",elm->name, 0);
        elm = elm->next;
      }
      fprintf(stderr,"\n");
    }
  }

}

/**
 * Returns 1 if symbol is in list
 * Returns 0 if not, if no list or no symbol is given
 */
int containsSym(SymbolList *list, SYMBOL *sym){
  if(sym == NULL){
    return 0;
  }
  while(list != NULL){
    if(sym == list->symbol){
      return 1;
    }
    list = list->next;
  }
  return 0;
}

/**
 * Prepends the symbol to the list
 * list may have repetitions
 * the given and returned list is the same
 */
SymbolList* prependSymbol(SymbolList *list, SYMBOL *sym){
  if(sym == NULL){
    return list;
  }
  SymbolList *sl = NEW(SymbolList);
  sl->symbol = sym;
  sl->next = list;
  list = sl;
  return sl;
}
