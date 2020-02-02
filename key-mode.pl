#!/usr/bin/env perl
# by William Hofferbert
# a script to get information about musical scales

use 5.022;				# perf
use utf8;				# box drawing
use open ':std', ':encoding(UTF-8)';	# like perl -CS; utf8ify std streams
use strict;				# good form
use warnings;				# know when stuff is wrong
use Data::Dumper;			# debug
use File::Basename;			# know where the script lives
use Getopt::Long;			# handle arguments

# TODO require some module so windoze understands
# the ANSII color escape sequences

# TODO be smarter about chords and shit.
# like how to use a pentatonic scale here
# pentatonic should have 5 chords in the progression
# chords could still be measured by the 3,3; 3,4; 4,3; 4,4 relationships
# if scalar @notes == 5
  # if two notes are separated by 3/4
  # do the right thing. 
  # assume some 2nd/6th was between them ?
#
# that and 8 note scales like bebop minor/dominant
#
#
# hmmmm
# maybe some other gabage
# pairs of step patterns, 33, 34, 43, 44, and see what combinations can happen in a scale.
# perhaps that's extensible... 7ths.. 33? 34? 43? 44?
# 
# 

#
# Default Variables
#

my $prog = basename($0);



# conventional scale notes
my @notes = ("A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#");
my @notesFlat = ("A", "Bb", "B", "C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab");

# TODO a hash of modes that correlate to scale steps
# all modes correspond to a number of steps in a scale
# TODO make this an array so it's ordered.
my %mode_hash = (
  'Ionian'		=> [2, 2, 1, 2, 2, 2, 1],
  'Dorian'		=> [2, 1, 2, 2, 2, 1, 2],
  'Phrygian'		=> [1, 2, 2, 2, 1, 2, 2],
  'Lydian'		=> [2, 2, 2, 1, 2, 2, 1],
  'Mixolydian'		=> [2, 2, 1, 2, 2, 1, 2],
  'Aeolian'		=> [2, 1, 2, 2, 1, 2, 2],
  'Locrian'		=> [1, 2, 2, 1, 2, 2, 1],

  'Minor'		=> [2, 1, 2, 2, 1, 2, 2],
  'Major'		=> [2, 2, 1, 2, 2, 2, 1],
  'Super Locrian'	=> [1, 3, 1, 2, 1, 2, 2],

  'Harmonic Minor'	=> [2, 1, 2, 2, 1, 3, 1], 

  'Bebop Minor'		=> [2, 1, 1, 1, 2, 2, 1, 2],

  #''	=> [], 
);

# numerals for chart representations, extra for random scales?
my @numerals = qw (I II III IV V VI VII VIII IX X);

# guitar options...
my ($show_fingerboard, $condense_boards);
my $fret_width = 3;
my $max_fret_number = 15;
my @guitar_tuning = ("E", "A", "D", "G", "B", "E");
my @highlight_frets = qw(0 3 5 7 9 12 15);

# colors
my @colors = ('DEFAULT', 'BOLD', 'BLACK', 'RED', 'BLUE', 'YELLOW', 'GREEN',
              'MAJENTA', 'CYAN', 'WHITE', 'BBLACK', 'BRED', 'BBLUE',
              'BYELLOW', 'BGREEN', 'BMAJENTA', 'BCYAN', 'BWHITE', 'BGDEFAULT',
              'BGBLACK', 'BGRED', 'BGBLUE', 'BGYELLOW', 'BGGREEN', 'BGMAJENTA',
              'BGCYAN', 'BGWHITE');

my $reset = "\e[0m";
my %colors = (
  'DEFAULT'      => "",
  'BOLD'         => "\e[1m",
  'BLACK'        => "\e[30m",
  'RED'          => "\e[31m",
  'GREEN'        => "\e[32m",
  'YELLOW'       => "\e[33m",
  'BLUE'         => "\e[34m",
  'MAJENTA'      => "\e[35m",
  'CYAN'         => "\e[36m",
  'WHITE'        => "\e[37m",
  'BBLACK'       => "\e[1;30m",
  'BRED'         => "\e[1;31m",
  'BGREEN'       => "\e[1;32m",
  'BYELLOW'      => "\e[1;33m",
  'BBLUE'        => "\e[1;34m",
  'BMAJENTA'     => "\e[1;35m",
  'BCYAN'        => "\e[1;36m",
  'BWHITE'       => "\e[1;37m",
  'BGDEFAULT'      => "",
  'BGBLACK'        => "\e[40m",
  'BGRED'          => "\e[41m",
  'BGGREEN'        => "\e[42m",
  'BGYELLOW'       => "\e[43m",
  'BGBLUE'         => "\e[44m",
  'BGMAJENTA'      => "\e[45m",
  'BGCYAN'         => "\e[46m",
  'BGWHITE'        => "\e[47m"
);

my %color_backgrounds = (
  #'30m' => $colors{BGBLACK},
  #'30m' => "\e[38;5;235m",
  '0' => $colors{BGRED},
  '1' => $colors{BGGREEN},
  '2' => $colors{BGYELLOW},
  '3' => $colors{BGBLUE},
  '4' => $colors{BGMAJENTA},
  '5' => $colors{BGCYAN},
  '6' => $colors{BGWHITE},
  '7' => "\x1b[48;5;21m",
  '8' => "\x1b[48;5;57m",
  '9' => "\x1b[48;5;93m",
);

my %color_font_bg_correlator = (
  #'' => $colors{BWHITE},
  '0' => $colors{BWHITE},
  '1' => $colors{BWHITE},
  '2' => $colors{BBLACK},
  '3' => $colors{BWHITE},
  '4' => $colors{BWHITE},
  '5' => $colors{BWHITE},
  '6' => $colors{BBLACK},
  '7' => $colors{BWHITE},
  '8' => $colors{BWHITE},
  '9' => $colors{BWHITE},
);

