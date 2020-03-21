# Interactive stock price app which will allow a user 
# to query the app for prices of stocks in the S&P500.
# The app will then display the stock in a neat table format.

require 'stock_quote'
require 'colorize'
require 'terminal-table' 
require 'tty-prompt'

require_relative 'sp500_hash_table.rb' 
require_relative 'iex_API_Key.rb'
require_relative 'stock_getter_methods.rb'
require_relative 'stock_print_methods.rb'
require_relative 'watchlist_methods.rb'

# API_KEY is hidden - sign up to iexcloud.io with account to get one
# Initialising the Stock class from 'stock_quote' - allows us to use the IEX API
StockQuote::Stock.new(api_key: API_KEY)

# Initialise 'TTY-Prompt'
prompt = TTY::Prompt.new

# Initialising the flow control loop for user interaction to true
make_stock_price_check = true
stop_program_running = false
user_options = ["Get stock overview", "Get stock price information", 
                "Get stock price information in percentages", "Show list of available stock tickers", 
                "Build watchlist", "Show watchlist", "Get watchlist stock overview",
                "Get watchlist price information", "Get watchlist price information in percentages", "Exit Program"]

puts "Welcome to the S&P 500 Stock Tracker"

while make_stock_price_check == true
    user_choice = prompt.select("Please choose which function you'd like to use:", user_options)

    if user_choice == "Get stock overview"
        puts "Enter a stock ticker from the S&P500:"
        stock_ticker = gets.chomp.upcase

        # Error handling
        if SP500_HASH_TABLE.has_key?(stock_ticker) == true
            stock = get_stock(stock_ticker)
            print_single_stock_info(stock)
        else
            puts "Invalid stock ticker, please try again."
            puts "Use - \'Show list of available stock tickers\' to see list of all possible ticker inputs"
        end
    elsif user_choice == "Get stock price information"
        puts "Enter a stock ticker from the S&P500:"
        stock_ticker = gets.chomp.upcase

        # Error handling
        if SP500_HASH_TABLE.has_key?(stock_ticker) == true
            stock = get_stock(stock_ticker)
            print_single_stock_price(stock)
        else
            puts "Invalid stock ticker, please try again."
            puts "Use - \'Show list of available stock tickers\' to see list of all possible ticker inputs"
        end

    elsif user_choice == "Get stock price information in percentages"
        puts "Enter a stock ticker from the S&P500:"
        stock_ticker = gets.chomp.upcase

         # Error handling
         if SP500_HASH_TABLE.has_key?(stock_ticker) == true
            stock = get_stock(stock_ticker)
            print_single_stock_price_pct(stock)
        else
            puts "#{stock_ticker}  is invalid input, please try again."
            puts "Use - \'Show list of available stock tickers\' to see list of all possible ticker inputs"
        end

    elsif user_choice == "Show list of available stock tickers"
        puts "This is a list of all of the available tickers to check onthe S&P 500:"
        print_list_of_stock_tickers()
    
    elsif user_choice == "Build watchlist"
        set_watchlist()
    elsif user_choice == "Show watchlist"
        show_watchlist()
    elsif user_choice == "Get watchlist stock overview"
        watchlist = get_watchlist()
        stocks = get_watchlist_stocks(watchlist)
        print_watchlist_info(stocks)
    elsif user_choice == "Get watchlist price information"
        watchlist = get_watchlist()
        stocks = get_watchlist_stocks(watchlist)
        print_watchlist_stock_prices(stocks)
    elsif user_choice == "Get watchlist price information in percentages"
        watchlist = get_watchlist()
        stocks = get_watchlist_stocks(watchlist)
        print_watchlist_stock_prices_pct(stocks)
    elsif user_choice == "Exit Program"
        stop_program_running = true
    end

    # Exiting program conditions, exits straight away if user selected Exit Program previously.
    # Otherwise it asks the user if they'd like to continue using it
    if stop_program_running == true
        make_stock_price_check = false
    else
        keep_using = prompt.yes?('Keep using S&P 500 Stock Tracker?')
        if keep_using == false
            make_stock_price_check = false
        end
    end

end