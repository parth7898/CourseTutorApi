class Api::V1::CoursesController < ApplicationController
  def create
    course = CourseCreationService.new(course_params).call

    render json: course, serializer: CourseSerializer, status: :created
  end

  def index
    courses = Course.includes(:tutors)

    render json: courses, each_serializer: CourseSerializer, status: :ok
  end

  private

  def course_params
    params.require(:course).permit(:name, :description, tutors: %i[name email])
  end
end
