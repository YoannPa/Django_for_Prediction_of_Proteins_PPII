#!/usr/bin/perl -w
#Copyright Jean-Christophe Gelly (Jan 20 2012)
#
# jean-christophe.gelly@univ-paris-diderot.fr
#
#This software is a computer program whose purpose is to 
# extract secondary structure assignment from segno.
#
#This software is governed by the CeCILL-B license under French law and
#abiding by the rules of distribution of free software.  You can  use, 
#modify and/ or redistribute the software under the terms of the CeCILL-B
#license as circulated by CEA, CNRS and INRIA at the following URL
#"http://www.cecill.info". 
#
#As a counterpart to the access to the source code and  rights to copy,
#modify and redistribute granted by the license, users are provided only
#with a limited warranty  and the software's author,  the holder of the
#economic rights,  and the successive licensors  have only  limited
#liability. 
#
#In this respect, the user's attention is drawn to the risks associated
#with loading,  using,  modifying and/or developing or reproducing the
#software by the user in light of its specific status of free software,
#that may mean  that it is complicated to manipulate,  and  that  also
#therefore means  that it is reserved for developers  and  experienced
#professionals having in-depth computer knowledge. Users are therefore
#encouraged to load and test the software's suitability as regards their
#requirements in conditions enabling the security of their systems and/or 
#data to be ensured and,  more generally, to use and operate it in the 
#same conditions as regards security. 
#
#The fact that you are presently reading this means that you have had
#knowledge of the CeCILL-B license and that you accept its terms.



use strict;

my $file=shift;

my @tab_aa;
my @tab_s2d;

open(F,"$file") || die "Cannot open file $file :$!\nYou need an output file from segno to use this program\n";

WHILE:while(my $line=<F>)
{
    my $aa=substr($line,7,3);
#        print STDERR ">>>>>>>>$line\n";
    my $s2d=substr($line,14,1);
    $s2d=~s/O/-/g;
    my $aa1=ThreeToOne($aa);
        push @tab_aa,"$aa1";
    push @tab_s2d,"$s2d";
}

#my $name=`basename $file`;
#chomp $name;
#print ">$name\n";
#print join('',@tab_aa)  . "\n";
#print join('',@tab_s2d) . "\n";
#
my $name=`basename $file`;
chomp $name;
#$name=~s/\..*//g;
my ($pdb,$method);
if ($name =~/^(.*)\.(.*)$/)
{
    $pdb=$1;
    $method=$2;
}
$pdb=uc($pdb);
print ">$pdb SEQ\n";
print join('',@tab_aa)  . "\n";
print ">$pdb $method\n";
print join('',@tab_s2d) . "\n";


sub ThreeToOne
{

    my $Code=shift;
    if (length ($Code) == 3)
    {
        if    ($Code eq 'ALA') {$Code = 'A'} # Alanine
        elsif ($Code eq 'ASX') {$Code = 'B'} # Aspartic acid or Asparagine
        elsif ($Code eq 'CYS') {$Code = 'C'} # Cysteine
        elsif ($Code eq 'ASP') {$Code = 'D'} # Aspartic acid
        elsif ($Code eq 'GLU') {$Code = 'E'} # Glutamic acid
        elsif ($Code eq 'PHE') {$Code = 'F'} # Phenylalanine
        elsif ($Code eq 'GLY') {$Code = 'G'} # Glycine
        elsif ($Code eq 'HIS') {$Code = 'H'} # Histidine
        elsif ($Code eq 'ILE') {$Code = 'I'} # Isoleucine
        elsif ($Code eq 'LYS') {$Code = 'K'} # Lysine
        elsif ($Code eq 'LEU') {$Code = 'L'} # Leucine
        elsif ($Code eq 'MET') {$Code = 'M'} # Methionine
        elsif ($Code eq 'ASN') {$Code = 'N'} # Asparagine
        elsif ($Code eq 'PRO') {$Code = 'P'} # Proline
        elsif ($Code eq 'GLN') {$Code = 'Q'} # Glutamine
        elsif ($Code eq 'ARG') {$Code = 'R'} # Arginine
        elsif ($Code eq 'SER') {$Code = 'S'} # Serine
        elsif ($Code eq 'THR') {$Code = 'T'} # Threonine
        elsif ($Code eq 'SEC') {$Code = 'U'} # Selenocysteine
        elsif ($Code eq 'VAL') {$Code = 'V'} # Valine
        elsif ($Code eq 'TRP') {$Code = 'W'} # Tryptophan
        elsif ($Code eq 'UNK') {$Code = 'X'} # Unknown amino acid
        elsif ($Code eq 'TYR') {$Code = 'Y'} # Tyrosine
        elsif ($Code eq 'GLX') {$Code = 'Z'} # Glutamic acid or Glutamine
        else {print STDERR "Warning in $0 amino acid code is non standard ($Code) !\n"; $Code="X";}

    }
    else
    {
        print STDERR "Warning in $0 amino acid is no 3 long !\n";$Code="X";
    }
    return ($Code);
}
