require 'nokogiri'
require 'uri'
require 'net/http'
require 'date'

module RiksbankCurrency
  class Fetcher
    # @param [Date] date
    # @param [String] base currency
    def self.get(date, base)
      self.new(date, base).parse
    end

    # @param [Date] date
    # @param [String] base currency
    def initialize(date, base)
      @date = date.strftime("%Y-%m-%d")
      @base = base.to_s
    end

    def parse
      rates = {}

      Nokogiri::XML(server_response).xpath("//series").each do |series|
        currency = get_currency_from_seriesid(series.at_xpath('seriesid').content)
        unit     = BigDecimal(series.at_xpath('unit').content)
        rate     = BigDecimal(series.at_xpath('resultrows/value').content)

        rates[currency] = rate / unit
      end

      if @base != 'SEK'
        rates.each do |currency, value|
          rates[currency] = rates[@base] / value
        end
      end

      rates[@base] = 1

      rates
    end

    def server_response
      uri = URI.parse("http://swea.riksbank.se/sweaWS/services/SweaWebServiceHttpSoap12Endpoint")

      request = Net::HTTP::Post.new(uri.path)
      request.body = xml_template
      request.content_type = 'text/xml'

      response = Net::HTTP.new(uri.host, uri.port).start { |http| http.request request }
      response.body
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
          <seriesid>SEK#{currency.upcase}PMI</seriesid>
        </searchGroupSeries>
      XML
    end

    def xml_template
      <<-XML
      <soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:xsd="http://swea.riksbank.se/xsd">
        <soap:Header/>
        <soap:Body>
          <xsd:getInterestAndExchangeRates>
            <searchRequestParameters>
              <aggregateMethod>D</aggregateMethod>
              <avg>false</avg>
              <datefrom>#{@date}</datefrom>
              <dateto>#{@date}</dateto>
              <languageid>en</languageid>
              <max>true</max>
              <min>false</min>
              #{ groups }
              <ultimo>false</ultimo>
            </searchRequestParameters>
          </xsd:getInterestAndExchangeRates>   
        </soap:Body>
      </soap:Envelope>
      XML
    end

    # Extract currency ISO name from Riksbank series name
    # Example: SEKEURPMI => EUR
    #
    # @see http://www.riksbank.se/en/Interest-and-exchange-rates/Series-for-web-services/
    #
    # @param [String] Riksbank SeriesId
    def get_currency_from_seriesid(seriesid)
      seriesid.match(/SEK(\w+)PMI/).try(:[], 1)
    end
  end
end
