# frozen_string_literal: true

RSpec.describe UserSessions::CreateService do
  subject(:session) { described_class }

  context 'with valid parameters' do
    let!(:user) { create(:user, email: 'bob@example.com', password: 'givemeatoken') }

    it 'creates a new session' do
      expect { session.call('bob@example.com', 'givemeatoken') }
        .to change { user.sessions(reload: true).count }.from(0).to(1)
    end

    it 'assigns session' do
      result = session.call('bob@example.com', 'givemeatoken')

      expect(result.session).to be_kind_of(UserSession)
    end
  end

  context 'with missing user' do
    it 'does not create session' do
      expect { session.call('bob@example.com', 'givemeatoken') }
        .not_to change(UserSession, :count)
    end

    it 'adds an error' do
      result = session.call('bob@example.com', 'givemeatoken')

      expect(result).to be_failure
    end

    it 'is recognizable' do
      result = session.call('bob@example.com', 'givemeatoken')

      expect(result.errors).to include("The session can't be created")
    end
  end

  context 'with invalid password' do
    before do
      create(:user, email: 'bob@example.com', password: 'givemeatoken')
    end

    it 'does not create session' do
      expect { session.call('bob@example.com', 'invalid') }
        .not_to change(UserSession, :count)
    end

    it 'adds an error' do
      result = session.call('bob@example.com', 'invalid')

      expect(result).to be_failure
    end

    it 'is recognizable' do
      result = session.call('bob@example.com', 'invalid')

      expect(result.errors).to include("The session can't be created")
    end
  end
end
