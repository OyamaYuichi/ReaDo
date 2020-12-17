class CommentsController < ApplicationController
  before_action :set_summary, only: [:create, :edit, :update]

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
        format.html { redirect_to summary_path(@summary), notice: '投稿できませんでした...' }
      end
    end
  end


  def edit
    @comment = @summary.comments.find(params[:id])
    respond_to do |format|
      flash.now[:notice] = 'コメントの編集中'
      format.js { render :edit }
    end
  end

  def update
    @comment = @summary.comments.find(params[:id])
    respond_to do |format|
      if @comment.update(comment_params)
        flash.now[:notice] = 'コメントが編集されました'
        format.js { render :index }
      else
        flash.now[:notice] = 'コメントの編集に失敗しました'
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
      flash.now[:notice] = 'コメントが削除されました'
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
