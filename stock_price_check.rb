# Interactive stock price app which will allow a user 
# to query the app for prices of stocks in the S&P500.
# The app will then display the stock in a neat table format.

require 'stock_quote'
require 'colorize'
require 'terminal-table' 
require 'tty-prompt'
# require 'cli/ui'

require_relative 'sp500_hash_table.rb' 
require_relative 'iex_API_Key.rb'
require_relative 'stock_getter_methods.rb'
require_relative 'stock_print_methods.rb'

# API_KEY is hidden - sign up to iexcloud.io with account to get one
# Initialising the Stock class from 'stock_quote' - allows us to use the IEX API
StockQuote::Stock.new(api_key: API_KEY)

# Initialise 'TTY-Prompt'
prompt = TTY::Prompt.new

# Initialising the flow control loop for user interaction to true
make_stock_price_check = true
user_options = ["Get stock information", "Get extended stock price information", 
                "Get extended stock price information in %s", "Show list of available stock tickers"]

puts "Welcome to the S&P 500 Stock Tracker"

while make_stock_price_check == true
    user_choice = prompt.select("Please choose which function you'd like to use:", user_options)
    # puts user_choice

    if user_choice == "Get stock information"
        puts "Enter a stock ticker from the S&P500:"
        stock_ticker = gets.chomp.upcase
        stock = get_stock(stock_ticker)
        print_single_stock_info(stock)
    elsif user_choice == "Get extended stock price information"
        puts "Enter a stock ticker from the S&P500:"
        stock_ticker = gets.chomp.upcase
        stock = get_stock(stock_ticker)
        print_single_stock_price(stock)
    elsif user_choice == "Get extended stock price information in %s"
        puts "Enter a stock ticker from the S&P500:"
        stock_ticker = gets.chomp.upcase
        stock = get_stock(stock_ticker)
        print_single_stock_price_pct(stock)
    elsif user_choice == "Show list of available stock tickers"
        puts "This is a list of all of the available tickers to check onthe S&P 500:"
        print_list_of_stock_tickers()
    end

    # replace these two lines with a TTY-Prompt
    puts "Keep using S&P 500 Stock Tracker? (y/n):"
    keep_using = gets.chomp
    if keep_using != "y"
        make_stock_price_check = false
    end

end