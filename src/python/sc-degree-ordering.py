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

# find degree ordering
with open(inputfile, "r") as f:
    toks = f.readline().split()
    nvertices = int(toks[0])
    nedges = int(toks[1])

    for u in range(0,nvertices):
        toks = f.readline().split()
        nneighbors = len(toks) - 1
        degrees.append(nneighbors)

# sort vertices according to the degree ordering
degree_ordering = list(range(0, nvertices))
degree_ordering.sort(key = lambda u: degrees[u], reverse = reverse)
del degrees

apply_ordering(inputfile, outputfile, degree_ordering)
