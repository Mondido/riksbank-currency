[![Build Status](https://travis-ci.org/Mondido/riksbank-currency.svg?branch=master)](https://travis-ci.org/Mondido/riksbank-currency)
# Riksbank Exchange Rates

Simple wrapper for Riksbank API that returns currency exchange rates for specific date.


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

  * `date` - specific date we want to get exchange rates for. It should be a valid `Date` object 
  * `base` - base currency (`SEK` is used by default)
  * `rates` - you can pass your own hash with rates. Can be useful for caching purposes


### Retrieve a specific rate

```ruby
  # How many euros in one american dollar?
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

### Rates from holidays / weekends

Exchange rates are not changed during holidays or weekends. 
If you query bank API directly, you will get an empty hash in response.

To avoid that, this gem provides last known rates:

```ruby
  # 20.01.2018 is Saturday, bank is closed
  holiday_bank = RiksbankCurrency::Rates.new(date: Date.new(2018, 1, 20))
  
  # Last known rates will be fetched instead (from Friday).
  holiday_bank.rate_date # Fri, 19 Jan 2018
````

### Riksbank updates rates twice a day (in the morning and in the evening)

If you try to fetch rates at 03.00 in the morning, then you will get an empty hash from the bank.
Therefore gem will return rates from a previous date.

```ruby
  # Time.current => Fri, 26 Jan 2018 03:00:00 UTC +00:00 
  morning_bank = RiksbankCurrency::Rates.new
  
  # It's too early, bank doensn't work at this time
  # Yesterday's rates will be used instead 
  morning_bank.rate_date # Thu, 25 Jan 2018
```

#### Default currencies

```ruby
%w(AUD BRL CAD CHF CNY CZK DKK EUR GBP HKD HUF IDR INR ISK JPY
   KRW MAD MXN NOK NZD PLN RUB SAR SGD THB TRY USD ZAR)
```

### Additional currencies

Check bank page to get a fresh list of provided currencies [official bank page](http://www.riksbank.se/en/Interest-and-exchange-rates/Series-for-web-services/).

By default this gem is only using existing currencies from 2018.
For example, FIM (Finland Marka) has published rates until 2002. 

So, if you wanna get information about FIM exchange rate in 2001 you should 
change the gem defaults:

```ruby
  RiksbankCurrency.currencies << 'FIM'
  
  old_bank = RiksbankCurrency::Rates.new(date: Date.new(2001, 1, 16))
  old_bank.rate('FIM').to_f # 1.495527
  
  today_bank = RiksbankCurrency::Rates.new
  today_bank.rate('FIM') # nil
```

## Legal

The author of this gem is not affiliated with the Riksbank.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
