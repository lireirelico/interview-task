# frozen_string_literal: true

class CreateInterests < ActiveRecord::Migration[7.1]
  def change
    create_table :interests do |t|
      t.string :name

      t.timestamps
    end
  end
end
