#!/bin/bash

# takes flex file sans .l as arg, generates and compiles lex.yy.c
flex $1.l
gcc -Iinclude -o $1.o lex.yy.c -Llib -lfl -lstack -O3