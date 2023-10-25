#! /usr/bin/perl -w

die "umt: EOF matrix (38 x 38)
lnmetabolicgenes: export from process_TPM_chesapeake.m (84 x 38)
output_prefix: The beginning part of the file names
ko: ko_numbers
Usage: umt lnmetabolicgenes ko output_prefix\n" unless (@ARGV);
($umt, $mat, $ko, $prefix) = (@ARGV);
chomp ($umt);
chomp ($mat);
chomp ($ko);
chomp ($prefix);

$lineno=1;
open (IN, "<$umt" ) or die "Can't open $umt\n";
while ($line =<IN>){
    chomp ($line);
    next unless ($line);
    (@pieces)=split(",", $line);
    #die "$pieces[0]\n";
    $i=0;
    $j=@pieces;
    until ($i>=$j){
	#Only use the first 4 EOFs
	if ($i<=3){
		#EOF1 is $i = 0, so change index to match EOF num
		$ei=$i+1;
		#$i is the library, which corresponds to the number in indenv
		#only keep the first four EOFs
		#lineno corresponds to libraries
		#Those are actually related to number 1...47 by indenv
		$umthash{$ei}{$lineno}=$pieces[$i];
		#die "ei $ei lineno $lineno pieces $pieces[$i]\n" if ($lineno == 2 && $ei == 2); 
	}
	$i++;
    }
    $lineno++;
} 
close (IN);

$lineno=1;
open (IN, "<$ko" ) or die "Can't open $ko\n";
while ($line =<IN>){
        chomp ($line);
        next unless ($line);
        (@pieces)=split (",", $line);
	$kotrans{$lineno}=$pieces[0];
	#die "$lineno $pieces[0]\n";
	$lineno++;
}

$lineno=1;
open (IN, "<$mat" ) or die "Can't open $mat\n";
while ($line =<IN>){
	chomp ($line);
	next unless ($line);
	(@pieces)=split (",", $line);
	#save data in hash if in the indenv array
	#these are actual column no., so change to index
	$i=0;
	$j=@pieces;
	until ($i>=$j){
		#library no is $i+1, since lineno started with 1 for the umt	
		$si=$i+1;
		$allheaders{$si}++;
		$KOhash{$kotrans{$lineno}}{$si}=$pieces[$i];
		#die "lineno $lineno KO $kotrans{$lineno} SI $si pieces $pieces[$i]\n";
		$i++;
	}
	$lineno++;
}
close(IN);

open (OUTX, ">${prefix}.X.txt" ) or die "Can't open ${prefix}.X.txt\n";
open (OUTY, ">${prefix}.Y.txt" ) or die "Can't open ${prefix}.Y.txt\n";
print OUTX "KEGG_ID";
print OUTY "KEGG_ID";
foreach $header (sort {$a <=> $b} keys %allheaders){
	print OUTX "\t$header";
	print OUTY "\t$header";
}
print OUTX "\n";
print OUTY "\n";

#make a matrix of values to compare
foreach $KO (sort {$a <=> $b} keys %KOhash){
	foreach $umt (sort {$a <=> $b} keys %umthash){
		#don't repeat
		next if ($done{$KO}{$umt});
		print OUTX "$KO";
		print OUTY "$umt";
		$done{$KO}{$umt}++;
		foreach $header (sort {$a <=> $b} keys %allheaders){
				print OUTX "\t$KOhash{$KO}{$header}";
				print OUTY "\t$umthash{$umt}{$header}";
		}
		print OUTX "\n";
		print OUTY "\n";
	}
}


