module StocksHelper
  
  # takes a number and options hash and outputs a string in any currency format
  def currencify(number, options={})
    # :currency_before => false puts the currency symbol after the number
    # default format: $12,345,678.90
    options = {:currency_symbol => "$", :delimiter => ",", :decimal_symbol => ".", :currency_before => true}.merge(options)

    # split integer and fractional parts 
    int, frac = ("%.2f" % number).split('.')
    # insert the delimiters
    int.gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{options[:delimiter]}")

    if options[:currency_before]
      options[:currency_symbol] + int + options[:decimal_symbol] + frac
    else
      int + options[:decimal_symbol] + frac + options[:currency_symbol]
    end
  end
  
  def currencify_rounded(number, options={})
    # :currency_before => false puts the currency symbol after the number
    # default format: $12,345,678
    options = {:currency_symbol => "$", :delimiter => ",", :decimal_symbol => ".", :rounded => true}.merge(options)

    # split integer and fractional parts 
    int, frac = ("%.2f" % number).split('.')
    # insert the delimiters
    int.gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{options[:delimiter]}")

    if options[:rounded]
      options[:currency_symbol] + int
    else
      options[:currency_symbol] + int + options[:decimal_symbol] + frac
    end
  end
  
end
