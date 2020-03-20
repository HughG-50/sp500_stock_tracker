# Methods for reading/writing to files and printing portfolio

require 'terminal-table'
require_relative 'sp500_hash_table.rb'

def is_positive_int(number)
    return number.is_a?(Integer) && number > 0
end

# Method for reading input from terminal and saving to file
def set_portfolio()
    # initialize empty 2D array - I don't think we need to declare like [][]
    portfolio_arr = []
    stock_ticker_and_num_of_stock_arr = []

    puts "Enter all stock tickers that you wish to have in your portfolio."
    puts "Each new stock ticker should be on a new line - Enter blank when done:"
    # Reads in user input from command line
    while true
        input = gets.chomp.upcase()
        break if input.empty?
        # Converts second input from string to integer to be able to error check
        stock_ticker_and_num_of_stock_arr = input.split(" ")
        stock_ticker_and_num_of_stock_arr[1] = stock_ticker_and_num_of_stock_arr[1].to_i()
        # p "Input stock ticker + num stocks arr: #{stock_ticker_and_num_of_stock_arr}"
        
        # Error handling - only allows valid stock tickers to be entered
        if SP500_HASH_TABLE.has_key?(stock_ticker_and_num_of_stock_arr[0]) && is_positive_int(stock_ticker_and_num_of_stock_arr[1])
            portfolio_arr.push(stock_ticker_and_num_of_stock_arr)
        end
    end

    # p "portfolio_arr: #{portfolio_arr}"
    # portfolio_string = portfolio_arr.join("\n")

    # converts back to original input as a single string for each stock and number - e.g. 'AAPL 2' is a single string
    for i in 0..portfolio_arr.length-1
        stock_tick_and_num_of_stock_string = portfolio_arr[i].join(" ")
        portfolio_arr[i] = stock_tick_and_num_of_stock_string
    end

    # p "portfolio_arr: #{portfolio_arr}"
    portfolio_string = portfolio_arr.join("\n")
    # p "portfolio string: #{portfolio_string}"

    #if portfolio.txt does not exist it will create it
    #WARNING - this will overwrite any existing portfolio data
    File.open("portfolio.txt", "w") do |file| 
        file.write(portfolio_string)
    end

end

# NEEDS UPDATING SO WE GET THE NUMBERS AND SUCH IN CORRECT FORMAT IN A USABLE ARRAY
# Returns the portfolio that is stored in the portfolio.txt file
def get_portfolio()
    text_array = []
    File.open("./portfolio.txt", "r") do |file|
        text_array = file.read.split("\n")
    end

    return text_array
end



# Prints contents of portfolio file
def show_portfolio()
    puts get_portfolio()
end

set_portfolio()
p get_portfolio()
show_portfolio()