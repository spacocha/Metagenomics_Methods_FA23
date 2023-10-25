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
			($gene, $KO)=split ("\t", $line);
			if ($KOhash{$gene}){
				#it already has a KO, so I need to know
				#die "Existing $gene new $KO old $KOhash{$gene}\n";
				#check to see if there are any redundant calls
				(@pieces)=split(",", $KOhash{$gene});
				#consider the new KO as well
				undef %newhash;
				push(@pieces, $KO);
				foreach $piece (@pieces){
					$newhash{$piece}++;
					#print "PIECE $piece\n" if ($gene eq "NODE_10005065_length_248_cov_0.984456_1");
				}
				$new=();
				#undef %newhash;
				foreach $key (keys %newhash){	
					#print "KEY $key\n" if ($gene eq "NODE_10005065_length_248_cov_0.984456_1");
					if ($new){
						#existing KOs
						$new="${new},${key}";
					} else {
						$new=$key;
					}
				}
					
				#print "FINAL $new\n" if ($gene eq "NODE_10005065_length_248_cov_0.984456_1");
				$KOhash{$gene}=$new;
			} elsif ($KO){
				$KOhash{$gene}=$KO;
			}
			#die if ($gene eq "NODE_10005065_length_248_cov_0.984456_1");
	}
}
close (IN);

open (IN, "<${mat}") or die "Can't open $mat\n";
while ($line=<IN>){
    chomp ($line);
    next unless ($line);
    ($gene)=split ("\t",  $line);
    print "$line";
    if ($KOhash{$gene}){
	print "\t$KOhash{$gene}\n";
    } else {
	print "\tNA\n";
    }
}
close (IN);
