use JSON::Fast;
use fatal;

CONTROL {
    when CX::Warn {
        note $_;
        note .backtrace;
        exit 1;
    }
}

sub to-tex($s, $options) {
  return $s
    .subst(/<!after "\\"> "^"/, "\\^"):g
    .subst(/<!after "\\"> "_"/, "\\,"):g
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
  # Options
  my $word-fmter = $options<styling> // '\textsf{%s}';
  my $section-fmter = $options<sectionstyle> //
    "\\section*\{%s\}\n";
  my $entry-fmter = $options<entryStyle> // DEFAULT_FMTER;
  my @tagInfo = $options<tags> // [];
  my @alphabet = @($options<alphabet>);
  my $aregex = /@alphabet/;
  my %amap = list-to-revmap(@alphabet);
  my $index-title-fmter = $options<indextitlestyle> // '\section*{%s}';
  my @indices = @($options<indices>) // [];
  # Read input
  my $fh = open $src, :r;
  my @entries;
  my $cur-entry;
  my $lineno = 0;
  for $fh.lines {
    ++$lineno;
    if /^ "#" \s* (.*)/ {
      die "Name redeclared at line $lineno" if $cur-entry<name>.defined;
      $cur-entry<name> = ~$0;
      $cur-entry<key> = get-sort-key(~$0, %amap, $aregex);
    } elsif /^ ":" \s* (.*)/ {
      die "POS redeclared at line $lineno" if $cur-entry<pos>.defined;
      $cur-entry<pos> = ~$0;
    } elsif /^ "<" \s* (.*)/ {
      $cur-entry<etym> = ~$0;
    } elsif /^ "@" (\w+) \s* (.*)/ {
      $cur-entry<tags>{~$0} = ~$1;
    } elsif $_ {
      if $cur-entry<def>:exists {
        $cur-entry<def> ~= "\n$_";
      } else {
        $cur-entry<def> = $_;
      }
    } elsif $cur-entry {
      if not $cur-entry<name>:exists {
        die "Attempted to push entry without name at line $lineno";
      }
      @entries.push: $cur-entry;
      $cur-entry = Hash();
    }
  }
  if $cur-entry {
    if not $cur-entry<name>:exists {
      die "Attempted to push entry without name at EOF";
    }
    @entries.push: $cur-entry;
  }
  my $cur-first = -1;
  $fh.close;
  @entries.=sort: {
    compare-lists($^a<key>, $^b<key>) || $a<name> leg $b<name>
  };
  # Write output
  # Main list
  $fh = open $out, :w;
  $fh.print("\\indent\n");
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
    my @tags = @tagInfo.map(-> ($i) {
      my $name = $i<name>;
      my $value = $entry<tags>{$name};
      return Any if !($value.defined);
      sprintf $i<styling>, $value;
    }).grep(*.defined);
    my $def = $entry<def>;
    if $entry<etym> {
      $def = "< " ~ $entry<etym> ~ "\n" ~ $def;
    }
    if @tags {
      $def = @tags.join("\n") ~ "\n" ~ $def;
    }
    $def = to-tex($def, $options);
    $fh.printf($entry-fmter, $texfmt, $pos, $def);
  }
  # Indices
  for @indices -> $index {
    $fh.printf($index-title-fmter, $index<indextitle>);
    my $index-section-fmter = $index<indexsectionstyle> // '\subsection{%s}';
    my @ialphabet = @($index<alphabet>);
    my $iaregex = /@ialphabet/;
    my %iamap = list-to-revmap(@ialphabet);
    my $ikey = $index<key>;
    my $istyle = $options<tags>.grep({$_<name> eq $ikey})[0]<styling>;
    my @ientries = @entries.map(sub (%e) {
      my $k = %e<tags>{$ikey} // %e{$ikey};
      (%e<name>, get-sort-key($k, %iamap, $iaregex), $k);
    });
    @ientries.sort({$_[1]});
    say @ientries;
    my $cur-first = -1;
    $fh.print("\\indent\n");
    for @ientries -> $ie {
      my $first = $ie[1][0] // -1;
      if $cur-first < $first {
        my $letter = @ialphabet[$first];
        my $texletter = to-tex $letter, $options;
        $fh.printf($index-section-fmter, $texletter);
        $fh.print("\n\\indent\n\n");
        $cur-first = $first;
      }
      $fh.print("  ");
      $fh.printf($istyle, to-tex($ie[2], $options));
      $fh.print(" ");
      $fh.printf($word-fmter, to-tex($ie[0], $options));
      $fh.print("\n");
    }
  }
  $fh.close;
}