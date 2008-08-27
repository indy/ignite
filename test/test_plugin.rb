require 'abstract_unit'
require 'find'

class TestPlugin < Test::Unit::TestCase

  include Ignite

  def setup
    # load plugins from the test plugins folder
    BaseIgnitor.load_default_plugins
    BaseIgnitor.load_plugins(File.join(File.dirname(__FILE__), "plugins"))
  end


  # TODO: add this to Dir additions
  def delete_empty_directories(main)
    d = []
    Find.find(main) { |p| d.push p }
    d.reverse.map {|di| Dir.delete(di) if File.exist? di }
  end

  def test_creating_directories
    ignitor_class = BaseIgnitor.select_plugin("basic")

    proj = "test_creating_directories"
    main = File.join(File.dirname(__FILE__), "output", proj)

    # delete any existing #{proj} directory
    delete_empty_directories(main)

    ignitor = ignitor_class.new
    assign_parent_directory_method ignitor
    ignitor.ignite(proj)

    # confirm that the directories have been created
    assert_directory_exists(main)
    assert_directory_exists(File.join(main, "child-a"))
    assert_directory_exists(File.join(main, "child-b"))
    assert_directory_exists(File.join(main, "child-a", "grandchild-a"))
    assert_directory_exists(File.join(main, "child-a", "grandchild-b"))
    
    delete_empty_directories(main)
  end

  def test_loading_plugins
    ignitor_class = BaseIgnitor.select_plugin("basic")
    assert(ignitor_class)
  end

  def test_loading_default_plugins
    ignitor_class = BaseIgnitor.select_plugin("ignite_plugin")
    assert(ignitor_class)
  end

  def test_creating_files
    ignitor_class = BaseIgnitor.select_plugin("create_file_test")

    proj = "test_creating_files"
    main = File.join(File.dirname(__FILE__), "output", proj)

    ignitor = ignitor_class.new
    assign_parent_directory_method ignitor
    ignitor.ignite(proj)

    assert(File.exist?(File.join(main, "some_weird_file.txt")))
    assert(File.exist?(File.join(main, "some_file.txt")))
  end

  def foo_test_already_existing_directory
    ignitor_class = BaseIgnitor.select_plugin("basic")

    proj = "test_already_existing_directory"
    main = File.join(File.dirname(__FILE__), "output", proj)

    ignitor = ignitor_class.new
    assign_parent_directory_method ignitor
    ignitor.ignite(proj)

    ignitor = ignitor_class.new
    assign_parent_directory_method ignitor
    ignitor.ignite(proj)

    # confirm that the directories have been created
    assert_directory_exists(main)
    assert_directory_exists(File.join(main, "child-a"))
    assert_directory_exists(File.join(main, "child-b"))
    assert_directory_exists(File.join(main, "child-a", "grandchild-a"))
    assert_directory_exists(File.join(main, "child-a", "grandchild-b"))
    
    delete_empty_directories(main)

  end

  def foo_test_show_help
    # go through all the plugins and call their description method
    BaseIgnitor.display_help
  end

  def assign_parent_directory_method ignitor
    ignitor.class.send(:define_method, "parent_directory") {
      File.join(File.dirname(__FILE__), "output")
    }
  end

end
