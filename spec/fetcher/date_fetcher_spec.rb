RSpec.describe RiksbankCurrency::DateFetcher do
  subject { RiksbankCurrency::DateFetcher.new(Date.new(2018, 1, 20)) }

  it 'should respond to Fetcher interface methods' do
    expect(subject.respond_to?(:rate_date)).to be_truthy
    expect(subject.respond_to?(:to_hash)).to be_truthy
    expect(subject.respond_to?(:response)).to be_truthy
  end

  describe '.rate_date' do
    it 'calls BusinessDay helper and returns Date' do
      # already tested, mock it
      allow(RiksbankCurrency::BusinessDay)
        .to receive(:get_latest).and_return(Date.new(2018, 1, 19))

      expect(subject.rate_date).to be_an_instance_of(Date)
      expect(subject.rate_date).to eq Date.new(2018, 1, 19)
    end
  end

  describe '.response' do
    it 'returns Nokogiri doc' do
      expect(subject.response).to be_an_instance_of(Nokogiri::XML::Document)
    end
  end

  describe '.to_hash' do
    let(:hash){ subject.to_hash }

    it 'returns Hash with allowed currencies' do
      expect(RiksbankCurrency.currencies).to include(*hash.keys)
    end

    it 'returns correct rates' do
      rates = {
        'USD' => 8.0081,
        'EUR' => 9.8282,
        'NOK' => 1.021738
      }

      rates.each do |iso, value|
        expect(hash[iso].to_f).to eq value
      end
    end
  end
end
