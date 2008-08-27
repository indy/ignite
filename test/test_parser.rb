require 'abstract_unit'

class TestPlugin < Test::Unit::TestCase

  include Ignite::Parser

  def app_name
    "test_app"
  end
    
  def my_var 
    "my_var_result"
  end

  def test_evaluate_line
    { "nochange" => "nochange",
      "%my_var%" => my_var,
      "prefix_%my_var%" => "prefix_" + my_var,
      "%my_var%_postfix" => my_var + "_postfix",
      "a%my_var%b%my_var%" => "a" + my_var + "b" + my_var,
      "foo%4+4%bar" => "foo8bar"
    }.each { |input, expected|
      assert_equal(expected, evaluate_line(input))
    }
  end

  def test_is_directory
    assert(is_directory?("foo/"))
    assert(!is_directory?("bar"))
  end

  def test_template_for_file
    { "Rakefile" => "Rakefile",
      "    indent" => "indent",
      "testfile.rb" => "testfile.rb",
      "testfile.rb   " => "testfile.rb",
      "test-file.rb" => "test-file.rb",
      "test_file.rb" => "test_file.rb",
      "something => somethingelse" => "somethingelse"
    }.each { |input, expected|
      assert_equal(expected, template_for_file(input)) 
    }
  end

  def test_name_of_file
    { "Rakefile" => "Rakefile",
      "    indent" => "indent",
      "testfile.rb" => "testfile.rb",
      "testfile.rb   " => "testfile.rb",
      "test-file.rb" => "test-file.rb",
      "test_file.rb" => "test_file.rb",
      "something => somethingelse" => "something"
    }.each { |input, expected|
      assert_equal(expected, name_of_file(input)) 
    }
  end

  def test_name_of_directory
    { "some_dir/" => "some_dir",
      "  some_dir/" => "some_dir"
    }.each { |input, expected|
      assert_equal(expected, name_of_directory(input)) 
    }
  end


  def test_indentation_level
    { "no_indentation" => 0,
      "  one_level" => 2,
      "    second_level" => 4
    }.each { |input, expected|
      assert_equal(expected, indentation_level(input) )
    }
  end


  def test_parse
    input = <<BAR
%app_name%/
  pkg/
  Rakefile
  lib/
    %app_name%.rb => app_name.rb
    %app_name%/
  test/
    abstract_unit.rb
    test_sample.rb
  bin/
BAR

    output = { "#{app_name}" => {
        "bin" => {},
        "lib" => {
          "#{app_name}.rb" => "app_name.rb",
          "#{app_name}" => {} },
        "pkg" => {},
        "test" => {
          "abstract_unit.rb" => "abstract_unit.rb",
          "test_sample.rb" => "test_sample.rb" },
        "Rakefile" => "Rakefile"}}

    assert_equal(output, parse(input))

  end

end
