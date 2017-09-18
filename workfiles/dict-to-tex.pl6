use JSON::Fast;

sub to-tex($s, $options) {
  return $s
    .subst("^", "\\^"):g
    .subst("\n", " " ~ ($options<newline> // "\\\\")):g;
}

sub list-to-revmap(@l) {
  my %m;
  for ^@l -> $i {
    %m{@l[$i]} = $i;
  }
  return %m;
}

sub get-sort-key($s, %alphamap, $aregex) {
  # Split into individual letters
  my @letters = $s.comb($aregex);
  return %alphamap{@letters}.grep(*.defined);
}

sub compare-lists(@a, @b) {
  for ^@a {
    return More if $_ >= @b;
    my $res = @a[$_] cmp @b[$_];
    return $res if $res != Same;
  }
  return @a.elems == @b.elems ?? Same !! Less;
}

constant \DEFAULT_FMTER = q:to/END/;
  %s \textit{%s}
  \quad %s

END

sub MAIN(Str $src, Str $out, Str $opts) {
  my $options = from-json(slurp($opts));
  my $word-fmter = $options<styling> // '\textsf{%s}';
  my $section-fmter = $options<sectionstyle> //
    "\\section*\{%s\}\n";
  my $entry-fmter = $options<entryStyle> // DEFAULT_FMTER;
  my @alphabet = @($options<alphabet>);
  my $aregex = /@alphabet/;
  my %amap = list-to-revmap(@alphabet);
  my $fh = open $src, :r;
  my @entries;
  my $cur-entry;
  for $fh.lines {
    if /^ "#" \s* (.*)/ {
      $cur-entry<name> = ~$0;
      $cur-entry<key> = get-sort-key(~$0, %amap, $aregex);
    } elsif /^ ":" \s* (.*)/ {
      $cur-entry<pos> = ~$0;
    } elsif $_ {
      if $cur-entry<def>:exists {
        $cur-entry<def> ~= "\n$_";
      } else {
        $cur-entry<def> = $_;
      }
    } elsif $cur-entry {
      @entries.push: $cur-entry;
      $cur-entry = Hash();
    }
  }
  my $cur-first = -1;
  $fh.close;
  @entries.=sort: {compare-lists($^a<key>, $^b<key>)};
  $fh = open $out, :w;
  $fh.printf("\\indent\n");
  for @entries -> $entry {
    my $first = $entry<key>[0] // -1;
    if $cur-first < $first {
      my $letter = @alphabet[$first];
      my $texletter = to-tex $letter, $options;
      $fh.printf($section-fmter, $texletter);
      $fh.print("\\indent\n\n");
      $cur-first = $first;
    }
    my $texname = to-tex $entry<name>, $options;
    my $texfmt = sprintf($word-fmter, $texname);
    my $pos = $entry<pos>;
    my $def = to-tex($entry<def>, $options);
    $fh.printf($entry-fmter, $texfmt, $pos, $def);
  }
  $fh.close;
}