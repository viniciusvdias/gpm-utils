import igraph as ig
import sys
import os
import tempfile
import subprocess

def apply_ordering(inputfile, outputfile, ordering):
    neighborhood_data = []
    # create temp files (to be able to process huge graphs w/o oom)
    with tempfile.NamedTemporaryFile(prefix="tmp", mode="w") as tmpf1, \
            tempfile.NamedTemporaryFile(prefix="tmp", mode="w") as tmpf2:
        tmpf1_name = tmpf1.name
        tmpf2_name = tmpf2.name

    # remap vertices
    with open(inputfile, "r") as f, open(tmpf1_name, "w") as tmpf1:
        toks = f.readline().split()
        nvertices = int(toks[0])
        nedges = int(toks[1])
        for u in range(0,nvertices):
            toks = f.readline().split()
            tmpf1.write("%d %s" % (ordering[u], toks[0]))

            neighborhood_data.clear()
            for tok in toks[1:]:
                neighbor_toks = tok.split(",")
                v = ordering[int(neighbor_toks[0])]
                neighborhood_data.append((v, ",".join(neighbor_toks[1:])))
                #tmpf1.write(" %d,%s" % (v, ",".join(neighbor_toks[1:])))

            neighborhood_data.sort(key = lambda kv: kv[0])
            
            for i in range(0, len(neighborhood_data)):
                tmpf1.write(" %d,%s" % (
                    neighborhood_data[i][0], neighborhood_data[i][1]))
            tmpf1.write("\n")

    # sort vertices by ID
    with open(tmpf1_name, "r") as tmpf1, open(tmpf2_name, "w") as tmpf2:
        sortpcmd = "sort -n -k1,1"
        sortp = subprocess.Popen(sortpcmd.split(), stdin=tmpf1, stdout=tmpf2)
        sortp.communicate()

    # remove tmp file
    os.unlink(tmpf1_name)

    # remap edges
    edges_ids = {}
    with open(tmpf2_name, "r") as tmpf2, open(outputfile, "w") as fout:
        fout.write("%d %d\n" % (nvertices, nedges))
        for u in range(0,nvertices):
            toks = tmpf2.readline().split()
            fout.write(toks[1])
            for tok in toks[2:]:
                neighbor_toks = tok.split(",")
                v = int(neighbor_toks[0])
                if u < v:
                    e = len(edges_ids)
                    edges_ids[(u,v)] = e
                else:
                    e = edges_ids[(v,u)]

                fout.write(" %d,%d" % (v, e))
                if len(neighbor_toks) > 2:
                    fout.write(",")
                    fout.write(",".join(neighbor_toks[2:]))
            fout.write("\n")

    # remove tmp file
    os.unlink(tmpf2_name)
