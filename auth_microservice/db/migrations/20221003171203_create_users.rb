# frozen_string_literal: true

# https://sequel.jeremyevans.net/rdoc/files/doc/schema_modification_rdoc.html
# https://github.com/jeremyevans/sequel/blob/master/doc/migration.rdoc
# https://medium.com/@barryf/using-json-in-postgres-with-ruby-and-sequel-897304158374
Sequel.migration do
  up do
    run 'CREATE EXTENSION IF NOT EXISTS citext'

    create_table(:users) do
      primary_key :id, type: :Bignum
      column :name, 'character varying', null: false
      column :email, 'citext', null: false
      column :password_digest, 'character varying', null: false
      column :created_at, 'timestamp(6) with time zone', null: false
      column :updated_at, 'timestamp(6) with time zone', null: false

      index [:email], name: :index_users_on_email, unique: true
    end
  end

  down do
    alter_table(:users) do
      drop_index [:email], name: :index_users_on_email
    end
    drop_table(:users)
  end
end
