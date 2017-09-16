# CONSTANTS

my \a = 7215;
my \b = 736;
my \r = a / b;

# COMPUTATION
# For each year, take as many months as are needed
# in order to cycle to the next.

my $c = 0;
my @k;

for 0 ..^ b -> $i {
	my $need = 1 - ($c - floor($c));
	my $objs = ceiling($need * r);
	@k[$i] = $objs;
	$c += $objs / r;
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
