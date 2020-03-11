# Interactive stock price app which will allow a user 
# to query the app for prices of stocks in the S&P500.
# The app will then display the stock in a neat table format.

require 'stock_quote'
require 'colorize'
require 'terminal-table' #if required in 'stock_print_methods.rb' is it needed here?
require_relative 'sp500_hash_table.rb' #needed if in 'stock_print_methods.rb' file?
require_relative 'iex_API_Key.rb'
require_relative 'stock_getter_methods.rb'
require_relative 'stock_print_methods.rb'

# API_KEY is hidden - sign up to iexcloud.io with account to get one
# Initialising the Stock class from 'stock_quote' - allows us to use the IEX API
StockQuote::Stock.new(api_key: API_KEY)

make_stock_price_check = true

puts "Welcome to the S&P 500 Stock Tracker"
puts "You can check the prices of stocks that are in the S&P 500 by entering a stock ticker"

while make_stock_price_check == true
    # puts "This is a list of all the S&P 500 stock tickers"
    # print_list_of_stock_tickers()
    puts "Enter a stock ticker from the S&P500:"
    stock_ticker = gets.chomp.upcase
    stock = get_stock(stock_ticker)
    # print_single_stock_info(stock)
    # print_single_stock_price_pct(stock)
    print_single_stock_price(stock)

    puts "Would you like to check another stock? (y/n):"
    another_stock_check = gets.chomp
    if another_stock_check != "y"
        make_stock_price_check = false
    end
end