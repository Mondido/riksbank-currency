RSpec.describe RiksbankCurrency do
  describe 'module variable @@currencies' do
    it 'can be changed' do
      expect{ RiksbankCurrency.currencies << 'SOME' }
        .to change{ RiksbankCurrency.currencies.count }.by(1)
    end
  end
end
