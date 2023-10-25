#! /usr/bin/perl -w
#
#

	die "Usage: KO.txt taxa_file> Redirect output\n" unless (@ARGV);
	
	chomp (@ARGV);
	($KOfile, $taxafile) = (@ARGV);
        open (IN, "<$KOfile") or die "Can't open $KOfile\n";
        while ($line1 = <IN>){
                chomp ($line1);
                next unless ($line1);
		($node, $KO)=split ("\t", $line1);
		#die "$node $KO\n";
		if ($KO){
			#die "This does exists $node $KO\n";
			$hash{$node}{$KO}++;
		}	
	}
	close (IN);

	open (IN, "<$taxafile") or die "Can't open $taxafile\n";
	while ($line1 = <IN>){	
		chomp ($line1);
		next unless ($line1);
		($usernode, $KO, @taxa)= split ("\t", $line1);
		($node)=$usernode=~/^user:(.+)/;
		#die "$node\n";
		if ($hash{$node}{$KO}){
			#only print things if the KO exists in the KO file
			print "$line1\n";
		}
	}
	
	close (IN);

	
