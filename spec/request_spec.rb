RSpec.describe RiksbankCurrency::Request do
  let(:xml) {
    <<-XML
      <soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:xsd="http://swea.riksbank.se/xsd">
      <soap:Header/>
        <soap:Body>
            <xsd:getCalendarDays>
               <datefrom>2001-10-01</datefrom>
               <dateto>2011-10-01</dateto>
            </xsd:getCalendarDays>
         </soap:Body>
      </soap:Envelope>
    XML
  }

  describe '#call' do
    it 'returns Nokogiri document' do
      expect(subject.call(xml)).to be_an_instance_of(Nokogiri::XML::Document)
    end
  end
end
