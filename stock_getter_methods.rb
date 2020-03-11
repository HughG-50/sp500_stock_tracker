# Getter methods for stock_price_check

def get_company_name(stock_ticker)
    return SP500_HASH_TABLE[stock_ticker][0]
end

def get_stock_sector(stock_ticker)
    return SP500_HASH_TABLE[stock_ticker][1]
end

# Gets new stock object from 'stock_quote' 
def get_stock(stock_ticker)
    stock = StockQuote::Stock.quote(stock_ticker)
    return stock
end

def get_stock_symbol(stock)
    return stock.symbol.upcase
end

def get_stock_price(stock)
    return stock.latest_price
end

def get_price_change_y_day(stock)
    return stock.change
end

def get_pct_change_y_day(stock)
    return stock.change_percent
end

# Returns a percentage
def get_pct_change_ytd(stock)
    return stock.ytd_change
end

def get_pe_ratio(stock)
    return stock.pe_ratio
end

def get_52w_high(stock)
    return stock.week52_high
end

def get_52w_low(stock)
    return stock.week52_low
end

# Helper functions to calculate price and percentage changes for additional data points
# Converts %ytd_change into price figure
def get_price_change_ytd(stock)
    stock_price = get_stock_price(stock)
    ytd_pct_change = get_pct_change_ytd(stock)
    # Calculate the price at the start of the year
    year_start_price = stock_price - (ytd_pct_change*stock_price)
    # get the price change from the start of year to date
    ytd_price_change = stock_price - year_start_price
    return ytd_price_change.round(2)
end

# Get price change from 52 week high to current price
def get_price_change_52w_h(stock)
    stock_price = get_stock_price(stock)
    week_52_high = get_52w_high(stock)
    return (stock_price - week_52_high).round(4)
end

# Get price change from 52 week low to current price
def get_price_change_52w_l(stock)
    stock_price = get_stock_price(stock)
    week_52_low = get_52w_low(stock)
    return (stock_price - week_52_low).round(4)
end

# Get percentage price change from 52 week high to current price
def get_pct_change_52w_h(stock)
    price_change_from_52w_h = get_price_change_52w_h(stock)
    week_52_high = get_52w_high(stock)
    return (price_change_from_52w_h/week_52_high).round(5)
end

# Get percentage price change from 52 week low to current price
def get_pct_change_52w_l(stock)
    price_change_from_52w_l = get_price_change_52w_l(stock)
    week_52_low = get_52w_low(stock)
    return (price_change_from_52w_l/week_52_low).round(5)
end