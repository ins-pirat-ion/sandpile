# sandpile
Things I play with, perhaps useful for anybody else

chart_time_price_volume_logscale.rb
===================================
Displays CSV data from https://data.bitcoinity.org/markets/price_volume on log scale. Colors the volume bars according to the price delta at the corresponding interval. Annotates the min, max and closing values.

Usage:

* grab e.g. https://data.bitcoinity.org/export_data.csv?currency=USD&data_type=price_volume&t=lb&timespan=30d&vu=curr
* `./chart_time_price_volume_logscale.rb /tmp/bitcoinity_data.csv`
* `eog /tmp/ctpvl_output.png`

chords.vim
==========
Highlights lines with chords, solos, chord explanations

Usage:

* write lyrics + chords on separate lines
* solos with `♪ ` at the beginning of line
* chord explanations like `Chord        x-x-0-2-1-1`
* you can use repetitions like `[:6x ....  :]`
* comments like `( .... )` at the end of chord line
* objects like `Lyrics, music: Autor`, `R:`, `Intro:` ...
* keep enough spaces after chords so they can be transposed without formatting loss
* chords.vim compatible examples at https://github.com/ins-pirat-ion/chords-and-tabs
* `:source /path/to/chords.vim` or put `chords.vim` to `$VIMRUNTIME/syntax` and `:se syntax=chords`
* to obtain printable output use `:source $VIMRUNTIME/syntax/2html.vim`

chords_transpose.rb
===================
Features
--------
* Transposes chords and solos in plain text
* If `Orig: <KEY>` is provided along with `-t <TO>` appends or replaces ` - Kapo: #`
* Attempts to keep formatting, best effort (+ warning on stderr) if not enough spaces after chords
* If chords has bass `/<Note>` suffix it is transposed as well

Prerequisites
-------------
* Expects format understandable by `chords.vim` i.e. chords and solos on separate lines
* Allowed chars after notes in solos: ±
* Allowed chars between notes in solos: +, -
* Usage
```
chords_transpose.rb -f E -t Cb -b < song_in_E > song_in_Cb
```
Parameters
----------
* `-f <FROM>` from key
* `-t <TO>` to key
* `-q <QUINTS>` how many quints to shift (if provided, `-f` and `-t` are ignored)
* `-b` prefer flat in output
* `-H` use German musical nomenclature (H instead of B, B means Bb)
* `-h` usage

Limitations
-----------
* Doesn't transpose chord explanations
* Doesn't transpose in comments, objects, non-chord, non-solo lines

assassin_draw.sh
================
Features
--------
* Draws a random `killer->victim` circle for group of assassin-like players
* see https://en.wikipedia.org/wiki/Assassin_(game)

Usage
-----
* stay in empty directory
* `touch <player1> ... <playerN>`
* `assassin_draw.sh *`
* send `<playerI>` file to `<playerI>`, don't look into it :), it will contain `<playerJ>` - his victim

