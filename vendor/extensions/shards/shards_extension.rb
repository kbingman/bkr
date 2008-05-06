# Uncomment this if you reference any of your controllers in activate
require_dependency 'application'
require 'ostruct'

class ShardsExtension < Radiant::Extension
  version "0.3"
  description "Enables flexible manipulation of the administration user-interface."
  url "http://dev.radiantcms.org/svn/radiant/trunk/extensions/shards"
    
  def activate
    ApplicationController.send :helper, Shards::HelperExtensions
    #helpers aren't automatically inherited by already loaded classes
    ApplicationController.descendants.each do |controller|
      controller.send :helper, Shards::HelperExtensions
    end
    Radiant::AdminUI.class_eval do
      attr_accessor :page, :user, :snippet, :layout
    end
    # initialize regions for page, snippet and layout
    admin.page = load_default_page_regions
    admin.user = load_default_user_regions
    admin.snippet = load_default_snippet_regions
    admin.layout = load_default_layout_regions
    
    Admin::PageController.class_eval do
      before_filter :only => :add_part do |c|
        c.send :instance_variable_set, '@template_name', 'edit'
      end
    end
  end
  
  def deactivate
  end
  
  private
    def load_default_page_regions
      returning OpenStruct.new do |page|
        page.edit = Shards::RegionSet.new do |edit|
            edit.main.concat %w{edit_header edit_form edit_popups}
            edit.form.concat %w{edit_title edit_extended_metadata
                                  edit_page_parts}
            edit.form_bottom.concat %w{edit_buttons}
            edit.parts_bottom.concat %w{edit_layout_and_type edit_timestamp}
        end
        page.index = Shards::RegionSet.new do |index|
          index.sitemap_head.concat %w{title_column_header status_column_header
                                      modify_column_header}
          index.node.concat %w{title_column status_column add_child_column remove_column}
        end
        page.remove = page.children = page.index
      end
    end

    def load_default_user_regions
      returning OpenStruct.new do |user|
        user.edit = Shards::RegionSet.new do |edit|
          edit.main.concat %w{edit_header edit_form}
          edit.form.concat %w{edit_table_header edit_name edit_email edit_login edit_password 
                              edit_password_confirmation edit_roles edit_notes edit_table_footer
                              edit_timestamp}
          edit.form_bottom.concat %w{edit_buttons}
        end
      end
    end

    def load_default_snippet_regions
      returning OpenStruct.new do |snippet|
        snippet.edit = Shards::RegionSet.new do |edit|
          edit.main.concat %w{edit_header edit_form}
          edit.form.concat %w{edit_title edit_content edit_filter edit_timestamp}
          edit.form_bottom.concat %w{edit_buttons}
        end
      end
    end

    def load_default_layout_regions
      returning OpenStruct.new do |layout|
        layout.edit = Shards::RegionSet.new do |edit|
          edit.main.concat %w{edit_header edit_form}
          edit.form.concat %w{edit_title edit_extended_metadata edit_content edit_timestamp}
          edit.form_bottom.concat %w{edit_buttons}
        end
      end
    end
end

