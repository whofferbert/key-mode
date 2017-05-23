# key-mode
./key-mode 

Usage: ./key-mode [key] [mode]

Where [key] is any of :  A A# B C C# D D# E F F# G G#

And [mode] is any of :   Ionian Dorian Phrygian Lydian Mixolydian Aeolian Locrian

ex:
  ./key-mode A dorian

```bash
$ ./key-mode A Phrygian

    A Phrygian

  Scale Notes: A A# C D E F G

  Progression: i II III iv v° VI vii 

  Chords: 

| A Minor | A# Major | C Major | D Minor | E Dim ° | F Major | G Minor | 
| A C E   | A# D F   | C E G   | D F A   | E G A#  | F A C   | G A# D  | 
| i       | II       | III     | iv      | v°      | VI      | vii     | 

  Progression Chart:
                       iv  -  vii
  vii -> III -> VI <      ><       > i
                       II  -  v°

```
