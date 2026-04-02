#!/bin/awk -f

BEGIN {
    if ((bin_size == "") && (bin_size == 0)) {
        printf "TO USE: ./depth_binner.awk -v bin_size=XXX INPUT.TSV -v se=True (optional)\nWhere XXX is the number of bases per bin, and INPUT.TSV is a tsv with columns\nchromosome, base, depth value. If \"True\" (case insensitive) is passed to se,\nthen standard error will be calculated for each bin. If bin_size is missing, this help will print.\n\n" > "/dev/stderr"
        exit 1
    };
    count=0;
    prev="";
    val=0;
    bin=1;
    if (toupper(se) == "TRUE") {
	print "Running with SE." > "/dev/stderr"
    }
    else {
	print "Running without SE." > "/dev/stderr"
    }
}
{
    if (toupper(se) == "TRUE") {
        if (NR == 1) {
            prev = $1;
            count = 1;
            val = $3;
            a[count] = $3
        };
        
        if (NR != 1) {
            if (prev != $1) {
                mean = val/count
                for (i = 1; i <= count; i++) {
                    sd_sum += (a[i]-mean)^2
                };
                print prev"\t"bin"\t"mean"\t"sqrt(sd_sum/(count-1))/sqrt(count);
                count = 1;
                prev = $1;
                val = $3;
                bin = 1;
                sd_sum = 0;
                a[count]=$3;
                next
            };
            if (prev == $1) {
                if (count == bin_size) {
                    mean = val/count
                    for (i = 1; i <= count; i++) {
                        sd_sum += (a[i]-mean)^2
                    };
                    print prev"\t"bin"\t"mean"\t"sqrt(sd_sum/(count-1))/sqrt(count);
                    count = 1;
                    val = $3;
                    bin += 1;
                    sd_sum = 0;
                    a[count] = $3;
                    next
                };
                count += 1;
                val += $3;
                a[count] = $3
            }
        }
    }
    else {
        if (NR == 1) {
            prev = $1;
            count = 1;
            val = $3;
            a[count] = $3
        };

        if (NR != 1) {
            if (prev != $1) {
                mean = val/count
                print prev"\t"bin"\t"mean;
                count = 1;
		prev = $1;
                val = $3;
                bin = 1;
                sd_sum = 0;
                next
            };
            if (prev == $1) {
                if (count == bin_size) {
                    mean = val/count
                    print prev"\t"bin"\t"mean;
                    count = 1;
                    val = $3;
                    bin += 1;
                    sd_sum = 0;
                    next
                };
                count += 1;
                val += $3
            };
        };
    };
}

END {
    mean = val/count;
    if (toupper(se) == "TRUE") {
        for (i = 1; i <= count; i++) {
            sd_sum += (a[i]-mean)^2
        };
        print prev"\t"bin"\t"mean"\t"sqrt(sd_sum/(count-1))/sqrt(count)
    }
    else {
    print prev"\t"bin"\t"mean
    };
}

