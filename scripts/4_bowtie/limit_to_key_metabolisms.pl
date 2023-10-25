#! /usr/bin/perl -w
#
#

	die "Usage: KOdb list> Redirect\n" unless (@ARGV);
($KOdb, $list) = (@ARGV);
chomp ($KOdb, $list);
$verbose=0;

open (IN, "<${KOdb}") or die "Can't open $KOdb\n";
while ($line=<IN>){
	chomp ($line);
	next unless ($line);
	if ($line=~/^A/){
		(@pieces)=split (" +", $line);
		($blank)=shift(@pieces);
		($A)=shift(@pieces);
		($Aname)=join (" ", @pieces);
		#die "AID: $A NAME: $Aname\n";
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
open (IN, "<${list}") or die "Can't open $list\n";
while ($line=<IN>){
    chomp ($line);
    next unless ($line);
    (@pieces)=split ("\t", $line);
    print "$line\t$hash{$pieces[1]}{'A'}\t$hash{$pieces[1]}{'B'}\t$hash{$pieces[1]}{'C'}\t$hash{$pieces[1]}{'D'}\n" if ($hash{$pieces[1]}{'A'} && $hash{$pieces[1]}{'B'} && $hash{$pieces[1]}{'C'} && $hash{$pieces[1]}{'D'});
}
close (IN);
