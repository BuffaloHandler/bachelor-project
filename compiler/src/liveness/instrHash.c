#include "internalASM.h"
#include "memory.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int Hash2(char *str){
  unsigned int sum = 0;
  for (unsigned int i = 0; i < strlen(str); i++){
    char c = str[i];
    sum += c;
    if(i < strlen(str)-1){
      sum <<= 1;
    }
  } return sum % HASHSIZE2;
}

/**
 * Creates and returns the instruction hash table
 */
InstrTable *initInstrHashTable(){
  InstrTable* table = Malloc(sizeof(InstrTable));
  memset(table->table, 0, sizeof(table->table));
  return table;
}

/**
 * Puts label instruction int hash table
 * Returns -1 if instruction is not a label
 */
int instrHashPutInstr(InstrTable *t, INSTR *instr){
  //make new symbol add name and value
  if(instr->instrKind != labelI){
    fprintf(stderr, "INTERNAL ERROR: tried to put something not a label\n");
    return -1;
  }
  InstrUnit *iu = NEW(InstrUnit);
  iu->instr = instr;
  iu->next = NULL;
  //find index via hash value of label-name
  int hashIndex = Hash2(instr->paramList->val.label);
  //insert into table
  InstrUnit **table = t->table;
  if(table[hashIndex] == NULL){
    table[hashIndex] = iu;
  } else {
    InstrUnit *temp = table[hashIndex];
    while(temp != NULL){
      if(temp->instr == instr){ //name is already in this table
        fprintf(stderr, "INTERNAL ERROR: \
          instrHashPutInstr(): Somehow the instruction was already inserted\n");
        return -1;
      }
      if(temp->next == NULL){
        break; //no more elements to check
      }
      else{ //as long as there is a next, check the next one.
        temp = temp->next;
      }
    }
    temp->next = iu;
  }
  return 0;
}

/**
 * Returns the label instruction having the given label
 * Returns NULL if the label was nut found in the given table
 */
INSTR *instrHashGetINSTR(InstrTable *t, char *label){
  //find index via hash
  int hashIndex = Hash2(label);
  //search in current table
  InstrUnit **table = t->table;
  InstrUnit *temp = table[hashIndex];
  while(temp != NULL){
    if(!strcmp(temp->instr->paramList->val.label, label)){
      return temp->instr; //found correct instruction
    } else {
      temp = temp->next;
    }
  }
  return NULL;
}
