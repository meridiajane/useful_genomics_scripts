#!/bin/gawk -f
## TO USE: ./flag_n.awk INPUT.FASTA,
## where INPUT_FASTA is the fasta you want to identify contig joins in. flag_it.awk will only 
## accept fasta as input and will produce a bed file containing the location of Ns (contig joins) 
## in each sequence therein.
##################################### REQUIRES GAWK (GNU AWK) #####################################

function genbed(chr, seq) {
    split(seq, w, /N*/, u)
    for (key in w) {
	    running_length+=length(w[key])
	    if(u[key] == "") {
		continue
	}
    	print chr"\t"running_length+1"\t"running_length+length(u[key])
	running_length+=length(u[key])
    }
    running_length=0
}

NR==1 {
    if ($0 !~ /^>/) {
        print $0
        print "Input is not a fasta"
        exit 1
    }
    chr=$0
    gsub(">","",chr)
    gsub(/ .*/,"",chr)
    next
}

{
    if ($0 ~ ">") {
	genbed(chr,seq)	
        seq=""
        chr=$0
        gsub(">","",chr)
        gsub(/ .*/,"",chr)
    }
    else {
        seq=seq$0
    }
}

END {
    genbed(chr,seq)
}
