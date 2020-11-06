import sys
import errno
import random as rnd
import random as rnd

inputfile = sys.argv[1]
seed = int(sys.argv[2])
nvertices = 0

with open(inputfile, "r") as f:
    toks = f.readline().split()
    nvertices = int(toks[0])

# vertex non-decreasing degree-ordering
shuffled_ordering = list(range(0, nvertices))
rnd.seed(seed)
rnd.shuffle(shuffled_ordering)

# write ordering (old rank -> new rank)
try:
    for u in range(0, nvertices):
        sys.stdout.write("%d %d\n" % (shuffled_ordering[u], u))
except IOError as e:
    if e.errno == errno.EPIPE:
        pass
