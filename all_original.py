# winsolve.py
import angr
import sys
import argparse
import time	
start = time.time()
argv=sys.argv

parser = argparse.ArgumentParser(description='Search \'win\' function by angr.')
parser.add_argument('./a.out', action='store', help='target binary filename.')
#parser.add_argument('-selfmod', action='store_true', default=False, help='Support self-modifying code.') 
#opts = parser.parse_args()
#target = opts.targetbin
p = angr.Project('./'+str(argv[1]), load_options={'auto_load_libs': False}) 
#f=open(str(argv[1])+".c","r")
#	support_selfmodifying_code = opts.selfmod,
#	)	
addr_main = p.loader.main_object.get_symbol('main').rebased_addr
#addr_check = p.loader.main_object.get_symbol('check').rebased_addr
#addr_win = p.loader.main_object.get_symbol('win').rebased_addr
#addr_lose = p.loader.main_object.get_symbol('lose').rebased_addr
#addr_cant = p.loader.main_object.get_symbol('cant').rebased_addr
#addr_phi = p.loader.main_object.get_symbol('phi').rebased_addr

print "main = %x" % addr_main
#print "check = %x" % addr_check
#print "cant = %x" % addr_cant	
#print "phi = %x" % addr_phi
#while True:
#    l=f.readline().rstrip()
#    print(l)
#    entry_state = p.factory.entry_state(addr=addr_main, args=[])
#    simgr = p.factory.simgr(entry_state)
#    simgr.explore(find=(l,))
#    if len(simgr.found) > 0:
#	    print 'Dump stdin at win():'
#	    s = simgr.found[0].state
#	    print "%r" % s.posix.dumps(0)
 #   else:
#	    print 'Not found.'
#    if len(l)==0:
#        break
addr_a = int((argv[2]),16)
entry_state = p.factory.entry_state()
simgr = p.factory.simgr(entry_state)
simgr.explore(find=addr_a)
if len(simgr.found) > 0:
	print 'Dump stdin at win():'
	s = simgr.found[0].state
	print "%r" % s.posix.dumps(0)
else:
	print 'Not found.'

result_time = time.time() - start
print "%f" % result_time
