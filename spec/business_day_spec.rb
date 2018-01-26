RSpec.describe RiksbankCurrency::BusinessDay do
  describe '#get_latest' do
    let!(:weekend){ subject.get_latest(Date.new(2018, 1, 20)) }
    let!(:new_year){ subject.get_latest(Date.new(2018, 1, 1)) }
    let!(:typical_day){ subject.get_latest(Date.new(2018, 1, 26)) }

    it 'returns Date object' do
      expect(typical_day).to be_an_instance_of(Date)
    end

    it 'takes the nearest previous working day for holidays' do
      expect(weekend).to eq Date.new(2018, 1, 19) # Friday
      expect(new_year).to eq Date.new(2017, 12, 29) # long holidays for the New Year
    end

    it 'returns the same day for typical working day' do
      expect(typical_day).to eq Date.new(2018, 1, 26)
    end
  end
end
