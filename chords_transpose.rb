#!/usr/bin/ruby

#
# ♡ Filip Krška 2015
# This piece of SW is free
# copyheart, unlicense, WTFPL whatever free license you want
# licenses, copywrong laws and all creative monopolies are obsolete anyway ;)
# feel free to copy, fork, pull request, profit, ... 
# whatever you want without any warranty
# make art, not law ;)
#

require 'optparse'

OptionParser.new do |o|
  o.on('-b') { |b| $flat = b }
  o.on('-H') { |german| $german = german }
  o.on('-q QUINTS') {|quints| $quints = quints}
  o.on('-f FROM') {|from| $from = from}
  o.on('-t TO') {|to| $to = to}
  o.on('-h') { $stderr.puts o; exit }
  o.parse!
end

def my_abort(message)
  abort "#{caller.join("\n")}: #{message}\n"
end

$opt_H = $german ? "H" : ""

def sharpen(note)
  note =~ /^[ABCDEFG#{$opt_H}][b#]?$/ or my_abort "'#{note}' is not a note"
  if note =~ /[ABCDEFG]b/
    sharp_tab = {"Ab" => "G#", "Bb" => "A#", "Db" => "C#", "Eb" => "D#", "Gb" => "F#", "Ab" => "G#"}
    sharp_note = sharp_tab[note] or my_abort "'#{note}' is not a note"
    return sharp_note
  elsif (note == "B" && $german)
    return "A#"
  else
    return note
  end
end

def flatten(note)
  note =~ /^[ABCDEFG#{$opt_H}][b#]?$/ or my_abort "'#{note}' is not a note"
  if note =~ /[ABCDEFG#{$opt_H}]#/
    flat_tab = {"A#" => $german ? "B" : "Bb", "C#" => "Db", "D#" => "Eb", "F#" => "Gb", "G#" => "Ab"}
    flat_note = flat_tab[note] or my_abort "'#{note}' is not a note"
    return flat_note
  else
    return note
  end
end

  $sharp_seq = ["C", "G", "D", "A", "E", $german ? "H" : "B", "F#", "C#", "G#", "D#", "A#", "F"]

if $quints
  begin
    !!Integer($quints)
  rescue
    my_abort "'-q #{$quints}' is not an Integer"
  end
elsif $from
  if $to
    $from = sharpen($from)
    $to = sharpen($to)
    $quints = ($sharp_seq.index($to) - $sharp_seq.index($from)) % 12
  else
    my_abort "<-f FROM> provided without <-t TO>"
  end
else
  my_abort "Either <-q QUINTS> or <-f FROM -t TO> shall be supplied"
end

def transpose(chord, quints, flat, next_char)
  orig_note = chord.match(/^[ABCDEFG#{$opt_H}][#b]?/)[0]
  orig_len = chord.size
  orig_sharpened = sharpen(orig_note)
  transposed_note = $sharp_seq[($sharp_seq.index(orig_sharpened) + quints) % 12]
  $flat and transposed_note = flatten(transposed_note)
  transposed_chord = chord.sub orig_note, transposed_note
  transposed_len = transposed_chord.size
  next_plus_white = ""
  if next_char =~ / +/
    correction = next_char.size + orig_len - transposed_len + $fwd_correction
    if correction > 0
      next_plus_white = " " * correction
      $fwd_correction = 0
    else
      next_plus_white = " "
      $fwd_correction = correction - 1
      $stderr.puts "Warning: not enough space after #{chord} on line #{$lineno}"
    end
  elsif next_char =~ /[\/±+-]/
    $fwd_correction -= transposed_len - orig_len
    next_plus_white = next_char
  end
  return "#{transposed_chord + next_plus_white}"
end

$lineno = 0

$stdin.readlines.each do |line|
  $fwd_correction = 0
  $lineno += 1
  if line =~ /^[ ]*([\(ABCDEFG#{$opt_H}\/\[:][^ ]*[ ]*)*(\(.*\))?$/
    puts line.gsub(/([ABCDEFG#{$opt_H}][^ \/]*)(\/| +|$)/){|match|
      transpose($1, $quints, $flat, $2)
    }
  elsif line =~ /^𝅘𝅥𝅮 /
    puts line.gsub(/([ABCDEFG#{$opt_H}][#b]?)([±+-]| +|$)/){|match|
      transpose($1, $quints, $flat, $2)
    }
  else
    puts line
  end
end
