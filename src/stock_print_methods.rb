require 'terminal-table'
require_relative 'sp500_hash_table.rb'

# Displays stock ticker, company name, sector, 
def print_single_stock_info(stock)
    table_rows = []
    stock_ticker = get_stock_symbol(stock)
    make_table_rows_stock_info(table_rows, stock)
    make_table(get_company_name(stock_ticker), ['Ticker','Company','Sector', 'Price', 'PE Ratio'], table_rows)
end

# Displays stock price + price changes from key points in % terms 
# Price, % change from yesterday, % change from 52w_high, % change from 52w_low 
def print_single_stock_price_pct(stock)
    table_rows = []  
    stock_ticker = get_stock_symbol(stock)
    set_rows_price_pct(table_rows, stock)
    make_table(get_company_name(stock_ticker), ['Stock', 'Price','% Change Prev Day','% Change YTD','% From 52 Week High','% From 52 Week Low'], table_rows)

end

# Displays extended information compared to print_single_stock_price
# Price, price change from yesterday, price change ytd, price change from 52w_high, price change from 52w_low 
def print_single_stock_price(stock)
    table_rows = []
    stock_ticker = get_stock_symbol(stock)
    set_rows_price(table_rows, stock)
    make_table(get_company_name(stock_ticker), ['Stock', 'Price','Price Change from Prev Day','Price Change YTD','Change from 52 Week High','Change From 52 Week Low'], table_rows)
end

# User story: Martin wanted to be able to see a list of all S&P500 tickers
def print_list_of_stock_tickers()
    list_of_keys = SP500_HASH_TABLE.keys()
    
    for i in 0..list_of_keys.length-1
        puts list_of_keys[i]
    end
end

# Function for populating stock overview information for stocks + watchlist overview
def make_table_rows_stock_info(table_rows, stock)
    stock_ticker = get_stock_symbol(stock)
    table_rows.push([stock_ticker, get_company_name(stock_ticker), get_stock_sector(stock_ticker), "$" + get_stock_price(stock).to_s,
                    get_pe_ratio(stock)])
end

def make_table_rows_portfolio_info(table_rows, stock, number_of_stock_owned)
    stock_ticker = get_stock_symbol(stock)
    price = get_stock_price(stock)
    value = number_of_stock_owned*price
    table_rows.push([stock_ticker, get_company_name(stock_ticker), get_stock_sector(stock_ticker), "$" + price.to_s,
                    get_pe_ratio(stock), number_of_stock_owned, "$" + value.to_s])
end

# pct_y_day_color and pct_ytd_color should be set to :green or :red
def make_table_rows_stock_prices_pct(table_rows, stock, pct_y_day_color, pct_ytd_color)
    stock_ticker = get_stock_symbol(stock)
    table_rows.push([stock_ticker, "$".colorize(pct_y_day_color) + get_stock_price(stock).to_s.colorize(pct_y_day_color),
            (get_pct_change_y_day(stock)*100).round(2).to_s.colorize(pct_y_day_color) + "%".colorize(pct_y_day_color),
            (get_pct_change_ytd(stock)*100).round(2).to_s.colorize(pct_ytd_color) + "%".colorize(pct_ytd_color),
            (get_pct_change_52w_h(stock)*100).round(2).to_s.colorize(:red)+ "%".colorize(:red), 
            (get_pct_change_52w_l(stock)*100).round(2).to_s.colorize(:green) + "%".colorize(:green)])
end

def make_table_rows_stock_prices(table_rows, stock, price_y_day_color, price_ytd_color)
    stock_ticker = get_stock_symbol(stock)
    table_rows.push([stock_ticker, "$".colorize(price_y_day_color) + get_stock_price(stock).to_s.colorize(price_y_day_color),
                "$".colorize(price_y_day_color) + get_price_change_y_day(stock).to_s.colorize(price_y_day_color), 
                "$".colorize(price_ytd_color) + get_price_change_ytd(stock).to_s.colorize(price_ytd_color),
                "$".colorize(:red) + get_price_change_52w_h(stock).to_s.colorize(:red), 
                "$".colorize(:green) + get_price_change_52w_l(stock).to_s.colorize(:green)])
end

def make_table(title, headings, rows)
    table = Terminal::Table.new :rows => rows
    table = Terminal::Table.new :title => title, :headings => headings, :rows => rows
    puts table
end

def set_rows_price(table_rows, stock)
    if get_price_change_y_day(stock) > 0 && get_price_change_ytd(stock) > 0
        price_y_day_color = :green
        price_ytd_color = :green
    elsif get_price_change_y_day(stock) > 0 && get_price_change_ytd(stock) < 0
        price_y_day_color = :green
        price_ytd_color = :red
    elsif get_price_change_y_day(stock) < 0 && get_price_change_ytd(stock) > 0
        price_y_day_color = :red
        price_ytd_color = :green
    elsif get_price_change_y_day(stock) < 0 && get_price_change_ytd(stock) < 0
        price_y_day_color = :red
        price_ytd_color = :red
    end
    make_table_rows_stock_prices(table_rows, stock, price_y_day_color, price_ytd_color)
end

def set_rows_price_pct(table_rows, stock)
    if get_price_change_y_day(stock) > 0 && get_pct_change_ytd(stock) > 0
        pct_y_day_color = :green
        pct_ytd_color = :green
    elsif get_price_change_y_day(stock) > 0 && get_pct_change_ytd(stock) < 0
        pct_y_day_color = :green
        pct_ytd_color = :red
    # Check if price is down from yesterday, if so colour the price and % change red
    elsif get_price_change_y_day(stock) < 0 && get_pct_change_ytd(stock) > 0
        pct_y_day_color = :red
        pct_ytd_color = :green
    elsif get_price_change_y_day(stock) < 0 && get_pct_change_ytd(stock) < 0
        pct_y_day_color = :red
        pct_ytd_color = :red
    end
    make_table_rows_stock_prices_pct(table_rows, stock, pct_y_day_color, pct_ytd_color)
end
