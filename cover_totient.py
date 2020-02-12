#!/usr/bin/env python

import re, sys
from z3 import *

TOTAL_TESTS=20001

def process_file (fname):
    lines=[]
    f=open(fname,"r")
 
    while True:
        l=f.readline().rstrip()
        m = re.search('^ *([0-9]+): *([0-9]+):.*$', l)
#        w = re.search('^ *([0-9]+): *([0-9]+):.*while.*$', l)
#        i = re.search('^ *([0-9]+): *([0-9]+):.*if.*$', l)
#        fo = re.search('^ *([0-9]+): *([0-9]+):.*for.*$', l)
#        e = re.search('^ *([0-9]+): *([0-9]+):.*else.*$', l)
        if m!=None:
            lines.append(int(m.group(2)))
            print(m.group(2))
        if len(l)==0:
            break
    f.close()
    return lines

stat={}
for test in range(-10000,10000):
    stat[test]=process_file("testgen/totient.c.gcov."+str(test))
all_lines=set()
tests_for_line={}

for test in stat:
    all_lines|=set(stat[test])
    for line in stat[test]:
        tests_for_line[line]=tests_for_line.get(line, []) + [test]
tests=[Int('%d' % (t)) for t in range(TOTAL_TESTS)]
#opt = Optimize()

#for t in tests:
#    opt.add(Or(t==0, t==1))
#for line in list(all_lines):
#    expressions=[tests[s]==1 for s in tests_for_line[line]]
#    opt.add(Or(*expressions))
#h=opt.minimize(Sum(*tests))


#print (opt.check())
#m=opt.model()
#print ("\ntest suite:")
#for t in tests:
#    if m[t].as_long()==1:
#        print (t)

