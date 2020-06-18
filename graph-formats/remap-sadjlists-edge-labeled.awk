FNR == NR {
   ids[$1] = $2
   next
}
{
   u = ids[$2]
   if (u != FNR - 1) {
      printf "invalid index line:(%s) NR:%d FNR:%d ids[2]:%d\n", $0,NR,FNR,u | "cat 1>&2"
   }
   printf "%d 1", u
   ai=0
   for (i in elabels) delete elabels[i]
   for (i=3; i<=NF; i=i+2) {
      id=ids[$i]
      idplus1=i+1
      elabels[id]=elabels[id]","$idplus1
      a[ai]=id
      ai+=1
   }

   asort(a)

   lastv = -1
   for (v in edgeids) delete edgeids[v]
   for (i in a) {
      v = a[i]
      if (lastv == -1 || v != lastv) {
         if (u < v) {
            if (v in edgeids) {
               eid = edgeids[v]
            } else {
               eid = nexteid
               nexteid+=1
               edgeids[v]=eid
            }
            eids[u,v] = eid
         } else {
            eid = eids[v,u] 
         }
         printf " %d,%d%s", v, eid, elabels[v]
      }
      lastv = v
      delete a[i]
   }

   printf "\n"
}
