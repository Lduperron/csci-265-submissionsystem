#!/usr/bin/perl
######################################################
#-------------File: ./stack_adt/stack_tst.pl-------------
# Peter Walsh
# stack test driver
######################################################

use lib '../';
use stack_adt::stack;

$s0=stack_adt::stack->new(10);
print("Initial stack size ", $s0->size(), "\n");
$s0->push(0);
$s0->push(1);
$s0->push(6);
$s0->push(9);
$s0->push(12);
print ("Top should be 12 Top = ", $s0->top(), "\n");
$s0->pop();
print ("Top should be 9 Top = ", $s0->top(), "\n");
print("stack size ", $s0->size(), "\n");
$s0->dump();
