my \r = 30.8014764;
my $worst = Inf;
for 1..1000 -> $i {
	my $badness = (r * $i - floor(r * $i)) * sqrt($i);
	next if $badness >= $worst;
	$worst = $badness;
	say "$i {floor(r * $i)} $badness"
}
