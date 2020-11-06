import igraph as ig
import sys
import errno

inputfile = sys.argv[1]
g = ig.Graph()
nvertices = 0

def edges_gen(inputfile):
    with open(inputfile, "r") as f:
        toks = f.readline().split()
        global nvertices
        nvertices = int(toks[0])
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
degeneracy_ordering.sort(key = lambda u: coreness[u])
del coreness

# write ordering (old rank -> new rank)
try:
    for u in range(0, nvertices):
        sys.stdout.write("%d %d\n" % (degeneracy_ordering[u], u))
except IOError as e:
    if e.errno == errno.EPIPE:
        pass
