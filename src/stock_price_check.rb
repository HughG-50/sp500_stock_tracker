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
require_relative 'portfolio_methods.rb'

# API_KEY is hidden - sign up to iexcloud.io with account to get one
# Initialising the Stock class from 'stock_quote' - allows us to use the IEX API
StockQuote::Stock.new(api_key: API_KEY)

# Initialise 'TTY-Prompt'
prompt = TTY::Prompt.new

# Initialising the flow control loop for user interaction to true
make_stock_price_check = true
stop_program_running = false
user_options = ["Individual stock information",  "Show list of available stock tickers", "Watchlist functions",
                "Portfolio functions", "Exit Program"]

puts "Welcome to the S&P 500 Stock Tracker"

while make_stock_price_check == true
    user_choice = prompt.select("Please choose which function you'd like to use:", user_options)

    if user_choice == "Individual stock information"
        
        user_options_indv_stock = ["Get stock overview", "Get stock price information", "Get stock price information in percentages", "Exit"]
        user_choice_indv_stock = prompt.select("Select option: ", user_options_indv_stock)
        
        if user_choice_indv_stock == "Get stock overview"
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
        
        elsif user_choice_indv_stock == "Get stock price information"
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

        elsif user_choice_indv_stock == "Get stock price information in percentages"
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

        elsif user_choice_indv_stock == "Exit"
            # Do nothing
        end

    elsif user_choice == "Show list of available stock tickers"
        puts "This is a list of all of the available tickers to check onthe S&P 500:"
        print_list_of_stock_tickers()

    elsif user_choice == "Watchlist functions"
    
        user_options_watchlist = ["Build watchlist", "Show watchlist", "Get watchlist stock overview", 
                                "Get watchlist price information", "Get watchlist price information in percentages", "Exit"]
        user_choice_watchlist = prompt.select("Select option: ", user_options_watchlist)

        if user_choice_watchlist == "Build watchlist"
            set_watchlist()
        elsif user_choice_watchlist == "Show watchlist"
            show_watchlist()
        elsif user_choice_watchlist == "Get watchlist stock overview"
            watchlist = get_watchlist()
            stocks = get_watchlist_stocks(watchlist)
            print_watchlist_info(stocks)
        elsif user_choice_watchlist == "Get watchlist price information"
            watchlist = get_watchlist()
            stocks = get_watchlist_stocks(watchlist)
            print_watchlist_stock_prices(stocks)
        elsif user_choice_watchlist == "Get watchlist price information in percentages"
            watchlist = get_watchlist()
            stocks = get_watchlist_stocks(watchlist)
            print_watchlist_stock_prices_pct(stocks)

        elsif user_choice_watchlist == "Exit"
            # Do nothing
        end

    elsif user_choice == "Portfolio functions"

        user_options_portfolio = ["Build portfolio", "Show portfolio", "Get portfolio stock overview", 
            "Get portfolio price information", "Get portfolio price information in percentages", "Exit"]
        user_choice_portfolio = prompt.select("Select option: ", user_options_portfolio)        
    
        if user_choice_portfolio == "Build portfolio"
            set_portfolio()
        elsif user_choice_portfolio == "Show portfolio"
            show_portfolio()
        elsif user_choice_portfolio == "Get portfolio stock overview"
            portfolio = get_portfolio_stock_list()
            stocks = get_portfolio_stocks(portfolio)
            print_portfolio_info(stocks)
        elsif user_choice_portfolio == "Get portfolio price information"
            portfolio = get_portfolio_stock_list()
            stocks = get_portfolio_stocks(portfolio)
            print_portfolio_stock_prices(stocks)
        elsif user_choice_portfolio == "Get portfolio price information in percentages"
            portfolio = get_portfolio_stock_list()
            stocks = get_portfolio_stocks(portfolio)
            print_portfolio_stock_prices_pct(stocks)
        
        elsif user_choice_portfolio == "Exit"
            # Do nothing
        end

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