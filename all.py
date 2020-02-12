import angr
import sys
import argparse
import re
import pyvex

argv=sys.argv

int_max=int(sys.maxsize/pow(2,32)-1)
int_min=int(-sys.maxsize/pow(2,32))

parser = argparse.ArgumentParser(description='Search \'win\' function by angr.')
parser.add_argument('./a.out', action='store', help='target binary filename.')
s={}
p = angr.Project('./'+str(argv[1]), load_options={'auto_load_libs': False}) 

addr_main = p.loader.main_object.get_symbol('main').rebased_addr
address = int((argv[2]),16)
state = p.factory.blank_state(addr=addr_main)
c=0
#for i in range(30):
tmp = state.posix.files[0].read_from(1)
#state.solver.add(tmp >= ' ')
#state.solver.add(tmp <= '~')
#state.solver.add(tmp <= 0x7e)
#state.solver.add(tmp != 0x00)
#state.posix.files[0].seek(0)
simgr = p.factory.simgr(state)
simgr.explore(find=address)
if len(simgr.found) > 0:
    s[c] = simgr.found[0]
#    print(s[c].posix.dumps(0))
    print("%r" % s[c].posix.dumps(0))
#    print(s[c].posix.dumps(0).split("\x00"))
#    print(len(s[c].posix.dumps(0)))
else:
    print('Not found.')
irsb = p.factory.block(address).vex
#for stmt in irsb.statements:    
#    if isinstance(stmt,pyvex.stmt.IMark) :  
#        addr = str(stmt)
#        m = re.search('^.*0x([a-z0-9_]+),.*([0-9]+),.*$',addr)
#if int(m.group(1),16) <= int(argv[3],16): 
#    address=int(m.group(1),16) + int(m.group(2))
#    c+=1
#    print(address)
#else: 
#    break

#num = s[c].posix.dumps(0)
#print(num)
