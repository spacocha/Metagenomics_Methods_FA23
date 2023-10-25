#! /usr/bin/perl -w
#
#

	die "Use this to split a fasta file for parallel processing
Output will be in the form of filebase.no.fa where filebase is the part before \.*f*a*s*t*a*
Usage: fasta_file total_files_needed > Redirect\n" unless (@ARGV);
	($file2, $number) = (@ARGV);

	die "Please follow command line args\n" unless ($number);
chomp ($file2);
chomp ($number);

$/ = ">";
$total=0;
$i=1;
if ($file2=~/^.+\.f*a*s*t*a*$/){
	($base, $end)=$file2=~/^(.+?)\.(f*a*s*t*a*)$/;
	#die "find $base $end\n";
} else {
	$base="assembledContigs.all_proteins";
	$end="faa";
	#die "Assigned $base $end\n";
}

open (IN, "<$file2") or die "Can't open $file2\n";
open (OUT, ">${base}.${i}.${end}") or die "Can't open ${base}.${i}.${end}\n";
	while ($line=<IN>){
		chomp ($line);
		next unless ($line);
		$total++;
	}
close (IN);
$needed=$total/$number;
#add one to the number needed just to make sure you don't get a single read at the end
$needed++;
$printed=0;
$first=1;
#die "$total $number $needed\n";
open (IN, "<$file2") or die "Can't open $file2\n";
	while ($line=<IN>){
		chomp ($line);
		next unless ($line);	
		($name, @seqs)=split ("\n", $line);
		next unless ($name);
		$sequence = join ("", @seqs);
		die "MISSING SEQUENCE: $line $name $sequence\n"  unless ($sequence);
		print OUT ">$name\n$sequence\n";
		$printed++;
		if ($printed>$needed){
			$i++;
			$printed=0;
			close (OUT);
			open (OUT, ">${base}.${i}.${end}") or die "Can't open ${base}.${i}.${end}\n";
		}		
       	}
close (IN);


    
