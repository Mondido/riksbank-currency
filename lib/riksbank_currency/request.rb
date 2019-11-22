require 'uri'
require 'net/http'
require 'nokogiri'

module RiksbankCurrency
  module Request
    module_function

    ENDPOINT = "https://swea.riksbank.se/sweaWS/services/SweaWebServiceHttpSoap12Endpoint"

    # @param [String] xml_body
    # @return [Nokogiri::XML::Document]
    def call(xml_body, action)
      raise 'action is required' unless action

      uri = URI.parse(ENDPOINT)

      request = Net::HTTP::Post.new(uri.path)

      request.body = xml_body
      request.content_type = "application/soap+xml;charset=UTF-8;action=\"urn:#{action}\""

      response = Net::HTTP.start(uri.host, uri.port, { use_ssl: true }) do |http|
        http.request request
      end
      Nokogiri::XML(response.body)
    end
  end
end
