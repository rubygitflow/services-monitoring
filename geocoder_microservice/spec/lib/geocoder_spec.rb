# frozen_string_literal: true

RSpec.describe Geocoder, type: :lib do
  describe 'GET response from lib' do
    subject(:geocoder) { described_class }

    context 'with an existing city' do
      it 'returns Kazan coordinates' do
        expect(geocoder.geocode('Казань')).to eq([55.7943584, 49.1114975])
      end
    end

    context 'with a nonexistent city' do
      it 'returns nil' do
        expect(geocoder.geocode('Казаньъ')).to eq(nil)
      end
    end
  end
end
