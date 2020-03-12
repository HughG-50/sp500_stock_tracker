# Methods for reading/writing to files and printing watchlist

require 'terminal-table'
require_relative 'sp500_hash_table.rb'

# Method for reading input from terminal and saving to file
def set_watchlist()
    watch_list_arr = []

    puts "Enter all stock tickers that you wish to have in your watchlist."
    puts "Each new stock ticker should be on a new line - Enter blank when done:"
    # Reads in user input from command line
    while true
        input = gets.chomp.upcase()
        break if input.empty?
        watch_list_arr.push(input)
    end

    watch_list_string = watch_list_arr.join("\n")
    #if watch_list.txt does not exist it will create it
    #WARNING - this will overwrite any existing watchlist data
    File.open("watchlist.txt", "w") do |file| 
        file.write(watch_list_string)
    end

end

# Returns the watchlist that is stored in the watch_list.txt file
def get_watchlist()
    text_array = []
    File.open("./watchlist.txt", "r") do |file|
        text_array = file.read.split("\n")
    end

    return text_array
end

# Prints contents of watchlist file
def show_watchlist()
    puts get_watchlist
end

# Get watchlist stocks
# Returns array of stock objects
def get_watchlist_stocks(watchlist)
    stocks = StockQuote::Stock.quote(watchlist)
end

# Displays stock ticker, company name, sector, price, PE ratio
def print_watchlist_info(stocks)
    table_rows = []

    for i in 0..stocks.length-1
        make_table_rows_stock_info(table_rows, stocks[i])
    end

    make_table("Watchlist", ['Ticker','Company','Sector', 'Price', 'PE Ratio'], table_rows)
end

# Displays 
# Displays stock price + price changes from key points in % terms 
# Price, % change from yesterday, % change from 52w_high, % change from 52w_low 
def print_watchlist_stock_prices_pct(stocks)
    table_rows = []  

    for i in 0..stocks.length-1
        set_rows_price_pct(table_rows, stocks[i])
    end

    make_table("Watchlist", ['Stock', 'Price','% Change Prev Day','% Change YTD','% From 52 Week High','% From 52 Week Low'], table_rows)
end

# Displays extended information compared to print_single_stock_price
# Price, price change from yesterday, price change ytd, price change from 52w_high, price change from 52w_low 
def print_watchlist_stock_prices(stocks)
    table_rows = []
    
    for i in 0..stocks.length-1
        set_rows_price(table_rows, stocks[i])
    end

    make_table("Watchlist", ['Stock', 'Price','Price Change from Prev Day','Price Change YTD','Change from 52 Week High','Change From 52 Week Low'], table_rows)
end

set_watchlist()
watchlist = get_watchlist()
stocks = get_watchlist_stocks(watchlist)
print_watchlist_info(stocks)
print_watchlist_stock_prices(stocks)
print_watchlist_stock_prices_pct(stocks)
