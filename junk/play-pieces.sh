cat /tmp/ctm-to-listen|while read i
do
	f=$(echo "$i"|awk '{print $1}'|awk -F':' '{print $NF}')
	t=$(echo "$i"|awk '{print $3}'|awk -F'.' '{print $1}')
	w=$(echo "$i"|awk '{print $5}')

	grep --color=auto -i $w $(cat text/actual-texts|awk '{print "text/" $0}')
	echo $w
	ffplay -loglevel error -ss $t $f
done
