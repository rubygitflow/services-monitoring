# frozen_string_literal: true

old_user_ids = User.where(name: 'admin').map(:id)
return unless old_user_ids.size.zero?
user = User.new
user.name = 'admin'
user.email = 'admin@example.com'
user.password = 'password'
user.password_confirmation = 'password'
user.save
