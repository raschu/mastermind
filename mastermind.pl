use strict;
use warnings;
use Term::ANSIColor ':constants';
use List::Util qw(shuffle);
use Term::ReadKey;

ReadMode('noecho');

my $z      = '(#) ';
my $code   = randomcode();
my $cnt    = 0;

main();

sub main {
    while(1) {
        $cnt++;
        chomp (my $input = <>);
        next if checkinput($input, $cnt) == 0;
        
        my @z = split(//, $code);
        my @i = split(//, $input);
        
        for (@i) {
            my $t = $z;
            $t =~ s/#/$_/;
            print WHITE,   $t, if $_ == 1;
            print YELLOW,  $t, if $_ == 2;
            print RED,     $t, if $_ == 3;
            print GREEN,   $t, if $_ == 4;
            print BLUE,    $t, if $_ == 5;
            print MAGENTA, $t, if $_ == 6;
        }
        
        print RESET;
        print "| ";
        
        if (evalanswer(@i, @z) == 1) {
            print "You solved it! $code is the code.\n";
            ReadMode('restore');
            last();
        }
    }
}

sub checkinput {
    my $i   = shift;
    my $cnt = shift;
    my $c   = 1;
    my %o   = ();
    
    if ($i eq 's') {
        print "You want to exit the game. The code was $code\n";
        ReadMode('restore');
        exit();
    }
    
    $c = 0 if length($i) != 4;
    
    for (split//, $i) {
        $c = 0 unless $_ =~ m/[1-6]/;
        $c = 0 if exists($o{$_});
        $o{$_} = 1;
    }
    
    if ($c == 0) {
        warn "[$cnt]\tcheck your input: $i\n";
        return 0;
    } else {
        print "[$cnt]\t$i | ";
    }
    
    return 1;
}

sub evalanswer {
    my @d = @_;
    my $l = @d / 2;
    my @i;
    my @z;
    my $white = 0;
    my $black = 0;
    my $zcnt  = 0;
    my %white = ();
    
    push (@i, shift @d) for 1..$l;
    push (@z, shift @d) for 1..$l;
   
    for my $z (@z) {
        $zcnt++;
        my $icnt = 0;
        for my $i (@i) {
            $icnt++;
            if ($icnt == $zcnt and $i == $z) {
                $black++;
                $white{$z} -= 1000;
            } elsif ($i == $z) {
                $white{$z}++;
            } 
        }
    }
    
    for my $i (keys(%white)) {
        $white++ if $white{$i} > 0;
    }
    
    print BLUE  "x" for 1..$black;
    print WHITE "x" for 1..$white;
    print RESET "\n";
    
    return 1 if $black == 4;
    return 0;
}

sub randomcode {
    my $r;
    
    $r .= $_ for shuffle (qw (1 2 3 4 5 6));
    $r = substr($r, 0, 4);
    
    return $r;
}
