#!/bin/ruby

#
# ♡ Filip Krška 2015
# This piece of SW is free
# copyheart, unlicense, WTFPL whatever free license you want
# licenses, copywrong laws and all creative monopolies are obsolete anyway ;)
# feel free to copy, fork, pull request, profit, ... 
# whatever you want without any warranty
# make art, not law ;)
#



require 'rmagick'
require 'csv'
require 'action_view'

include ActionView::Helpers::NumberHelper


$canvas_width = 1800
$canvas_height = 850
$annotations_n = 15
timestamps_n = 8

labels = ARGF.readline.split(',')
value = 0
volume = 0
max_value = 0
max_volume = 0
min_value = 1000000000000
min_volume= 1000000000000
logscale_arr = []
max_abs_val_delta_log = 0

first_time = true

ARGF.each do |line|
  linearray = line.split(',')
  day_time = linearray[0].split()
  ymd = day_time[0].split('-')
  hms = day_time[1].split(':')
  line_time = Time.utc(ymd[0],ymd[1],ymd[2],hms[0],hms[1],hms[2])
  max_abs_val_delta_log = (Math.log(value / linearray[1].to_f)).abs if (
    !first_time &&
    linearray[2].to_f > 0 &&
    linearray[1].to_f > 0 &&
    (Math.log(value / linearray[1].to_f)).abs > max_abs_val_delta_log
  )
  value = linearray[1].to_f if linearray[1].to_f > 0   # previous one instead of invalid value
  volume = linearray[2].to_f if linearray[2].to_f > 0  # previous one instead of invalid value
  value = 0.00001 if value <= 0.0                      # some low value instead of invalid one
  volume = 2000.0 if volume < 2000.0                   # some low value instead of invalid one
  max_value = value if value > max_value
  min_value = value if value < min_value
  max_volume = volume if volume > max_volume
  min_volume = volume if volume < min_volume
  logscale_arr.push([line_time, Math.log(value), Math.log(volume)])
  first_time = false
end

$close_value = value
$close_volume = volume

min_time = logscale_arr[0][0]
max_time = logscale_arr[-1][0]
time_period = max_time - min_time
time_delta = time_period / (logscale_arr.length - 1)
time_period_w = time_period + time_delta
min_time_w = min_time - time_delta

canvas = Magick::Image.new($canvas_width, $canvas_height,
              Magick::HatchFill.new('white','lightcyan2'))
$gc = Magick::Draw.new

value_prev = logscale_arr[0][1]
time_prev = min_time - time_delta
$log_min_value = Math.log(min_value) > -Float::MAX ? Math.log(min_value) : -Float::MAX
$log_max_value = Math.log(max_value)
$log_min_volume = Math.log(min_volume) > -Float::MAX ? Math.log(min_volume) : -Float::MAX
$log_max_volume = Math.log(max_volume)

# Annotate

def roundest(min,max)
  return min if min >=max

  log10minceil = (Math.log10(min) > -Float::MAX ? Math.log10(min) : -Float::MAX).ceil
  log10maxceil = (Math.log10(max) > -Float::MAX ? Math.log10(max) : -Float::MAX).ceil
  if log10maxceil > log10minceil
    return 10**log10minceil
  end

  delta_order = Math.log10(max-min).ceil

  if (max*(10**(-delta_order))).floor == (min*(10**(-delta_order))).ceil
    return (max*(10**(-delta_order))).floor * 10**delta_order
  end

  common = (max*(10**(-delta_order))).floor * 10**delta_order
  max_digit = ((max - common)*(10**(1-delta_order))).floor
  min_digit = ((min - common)*(10**(1-delta_order))).floor

  nice_order = [0, 5, 2, 4, 8, 6, 3, 7, 1, 9]
  nicest_digit = (nice_order.select {|a| a>min_digit && a<=max_digit })[0]
  
  return (common + nicest_digit * 10**(delta_order-1)).to_f
end

$close = false

