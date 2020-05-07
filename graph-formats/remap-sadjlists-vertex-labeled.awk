FNR == NR {
   ids[$1] = $2
   next
}
{
   u = ids[$2]
   ulabel = $3
   if (u != FNR - 1) {
      printf "invalid index line:(%s) NR:%d FNR:%d ids[2]:%d\n", $0,NR,FNR,u | "cat 1>&2"
   }
   printf "%d %d", u, ulabel
   for (i=4; i<=NF; ++i) {
      a[i-3]=ids[$i]
   }
   asort(a)
   for (i in a) {
      v = a[i]
      if (u < v) {
         eid = nexteid
         eids[u,v] = eid
         nexteid += 1
      } else {
        eid = eids[v,u] 
      }
      printf " %d,%d", v, eid
      delete a[i]
   }
   printf "\n"
}
