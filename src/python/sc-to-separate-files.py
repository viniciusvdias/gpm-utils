import sys
import os

inputfile = sys.argv[1]
outputdir = sys.argv[2]

if not os.path.exists(outputdir):
    os.mkdir(outputdir)


# metadata
with open(inputfile, "r") as f:
    line = f.readline().strip()
    with open("%s/metadata" % outputdir, "w") as fout:
        fout.write("%s\n" % line)


# vlabels
with open(inputfile, "r") as f:
    with open("%s/vlabels" % outputdir, "w") as fout:
        firstline = True
        for line in f:
            if firstline:
                firstline = False
                continue
            toks = line.strip().split(" ")
            if len(toks) > 0:
                fout.write("%s\n" % toks[0])
            else:
                fout.write("\n")

# elabels
with open(inputfile, "r") as f:
    with open("%s/elabels" % outputdir, "w") as fout:
        firstline = True
        u = -1
        for line in f:
            if firstline:
                firstline = False
                continue
            
            u += 1

            toks = line.strip().split(" ")
            
            for i in range(1,len(toks)):
                edgetoks = toks[i].strip().split(",")
                v = int(edgetoks[0])
                if u > v: continue
                if len(edgetoks) > 2:
                    fout.write("%s\n" % ",".join(edgetoks[2:]))
                else:
                    fout.write("\n")

# adjlists
with open(inputfile, "r") as f:
    with open("%s/adjlists" % outputdir, "w") as fout:
        firstline = True
        for line in f:
            if firstline:
                firstline = False
                continue
            
            toks = line.strip().split(" ")
            
            for i in range(1,len(toks)):
                edgetoks = toks[i].strip().split(",")
                if i > 1: fout.write(" ")
                fout.write("%s,%s" % (edgetoks[0],edgetoks[1]))

            fout.write("\n")
