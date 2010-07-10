class AddSoldToStock < ActiveRecord::Migration
  def self.up
    add_column :stocks, :sold, :boolean, :default => false
    
    stocks = Stock.find :all
    stocks.each do |s|
      s.sold = true if s.sell_date!=nil
      s.save
    end
    
  end

  def self.down
    stocks = Stock.find :all
    stocks.each do |s|
      s.sell_date = nil if s.sold==false
      s.save
    end
    
    remove_column :stocks, :sold
  end
end
