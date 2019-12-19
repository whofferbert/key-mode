#!/usr/bin/env perl
# by William Hofferbert
# a script to get information about musical scales

use 5.010;				# say
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
# TODO flats optional instead of sharps?

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
  #''	=> [], 
);

# numerals for chart representations
my @numerals = qw (I II III IV V VI VII);

# guitar options...
my ($show_fingerboard, $condense_boards);
my $fret_width = 3;
my $max_fret_number = 15;
my @guitar_tuning = ("E", "A", "D", "G", "B", "E");
my @highlight_frets = qw(0 3 5 7 9 12 15);

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

my %scale_colors = (
  '0' => $colors{BRED},
  '1' => $colors{BBLACK},
  '2' => $colors{BYELLOW},
  '3' => $colors{BBLUE},
  '4' => $colors{BGREEN},
  '5' => $colors{BMAJENTA},
  '6' => $colors{BCYAN},
);

my $fret_color = $colors{BWHITE};

# expected input vars
my ($in_key, $in_mode, @in_steps, $user_scale_name);

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

Usage:
  $prog -key [note] -mode [mode]
  $prog -key [note] -steps ["quoted pattern"]

  Key:
    [note] can be any of:
    @notes

  Mode:
    [mode] can be any of: Major, Minor,
    $mode_str

  Steps:
    ["quoted pattern"] can consist of any quoted and space
    delimited set of 7 numbers which add up to 12, to allow
    for extrapolation of non-built in modes.

Additional Options

  -name ["Scale Name"]
    Scale Name can be any quoted string.
    Provides the name to display when using a custom Step signature

  -fingerboards
    For each chord in the scale, print a representation of a guitar
    figerboard, with the notes displayed

  -guitar-tuning ["Open Notes"]
    Open notes can be any quoted list of notes, low to high.
    Not limited to 6 strings.
    Default is "E A D G B E"

  -color-1 [COLOR] ... -color-7 [COLOR]
    Assign a specific color to the given notes, when drawing the 
    guitar fingerboard patterns. 
    -color-1 is the root, -color-3 is the third, etc.
    Colors may be any of:
      $color_str

  -condense-boards
    Print the guitar fingerboards in multiple columns
    Good for running with a wide terminal

Examples:

  Get info on A Dorian
    $prog -key A -mode dorian

  Get info on E Aeolian, along with fretboard note positions
    $prog -key E -mode Aeolian -fingerboards

  Get info about a user-provided scale
    $prog -key E -steps "1 3 1 2 1 2 2" -name "Super Locrian"
 
  Get info and fingerboard patterns for an 8 string guitar with weird tuning:
    $prog -key B -mode Mixolydian -fingerboards -guitar-tuning "E A D A D G B E"
 
  END_USAGE

  chomp $usage;
  say "$usage";
  exit(0);
}

sub check_required_args {		# handle leftover @ARGV stuff here if need be
  &err("Invalid Key! Must be one of: " . join", ", @notes) unless defined $in_key;
  &err("Invalid Key! Must be one of: " . join", ", @notes) unless grep {$in_key eq $_} @notes;
  if (! $in_mode && ! @in_steps) {
    &helps;
  }
  if (defined $in_mode) {
    unless (grep {$in_mode =~ /^$_$/i} keys %mode_hash) {
      &err("$prog requires a valid -key");
    }
  } else {
    &err("$prog requires a valid -key");
  }
  if (@in_steps) {
    &err("Unexpected number of steps in -steps!") unless scalar @in_steps == 7;
    &err("Steps don't add up to 12!") unless (eval join"+",@in_steps) == 12;
  }
}

