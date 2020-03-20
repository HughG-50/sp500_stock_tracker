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

# Returns the portfolio that is stored in the portfolio.txt file
def get_portfolio()
    portfolio_arr = []
    stock_item_arr = []
    File.open("./portfolio.txt", "r") do |file|
        portfolio_arr = file.read.split("\n")
    end

    for i in 0..portfolio_arr.length-1
        stock_item_arr = portfolio_arr[i].split(" ")
        stock_item_arr[1].to_i()
        portfolio_arr[i] = stock_item_arr
    end

    return portfolio_arr
end

# Prints contents of portfolio file
def show_portfolio()
    portfolio_array = get_portfolio()
    
    for i in 0..portfolio_array.length-1
        puts "#{portfolio_array[i][0]} #{portfolio_array[i][1]}"
    end
end

# set_portfolio()
# # p get_portfolio()
# show_portfolio()