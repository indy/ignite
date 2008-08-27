
ignite_lib = File.join(File.dirname(__FILE__), '..', 'lib')
$:.unshift(ignite_lib) unless $:.include? ignite_lib

require 'test/unit'
require 'ignite'

class Test::Unit::TestCase

  def assert_directory_exists directory_name
    assert(File.directory?(directory_name))
  end
end
