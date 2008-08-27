
<%= name %>_lib = File.join(File.dirname(__FILE__), '..', 'lib')
$:.unshift(<%= name %>_lib) unless $:.include? <%= name %>_lib

require 'test/unit'
require '<%= name %>'

class Test::Unit::TestCase

# Insert helper functions here 

end
