#!/usr/bin/perl6

constant N = 729;

sub f(Int $n) {
  # Place your function here
  59 * $n + 666;
}

my @a = False xx N;

for ^N -> $i {
  @a[f($i) % N] = True;
}

for ^N -> $i {
  if !@a[$i] {
    say "Nothing maps to $i";
  }
}
