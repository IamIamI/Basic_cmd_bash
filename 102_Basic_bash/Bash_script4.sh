count_ah_ah_ah=( for_loop_file1.txt for_loop_file2.txt for_loop_file3.txt for_loop_file4.txt )
clear

for items in ${count_ah_ah_ah[@]}; do
	cat ${items}
	sleep 1
	clear
done