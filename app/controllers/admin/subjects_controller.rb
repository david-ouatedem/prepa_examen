module Admin
  class SubjectsController < Admin::BaseController
    before_action :set_subject, only: %i[ show edit update destroy ]

    def index
      @subjects = Subject.all
      @specialities = Speciality.all
    end

    def show; end

    def new
      @subject = Subject.new
      @specialities = Speciality.all
    end

    def edit
      @specialities = Speciality.all
    end

    def create
      @subject = Subject.new(subject_params)

      respond_to do |format|
        if @subject.save
          format.html { redirect_to admin_subjects_path, notice: "Subject was successfully created." }
          format.json { render json: @subject, status: :created }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: { errors: @subject.errors }, status: :unprocessable_entity }
        end
      end
    end


    def update
      @subject = Subject.find(params[:id])

      respond_to do |format|
        if @subject.update(subject_params)
          format.html { redirect_to admin_subjects_path, notice: "Subject was successfully updated." }
          format.json { render json: @subject, status: :ok }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: { errors: @subject.errors }, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @subject.destroy
      redirect_to admin_subjects_path, notice: "Subject was successfully destroyed."
    end

    private

    def set_subject
      @subject = Subject.find(params[:id])
    end

    def subject_params
      params.require(:subject).permit(:label, :description, :year, speciality_ids: [])
    end
  end
end
