require 'abstract_unit'

class TestPlugin < Test::Unit::TestCase

  include Ignite

  def setup
    # load plugins from the test plugins folder
    BaseIgnitor.load_default_plugins
    BaseIgnitor.load_plugins(File.join(File.dirname(__FILE__), "plugins"))
  end

  def test_show_help
    # go through all the plugins and call their description method
    BaseIgnitor.display_help
  end

end
