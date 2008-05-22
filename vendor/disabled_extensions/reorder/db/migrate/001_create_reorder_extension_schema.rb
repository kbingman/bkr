class CreateReorderExtensionSchema < ActiveRecord::Migration
  class << self
    def up
      add_column "pages", "position", :integer, :default => 0, :null => false
      Page.reset_column_information
      update_position_column
    end

    def down
      remove_column "pages", "position"
    end

    private

      def update_position_column
        pages = Page.find(:all).reject { |page| page.children.empty? }
        pages.each do |page|
          children = page.children.find(:all, :order => 'virtual DESC, title ASC')
          children.each_with_index do |child, index|
            child.update_attribute :position, index
          end
        end
      end
  end
end