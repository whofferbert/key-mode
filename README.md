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

  Get info on A Dorian
    key-mode -key A -mode dorian

  Get info on E Aeolian, along with fretboard note positions
    key-mode -key E -mode Aeolian -fingerboards

  Get info about a user-provided scale
    key-mode -key E -steps "1 3 1 2 1 2 2" -name "Super Locrian"
 
  Get info and fingerboard patterns for an 8 string guitar with weird tuning:
    key-mode -key B -mode Mixolydian -fingerboards -guitar-tuning "E A D A D G B E"
 
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
There is coloization to the fingerboard output at the CLI, it just does not translate properly to the markdown. The root, third, and fifth notes are all assigned their own colors, for clarity.

```bash
$ ./key-mode -steps "1 3 1 2 1 2 2" -key E -name "Super Locrian" -fingerboards

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

## B Aeolian (Minor) on a 7 string guitar
```bash
$ ./key-mode -mode Aeolian -key B -fingerboards -guitar-tuning "B E A D G B E"

  B  -  Aeolian
  
  Scale Notes:   B C# D E F# G A

  Progression:   i ii° III iv v VI VII 

  Chords:

    | B Minor | C# Dim ° | D Major | E Minor | F# Minor | G Major | A Major | 
    | B D F#  | C# E G   | D F# A  | E G B   | F# A C#  | G B D   | A C# E  | 
    | i       | ii°      | III     | iv      | v        | VI      | VII     | 
  
  Progression Chart:

                         iv  -  VII
    VII -> III -> VI <      ><       > i
                         ii°  -  v

B Minor - B D F# 
0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  
---|---|F#-|---|---|---|---|B--|---|---|D--|---|---|---|F#-|---|
B--|---|---|D--|---|---|---|F#-|---|---|---|---|B--|---|---|D--|
---|---|---|---|B--|---|---|D--|---|---|---|F#-|---|---|---|---|
D--|---|---|---|F#-|---|---|---|---|B--|---|---|D--|---|---|---|
---|---|B--|---|---|D--|---|---|---|F#-|---|---|---|---|B--|---|
---|---|F#-|---|---|---|---|B--|---|---|D--|---|---|---|F#-|---|
B--|---|---|D--|---|---|---|F#-|---|---|---|---|B--|---|---|D--|

C# Dim ° - C# E G 
0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  
E--|---|---|G--|---|---|---|---|---|C#-|---|---|E--|---|---|G--|
---|---|C#-|---|---|E--|---|---|G--|---|---|---|---|---|C#-|---|
G--|---|---|---|---|---|C#-|---|---|E--|---|---|G--|---|---|---|
---|---|E--|---|---|G--|---|---|---|---|---|C#-|---|---|E--|---|
---|---|---|---|C#-|---|---|E--|---|---|G--|---|---|---|---|---|
E--|---|---|G--|---|---|---|---|---|C#-|---|---|E--|---|---|G--|
---|---|C#-|---|---|E--|---|---|G--|---|---|---|---|---|C#-|---|

D Major - D F# A 
0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  
---|---|F#-|---|---|A--|---|---|---|---|D--|---|---|---|F#-|---|
---|---|---|D--|---|---|---|F#-|---|---|A--|---|---|---|---|D--|
---|---|A--|---|---|---|---|D--|---|---|---|F#-|---|---|A--|---|
D--|---|---|---|F#-|---|---|A--|---|---|---|---|D--|---|---|---|
A--|---|---|---|---|D--|---|---|---|F#-|---|---|A--|---|---|---|
---|---|F#-|---|---|A--|---|---|---|---|D--|---|---|---|F#-|---|
---|---|---|D--|---|---|---|F#-|---|---|A--|---|---|---|---|D--|

E Minor - E G B 
0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  
E--|---|---|G--|---|---|---|B--|---|---|---|---|E--|---|---|G--|
B--|---|---|---|---|E--|---|---|G--|---|---|---|B--|---|---|---|
G--|---|---|---|B--|---|---|---|---|E--|---|---|G--|---|---|---|
---|---|E--|---|---|G--|---|---|---|B--|---|---|---|---|E--|---|
---|---|B--|---|---|---|---|E--|---|---|G--|---|---|---|B--|---|
E--|---|---|G--|---|---|---|B--|---|---|---|---|E--|---|---|G--|
B--|---|---|---|---|E--|---|---|G--|---|---|---|B--|---|---|---|

F# Minor - F# A C# 
0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  
---|---|F#-|---|---|A--|---|---|---|C#-|---|---|---|---|F#-|---|
---|---|C#-|---|---|---|---|F#-|---|---|A--|---|---|---|C#-|---|
---|---|A--|---|---|---|C#-|---|---|---|---|F#-|---|---|A--|---|
---|---|---|---|F#-|---|---|A--|---|---|---|C#-|---|---|---|---|
A--|---|---|---|C#-|---|---|---|---|F#-|---|---|A--|---|---|---|
---|---|F#-|---|---|A--|---|---|---|C#-|---|---|---|---|F#-|---|
---|---|C#-|---|---|---|---|F#-|---|---|A--|---|---|---|C#-|---|

G Major - G B D 
0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  
---|---|---|G--|---|---|---|B--|---|---|D--|---|---|---|---|G--|
B--|---|---|D--|---|---|---|---|G--|---|---|---|B--|---|---|D--|
G--|---|---|---|B--|---|---|D--|---|---|---|---|G--|---|---|---|
D--|---|---|---|---|G--|---|---|---|B--|---|---|D--|---|---|---|
---|---|B--|---|---|D--|---|---|---|---|G--|---|---|---|B--|---|
---|---|---|G--|---|---|---|B--|---|---|D--|---|---|---|---|G--|
B--|---|---|D--|---|---|---|---|G--|---|---|---|B--|---|---|D--|

