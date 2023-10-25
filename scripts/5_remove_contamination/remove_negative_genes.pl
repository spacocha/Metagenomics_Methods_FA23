#! /usr/bin/perl -w

die "Usage: gene_table metadata column group1 group2 > new_gene_table\n" unless (@ARGV);
($table, $metadata, $col, $regex1, $regex2) = (@ARGV);
chomp ($table, $metadata, $col, $regex1, $regex2);

$newcol=$col-1;
open (IN, "<$metadata" ) or die "Can't open $table\n";
while ($line1 =<IN>){
    chomp ($line1);
    next unless ($line1);
    (@pieces)=split("\t", $line1);
    if ($pieces[$newcol]=~/$regex1/){
	    #die "Group1 $pieces[$newcol]\n";
	    $hash1{$pieces[0]}++;
    } elsif ($pieces[$newcol]=~/$regex2/) {
	    #die "Group2 $pieces[$newcol]\n";
	    $hash2{$pieces[0]}++;
    }
}
close (IN);

open (IN, "<$table" ) or die "Can't open $table\n";
while ($line1 =<IN>){
    chomp ($line1);
    next unless ($line1);
    $group1=0;
    $group2=0;
    (@pieces)=split("\t", $line1);
    if (@headers){
	$i=0;
	$j=@pieces;
	until ($i >=$j){
		if ($hash1{$headers[$i]}){
			#it's in the first group
			if ($group1){
				#make a new average
				$group1=($group1+$pieces[$i])/2;
			} else {
				#it's the first one
				$group1=$pieces[$i];
			}
		} elsif ($hash2{$headers[$i]}) {
			#its in the second group
			if ($group2){
				#make a new average
				$group2=($group2+$pieces[$i])/2;
			} else {
				$group2=$pieces[$i];
			}
		} else {
			#die "Missing $headers[$i]\n";
		}
		$i++;
	}
	if ($group1>=$group2){
		#die "$pieces[0] is larger or equal in group1 than group2 $group1 $group2\n";
		#this is removed
	} elsif ($group2>$group1) {
		#die "$pieces[0] is larger in group2 than group1\n";
		print "$line1\n";
	}
    } else {
	 (@headers)=@pieces;
	 print "$line1\n";
    }	 
} 
close (IN);

