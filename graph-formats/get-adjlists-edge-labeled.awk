BEGIN {
   lastu = -1
   idx = 0
}
{
   uid = $1
   vid = $2
   elabel = $3
   nedges += 1
   
   if (lastu != -1 && uid != lastu) {
      printf "%d", lastu
      for (k in adjlist) {
         printf " %d", adjlist[k]
         printf " %d", adjlistlabel[k]
         delete adjlist[k]
         delete adjlistlabel[k]
      }
      printf "\n"
      idx = 0
   }

   adjlist[idx] = vid
   adjlistlabel[idx] = elabel
   lastu = uid
   idx += 1

   if (nedges % 1000000 == 0) {
      printf "# edges processed = %d\n", nedges | "cat 1>&2"
   }
}
END {
   printf "%d", uid
   for (k in adjlist) {
      printf " %d", adjlist[k]
      printf " %d", adjlistlabel[k]
      delete adjlist[k]
      delete adjlistlabel[k]
   }
   printf "\n"

}
