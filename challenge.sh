#! /bin/bash

#this if and while condition is to create a file with a name not already used so we not erase important file

name=test
if [[ -e $name.txt || -L $name.txt ]]; then
	i=1
	while [[ -e $name'('$i')'.txt || -L $name'('$i')'.txt ]]; do
		let i++
	done
	name=$name'('$i')'
fi

touch -- "$name".txt


# the ls command print different thing but the size is in colomn 5
size=$(ls -l "$name".txt | awk '{ print $5 }')


#the script put a new line to the file until the size reach 1048576 bytes = 1mb
until [[ $size -gt 1048576 ]]
	do
#we find in the first part random things, so with the tr commande we choose only what we want, with the fold command we decide to get only strings with no more than 15 characters and each time we want one line
		cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $(( RANDOM %15 +1 )) | head -n 1 >> "$name".txt
		size=$(ls -l "$name".txt | awk '{ print $5 }')
	done

#we sort the file and save it
sort -d "$name".txt -o "$name".txt

#the wc command print how many lines are in the file
line1=$(wc -l "$name".txt | awk '{ print $1 }')

#the sed command erase all the line that starts with 'a' or 'A' and put the rest in a newfile
sed '/^[a,A]/d' "$name".txt > new"$name".txt

#the wc command print how many lines are in the newfile
line2=$(wc -l new"$name".txt | awk '{ print $1 }')

#to know how many lines was erase
remove=$(expr $line1 - $line2)

echo $remove lines were removed
