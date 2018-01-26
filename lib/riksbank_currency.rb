require 'riksbank_currency/helper'
require 'riksbank_currency/business_day'
require 'riksbank_currency/fetcher'
require 'riksbank_currency/fetcher/date_fetcher'
require 'riksbank_currency/fetcher/today_fetcher'
require 'riksbank_currency/rates'
require 'riksbank_currency/request'
require 'riksbank_currency/version'

module RiksbankCurrency
  # list of available currencies in 2018
  mattr_accessor :currencies
  @@currencies = %w(AUD BRL CAD CHF CNY CZK DKK EUR GBP HKD HUF IDR INR ISK JPY
                    KRW MAD MXN NOK NZD PLN RUB SAR SGD THB TRY USD ZAR)
end
