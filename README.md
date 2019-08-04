# key-mode

This is a perl utility which can print helpful information about scales
and progressions, based on input key and mode.

Custom step patterns can be provided, to get info on non-built-in scales.

The help text is referenced here for clarity:

```bash
$ ./key-mode -help

  This script can print out information about progressions
  and chord relationships, based on an input key and mode.

  Additionally, you can provide your own step pattern and key
  if desired.

Usage:
  key-mode -key [note] -mode [mode]
  key-mode -key [note] -steps ["quoted pattern"]

  Key:
    [note] can be any of:
    A A# B C C# D D# E F F# G G#

  Mode:
    [mode] can be any of:
    Ionian Dorian Phrygian Lydian Mixolydian Aeolian Locrian

  Steps:
    ["quoted pattern"] can consist of any quoted and space
    elimited set of numbers which adds up to 12, to allow
    for extrapolation of non-built in modes.

Additional Options

  -name ["Scale Name"]
    Scale Name can be any quoted string.
    Provides the name to display when using a custom Step signature

  -guitar-possibilities
    For each chord in the scale, print a representation of a guitar
    figerboard, with the notes displayed

  -guitar-tuning ["Open Notes"]
    Open notes can be any quoted list of notes, low to high.
    Default is "E A D G B E"

  -root-color [COLOR]
    Default is BRED
  -third-color [COLOR]
    Default is BYELLOW
  -fifth-color [COLOR]
    Default is BGREEN

    Assign a specific color to the root/third/fifth notes, when
    drawing the guitar fingerboard patterns.
    Colors may be any of:
      DEFAULT, BOLD, BLACK, RED, BLUE, YELLOW, GREEN, 
      MAJENTA, CYAN, WHITE, BBLACK, BRED, BBLUE, BYELLOW, 
      BGREEN, BMAJENTA, BCYAN, BWHITE, BGDEFAULT, BGBLACK, BGRED, 
      BGBLUE, BGYELLOW, BGGREEN, BGMAJENTA, BGCYAN, BGWHITE

  -condense-boards
    Print the guitar fingerboards in multiple columns

Examples:

  key-mode -key A -mode dorian

  key-mode -key E -steps "1 3 1 2 1 2 2" -name "Super Locrian"
 
```

# Runtime Examples
## A Phrygian, from built in scales

```bash
$ ./key-mode -key A -mode Phrygian

  A  -  Phrygian
  
  Scale Notes:   A A# C D E F G

  Progression:   i II III iv v° VI vii 

  Chords:

    | A Minor | A# Major | C Major | D Minor | E Dim ° | F Major | G Minor | 
    | A C E   | A# D F   | C E G   | D F A   | E G A#  | F A C   | G A# D  | 
    | i       | II       | III     | iv      | v°      | VI      | vii     | 
  
  Progression Chart:

                         iv  -  vii
    vii -> III -> VI <      ><       > i
                         II  -  v°

```

## E Super Locrian, provided at the CLI

