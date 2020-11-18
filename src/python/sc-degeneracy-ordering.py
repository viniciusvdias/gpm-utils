import igraph as ig
import sys
from scutils import apply_ordering

inputfile = sys.argv[1]
if sys.argv[2] == "nd":
    reverse = False
elif sys.argv[2] == "ni":
    reverse = True
else:
    print("nd: Non-decreasing ni: Non-increasing")
    sys.exit(1)

outputfile = sys.argv[3]

g = ig.Graph()
nvertices = 0
nedges = 0
degrees = []

def edges_gen(inputfile):
    with open(inputfile, "r") as f:
        toks = f.readline().split()
        global nvertices
        global nedges
        nvertices = int(toks[0])
        nedges = int(toks[1])
        g.add_vertices(nvertices)

        for u in range(0,nvertices):
            toks = f.readline().split()
            for i in range(1,len(toks)):
                v = int(toks[i].split(",")[0])
                if u < v: yield (u,v)

# find coreness
g.add_edges(edges_gen(inputfile))
coreness = g.coreness()
del g

degeneracy = max(coreness)
sys.stderr.write("degeneracy = %d\n" % degeneracy)

# vertex non-decreasing degeneracy-ordering
degeneracy_ordering = list(range(0, nvertices))
degeneracy_ordering.sort(key = lambda u: coreness[u], reverse = reverse)
del coreness

apply_ordering(inputfile, outputfile, degeneracy_ordering)
