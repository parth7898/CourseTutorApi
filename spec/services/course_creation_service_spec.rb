require "rails_helper"

RSpec.describe CourseCreationService, type: :service do
  describe "#call" do
    subject(:service) { described_class.new(params) }

    let(:params) do
      attributes_for(:course).merge(
        tutors: [
          {
            name: Faker::Name.name,
            email: Faker::Internet.unique.email
          },
          {
            name: Faker::Name.name,
            email: Faker::Internet.unique.email
          }
        ]
      )
    end

    context "when parameters are valid" do
      it "creates a course with tutors" do
        course = nil

        expect do
          course = service.call
        end.to change(Course, :count).by(1)
          .and change(Tutor, :count).by(2)

        expect(course).to be_persisted
        expect(course.name).to eq(params[:name])
        expect(course.description).to eq(params[:description])
        expect(course.tutors.count).to eq(2)
      end
    end

    context "when course is invalid" do
      let(:params) do
        attributes_for(:course, name: nil).merge(
          tutors: []
        )
      end

      it "raises RecordInvalid" do
        expect { service.call }
          .to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "when tutor email already exists" do
      let!(:existing_tutor) { create(:tutor) }

      let(:params) do
        attributes_for(:course).merge(
          tutors: [
            {
              name: Faker::Name.name,
              email: existing_tutor.email
            }
          ]
        )
      end

      it "does not create a new course" do
        expect do
          begin
            service.call
          rescue ActiveRecord::RecordInvalid
          end
        end.not_to change(Course, :count)
      end
    end

    context "when tutor is invalid" do
      let(:params) do
        attributes_for(:course).merge(
          tutors: [
            {
              name: "",
              email: ""
            }
          ]
        )
      end

      it "rolls back the transaction" do
        expect do
          begin
            service.call
          rescue ActiveRecord::RecordInvalid
          end
        end.not_to change(Course, :count)

        expect(Tutor.count).to eq(0)
      end
    end

    context "when tutors are empty" do
      let(:params) do
        attributes_for(:course).merge(
          tutors: []
        )
      end

      it "creates only the course" do
        course = service.call

        expect(course).to be_persisted
        expect(course.tutors).to be_empty
      end
    end
  end
end