require 'terminal-table'
require_relative 'sp500_hash_table.rb'

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
    if get_price_change_y_day(stock) > 0 && get_pct_change_ytd(stock) > 0
        rows.push([get_stock_symbol(stock), "$".colorize(:green) + get_stock_price(stock).to_s.colorize(:green),
                (get_pct_change_y_day(stock)*100).round(2).to_s.colorize(:green) + "%".colorize(:green),
                (get_pct_change_ytd(stock)*100).round(2).to_s.colorize(:green) + "%".colorize(:green),
                (get_pct_change_52w_h(stock)*100).round(2).to_s.colorize(:red)+ "%".colorize(:red), 
                (get_pct_change_52w_l(stock)*100).round(2).to_s.colorize(:green) + "%".colorize(:green)])
    elsif get_price_change_y_day(stock) > 0 && get_pct_change_ytd(stock) < 0
        rows.push([get_stock_symbol(stock), "$".colorize(:green) + get_stock_price(stock).to_s.colorize(:green),
                (get_pct_change_y_day(stock)*100).round(2).to_s.colorize(:green) + "%".colorize(:green), 
                (get_pct_change_ytd(stock)*100).round(2).to_s.colorize(:red) + "%".colorize(:red),
                (get_pct_change_52w_h(stock)*100).round(2).to_s.colorize(:red)+ "%".colorize(:red), 
                (get_pct_change_52w_l(stock)*100).round(2).to_s.colorize(:green) + "%".colorize(:green)])
    # Check if price is down from yesterday, if so colour the price and % change red
    elsif get_price_change_y_day(stock) < 0 && get_pct_change_ytd(stock) > 0
        rows.push([get_stock_symbol(stock), "$".colorize(:red) + get_stock_price(stock).to_s.colorize(:red), 
                (get_pct_change_y_day(stock)*100).round(2).to_s.colorize(:red) + "%".colorize(:red),
                (get_pct_change_ytd(stock)*100).round(2).to_s.colorize(:green) + "%".colorize(:green),
                (get_pct_change_52w_h(stock)*100).round(2).to_s.colorize(:red) + "%".colorize(:red), 
                (get_pct_change_52w_l(stock)*100).round(2).to_s.colorize(:green) + "%".colorize(:green)])               
    elsif get_price_change_y_day(stock) < 0 && get_pct_change_ytd(stock) < 0
        rows.push([get_stock_symbol(stock), "$".colorize(:red) + get_stock_price(stock).to_s.colorize(:red), 
                (get_pct_change_y_day(stock)*100).round(2).to_s.colorize(:red) + "%".colorize(:red),
                (get_pct_change_ytd(stock)*100).round(2).to_s.colorize(:red) + "%".colorize(:red),
                (get_pct_change_52w_h(stock)*100).round(2).to_s.colorize(:red) + "%".colorize(:red), 
                (get_pct_change_52w_l(stock)*100).round(2).to_s.colorize(:green) + "%".colorize(:green)])
    else
        rows.push([get_stock_symbol(stock), "$" + get_stock_price(stock).to_s, "0%", 
                (get_pct_change_ytd(stock)*100).round(2).to_s + "%",
                (get_pct_change_52w_h(stock)*100).round(2).to_s.colorize(:red)+ "%".colorize(:red), 
                (get_pct_change_52w_l(stock)*100).round(2).to_s.colorize(:green)+ "%".colorize(:red)])
    end

    table = Terminal::Table.new :rows => rows
    table = Terminal::Table.new :headings => ['Stock', 'Price','% Change Prev Day','% Change YTD','% From 52 Week High','% From 52 Week Low'], :rows => rows
    puts table
end

# Displays extended information compared to print_single_stock_price
# Price, price change from yesterday, price change ytd, price change from 52w_high, price change from 52w_low 
def print_single_stock_price(stock)
    rows = []
    if get_price_change_y_day(stock) > 0 && get_price_change_ytd(stock) > 0
        rows.push([get_stock_symbol(stock), "$".colorize(:green) + get_stock_price(stock).to_s.colorize(:green),
            "$".colorize(:green) + get_price_change_y_day(stock).to_s.colorize(:green),
            "$".colorize(:green) + get_price_change_ytd(stock).to_s.colorize(:green),
            "$".colorize(:red) + get_price_change_52w_h(stock).to_s.colorize(:red), 
            "$".colorize(:green) + get_price_change_52w_l(stock).to_s.colorize(:green)])
    elsif get_price_change_y_day(stock) > 0 && get_price_change_ytd(stock) < 0
        rows.push([get_stock_symbol(stock), "$".colorize(:green) + get_stock_price(stock).to_s.colorize(:green),
            "$".colorize(:green) + get_price_change_y_day(stock).to_s.colorize(:green), 
            "$".colorize(:red) + get_price_change_ytd(stock).to_s.colorize(:red),
            "$".colorize(:red) + get_price_change_52w_h(stock).to_s.colorize(:red), 
            "$".colorize(:green) + get_price_change_52w_l(stock).to_s.colorize(:green)])
    elsif get_price_change_y_day(stock) < 0 && get_price_change_ytd(stock) > 0
        rows.push([get_stock_symbol(stock), "$".colorize(:red) + get_stock_price(stock).to_s.colorize(:red),
            "$".colorize(:red) + get_price_change_y_day(stock).to_s.colorize(:red), 
            "$".colorize(:green) + get_price_change_ytd(stock).to_s.colorize(:green),
            "$".colorize(:red) + get_price_change_52w_h(stock).to_s.colorize(:red), 
            "$".colorize(:green) + get_price_change_52w_l(stock).to_s.colorize(:green)])
    elsif get_price_change_y_day(stock) < 0 && get_price_change_ytd(stock) < 0
        rows.push([get_stock_symbol(stock), "$".colorize(:red) + get_stock_price(stock).to_s.colorize(:red),
            "$".colorize(:red) + get_price_change_y_day(stock).to_s.colorize(:red), 
            "$".colorize(:red) + get_price_change_ytd(stock).to_s.colorize(:red),
            "$".colorize(:red) + get_price_change_52w_h(stock).to_s.colorize(:red), 
            "$".colorize(:green) + get_price_change_52w_l(stock).to_s.colorize(:green)])
    end

    table = Terminal::Table.new :rows => rows
    table = Terminal::Table.new :headings => ['Stock', 'Price','Price Change from Prev Day','Price Change YTD','Change from 52 Week High','Change From 52 Week Low'], :rows => rows
    puts table
end

# User story: Martin wanted to be able to see a list of all S&P500 tickers
def print_list_of_stock_tickers
    list_of_keys = SP500_HASH_TABLE.keys()
    
    for i in 0..list_of_keys.length-1
        puts list_of_keys[i]
    end
end