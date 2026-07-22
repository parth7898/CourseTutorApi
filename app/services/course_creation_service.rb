class CourseCreationService
  def initialize(params)
    @params = params
  end

  def call
    ActiveRecord::Base.transaction do
      course = create_course
      create_tutors(course)

      course
    end
  end

  private

  attr_reader :params

  def create_course
    Course.create!(
      name: params[:name],
      description: params[:description]
    )
  end

  def create_tutors(course)
    return unless params[:tutors].present?

    params[:tutors].each do |tutor|
      course.tutors.create!(
        name: tutor[:name],
        email: tutor[:email]
      )
    end
  end
end
