mkvoc(){ echo $1 >> vocab-to-add; }
mkpronasl(){ printf "$1\t$2\t$3\n" >> pron-data/pronounce-as.tsv ; }
mknorm(){ printf "$1\t$2\t$3\n" >> specific-norms.tsv ;}
mkcor(){ printf "$1\t$2\t$3\tC\n" >> specific-norms.tsv; }
simpleas(){ printf "$1\t$2\n" >> pron-data/pronounce-as.tsv ; }
mklmcor(){ printf "$1\t$2\n" >> lm-normalisations.tsv ; }
