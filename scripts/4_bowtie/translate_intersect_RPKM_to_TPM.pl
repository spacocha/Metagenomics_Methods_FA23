#! /usr/bin/perl -w
#
#

	die "Use this to create gene coverage distribution from gene bowtie
Usage: RPKM_output > Redirect\n" unless (@ARGV);
	($rpkmfile) = (@ARGV);

	die "Please follow command line args\n" unless ($rpkmfile);
chomp ($rpkmfile);

$first=1;
open (IN, "<$rpkmfile") or die "Can't open $rpkmfile\n";
while ($line=<IN>){
	chomp ($line);
	next unless ($line);
	(@pieces)=split ("\t", $line);
	if ($first){
		$first=0;
	} else {
		($RPKM)=pop(@pieces);
		$sumRPKM+=$RPKM;
	}
}
close (IN);

$first=1;
open (IN, "<${rpkmfile}") or die "Can't open $rpkmfile\n";
while ($line=<IN>){	
	chomp ($line);
	next unless ($line);
	if ($first){
		print "${line}\tTPM\n";
		$first=0;
	} else {
		(@pieces)=split ("\t", $line);
		($RPKM)=pop(@pieces);
		$TPM=1000000*$RPKM/$sumRPKM;
		print "$line\t$TPM\n";
	}
}

