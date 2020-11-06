FNR == NR {
   ordering[$1]=$2
   next
}
FNR > 1 {
   delete vs
   delete es
   delete elabels

   u=ordering[FNR-2]
   ulabel=$1
   for(i=2;i<=NF;++i) {
      split($i,toks,",");
      v=ordering[toks[1]]
      vs[i-1]=v;
      es[v]=toks[2];
      for(j=3;j<=length(toks);++j) {
         elabels[es[v]]=elabels[es[v]]","toks[j]
      }
   }

   asort(vs)

   printf "%s %s", u,ulabel
   for (i in vs) {
      printf " %s,%s%s", vs[i], es[vs[i]], elabels[es[vs[i]]]
   }
   printf "\n"
}
