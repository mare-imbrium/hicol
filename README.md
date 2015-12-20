# hicol
Highlight or colour fields in standard input 

You may specify fields to highlight with -f / --columns. By default, colors the first column.
You may specify delimiter with -d, by default uses TAB as delimiter.

Caveats: This is a simple tool. It does not understand delimiters inside quoted strings (meaning usually CSV files with commas within quotes).


# Examples:

    $ hicol.rb -f 1,2,4 table.tsv
    $ hicol.rb -f 2 --fg 20 --bg 255 data.tsv | less
    $ hicol.rb --columns 2,3 data.tsv > output.txt
    $ hicol.rb data.tsv data1.tsv
    $ cat data*.tsv | hicol.rb
    $ cat data.tsv | hicol.rb - data1.tsv

# Usage:

     hicol.rb --help

Usage: hicol.rb [options] [files]
Highlight given columns of input. Columns and single bg fg pair may be specified

Specific options:
    -f, --columns 1,2,3              Column/s to highlight (index 1)
    -d, --delim S                    delimiter, default is tab
        --fg NUM                     Foreground color number 0 - 255
        --bg NUM                     Background color number 0 - 255
    -h, --help                       Highlight Columns of delimited data

# Install

      Place hicol.rb in your PATH and preferably rename to hicol.

# License
   MIT License.
