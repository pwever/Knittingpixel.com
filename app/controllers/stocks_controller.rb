class StocksController < ApplicationController
  require 'open-uri'
  @@YAHOO_URL = 'http://finance.yahoo.com/d/quotes.csv?f=sl1d1t1c1ohgv&e=.csv&s='
  
  def index()
    @stocks = Stock.find(:all, :order => :symbol)
    
    begin
      fetchPrices()
    rescue
      flash.now[:warning] = "Error fetching current prices."
    end
  end
  
  def fetchPrices
    symbols = []
    path = "tmp/cache/stock_prices.cache"
    if (!File.exist?(path) || ((Time.new()-File.mtime(path))>(60*5)))
      # fetch new file
      @stocks.each {|stock| symbols.push(stock.symbol) unless stock.sold }
      symbols.uniq!
      p @@YAHOO_URL+symbols.join(',')
      fetched_prices = open(@@YAHOO_URL+symbols.join(',')).readlines
      # build price-hash
      prices = {}
      fetched_prices.each do |line|
        line = line.delete('"')
        sym, pri = line.split(/,/)[0,2]
        puts "stock %s:%f.2" % [sym, pri]
        prices[sym.downcase] = pri.to_f || 0
      end
      # update stocks
      @stocks.each do |stock|
        stock.price = prices[stock.symbol.downcase] if prices.key?(stock.symbol.downcase)
        stock.save
      end
      # write to file
      f = File.new(path, 'w+')
      f.chmod(0664)
      f.write(fetched_prices)
      f.close()
      # put up note
      flash.now[:notice] = "Fetched new stock prices."
    end
    
    
  end
  
  # GET /stocks
  # GET /stocks.xml
  def index_old
    @stocks = Stock.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stocks }
    end
  end
  
  def details
    @stocks = Stock.find(:all)
    
    respond_to do |format|
      format.html # detail.html.erb
      format.xml  { render :xml => @stocks }
    end
  end

  # GET /stocks/1
  # GET /stocks/1.xml
  def show
    @stock = Stock.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @stock }
    end
  end

  # GET /stocks/new
  # GET /stocks/new.xml
  def new
    @stock = Stock.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @stock }
    end
  end

  # GET /stocks/1/edit
  def edit
    @stock = Stock.find(params[:id])
  end

  # POST /stocks
  # POST /stocks.xml
  def create
    @stock = Stock.new(params[:stock])

    respond_to do |format|
      if @stock.save
        flash[:notice] = 'Stock was successfully created.'
        format.html { redirect_to(@stock) }
        format.xml  { render :xml => @stock, :status => :created, :location => @stock }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @stock.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /stocks/1
  # PUT /stocks/1.xml
  def update
    @stock = Stock.find(params[:id])

    respond_to do |format|
      if @stock.update_attributes(params[:stock])
        flash[:notice] = 'Stock was successfully updated.'
        format.html { redirect_to(@stock) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @stock.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stocks/1
  # DELETE /stocks/1.xml
  def destroy
    @stock = Stock.find(params[:id])
    @stock.destroy

    respond_to do |format|
      format.html { redirect_to(stocks_url) }
      format.xml  { head :ok }
    end
  end
end
