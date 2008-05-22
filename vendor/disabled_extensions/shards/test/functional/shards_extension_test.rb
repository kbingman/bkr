require File.dirname(__FILE__) + '/../test_helper'

class ShardsExtensionTest < Test::Unit::TestCase
  
  def test_initialization
    assert_equal 'Shards', ShardsExtension.extension_name
  end
  
  def test_should_create_page_region_sets
    admin = Radiant::AdminUI.instance
    assert_respond_to admin, :page
    assert_not_nil admin.page
    assert_instance_of OpenStruct, admin.page
  end
  
  def test_page_edit_region_set_default_settings
    page = ShardsExtension.instance.send(:load_default_page_regions)
    %w{edit remove children index}.each do |action|
      assert_not_nil page.send(action)
      assert_instance_of Shards::RegionSet, page.send(action)
    end
    assert_equal %w{edit_header edit_form edit_popups}, page.edit.main
    assert_equal %w{edit_title edit_extended_metadata
                              edit_page_parts}, page.edit.form
    assert_equal %w{edit_layout_and_type edit_timestamp}, page.edit.parts_bottom
    assert_equal %w{edit_buttons}, page.edit.form_bottom
    assert_equal %w{title_column_header status_column_header
                                modify_column_header}, page.index.sitemap_head
    assert_equal %w{title_column status_column add_child_column remove_column},
                  page.index.node
    assert_same page.index, page.remove
    assert_same page.index, page.children
  end
  
  def test_should_create_snippet_region_sets
    admin = Radiant::AdminUI.instance
    assert_respond_to admin, :snippet
    assert_not_nil admin.snippet
    assert_kind_of OpenStruct, admin.snippet
  end

  def test_should_initialize_snippet_region_defaults
    snippet = ShardsExtension.instance.send(:load_default_snippet_regions)
    assert_not_nil snippet.edit
    assert_equal %w{edit_header edit_form}, snippet.edit.main    
  end

  def test_should_create_layout_region_sets
    admin = Radiant::AdminUI.instance
    assert_respond_to admin, :layout
    assert_not_nil admin.layout
    assert_kind_of OpenStruct, admin.layout
  end
  
  def test_should_initialize_layout_region_defaults
    layout = ShardsExtension.instance.send(:load_default_layout_regions)
    assert_not_nil layout.edit
    assert_equal %w{edit_header edit_form}, layout.edit.main
  end

  def test_should_create_user_region_sets
    admin = Radiant::AdminUI.instance
    assert_respond_to admin, :user
    assert_not_nil admin.layout
    assert_kind_of OpenStruct, admin.user
  end

  def test_should_initialize_user_region_defaults
    user = ShardsExtension.instance.send(:load_default_user_regions)
    assert_not_nil user.edit
    assert_equal %w{edit_header edit_form}, user.edit.main
  end
  
  def test_should_add_render_region_helper
    assert ApplicationController.master_helper_module.included_modules.include?(Shards::HelperExtensions)
  end
end
