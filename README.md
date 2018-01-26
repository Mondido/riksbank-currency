# Riksbank Exchange Rates

Simple wrapper for Riksbank API that returns currency exchange rates for the specific date.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'riksbank_currency'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install riksbank_currency

## Usage

### Initialize

```ruby
  bank = RiksbankCurrency::Rates.new(date: Date.yesterday, base: 'USD')
```

Initializer options:

  * `date` - the day for which we want to get exchange rates. It should be `Date` object 
  * `base` - base currency (by default `SEK`)
  * `rates` - you can pass your own hash with rates. Can be useful for caching purposes


### Retrieve a specific rate

```ruby
  # how many euros in one american dollar?
  bank.rate('USD', 'EUR').to_f # => 0.80607
  
  # by default it converts to SEK
  bank.rate('USD').to_f # => 7.913
```

Get all available currencies:

```ruby
  bank.currencies # => ['AUD', 'BRL', 'CAD', 'CHF', 'CNY', 'CZK', 'DKK', 'EUR'...]
```

Get all rates

```ruby
  bank.rates # => { 'NOK' => 105.556298, 'INR' => 13.619511, … }
```

### Bank days and holidays

During the holidays or weekends bank doesn't change exchange rates. It means that
bank doesn't have exchange rates for Saturday or Christmas.

Also, another problem in the current day. Bank refreshes rates twice per day (morning and evening).
So, therefore at 3 o'clock of morning bank doensn't have fresh rates and we should use
rates from prevoius day.

This gem deals with all of this problems:

```ruby
  # 20.01.2018 is Saturday, bank doesn't work at this day
  holiday_bank = RiksbankCurrency::Rates.new(date: Date.new(2018, 1, 20))
  
  # rates will be got from Friday!
  holiday_bank.rate_date # Fri, 19 Jan 2018
  
  
  
  
  # imagine that we do it at night
  # Time.current => Fri, 26 Jan 2018 03:00:00 UTC +00:00 
  morning_bank = RiksbankCurrency::Rates.new
  
  # it is too early, bank doensn't work at this time
  # let's use yesterday rates 
  morning_bank.rate_date # Thu, 25 Jan 2018
```

### Available currencies

Pay attention to check available currencies at [official bank page](http://www.riksbank.se/en/Interest-and-exchange-rates/Series-for-web-services/).

By default this gem uses only existing currencies for 2018. For example, FIM (Finland Marka)
has rates only till 2002 and it doesn't exist anymore in 2018.

So, if you wanna get information about FIM exchange rate in 2001 you should 
change the gem defaults:

```ruby
  RiksbankCurrency.currencies << 'FIM'
  
  old_bank = RiksbankCurrency::Rates.new(date: Date.new(2001, 1, 16))
  old_bank.rate('FIM').to_f # 1.495527
  
  today_bank = RiksbankCurrency::Rates.new
  today_bank.rate('FIM') # nil
```

#### Default currencies

```ruby
%w(AUD BRL CAD CHF CNY CZK DKK EUR GBP HKD HUF IDR INR ISK JPY
   KRW MAD MXN NOK NZD PLN RUB SAR SGD THB TRY USD ZAR)
```

## Legal

The author of this gem is not affiliated with the Riksbank.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
