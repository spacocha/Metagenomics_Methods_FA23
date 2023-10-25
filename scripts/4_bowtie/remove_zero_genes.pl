#! /usr/bin/perl -w
#
#

	die "Usage: mat new_mat_output_filename removed_mat_output_filename\n" unless (@ARGV);
($mat, $newmat, $rmmat) = (@ARGV);
chomp ($mat, $newmat, $rmmat);

open (OUT1, ">$newmat") or die "Can't open $newmat\n";
open (OUT2, ">$rmmat") or die "Can't open $rmmat\n";

$first=1;
open (IN, "<${mat}") or die "Can't open $mat\n";
while ($line=<IN>){
    chomp ($line);
    next unless ($line);
    ($gene, @pieces)=split ("\t",  $line);
    if ($first){
	print OUT1 "$line\n";
	print OUT2 "$line\n";
	(@headers)=@pieces;
	#$i=0;
	#$j=@headers;
	#until ($i>=$j){
#		if ($headers[$i]=~/HJKKLBCX/){
#			print "$headers[$i]\n";
#		}
#		$i++;
#	}
	#die;
	$first=0;
    } else {
	#Sum up all of the coverage info and print to new_mat if present and remove_mat if 0
	($gene, @pieces)=split ("\t",  $line);
	$i=0;
	$j=@headers;
	$total=0;
	until ($i >=$j){
		if ($headers[$i]=~/HJKKLBCX/){
			$total+=$pieces[$i];
		}
		$i++;
	}
	if ($total){
		print OUT1 "$line\n";
	} else {
		print OUT2 "$line\n";
	}
    }
}
close (IN);
