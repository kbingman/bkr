require File.dirname(__FILE__) + '/../test_helper'

class LegacyTagsExtensionTest < Test::Unit::TestCase
  
  # Replace this with your real tests.
  def test_this_extension
    flunk
  end
  
  def test_initialization
    assert_equal RADIANT_ROOT + '/vendor/extensions/legacy_tags', LegacyTagsExtension.root
    assert_equal 'Legacy Tags', LegacyTagsExtension.extension_name
  end
  
end
