#!/bin/ruby

require 'rmagick'
require 'csv'

canvas_width = 1800
canvas_height = 850

labels = ARGF.readline.split(',')
max_time = Time.at(0)
min_time = Time.new
max_value = 0
max_volume = 0
min_value = 1000000000000
min_volume= 1000000000000
logscale_arr = []

ARGF.each do |line|
  linearray = line.split(',')
  day_time = linearray[0].split()
  ymd = day_time[0].split('-')
  hms = day_time[1].split(':')
  line_time = Time.utc(ymd[0],ymd[1],ymd[2],hms[0],hms[1],hms[2])
  max_time = line_time if line_time > max_time
  min_time = line_time if line_time < min_time
  value = linearray[1].to_f
  volume = linearray[2].to_f
  max_value = value if value > max_value
  min_value = value if value < min_value
  max_volume = volume if volume > max_volume
  min_volume = volume if volume < min_volume
  logscale_arr.push([line_time, Math.log(value), Math.log(volume)])
end

canvas = Magick::Image.new(canvas_width, canvas_height,
              Magick::HatchFill.new('white','lightcyan2'))
gc = Magick::Draw.new

# Graph

value_prev = logscale_arr[0][1]
time_prev = logscale_arr[0][0]
min_value = Math.log(min_value)
max_value = Math.log(max_value)
min_volume = Math.log(min_volume)
max_volume = Math.log(max_volume)

logscale_arr.each do |record|
  gc.stroke('#0022dd')
  gc.stroke_width(2)
  gc.fill_opacity(1)
  gc.fill('#0022dd')
  gc.line(
    canvas_width / 10 + (time_prev - min_time) / (max_time - min_time) * canvas_width * 0.8,
    canvas_height * 0.9 - (value_prev - min_value) / (max_value - min_value) * canvas_height * 0.8,
    canvas_width / 10 + (record[0] - min_time) / (max_time - min_time) * canvas_width * 0.8,
    canvas_height * 0.9 - (record[1] - min_value) / (max_value - min_value) * canvas_height * 0.8
    )
  gc.fill(if record[1] > value_prev then 'green' else 'red' end)
  gc.fill_opacity(0.5)
  gc.stroke_width(0)
  gc.stroke_opacity(0)
  gc.rectangle(
    canvas_width / 10 + (time_prev - min_time) / (max_time - min_time) * canvas_width * 0.8,
    canvas_height * 0.9,
    canvas_width / 10 + (record[0] - min_time) / (max_time - min_time) * canvas_width * 0.8,
    canvas_height * 0.9 - (record[2] - min_volume) / (max_volume - min_volume) * canvas_height * 0.8
    )
  value_prev = record[1]
  time_prev  = record[0]
#  print "#{time_prev} #{min_time} #{max_time} #{value_prev} #{min_value} #{max_value}\n"
end


# Annotate
gc.stroke('transparent')
gc.fill('black')
gc.text(canvas_width / 10, canvas_height * 0.9 + 30, min_time.to_s)
gc.text(canvas_width / 10 - 150, canvas_height * 0.9, "#{labels[1]} #{(Math::E**min_value).round(2).to_s}")
gc.text(canvas_width / 10 - 150, canvas_height * 0.7, "#{labels[1]} #{(Math::E**((3*min_value + max_value)/4)).round(2).to_s}")
gc.text(canvas_width / 10 - 150, canvas_height * 0.5, "#{labels[1]} #{(Math::E**((min_value + max_value)/2)).round(2).to_s}")
gc.text(canvas_width / 10 - 150, canvas_height * 0.3, "#{labels[1]} #{(Math::E**((min_value + 3*max_value)/4)).round(2).to_s}")
gc.text(canvas_width / 10 - 150, canvas_height * 0.9 - 20, "#{labels[2].strip} #{(Math::E**min_volume).round(2).to_s}")
gc.text(canvas_width * 0.9 , canvas_height * 0.9 + 30, max_time.to_s)
gc.text(canvas_width / 10 - 150, canvas_height / 10, "#{labels[1]} #{(Math::E**max_value).round(2).to_s}")
gc.text(canvas_width / 10 - 150, canvas_height / 10 - 20, "#{labels[2].strip} #{(Math::E**max_volume).round(2).to_s}")

gc.draw(canvas)
canvas.write('/tmp/ctpvl_output.png')
