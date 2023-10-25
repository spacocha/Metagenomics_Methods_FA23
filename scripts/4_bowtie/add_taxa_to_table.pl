#! /usr/bin/perl -w
#
#

	die "Usage: KOdb mat> Redirect\n" unless (@ARGV);
($list, $mat) = (@ARGV);
chomp ($list, $mat);

open (IN1, "<$list") or die "Can't open $list\n";
while ($line1=<IN1>){
	chomp($line1);
	next unless ($line1);
	open (IN, "<${line1}") or die "Can't open $line1\n";
		while ($line=<IN>){
			chomp ($line);
			next unless ($line);
			($user, @rest)=split ("\t", $line);
        		($gene)=$user=~/^user:(.+)$/;
        		#die "$user $gene\n";
			$allhash{$gene}=$line;
	}
}
close (IN);

$first=1;
open (IN, "<${mat}") or die "Can't open $mat\n";
while ($line=<IN>){
    chomp ($line);
    next unless ($line);
     if ($first){
	print "$line\tKO\tDomain\tClass\tGenus\tKEGGID\tConfidence\n";
	$first=();
    } else {
   	 ($gene)=split ("\t",  $line);
   	 #die "$gene\n";
  	  print "$line";
  	  if ($allhash{$gene}){
		#die "Found $gene $line\n";
		($user, @rest)=split ("\t", $allhash{$gene});
		foreach $piece (@rest){
			print "\t$piece";
		}
		print "\n";
		#die;
   	} else {
		print "\tNA\tNA\tNA\tNA\tNA\tNA\n";
   	}
    }

}
close (IN);
