require 'date'

module RiksbankCurrency
  class Rates
    def initialize(**options)
      @date = options[:date] || Date.current
      @base = options[:base] || 'SEK'

      # it is possible to pass cached rates to initializer to avoid extra http calls
      @rates = options[:rates]
    end

    def rate(from, to = @base)
      rates[from] / rates[to]
    end

    # @return [Hash]
    def rates
      @rates ||= Fetcher.get(@date, @base)
    end

    # @return [Array]
    def currencies
      rates.keys
    end
  end
end
