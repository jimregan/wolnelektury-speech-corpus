mkvoc(){ echo $1 >> vocab-to-add; }
mkpronasl(){ printf "$1\t$2\t$3\n" >> pron-data/pronounce-as.tsv ; }
mknorm(){ printf "$1\t$2\t$3\n" >> specific-norms.tsv ;}
mkcor(){ printf "$1\t$2\t$3\tC\n" >> specific-norms.tsv; }
dehyph(){ in=$2; out=$(echo "$in"|tr '-' ' '); mkcor $1 "$in" "$out" ;}
simpleas(){ printf "$1\t$2\n" >> pron-data/pronounce-as.tsv ; }
mklmcor(){ printf "$1\t$2\n" >> lm-normalisations.tsv ; }
pa_ski_adj(){
	ba=$1
	oa=$2
	basea=$(echo $ba|sed -e 's/i$//')
	outa=$(echo $oa|sed -e 's/i$//')
	for i in i ich iego iemu im imi o a ą ie iej;do
		simpleas $basea$i $outa$i
		simpleas nie$basea$i nie$outa$i
	done
	simpleas ${basea}u ${outa}u
	basempl=$(echo $ba|sed -e 's/ki$//')
	outmpl=$(echo $oa|sed -e 's/ki$//')
	simpleas ${basempl}cy ${outmpl}cy
	simpleas nie${basempl}cy nie${outmpl}cy
}
mv_ski_adj(){
	ba=$1
	basea=$(echo $ba|sed -e 's/i$//')
	for i in i ich iego iemu im imi o a ą ie iej;do
		mkvoc $basea$i
		mkvoc nie$basea$i
	done
	mkvoc ${basea}u
	basempl=$(echo $ba|sed -e 's/ki$//')
	mkvoc ${basempl}cy
	mkvoc nie${basempl}cy
}
