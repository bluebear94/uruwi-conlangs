my $digits-str = "0123456789TKXSNVFMD";
my @digits = $digits-str.comb;

sub convert-small-fwd($n, $pad = False) {
	die "$n must be < 4199" if $n >= 4199;
	my $a = $n div (19 * 17);
	my $b = ($n div 17) % 19;
	my $c = $n % 17;
	return
		(!$pad && $a == 0 ?? "" !! @digits[$a]) ~
		(!$pad && $b == 0 && $a == 0 ?? "" !! @digits[$b]) ~
		@digits[$c];
}

sub convert-small-back($s) {
	die "$s must be 3 chars or fewer" if $s.chars > 3;
	my $c = $digits-str.index($s.substr(* - 1, 1) // "0");
	my $b = $digits-str.index($s.substr(* - 2, 1) // "0");
	my $a = $digits-str.index($s.substr(* - 3, 1) // "0");
	return $c + 17 * ($b + 19 * $a);
}

sub triangle($n, $p) {
	return ($n * (2 * $p + 1 - $n)) div 2;
}

sub sqrt-floor($y) {
	die "$y is negative" if $y < 0;
	return $y if $y < 2;
	my $small = sqrt-floor($y +> 2) +< 1;
	my $large = $small + 1;
	return $small if $large * $large > $y;
	return $large;
}
sub sqrt-ceil($y) {
	my $n = sqrt-floor($y);
	return $n if $n * $n == $y;
	return $n + 1;
}

sub untriangle($y, $p) {
	return (2 * $p + 1 - sqrt-ceil(4 * $p * $p + 4 * $p - 8 * $y + 1)) div 2;
}

my @powers = (4199);

for 0 .. 10 {
	my $p = @powers[* - 1];
	@powers.push: $p * ($p + 1) div 2;
}

sub convert-large-fwd-h($n, $i, $pad = False) {
	# base case
	if $i == 0 {
		return convert-small-fwd($n, $pad);
	}
	# recursive
	my $super = untriangle($n, @powers[$i - 1]);
	my $infra = $n - triangle($super, @powers[$i - 1]);
	if $super == 0 && !$pad {
		return convert-large-fwd-h($infra, $i - 1, False);
	}
	return
		convert-large-fwd-h($super, $i - 1, $pad) ~
		(":" x $i) ~
		convert-large-fwd-h($infra, $i - 1, True);
}

sub convert-large-fwd($n, $pad = False) {
	my $i = 0;
	++$i while @powers[$i] <= $n;
	convert-large-fwd-h($n, $i, $pad);
}

sub convert-large-back($s) {
	# Find the longest run of colons
	my @matches = ($s ~~ m:g/":"+/); #/"
	if (!@matches) {
		return convert-small-back($s);
	}
	my $longest-match = @matches.max(*.chars);
	my $i = (~$longest-match).chars;
	my $left = $s.substr(0, $longest-match.from);
	my $right = $s.substr($longest-match.to);
	my $sup = convert-large-back($left);
	my $inf = convert-large-back($right);
	return triangle($sup, @powers[$i - 1]) + $inf;
}

multi MAIN(Int :$fwd) {
	say convert-large-fwd($fwd);
}
multi MAIN(Str :$back) {
	say convert-large-back($back);
}