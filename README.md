# sandpile
Things I play with, perhaps useful for anybody else

chart_time_price_volume_logscale.rb
===================================
Usage:

* grab e.g. https://data.bitcoinity.org/export_data.csv?currency=USD&data_type=price_volume&t=lb&timespan=30d&vu=curr
* ./chart_time_price_volume_logscale.rb /tmp/bitcoinity_data.csv
* eog /tmp/ctpvl_output.png

chords.vim
==========
Highlights lines with chords, solos, chord explanations

Usage:

* write lyrics + chords on separate line, solos with "𝅘𝅥𝅮 " at the beginning of line, chord explanations like "x-x-0-2-1-1"
* you can use repetitions like "[:6x ....  :]" comments like "( .... )" at the end of chord line
* chords.vim compatible examples at https://github.com/ins-pirat-ion/chords-and-tabs
* :source /path/to/chords.vim or put chords.vim to $VIMRUNTIME/syntax and :se syntax=chords
* to obtain printable output use :source $VIMRUNTIME/syntax/2html.vim
