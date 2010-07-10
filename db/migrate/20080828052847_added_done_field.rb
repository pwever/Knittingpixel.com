class AddedDoneField < ActiveRecord::Migration
  def self.up
    add_column :todos, :done, :boolean, :default => 0
  end

  def self.down
    remove_column :todos, :done
  end
end
