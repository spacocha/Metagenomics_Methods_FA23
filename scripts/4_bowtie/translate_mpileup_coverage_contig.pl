#! /usr/bin/perl -w
#
#

	die "Use this to create gene coverage distribution from gene bowtie
Usage: total.reads prodigal_fasta gene_mpileup > Redirect\n" unless (@ARGV);
	($trfile, $fastafile, $mpileupfile) = (@ARGV);

	die "Please follow command line args\n" unless ($mpileupfile);
chomp ($fastafile);
chomp ($mpileupfile);
chomp ($trfile);

open (IN, "<$trfile") or die "Can't open $trfile\n";
while ($line=<IN>){
	chomp ($line);
	next unless ($line);
	$totalreads=$line;
}
close (IN);
		
$/ = ">";
$first="first";
$second="second";
$orient="orient";
open (IN, "<$fastafile") or die "Can't open $fastafile\n";
	while ($line=<IN>){
		chomp ($line);
		next unless ($line);
		($header, @sequences)=split ("\n", $line);
		(@pieces)=split (" ", $header);
		($contig)=$pieces[0]=~/^(.+)_[0-9]+$/;
		#die "$pieces[0] $pieces[2] $pieces[4]\n";
		$length = $pieces[4] - $pieces[2] + 1;
		$lhash{$pieces[0]}=$length;
		#make a hash that provides a map of where genes are found on the genome
		$i=$pieces[2];
		until ($i >=$pieces[4]){
			$phash{$contig}{$i}=$pieces[0];
			print "Marked $contig $i $pieces[0]\n" if ($pieces[0] eq "NODE_1_length_1007056_cov_11.385102_110");
			$i++;
		}
	}
close (IN);

$/ = "\n";
open (IN, "<$mpileupfile") or die "Can't open $mpileupfile\n";
        while ($line=<IN>){
                chomp ($line);
                next unless ($line);
                ($gene, $pos, $base, $coverage, $read, $qual)=split ("\t", $line);
		#figure out which gene is in this area, if any
		if ($phash{$gene}{$pos}){
			#This position is associated with a gene
			#add up all of the coverage data for each gene (this is gene bowtie, so each gene name is unique)
			#die "Made it $pos $phash{$pos}\n";
			$chash{$phash{$gene}{$pos}}+=$coverage;
			print "Coverage counted $gene $pos $coverage $phash{$gene}{$pos}\n" if ($phash{$gene}{$pos} eq "NODE_1_length_1007056_cov_11.385102_110");
		} #otherwise, it's useless for this analysis
    }
close (IN);

print "Gene_locus\tTotal_Coverage\tGene_Length\tAve_Coverage\tRPM\n";
foreach $gene (sort keys %lhash){
	if ($chash{$gene}){
		#it was observed in the readmap, so calculate coverage info
		#formula: total coverage normalized by length or average coverage per base
		$avecoverage=$chash{$gene}/$lhash{$gene};
		#This isn't normalized by the total number of reads in the library, then mult by 10^6
		$RPM=1000000*${avecoverage}/${totalreads};
		print "$gene\t$chash{$gene}\t$lhash{$gene}\t$avecoverage\t$RPM\n";
	} else {
		print "$gene\t0\t$lhash{$gene}\t0\t0\n";
	}
}

