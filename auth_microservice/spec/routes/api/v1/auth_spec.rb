# frozen_string_literal: true

RSpec.describe AuthMicroservice, type: :routes do
  describe 'POST /api/v1/auth' do
    context 'with valid auth token' do
      let!(:user) { create(:user) }

      it 'returns corresponding user' do
        header 'Authorization', auth_token(user)
        post '/api/v1/auth'

        expect(response_body['meta']).to eq('user_id' => user.id)
      end

      it 'has status 200' do
        header 'Authorization', auth_token(user)
        post '/api/v1/auth'

        expect(last_response.status).to eq(200)
      end
    end

    context 'with invalid auth token' do
      it 'returns an error' do
        header 'Authorization', 'auth.token'
        post '/api/v1/auth'

        expect(last_response.status).to eq(403)
      end
    end

    context 'with missing auth token' do
      it 'returns an error' do
        post '/api/v1/auth'

        expect(last_response.status).to eq(403)
      end
    end
  end
end
