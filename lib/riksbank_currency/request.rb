require 'uri'
require 'net/http'
require 'nokogiri'

module RiksbankCurrency
  module Request
    module_function

    ENDPOINT = "http://swea.riksbank.se/sweaWS/services/SweaWebServiceHttpSoap12Endpoint"

    # @param [String] xml_body
    # @return [Nokogiri::XML::Document]
    def call(xml_body)
      uri = URI.parse(ENDPOINT)

      request = Net::HTTP::Post.new(uri.path)
      request.body = xml_body
      request.content_type = 'text/xml'

      response = Net::HTTP.new(uri.host, uri.port).start { |http| http.request request }
      Nokogiri::XML(response.body)
    end
  end
end
