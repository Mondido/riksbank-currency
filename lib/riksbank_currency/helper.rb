module RiksbankCurrency
  module Helper
    module_function

    # Extract currency ISO name from Riksbank series name
    # Example: SEKEURPMI => EUR
    #
    # @see http://www.riksbank.se/en/Interest-and-exchange-rates/Series-for-web-services/
    #
    # @param [String] Riksbank SeriesId
    def currency_from_seriesid(seriesid)
      seriesid.match(/SEK(\w+)PMI/).try(:[], 1)
    end

    # Generate series name for specific currency
    # @param [String] currency ISO name
    def currency_to_seriesid(currency)
      "SEK#{currency.upcase}PMI"
    end

    # Converts date to the bank format
    # @param [Date] date
    def format_date(date)
      date.strftime("%Y-%m-%d")
    end

    # Parse date from bank format
    # @param [String] date string in format "YYYY-MM-DD"
    # @return [Date]
    def parse_date(string_date)
      Date.new(*string_date.split('-').map(&:to_i))
    end
  end
end
