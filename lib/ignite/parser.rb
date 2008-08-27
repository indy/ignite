
module Ignite

  # given a string that describes the folder structure, the parser will
  # return the appropriate hash table

  module Parser

    # indices start at 1. All odd numbered segments are normal, all even segments are expressions
    def evaluate_line line
      flipflop = 0
      line.split("%").map { |seg|
        flipflop = 1 - flipflop
        (flipflop % 2 == 0) ? eval(seg) : seg
      }.join
    end

    def is_directory?(line)
      line.slice(/.$/) == '/' ? true : false
    end

    def name_of_directory(line)
      line.scan(/([-a-zA-Z0-9._]*)\/$/)[0][0]
    end

    def template_for_file(line)
      line.rstrip.scan(/[-a-zA-Z0-9._]*$/)[0]
    end

    def name_of_file(line)
      line.scan(/^([\s]*)([-a-zA-Z0-9._]*)/)[0][1]
    end

    def indentation_level(line)
      line.scan(/^[\s]*/)[0].length
    end

    def name_of_line(line)
      if(is_directory?(line))
         return name_of_directory(line)
      else
         return name_of_file(line)
      end
    end


  def load_structure
    full_path = File.join(my_directory, my_name) + ".structure"
    File.read(full_path)
  end


    # returns a ruby structure representing the desired file structure 
    def parse input
      ## split input into lines, remove comments and evaluate any variables

      lines = input.split("\n").delete_if { |l| 
        l == "" || l =~ /^;;/ }.map{ |l| evaluate_line l }

      scan lines
    end

    # returns a hash
    def scan(lines)
      h = Hash.new

      old_indent_level = indentation_level(lines[0])

      while(true) do

        return h if lines.empty?

        indent_level = indentation_level(lines[0])
        return h if(indent_level < old_indent_level)

        line = lines.shift      # shift modifies lines
        line_name = name_of_line(line)

        if is_directory?(line)
          if lines.empty?       # directory as last line
            h[line_name] = {}
          elsif indentation_level(lines[0]) > indent_level
            h[line_name] = scan(lines)
          else
            h[line_name] = {}
          end
        else
          h[line_name] = template_for_file(line)
        end
      end
    end

  end

end