my %scale_colors = (
  '0' => $colors{BRED},
  '1' => $colors{BBLACK},
  '2' => $colors{BYELLOW},
  '3' => $colors{BBLUE},
  '4' => $colors{BGREEN},
  '5' => $colors{BMAJENTA},
  '6' => $colors{BCYAN},
  '7' => "\e[38;5;21m",
  '8' => "\e[38;5;57m",
  '9' => "\e[38;5;93m",
);

my $ansiColorRegex = '\e\[(?:1;)?(\d+m)|\x1b\[(\d+;\d+;\d+m)|\e\[(\d+;\d+;\d+m)';

my $fret_color = $colors{BWHITE};

# keyboard options...
my $show_keyboard;
my $octaves = 3;
my $keyWidth = 3;
my $vert_bar = $colors{BGWHITE} . $colors{BBLACK} . "\x{2503}";
my @kbdNoteOrder = ("B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#");
my @kbdNoteOrderFlat = ("B", "C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb");
my @kbdFullNotes;
my %piano_keys;
my $start_white_keys = $colors{BLACK} . $colors{BGWHITE}. " " x $keyWidth . $vert_bar . " " x ($keyWidth - 1) ;
my $two_black_keys = $colors{BGBLACK}. " " x $keyWidth . "$colors{BGWHITE} $colors{BGBLACK}" . " " x $keyWidth;
my $three_black_keys = "$two_black_keys$colors{BGWHITE} $colors{BGBLACK}" . " " x $keyWidth;
my $two_white_keys = $colors{BGWHITE} . " " x ($keyWidth - 1) . $vert_bar . " " x ($keyWidth - 1);



# expected input vars
my ($in_key, $in_mode, @in_steps, $user_scale_name, $use_flats, $static_triad_colors);



#
# Functions
#

sub usage {

  my $color_str = join", ", @colors;
  $color_str =~ s/((\S+\s+){7})/$1\n/g;
  $color_str =~ s/\n/\n      /sg;

  my $mode_str = join", ", keys %mode_hash;

  my $usage = <<"  END_USAGE";

  This script can print out information about progressions
  and chord relationships, based on an input key and mode.

  Additionally, you can provide your own step pattern and key
  if desired.

  Most options can be mixed and matched as you might expect.

Usage:
  $prog -key [note] -mode [mode]
  $prog -key [note] -steps ["quoted pattern"]

  -R
  -key [note]
    [note] can be any of:
    @notes

  -m
  -mode [mode]
    [mode] can be any of: Major, Minor,
    $mode_str

  -P
  -steps ["quoted pattern"]
    ["quoted pattern"] can consist of any quoted and space
    delimited set of 7 numbers which add up to 12, to allow
    for extrapolation of non-built in modes.

Options:

  -b
  -flat
    Use flat notes inseted of sharp.

  -n
  -name ["Scale Name"]
    Scale Name can be any quoted string.
    Provides the name to display when using a custom Step signature.

  -color-1 [COLOR] ... -color-7 [COLOR]
    Assign a specific color to the given notes, when drawing the 
    guitar fingerboard patterns. 
    -color-1 is the root, -color-3 is the third, etc.
    Colors may be any of:
      $color_str

  -c
  -condense
    Print the guitar fingerboards or the piano keyboards in multiple columns.
    Good for running with a wide terminal!

  -static-triad-colors
    Only print triads with the same set of colors, representing
    root, third, fifth.

Guitar Options:

  -F
  -fingerboards
    For each chord in the scale, print a representation of a guitar
    figerboard, with the notes displayed.

  -g
  -guitar-tuning ["Open Notes"]
    Open notes can be any quoted list of notes, low to high.
    Not limited to 6 strings.
    Default is "E A D G B E"

Keyboard Options:

  -K
  -keyboards
    For each chord in the scale, print a representation of a piano
    keyboard, with the given notes highlighed on the keyboard.


Examples:

  Get info on A Dorian:
    $prog -key A -mode dorian

  Get info on E Aeolian, along with fretboard note positions:
    $prog -key E -mode Aeolian -fingerboards

  Get info about a user-provided scale:
    $prog -key E -steps "1 3 1 2 1 2 2" -name "Super Locrian"

  Get info and fingerboard patterns for an 8 string guitar with weird tuning:
    $prog -key B -mode Mixolydian -fingerboards -guitar-tuning "E A D A D G B E"
 
  Get info about a keyboard, condensed:
    $prog -key G -mode Phrygian -keyboards -condense
 
  The argument handling also supports shorthand addressing on most options.
  To see condensed keyboard and fingerboard renditions of a Db Major scale: 
    $prog -b -R Db -m Major -F -K -c
 
  END_USAGE

  chomp $usage;
  say "$usage";
  exit(0);
}

