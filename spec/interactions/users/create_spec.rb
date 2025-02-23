# frozen_string_literal: true

require "rails_helper"

describe Users::Create, type: :interaction do
  let!(:interest) { Interest.create!(name: "Sports") }
  let!(:ruby_skill) { Skill.create!(name: "Ruby") }
  let!(:rails_skill) { Skill.create!(name: "Rails") }

  context "with valid parameters" do
    let(:params) do
      {
        surname: "Smith",
        name: "John",
        patronymic: "Doe",
        email: "john.smith@example.com",
        age: 30,
        nationality: "American",
        country: "USA",
        gender: "male",
        interests: ["Sports"],
        skills: "Ruby, Rails"
      }
    end

    it "creates a user with interests and skills via join models" do
      result = Users::Create.run(params)
      expect(result).to be_valid
      user = result.result

      expect(user.email).to eq("john.smith@example.com")
      expect(user.interests.map(&:name)).to include("Sports")
      expect(user.skills.map(&:name)).to include("Ruby", "Rails")

      # Verify that join records are created
      expect(user.user_interests.count).to eq(1)
      expect(user.user_skills.count).to eq(2)
    end
  end

  context "with invalid age" do
    let(:params) do
      {
        surname: "Smith",
        name: "John",
        patronymic: "Doe",
        email: "john.smith@example.com",
        age: 100, # invalid age
        nationality: "American",
        country: "USA",
        gender: "male"
      }
    end

    it "does not create a user and returns an age error" do
      result = Users::Create.run(params)
      expect(result).not_to be_valid
      expect(result.errors.full_messages).to include(/Age/)
    end
  end

  context "with duplicate email" do
    before do
      User.create!(
        surname: "Smith",
        name: "John",
        patronymic: "Doe",
        email: "duplicate@example.com",
        age: 25,
        nationality: "American",
        country: "USA",
        gender: "male",
        full_name: "Smith John Doe"
      )
    end

    let(:params) do
      {
        surname: "Brown",
        name: "Charlie",
        patronymic: "Brown",
        email: "duplicate@example.com", # duplicate email
        age: 28,
        nationality: "American",
        country: "USA",
        gender: "male",
        interests: ["Sports"],
        skills: "Ruby, Rails"
      }
    end

    it "does not create a user due to duplicate email" do
      result = Users::Create.run(params)
      expect(result).not_to be_valid
      expect(result.errors[:email]).to include("already exists")
    end
  end

  context "with invalid gender" do
    let(:params) do
      {
        surname: "Smith",
        name: "John",
        patronymic: "Doe",
        email: "john.smith@example.com",
        age: 30,
        nationality: "American",
        country: "USA",
        gender: "other", # invalid gender value
        interests: ["Sports"],
        skills: "Ruby, Rails"
      }
    end

    it "does not create a user and returns a gender error" do
      result = Users::Create.run(params)
      expect(result).not_to be_valid
      expect(result.errors.full_messages).to include(/Gender/)
    end
  end

  context "with missing required parameters" do
    let(:params) do
      {
        # missing surname
        name: "John",
        patronymic: "Doe",
        email: "john.smith@example.com",
        age: 30,
        nationality: "American",
        country: "USA",
        gender: "male"
      }
    end

    it "does not create a user and returns an error for missing surname" do
      result = Users::Create.run(params)
      expect(result).not_to be_valid
      expect(result.errors.full_messages).to include(/Surname/)
    end
  end

  context "with non-existent interest" do
    let(:params) do
      {
        surname: "Smith",
        name: "John",
        patronymic: "Doe",
        email: "john.smith@example.com",
        age: 30,
        nationality: "American",
        country: "USA",
        gender: "male",
        interests: ["NonExistentInterest"],
        skills: "Ruby, Rails"
      }
    end

    it "creates a user without associating non-existent interests" do
      result = Users::Create.run(params)
      expect(result).to be_valid
      user = result.result
      expect(user.interests).to be_empty
      expect(user.user_interests.count).to eq(0)
    end
  end

  context "with empty skills string" do
    let(:params) do
      {
        surname: "Smith",
        name: "John",
        patronymic: "Doe",
        email: "john.smith@example.com",
        age: 30,
        nationality: "American",
        country: "USA",
        gender: "male",
        interests: ["Sports"],
        skills: ""
      }
    end

    it "creates a user without any associated skills" do
      result = Users::Create.run(params)
      expect(result).to be_valid
      user = result.result
      expect(user.skills).to be_empty
      expect(user.user_skills.count).to eq(0)
    end
  end
end
