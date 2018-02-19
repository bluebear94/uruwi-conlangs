#!/usr/bin/perl6

use v6;
use fatal;

constant $dq = "\x22";

constant @ALLTABLE =
  ".",
  "t", "t^x", "t^s", "t^y", "k", "k^x", "x", "x^l", "s", "s^f", "s^h", "s^w",
  "n", "n^g", "n^y", "v", "v^h", "v^j", "f", "f^x", "f^h", "m",
  "d", "d^y", "g", "g^j", "p", "b",
  "y", "c", "r",
  "z", "z^v", "z^h", "z^w", "j", "j^l", "w", "l",
  "a", "i", "o", "e", "u", "q"
  ;
constant %ALLTABLE_REV = %(@ALLTABLE.antipairs);
constant @P = <t s p f k k^x d b z^w v g f^h s^h f^x>;
constant @N = <n n^y m n^g>;
constant @L = <r l y w>;
constant @M = <t^x t^s j^l x t^y j d^y>;
constant @V = <a i q e u o>;
constant @PP = @P.map({%ALLTABLE_REV{$_}});
constant @NN = @N.map({%ALLTABLE_REV{$_}});
constant @LL = @L.map({%ALLTABLE_REV{$_}});
constant @MM = @M.map({%ALLTABLE_REV{$_}});
constant @VV = @V.map({%ALLTABLE_REV{$_}});

sub parseStr(Str $s) returns Blob {
  my @combed = $s.comb(/ '.' | [\w ['^' \w]?] /);
  return Blob.new(@combed.map({%ALLTABLE_REV{$_}}));
}
sub getStr(Blob $b) returns Str {
  return $b.map({@ALLTABLE[$_]}).join;
}
sub getStrBrace(Blob $b) returns Str {
  return $b.map({
    my $s = @ALLTABLE[$_];
    $s.chars > 1 ?? '{' ~ $s ~ '}' !! $s;
  }).join;
}

sub bitToStr(int $x) returns Blob {
  sub f(int $q) {
    return 0 if $q == 0;
    return @PP[$q - 1] if $q < 15;
    return @NN[$q - 15] if $q < 19;
    return @PP[($q - 19) div 4], @LL[($q - 19) % 4] if $q < 75;
    return @LL[$q - 75] if $q < 79;
    return @MM[$q - 79];
  }
  my $r = $x % 6;
  my $q = $x div 6;
  return Blob.new(|f($q), @VV[$r]);
}

constant %ATOMIC_INSTRUCTIONS = %(
  nop => 0o000,
  modadj => 0o001,
  modnoun => 0o002,
  modgen => 0o003,
  copadj => 0o025,
  copnoun => 0o026,
  pronounlc => 0o030,
  pronounllc => 0o031,
  adpton => 0o040,
  adptov => 0o041,
  negadp => 0o042,
  conj => 0o043,
  trans => 0o050,
  modverb => 0o051,
  attachconn => 0o061,
  setnname => 0o100,
  add => 0o701,
  sub => 0o702,
  div => 0o703,
  mul => 0o704,
);
constant %LITERAL_TYPES = %(
  0 => 0, 1 => 1, 2 => 2, 3 => 3,
  4 => 4, 5 => 5, 6 => 6, 7 => 7,
  v1 => 0, v2 => 1, v3 => 2,
  nsent => 0, nnonsent => 2, nmeas => 3,
  nedib => 5, nined => 6, nabst => 7,
  dfront => 0, dback => 4,
);
constant %OPTION_INSTRUCTIONS = %(
  setnopt => %(
    op => 0o021,
    df => <dir indef>,
    nd => <inv def>,
  ),
  setvopt => %(
    op => 0o022,
    df => <nonpast telic pos nq>,
    nd => <past atelic neg q>,
  ),
);
constant %PRONOUN_TYPES = %(
  near => 0,
  far => 1,
  other => 2,
  anaph_sub => 4,
  anaph_obj => 6,
  generic => 7,
);
constant %CONNECTOR_TYPES = %(
  ordinary => 0, analogous => 1,
  subversive => 2, augmentative => 3,
  explanatory => 4, conditional => 5,
);
constant %DEFAULT_SEQIDS = %(
  <a p e t i d o g u k z t^s v s^h ar pr>.antipairs
);
constant %ASPECTS = %(
  imp => 0, perf => 1, gnom => 2, deon_nec => 3,
  deon_pot => 4, unexp => 5, left => 6, right => 7,
  inter => 9, deon_rec => 10, gnom_dub => 11,
  epis_nec => 12, epis_pot => 13, cmp => 14,
  tmpu => 15, tmpnu => 16, spcu => 17,
  nxs => 18, spcnu => 19, nxo => 20, nxa => 21,
  spcfirst => 22,
);

sub paramList(Str @df, Str @nd, Str @args) returns Int {
  my Int $flags = 0;
  my Int $visited = 0;
  my %dfm = %(@df.antipairs);
  my %ndm = %(@nd.antipairs);
  for @args -> $arg {
    my $n = %ndm{$arg};
    my $d = %dfm{$arg};
    if $n.defined {
      # Non-default?
      die "Option {@df[$n]}|$arg already set"
        if $visited +& (1 +< $n);
      $visited +|= (1 +< $n);
      $flags +|= (1 +< $n);
    } elsif $d.defined {
      # Default?
      die "Option $arg|{@nd[$n]} already set"
        if $visited +& (1 +< $d);
      $visited +|= (1 +< $d);
    } else {
      die "Unrecognised option \"$arg\"";
    }
  }
  return $flags;
}

sub unquote(Str $s) {
  if !($s.starts-with($dq) && $s.ends-with($dq)) {
    note "WARN: literal $s is not enclosed in double quotes";
    return $s;
  } else {
    return $s.substr(1, * - 1);
  }
}

