# frozen_string_literal: true

class UserInterest < ApplicationRecord
  belongs_to :user
  belongs_to :interest
end
