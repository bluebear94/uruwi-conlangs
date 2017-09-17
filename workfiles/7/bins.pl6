# CONSTANTS

constant \MONTHS_PER_YEAR_CYCLE = 7215;
constant \YEARS_PER_YEAR_CYCLE = 736;
constant \AVG_MONTHS_PER_YEAR = MONTHS_PER_YEAR_CYCLE / YEARS_PER_YEAR_CYCLE;

# COMPUTATION
# For each year, take as many months as are needed
# in order to cycle to the next.

my $c = 0;
my @k;

for 0 ..^ YEARS_PER_YEAR_CYCLE -> $i {
	my $need = 1 - ($c - floor($c));
	my $objs = ceiling($need * AVG_MONTHS_PER_YEAR);
	@k[$i] = $objs;
	$c += $objs / AVG_MONTHS_PER_YEAR;
}

# DISPLAY

my \cols = 4;
my $len = @k.elems;

say ("    0123456789" xx cols).join(" | ");

my \total-rows = ceiling($len / 10);
my \rows = ceiling(total-rows / cols);

for 0 ..^ rows -> $j {
	for 0 ..^ cols -> $p {
		print(" | ") if $p != 0;
		my $q = $j + rows * $p;
		next if $q >= total-rows;
		printf("%3d ", $q);
		for 0 ..^ 10 {
			my $i = 10 * $q + $_;
			if $i >= $len { print " "; }
			else {
				print "0123456789XE".substr(@k[$i], 1);
			}
		}
	}
	say "";
}
