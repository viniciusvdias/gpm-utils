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

nvertices = 0
nedges = 0
degrees = []

isolated = []

# find degree ordering
with open(inputfile, "r") as f:
    toks = f.readline().split()
    nvertices = int(toks[0])
    nedges = int(toks[1])

    for u in range(0,nvertices):
        line = f.readline()
        toks = line.split()
        nneighbors = len(toks) - 1
        degrees.append(nneighbors)

        if nneighbors == 0:
            isolated.append(u)

# sort vertices according to the degree ordering
degree_ordering = list(range(0, nvertices))
degree_ordering.sort(key = lambda u: degrees[u], reverse = reverse)
del degrees


vertex_to_ordering = list(range(0, nvertices))

for i in range(len(vertex_to_ordering)):
    u = degree_ordering[i]
    vertex_to_ordering[u] = i

apply_ordering(inputfile, outputfile, vertex_to_ordering)
