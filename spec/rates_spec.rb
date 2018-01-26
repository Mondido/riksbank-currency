RSpec.describe RiksbankCurrency::Rates do
  describe '.fetcher' do
    it 'returns Fetcher instance' do
      expect(subject.fetcher).to be_an_instance_of RiksbankCurrency::Fetcher
    end
  end

  describe '.currencies' do
    it 'returns array of currencies from fetched rates' do
      expect(RiksbankCurrency.currencies).to include(*(subject.currencies - ['SEK']))
    end
  end

  describe '.rate' do
    let(:predefined) {
      {
        'USD' => 10.0,
        'EUR' => 15.0,
        'RUB' => 1000.0,
        'NGD' => 0.1,
        'SEK' => 1
      }
    }

    it 'returns nil for unexisted currencies' do
      expect(subject.rate('ZZZ', 'AAA')).to be_nil
      expect(subject.rate('XXX')).to be_nil
    end

    it 'converts between any currencies' do
      rates = subject.class.new(rates: predefined)

      expect(rates.rate('USD', 'RUB')).to eq 0.01 # 10 / 1000
      expect(rates.rate('SEK', 'NGD')).to eq 10.0 # 1 / 0.1
      expect(rates.rate('EUR')).to eq 15.0
    end
  end
end
