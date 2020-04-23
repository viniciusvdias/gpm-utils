FNR == NR {
   ids[$1] = $2
   next
}
{
   u = ids[$1]
   v = ids[$2]
   if (u < v) {
      printf "%d %d\n", u, v
   }
}
