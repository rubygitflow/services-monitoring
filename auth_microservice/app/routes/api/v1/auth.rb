# frozen_string_literal: true

class AuthMicroservice
  include Authi
  include ApiErrors

  hash_path('/api/v1/auth') do |r|
    r.is do
      r.post do
        k = extracted_token['uuid']

        result = Auth::FetchUserService.call(k)

        if result.success?
          meta = { user_id: result.user.id }

          response.status = 200
          { meta: meta }
        else
          response.status = 403
          error_response(result.errors)
        end
      end
    end
  end
end
