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
   for (i=3; i<=NF; ++i) {
      a[i-3]=ids[$i]
   }
   asort(a)
   for (i in a) {
      v = a[i]
      printf " %d", v
      delete a[i]
   }
   printf "\n"
}
