i=1

while read line; do
	if [[ i -gt 2 ]]; then
		echo $line
		sleep 0.5
	else
		clear
		echo $line
		sleep 2
		clear
	fi
	i=$((i + 1))
done < while_loop_example.txt
