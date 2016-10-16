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
syn match titleLine /\%1l.*/
syn match chordLine /^[ ]*\([(A-H/:\[[][^ ]*[ ]*\)*\((.*)\)\?$/
syn match objectLine  /^[[:alnum:], ]*:\( .*\|\)$/
syn match chordTabLine  /^.*\([0-9x]\+-\)\{3,}[0-9x]\+.*$/
syn match noteLine  /^[♪] .*$/


" The default highlighting.
hi def titleLine			     cterm=bold ctermfg=16
hi def chordLine			     cterm=bold ctermfg=124
hi def noteLine				     ctermfg=28
hi def objectLine			     cterm=bold ctermfg=24
hi def chordTabLine			     ctermfg=94

let b:current_syntax = "chords"
