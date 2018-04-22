#!/usr/bin/perl6

use v6;

constant %DNUMBERS = %(
  'm' => 0,
  'n' => 27,
  'ŋ' => 54,
  'Ŋ' => 67,
  'p' => 162,
  'P' => 175,
  'T' => 202,
  'c' => 190,
  'C' => 203,
  'ċ' => 191,
  'Ċ' => 204,
  'ṭ' => 192,
  'k' => 216,
  'q' => 217,
  'F' => 337,
  'þ' => 350,
  'Þ' => 363,
  's' => 351,
  'S' => 364,
  'ṡ' => 352,
  'h' => 378,
  'Ḥ' => 392,
  'w' => 380,
  'r' => 405,
  'a' => 486,
  'A' => 499,
  'u' => 513,
  'U' => 526,
);

constant %PBYDN = %(%DNUMBERS.antipairs);

constant @CONSONANTS = %DNUMBERS.values.grep(* < 486);

sub rootl(Int $p, Int $q) {
  (($q - $p) % 729) <= 364;
}

sub rootcmp(Int $p, Int $q) {
  my $r = (($q - $p) % 729);
  return
    $r == 0 ?? Same !!
    $r <= 364 ?? Less !! More;
}

sub getABC(@r) {
  my ($a, $b, $c) = @r;
  my $v = ($a + $b + $c) % 729;
  while $v gcd 729 != 1 { ++$v; }
  my $A = $v * $a + 128;
  my $B = $v * $b + 128;
  my $C = $v * $c + 128;
  return ($A, $B, $C);
}

sub checkRoot(@r) {
  my ($A, $B, $C) = getABC(@r);
  return rootl($A, $B) && rootl($B, $C);
}

sub sortRoot(@r) {
  my @R = getABC(@r);
  return (@r Z @R).sort({
    rootcmp($^a[1], $^b[1])
  }).map(*[0]);
}

sub printRoot() {
  my @r;
  for ^3 {
    @r.push: @CONSONANTS.roll;
  }
  @r = sortRoot(@r);
  my $s = %PBYDN{@r}.join;
  my @g = ((^27).roll - 13) xx 3;
  say "$s ({@g.join(', ')})";
}

sub MAIN(Int $n = 1) {
  for ^$n {
    printRoot();
  }
}
