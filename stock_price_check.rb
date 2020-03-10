# Interactive stock price app which will allow a user 
# to query the app for prices of stocks in the S&P500.
# The app will then display the stock in a neat table format.

require 'stock_quote'
require 'colorize'
require 'terminal-table'
require './sp500_hash_table.rb'
require './iex_API_Key.rb'

# Normal key
# This line is initialising the API class? - allows us to use the IEX API
# Need to be able to explain what is happening here better
StockQuote::Stock.new(api_key: API_KEY)

make_stock_price_check = false

def get_company_name(stock_ticker)
    return SP500_HASH_TABLE[stock_ticker][0]
end

def get_stock_sector(stock_ticker)
    return SP500_HASH_TABLE[stock_ticker][1]
end

def get_stock(stock_ticker)
    stock = StockQuote::Stock.quote(stock_ticker)
    return stock
end

def get_stock_price(stock)
    return stock.latest_price
end

def get_price_change_y_day(stock)
    return stock.change
end

def get_pct_change_y_day(stock)
    return stock.change_percent
end

def get_price_change_ytd(stock)
    return stock.ytd_change
end

def get_pe_ratio(stock)
    return stock.pe_ratio
end

def get_52_week_high(stock)
    return stock.week52_high
end

def get_52_week_low(stock)
    return stock.week52_low
end

# Helper functions to convert data points into percentages
def get_pct_change_ytd(stock, ytd_price_change)

puts "Welcome to the S&P 500 Stock Tracker"
puts "You can check the prices of stocks that are in the S&P 500 by entering a stock ticker"

while make_stock_price_check == true
    puts "Enter a stock ticker from the S&P500:"
    stock_ticker = gets.chomp.upcase
    stock = get_stock(stock_ticker)
    # stock = StockQuote::Stock.quote(stock_ticker)
    stock_name = get_company_name(stock_ticker)
    stock_sector = get_stock_sector(stock_ticker)
    stock_price = get_stock_price(stock)
    puts "#{stock_ticker} - #{stock_name} current price: #{stock_price}"

    puts "Would you like to check another stock? (y/n):"
    another_stock_check = gets.chomp
    if another_stock_check != "y"
        make_stock_price_check = false
    end
end