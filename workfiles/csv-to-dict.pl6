use CSV::Parser;

sub MAIN(Str $src, Str $out) {
  my $fh = open $src, :r;
  my $parser = CSV::Parser.new(file_handle => $fh, :contains_header_row);
  my $ofh = open $out, :w;
  until $fh.eof {
    my %data = %($parser.get_line());
    my $term = %data<Term>;
    my $pos = %data<PoS>;
    my $gloss = %data<Gloss>;
    my $notes = %data<Notes>;
    $ofh.say("# $term");
    $ofh.say(": $pos");
    $ofh.say($gloss);
    $ofh.say($notes);
    $ofh.say("");
  }
  $fh.close;
  $ofh.close;
}