class Api::V1::CoursesController < ApplicationController
  def create
    course = CourseCreationService.new(course_params).call

    render json: course.as_json(include: :tutors), status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  private

  def course_params
    params.require(:course).permit(:name, :description, tutors: %i[name email])
  end
end
