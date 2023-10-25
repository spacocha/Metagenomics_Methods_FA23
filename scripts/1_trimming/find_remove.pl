#! /usr/bin/perl -w

die "Use this to remove something from a file.
Usage: file str_to_remove > redirect" unless (@ARGV);
($file, $find) = (@ARGV);
chomp ($file);
chomp ($find);


open (IN, "<$file" ) or die "Can't open $file\n";
while ($line =<IN>){
    chomp ($line);
    $line =~ s/${find}//g;
    print "$line\n";
}
