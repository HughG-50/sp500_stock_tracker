# Methods for reading/writing to files and printing watchlist

require 'terminal-table'
require_relative 'sp500_hash_table.rb'

# Method for reading input from terminal and saving to file
def set_watchlist()
    watch_list_arr = []

    puts "Enter all stock tickers that you wish to have in your watchlist."
    puts "Each new stock ticker should be on a new line, Enter blank when done:"
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
    stock_tickers = get_watchlist()
    rows = []

    for i in 0..stock_tickers.length-1
        rows.push([stock_tickers[i], get_company_name(stock_tickers[i]), get_stock_sector(stock_tickers[i]), "$" + get_stock_price(stocks[i]).to_s,
            get_pe_ratio(stocks[i])])
    end

    table = Terminal::Table.new :rows => rows
    table = Terminal::Table.new :title => "Watchlist", :headings => ['Ticker','Company','Sector', 'Price', 'PE Ratio'], :rows => rows
    puts table
end

# Displays 
# Displays stock price + price changes from key points in % terms 
# Price, % change from yesterday, % change from 52w_high, % change from 52w_low 
def print_watchlist_stock_prices_pct(stocks)
    rows = []
    stock_tickers = get_watchlist()
    
    for i in 0..stock_tickers.length-1
        # Check if price is up from yesterday, if so colour the price and % change green
        # Price values are converted into strings for purposes of printing in order to colorize output
        if get_price_change_y_day(stocks[i]) > 0 && get_pct_change_ytd(stocks[i]) > 0
            rows.push([get_stock_symbol(stocks[i]), "$".colorize(:green) + get_stock_price(stocks[i]).to_s.colorize(:green),
                    (get_pct_change_y_day(stocks[i])*100).round(2).to_s.colorize(:green) + "%".colorize(:green),
                    (get_pct_change_ytd(stocks[i])*100).round(2).to_s.colorize(:green) + "%".colorize(:green),
                    (get_pct_change_52w_h(stocks[i])*100).round(2).to_s.colorize(:red)+ "%".colorize(:red), 
                    (get_pct_change_52w_l(stocks[i])*100).round(2).to_s.colorize(:green) + "%".colorize(:green)])
        elsif get_price_change_y_day(stocks[i]) > 0 && get_pct_change_ytd(stocks[i]) < 0
            rows.push([get_stock_symbol(stocks[i]), "$".colorize(:green) + get_stock_price(stocks[i]).to_s.colorize(:green),
                    (get_pct_change_y_day(stocks[i])*100).round(2).to_s.colorize(:green) + "%".colorize(:green), 
                    (get_pct_change_ytd(stocks[i])*100).round(2).to_s.colorize(:red) + "%".colorize(:red),
                    (get_pct_change_52w_h(stocks[i])*100).round(2).to_s.colorize(:red)+ "%".colorize(:red), 
                    (get_pct_change_52w_l(stocks[i])*100).round(2).to_s.colorize(:green) + "%".colorize(:green)])
        # Check if price is down from yesterday, if so colour the price and % change red
        elsif get_price_change_y_day(stocks[i]) < 0 && get_pct_change_ytd(stocks[i]) > 0
            rows.push([get_stock_symbol(stocks[i]), "$".colorize(:red) + get_stock_price(stocks[i]).to_s.colorize(:red), 
                    (get_pct_change_y_day(stocks[i])*100).round(2).to_s.colorize(:red) + "%".colorize(:red),
                    (get_pct_change_ytd(stocks[i])*100).round(2).to_s.colorize(:green) + "%".colorize(:green),
                    (get_pct_change_52w_h(stocks[i])*100).round(2).to_s.colorize(:red) + "%".colorize(:red), 
                    (get_pct_change_52w_l(stocks[i])*100).round(2).to_s.colorize(:green) + "%".colorize(:green)])               
        elsif get_price_change_y_day(stocks[i]) < 0 && get_pct_change_ytd(stocks[i]) < 0
            rows.push([get_stock_symbol(stocks[i]), "$".colorize(:red) + get_stock_price(stocks[i]).to_s.colorize(:red), 
                    (get_pct_change_y_day(stocks[i])*100).round(2).to_s.colorize(:red) + "%".colorize(:red),
                    (get_pct_change_ytd(stocks[i])*100).round(2).to_s.colorize(:red) + "%".colorize(:red),
                    (get_pct_change_52w_h(stocks[i])*100).round(2).to_s.colorize(:red) + "%".colorize(:red), 
                    (get_pct_change_52w_l(stocks[i])*100).round(2).to_s.colorize(:green) + "%".colorize(:green)])
        else
            rows.push([get_stock_symbol(stocks[i]), "$" + get_stock_price(stocks[i]).to_s, "0%", 
                    (get_pct_change_ytd(stocks[i])*100).round(2).to_s + "%",
                    (get_pct_change_52w_h(stocks[i])*100).round(2).to_s.colorize(:red)+ "%".colorize(:red), 
                    (get_pct_change_52w_l(stocks[i])*100).round(2).to_s.colorize(:green)+ "%".colorize(:red)])
        end
    end

    table = Terminal::Table.new :rows => rows
    table = Terminal::Table.new :title => "Watchlist", :headings => ['Stock', 'Price','% Change Prev Day','% Change YTD','% From 52 Week High','% From 52 Week Low'], :rows => rows
    puts table
