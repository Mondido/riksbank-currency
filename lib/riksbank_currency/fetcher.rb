require 'nokogiri'
require 'date'

module RiksbankCurrency
  class Fetcher
    # @param [Date] date
    # @param [String] base currency
    def initialize(date, base)
      @date = date
      @base = base.to_s
    end

    # Convert XML response to Hash and recalculate it by @base currency
    # Example:
    #   {
    #     "EUR": 9.021,
    #     "USD": 7.65
    #   }
    # @return [Hash]
    def to_hash
      rates = fetcher.to_hash
      rates['SEK'] = 1.0
      recombine_by_base(rates)
    end

    # Define correct rate fetcher
    # @return [TodayFetcher,DateFetcher]
    def fetcher
      @fetcher ||=
        if @date == Date.today
          TodayFetcher.new
        else
          DateFetcher.new(@date)
        end
    end

    # @return [Date]
    def rate_date
      fetcher.rate_date
    end

    protected

    def recombine_by_base(rates)
      if @base != 'SEK'
        new_rates = {}

        rates.each do |currency, value|
          new_rates[currency] = rates[@base] / value
        end

        rates = new_rates
      end

      rates[@base] = 1.0

      rates
    end
  end
end
