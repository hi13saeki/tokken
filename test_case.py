#!/usr/bin/env python

import re, sys
from z3 import *

TOTAL_TESTS=20001
INT_MIN=-99
INT_MAX=99
argv=sys.argv

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
        if len(l)==0:
            break
    f.close()
    return lines

stat={}
tmp={}
youso=[]
case=[]
suite=""
flag=0
f={}
num=int(argv[2])
test=0

for inputs in range(0,num):
    f[inputs] = INT_MIN


while f[num-1] < INT_MAX:
    for c in range(0,num):
        if f[c] > INT_MAX:
            f[c+1] += 1
            f[c] = INT_MIN
        suite=suite+str(f[c])+"_" #hukannzen
    suite = suite[:-1]
    f[0] += 1
    tmp[test]=process_file("testgen/"+str(argv[1])+".gcov."+str(suite))
    if flag != 0:
        for judge in range(0,len(youso)):
            if set(tmp[test]) == set(stat[youso[judge]]): #same excection
                case.append("")
                break 
            if judge == len(stat)-1: #deferent excection
                stat[test] = tmp[test]
                youso.append(int(test))
                case.append(suite)
    else:
        stat[test]=tmp[test]
        youso.append(int(test))  
        case.append(suite)
        flag=1
    suite=""
    test += 1

all_lines=set()
tests_for_line={}
tests=[]
for i in youso:
    all_lines|=set(stat[i])
    for line in stat[i]:
        tests_for_line[line]=tests_for_line.get(line, []) + [i]
    
tests=[Int('%s' % (case[t])) for t in range(test)]

opt = Optimize()
for t in tests:
    opt.add(Or(t==0, t==1))
for line in list(all_lines):
    expressions=[tests[s]==1 for s in tests_for_line[line]]
    opt.add(Or(*expressions))
h=opt.minimize(Sum(*tests))


print (opt.check())
m=opt.model()
print ("\ntest suite:")
for t in tests:
    if m[t].as_long()==1:
        print (t)

