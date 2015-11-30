" Vim syntax file
" Language:	songs with chords
" Maintainer:	Filip Krska <fill_io@centrum.cz>
" Last Change:	Mo, 23 Nov 2015 10:38:00 CET
" Filenames:	*.chords
" $Id: chords.vim,v 0.1 2015/11/23 10:38:00 vimboss Exp $

" Quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

" chordlines
syn match chordLine /^[ ]*\([(A-H/:[][^ ]*[ ]*\)*\((.*)\)\?$/
syn match noteLine  /^𝅘𝅥𝅮 .*$/
syn match kapoLine  /^Kapo.*$/
syn match chordTab  /\([0-9x]\+-\)\+[0-9x]\+/


" The default highlighting.
hi def link chordLine			     String
hi def link noteLine			     Type
hi def link kapoLine			     Keyword
hi def link chordTab			     Statement

let b:current_syntax = "chords"
