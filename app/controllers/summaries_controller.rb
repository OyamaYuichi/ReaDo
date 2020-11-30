class SummariesController < ApplicationController
  before_action :set_summary, only: [:show, :edit, :update, :destroy]

  def index
    @summaries = Summary.all
  end

  def new
      @summary = Summary.new
  end

  def create
    @summary = Summary.new(summary_params)
    if params[:back]
      render :new
    else
      if @summary.save
        redirect_to summaries_path, notice: "投稿しました！"
      else
        render :new
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    if @summary.update(summary_params)
      redirect_to summaries_path, notice: "編集しました！"
    else
      render :edit
    end
  end

  def destroy
    @summary.destroy
    redirect_to summaries_path, notice: "削除しました！"
  end

  # def confirm
  #   @mouth = Mouth.new(mouth_params)
  #   render :new if @mouth.invalid?
  # end

  private
  def summary_params
    params.require(:summary).permit(:content)
  end

  def set_summary
    @summary = Summary.find(params[:id])
  end
end
