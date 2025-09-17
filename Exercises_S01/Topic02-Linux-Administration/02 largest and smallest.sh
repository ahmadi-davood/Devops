#!/bin/bash

# Script to find largest and smallest of 20 numbers

echo "Enter 20 numbers:"

# Initialize variables
largest=0
smallest=0
count=0

# Read 20 numbers
while [ $count -lt 20 ]; do
    read -p "Number $((count+1)): " num
    
    # Input validation
    if ! [[ $num =~ ^-?[0-9]+$ ]]; then
        echo "Please enter a valid number!"
        continue
    fi
    
    # Initialize with first number
    if [ $count -eq 0 ]; then
        largest=$num
        smallest=$num
    else
        # Compare for largest
        if [ $num -gt $largest ]; then
            largest=$num
        fi
        
        # Compare for smallest
        if [ $num -lt $smallest ]; then
            smallest=$num
        fi
    fi
    
    count=$((count+1))
done

echo "--------------------------------"
echo "Largest number: $largest"
echo "Smallest number: $smallest"