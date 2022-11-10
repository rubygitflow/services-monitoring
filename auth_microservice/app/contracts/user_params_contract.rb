# frozen_string_literal: true

require 'dry/validation'

class UserParamsContract < Dry::Validation::Contract
  params do
    optional(:name).value(:string)
    optional(:email).value(:string)
    optional(:password).value(:string)
  end

  # https://dry-rb.org/gems/dry-validation/1.8/rules/
  rule(:name) do
    if !key? || values[:name].blank?
      key.failure(I18n.t(:blank, scope: 'model.errors.user.name',
                                 default: 'missing parameter'))
    end
  end

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
