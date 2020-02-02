# key-mode

This is a perl utility which can print helpful information about scales
and progressions, based on input key and mode.

Custom step patterns can be provided, to get info on non-built-in scales.

### Help
<details><summary>The (extensive) help text is referenced here for clarity:</summary>
<p>

```bash
$ ./key-mode.pl -help

  This script can print out information about progressions
  and chord relationships, based on an input key and mode.

  Additionally, you can provide your own step pattern and key
  if desired.

  Most options can be mixed and matched as you might expect.

Usage:
  key-mode.pl -key [note] -mode [mode]
  key-mode.pl -key [note] -steps ["quoted pattern"]

  -R
  -key [note]
    [note] can be any of:
    A A# B C C# D D# E F F# G G#

  -m
  -mode [mode]
    [mode] can be any of: Major, Minor,
    Minor, Lydian, Locrian, Aeolian, Mixolydian, Super Locrian, Phrygian, Major, Ionian, Dorian, Harmonic Minor

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
    Provides the name to display when using a custom Step signature

  -color-1 [COLOR] ... -color-7 [COLOR]
    Assign a specific color to the given notes, when drawing the 
    guitar fingerboard patterns. 
    -color-1 is the root, -color-3 is the third, etc.
    Colors may be any of:
      DEFAULT, BOLD, BLACK, RED, BLUE, YELLOW, GREEN, 
      MAJENTA, CYAN, WHITE, BBLACK, BRED, BBLUE, BYELLOW, 
      BGREEN, BMAJENTA, BCYAN, BWHITE, BGDEFAULT, BGBLACK, BGRED, 
      BGBLUE, BGYELLOW, BGGREEN, BGMAJENTA, BGCYAN, BGWHITE

  -c
  -condense
    Print the guitar fingerboards or the piano keyboards in multiple columns.
    Good for running with a wide terminal

  -static-triad-colors
    Only print triads with the same set of colors, representing
    root, third, fifth.

Guitar Options

  -F
  -fingerboards
    For each chord in the scale, print a representation of a guitar
    figerboard, with the notes displayed

  -g
  -guitar-tuning ["Open Notes"]
    Open notes can be any quoted list of notes, low to high.
    Not limited to 6 strings.
    Default is "E A D G B E"

Keyboard Options

  -K
  -keyboards
    For each chord in the scale, print a representation of a piano
    keyboard, with the notes highlighed on the keyboard


Examples:

  Get info on A Dorian
    key-mode.pl -key A -mode dorian

  Get info on E Aeolian, along with fretboard note positions
    key-mode.pl -key E -mode Aeolian -fingerboards

  Get info about a user-provided scale
    key-mode.pl -key E -steps "1 3 1 2 1 2 2" -name "Super Locrian"

  Get info and fingerboard patterns for an 8 string guitar with weird tuning:
    key-mode.pl -key B -mode Mixolydian -fingerboards -guitar-tuning "E A D A D G B E"
 
  Get info about a keyboard, condensed
    key-mode.pl -key G -mode Phrygian -keyboards -condense
 
  The argument handling also supports shorthand addressing on most options.
  To see condensed keyboard and fingerboard renditions of a Db Major scale: 
    key-mode.pl -b -R Db -m Major -F -K -c
 
```

</p>
</details>

# Runtime Examples
You can click the sections to expand their details.

## A Phrygian, from built in scales


<details><summary>./key-mode.pl -key A -mode Phrygian</summary>
<p>

```bash
$ ./key-mode.pl -key A -mode Phrygian

  A  -  Phrygian
  
  Scale Notes:   A A# C D E F G

  Progression:   i II III iv v° VI vii 

  Chords:

    | A Minor | A# Major | C Major | D Minor | E Dim ° | F Major | G Minor | 
    | A C E   | A# D F   | C E G   | D F A   | E G A# | F A C   | G A# D  | 
    | i       | II       | III     | iv      | v°      | VI      | vii     | 
  
  Progression Chart:

                             iv  --  vii
     vii ->  III ->   VI <       ><       >    i
                              II  --   v°

                                     D Minor  --  G Minor 
    G Minor -> C Major -> F Major <           ><           > A Minor
                                     A# Major  --  E Dim ° 

```

</p>
</details>


## E Super Locrian, provided at the CLI
There is coloization to the fingerboard output at the CLI, it just does not translate properly to the markdown. The root, third, and fifth notes are all assigned their own colors, for clarity.

<details><summary>./key-mode.pl -steps "1 3 1 2 1 2 2" -key E -name "Super Locrian" -fingerboards</summary>
<p>

