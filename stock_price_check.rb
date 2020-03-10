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

# Essentially the same as the ticker that the user inputs
# However we use this method as the user input is error checked first
# *******************
# NEEDS TESTS OF HASH_TABLE TO MAKE SURE THIS IS VALID
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
    return (price_change_from_52w_h/week_52_high).round(5)
end

# Get percentage price change from 52 week low to current price
def get_pct_change_52w_l(stock)
    price_change_from_52w_l = get_price_change_52w_l(stock)
    week_52_low = get_52w_low(stock)
    return (price_change_from_52w_l/week_52_low).round(5)
end

# Displays stock ticker, company name, sector, 
def print_single_stock_info(stock)
    # *************
    # NEED TO TEST IF THIS IS VALID OR WHETHER STOCK_TICKER SHOULD BE PASSED IN AS AN ARGUMENT TO METHOD AS WELL
    stock_ticker = get_stock_symbol(stock)
    rows = []
    rows.push([stock_ticker, get_company_name(stock_ticker), get_stock_sector(stock_ticker), get_stock_price(stock),
            get_pe_ratio(stock)])
    table = Terminal::Table.new :rows => rows
    table = Terminal::Table.new :headings => ['Ticker','Company','Sector', 'Price', 'PE Ratio'], :rows => rows
    puts table
end


# Displays stock price + price changes from key points in % terms 
# Price, % change from yesterday, % change from 52w_high, % change from 52w_low 
def print_single_stock_price_pct(stock)
    rows = []
    # Check if price is up from yesterday, if so colour the price and % change green
    # Price values are converted into strings for purposes of printing in order to colorize output
    if get_price_change_y_day(stock) > 0
        rows.push([get_stock_symbol(stock), "$".colorize(:green) + get_stock_price(stock).to_s.colorize(:green), 
                (get_pct_change_y_day(stock)*100).round(2).to_s.colorize(:green) + "%".colorize(:green), 
                (get_pct_change_52w_h(stock)*100).round(2).to_s.colorize(:red)+ "%".colorize(:red), 
                (get_pct_change_52w_l(stock)*100).round(2).to_s.colorize(:green) + "%".colorize(:green)])
    # Check if price is down from yesterday, if so colour the price and % change red
    elsif get_price_change_y_day(stock) < 0
        rows.push([get_stock_symbol(stock), "$".colorize(:red) + get_stock_price(stock).to_s.colorize(:red), 
                (get_pct_change_y_day(stock)*100).round(2).to_s.colorize(:red) + "%".colorize(:red),
                (get_pct_change_52w_h(stock)*100).round(2).to_s.colorize(:red) + "%".colorize(:red), 
                (get_pct_change_52w_l(stock)*100).round(2).to_s.colorize(:green) + "%".colorize(:green)])
    else
        rows.push([get_stock_symbol(stock), "$" + get_stock_price(stock).to_s, "0%", 
                (get_pct_change_52w_h(stock)*100).round(2).to_s.colorize(:red)+ "%".colorize(:red), 
                (get_pct_change_52w_l(stock)*100).round(2).to_s.colorize(:green)+ "%".colorize(:red)])
    end

    table = Terminal::Table.new :rows => rows
    table = Terminal::Table.new :headings => ['Stock', 'Price','% From Prev Day','% From 52 Week High','% From 52 Week Low'], :rows => rows
    puts table
end

# Displays extended information compared to print_single_stock_price
# Price, % change from yesterday, % change ytd, % change from 52w_high, % change from 52w_low 
def print_single_stock_price(stock)


end

puts "Welcome to the S&P 500 Stock Tracker"
puts "You can check the prices of stocks that are in the S&P 500 by entering a stock ticker"

while make_stock_price_check == true
    puts "Enter a stock ticker from the S&P500:"
    stock_ticker = gets.chomp.upcase
    stock = get_stock(stock_ticker)
    # print_single_stock_info(stock)
    print_single_stock_price_pct(stock)

    puts "Would you like to check another stock? (y/n):"
    another_stock_check = gets.chomp
    if another_stock_check != "y"
        make_stock_price_check = false
    end
end