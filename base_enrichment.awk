#!/bin/awk -f

BEGIN {
    if ((bases == "") && (bases == 0) || (window == "") && (window == 0) ){
	printf "TO USE: ./base_enrichment.awk -v bases=\"ACTG\" -v window=N INPUT.FASTA,\nwhere bases is the bases you want to check the proportion of and window is the rolling window size.\nOnly accepts fasta as input, will call chr name as everything before the first space in the header.\nRolling window is right aligned.\n\n"
	exit 1
    }
    ntar = split(toupper(bases), tar, "")
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
}

{
    if ($0 ~ ">") {
        for (i=window; i<=length(seq); i++) {
	    sample=toupper(substr(seq, i-window+1, window))
	    for (j=1; j<=ntar; j++) {
		hits+=split(sample, tmp, tar[j])-1
	    }
	    print chr"\t"i"\t"hits/length(sample)
	    hits=0
	}
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
    for (i=window; i<=length(seq); i++) {
	sample=toupper(substr(seq, i-window+1, window))
	for (j=1; j<=ntar; j++) {
	    hits+=split(sample, tmp, tar[j])-1
	}
	print chr"\t"i"\t"hits/length(sample)
        hits=0
    }
}
