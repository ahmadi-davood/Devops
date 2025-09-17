#!/bin/bash

# Prompt for input
read -p "Enter a number: " num

# Compare and output result
if [ "$num" -gt 10 ]; then
  echo "The number is larger than 10."
elif [ "$num" -eq 10 ]; then
  echo "The number is equal to 10."
else
  echo "The number is smaller than 10."
fi