```bash
$ ./key-mode -steps "1 3 1 2 1 2 2" -key E -name "Super Locrian" -guitar-poss

  E  -  Super Locrian
  
  Scale Notes:   E F G# A B C D

  Progression:   I II iii° iv v° VI+ vii 

  Chords:

    | E Major | F Major | G# Dim ° | A Minor | B Dim ° | C Aug + | D Minor | 
    | E G# B  | F A C   | G# B D   | A C E   | B D F   | C E G#  | D F A   | 
    | I       | II      | iii°     | iv      | v°      | VI+     | vii     | 
  
  Progression Chart:

                         iv  -  vii
    vii -> iii° -> VI+ <      ><       > I
                         II  -  v°

E Major - E G# B 
0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  
E--|---|---|---|G#-|---|---|B--|---|---|---|---|E--|---|---|---|
B--|---|---|---|---|E--|---|---|---|G#-|---|---|B--|---|---|---|
---|G#-|---|---|B--|---|---|---|---|E--|---|---|---|G#-|---|---|
---|---|E--|---|---|---|G#-|---|---|B--|---|---|---|---|E--|---|
---|---|B--|---|---|---|---|E--|---|---|---|G#-|---|---|B--|---|
E--|---|---|---|G#-|---|---|B--|---|---|---|---|E--|---|---|---|

F Major - F A C 
0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  
---|F--|---|---|---|A--|---|---|C--|---|---|---|---|F--|---|---|
---|C--|---|---|---|---|F--|---|---|---|A--|---|---|C--|---|---|
---|---|A--|---|---|C--|---|---|---|---|F--|---|---|---|A--|---|
---|---|---|F--|---|---|---|A--|---|---|C--|---|---|---|---|F--|
A--|---|---|C--|---|---|---|---|F--|---|---|---|A--|---|---|C--|
---|F--|---|---|---|A--|---|---|C--|---|---|---|---|F--|---|---|

G# Dim ° - G# B D 
0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  
---|---|---|---|G#-|---|---|B--|---|---|D--|---|---|---|---|---|
B--|---|---|D--|---|---|---|---|---|G#-|---|---|B--|---|---|D--|
---|G#-|---|---|B--|---|---|D--|---|---|---|---|---|G#-|---|---|
D--|---|---|---|---|---|G#-|---|---|B--|---|---|D--|---|---|---|
---|---|B--|---|---|D--|---|---|---|---|---|G#-|---|---|B--|---|
---|---|---|---|G#-|---|---|B--|---|---|D--|---|---|---|---|---|

A Minor - A C E 
0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  
E--|---|---|---|---|A--|---|---|C--|---|---|---|E--|---|---|---|
---|C--|---|---|---|E--|---|---|---|---|A--|---|---|C--|---|---|
---|---|A--|---|---|C--|---|---|---|E--|---|---|---|---|A--|---|
---|---|E--|---|---|---|---|A--|---|---|C--|---|---|---|E--|---|
A--|---|---|C--|---|---|---|E--|---|---|---|---|A--|---|---|C--|
E--|---|---|---|---|A--|---|---|C--|---|---|---|E--|---|---|---|

B Dim ° - B D F 
0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  
---|F--|---|---|---|---|---|B--|---|---|D--|---|---|F--|---|---|
B--|---|---|D--|---|---|F--|---|---|---|---|---|B--|---|---|D--|
---|---|---|---|B--|---|---|D--|---|---|F--|---|---|---|---|---|
D--|---|---|F--|---|---|---|---|---|B--|---|---|D--|---|---|F--|
---|---|B--|---|---|D--|---|---|F--|---|---|---|---|---|B--|---|
---|F--|---|---|---|---|---|B--|---|---|D--|---|---|F--|---|---|

C Aug + - C E G# 
0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  
E--|---|---|---|G#-|---|---|---|C--|---|---|---|E--|---|---|---|
---|C--|---|---|---|E--|---|---|---|G#-|---|---|---|C--|---|---|
---|G#-|---|---|---|C--|---|---|---|E--|---|---|---|G#-|---|---|
---|---|E--|---|---|---|G#-|---|---|---|C--|---|---|---|E--|---|
---|---|---|C--|---|---|---|E--|---|---|---|G#-|---|---|---|C--|
E--|---|---|---|G#-|---|---|---|C--|---|---|---|E--|---|---|---|

D Minor - D F A 
0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  
---|F--|---|---|---|A--|---|---|---|---|D--|---|---|F--|---|---|
---|---|---|D--|---|---|F--|---|---|---|A--|---|---|---|---|D--|
---|---|A--|---|---|---|---|D--|---|---|F--|---|---|---|A--|---|
D--|---|---|F--|---|---|---|A--|---|---|---|---|D--|---|---|F--|
A--|---|---|---|---|D--|---|---|F--|---|---|---|A--|---|---|---|
---|F--|---|---|---|A--|---|---|---|---|D--|---|---|F--|---|---|

```