def annotate_val_vol(value, volume)
  log_value = Math.log(value) > -Float::MAX ? Math.log(value) : -Float::MAX
  log_volume = Math.log(volume) > -Float::MAX ? Math.log(volume) : -Float::MAX
  height_value =  $canvas_height * (0.9 - 0.8 * (log_value - $log_min_value)/($log_max_value - $log_min_value))
  height_volume =  $canvas_height * (0.9 - 0.8 * (log_volume - $log_min_volume)/($log_max_volume - $log_min_volume))
  $gc.stroke('transparent')
  $gc.fill(if $close then '#b06000' else 'black' end)
  $gc.text($canvas_width / 10 - (if $close then 150 else 85 end), height_value, number_to_human(value.round(2).to_s, precision: 6))
  $gc.fill(if $close then '#60b000' else 'black' end)
  $gc.text($canvas_width * 0.9 + (if $close then 80 else 10 end), height_volume, number_to_human(volume.round(2).to_s, precision: 6))
  $gc.stroke(if $close then '#b06000' else 'black' end)
  $gc.line($canvas_width / 10, height_value, $canvas_width * 0.9, height_value)
  if height_value != height_volume then
    $gc.fill(if $close then '#60b000' else 'grey' end)
    $gc.stroke(if $close then '#60b000' else 'grey' end)
    $gc.line($canvas_width / 10, height_volume, $canvas_width * 0.9, height_volume)
  end
end

$gc.stroke_width(2)

annotate_val_vol(min_value, min_volume)
annotate_val_vol(max_value, max_volume)

$annotations_n.times do |i|
  j=i+1
  annotate_val_vol(
    roundest(Math::E**(((0.02 + 0.96/$annotations_n*j)*$log_min_value + (0.98 - 0.96/$annotations_n*j)*$log_max_value)),
      Math::E**(((0.02 + 0.96/$annotations_n*i)*$log_min_value + (0.98 - 0.96/$annotations_n*i)*$log_max_value))
    ),
    roundest(Math::E**(((0.02 + 0.96/$annotations_n*j)*$log_min_volume + (0.98 - 0.96/$annotations_n*j)*$log_max_volume)),
      Math::E**(((0.02 + 0.96/$annotations_n*i)*$log_min_volume + (0.98 - 0.96/$annotations_n*i)*$log_max_volume))
    )
  )  
end

$close = true

annotate_val_vol($close_value, $close_volume)

$gc.stroke('transparent')
$gc.fill('black')
$gc.text($canvas_width / 10 - 85, $canvas_height * 0.1 - 30, labels[1])
$gc.text($canvas_width * 0.9 + 10 , $canvas_height * 0.1 - 30, labels[2])

(timestamps_n).times do |i|
  time = ((timestamps_n - 1 - i) * min_time.to_f + i * max_time.to_f)/(timestamps_n - 1)
  x = $canvas_width * (0.1 + (time - min_time_w.to_f)/time_period_w*0.8)
  $gc.stroke('transparent')
  $gc.text(x - 70, $canvas_height * 0.9 + 30,
    Time.at(time).utc.to_s
  )
  $gc.stroke('black')
  $gc.line(x, $canvas_height * 0.9, x, $canvas_height * 0.1)
end

# Graph

first_time = true
logscale_arr.each do |record|
  relative_delta_log = (record[1] - value_prev) / max_abs_val_delta_log
  opacity_correction = 1
  if relative_delta_log > 0.03 then
    hue = 120
  elsif relative_delta_log < -0.03 then
    hue = 360
  else
    hue = 200
    opacity_correction = 0.2
  end
  $gc.fill("hsl(#{hue}, 255, 100)")
  $gc.fill_opacity(0.2 + 0.4 * (relative_delta_log.abs)**0.5 * opacity_correction)
  $gc.stroke_width(0)
  $gc.stroke_opacity(0)
  $gc.rectangle(
    $canvas_width / 10 + (time_prev - min_time_w) / time_period_w * $canvas_width * 0.8,
    $canvas_height * 0.9,
    $canvas_width / 10 + (record[0] - min_time_w) / time_period_w * $canvas_width * 0.8,
    $canvas_height * 0.9 - (record[2] - $log_min_volume) / ($log_max_volume - $log_min_volume) * $canvas_height * 0.8
    )
  $gc.stroke_width(2)
  $gc.fill_opacity(1)
  $gc.stroke("hsl(#{hue}, 100, 80)")
  $gc.fill("hsl(#{hue}, 100, 80)")
  $gc.line(
    $canvas_width / 10 + (time_prev - min_time_w) / time_period_w * $canvas_width * 0.8,
    $canvas_height * 0.9 - (value_prev - $log_min_value) / ($log_max_value - $log_min_value) * $canvas_height * 0.8,
    $canvas_width / 10 + (record[0] - min_time_w) / time_period_w * $canvas_width * 0.8,
    $canvas_height * 0.9 - (record[1] - $log_min_value) / ($log_max_value - $log_min_value) * $canvas_height * 0.8
    ) if !first_time
  value_prev = record[1]
  time_prev  = record[0]
  first_time = false
end

$gc.draw(canvas)
canvas.write('/tmp/ctpvl_output.png')
