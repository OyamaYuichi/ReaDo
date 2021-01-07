class MemosController < ApplicationController
  before_action :set_memo, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def new
    @memo = Memo.new
    @book = Book.find(params[:book_id])
    category = @book.summaries.pluck(:category)
    if category.count < 1
      @category_1 = @book.summaries.categories_i18n.first[1]
    elsif category.count < 2
      @category_1 = @book.summaries.first.category_i18n
    elsif category.count < 3
      @category_1 = @book.summaries.first.category_i18n
      @category_2 = @book.summaries.second.category_i18n
    else
      @category_1 = @book.summaries.first.category_i18n
      @category_2 = @book.summaries.second.category_i18n
      @category_3 = @book.summaries.third.category_i18n
    end
  end

  def create
    @book = Book.find(params[:book_id])
    @memo = @book.memos.build(memo_params)
    @memo.user_id = current_user.id
    if @memo.save
      UserMailer.notify_user().deliver
      read_level = Memo.calc_level(current_user)
      current_user.update(level: read_level.floor)
      redirect_to summaries_path, notice: t('view.create_notice')
    else
      render :new
    end
  end


  def show
    category = @memo.book.summaries.pluck(:category)
    if category.count < 1
      @category_1 = @memo.book.summaries.categories_i18n.first[1]
    elsif category.count < 2
      @category_1 = @memo.book.summaries.first.category_i18n
    elsif category.count < 3
      @category_1 = @memo.book.summaries.first.category_i18n
      @category_2 = @memo.book.summaries.second.category_i18n
    else
      @category_1 = @memo.book.summaries.first.category_i18n
      @category_2 = @memo.book.summaries.second.category_i18n
      @category_3 = @memo.book.summaries.third.category_i18n
    end
  end

  def edit
    @book = @memo.book
    category = @book.summaries.pluck(:category)
    if category.count < 1
      @category_1 = @book.summaries.categories_i18n.first[1]
    elsif category.count < 2
      @category_1 = @book.summaries.first.category_i18n
    elsif category.count < 3
      @category_1 = @book.summaries.first.category_i18n
      @category_2 = @book.summaries.second.category_i18n
    else
      @category_1 = @book.summaries.first.category_i18n
      @category_2 = @book.summaries.second.category_i18n
      @category_3 = @book.summaries.third.category_i18n
    end
  end

  def update
    if @memo.update(memo_params)
      UserMailer.notify_user().deliver
      redirect_to memo_path(@memo), notice: t('view.edit_notice')
    else
      @book = @memo.book
      render :edit
    end
  end

  def destroy
    @memo.destroy
    UserMailer.notify_user().deliver
    read_level = Memo.calc_level(current_user)
    current_user.update(level: read_level.floor)
    redirect_to user_path(current_user), notice: t('view.destroy_notice')
  end

  private
  def memo_params
    params.require(:memo).permit(:content, :action_plan, :email_send)
  end

  def set_memo
    @memo = Memo.find(params[:id])
  end
end
