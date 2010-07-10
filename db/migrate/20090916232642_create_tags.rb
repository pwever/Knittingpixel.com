class CreateTags < ActiveRecord::Migration
  def self.up
    
    create_table :tags do |t|
      t.string :label

      t.timestamps
    end
    
    create_table :todos_tags do |t|
      t.integer :todo_id
      t.integer :tag_id
    end
    
  end

  def self.down
    drop_table :tags
    drop_table :todos_tags
  end
end
