

def add_include_path(path)
  $:.unshift(path) unless
    $:.include?(path) || $:.include?(File.expand_path(path))
end

add_include_path(File.dirname(__FILE__))

require 'ignite/dir_additions'
require 'ignite/string_additions'
require 'ignite/parser'
require 'ignite/base_ignitor'


