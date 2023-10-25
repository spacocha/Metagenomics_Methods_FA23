#! /usr/bin/perl -w
#
#

	die "Usage: KOdb RPM_table> Redirect\n" unless (@ARGV);
($KOdb, $table) = (@ARGV);
chomp ($KOdb, $table);
$verbose=0;

open (IN, "<${KOdb}") or die "Can't open $KOdb\n";
while ($line=<IN>){
	chomp ($line);
	next unless ($line);
	if ($line=~/^A/){
		(@pieces)=split (" +", $line);
		($blank)=shift(@pieces);
		#($A)=shift(@pieces);
		($Aname)=join (" ", @pieces);
		$A=$Aname;
		#print "ANAME: $Aname\n";
	} elsif ($line=~/^B/){
                (@pieces)=split (" +", $line);
                ($blank)=shift(@pieces);
                ($B)=shift(@pieces);
                ($Bname)=join (" ", @pieces);
                #die "BIDs: $A;$B  NAME: $Aname;$Bname\n";
	} elsif ($line=~/^C/){
		(@pieces)=split (" +", $line);
                ($blank)=shift(@pieces);
                ($C)=shift(@pieces);
                ($Cname)=join (" ", @pieces);
                #die "CIDs: $A;$B;$C  NAME: $Aname;$Bname;$Cname\n";
	} elsif ($line=~/^D/){
		(@pieces)=split (" +", $line);
		($blank)=shift(@pieces);
		($KOid)=shift(@pieces);
		($name)=join (" ", @pieces);
		#die "DID: $A;$B;$C;$KOid\tNAME: $Aname;$Bname;$Cname;$name\n";
		$hash{$KOid}{"A"}=$Aname;
		$hash{$KOid}{"B"}=$Bname;
		$hash{$KOid}{"C"}=$Cname;
		$hash{$KOid}{"D"}=$name;
	}
}
close (IN);

print "Processing list $list\n" if ($verbose);
$first=1;
open (IN, "<${table}") or die "Can't open $table\n";
while ($line=<IN>){
    chomp ($line);
    next unless ($line);
    (@pieces)=split ("\t", $line);
    if ($first){
	(@headers)=@pieces;
	$first=0;
    } else {
 	#die "$pieces[48]\n";
    	if ($pieces[48]=~/^K/){
		if ($hash{$pieces[48]}{'C'}){
			#die "$pieces[48]\t$hash{$pieces[48]}{'A'}\t$hash{$pieces[48]}{'B'}\t$hash{$pieces[48]}{'C'}\t$hash{$pieces[48]}{'D'}\n";
			#Do the average across all samples
			$i=1;
			$j=47;
			$summed=0;
			$nosamples=0;
			until ($i >=$j){
				$summed+=$pieces[$i];
				$nosamples++;
				$i++;
			}
			$average=$summed/$nosamples;
			$overallave{$hash{$pieces[48]}{'C'}}+=$average;
			die "$pieces[48] $hash{$pieces[48]}{'C'}\n" if ($pieces[48] eq "K10944");
		} else {
			#die "doesn't exist $pieces[48]\n";
		}
    	}
    }
}
close (IN);

foreach $levelA (sort keys %overallave){
	print "$levelA\t$overallave{$levelA}\n";
}

