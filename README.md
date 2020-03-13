# S&P 500 Stock Tracker

## Purpose and Scope

The S&P500 Stock Tracker is a terminal application designed to provide an easy way for users to get up-to-date, basic price information of all the major stocks trading in the US. The core functionality is built on top of the Gem 'stock_quote' which allows US stock data to be pulled from the [IEX Cloud](https://iexcloud.io/) API.

Users will be able to specify the stock ticker they wish to check, and will be able to receive information about the stock such as: 
- company name
- sector
- latest traded price
- pe ratio
- price change since yesterday
- price change year to date
- price change since 52 week high/low

The purpose of this application is to provide an easy and convenient way for anyone who invests in US stocks to be able to check basic stock information without going through the hassle of searching online or using elaborate consumer investor software. The intended users of this application should be comfortable with the command line and understanding stock tickers.

## Features

### Prompted user commands

S&P 500 Stock Tracker makes use of popular Ruby Gem,  'tty-prompt' in order to create more user friendly prompts that guide the actions that can be selected by users, reducing the risk of errors being produced by user input.
User stock ticker input is also checked against a valid table of stock tickers, handling invalid inputs gracefully.

The application will run continuously allowing users to check multiple stocks until they decide to exit the application.

### Display stock overview

Conveniently prints the following information in table format to terminal after the user has specified the stock ticker to check:
- Stock ticker
- Company name
- Industry Sector
- Latest Price
- PE Ratio

### Display extended stock price information

Conveniently prints the following information in table format to terminal after the user has specified the stock ticker to check:
- Stock ticker
- Latest price
- Price change from yesterday
- Price change year to date (YTD)
- Price change from 52 week highs and lows

The output text is also colourised green or red depending on whether the price movement is positive or negative.

### Display extended stock price information in percentages

This feature presents in the same format as 'Display exteded stock price information' except:
- Price change from yesterday
- Price change year to date (YTD)
- Price change from 52 week highs and lows

Are all displayed in percentage terms.

### Show list of available stock tickers

Prints entire list of stock tickers that are able to be checked.

### Build watchlist

Allows user to create and save a list of tickers that a user wants to keep track of. Saves to a .txt file so it can be used and accessed at a later date.

### Show watchlist

Prints the list of tickers that the user has saved.

### Display watchlist stock price information

Outputs the extended stock price information but in a table for all of the selected tickers in the watchlist.

## User interaction and experience

The user will run the application by running launching the program in the command line.

From this the user will be welcomed and then prompted to make a selection of which feature they'd like to use or to exit. These options are able to be navigated through with the Up and Down arrow keys and selected with return/enter key.

If the feature selected requires the user to input a stock ticker, they then must type in the stock ticker in the terminal (can be upper or lowercase) and press return/enter. Otherwise if the feature requires no further input it will just print the output.

Once the function output has completed, the user will be prompted whether they wish to continue, if they select 'yes' then they will be returned to the original function selection menu otherwise if 'no', the program will exit.

If the user has entered an invalid ticker, the user will be notified of this and be given the suggestion to check the list of available tickers. They will then be prompted whether they wish to exit or not, if not they will be returned to the original prompt function seletion menu.

## Control Flow

![Logic Flow Chart](/docs/stock_tracker_flow_diagram.png)

## Implementation plan

The steps to build the application were conducted in the following order of priority to iterate effectively and ensure a working product.

1. Create hash table of S&P 500 company names and sector mapped to their stock ticker as the keys.

    Checklist:
   - Find data source
   - Format hash table
   - Create getter methods for retrieving values from hash table fields
  
2. Integrate 'stock_quote' gem and create getter methods for Stock object

    Checklist:
    - Create getter methods for price change information - e.g. latest price, price change YTD, PE Ratio etc
    - Validate hash table of tickers are valid inputs to API - see *'sp500_hash_table_test'*
    - Create helper methods for converting percentage change values from API into absolute price terms

3. Create print methods for outputting the data into useful formats
   
   Checklist:
   - Setup terminal-table output to present outputs in more readable format
   - Create print method for stock overview feature
   - Create print method for extended stock price information
   - Create print method for extended stock price information in percentages
   - Create print method for the list of stock tickers
   - Add logic such that the output prices are colorized green or red appropriately based on their movement

4. Create user interaction control flow and error handling

    Checklist:
    - Setup while control loop to control exiting or continuation of using the application
    - Add prompts for the user to select which function they want to use - and appropriate control flow based on their decision
    - add error handling when invalid inputs are made - checks against hash table

5. Continue to add features once MVP is completed

    Checklist:
    - Watchlists - build watchlist, show watchlist, display watchlist information
    - Portfolio tracking - build portfolio, show portfolio, display portfolio information

![Trello board ticket management](/docs/trello_project_planning.png)

## Help and Installation

This application runs in the terminal of MacOS and Linux based systems only.

Users of S&P 500 Stock Tracker must have a public API Token from [IEX Cloud](https://iexcloud.io/) in order to use the application. You must sign up to IEX Cloud in order to get a token, however the free tier of 50,000 messages per month should be ample for most people.

The Ruby Gems - [stock_quote](https://github.com/tyrauber/stock_quote), [colorize](https://github.com/fazibear/colorize), [terminal-table](https://github.com/tj/terminal-table) and [tty-prompt](https://github.com/piotrmurach/tty-prompt) must also be installed.

Install with the following commands:

```
gem install stock_quote
```
```
gem install colorize
```
```
gem install terminal-table
```
```
gem install tty-prompt
```

Fork and clone the [sp500_stock_tracker](https://github.com/HughG-50/sp500_stock_tracker) repository from Github to your local machine.

To use the 'stock_quote' gem it must be initialised with your API token such that the prices and other information can be pulled from the IEX Cloud service. 

```ruby
StockQuote::Stock.new(api_key: API_KEY)
```
At the top of the stock_price_check.rb file, this line must be modified such that API_KEY is the string that you were given by IEX Cloud.

Then run the program from the terminal with the command:

```
ruby stock_price_check.rb
```