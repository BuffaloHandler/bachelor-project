#ifndef __patterns_h
#define __patterns_h

#include "internalASM.h"

#define NRPATTERNS 2 //faktisk 3 men det er kun 2 der virker
#define WINDOWSIZE 5

int incPattern(INSTR* instr);
int decPattern(INSTR* instr);
int wastedMovq(INSTR* instr);

#endif