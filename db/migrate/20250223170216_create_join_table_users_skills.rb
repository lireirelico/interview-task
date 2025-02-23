# frozen_string_literal: true

class CreateJoinTableUsersSkills < ActiveRecord::Migration[7.1]
  def change
    create_join_table :users, :skills do |t|
      t.index %i[user_id skill_id]
      t.index %i[skill_id user_id]
    end
  end
end
