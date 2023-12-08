# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_commentable

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      flash[:notice] = t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      flash[:alert] = t('controllers.common.alert_create', name: Comment.model_name.human)
    end
    redirect_to @commentable
  end

  def destroy
    @comment = @commentable.comments.find(params[:id])
    @comment.destroy if current_user == @comment.user
    redirect_to @commentable
  end

  private

  def find_commentable
    @commentable = Book.find(params[:book_id]) if params[:book_id]
    @commentable = Report.find(params[:report_id]) if params[:report_id]
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