sub makeLiteral(Str $literal, Buf $b is rw, int $literalType = 0) {
  my $literalBlob = parseStr($literal);
  if ($literalBlob.bytes >= 512) {
    die "Literal is more than 512 chars long";
  }
  $b ~= bitToStr(0o010 + $literalType);
  $b ~= bitToStr($literalBlob.bytes);
  $b ~= $literalBlob;
}

sub assemble(IO::Handle $fh) returns Blob {
  my Buf $b = Buf.new;
  for $fh.lines -> $line {
    my $nl = $line;
    my $i = $nl.index("#");
    if $i.defined {
      $nl = $nl.substr(0, $i);
    }
    $nl = $nl.chomp;
    my @args = $nl.split(/\s+/, :skip-empty);
    next if @args.elems == 0 || @args[0] eq '';
    my $cname = @args[0];
    my Str @rest = Array[Str].new(@args[1..*]);
    if %ATOMIC_INSTRUCTIONS{$cname}.defined {
      $b ~= bitToStr(%ATOMIC_INSTRUCTIONS{$cname});
    } elsif %OPTION_INSTRUCTIONS{$cname} -> %spec {
      my Str @df = Array[Str].new(@(%spec<df>));
      my Str @nd = Array[Str].new(@(%spec<nd>));
      my $op = %spec<op>;
      my $bits = %spec<bitcount> // 1;
      my $flags = paramList(@df, @nd, @rest);
      $b ~= bitToStr($op);
      for ^$bits -> $shift {
        $b ~= bitToStr(($flags +> (9 * $shift)) +& 0o777);
      }
    } elsif $cname eq 'literal' {
      my $literalType = %LITERAL_TYPES{@args[1]} //
        die "Unrecognised literal type \"{@args[1]}\"!";
      my $literal = unquote @args[2];
      makeLiteral($literal, $b, $literalType);
    } elsif $cname eq 'sentence' {
      my $flags = paramList(
        Array[Str].new(<s o>),
        Array[Str].new(<ns no>),
        @rest);
      $b ~= bitToStr(0o004 +| (+^$flags +& 3));
    } elsif $cname eq 'pronoun' {
      my $pronounType = %PRONOUN_TYPES{@args[1]} //
        die "Unrecognised pronoun type \"{@args[1]}\"!";
      my $isDual = @args.elems >= 3 && @args[2] eq 'du';
      $b ~= bitToStr(0o020);
      $b ~= bitToStr($pronounType +| ($isDual ?? 8 !! 0));
    } elsif $cname eq 'conn' {
      my $connType = %CONNECTOR_TYPES{@args[1]} //
        die "Unrecognised connector type \"{@args[1]}\"!";
      my $parity = +@args[2];
      die "Invalid parity $parity!" if $parity != 0 | 1;
      my $seqid = unquote @args[3];
      my $noimm = @args.elems >= 4 && @args[3] eq 'noimm';
      my $dsid = %DEFAULT_SEQIDS{$seqid};
      my $flags = $connType +| ($parity +< 3);
      if !$noimm && $dsid.defined {
        # Use default seqid
        $b ~= bitToStr(0o60);
        $b ~= bitToStr($flags +| ($dsid +< 5));
      } elsif $seqid eq '-' {
        # Don't generate a literal instruction beforehand
        $b ~= bitToStr(0o60);
        $b ~= bitToStr($flags +| (1 +< 4));
      } else {
        # Do generate a literal instruction
        makeLiteral($seqid, $b);
        $b ~= bitToStr(0o60);
        $b ~= bitToStr($flags +| (1 +< 4));
      }
    } elsif $cname eq 'setaspect' {
      my int $flags = 0;
      for @rest -> $a {
        my $d = %ASPECTS{$a};
        die "Unrecognised aspect \"$a\"!" if !$d.defined;
        die "Aspect \"$a\" already set!" if $flags +& (1 +< $d);
        $flags +|= (1 +< $d);
      }
      $b ~= bitToStr(0o23);
      $b ~= bitToStr($flags +& 0o777);
      $b ~= bitToStr(($flags +> 9) +& 0o777);
      $b ~= bitToStr(($flags +> 18) +& 0o777);
    } elsif $cname eq 'pushint' {
      my Int $a = +@args[1];
      my @bytes = $a.polymod(512 xx *);
      my $nbytes = @bytes.elems;
      die 'Integer larger than $nbits bits'
        if $nbytes >= 512 ** 4;
      $b ~= bitToStr(0o700);
      for ^4 -> $i {
        $b ~= bitToStr(($nbytes +> (9 * $i)) +& 0o777);
      }
      for @bytes {
        $b ~= bitToStr($_);
      }
    } elsif $cname eq "quote" {
      my $dir = $fh.path;
      if $dir ~~ IO::Special {
        $dir = $*CWD;
      } else {
        $dir = $dir.parent;
      }
      my $fh2 = open $dir.add(@args[1]).resolve;
      my $b2 = assemble($fh2);
      if ($b2.bytes >= 512) {
        die "Literal is more than 512 chars long";
      }
      $b ~= bitToStr(0o010);
      $b ~= bitToStr($b2.bytes);
      $b ~= $b2;
    } else {
      die "Unrecognised instruction \"$cname\"!";
    }
  }
  return $b;
}

sub MAIN(Str $fname, Bool :$escape, Bool :$brace) {
  my $fh = open $fname;
  my $s = ($brace ?? &getStrBrace !! &getStr)(assemble($fh));
  $fh.close;
  if $escape {
    $s = $s.subst("^", "\\^", :g);
  }
  say $s;
}
