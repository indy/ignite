require 'abstract_unit'

class TestStringAdditions < Test::Unit::TestCase

  def setup
    @c_to_u = { 
      "Simple" => "simple",
      "TwoWords" => "two_words",
      "Class42" => "class_42"
    }

  end

  def test_camel_to_underscore
    @c_to_u.each do |camel, underscored|
      assert_equal(underscored, camel.camel_to_underscore)
    end
  end

  def test_underscore_to_camel
    @c_to_u.each do |camel, underscored|
      assert_equal(camel, underscored.underscore_to_camel)
    end
  end
end
