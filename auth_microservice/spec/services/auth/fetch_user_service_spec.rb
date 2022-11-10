# frozen_string_literal: true

RSpec.describe Auth::FetchUserService do
  subject(:auth) { described_class }

  context 'with valid parameters' do
    let(:session) { create(:user_session) }

    it 'assigns user' do
      result = auth.call(session.uuid)

      expect(result.user).to eq(session.user)
    end
  end

  context 'with invalid parameters' do
    it 'does not assign user' do
      result = auth.call('invalid')

      expect(result.user).to be_nil
    end

    it 'adds an error' do
      result = auth.call('invalid')

      expect(result).to be_failure
    end

    it 'is recognizable' do
      result = auth.call('invalid')

      expect(result.errors).to include('Access to the resource is limited')
    end
  end
end
