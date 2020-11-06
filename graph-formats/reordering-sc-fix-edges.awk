BEGIN {
   nextedgeid=0
}
{
   u=$1
   ulabel=$2
   printf "%s", ulabel

   for(i=3;i<=NF;++i) {
      split($i,toks,",");
      v=toks[1]
      e=toks[2]
      if(v > u) {
         edgeids[e]=nextedgeid
         nextedgeid=nextedgeid+1
      }

      printf " %s,%s", v, edgeids[e]
   }

   printf "\n"
}