```bash
$ ./key-mode.pl -key E -name "Super Locrian" -steps "1 3 1 2 1 2 2" -fingerboards

  E  -  Super Locrian
  
  Scale Notes:   E F G# A B C D

  Progression:   I II iii° iv v° VI+ vii 

  Chords:

    | E Major | F Major | G# Dim ° | A Minor | B Dim ° | C Aug + | D Minor | 
    | E G# B  | F A C   | G# B D  | A C E   | B D F  | C E G#  | D F A   | 
    | I       | II      | iii°     | iv      | v°      | VI+     | vii     | 
  
  Progression Chart:

                             iv  --  vii
     vii -> iii° ->  VI+ <       ><       >    I
                              II  --   v°

                                     A Minor  --  D Minor 
    D Minor -> G# Dim ° -> C Aug + <           ><           > E Major
                                     F Major  --  B Dim ° 

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


E Super Locrian - E F G# A B C D
0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  
E--|F--|---|---|G#-|A--|---|B--|C--|---|D--|---|E--|F--|---|---|
B--|C--|---|D--|---|E--|F--|---|---|G#-|A--|---|B--|C--|---|D--|
---|G#-|A--|---|B--|C--|---|D--|---|E--|F--|---|---|G#-|A--|---|
D--|---|E--|F--|---|---|G#-|A--|---|B--|C--|---|D--|---|E--|F--|
A--|---|B--|C--|---|D--|---|E--|F--|---|---|G#-|A--|---|B--|C--|
E--|F--|---|---|G#-|A--|---|B--|C--|---|D--|---|E--|F--|---|---|

```

</p>
</details>

## B Aeolian (Minor) on a 7 string guitar
<details><summary>./key-mode.pl -mode Aeolian -key B -fingerboards -guitar-tuning "B E A D G B E"</summary>
<p>

```bash
$ ./key-mode.pl -mode Aeolian -key B -fingerboards -guitar-tuning "B E A D G B E"

  B  -  Aeolian
  
  Scale Notes:   B C# D E F# G A

  Progression:   i ii° III iv v VI VII 

  Chords:

    | B Minor | C# Dim ° | D Major | E Minor | F# Minor | G Major | A Major | 
    | B D F#  | C# E G  | D F# A  | E G B   | F# A C#  | G B D   | A C# E  | 
    | i       | ii°      | III     | iv      | v        | VI      | VII     | 
  
  Progression Chart:

                             iv  --  VII
     VII ->  III ->   VI <       ><       >    i
                             ii°  --    v

                                     E Minor  --  A Major 
    A Major -> D Major -> G Major <           ><           > B Minor
                                     C# Dim °  --  F# Minor 

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


B Aeolian - B C# D E F# G A
0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  
E--|---|F#-|G--|---|A--|---|B--|---|C#-|D--|---|E--|---|F#-|G--|
B--|---|C#-|D--|---|E--|---|F#-|G--|---|A--|---|B--|---|C#-|D--|
G--|---|A--|---|B--|---|C#-|D--|---|E--|---|F#-|G--|---|A--|---|
D--|---|E--|---|F#-|G--|---|A--|---|B--|---|C#-|D--|---|E--|---|
A--|---|B--|---|C#-|D--|---|E--|---|F#-|G--|---|A--|---|B--|---|
E--|---|F#-|G--|---|A--|---|B--|---|C#-|D--|---|E--|---|F#-|G--|
B--|---|C#-|D--|---|E--|---|F#-|G--|---|A--|---|B--|---|C#-|D--|

```

</p>
</details>

## C Ionian (Major) in open C tuning
<details><summary>./key-mode.pl -mode Ionian -key C -fingerboards -guitar-tuning "C G C G C E"</summary>
<p>

```bash
$ ./key-mode.pl -mode Ionian -key C -fingerboards -guitar-tuning "C G C G C E"

  C  -  Ionian
  
  Scale Notes:   C D E F G A B

  Progression:   I ii iii IV V vi vii° 

  Chords:

    | C Major | D Minor | E Minor | F Major | G Major | A Minor | B Dim ° | 
    | C E G   | D F A   | E G B   | F A C   | G B D   | A C E   | B D F  | 
    | I       | ii      | iii     | IV      | V       | vi      | vii°    | 
  
  Progression Chart:

                             IV  -- vii°
    vii° ->  iii ->   vi <       ><       >    I
                              ii  --    V

                                     F Major  --  B Dim ° 
    B Dim ° -> E Minor -> A Minor <           ><           > C Major
                                     D Minor  --  G Major 

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


C Ionian - C D E F G A B
0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  
E--|F--|---|G--|---|A--|---|B--|C--|---|D--|---|E--|F--|---|G--|
C--|---|D--|---|E--|F--|---|G--|---|A--|---|B--|C--|---|D--|---|
G--|---|A--|---|B--|C--|---|D--|---|E--|F--|---|G--|---|A--|---|
C--|---|D--|---|E--|F--|---|G--|---|A--|---|B--|C--|---|D--|---|
G--|---|A--|---|B--|C--|---|D--|---|E--|F--|---|G--|---|A--|---|
C--|---|D--|---|E--|F--|---|G--|---|A--|---|B--|C--|---|D--|---|

```

</p>
</details>

