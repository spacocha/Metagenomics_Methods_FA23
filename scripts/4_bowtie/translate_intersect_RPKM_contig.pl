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
		#These are fragments because I used count_distinct
		#bedtools makes two mapps to the same gene one fragment
                ($contig, $fragments)=split ("\t", $line);
		$rhash{$contig}=$fragments;
}
close (IN);

print "Gene_locus\tTotal_Reads\tGene_Length\tFragments Per Kilobase(FPK)\tFragments Per Kilobase Million (FPKM)\n";
open (IN, "<${gnfile}") or die "Can't open $gnfile\n";
while ($line=<IN>){
                chomp ($line);
                next unless ($line);
                ($contig, $start, $stop, $gene)=split ("\t", $line);
		$length=$stop-$start + 1;
		if ($rhash{$gene}){
			$FPK=1000*$rhash{$gene}/$length;
			#normalized by the total number of reads in the library, then mult by 10^6
			$FPKM=1000000*${FPK}/${totalreads};
			print "$gene\t$rhash{$gene}\t$length\t$FPK\t$FPKM\n";
		} else {
			print "$gene\t0\t$length\t0\t0\n";
		}
}
close (IN);
