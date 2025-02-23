# frozen_string_literal: true

require "rails_helper"

describe "Users API", type: :request do
  describe "POST /users" do
    let!(:interest) { Interest.create!(name: "Sports") }
    let!(:skill1)   { Skill.create!(name: "Ruby") }
    let!(:skill2)   { Skill.create!(name: "Rails") }

    context "with valid parameters" do
      let(:valid_params) do
        {
          user: {
            surname: "Smith",
            name: "John",
            patronymic: "Doe",
            email: "john.smith@example.com",
            age: 30,
            nationality: "American",
            country: "USA",
            gender: "male",
            skills: "Ruby, Rails",
            interests: ["Sports"]
          }
        }
      end

      it "creates a new user and returns success" do
        expect do
          post "/users", params: valid_params
        end.to change(User, :count).by(1)

        expect(response).to have_http_status(:success)
        json_response = response.parsed_body
        expect(json_response["status"]).to eq("success")
        expect(json_response["user"]["email"]).to eq("john.smith@example.com")
      end
    end

    context "with invalid age" do
      let(:invalid_age_params) do
        {
          user: {
            surname: "Smith",
            name: "John",
            patronymic: "Doe",
            email: "john.smith@example.com",
            age: 100,  # invalid age
            nationality: "American",
            country: "USA",
            gender: "male",
            skills: "Ruby, Rails",
            interests: ["Sports"]
          }
        }
      end

      it "does not create a user and returns an age error" do
        expect do
          post "/users", params: invalid_age_params
        end.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = response.parsed_body
        expect(json_response["status"]).to eq("error")
        expect(json_response["errors"].join).to match(/Age/)
      end
    end

    context "with duplicate email" do
      let!(:existing_user) do
        User.create!(
          surname: "Smith",
          name: "John",
          patronymic: "Doe",
          email: "duplicate@example.com",
          age: 30,
          nationality: "American",
          country: "USA",
          gender: "male",
          full_name: "Smith John Doe"
        )
      end

      let(:duplicate_email_params) do
        {
          user: {
            surname: "Brown",
            name: "Charlie",
            patronymic: "Brown",
            email: "duplicate@example.com",
            age: 28,
            nationality: "American",
            country: "USA",
            gender: "male",
            skills: "Ruby, Rails",
            interests: ["Sports"]
          }
        }
      end

      it "does not create a user and returns an email error" do
        expect do
          post "/users", params: duplicate_email_params
        end.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = response.parsed_body
        expect(json_response["status"]).to eq("error")
        expect(json_response["errors"].join).to match(/already exists/)
      end
    end
  end
end
