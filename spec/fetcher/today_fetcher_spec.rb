RSpec.describe RiksbankCurrency::TodayFetcher do
  before(:context) do
    @fetcher = RiksbankCurrency::TodayFetcher.new
    @fetcher.to_hash
  end

  it 'should respond to Fetcher interface methods' do
    expect(@fetcher.respond_to?(:rate_date)).to be_truthy
    expect(@fetcher.respond_to?(:to_hash)).to be_truthy
    expect(@fetcher.respond_to?(:response)).to be_truthy
  end

  describe '.rate_date' do
    it 'returns Date' do
      expect(@fetcher.rate_date).to be_an_instance_of(Date)
    end
  end

  describe '.response' do
    it 'returns Nokogiri doc' do
      expect(@fetcher.response).to be_an_instance_of(Nokogiri::XML::Document)
    end
  end

  describe '.to_hash' do
    let(:hash){ @fetcher.to_hash }

    it 'returns Hash with allowed currencies' do
      expect(RiksbankCurrency.currencies).to include(*hash.keys)
    end
  end
end
