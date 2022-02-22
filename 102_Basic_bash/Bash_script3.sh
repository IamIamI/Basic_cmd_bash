variable=1

if [[ $variable -gt 1 ]]; then
	echo "Variable is greater than 1"
elif [[ $variable -eq 1 ]]; then
	echo "Variable is equal to 1"
elif [[ $variable -lt 1 ]]; then
	echo "Variable is lower than 1"
fi

if ! [[ $variable -eq 1 ]]; then
	echo "Based on the negative statement, i have determined that you changed the number"
fi