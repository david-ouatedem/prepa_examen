module Api
  class SpecialitiesController < ApplicationController
    def index
      @specialities = if params[:exam_id].present?
                        Speciality.where(exam_id: params[:exam_id])
                      else
                        Speciality.all
                      end
      render json: @specialities.select(:id, :label)
    end
  end
end
