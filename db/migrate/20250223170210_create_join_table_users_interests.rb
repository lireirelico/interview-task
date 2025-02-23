# frozen_string_literal: true

class CreateJoinTableUsersInterests < ActiveRecord::Migration[7.1]
  def change
    create_join_table :users, :interests do |t|
      t.index %i[user_id interest_id]
      t.index %i[interest_id user_id]
    end
  end
end
