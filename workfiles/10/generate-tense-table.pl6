my \s = «a u ""»;
my @r = (s X s X s X s).map({"{$_[0]}1{$_[1]}2{$_[2]}3{$_[3]}"}).grep(none <1a23u 12a3a 1u2u3 u12a3 a1a23 u1u23>).pick(*);
my @tenses = «Present Past "Imminent future"»;
my @persons = <0 1 2 3p 3o>;
my $i = 0;
for @r.rotor(5).rotor(5) -> @bt {
  my $j = 0;
  NEXT say '\hline';
  for @bt -> @bp {
    FIRST { print '\multirow{5}{*}{' ~ @tenses[$i] ~ '} '; }
    print '& ';
    print @persons[$j];
    print ' & ';
    say @bp.join(" & ") ~ ' \\\\';
    ++$j;
  }
  ++$i;
}