require File.dirname(__FILE__) + '/../test_helper'

class ZBkrInterfaceExtensionTest < Test::Unit::TestCase
  
  # Replace this with your real tests.
  def test_this_extension
    flunk
  end
  
  def test_initialization
    assert_equal File.join(File.expand_path(RADIANT_ROOT), 'vendor', 'extensions', 'z_bkr_interface'), ZBkrInterfaceExtension.root
    assert_equal 'Z Bkr Interface', ZBkrInterfaceExtension.extension_name
  end
  
end
