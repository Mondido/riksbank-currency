RSpec.describe RiksbankCurrency::Helper do
  describe '#currency_from_seriesid' do
    it 'parses currency ISO from Riksbank seriesid' do
      expect(subject.currency_from_seriesid('SEKNOKPMI')).to eq 'NOK'
      expect(subject.currency_from_seriesid('SEKPMIPMI')).to eq 'PMI'
    end
  end

  describe '#currency_to_seriesid' do
    it 'generates riksbank seriesid from currency code' do
      %w(USD usd UsD).each do |code|
        expect(subject.currency_to_seriesid(code)).to eq 'SEKUSDPMI'
      end
    end
  end

  describe '#format_date' do
    it 'converts ruby Date to riksbank string format' do
      expect(subject.format_date(Date.new(2010, 1, 1))).to eq '2010-01-01'
      expect(subject.format_date(Date.new(2018, 12, 3))).to eq '2018-12-03'
    end
  end

  describe '#parse_date' do
    let(:date) { subject.parse_date('2015-02-03') }

    it 'returns Date object' do
      expect(date).to be_an_instance_of(Date)
    end

    it 'parses riksbank date and returns ruby Date' do
      expect(date.year).to eq 2015
      expect(date.month).to eq 2
      expect(date.day).to eq 3
    end
  end
end
