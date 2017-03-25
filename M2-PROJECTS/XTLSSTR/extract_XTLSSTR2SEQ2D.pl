#!/usr/bin/perl -w
#Copyright Jean-Christophe Gelly (Jan 20 2012)
#
# jean-christophe.gelly@univ-paris-diderot.fr
#
#This software is a computer program whose purpose is to 
# extract secondary structure assignment from XTLSSTR.
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

open(F,"$file") || die "Cannot open $file :$!\nYou need an output file from pross to use this program\n";
my $old_model=666;
my $check=0;
my %hash_check_pos;
WHILE:while(my $line=<F>)
{
#   next WHILE if (length $line < 77);

    if ($line =~/^isub/)
    {
        $check=1;
        next WHILE;
    }
    next WHILE if ($check ==0);
    next WHILE if ($line !~/^\s{0,}\d/);
    my $aa=substr($line,14,1);
    next WHILE if ($aa !~/[A-Z]{1}/);
    my $model=substr($line,0,3);
    $model=~s/\s//g;
    last WHILE if ($model > $old_model);


    my $pos=substr($line,17,5);
    $pos=~s/\s//g;
    if (not defined $hash_check_pos{$pos})
    {
        $hash_check_pos{$pos}=1;
    }
    else
    {
        next WHILE;
    }

#   print STDERR ">>>>>>>>$line\n";
    my $s2d=substr($line,26,1);
    push @tab_aa,"$aa";
    push @tab_s2d,"$s2d";
    $old_model=$model;
}

#my $name=`basename $file`;
#chomp $name;
#
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




