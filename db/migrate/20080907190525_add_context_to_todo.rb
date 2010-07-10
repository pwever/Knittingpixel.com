class AddContextToTodo < ActiveRecord::Migration
  def self.up
    add_column :todos, :context_id, :int
  end

  def self.down
    remove_column :todos, :context_id
  end
end
