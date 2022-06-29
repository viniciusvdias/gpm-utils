import sys
import os

inputfile = sys.argv[1]
outputdir = sys.argv[2]

if not os.path.exists(outputdir):
    os.mkdir(outputdir)

adjlists = dict()

# adjlists
with open(inputfile, "r") as f:
    for line in f:
        if line.strip().startswith("#"): continue
        toks = line.split()
        u = int(toks[0])
        v = int(toks[1])

        uadjlist = adjlists.get(u)
        if uadjlist is None:
            uadjlist = set()
            adjlists[u] = uadjlist
        uadjlist.add(v)
        
        vadjlist = adjlists.get(v)
        if vadjlist is None:
            vadjlist = set()
            adjlists[v] = vadjlist
        vadjlist.add(u)

nvertices = len(adjlists)
nedges = 0
for l in adjlists.values():
    nedges += len(l)

nedges = int(nedges / 2)

print(nedges)

# metadata
with open("%s/metadata" % outputdir, "w") as f:
    f.write("%d %d\n" % (nvertices, nedges))

edgeids = dict()

# adjlists
with open("%s/adjlists" % outputdir, 'w') as f:
    for u in range(0,nvertices):
        uadjlist = adjlists.get(u)
        if uadjlist is not None:
            uadjlist = sorted(list(uadjlist))
            for i in range(0,len(uadjlist)):
                v = uadjlist[i]
                if i > 0: f.write(" ")
                if u < v:
                    eid = len(edgeids)
                    edgeids[(u,v)] = eid
                    f.write("%d,%d" % (v, eid))
                else:
                    eid = edgeids[(v,u)]
                    f.write("%d,%d" % (v, eid))

            f.write("\n")
