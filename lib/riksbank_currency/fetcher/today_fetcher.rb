module RiksbankCurrency
  # Get the latest rates that will be correct for the current day.
  #
  # @see https://swea.riksbank.se/sweaWS/docs/api/call/getLatestInterestAndExchangeRates.htm
  class TodayFetcher
    def rate_date
      @rate_date ||=
        begin
          response.xpath("//resultrows/date").map do |date_node|
            Helper.parse_date(date_node.content)
          end.max
        end
    end

    def to_hash
      rates = {}

      response.xpath("//series").each do |series|
        currency = Helper.currency_from_seriesid(series.at_xpath('seriesid').content)

        if (rate = series.at_xpath('resultrows/value').content).length > 0
          unit = BigDecimal(series.at_xpath('unit').content)
          rate = BigDecimal(rate)

          rates[currency] = rate / unit
        else
          next
        end
      end

      rates
    end

    def response
      @response ||= Request.call(xml_template)
    end

    protected

    def series
      RiksbankCurrency.currencies.map do |currency|
        id = Helper.currency_to_seriesid(currency)
        "<seriesid>#{id}</seriesid>"
      end.join('')
    end

    def xml_template
      <<-XML
      <soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:xsd="http://swea.riksbank.se/xsd">
        <soap:Header/>
        <soap:Body>
          <xsd:getLatestInterestAndExchangeRates>
            <languageid>en</languageid>
            #{series}
          </xsd:getLatestInterestAndExchangeRates>   
        </soap:Body>
      </soap:Envelope>
      XML
    end
  end
end
