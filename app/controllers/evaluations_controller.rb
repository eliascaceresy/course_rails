class EvaluationsController < ApplicationController
  before_action :set_evaluation, only: %i[ show edit update destroy ]

  def index
    @evaluations = Evaluation.all
  end

  def show
  end

  def new
    @evaluation = Evaluation.new
  end

  def edit
  end

  def create
    @evaluation = Evaluation.new(evaluation_params)
    @evaluation.user = current_user

    respond_to do |format|
      if @evaluation.save
        format.turbo_stream { 
          render turbo_stream: turbo_stream.replace(
            "evaluations_index", 
            partial: "evaluations/evaluations", 
            locals: { evaluations: Evaluation.all }
          )
        }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @evaluation.update(evaluation_params)
        format.html { redirect_to @evaluation, notice: "Evaluation was successfully updated.", status: :see_other }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @evaluation.destroy

    respond_to do |format|
      format.html { redirect_to evaluations_path, notice: "Evaluation was successfully destroyed.", status: :see_other }
    end
  end

  private
    def set_evaluation
      @evaluation = Evaluation.find(params[:id])
    end

    def evaluation_params
      params.require(:evaluation).permit(:name, :description, :body)
    end
end
