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
    delegate :rate_date, to: :fetcher

    protected

    def recombine_by_base(rates)
      if @base != 'SEK'
        rates.each do |currency, value|
          rates[currency] = rates[@base] / value
        end
      end

      rates[@base] = 1

      rates
    end
  end
end
