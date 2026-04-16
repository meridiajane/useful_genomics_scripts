#!/bin/awk -f 

BEGIN {
    RS=">"
    FS="\n"
    tmp_cnt=0
    cnt=1
    fnme=output"_"cnt".fasta"
    if(file_size == "" || output == "") {
        print "TO USE: ./script.awk -v file_size=XXX -v output=YYY INPUT_FASTA\nWhere file_size is the number of sequences per file (maximum),\noutput is the prefix for output file names, and input_tsv is a\nmultifasta file you wish to divide.\n\n"
        exit 1
    }
}

NR > 1 {
    if(tmp_cnt >= file_size) {
        gsub("\n\n","\n",tmp_out)
        printf tmp_out > fnme
        close(fnme)
        cnt++
        tmp_cnt=1
        fnme=output"_"cnt".fasta"
        tmp_out=">"$0
    }
    else {
        fnme=output"_"cnt".fasta"
        tmp_out=tmp_out">"$0
        tmp_cnt++
    }
}

END {
    gsub("\n\n","\n",tmp_out)
    printf tmp_out > fnme
    close(fnme)
}