sub check_required_args {		# handle leftover @ARGV stuff here if need be
  if ($use_flats) {
    @kbdNoteOrder = @kbdNoteOrderFlat;
    @notes = @notesFlat;
  }

  &err("Requires an input key! Must be one of: " . join", ", @notes) unless defined $in_key;
  &err("Invalid Key! Must be one of: " . join", ", @notes) unless grep {$in_key eq $_} @notes;
  if (! $in_mode && ! @in_steps) {
    &helps;
  }
  if (defined $in_mode) {
    unless (grep {$in_mode =~ /^$_$/i} keys %mode_hash) {
      &err("$prog requires a valid -mode");
    }
  } 
  if (! defined $in_key) {
    &err("$prog requires a valid -key");
  }
  if (@in_steps) {
    unless (@in_steps == 7 || @in_steps == 8) {
      &err("Unexpected number of steps in -steps!");
    }
    &err("Steps don't add up to 12!") unless (eval join"+",@in_steps) == 12;
  }

  # handle note rearrangement after flats
  map {push(@kbdFullNotes, @kbdNoteOrder)} 1..$octaves + 1;
  for my $note (@kbdNoteOrder) {
    if ($note =~ /[#b]$/) {
      $piano_keys{$note}{COLOR} = $colors{WHITE};
      $piano_keys{$note}{BGCOLOR} = $colors{BGBLACK};
    } else {
      $piano_keys{$note}{COLOR} = $colors{BLACK};
      $piano_keys{$note}{BGCOLOR} = $colors{BGWHITE};
    }
  }
}

sub parse_insteps {
  my $steps = $_[1];
  push (@in_steps, split(/\s+/, $steps));
  #return(@in_steps);
}

sub parse_tuning {
  my $tuning = $_[1];
  @guitar_tuning = ();
  for my $note (split(/\s+/, $tuning)) {
    if (grep {$note eq $_} @notes) {
      push @guitar_tuning, $note;
    } else {
      say "$note is not a valid note!";
      exit;
    }
  }
}

sub parse_colors {
  my ($thing, $color) = @_;
  if (grep {$color eq $_} @colors) {
    $scale_colors{$thing} = $colors{$color};
  } else {
    say "$color is not a valid color!";
    exit;
  }
}

sub handle_args {
  Getopt::Long::GetOptions(
    'R|key=s' => \$in_key,
    'm|mode=s' => \$in_mode,
    'P|steps=s' => \&parse_insteps,
    'n|name=s' => \$user_scale_name,
    'b|flats' => \$use_flats,
    'static-triad-colors' => \$static_triad_colors,
    'F|fingerboards' => \$show_fingerboard,
    'K|keyboards' => \$show_keyboard,
    'g|guitar-tuning=s' => \&parse_tuning,
    'color-1=s' => sub {&parse_colors(0, $_[1])},
    'color-2=s' => sub {&parse_colors(1, $_[1])},
    'color-3=s' => sub {&parse_colors(2, $_[1])},
    'color-4=s' => sub {&parse_colors(3, $_[1])},
    'color-5=s' => sub {&parse_colors(4, $_[1])},
    'color-6=s' => sub {&parse_colors(5, $_[1])},
    'color-7=s' => sub {&parse_colors(6, $_[1])},
    'c|condense' => \$condense_boards,
    'h|help' => \&usage,
  );
  &check_required_args;
}


sub err {
  my $msg=shift;
  say STDERR $msg;
  exit 2;
}

sub warn {
  my $msg=shift;
  say STDERR $msg;
}

sub centerStr {
  my ($str, $len, $pad) = @_;
  $pad //= " ";
  my $pre = $pad x int(($len - length($str) + 1) / 2);
  my $post = $pad x int(($len - length($str)) / 2);
  return $pre . $str . $post;
}

sub longestString {
  my $len = 0;
  map {my $c = length($_);$len = $c if $c > $len} @_;
  return $len;
}

sub array_search {
  my ($elem, @arr) = @_;
  for (0..$#arr) {
    return $_ if $arr[$_] eq $elem;
  }
  return -1;
}

sub rotate_array_left {
  my ($amount, @array) = @_;
  for (my $i=0 ; $i < $amount ; $i++) { 
    my $pos1 = shift @array;
    push (@array, $pos1);
  }
  return (@array);
}

sub length_without_color {
  my ($txt) = @_;
  $txt =~ s/$ansiColorRegex//g;
  return length $txt;
}

sub column_color_txt_arr {
  my ($textAref, $sep) = @_;
  my @txtsArr = @{$textAref};
  my $longestLine = 0;
  #for my $lines (@txtsArr) {
  for my $lines ($txtsArr[0]) {
    map {$longestLine = &length_without_color($_) if &length_without_color($_) > $longestLine} @$lines;
  }
  my $half = int((scalar @txtsArr + 1) / 2);
  for my $index (0..$half) {
    my $idxA = $index * 2;
    my $idxB = $idxA + 1;
    if (defined $txtsArr[$idxB]) {
      my @ar1 = @{$txtsArr[$idxA]};
      my @ar2 = @{$txtsArr[$idxB]};
      for my $arIDx (0..$#ar1) {
        my $txt1 = $ar1[$arIDx];
        my $txt2 = $ar2[$arIDx];
        my $spaces = " " x ($longestLine - &length_without_color($txt1));
        say $txt1 . $spaces . $sep . $txt2 ;
      }
    } else {
      map {say} @{$txtsArr[$idxA]};
    }
  }
}

# 
# 
# 
# Music stuff 
# 
# 
# 

sub shift_scales {
  # mode step selection
  my @step_pattern;

  if (@in_steps) {
    @step_pattern = @in_steps;
  } else {
    for my $insensitive_check (keys %mode_hash) {
      if ($insensitive_check =~ /^$in_mode$/i) {
        @step_pattern = @{$mode_hash{$insensitive_check}};
        $in_mode = $insensitive_check;
      }
    }
  }


  # get to the right note structure
  my ( $note_index )= grep {$notes[$_] =~ /$in_key/i} 0..$#notes;
  @notes = &rotate_array_left($note_index, @notes);

  my @scale_notes;
  my $current_step = 0;
  
  # build array of notes in teh scale
  for my $step (@step_pattern) {
    push(@scale_notes, $notes[$current_step]);
    $current_step += $step;
  }

  return(@scale_notes);
}

# TODO this might be better as some combination check,
# then have a preferred order perhaps?
sub find_best_chord {
  my @scaleNotes = @_;
  my $root = $scaleNotes[0];
  my $root_note_index = &array_search($root, @notes);
  my @adj_scale = &rotate_array_left($root_note_index, @notes);
  my $skip = 2;
  my $third = $scaleNotes[$skip];
  my $idx3 = &array_search($third, @adj_scale);
  while ($idx3 < 3) {
    $skip++;
    $third = $scaleNotes[$skip];
    $idx3 = &array_search($third, @adj_scale);
  }
  # prefer major over minor?
  #if (&array_search($scaleNotes[$skip + 1], @adj_scale) == 4) {
  #  say "Skipping another on the third, $third to" . $scaleNotes[$skip + 1],;
  #  $skip++;
  #  $third = $scaleNotes[$skip];
  #  $idx3 = &array_search($third, @adj_scale);
  #}
  my $fifthSkip = 2;
  my $fifth = $scaleNotes[$skip + $fifthSkip];
  my $idx5 = &array_search($fifth, @adj_scale);
  while ($idx5 - $idx3 < 3) {
    $fifthSkip++;
    $fifth = $scaleNotes[$skip + $fifthSkip];
    $idx5 = &array_search($fifth, @adj_scale);
  }
  my $fifthCheck = &array_search($scaleNotes[$skip + $fifthSkip + 1], @adj_scale);
  # prefer minor to dim
  if ($fifthCheck == 7) {
    #say "root $root ; Skipping another on the fifth, $fifth to " . $fifthCheck;
    $fifthSkip++;
    $fifth = $scaleNotes[$skip + $fifthSkip];
    $idx5 = &array_search($fifth, @adj_scale);
  }
  return($root, $third, $fifth);
}

sub find_progression {
  my (@scale_notes) = @_;

  my @progression;

  # build all triads
  foreach my $snote (@scale_notes) {
  
    my $note_degree;

    for (my $i=0 ; $i <= $#scale_notes ; $i++) {
      $note_degree = $i if ($scale_notes[$i] eq $snote)
    }

    my @adj_notes = &rotate_array_left($note_degree, @scale_notes);

    my @chord;
    my @scaleSteps;
    if (defined $in_mode && exists $mode_hash{$in_mode}) {
      @scaleSteps = @{$mode_hash{$in_mode}};
    } else {
      @scaleSteps = @in_steps;
    }
    if (scalar @scaleSteps == 8) {
      @chord = &find_best_chord(@adj_notes);
    } else {
      $chord[0] = $adj_notes[0];
      $chord[1] = $adj_notes[2];
      $chord[2] = $adj_notes[4];
    }
    push(@progression, \@chord);
  }

  return @progression;
}

sub find_tonality {
  # Now we know what the chord notes are, so figure out if major or minor, push to hash
  my (@progression) = @_;
  my %music;

  # TODO this could probably be an array of hashes
  my $n = 0;
  foreach my $chord (@progression) {
    my $first_note = @{$chord}[0];
  
    my $first_note_degree = &array_search($first_note, @notes);
    my @adj_scale = &rotate_array_left($first_note_degree, @notes);
  
    my $pattern;
    my $chord_notes;
    foreach my $note (@{$chord}){
      my $note_degree = &array_search($note, @adj_scale);
      $pattern .= $note_degree;
      $chord_notes .= "$note ";
    }
  
    $music{$n}{notes} = $chord_notes;
    $music{$n}{base} = $first_note;
  
    if ($pattern eq "036") {
      $music{$n}{sig} = "Dim °";
      $music{$n}{num} = lc($numerals[$n]) . "°";
    } elsif ($pattern eq "037") {
      $music{$n}{sig} = "Minor";
      $music{$n}{num} = lc($numerals[$n]);
    } elsif ($pattern eq "047") {
      $music{$n}{sig} = "Major";
      $music{$n}{num} = $numerals[$n];
    } elsif ($pattern eq "048") {
      $music{$n}{sig} = "Aug +";
      $music{$n}{num} = $numerals[$n] . "+";
    } else {
      $music{$n}{sig} = "?????";
      $music{$n}{num} = $numerals[$n] . "?";
    }
  
    $n++;
  }

  return %music;
}


#
# this is the chord block diagram
#
sub chord_output {
  my (%music) = @_;

  my $input_offset = "4";

  my $input_spaces = " " x $input_offset;
  my $outstr = "$input_spaces| ";

  foreach my $chord (sort (keys %music)) {
    $outstr .= "$scale_colors{$chord}$music{$chord}{base} $music{$chord}{sig}$reset | ";
  }
  
  $outstr .= "\n$input_spaces| ";
  foreach my $chord (sort (keys %music)) {
    $outstr .= "$scale_colors{$chord}$music{$chord}{notes}$reset";
    my $padding = length("$music{$chord}{base} $music{$chord}{sig} ") - length($music{$chord}{notes});
    for (my $i=1 ; $i <= $padding ; $i++) {
      $outstr .= " ";
    }
    $outstr .= "| ";
  }
  
  $outstr .= "\n$input_spaces| ";
  foreach my $chord (sort (keys %music)) {
    my $padding = length("$music{$chord}{base} $music{$chord}{sig} ") - length($music{$chord}{num}) - 1;
    $outstr .= "$scale_colors{$chord}$music{$chord}{num}$reset ";
    for (my $i=1 ; $i <= $padding ; $i++) {
      $outstr .= " ";
    }
    $outstr .= "| ";
  }

  return $outstr;
}

#
#
# The following 5 subs are for doing regex replacements on the
# built in block diagram, based on what needs to go in it.
#
# If you have a better idea, please implement it. Until then:
# long live regex.
#
#

sub smBlock1Horiz {
  my ($txt, $fifth, $second, $seventh) = @_;
  my @cmp = @_;
  shift @cmp;
  my $len = &longestString(@cmp);
  my $fivepad = &centerStr($fifth, $len);
  my $secondpad = &centerStr($second, $len);
  my $seventhpad = &centerStr($seventh, $len);
  my $emptypad = " " x $len;
  my $bars = "━" x ($len - 3);
  my $spaces = " " x ($len - 3);
  # sed replace the text and return
  $txt =~ s/^(\s+┏)/$1$bars/mg;
  $txt =~ s/^(\s+┃) 5 ┃/$1$scale_colors{4}$fivepad$reset┃/m;
  $txt =~ s/^(\s+┃) - ┠/$1$emptypad┃/mg;
  $txt =~ s/^(\s+┗)(━┯┯┛)/$1$bars$2/m;
  $txt =~ s/^(\s{4})(?=\S)/$1$spaces/mg;
  $txt =~ s/^(\s+┃) 2 ┃/$1$scale_colors{1}$secondpad$reset┃/m;
  $txt =~ s/^(\s+┃)7\/2┠/$1$scale_colors{6}$seventhpad$reset┃/m;
  $txt =~ s/^(\s+┗)(━┯━┛)/$1$bars$2/m;
  return $txt;
}

sub smBlock2Horiz {
  my ($txt, $six, $four, $three, $root) = @_;
  my @cmp = @_;
  shift @cmp;
  my $len = &longestString(@cmp);
  my $sixpad = &centerStr($six, $len);
  my $fourpad = &centerStr($four, $len);
  my $threepad = &centerStr($three, $len);
  my $rootpad = &centerStr($root, $len);
  my $emptypad = " " x $len;
  my $bars = "━" x ($len - 3);
  my $pipes = "─" x ($len - 3);
  my $spaces = " " x ($len - 3);
  # sed replace the text and return
  $txt =~ s/^(.*?┏)(━━━┓)/$1$bars$2/mg;
  $txt =~ s/^(.*?┃) 6 ┃/$1$scale_colors{5}$sixpad$reset┃/m;
  $txt =~ s/^(.*?┨)4\/6┠/$1$scale_colors{3}$fourpad$reset┃/mg;
  $txt =~ s/^(.*?┗)(━┯━┛)/$1$bars$2/m;

  $txt =~ s/^(.*?┏)(┷┷━┓)/$1$bars$2/mg;
  $txt =~ s/^(.*?┃) 3 ┃/$1$scale_colors{2}$threepad$reset┃/m;
  $txt =~ s/^(.*?┨)1\/3┠/$1$scale_colors{0}$rootpad$reset┃/m;
  $txt =~ s/^(.*?┗)(━┯━┛)/$1$bars$2/m;

  $txt =~ s/^(.*?╰─)/$1$pipes/m;
  $txt =~ s/^(.*?△\s+)(▽△)/$1$spaces$2/m;
  $txt =~ s/^(\s+▽)/$1$spaces/m;
  $txt =~ s/^(\s+╰)/$1$pipes/m;
  return $txt;
}

sub smBlock3Horiz {
  my ($txt, $two, $seven, $four, $second) = @_;
  my @cmp = @_;
  shift @cmp;
  my $len = &longestString(@cmp);
  my $twopad = &centerStr($two, $len);
  my $sevenpad = &centerStr($seven, $len);
  my $fourpad = &centerStr($four, $len);
  my $secondpad = &centerStr($second, $len);
  my $emptypad = " " x $len;
  my $bars = "━" x ($len - 3);
  my $pipes = "─" x ($len - 3);
  my $spaces = " " x ($len - 3);
  # sed replace the text and return
  $txt =~ s/^(.*?┏)(━━━┓)/$1$bars$2/mg;
  $txt =~ s/^(.*?┃) 2 ┃/$1$scale_colors{1}$twopad$reset┃/m;
  $txt =~ s/^(.*?┨)7\/2┠/$1$scale_colors{6}$sevenpad$reset┃/mg;
  $txt =~ s/^(.*?┗)(━┯┯┛)/$1$bars$2/m;

  $txt =~ s/^(.*?┏)(━┷━┓)/$1$bars$2/mg;
  $txt =~ s/^(.*?┃) 4 ┠/$1$scale_colors{3}$fourpad$reset┃/m;
  $txt =~ s/^(.*?┨)2\/4┠/$1$scale_colors{1}$secondpad$reset┃/m;
  $txt =~ s/^(.*?┗)(━┯━┛)/$1$bars$2/m;
  
  $txt =~ s/^(.*?)(│╰▷)/$1$spaces$2/m;
  $txt =~ s/^(.*?)(△   │)/$1$spaces$2/m;
  $txt =~ s/^((?:\s+▽){2})/$1$spaces/m;
  $txt =~ s/^(\s+╰─+┴)/$1$pipes/m;
  return $txt;
}

sub smBlock4Horiz {
  my ($txt, $root, $five) = @_;
  my @cmp = @_;
  shift @cmp;
  my $len = &longestString(@cmp);
  my $rootpad = &centerStr($root, $len);
  my $fivepad = &centerStr($five, $len);
  my $emptypad = " " x $len;
  my $bars = "━" x ($len - 3);
  my $pipes = "─" x ($len - 3);
  my $spaces = " " x ($len - 3);
  # sed replace the text and return
  $txt =~ s/^(.*?┏)(━━━┓)/$1$bars$2/mg;
  $txt =~ s/^(.*?┃) - ┃/$1$emptypad┃/mg;
  $txt =~ s/^(.*?┨)1\/5┃/$1$scale_colors{0}$rootpad$reset┃/mg;
  $txt =~ s/^(.*?┺)(━┯━┛)/$1$bars$2/m;

  $txt =~ s/^(.*?┏)(┷┷━┓)/$1$bars$2/mg;
  $txt =~ s/^(.*?┨) 5 ┠/$1$scale_colors{4}$fivepad$reset┃/m;
  $txt =~ s/^(.*?┗)(━━━┛)/$1$bars$2/m;

  $txt =~ s/^(.*?┼)/$1$pipes/m;
  $txt =~ s/^(.*?)(▽▽)/$1$spaces$2/m;
  $txt =~ s/^(.*?─{5})(╯)/$1$pipes$2/m;
  $txt =~ s/^(.*?)(△\s+$)/$1$spaces$2/m;
  return $txt;
}

sub smBlock5Horiz {
  my ($txt, $four, $five, $root) = @_;
  my @cmp = @_;
  shift @cmp;
  my $len = &longestString(@cmp); 
  my $fourpad = &centerStr($four, $len);
  my $fivepad = &centerStr($five, $len);
  my $rootpad = &centerStr($root, $len);
  my $emptypad = " " x $len;
  my $bars = "━" x ($len - 3);
  my $pipes = "─" x ($len - 3);
  my $spaces = " " x ($len - 3);
  # sed replace the text and return
  $txt =~ s/^(.*?┏)(━━━┓)/$1$bars$2/mg;
  $txt =~ s/^(.*?┃)4\/1┃/$1$scale_colors{3}$fourpad$reset┃/mg;
  $txt =~ s/^(.*?┃)5\/1┃/$1$scale_colors{4}$fivepad$reset┃/mg;
  $txt =~ s/^(.*?┗┯┯)(━┛)/$1$bars$2/m;

  $txt =~ s/^(.*?┏┷┷)(━┓)/$1$bars$2/mg;
  $txt =~ s/^(.*?┃) - ┃/$1$emptypad┃/m;
  $txt =~ s/^(.*?┨) 1 ┃/$1$scale_colors{0}$rootpad$reset┃/m;
  $txt =~ s/^(.*?┗━┯)(━┛)/$1$bars$2/m;
  return $txt;
}

sub SteveMugglinProgressionBlockFlat {
  # TODO color
  my ($chordRef, $noteRef) = @_;
  # should be references to arrays of text in the right order
  my @chords = @{$chordRef};
  my @notes = @{$noteRef};
  my $minWidth = 3;
  my @txt;
  # NOTE Do not adjust this without adjusting the regexen in the supporting subs
  my $txtRef = <<"  EOF";
  ┏━━━┓   ┏━━━┓    ┏━━━┓   ┏━━━┓   ┏━━━┓
  ┃ 5 ┃   ┃ 6 ┃    ┃ 2 ┃   ┃ - ┃   ┃4/1┃
  ┃ - ┠─▷─┨4/6┠──▷─┨7/2┠─▷─┨1/5┃   ┃5/1┃
  ┗━┯┯┛   ┗━┯━┛    ┗━┯┯┛ ╭─┺━┯━┛   ┗┯┯━┛
    │╰─────╮│        │╰▷─┼──╮│      ││  
    △      ▽△        △   │  ▽▽      △▽  
  ┏━┷━┓   ┏┷┷━┓    ┏━┷━┓ △ ┏┷┷━┓   ┏┷┷━┓
  ┃ 2 ┃   ┃ 3 ┃    ┃ 4 ┠─╯ ┃ - ┃   ┃ - ┃
  ┃7/2┠─▷─┨1/3┠──▷─┨2/4┠─▷─┨ 5 ┠─▷─┨ 1 ┃
  ┗━┯━┛   ┗━┯━┛    ┗━┯━┛   ┗━━━┛   ┗━┯━┛
    ▽       ▽        ▽               △  
    ╰───────┴────────┴───────────────╯  
  EOF

  my $newtxt = &smBlock1Horiz($txtRef, $chords[4], $chords[1], $chords[6] . "/" . $notes[1]);
  $newtxt = &smBlock2Horiz($newtxt, $chords[5], $chords[4] . "/" . $notes[5] , $chords[2], $chords[0] . "/" . $notes[2]);
  $newtxt = &smBlock3Horiz($newtxt, $chords[1], $chords[6] . "/" . $notes[1] , $chords[4], $chords[1] . "/" . $notes[3]);
  $newtxt = &smBlock4Horiz($newtxt, $chords[0] . "/" . $notes[4], $chords[4]);
  $newtxt = &smBlock5Horiz($newtxt, $chords[3] . "/" . $notes[0], $chords[4] . "/" . $notes[0], $chords[0]);

  return $newtxt;
}

# TODO unused sub, remove?
sub SteveMugglinProgressionBlock {
  my ($chordRef, $noteRef) = @_;
  # chordRef = array of strings "E Minor" or "iim"
  # noteRef = array of strings of notes of that scale, E, F#, etc
  # this will have to find the longest possible string, and use that
  # length logic for padding the boxes
  my $txt = <<"  EOF";
   ┏━━━┓   ┏━━━┓
   ┃ 2 ┃   ┃ 5 ┃
  ╭┨7/2┠─▷─┨   ┃
  │┗━┯━┛   ┗┯┯━┛
  ▽  │╭─────╯│
  │  ▽▽      ▽
 ╭╯┏━┷┷┓   ┏━┷━┓
 │ ┃ 3 ┃   ┃ 6 ┃
 │╭┨1/3┠─▷─┨4/6┃
 ││┗━┯━┛   ┗┯┯━┛
 │▽  │╭─────╯│
 ││  ▽▽      ▽
 ├╯┏━┷┷┓   ┏━┷━┓
 │ ┃ 4 ┃   ┃ 2 ┃
 │╭┨2/4┠─▷─┨7/2┃
 ││┗━┯┯┛ ╭─┺━┯━┛
 │▽  │╰──┼──╮│
 ││  ▽╭◁─╯  ▽▽
 ├╯┏━┷┷┓   ┏┷┷━┓
 │╭┨ 5 ┠─◁─┨1/5┃
 ││┗━┯━┛   ┗━━━┛
 │▽  ▽ 
 ├╯┏━┷━┓   ┏━━━┓
 ╰─┨ 1 ┠─▷─┨4/1┃
   ┃   ┠─◁─┨5/1┃
   ┗━━━┛   ┗━━━┛
  EOF
  #say $txt;
}


sub relation_block {
  my ($musicRef, $scaleRef) = @_;
  my %music = %{$musicRef};
  my %h;
  for my $num (sort keys %music) {
    $h{$num} = "    ";
    my $len = length($music{$num}{num});
    $h{$num} =~ s/.{$len}$/$music{$num}{num}/;
  }
  my @chords = ($h{0}, $h{1}, $h{2}, $h{3}, $h{4}, $h{5}, $h{6});  
  my $prog = &SteveMugglinProgressionBlockFlat(\@chords, $scaleRef);
  chomp $prog;
  return split(/\n/, $prog);
}


# TODO this needs better handling in 8 note scales
sub relation_name_block {
  my ($musicRef, $scaleRef) = @_;
  my %music = %{$musicRef};
  my $one = $music{0}{base} . " " . $music{0}{sig};
  my $two = $music{1}{base} . " " . $music{1}{sig};
  my $three = $music{2}{base} . " " . $music{2}{sig};
  my $four = $music{3}{base} . " " . $music{3}{sig};
  my $five = $music{4}{base} . " " . $music{4}{sig};
  my $six = $music{5}{base} . " " . $music{5}{sig};
  my $seven = $music{6}{base} . " " . $music{6}{sig};
  my @chords = ($one, $two, $three, $four, $five, $six, $seven);
  my $prog = &SteveMugglinProgressionBlockFlat(\@chords, $scaleRef);
  chomp $prog;
  return split(/\n/, $prog);
}


# take the info and spit it out in a useful way
sub output_data {
  my ($scale_ref, $music_ref) = @_;
  my @scale_notes = @{$scale_ref};
  my %music = %{$music_ref};
  my $scale_str;
  for my $idx (0..$#scale_notes) {
    $scale_str .= $scale_colors{$idx} . $scale_notes[$idx] . $reset . " ";
  }
  my $prog_str;

  foreach my $chord (0..6) {
    $prog_str.= $scale_colors{$chord} . $music{$chord}{num} . $reset . " ";
  }

  my $chord_block = &chord_output(%music);

  # for progression notation
  my @notes = 1..10;
  my @relation_arr = &relation_block(\%music, \@notes);
  unshift(@relation_arr, "Tonal Relationships");

  my @relation_name_arr = &relation_name_block(\%music, $scale_ref);
  unshift(@relation_name_arr, "Chord Progression");

  if (! defined $in_mode) {
    $in_mode = ($user_scale_name) ? $user_scale_name : "User provided scale" ;
  }

  # TODO 8 tone scales should be pinned against their closest 7 tone scale
  # IE D bebop minor, D dorian.
  my $output = << "  ENDOUT";

  $in_key  -  $in_mode
  
  Scale Notes:   $scale_str

  Progression:   $prog_str

  Chords:

$chord_block

Chords in X/Y notation are chord X with root/base note Y
  ENDOUT

  chomp $output;
  say $output;

  if ($condense_boards) {
    my @progArr = (\@relation_arr, \@relation_name_arr);
    &column_color_txt_arr(\@progArr, "      ");
  } else {
    map {say} @relation_arr;
    say "";
    map {say} @relation_name_arr;
  }

}

# 
# 
# 
# Guitar stuff 
# 
# 
#
  
#
# TODO this function is a bit long and could use some finesse
#

sub get_guitar_boards {
  my ($scale_ref, $music_ref) = @_;
  my @scale_notes = @{$scale_ref};
  my %music = %{$music_ref};
  my @fingerboards;

  my @repeat_notes = @notes;
  push(@repeat_notes, @notes);
  my $nextKey = scalar keys %music;
  $music{$nextKey}{notes} = join" ", @scale_notes;
  $music{$nextKey}{base} = $in_key;
  $music{$nextKey}{sig} = $in_mode;

  for my $chord (sort keys %music) {
    my $chord_notes = $music{$chord}{notes};
    my @chord_notes = split(/\s+/, $chord_notes);
    my @print_arr;
    for my $tuning_key (@guitar_tuning) {
      my $string;
      # rotate note array left for each tuning key
      my ($tuning_index) = grep {$tuning_key eq $repeat_notes[$_]} 0..$#repeat_notes; 
      my @note_shift = &rotate_array_left($tuning_index, @repeat_notes);

      for my $fret (0..$max_fret_number) {
        my $difference = $fret_width - length $note_shift[$fret];
        my $diffstr = "-" x $difference;
        my $matched = 0;
        if (scalar @chord_notes == 3) {
          for my $i (0..2) {
            if ($note_shift[$fret] eq $chord_notes[$i]) {
              my $colors;
              if ($static_triad_colors) {
                $colors = $scale_colors{$i * 2};
              } else {
                my $idx = &array_search($chord_notes[$i], @scale_notes);
                $colors = $scale_colors{$idx};
              }
              $matched = 1;
              if (! defined $colors) {
                &warn("Got bad stuff from fret " . ($fret + 1) . " and note " . $chord_notes[$i] . " with scale notes: " . join",",@scale_notes);
              }
              $string .= $colors . $note_shift[$fret] . $reset . $diffstr . "|";
            }
          }
        } else {
          for my $i (0..$#scale_notes) {
            if ($note_shift[$fret] eq $chord_notes[$i]) {
              $matched = 1;
              $string .= $scale_colors{$i} . $note_shift[$fret] . $reset . $diffstr . "|";
            }
          }
        }
        $string .= "-" x $fret_width . "|" if $matched == 0;
      }
      unshift(@print_arr, $string);
    }
    my $number_str;
    for my $i (0..$max_fret_number) {
      my $difference = $fret_width - length($i);
      my $diffstr = " " x ($difference + 1);
      if (grep {$i == $_} @highlight_frets) {
        $number_str .= $fret_color . $i . $reset . $diffstr;
      } else {
        $number_str .= $i . $diffstr;
      }
    }
    unshift(@print_arr, $number_str);
    unshift(@print_arr, "$scale_colors{$chord}$music{$chord}{base} $music{$chord}{sig} - $music{$chord}{notes}$reset");
    unshift(@print_arr, "");
    push (@fingerboards, \@print_arr);
  }
  return @fingerboards;
}


sub print_boards {
  my @fingerboards = @_;
  if ($condense_boards) {
    &column_color_txt_arr(\@fingerboards, "    ");
  } else {
    for my $aref (@fingerboards) {
      my @arr = @{$aref};
      map {say} @arr;
      say "";
    }
  }
}

#
#
# Keyboard stuff
#
#

sub top_line_pattern {
  my $return;
  $return .= $start_white_keys;
  for (1..$octaves) {
    $return .= $two_black_keys; 
    $return .= $two_white_keys;
    $return .= $three_black_keys;
    $return .= $two_white_keys;
  }
  $return .= " $reset";
}


sub getFgBgColor {
  my ($idx) = @_;
  return ($color_backgrounds{$idx}, $color_font_bg_correlator{$idx});
}

sub getFgBgColor_old {
  my ($color) = @_;
  if ($color =~ /$ansiColorRegex/g) {
    my $colorBase = $1;

    if (! defined $colorBase) {
      # yellow?
      say "failed to do the thing on $color";
      return($color_backgrounds{"33m"}, $color_font_bg_correlator{"33m"});
    }
    if (exists $color_backgrounds{$colorBase} && exists $color_font_bg_correlator{$colorBase}) {
      return ($color_backgrounds{$colorBase}, $color_font_bg_correlator{$colorBase});
    }
  }
}

sub mid_line_pattern {
  my ($noteArrRef, $colorArrRef, $scaleNotesRef) = @_;
  my @scale = @{$scaleNotesRef};
  my @noteArr = @{$noteArrRef};
  my @noteColors = @{$colorArrRef};
  my $line = &top_line_pattern;
  my $ret;
  my @notes = @kbdFullNotes;
  while ($line =~ /(?:(\S*?)(\s+))/g) {
    my $matchText = $1;
    my $matchSpaces = $2;
    my $note = shift @notes;
    if (grep {$note eq $_} @noteArr) {
      my $colorIndex = &array_search($note, @scale);
      my ($bgColor, $fgColor) = &getFgBgColor($colorIndex);
      my $colorSet = $fgColor . $bgColor;
      my $localKeyWidth = $keyWidth;
      $localKeyWidth = length $matchSpaces;# if length $matchSpaces == 1;
      my $text = " " x $localKeyWidth;
      my $startSpaces = int($localKeyWidth / 2);
      $startSpaces++ if $startSpaces == 0;
      $text =~ s/( ){$startSpaces}(.*)/$1$note$2/ if $note =~ /[#b]$/;
      $text =~ s/(.{$localKeyWidth}).*/$1/;
      #$ret .= $matchText . $colorSet . $text;
      #$ret .= $colors{BLACK} . $matchText . $colorSet . $text . $colors{BLACK};
      $ret .= $colors{BLACK} . $matchText . $colorSet . $text . $colors{BLACK};
    } else {
      # just default stuff
      my $colorSet = $piano_keys{$note}{COLOR} . $piano_keys{$note}{BGCOLOR};
      $ret .= $colors{BLACK} . $colorSet . $matchText . " " x length($matchSpaces);
    }
  }
  $ret .= $reset;
  return $ret;
}

sub bottom_line_pattern {
  my ($noteAref, $colorAref, $scaleNotesRef) = @_;
  my @scale = @{$scaleNotesRef};
  my @noteHighlight = @{$noteAref};
  my @noteColors = @{$colorAref};
  my @notes = grep {$_ !~ /[#b]$/} @kbdFullNotes;
  my $ret = "$colors{BLACK}$colors{BGWHITE}";
  my $i = 0;
  for (1..$octaves * 7 + 2) {
    my $note = shift @notes;
    if (grep {$note eq $_} @noteHighlight) {
      my $colorIndex = &array_search($note, @scale);
      my ($bgColor, $fgColor) = &getFgBgColor($colorIndex);
      my $colorSet = $fgColor . $bgColor;
      my $text = " " x $keyWidth;
      my $startSpaces = int($keyWidth / 2);
      $startSpaces++ if $startSpaces == 0;
      $text =~ s/( ){$startSpaces}(.*)/$1$note$2/;
      $text =~ s/(.{$keyWidth}).*/$1/;
      if ($i > 0) {
        $ret .= $vert_bar . $colorSet . $text;
      } else {
        $ret .= $colorSet . $text;
      }
    } else {
      # normal note
      my $colorSet = $piano_keys{$note}{COLOR} . $piano_keys{$note}{BGCOLOR};
      if ($i > 0) {
        $ret .= $colorSet . $vert_bar . " " x $keyWidth;
      } else {
        $ret .= $colorSet . " " x $keyWidth;
      }
    } 
    $i++;
  }
  $ret .= $reset;
  return $ret;
}

sub show_keyboards {
  my ($noteRef, $musicRef) = @_;
  my @text = &gen_keyboards($noteRef, $musicRef);
  if ($condense_boards) {
    &column_color_txt_arr(\@text, "    ");
  } else {
    for my $board (@text) {
      map {say} @{$board};
    }
  }
}

sub gen_one_keyboard {
  my ($top, $mid, $bottom) = @_;
}

sub gen_keyboards {
  my ($noteRef, $musicRef) = @_;
  my @scaleNotes = @{$noteRef};
  my %music = %{$musicRef};
  my @txt_arr;
  for my $key (sort keys %music) {
    my @txt;
    my @chordNotes = split(/\s+/, $music{$key}{notes});
    my @colors;
    if ($static_triad_colors) {
      @colors = ($scale_colors{0},$scale_colors{2},$scale_colors{4});
    } else {
      my $idxA = &array_search($chordNotes[0], @scaleNotes);
      my $idxB = &array_search($chordNotes[1], @scaleNotes);
      my $idxC = &array_search($chordNotes[2], @scaleNotes);
      @colors = ($scale_colors{$idxA}, $scale_colors{$idxB}, $scale_colors{$idxC});
    }
    my $top_line = &top_line_pattern;
    my $mid_line = &mid_line_pattern(\@chordNotes, \@colors, \@scaleNotes);
    my $bottom_line = &bottom_line_pattern(\@chordNotes, \@colors, \@scaleNotes);

    push(@txt, "");
    push(@txt, $scale_colors{$key} . $music{$key}{base} . " " . $music{$key}{sig} . $reset);
    push(@txt, $top_line) for 1..1;
    push(@txt, $mid_line) for 1..3;
    push(@txt, $bottom_line) for 1..3;
    push(@txt_arr, \@txt);
  }
  {
    my @colors = map {$scale_colors{$_}} sort keys %scale_colors;
    my @txt;
    push(@txt, "");
    push(@txt, "Key: " . $music{0}{base} . " - Scale: " . $in_mode);
    push(@txt, &top_line_pattern) for 1..1;
    push(@txt, &mid_line_pattern(\@scaleNotes, \@colors, \@scaleNotes)) for 1..3;
    push(@txt, &bottom_line_pattern(\@scaleNotes, \@colors, \@scaleNotes)) for 1..3;
    push(@txt_arr, \@txt);
  }
  return (@txt_arr);
}

# 
# 
# 
# Main
# 
# 
# 

sub main {
  &handle_args;
  my @scale_notes = &shift_scales;
  my @progression = &find_progression(@scale_notes);
  my %music = &find_tonality(@progression);
  #say Dumper(\%music);
  &output_data(\@scale_notes, \%music);
  if ($show_fingerboard) {
    my @fboard = &get_guitar_boards(\@scale_notes, \%music);
    &print_boards(@fboard);
  }
  if ($show_keyboard) {
    &show_keyboards(\@scale_notes, \%music);
  }
}



&main;
