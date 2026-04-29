class ChaptersController < ApplicationController
  before_action :set_chapter, only: %i[ show edit update destroy ]

  def index
    @chapters = Chapter.all
  end

  def show
  end

  def new
    @chapter = Chapter.new
  end

  def edit
  end

  def create
    @chapter = Chapter.new(chapter_params)
    @chapter.user = current_user

    respond_to do |format|
      if @chapter.save
        format.turbo_stream { 
          render turbo_stream: turbo_stream.replace(
            "chapters_index", 
            partial: "chapters/chapters", 
            locals: { chapters: Chapter.all }
          )
        }
      else
        format.turbo_stream { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @chapter.update(chapter_params)
        format.turbo_stream { 
          render turbo_stream: turbo_stream.replace(
            "chapter_#{@chapter.id}", 
            partial: "chapters/card_chapter", 
            locals: { chapter: @chapter }
          )
        }
      else
        format.turbo_stream { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @chapter.destroy

    respond_to do |format|
      format.html { redirect_to chapters_path, notice: "Chapter was successfully destroyed.", status: :see_other }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chapter
      @chapter = Chapter.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def chapter_params
      params.require(:chapter).permit(:name, :description)
    end
end
