grep 'ł$' $1 | while read i
do
	li=$(echo "$i"|sed -e 's/iał/ieli/;s/ł/li/')
	el=$(echo "$i"|sed -e 's/ął/ęł/')
	echo ${i}em; echo ${i}eś
	echo $li; echo ${li}śmy;echo ${li}ście
	echo ${el}a ; echo ${el}aś; echo ${el}am
	echo ${el}y; echo ${el}yśmy; echo ${el}yście
done
	
