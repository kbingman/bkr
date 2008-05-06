class ReorderExtension < Radiant::Extension
  version "1.0"
  description "Adds the ability to reorder the children of a page."
  url "http://dev.radiantcms.org/svn/radiant/branches/mental/extensions/reorder"

  define_routes do |map|
    map.page_reorder_children  'admin/pages/reorder/:id', :controller => 'admin/page', :action => 'reorder'
  end
  
  def activate
    raise "The Shards extension is required and must be loaded first!" unless defined?(Shards)
    admin.page.index.add :sitemap_head, 'reorder_extra_th'
    admin.page.index.add :node, 'reorder_extra_td', :after => "add_child_column"

    Page.send :include, ReorderPageExtensions, ReorderTagExtensions
    Page.reflections[:children].options[:order] = "position ASC"
    
    StandardTags.class_eval do
      unless method_defined?(:children_find_options_with_position)
        def children_find_options_with_position(tag)
          default_options = children_find_options_without_position(tag)
          default_options[:order].sub! /published_at/, 'position' if tag.attr.symbolize_keys[:by].nil?
          default_options
        end
        alias_method_chain :children_find_options, :position
      end
    end
    
    require_dependency 'application'
    Admin::PageController.send :include, ReorderPageControllerExtensions
    Admin::PageController.send :helper, ReorderPageHelperExtensions
  end
  
  def deactivate
  end
    
end