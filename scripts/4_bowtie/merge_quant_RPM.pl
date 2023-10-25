#! /usr/bin/perl -w
#
#


	die "Usage: list> Redirect\n" unless (@ARGV);
($list) = (@ARGV);
chomp ($list);

#Use this if I need to limit to on KOs
#open (IN, "<${KOfile}") or die "Can't open $KOfile\n";
#while ($line=<IN>){
#	chomp ($line);
#	next unless ($line);
#	($name, $KO, $L1, $L2, $L3)=split ("\t", $line);
#	$transhash{$name}{"KO"}=$KO;
#	$transhash{$name}{"L1"}=$L1;
#	$transhash{$name}{"L2"}=$L2;
#	$transhash{$name}{"L3"}=$L3;
#}
#close (IN);


open (IN, "<${list}") or die "Can't open $list\n";
while ($file=<IN>){
    chomp ($file);
    next unless ($file);
    ($prefix)=$file=~/(HJKKLBCX2_[12]_[A-Z]{8}~[A-Z]{8})/;
    die "MISSING PREFIX: FILE $file PREFIX $prefix\n" unless ($prefix);
    $first=1;
    open (IN2, "<${file}") or die "Can't open $file\n";
    while ($line=<IN2>){
	chomp ($line);
	next unless ($line);
	next if ($line=~/^Name/);
	($gloc, $tc, $glen, $ac, $CPM)=split("\t", $line);
	#die "$name $length $efflen $TPM $reads\n";
	if ($first){
		$first=0;
	} else {
		if ($gloc && $prefix){
			$hash{$gloc}{$prefix}=$CPM;
			$allprefix{$prefix}++;
    		} else {
			die "Missing $gloc or $prefix\n";
		}
    	}
    }
    close (IN2);
}

close (IN);
print "Gene_locus";
foreach $prefix (sort keys %allprefix){
                print "\t$prefix";
}
print "\n";

#Next I have to figure out a way to print out the entire matrix
foreach $name (sort keys %hash){
	print "$name";
	foreach $prefix (sort keys %allprefix){
		if ($hash{$name}{$prefix}){
			print "\t$hash{$name}{$prefix}";
		} else {
			print "\t0";
		}
	}
	print "\n";
}

