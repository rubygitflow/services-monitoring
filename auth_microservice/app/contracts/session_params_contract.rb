# frozen_string_literal: true

require 'dry/validation'

class SessionParamsContract < Dry::Validation::Contract
  params do
    optional(:email).value(:string)
    optional(:password).value(:string)
  end

  # https://dry-rb.org/gems/dry-validation/1.8/
  rule(:email) do
    if !key? || values[:email].blank?
      key.failure(I18n.t(:blank, scope: 'model.errors.user.email',
                                 default: 'missing parameter'))
    end
  end

  rule(:password) do
    if !key? || values[:password].blank?
      key.failure(I18n.t(:blank, scope: 'model.errors.user.password',
                                 default: 'missing parameter'))
    end
  end
end
