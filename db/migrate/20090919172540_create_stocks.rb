class CreateStocks < ActiveRecord::Migration
  def self.up
    create_table :stocks do |t|
      t.string :symbol
      t.string :company
      t.float :shares
      t.date :buy_date
      t.decimal :buy_price
      t.date :sell_date
      t.decimal :sell_price

      t.timestamps
    end
        
  end

  def self.down
    drop_table :stocks
  end
end
