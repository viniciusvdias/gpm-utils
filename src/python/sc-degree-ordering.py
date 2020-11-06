import sys
import errno

inputfile = sys.argv[1]
if sys.argv[2] == "a":
    reverse = False
elif sys.argv[2] == "d":
    reverse = True
else:
    print("a: Non-decreasing d: Non-increasing")
    sys.exit(1)

nvertices = 0
degrees = []

with open(inputfile, "r") as f:
    toks = f.readline().split()
    nvertices = int(toks[0])

    for u in range(0,nvertices):
        toks = f.readline().split()
        degrees.append(len(toks) - 1)

# vertex non-decreasing degree-ordering
degree_ordering = list(range(0, nvertices))
degree_ordering.sort(key = lambda u: degrees[u], reverse = reverse)
del degrees

# write ordering (old rank -> new rank)
try:
    for u in range(0, nvertices):
        sys.stdout.write("%d %d\n" % (degree_ordering[u], u))
except IOError as e:
    if e.errno == errno.EPIPE:
        pass
