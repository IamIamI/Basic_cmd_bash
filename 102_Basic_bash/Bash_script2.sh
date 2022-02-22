variable=1

if [[ variable = 1 ]]; then
	echo "Variable is indeed a 1"
elif [[ variable = 2 ]]; then
	echo "Variable is a 2"
else
	echo "Variable is neither 1 or 2"
fi

if [[ variable = true ]]; then
	echo "You changed the variable type to boolean"
elif [[ variable = false ]]; then
	echo "You changed the variable type to boolean"
fi

if [[ variable = *[a-zA-Z]* ]]; then
	echo "You changed the variable type to string"
fi