import angr
import sys
import argparse
import re
import pyvex
argv=sys.argv

parser = argparse.ArgumentParser(description='Search \'win\' function by angr.')
parser.add_argument('./a.out', action='store', help='target binary filename.')
p = angr.Project('./'+str(argv[1]), load_options={'auto_load_libs': False}) 

addr_main = p.loader.main_object.get_symbol('main').rebased_addr
address = int((argv[2]),16)
entry_state = p.factory.entry_state(addr=addr_main, args=[])
c=0
a=[]
while True: 
    irsb = p.factory.block(address).vex
    for stmt in irsb.statements:    
        if isinstance(stmt,pyvex.stmt.IMark) :  
            addr = str(stmt)
            m = re.search('^.*0x([a-z0-9_]+),.*([0-9]+),.*$',addr)
    if int(m.group(1),16) <= int('4010d1',16): 
        address=int(m.group(1),16) + int(m.group(2))
        c+=1
        a.append(address)
    else: 
        break
x=0
simgr = p.factory.simgr(entry_state)
simgr.explore(find=a)
if len(simgr.found) > 0:
    s = simgr.found[x].state
    print "%r" % s.posix.dumps(0)
    x+=1
else:
    print 'Not found.'
