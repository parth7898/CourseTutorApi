require "rails_helper"

RSpec.describe "Api::V1::Courses API", type: :request do
  def json
    JSON.parse(response.body)
  end

  describe "POST /api/v1/courses" do
    let(:valid_params) do
      {
        course: attributes_for(:course).merge(
          tutors: [
            {
              name: "Rahul",
              email: "rahul@test.com"
            },
            {
              name: "Amit",
              email: "amit@test.com"
            }
          ]
        )
      }
    end

    context "when request parameters are valid" do
      it "creates a course with tutors" do
        expect do
          post api_v1_courses_path, params: valid_params
        end.to change(Course, :count).by(1)
          .and change(Tutor, :count).by(2)

        expect(response).to have_http_status(:created)
        expect(json["name"]).to eq(valid_params[:course][:name])
        expect(json["description"]).to eq(valid_params[:course][:description])
        expect(json["tutors"].size).to eq(2)
      end
    end

    context "when course name is missing" do
      let(:invalid_params) do
        {
          course: {
            name: "",
            description: "Backend Framework",
            tutors: []
          }
        }
      end

      it "returns validation errors" do
        post api_v1_courses_path, params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json["errors"]).to include("Name can't be blank")
      end
    end

    context "when tutor email already exists" do
      before do
        create(:tutor, email: "rahul@test.com")
      end

      it "does not create course and rolls back the transaction" do
        expect do
          post api_v1_courses_path, params: valid_params
        end.not_to change(Course, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json["errors"]).to include("Email has already been taken")
      end
    end

    context "when tutor details are invalid" do
      let(:invalid_tutor_params) do
        {
          course: {
            name: "Ruby",
            description: "Backend",
            tutors: [
              {
                name: "",
                email: ""
              }
            ]
          }
        }
      end
      it "rolls back the transaction" do
        expect do
          post api_v1_courses_path, params: invalid_tutor_params
        end.to change(Course, :count).by(0)
        .and change(Tutor, :count).by(0)
         expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "when tutors array is empty" do
      let(:params_without_tutors) do
        {
          course: attributes_for(:course).merge(
            tutors: []
          )
        }
      end

      it "creates course successfully" do
        expect do
          post api_v1_courses_path, params: params_without_tutors
        end.to change(Course, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(Tutor.count).to eq(0)
      end
    end
  end

  describe "GET /api/v1/courses" do
    let!(:course) { create(:course) }

    before do
      create_list(:tutor, 2, course: course)
    end

    context "when courses exist" do
      it "returns all courses with tutors" do
        get api_v1_courses_path

        expect(response).to have_http_status(:ok)
        expect(json.size).to eq(1)
        expect(json.first["name"]).to eq(course.name)
        expect(json.first["description"]).to eq(course.description)
        expect(json.first["tutors"].size).to eq(2)
      end
    end

    context "when no courses exist" do
      before do
        Course.destroy_all
      end

      it "returns an empty array" do
        get api_v1_courses_path

        expect(response).to have_http_status(:ok)
        expect(json).to eq([])
      end
    end

    context "when verifying response structure" do
      it "returns expected course and tutor attributes" do
        get api_v1_courses_path

        expect(json.first.keys).to contain_exactly(
          "id",
          "name",
          "description",
          "tutors"
        )

        expect(json.first["tutors"].first.keys).to contain_exactly(
          "id",
          "name",
          "email"
        )
      end
    end
  end
end
