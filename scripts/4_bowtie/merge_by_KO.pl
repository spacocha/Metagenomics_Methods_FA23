#! /usr/bin/perl -w
#
#

	die "Usage: mat> Redirect\n" unless (@ARGV);
($mat) = (@ARGV);
chomp ($mat);

$first=1;
open (IN, "<${mat}") or die "Can't open $mat\n";
while ($line=<IN>){
    chomp ($line);
    next unless ($line);
    (@pieces)=split ("\t",  $line);
    ($gene)=shift(@pieces);
    ($KO)=pop(@pieces);
    (@KOpieces)=split(",",$KO);
    if ($first){
	(@headers)=@pieces;
	foreach $head (@headers){
		$headershash{$head}++;
	}
	$first=0;
    } else {
	$i=0;
    	$j=@pieces;	
	#Add the coverage for each KO that it was assigned (doubling)	
	foreach $KOpiece (@KOpieces){
		$i=0;
		$j=@pieces;
		until ($i>=$j){
			$hash{$KOpiece}{$headers[$i]}+=$pieces[$i];
			$i++;	
    		}
	}
   }
}
close (IN);

print "KO";
foreach $head (sort keys %headershash){
	print "\t$head";
}
print "\n";

foreach $KO (sort keys %hash){
	print "$KO";
	foreach $value (sort keys %headershash){
		print "\t$hash{$KO}{$value}";
	}
	print "\n";
}

