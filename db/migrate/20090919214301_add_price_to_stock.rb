class AddPriceToStock < ActiveRecord::Migration
  def self.up
    add_column :stocks, :price, :decimal
  end

  def self.down
    remove_column :stocks, :price
  end
end
