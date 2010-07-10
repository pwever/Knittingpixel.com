class CreateTodos < ActiveRecord::Migration
  def self.up
    create_table :todos do |t|
      t.string :label
      t.timestamp :due_at
      t.timestamp :done_at
      t.integer :project_id
      t.string :raw_input

      t.timestamps
    end
  end

  def self.down
    drop_table :todos
  end
end
