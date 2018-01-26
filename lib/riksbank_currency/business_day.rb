require 'nokogiri'

module RiksbankCurrency
  class BusinessDay
    def self.get_latest(date)
      template = <<-XML
          <soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:xsd="http://swea.riksbank.se/xsd">
          <soap:Header/>
            <soap:Body>
              <xsd:getCalendarDays>
                <datefrom>#{Helper.format_date(date.prev_month)}</datefrom>
                <dateto>#{Helper.format_date(date)}</dateto>
              </xsd:getCalendarDays>
            </soap:Body>
          </soap:Envelope>
      XML

      date = nil

      Request.call(template).xpath('//return').reverse_each do |block|
        bankday = block.at_xpath('bankday').content == 'Y'
        next unless bankday

        date = Helper.parse_date(block.at_xpath('caldate').content)
        break
      end

      date
    end
  end
end
