module Admin
  class SpecialitiesController < Admin::BaseController
    before_action :set_speciality, only: %i[ edit update destroy ]

    # GET /specialities or /specialities.json
    def index
      @specialities = Speciality.includes(:exam).all
      @exams = Exam.all
    end

    # GET /specialities/new
    def new
      @speciality = Speciality.new
    end

    # GET /specialities/1/edit
    def edit
    end

    # POST /specialities or /specialities.json
    def create
      @speciality = Speciality.new(speciality_params)

      respond_to do |format|
        if @speciality.save
          format.html { redirect_to admin_specialities_path, notice: "Speciality was successfully created." }
          format.json { render json: @speciality, status: :created }
        else
          format.html do
            @specialities = Speciality.includes(:exam).all
            @exams = Exam.all
            render :index, status: :unprocessable_entity
          end
          format.json { render json: { errors: @speciality.errors }, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /specialities/1 or /specialities/1.json
    def update
      respond_to do |format|
        if @speciality.update(speciality_params)
          format.html { redirect_to admin_specialities_path, notice: "Speciality was successfully updated.", status: :see_other }
          format.json { render json: @speciality, status: :ok }
        else
          format.html do
            @specialities = Speciality.includes(:exam).all
            @exams = Exam.all
            render :index, status: :unprocessable_entity
          end
          format.json { render json: { errors: @speciality.errors }, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /specialities/1 or /specialities/1.json
    def destroy
      @speciality.destroy!

      respond_to do |format|
        format.html { redirect_to admin_specialities_path, notice: "Speciality was successfully destroyed.", status: :see_other }
        format.json { head :no_content }
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_speciality
      @speciality = Speciality.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def speciality_params
      params.require(:speciality).permit(:label, :description, :exam_id)
    end
  end
end