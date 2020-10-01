#! /bin/bash

name=test
if [[ -e $name.txt || -L $name.txt ]]; then
i=1
while [[ -e $name'('$i')'.txt || -L $name'('$i')'.txt ]]; do
let i++
done
name=$name'('$i')'
fi
touch -- "$name".txt



size=$(ls -l "$name".txt | awk '{ print $5 }')

until [[ $size -gt 10400 ]]
do
cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $(( RANDOM %15 +1 )) | head -n 1 >> "$name".txt
size=$(ls -l "$name".txt | awk '{ print $5 }')
done

sort est1.txt -o test1.txt

line1=$(wc -l "$name".txt | awk '{ print $1 }')

echo file has $line1 lines
sed '/^[a,A]/d' "$name".txt > new"$name".txt

line2=$(wc -l new"$name".txt | awk '{ print $1 }')
echo newfile has $line2 lines
remove=$(expr $line1 - $line2)

echo $remove lines were removed
