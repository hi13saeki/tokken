#!/usr/bin/env python2
import angr
import sys
argv=sys.argv

p = angr.Project('./'+str(argv[1]))
state = p.factory.entry_state()
path = p.factory.path(state)
pathgroup = p.factory.path_group(path)

print "%r" % state
print "%r" % path
print "%r" % pathgroup
print "%r" % p.loader
#pathgroup.explore()

#for path in pathgroup.deadended:
#  if not path.state.posix.dumps(1).startswith('Hello,World!'):
#      print "%r" % path.state.posix.dumps(0)
