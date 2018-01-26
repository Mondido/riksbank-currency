RSpec.describe RiksbankCurrency::Fetcher do
  let(:today_fetcher) { RiksbankCurrency::Fetcher.new(Date.today, 'SEK') }
  let(:past_fetcher) { RiksbankCurrency::Fetcher.new(Date.today.prev_month, 'USD') }

  describe '.fetcher' do
    it 'returns TodayFetcher instance for current day' do
      expect(today_fetcher.fetcher).to be_an_instance_of(RiksbankCurrency::TodayFetcher)
    end

    it 'returns DateFetcher instance for past days' do
      expect(past_fetcher.fetcher).to be_an_instance_of(RiksbankCurrency::DateFetcher)
    end
  end

  describe '.to_hash' do
    it 'should be Hash' do
      expect(today_fetcher.to_hash).to be_an_instance_of(Hash)
    end

    it 'has base currency in the hash' do
      expect(today_fetcher.to_hash).to include('SEK')
    end
  end

  describe '.recombine_by_base' do
    let(:rates){
      {
        'USD' => 7.0,
        'EUR' => 10.0,
        'JPY' => 0.5,
        'SEK' => 1.0
      }
    }

    let(:converted_rates) {
      {
        'USD' => 1.0,
        'EUR' => 0.7,
        'JPY' => 14.0,
        'SEK' => 7.0
      }
    }

    let(:sek_hash) { today_fetcher.send(:recombine_by_base, rates) }
    let(:usd_hash) { past_fetcher.send(:recombine_by_base, rates) }

    it 'adds base currency to the hash' do
      expect(sek_hash['SEK']).to eq(1)
      expect(usd_hash['USD']).to eq(1)
    end

    it 'does not change any values if base currency is SEK' do
      expect(sek_hash['USD']).to eq(rates['USD'])
      expect(sek_hash['EUR']).to eq(rates['EUR'])
      expect(sek_hash['JPY']).to eq(rates['JPY'])
    end

    it 'recalculates rates by @base if base currency is not SEK' do
      expect(usd_hash).to include converted_rates
    end
  end
end
