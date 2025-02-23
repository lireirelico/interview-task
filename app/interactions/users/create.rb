# frozen_string_literal: true

module Users
  class Create < ActiveInteraction::Base
    string  :surname
    string  :name
    string  :patronymic
    string  :email
    integer :age, greater_than: 0
    string  :nationality
    string  :country
    string  :gender
    array   :interests, default: []
    string  :skills, default: ""

    validates :gender, inclusion: { in: %w[male female] }
    validate :age_must_be_within_range

    def execute
      return add_email_error_and_return unless email_unique?

      user = create_user(build_full_name)
      associate_interests(user)
      associate_skills(user)
      user
    end

    private

    def age_must_be_within_range
      errors.add(:age, "must be less than or equal to 90") if age > 90
    end

    def email_unique?
      !User.exists?(email:)
    end

    def add_email_error_and_return
      errors.add(:email, "already exists")
      nil
    end

    def build_full_name
      "#{surname} #{name} #{patronymic}"
    end

    def create_user(full_name)
      User.create!(
        surname:,
        name:,
        patronymic:,
        email:,
        age:,
        nationality:,
        country:,
        gender:,
        full_name:
      )
    end

    def associate_interests(user)
      interests.each do |interest_name|
        if (interest = Interest.find_by(name: interest_name))
          user.interests << interest
        end
      end
    end

    def associate_skills(user)
      user_skills = skills.split(",").map { |skill_name| Skill.find_by(name: skill_name.strip) }.compact
      user.skills << user_skills
    end
  end
end
