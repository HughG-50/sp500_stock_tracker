# Methods for reading/writing to files and printing portfolio

require 'terminal-table'
require_relative 'sp500_hash_table.rb'

# Error checking helper method - checks if number is positive integer
def is_positive_int(number)
    return number.is_a?(Integer) && number > 0
end

# Error checking helper method - checks if string only contains digits
def string_is_digits?(string)
    return string.scan(/\D/).empty?
end

# Method for reading input from terminal and saving to file
def set_portfolio()
    # initialize empty 2D array - I don't think we need to declare like [][]
    portfolio_arr = []
    stock_ticker_and_num_of_stock_arr = []

    puts "Enter stock ticker + amount held"
    puts "Each new stock ticker + amount should be on a new line, with stock ticker and amount separated with a space"
    puts "e.g. 10 shares of Apple Inc. :"
    puts "AAPL 10"
    puts "Enter blank input when done"

    # Reads in user input from command line
    while true
        input = gets.chomp.upcase()
        break if input.empty?
        # Converts second input from string to integer to be able to error check
        stock_ticker_and_num_of_stock_arr = input.split(" ")

        # Error handling - checks if only 2 inputs made and that second value is only a number input
        if stock_ticker_and_num_of_stock_arr.length == 2 && string_is_digits?(stock_ticker_and_num_of_stock_arr[1])
            stock_ticker_and_num_of_stock_arr[1] = stock_ticker_and_num_of_stock_arr[1].to_i()
            # Error handling - only allows valid stock tickers to be entered and check if stocks is integer > 0
            if SP500_HASH_TABLE.has_key?(stock_ticker_and_num_of_stock_arr[0]) && is_positive_int(stock_ticker_and_num_of_stock_arr[1])
                portfolio_arr.push(stock_ticker_and_num_of_stock_arr)
            end
        end
    end

    # converts back to original input as a single string for each stock and number - e.g. 'AAPL 2' is a single string
    for i in 0..portfolio_arr.length-1
        stock_tick_and_num_of_stock_string = portfolio_arr[i].join(" ")
        portfolio_arr[i] = stock_tick_and_num_of_stock_string
    end

    portfolio_string = portfolio_arr.join("\n")

    #if portfolio.txt does not exist it will create it
    #WARNING - this will overwrite any existing portfolio data
    File.open("portfolio.txt", "w") do |file| 
        file.write(portfolio_string)
    end

end

# Returns the portfolio that is stored in the portfolio.txt file as a hash table
def get_portfolio_hash()
    portfolio_arr = []
    portfolio_hash_table = {}
    File.open("./portfolio.txt", "r") do |file|
        portfolio_arr = file.read.split("\n")
    end

    portfolio_arr.each do |array_item|
        # stock ticker is the key and the number of stocks is the value
        key,value = array_item.split(" ") # splitting the array items into key and value
        portfolio_hash_table[key] = value.to_i # storing key => value pairs in the portfolio_hash_table
    end
    
    return portfolio_hash_table
end

# Returns array of the portfolio stock tickers - needed for getting stock objects from API
def get_portfolio_stock_list()
    portfolio_stock_list = []
    portfolio_hash = get_portfolio_hash()
    # Need to make array of all the portfolio hash keys
    portfolio_stock_list = portfolio_hash.keys
    return portfolio_stock_list
end

# Get number of stock owned for stock in portfolio
def get_number_of_stock_owned(stock_ticker)
    portfolio_hash_table = get_portfolio_hash()
    return portfolio_hash_table[stock_ticker]
end

# Prints contents of portfolio file
def show_portfolio()
    portfolio_hash_table = get_portfolio_hash()

    portfolio_hash_table.each do |key, value|
        puts "#{key} #{value}"
    end
end

# Returns array of stock objects
def get_portfolio_stocks(portfolio_stock_list)
    stocks = StockQuote::Stock.quote(portfolio_stock_list)
end

def get_total_portfolio_value(stocks)
    total_value = 0

    for i in 0..stocks.length-1
        stock_ticker = get_stock_symbol(stocks[i])
        price = get_stock_price(stocks[i])
        number_of_stock_owned = get_number_of_stock_owned(stock_ticker)
        stock_holding_value = (number_of_stock_owned*price).round(2)
        total_value += stock_holding_value
    end

    return total_value.round(2)
end

def print_portfolio_total_value(stocks)
    table_rows = []
    total_portfolio_value = get_total_portfolio_value(stocks)
    table_rows.push(["$" + total_portfolio_value.to_s + " USD"])
    make_simple_table(['Total Portfolio Value'], table_rows)
end

# Displays stock ticker, company name, sector, price, PE ratio
def print_portfolio_info(stocks)
    table_rows = []

    for i in 0..stocks.length-1
        stock_ticker = get_stock_symbol(stocks[i])
        number_of_stock_owned = get_number_of_stock_owned(stock_ticker)
        make_table_rows_portfolio_info(table_rows, stocks[i], number_of_stock_owned)
    end

    make_table("Portfolio", ['Ticker','Company','Sector','Price','PE Ratio','Number of Stock','Holdings Value'], table_rows)
end

def print_portfolio_stock_prices(stocks)
    table_rows = []
    
    for i in 0..stocks.length-1
        stock_ticker = get_stock_symbol(stocks[i])
        number_of_stock_owned = get_number_of_stock_owned(stock_ticker)
        set_rows_portfolio_price(table_rows, stocks[i], number_of_stock_owned)
    end

    make_table("Portfolio", ['Stock','Price','Price Change from Prev Day','Price Change YTD','Change from 52 Week High','Change From 52 Week Low','Number of Stock','Holdings Value', 'Holdings Value Change'], table_rows)
end

def print_portfolio_stock_prices_pct(stocks)
    table_rows = []
    
    for i in 0..stocks.length-1
        stock_ticker = get_stock_symbol(stocks[i])
        number_of_stock_owned = get_number_of_stock_owned(stock_ticker)
        set_rows_portfolio_price_pct(table_rows, stocks[i], number_of_stock_owned)
    end

    make_table("Portfolio", ['Stock', 'Price','% Change Prev Day','% Change YTD','% From 52 Week High','% From 52 Week Low','Number of Stock','Holdings Value'], table_rows)
end
