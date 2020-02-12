import angr
import sys
import argparse
import re
import pyvex
import claripy
import string
import simuvex

argv=sys.argv

int_max=int(sys.maxsize/pow(2,32)+1)
int_min=int(-sys.maxsize/pow(2,32))

parser = argparse.ArgumentParser(description='Search \'win\' function by angr.')
parser.add_argument('./a.out', action='store', help='target binary filename.')
s={}
p = angr.Project('./'+str(argv[1]), load_options={'auto_load_libs': False}) 
addr_main = p.loader.main_object.get_symbol('main').rebased_addr
address = int((argv[2]),16)
c=0
state = p.factory.blank_state(addr=addr_main)
k = state.posix.files[0].read_from(1)
state.solver.add(k >= 0x20)
state.solver.add(k <= 0x7e)
#state.solver.add(k != 0x01)
state.posix.files[0].seek(0)
while True:
    simgr = p.factory.simgr(state)
    simgr.explore(find=address)
    for path in simgr.found:
        s[c] = simgr.found[0]
    else:
        pass
    irsb = p.factory.block(address).vex
    for stmt in irsb.statements:
        if isinstance(stmt,pyvex.stmt.IMark) : 
            addr = str(stmt)
            m = re.search('^.*0x([a-z0-9_]+),.*([0-9]+),.*$',addr)
    if int(m.group(1),16) <= int(argv[3],16): 
        address=int(m.group(1),16) + int(m.group(2))
    else: 
        break
    if m is not None:
       c+=1
num=0
for i in range(0,c):
    num = s[i].posix.dumps(0)
    print(num)
    if re.search(r'[\x00-\x1f\x7f-\x9f]', num) != None:
        num = re.sub(r'[\x00-\x1f\x7f-\x9f]', ' ', num)
    if num[1:-1].isdigit() == True and num[-1:].isdigit() == False:
        if len(num) == 12: 
            num = int(s[i].posix.dumps(0)[:-1])
    elif num[1:].isdigit() == True:
        num = int(s[i].posix.dumps(0))
    if isinstance(num,int) == True:
        while True:
            if int(num) < int_max and int(num) >= int_min:
                break
            else:
                if (int(num) >= int_max):
                    num = int_min + (int(num) + int_min)
                elif (num < int_min):
                    num = int_max + (int(num) + int_max)
    print(num)
