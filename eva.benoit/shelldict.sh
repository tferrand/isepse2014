#!/bin/bash

echo "--------------------------------------------------"
echo "-----------------SHELL DICTIONARY-----------------"
echo "--------------------------------------------------"
echo "Welcome to Shell Dictionary. Please enter a word :"
read word
dictionaryUrl="http://www.oxforddictionaries.com/definition/english/"
wordUrl=$dictionaryUrl$word
curl $wordUrl > pagecode.txt

#Delete blank lines
tr -d '\r\n' < pagecode.txt > lineCode.txt
#Only keep <section class="senseGroup">...</section>
sed -i "s/<\/section>/\n/g" lineCode.txt
grep -o '<section class="senseGroup">.*' lineCode.txt > senseGroups.txt

#Get all definitions
grep -o '<span class="iteration">.*</span>' senseGroups.txt > iterations.txt
grep -o '<span class="definition">.*</span>' iterations.txt | sed -re 's/<span class="exampleGroup.*//g' -e 's/<div class="moreInformation">.*//g' -e 's/<span class="definition">//g' -e 's/.<\/span>//g' > definitions.txt

echo "--------------------------------------------------"
echo "----------------DEFINITIONS FOUND-----------------"
echo "--------------------------------------------------"
lineNumber=1
while read line
do
  echo -e "$lineNumber.\t $line\n"
  lineNumber=`expr $lineNumber + 1`
done < definitions.txt

#Delete generated files
rm pagecode.txt lineCode.txt senseGroups.txt iterations.txt definitions.txt