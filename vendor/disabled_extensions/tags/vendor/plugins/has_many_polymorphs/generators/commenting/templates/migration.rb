
# A migration to add tables for Comment and Commenting. This file is automatically generated and added to your app if you run the commenting generator.

class CreateCommentsAndCommentings < ActiveRecord::Migration

  # Add the new tables.
  def self.up
    create_table :comments do |t|
      t.column :name, :string, :null => false
      t.column :url, :string
      t.column :email, :string
      t.column :body, :text
    end

    create_table :commentings do |t|
      t.column :<%= parent_association_name -%>_id, :integer, :null => false
      t.column :commentable_id, :integer, :null => false
      t.column :commentable_type, :string, :null => false
    end
  end

  # Remove the tables.
  def self.down
    drop_table :comments
    drop_table :commentings
  end

end