sub parse_insteps {
  my $steps = $_[1];
  push (@in_steps, split(/\s+/, $steps));
  return(@in_steps);
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
    'key=s' => \$in_key,
    'mode=s' => \$in_mode,
    'steps=s' => \&parse_insteps,
    'name=s' => \$user_scale_name,
    'fingerboards' => \$show_fingerboard,
    'guitar-tuning=s' => \&parse_tuning,
    'color-1=s' => sub {&parse_colors(0, $_[1])},
    'color-2=s' => sub {&parse_colors(1, $_[1])},
    'color-3=s' => sub {&parse_colors(2, $_[1])},
    'color-4=s' => sub {&parse_colors(3, $_[1])},
    'color-5=s' => sub {&parse_colors(4, $_[1])},
    'color-6=s' => sub {&parse_colors(5, $_[1])},
    'color-7=s' => sub {&parse_colors(6, $_[1])},
    'condense-boards' => \$condense_boards,
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

sub rotate_array_left {
  my ($amount, @array) = @_;
  for (my $i=0 ; $i < $amount ; $i++) { 
    my $pos1 = shift @array;
    push (@array, $pos1);
  }
  return (@array);
}

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
    $chord[0] = $adj_notes[0];
    $chord[1] = $adj_notes[2];
    $chord[2] = $adj_notes[4];
  
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
    my $first_note_degree;
    for (my $i=0 ; $i <= $#notes ; $i++) {
      $first_note_degree = $i if ($notes[$i] eq $first_note)
    }
  
    my @adj_scale = &rotate_array_left($first_note_degree, @notes);
  
    my $pattern;
    my $chord_notes;
    foreach my $note (@{$chord}){
      my $note_degree;
      for (my $i=0 ; $i <= $#adj_scale ; $i++) {
        $note_degree = $i if ($adj_scale[$i] eq $note)
      }
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

sub chord_output {
  my (%music) = @_;

  my $input_offset = "4";

  my $input_spaces = " " x $input_offset;
  my $outstr = "$input_spaces| ";

  foreach my $chord (sort (keys %music)) {
    $outstr .= "$music{$chord}{base} $music{$chord}{sig} | ";
  }
  
  $outstr .= "\n$input_spaces| ";
  foreach my $chord (sort (keys %music)) {
    $outstr .= "$music{$chord}{notes}";
    my $padding = length("$music{$chord}{base} $music{$chord}{sig} ") - length($music{$chord}{notes});
    $padding-- if ($music{$chord}{sig} eq "Dim °");
    for (my $i=1 ; $i <= $padding ; $i++) {
      $outstr .= " ";
    }
    $outstr .= "| ";
  }
  
  $outstr .= "\n$input_spaces| ";
  foreach my $chord (sort (keys %music)) {
    my $padding = length("$music{$chord}{base} $music{$chord}{sig} ") - length($music{$chord}{num}) - 1;
    $outstr .= "$music{$chord}{num} ";
    for (my $i=1 ; $i <= $padding ; $i++) {
      $outstr .= " ";
    }
    $outstr .= "| ";
  }

  return $outstr;
}

sub relation_block {
  my (%music) = @_;

  my $pad = "    ";
  my %h;
  for my $num (sort keys %music) {
    $h{$num} = $pad;
    my $len = length($music{$num}{num});
    $h{$num} =~ s/.{$len}$/$music{$num}{num}/;
  }

  my $prog = <<"  END_PROG";
                           $h{3}  -- $h{6}
    $h{6} -> $h{2} -> $h{5} <       ><       > $h{0}
                            $h{1}  -- $h{4}
  END_PROG
  chomp $prog;
  return $prog;
}

sub relation_name_block {
  my (%music) = @_;
  say Dumper(\%music);

  my $sp = " " x 7;

  my $one = $music{0}{base} . " " . $music{0}{sig};
  my $two = $music{1}{base} . " " . $music{1}{sig};
  my $three = $music{2}{base} . " " . $music{2}{sig};
  my $four = $music{3}{base} . " " . $music{3}{sig};
  my $five = $music{4}{base} . " " . $music{4}{sig};
  my $six = $music{5}{base} . " " . $music{5}{sig};
  my $seven = $music{6}{base} . " " . $music{6}{sig};


  my $prog = <<"  END_PROG";
    $sp       $sp            $four  --  $seven 
    $seven -> $three -> $six <  $sp  ><  $sp  > $one
    $sp       $sp            $two  --  $five 
  END_PROG
  chomp $prog;
  return $prog;
}




# take the info and spit it out in a useful way
sub output_data {
  my ($scale_ref, $music_ref) = @_;
  my @scale_notes = @{$scale_ref};
  my %music = %{$music_ref};

  my $scale_str = join" ", @scale_notes;

  my $prog_str;
  foreach my $chord (0..6) {
    $prog_str.= $music{$chord}{num} . " ";
  }

  my $chord_block = &chord_output(%music);
  my $relation_block = &relation_block(%music);
  my $relation_name_block = &relation_name_block(%music);

  #$in_mode ||= "User provided scale";
  if (! defined $in_mode) {
    $in_mode = ($user_scale_name) ? $user_scale_name : "User provided scale" ;
  }

  my $output = << "  ENDOUT";

  $in_key  -  $in_mode
  
  Scale Notes:   $scale_str

  Progression:   $prog_str

  Chords:

$chord_block
  
  Progression Chart:

$relation_block

$relation_name_block

  ENDOUT
  chomp $output;
  say $output;
}


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
  $music{7}{notes} = join" ", @scale_notes;
  $music{7}{base} = $in_key;
  $music{7}{sig} = $in_mode;

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
              $matched = 1;
              $string .= $scale_colors{$i * 2} . $note_shift[$fret] . $reset . $diffstr . "|";
            }
          }
        } else {
          for my $i (0..6) {
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
    unshift(@print_arr, "$music{$chord}{base} $music{$chord}{sig} - $music{$chord}{notes}");
    push (@fingerboards, \@print_arr);
  }
  return @fingerboards;
}


sub print_boards {
  my @fingerboards = @_;
  if ($condense_boards) {
    # making pairs of boards
    while (scalar(@fingerboards)) {
      my $one = shift @fingerboards;
      my $two = shift @fingerboards;
      if ($two) {
        my @one = @{$one};
        my @two = @{$two};
        # mash the two arrays together for printing.
        my $buffer = 8;
        # cannot rely on length() here, due to ANSI color escapes.
        my $width = ($fret_width + 1) * ($max_fret_number + 1);
        my $title_length = length($one[0]);
        # accounting for unicode bs...
        $title_length-- if $one[0] =~ /°/;
        my $title_buffer = " " x ($width + $buffer - $title_length);
        my $line_buffer = " " x $buffer;
        say $one[0] . $title_buffer . $two[0];
        for (1..$#one) {
          say $one[$_] . $line_buffer . $two[$_];
        }
        say "";
      } else {
        map {say} @$one;
        say "";
      }
    }
  } else {
    for my $aref (@fingerboards) {
      my @arr = @{$aref};
      map {say} @arr;
      say "";
    }
  }
}


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
}



&main;

