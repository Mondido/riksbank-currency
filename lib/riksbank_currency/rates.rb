require 'date'

module RiksbankCurrency
  class Rates
    def initialize(**options)
      @date = options[:date] || Date.today
      @base = options[:base] || 'SEK'

      # it is possible to pass cached rates to initializer to avoid extra http calls
      unless options[:rates].nil?
        @rates     = options[:rates]
        @rate_date = @date
      end
    end

    # @return [RiksbankCurreny::Fetcher]
    def fetcher
      @fetcher ||= Fetcher.new(@date, @base)
    end

    def rate(from, to = @base)
      return nil if rates[from].nil? || rates[to].nil?
      rates[from] / rates[to]
    end

    # Hash with all available currencies
    # {
    #   "EUR": 9.021,
    #   "USD": 7.211
    # }
    # @return [Hash]
    def rates
      @rates ||= fetcher.to_hash
    end

    # Sometimes date passed to the initializer is different from last available exchange date.
    # It could be because of holidays, weekends or bank closing hours.
    #
    # For example, if we want to get rates for the `1st of January 2018` then rate date
    # will be `27th of December 2017`, because `1st of January` is a holiday.
    # @return [Date]
    def rate_date
      @rate_date ||= fetcher.rate_date
    end

    # @return [Array]
    def currencies
      rates.keys
    end
  end
end
