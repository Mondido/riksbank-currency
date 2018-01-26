module RiksbankCurrency
  # Get historical rates by date.
  #
  # @see https://swea.riksbank.se/sweaWS/docs/api/call/getInterestAndExchangeRates.htm
  #
  # IMPORTANT! The date should be less than current date. To get rates for today
  # see at TodayFetcher
  class DateFetcher
    def initialize(date)
      @date = date
    end

    def rate_date
      @rate_date ||= BusinessDay.get_latest(@date)
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

    def groups
      RiksbankCurrency.currencies.map do |currency|
        group(currency)
      end.join('')
    end

    def group(currency)
      <<-XML
        <searchGroupSeries>
          <groupid>130</groupid>
          <seriesid>#{Helper.currency_to_seriesid(currency)}</seriesid>
        </searchGroupSeries>
      XML
    end

    def xml_template
      formatted_date = Helper.format_date(rate_date)
      <<-XML
      <soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:xsd="http://swea.riksbank.se/xsd">
        <soap:Header/>
        <soap:Body>
          <xsd:getInterestAndExchangeRates>
            <searchRequestParameters>
              <aggregateMethod>D</aggregateMethod>
              <avg>false</avg>
              <datefrom>#{formatted_date}</datefrom>
              <dateto>#{formatted_date}</dateto>
              <languageid>en</languageid>
              <max>true</max>
              <min>false</min>
              #{groups}
              <ultimo>false</ultimo>
            </searchRequestParameters>
          </xsd:getInterestAndExchangeRates>   
        </soap:Body>
      </soap:Envelope>
      XML
    end
  end
end
