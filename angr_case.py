#!/usr/bin/env python

import re, sys,os
from z3 import *
argv=sys.argv
def process_file (fname):
    lines=[]
    f=open(fname,"r")
    while True:
        l=f.readline().rstrip()
        m = re.search('^ *([0-9]+): *([0-9]+):.*$', l)
        if m!=None:
            lines.append(int(m.group(2)))
        if len(l)==0:
            break
    f.close()
    return lines

stat={}
name={}

#test
i=0
for test in os.listdir('./tests'):
#    for y in len(argv[1]):
#        if(test[len(argv[1]):] == argv[1]):
    if str(argv[1]) in test:
        stat[i]=process_file("tests/"+str(test))
        name[i]="tests/"+str(test)
        i += 1

all_lines=set()
tests_for_line={}
for test in stat:
    all_lines|=set(stat[test])
    for line in stat[test]:
        tests_for_line[line]=tests_for_line.get(line, []) + [test]

tests=[Int('%d' % (t)) for t in range(i)]

opt = Optimize()
#t = Int('t')
for t in tests:
    opt.add(Or(t==0, t==1))
#    opt.add_soft(t == 1,0)
#    opt.add_soft(t == 0,1)
for line in list(all_lines):
    expressions=[tests[s]==1 for s in tests_for_line[line]]
    opt.add(Or(*expressions))
h=opt.minimize(Sum(*tests))

print (opt.check())
m=opt.model()
print ("\ninput set:")
c=0
for t in tests:
    if m[t].as_long()==1:
        print(name[c].split('.',3)[3])
        #print(name[c].strip("tests/"+argv[1]+".gcov"))
    c += 1

