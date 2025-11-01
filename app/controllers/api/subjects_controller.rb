module Api
  class SubjectsController < ApplicationController
    include Rails.application.routes.url_helpers

    def index
      subjects = Subject.filter(params)

      # Mark the response to verify the executing controller/action and disable stale caches
      response.set_header "X-Api-Subjects", "v2"

      render json: subjects.map { |subject|
        {
          id: subject.id,
          label: subject.label,
          description: subject.description,
          year: subject.year,
          file_url: subject.file.attached? ? rails_blob_url(subject.file, host: request.base_url) : nil
        }
      }
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
end
