#! /usr/bin/perl -w
#
#

	die "Usage: mat> Redirect\n" unless (@ARGV);
($mat) = (@ARGV);
chomp ($mat);

open (IN, "<${mat}") or die "Can't open $mat\n";
while ($line=<IN>){
    chomp ($line);
    next unless ($line);
    ($gene, @pieces)=split ("\t",  $line);
    #die "$pieces[-1]\n";
        ($Conf)=pop(@pieces);
        ($KEGGTax)=pop(@pieces);
        ($genus)=pop(@pieces);
        ($class)=pop(@pieces);
        ($domain)=pop(@pieces);
        ($KO)=pop(@pieces);
	#die "$KO\n"; 
    if (@headers){
	$i=0;
	$j=@pieces;
	until ($i>=$j){
		$hash{$KO}{$headers[$i]}+=$pieces[$i];
		$headershash{$headers[$i]}++;
		$i++;
	}
    } else {	
	#Add the coverage for each KO that it was assigned (doubling)	
	(@headers)=@pieces;
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
		if ($hash{$KO}{$value}){
			print "\t$hash{$KO}{$value}";
		} else {
			print "\t0";
		}
	}
	print "\n";
}

