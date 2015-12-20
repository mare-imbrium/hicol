#!/usr/bin/env ruby
# ----------------------------------------------------------------------------- #
#         File: hicol.rb
#  Description: highlight columns of a TSV or other columnar data file
#               The term columns here refers to a field as in `cut`.
#       Author: j kepler  http://github.com/mare-imbrium/canis/
#         Date: 2015-12-19 - 18:37
#      License: MIT
#  Last update: 2015-12-20 20:01
# ----------------------------------------------------------------------------- #
#  hicol.rb  Copyright (C) 2012-2016 j kepler

# Examples:
#
# $ hicol.rb -f 1,2,4 table.tsv
# $ hicol.rb -f 2 --fg 20 --bg 255 data.tsv | less
# $ hicol.rb --columns 2,3 data.tsv > output.txt
# $ hicol.rb data.tsv data1.tsv
# $ cat data*.tsv | hicol.rb
# $ cat data.tsv | hicol.rb - data1.tsv
#

# escaped bash color codes
fgcolor = "\e[31m"
bgcolor = "\x1b[48;5;0m" 
reset_color = "\e[0m"

# unused
colorized_output = true
delim = "\t"
# columns to highlight. If none specified, then first
list = [1]

require 'optparse'
OptionParser.new do |options|
  # This banner is the first line of your help documentation.
  options.set_banner "Usage: hicol.rb [options] [files]\n" \
    "Highlight given columns of input. Columns and single bg fg pair may be specified"

  # Separator just adds a new line with the specified text.
  options.separator ""
  options.separator "Specific options:"

  options.on("--no-color", "Disable colorized output") do |color|
    colorized_output = color
  end

  # fields or columns to highlight
	options.on("-f", "--columns 1,2,3", Array, "Column/s to highlight (index 1)") do |l|
		list = l
	end
	# delimiter or separator.
	options.on("-d", "--delim S", String, "delimiter, default is tab") do |n|
		delim = n
	end
  options.on("--fg NUM", Integer, "Foreground color number 0 - 255") do |fg|
    fgcolor =  "\x1b[38;5;#{fg}m"
  end
  options.on("--bg NUM", Integer, "Background color number 0 - 255") do |bg|
    bgcolor = "\x1b[48;5;#{bg}m" 
  end

  options.on_tail("-h", "--help", "Highlight Columns of delimited data") do
    $stderr.puts options
    exit 1
  end
end.parse!

fgbg = "#{bgcolor}#{fgcolor}"
# Keep reading lines of input as long as they're coming.
while input = ARGF.gets
  input.each_line do |line|
    line = line.chomp
    # 
    # split line
    # colorize the columns requested
    # join lines again
    cols = line.split(delim)
    colsz = cols.size - 1
    list.each_with_index {|e, ix|
      indx = e.to_i - 1
      # ignore non existent field
      next if indx > colsz

      val = cols[indx]
      val.insert(0, fgbg)
      val.insert(-1, reset_color)
      cols[indx] = val

    }
    output_line = cols.join(delim)

    begin
      $stdout.puts output_line
    rescue Errno::EPIPE
      # in case the pipe closes before we are done writing
      exit(74)
    end
  end
end
