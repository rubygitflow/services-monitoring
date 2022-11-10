# frozen_string_literal: true

# https://sequel.jeremyevans.net/rdoc/files/doc/schema_modification_rdoc.html
# https://github.com/jeremyevans/sequel/blob/master/doc/migration.rdoc
# https://medium.com/@barryf/using-json-in-postgres-with-ruby-and-sequel-897304158374
Sequel.migration do
  up do
    create_table(:user_sessions) do
      primary_key :id, type: :Bignum
      column :uuid, 'uuid', null: false
      foreign_key :user_id, :users, type: 'bigint', null: false, key: [:id]
      column :created_at, 'timestamp(6) with time zone', null: false
      column :updated_at, 'timestamp(6) with time zone', null: false

      index [:user_id], name: :index_user_sessions_on_user_id
      index [:uuid], name: :index_user_sessions_on_uuid
    end
  end

  down do
    alter_table(:users) do
      drop_index [:uuid], name: :index_user_sessions_on_uuid
    end
    alter_table(:users) do
      drop_index [:user_id], name: :index_user_sessions_on_user_id
    end
    drop_table(:user_sessions)
  end
end
