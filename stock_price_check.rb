# Interactive stock price app which will allow a user 
# to query the app for prices of stocks in the S&P500.
# The app will then display the stock in a neat table format.

require 'stock_quote'
require 'colorize'
require 'terminal-table'
require './sp500_hash_table.rb'
require './iex_API_Key.rb'

# API_KEY is hidden - sign up to iexcloud.io with account to get one
# Initialising the Stock class from 'stock_quote' - allows us to use the IEX API
StockQuote::Stock.new(api_key: API_KEY)

make_stock_price_check = true

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

# essentially the same as the ticker that the user inputs
def get_stock_symbol(stock)
    return stock.symbol.upcase
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

# Returns a percentage
def get_pct_change_ytd(stock)
    return stock.ytd_change
end

def get_pe_ratio(stock)
    return stock.pe_ratio
end

def get_52w_high(stock)
    return stock.week52_high
end

def get_52w_low(stock)
    return stock.week52_low
end

# Helper functions to calculate price and percentage changes for additional data points

# Converts %ytd_change into price figure
def get_price_change_ytd(stock)
    stock_price = get_stock_price(stock)
    ytd_pct_change = get_pct_change_ytd(stock)
    # Calculate the price at the start of the year
    year_start_price = stock_price - (ytd_pct_change*stock_price)
    # get the price change from the start of year to date
    ytd_price_change = stock_price - year_start_price
    return ytd_price_change.round(2)
end

# Get price change from 52 week high to current price
def get_price_change_52w_h(stock)
    stock_price = get_stock_price(stock)
    week_52_high = get_52w_high(stock)
    return stock_price - week_52_high
end

# Get price change from 52 week low to current price
def get_price_change_52w_l(stock)
    stock_price = get_stock_price(stock)
    week_52_low = get_52w_low(stock)
    return stock_price - week_52_low
end

# Get percentage price change from 52 week high to current price
def get_pct_change_52w_h(stock)
    price_change_from_52w_h = get_price_change_52w_h(stock)
    week_52_high = get_52w_high(stock)
    return price_change_from_52w_h/week_52_high
end

# Get percentage price change from 52 week low to current price
def get_pct_change_52w_l(stock)
    price_change_from_52w_l = get_price_change_52w_l(stock)
    week_52_low = get_52w_low(stock)
    return price_change_from_52w_l/week_52_low
end

# Displays price and % price change since yesterday in table format
def print_single_stock_price(stock)
    
    rows = []
    # Check if price is up from yesterday, if so colour the price and % change green
    # Price values are converted into strings for purposes of printing in order to colorize output
    if get_price_change_y_day(stock) > 0
        rows.push([get_stock_symbol(stock), "$".colorize(:green) + get_stock_price(stock).to_s.colorize(:green), 
                get_pct_change_y_day(stock).to_s.colorize(:green) + "%".colorize(:green)])
    # Check if price is down from yesterday, if so colour the price and % change red
    elsif get_price_change_y_day(stock) < 0
        rows.push([get_stock_symbol(stock), "$".colorize(:red) + get_stock_price(stock).to_s.colorize(:red), 
            get_pct_change_y_day(stock).to_s.colorize(:red) + "%".colorize(:red)])
    else
        rows.push([get_stock_symbol(stock), "$" + get_stock_price(stock).to_s, "0%"])
    end

    table = Terminal::Table.new :rows => rows
    table = Terminal::Table.new :headings => ['Stock', 'Price', '% Change from previous day'], :rows => rows
    puts table
end

puts "Welcome to the S&P 500 Stock Tracker"
puts "You can check the prices of stocks that are in the S&P 500 by entering a stock ticker"

while make_stock_price_check == true
    puts "Enter a stock ticker from the S&P500:"
    stock_ticker = gets.chomp.upcase
    stock = get_stock(stock_ticker)
    print_single_stock_price(stock)

    puts "Would you like to check another stock? (y/n):"
    another_stock_check = gets.chomp
    if another_stock_check != "y"
        make_stock_price_check = false
    end
end