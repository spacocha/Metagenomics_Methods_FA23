#! /usr/bin/perl -w
#
#

	die "Use this to create bed file from prodigal gene output
Usage: prodigal_gene_file > Redirect\n" unless (@ARGV);
	($pfile) = (@ARGV);

	die "Please follow command line args\n" unless ($pfile);
chomp ($pfile);

$/=">";
open (IN, "<${pfile}") or die "Can't open $pfile\n";
while ($line=<IN>){	
                chomp ($line);
                next unless ($line);
		($header, @pieces)=split("\n", $line);
		(@hps)=split (" ", $header);
		($gene)=$hps[0];
		($contig) = $hps[0]=~/^(.+)_[0-9]+$/;
		#die "Contig $contig Gene $gene Start $hps[2] stop $hps[4]\n";
		print "$contig\t$hps[2]\t$hps[4]\t$gene\n";
}
close (IN);

