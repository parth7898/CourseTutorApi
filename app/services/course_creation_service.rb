class CourseCreationService
  def initialize(params)
    @params = params
  end

  def call
    ActiveRecord::Base.transaction do
      create_course
    end
  end

  private

  attr_reader :params

  def create_course
    course = Course.create!(
      name: params[:name],
      description: params[:description]
    )

    create_tutors(course)

    course
  end

  def create_tutors(course)
    params[:tutors].to_a.each do |tutor|
      course.tutors.create!(tutor)
    end
  end
end