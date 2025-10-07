module Admin
  class ExamsController < Admin::BaseController
    before_action :set_exam, only: %i[ edit update destroy ]

    # GET /exams or /exams.json
    def index
      @exams = Exam.all
    end

    # GET /exams/new
    def new
      @exam = Exam.new
    end

    # GET /exams/1/edit
    def edit
    end

    # POST /exams or /exams.json
    def create
      @exam = Exam.new(exam_params)

      respond_to do |format|
        if @exam.save
          format.html { redirect_to admin_exams_path, notice: "Exam was successfully created." }
          format.json { render json: @exam, status: :created }
        else
          format.html do
            @exams = Exam.all
            render :index, status: :unprocessable_entity
          end
          format.json { render json: { errors: @exam.errors }, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /exams/1 or /exams/1.json
    def update
      respond_to do |format|
        if @exam.update(exam_params)
          format.html { redirect_to admin_exams_path, notice: "Exam was successfully updated.", status: :see_other }
          format.json { render json: @exam, status: :ok }
        else
          format.html do
            @exams = Exam.all
            render :index, status: :unprocessable_entity
          end
          format.json { render json: { errors: @exam.errors }, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /exams/1 or /exams/1.json
    def destroy
      @exam.destroy!

      respond_to do |format|
        format.html { redirect_to admin_exams_path, notice: "Exam was successfully destroyed.", status: :see_other }
        format.json { head :no_content }
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_exam
      @exam = Exam.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def exam_params
      params.require(:exam).permit(:label, :description)
    end
  end
end