#! /usr/bin/perl -w
#
#

	die "Use this to create gene coverage distribution from gene bowtie
Usage: total.reads intersect_output gene_file > Redirect\n" unless (@ARGV);
	($trfile, $intersectfile, $gnfile) = (@ARGV);

	die "Please follow command line args\n" unless ($gnfile);
chomp ($intersectfile);
chomp ($trfile);
chomp ($gnfile);

open (IN, "<$trfile") or die "Can't open $trfile\n";
while ($line=<IN>){
	chomp ($line);
	next unless ($line);
	$totalreads=$line;
}
close (IN);

open (IN, "<${intersectfile}") or die "Can't open $intersectfile\n";
while ($line=<IN>){	
                chomp ($line);
                next unless ($line);
                ($contig, $coverage)=split ("\t", $line);
		$chash{$contig}=$coverage;
}
close (IN);

print "Gene_locus\tTotal_Coverage\tGene_Length\tAve_Coverage\tCPM\n";
$/=">";
open (IN, "<${gnfile}") or die "Can't open $gnfile\n";
while ($line=<IN>){
                chomp ($line);
                next unless ($line);
                ($header, $coverage)=split ("\n", $line);
                (@pieces)=split (" ", $header);
		#die "$pieces[4] $pieces[2]\n";
		($gene)=$pieces[0];
		$length=$pieces[4]-$pieces[2] + 1;
		if ($chash{$gene}){
			$avecoverage=$chash{$gene}/$length;
			#This isn't normalized by the total number of reads in the library, then mult by 10^6
			$RPM=1000000*${avecoverage}/${totalreads};
			print "$gene\t$chash{$gene}\t$length\t$avecoverage\t$RPM\n";
		} else {
			print "$gene\t0\t$length\t0\t0\n";
		}
}
close (IN);
