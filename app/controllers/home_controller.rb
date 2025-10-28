class HomeController < ApplicationController
  def index
    @exams = Exam.all
    @specialities = Speciality.all
    @subjects = Subject.all

    if params[:exam_id].present?
      @specialities = @specialities.where(exam_id: params[:exam_id])
    end

    if params[:speciality_id].present?
      @subjects = @subjects.joins(:specialities).where(specialities: { id: params[:speciality_id] })
    end
  end
end
