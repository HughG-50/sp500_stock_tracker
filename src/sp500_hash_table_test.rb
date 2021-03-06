# Unit tests for verifying that that all of the keys in the SP500_HASH_TABLE
# are valid stock ticker inputs for the 'stock_quote' gem that pulls data from
# the iexcloud.io api

# Creates many API calls - SO SHOULD NOT BE RUN THAT OFTEN
# This should be run every now and then to check the S&P500 list, 
# as the index gets updated often and stocks that are no longer in the 
# index will throw an error using the 'stock_quote' gem

require 'stock_quote'
require "test/unit/assertions"
include Test::Unit::Assertions

require_relative 'sp500_hash_table.rb'
require_relative 'iex_API_Key.rb'
require_relative 'stock_getter_methods.rb'

StockQuote::Stock.new(api_key: API_KEY)

list_of_keys = SP500_HASH_TABLE.keys()
    
for i in 0..list_of_keys.length-1
    puts "Current stock ticker is: #{list_of_keys[i]}"
    # API will throw an error message if incorrec
    stock = get_stock(list_of_keys[i])
    assert_equal((list_of_keys[i]), get_stock_symbol(stock), "Stock ticker in hash table: 
                #{list_of_keys[i]} does not match stock_quote value: #{get_stock_symbol(stock)}")
end