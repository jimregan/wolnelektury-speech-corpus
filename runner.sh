mkleft () {  cat  $1 |perl ~/Playing/wolnelektury-audio-corpus/split-sentence.pl |perl ~/Playing/wolnelektury-audio-corpus/clean.pl |tr ' ' '\n'|sort|uniq|perl ~/Playing/wolnelektury-audio-corpus/filter-dict.pl ~/Playing/wolnelektury-audio-corpus/pron-data/gen.tsv > /tmp/left ; }
mkinn() { cat /tmp/left |awk '{print "{{pl-IPA-auto|" $0 "}}"}' > /tmp/inn ; }

mkright() { cat /tmp/inn|gsed -e 's/IPA/\nIPA/g'|awk -F':' '{print $2}'|sed -e 's/^ //'|grep -v '^$' > /tmp/right ; }
addvocab () { paste /tmp/left /tmp/right |sed -e 's/ *$//'  >> ~/Playing/wolnelektury-audio-corpus/pron-data/gen.tsv ; }

