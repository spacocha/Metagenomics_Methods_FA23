#! /usr/bin/perl -w
#
#


	die "Usage: taxa_file list> Redirect\n" unless (@ARGV);
($taxafile, $list) = (@ARGV);
chomp ($taxafile, $list);

open (IN, "<${taxafile}") or die "Can't open $taxafile\n";
while ($line=<IN>){
	chomp ($line);
	next unless ($line);
	($index, $KO, $K1, $P1, $G1, $info, $number)=split ("\t", $line);
	next unless ($KO);
	($node)=$index=~/^user:(.+)$/;
	($name)="$KO"."_"."$node";
	#die "$name\n";
	$transhash{$node}{$name}{"K1"}=$K1;
	$transhash{$node}{$name}{"P1"}=$P1;
	$transhash{$node}{$name}{"G1"}=$G1;
	$transhash{$node}{$name}{"info"}=$info;
	$transhash{$node}{$name}{"number"}=$number;
}
close (IN);


#print "made it to list\n";
open (IN, "<${list}") or die "Can't open $list\n";
while ($fileline=<IN>){
    chomp ($fileline);
    next unless ($fileline);
    ($prefix)=$fileline=~/\/.*(HJKKLBCX2_[12]_[A-Z]{8}~[A-Z]{8})/;
    die "$fileline $prefix\n" unless ($prefix);
    open (IN2, "<${fileline}") or die "Can't open $fileline\n";
    while ($line=<IN2>){
	#print "Line $line of $fileline\n";
	chomp ($line);
	next unless ($line);
	next if ($line=~/^Name/);
	($name, $length, $efflen, $TPM, $reads)=split("\t", $line);
	#die "$name $length $efflen $TPM $reads\n";
	#print "made it to split $name\n";
	if ($transhash{$name}){
		#print "Made it to the keeper loop of $name\n";
		foreach $nodekoname (keys %{$transhash{$name}}){
			#print "Made it ot the $nodekoname has\n";
			#look for entires with this node
			#print "Looking for $nodekoname\n";	
			$TPMindex="TPM";
			$K1index="K1";
			$P1index="P1";
			$G1index="G1";
			$infoindex="info";
			$numberindex="number";
			$hash{$nodekoname}{$prefix}{$TPMindex}+=$TPM;
			$hash{$nodekoname}{$K1index}=$transhash{$name}{$nodekoname}{$K1index};
                        $hash{$nodekoname}{$P1index}=$transhash{$name}{$nodekoname}{$P1index};
                        $hash{$nodekoname}{$G1index}=$transhash{$name}{$nodekoname}{$G1index};
                        $hash{$nodekoname}{$infoindex}=$transhash{$name}{$nodekoname}{$infoindex};
                        $hash{$nodekoname}{$numberindex}=$transhash{$name}{$nodekoname}{$numberindex};
			#print "Found $nodekoname $prefix $TPM\n";
			$prefixhash{$prefix}++;  
  		}
	}
    }
    close (IN2);
}

close (IN);
print "TPM";
foreach $name (sort keys %hash){
        foreach $prefix (sort keys %prefixhash){
                print "\t$prefix";
        }
	print "\n";
	last;
}

#Next I have to figure out a way to print out the entire matrix
foreach $name (sort keys %hash){
	print "$name";
	foreach $prefix (sort keys %prefixhash){
		if ($hash{$name}{$prefix}{'TPM'}){
			print "\t$hash{$name}{$prefix}{'TPM'}";
		} else {
			print "\t0";
		}
	}
	print "\t$hash{$name}{$K1index}\t$hash{$name}{$P1index}\t$hash{$name}{$G1index}\t$hash{$name}{$infoindex}\t$hash{$name}{$numberindex}\n";
}