A Major - A C# E 
0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  
E--|---|---|---|---|A--|---|---|---|C#-|---|---|E--|---|---|---|
---|---|C#-|---|---|E--|---|---|---|---|A--|---|---|---|C#-|---|
---|---|A--|---|---|---|C#-|---|---|E--|---|---|---|---|A--|---|
---|---|E--|---|---|---|---|A--|---|---|---|C#-|---|---|E--|---|
A--|---|---|---|C#-|---|---|E--|---|---|---|---|A--|---|---|---|
E--|---|---|---|---|A--|---|---|---|C#-|---|---|E--|---|---|---|
---|---|C#-|---|---|E--|---|---|---|---|A--|---|---|---|C#-|---|

```

## C Ionian (Major) in an open C tuning
```bash
$ ./key-mode -mode Ionian -key C -fingerboards -guitar-tuning "C G C G C E"

  C  -  Ionian
  
  Scale Notes:   C D E F G A B

  Progression:   I ii iii IV V vi vii° 

  Chords:

    | C Major | D Minor | E Minor | F Major | G Major | A Minor | B Dim ° | 
    | C E G   | D F A   | E G B   | F A C   | G B D   | A C E   | B D F   | 
    | I       | ii      | iii     | IV      | V       | vi      | vii°    | 
  
  Progression Chart:

                         IV  -  vii°
    vii° -> iii -> vi <      ><       > I
                         ii  -  V

C Major - C E G 
0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  
E--|---|---|G--|---|---|---|---|C--|---|---|---|E--|---|---|G--|
C--|---|---|---|E--|---|---|G--|---|---|---|---|C--|---|---|---|
G--|---|---|---|---|C--|---|---|---|E--|---|---|G--|---|---|---|
C--|---|---|---|E--|---|---|G--|---|---|---|---|C--|---|---|---|
G--|---|---|---|---|C--|---|---|---|E--|---|---|G--|---|---|---|
C--|---|---|---|E--|---|---|G--|---|---|---|---|C--|---|---|---|

D Minor - D F A 
0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  
---|F--|---|---|---|A--|---|---|---|---|D--|---|---|F--|---|---|
---|---|D--|---|---|F--|---|---|---|A--|---|---|---|---|D--|---|
---|---|A--|---|---|---|---|D--|---|---|F--|---|---|---|A--|---|
---|---|D--|---|---|F--|---|---|---|A--|---|---|---|---|D--|---|
---|---|A--|---|---|---|---|D--|---|---|F--|---|---|---|A--|---|
---|---|D--|---|---|F--|---|---|---|A--|---|---|---|---|D--|---|

E Minor - E G B 
0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  
E--|---|---|G--|---|---|---|B--|---|---|---|---|E--|---|---|G--|
---|---|---|---|E--|---|---|G--|---|---|---|B--|---|---|---|---|
G--|---|---|---|B--|---|---|---|---|E--|---|---|G--|---|---|---|
---|---|---|---|E--|---|---|G--|---|---|---|B--|---|---|---|---|
G--|---|---|---|B--|---|---|---|---|E--|---|---|G--|---|---|---|
---|---|---|---|E--|---|---|G--|---|---|---|B--|---|---|---|---|

F Major - F A C 
0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  
---|F--|---|---|---|A--|---|---|C--|---|---|---|---|F--|---|---|
C--|---|---|---|---|F--|---|---|---|A--|---|---|C--|---|---|---|
---|---|A--|---|---|C--|---|---|---|---|F--|---|---|---|A--|---|
C--|---|---|---|---|F--|---|---|---|A--|---|---|C--|---|---|---|
---|---|A--|---|---|C--|---|---|---|---|F--|---|---|---|A--|---|
C--|---|---|---|---|F--|---|---|---|A--|---|---|C--|---|---|---|

G Major - G B D 
0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  
---|---|---|G--|---|---|---|B--|---|---|D--|---|---|---|---|G--|
---|---|D--|---|---|---|---|G--|---|---|---|B--|---|---|D--|---|
G--|---|---|---|B--|---|---|D--|---|---|---|---|G--|---|---|---|
---|---|D--|---|---|---|---|G--|---|---|---|B--|---|---|D--|---|
G--|---|---|---|B--|---|---|D--|---|---|---|---|G--|---|---|---|
---|---|D--|---|---|---|---|G--|---|---|---|B--|---|---|D--|---|

A Minor - A C E 
0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  
E--|---|---|---|---|A--|---|---|C--|---|---|---|E--|---|---|---|
C--|---|---|---|E--|---|---|---|---|A--|---|---|C--|---|---|---|
---|---|A--|---|---|C--|---|---|---|E--|---|---|---|---|A--|---|
C--|---|---|---|E--|---|---|---|---|A--|---|---|C--|---|---|---|
---|---|A--|---|---|C--|---|---|---|E--|---|---|---|---|A--|---|
C--|---|---|---|E--|---|---|---|---|A--|---|---|C--|---|---|---|

B Dim ° - B D F 
0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  
---|F--|---|---|---|---|---|B--|---|---|D--|---|---|F--|---|---|
---|---|D--|---|---|F--|---|---|---|---|---|B--|---|---|D--|---|
---|---|---|---|B--|---|---|D--|---|---|F--|---|---|---|---|---|
---|---|D--|---|---|F--|---|---|---|---|---|B--|---|---|D--|---|
---|---|---|---|B--|---|---|D--|---|---|F--|---|---|---|---|---|
---|---|D--|---|---|F--|---|---|---|---|---|B--|---|---|D--|---|

```

