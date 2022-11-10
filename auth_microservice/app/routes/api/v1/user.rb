# frozen_string_literal: true

class AuthMicroservice
  include Validations
  include ApiErrors

  hash_path('/api/v1/user') do |r|
    r.is do
      r.post do
        user_params = validate_with!(UserParamsContract)

        result = Users::CreateService.call(*user_params.to_h.values)

        if result.success?
          response.status = 201
          {}
        else
          response.status = 422
          error_response result.user
        end
      end
    end
  end
end