end

# Displays extended information compared to print_single_stock_price
# Price, price change from yesterday, price change ytd, price change from 52w_high, price change from 52w_low 
def print_watchlist_stock_prices(stocks)
    rows = []
    stock_tickers = get_watchlist()
    
    for i in 0..stock_tickers.length-1
        if get_price_change_y_day(stocks[i]) > 0 && get_price_change_ytd(stocks[i]) > 0
            rows.push([get_stock_symbol(stocks[i]), "$".colorize(:green) + get_stock_price(stocks[i]).to_s.colorize(:green),
                "$".colorize(:green) + get_price_change_y_day(stocks[i]).to_s.colorize(:green),
                "$".colorize(:green) + get_price_change_ytd(stocks[i]).to_s.colorize(:green),
                "$".colorize(:red) + get_price_change_52w_h(stocks[i]).to_s.colorize(:red), 
                "$".colorize(:green) + get_price_change_52w_l(stocks[i]).to_s.colorize(:green)])
        elsif get_price_change_y_day(stocks[i]) > 0 && get_price_change_ytd(stocks[i]) < 0
            rows.push([get_stock_symbol(stocks[i]), "$".colorize(:green) + get_stock_price(stocks[i]).to_s.colorize(:green),
                "$".colorize(:green) + get_price_change_y_day(stocks[i]).to_s.colorize(:green), 
                "$".colorize(:red) + get_price_change_ytd(stocks[i]).to_s.colorize(:red),
                "$".colorize(:red) + get_price_change_52w_h(stocks[i]).to_s.colorize(:red), 
                "$".colorize(:green) + get_price_change_52w_l(stocks[i]).to_s.colorize(:green)])
        elsif get_price_change_y_day(stocks[i]) < 0 && get_price_change_ytd(stocks[i]) > 0
            rows.push([get_stock_symbol(stocks[i]), "$".colorize(:red) + get_stock_price(stocks[i]).to_s.colorize(:red),
                "$".colorize(:red) + get_price_change_y_day(stocks[i]).to_s.colorize(:red), 
                "$".colorize(:green) + get_price_change_ytd(stocks[i]).to_s.colorize(:green),
                "$".colorize(:red) + get_price_change_52w_h(stocks[i]).to_s.colorize(:red), 
                "$".colorize(:green) + get_price_change_52w_l(stocks[i]).to_s.colorize(:green)])
        elsif get_price_change_y_day(stocks[i]) < 0 && get_price_change_ytd(stocks[i]) < 0
            rows.push([get_stock_symbol(stocks[i]), "$".colorize(:red) + get_stock_price(stocks[i]).to_s.colorize(:red),
                "$".colorize(:red) + get_price_change_y_day(stocks[i]).to_s.colorize(:red), 
                "$".colorize(:red) + get_price_change_ytd(stocks[i]).to_s.colorize(:red),
                "$".colorize(:red) + get_price_change_52w_h(stocks[i]).to_s.colorize(:red), 
                "$".colorize(:green) + get_price_change_52w_l(stocks[i]).to_s.colorize(:green)])
        end
    end

    table = Terminal::Table.new :rows => rows
    table = Terminal::Table.new :title => "Watchlist", :headings => ['Stock', 'Price','Price Change from Prev Day','Price Change YTD','Change from 52 Week High','Change From 52 Week Low'], :rows => rows
    puts table
end
