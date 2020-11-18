import sys
import random as rnd
import random as rnd
from scutils import apply_ordering

inputfile = sys.argv[1]
seed = int(sys.argv[2])
outputfile = sys.argv[3]
nvertices = 0
nedges = 0

with open(inputfile, "r") as f:
    toks = f.readline().split()
    nvertices = int(toks[0])
    nedges = int(toks[1])

# vertex non-decreasing degree-ordering
shuffled_ordering = list(range(0, nvertices))
rnd.seed(seed)
rnd.shuffle(shuffled_ordering)

apply_ordering(inputfile, outputfile, shuffled_ordering)
