# Count the number of days between 1/0/0 and D/M/Y, inclusive.

# CONSTANTS

constant \MONTHS_PER_YEAR_CYCLE = 7215;
constant \YEARS_PER_YEAR_CYCLE = 736;
constant \AVG_MONTHS_PER_YEAR = MONTHS_PER_YEAR_CYCLE / YEARS_PER_YEAR_CYCLE;
constant \MONTHS_PER_MONTH_CYCLE = 136;
constant \DAYS_PER_MONTH_CYCLE = 4053;

# COMPUTATION
# For each year, take as many months as are needed
# in order to cycle to the next.

my $c = 0;
my @k = (0);

for 0 ..^ YEARS_PER_YEAR_CYCLE -> $i {
	my $need = 1 - ($c - floor($c));
	my $objs = ceiling($need * AVG_MONTHS_PER_YEAR);
	@k[$i + 1] = $objs;
	$c += $objs / AVG_MONTHS_PER_YEAR;
}

my @cumk = [\+] @k;

sub months-before-year($year) {
  my $whole-cycles = $year div YEARS_PER_YEAR_CYCLE;
  my $remainder = $year % YEARS_PER_YEAR_CYCLE;
  return $whole-cycles * MONTHS_PER_YEAR_CYCLE + @cumk[$remainder];
}

my @m = (0);

for 0 ..^ MONTHS_PER_MONTH_CYCLE -> $i {
  @m.push: ($i % 5 == 2) ?? 29 !! 30;
}

my @cumm = [\+] @m;

sub days-before-month($month) {
  my $whole-cycles = $month div MONTHS_PER_MONTH_CYCLE;
  my $remainder = $month % MONTHS_PER_MONTH_CYCLE;
  return $whole-cycles * DAYS_PER_MONTH_CYCLE + @cumm[$remainder];
}

sub days-before-date($d2, $m, $y) {
  my $d = $d2 - 1; # d is 0-indexed
  my $bm = months-before-year($y) + $m;
  return days-before-month($bm) + $d;
}

sub MAIN($d2, $m, $y) {
  say days-before-date($d2, $m, $y);
}