class Stock < ActiveRecord::Base

  def days_held
    tmp = (sell_date!=nil) ? sell_date : Date.today
    return (tmp-buy_date).to_i
  end

  def years_held
    if days_held>0 then
      years = days_held/365.0
    else
      years = 1/365.0
    end
    return years
  end

  def market_value
    p = sold ? sell_price : price
    return 0 if p==nil
    return p * shares
  end

  def original_investment
    return buy_price * shares
  end

  def has_gained
    g = gain()
    return (g>0)
  end

  def gain
    p = sold ? sell_price : price
    return 0 if p==nil
    return shares * (p-buy_price)
  end

  def percentage_gain
    p = sold ? sell_price : price
    return 0 if p==nil
    return 100 * (p/buy_price) - 100
  end

  def yearly_gain
    return percentage_gain()/years_held
  end

end
