class CommentsController < ApplicationController
  before_action :set_summary, only: [:create, :edit, :update]
  before_action :authenticate_user!

  def create
    @summary = Summary.find(params[:summary_id])
    @comment = @summary.comments.build(comment_params)
    @comment.user_id = current_user.id
    respond_to do |format|
      if @comment.save
        calc_level
        current_user.update(level: @read_level.floor)
        format.js { render :index }
      else
        format.html { redirect_to summary_path(@summary) }
      end
    end
  end


  def edit
    @comment = @summary.comments.find(params[:id])
    respond_to do |format|
      format.js { render :edit }
    end
  end

  def update
    @comment = @summary.comments.find(params[:id])
    respond_to do |format|
      if @comment.update(comment_params)
        format.js { render :index }
      else
        format.js { render :edit_error }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    calc_level
    current_user.update(level: @read_level.floor)
    respond_to do |format|
      format.js { render :index }
    end
  end

  def calc_level
    @read_level = current_user.summaries.count * 0.6
                  + current_user.memos.count * 0.2
                  + current_user.reviews.count * 0.1
                  + current_user.comments.count * 0.1
  end

  private
  def comment_params
    params.require(:comment).permit(:summary_id, :content)
  end

  def set_summary
    @summary = Summary.find(params[:summary_id])
  end
end
