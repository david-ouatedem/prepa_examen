module Api
  class SubjectsController < ApplicationController
    include Rails.application.routes.url_helpers

    def index
      subjects = Subject.all

      # Filter by speciality if provided
      if params[:speciality_id].present?
        subjects = subjects.joins(:specialities)
                           .where(specialities: { id: params[:speciality_id] })
      end

      # Filter by exam if provided
      if params[:exam_id].present?
        subjects = subjects.joins(:specialities)
                           .where(specialities: { exam_id: params[:exam_id] })
      end

      subjects = subjects.distinct

      render json: subjects.map { |s|
        {
          id: s.id,
          label: s.label,
          description: s.description,
          year: s.year,
          file_url: s.file.attached? ? rails_blob_url(s.file, host: request.base_url) : nil
        }
      }
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
end
