#! /bin/bash
printf "%-32s %-10s\n" 命令 次数  
cat ~/.bash_history | awk '{list[$1]++} 
END {  
	for (i in list ) { 
		printf ("%-30s %-10s\n",i,list[i])
	}  
}'|sort -nrk 2 | head
