class CommentsController < ApplicationController
  before_action :user_logged_in?, only: [:create, :destroy, :new]
  before_action :correct_user?, only: [:destroy]


  def new
    if params[:discovery_id]
    @comment = Comment.new(discovery_id: params[:discovery_id])
    else
    @comment = Comment.new(forcomment_id: params[:forcomment_id])
  end
  end


  def create
    @comment = current_user.comments.new(comment_params)
    if params[:discovery_id].present?
    @comment.discovery_id = params[:discovery_id]
    else
    @comment.forcomment_id = params[:forcomment_id]
    end
    if @comment.save
      if @comment.discovery_id
      redirect_to discovery_path(@comment.discovery_id)
    else
      redirect_to comment_path(@comment.forcomment_id)
    end
    else
      render "new"
    end
  end


  def show
    @comment = Comment.find(params[:id])
    @forcomment = @comment.forcomments
  end

  def destroy
    @comment.destroy
    flash[:danger] = "削除しました"
    if @comment.discovery_id
      redirect_to discovery_path(@comment.discovery)
    else
      redirect_to comment_path(@comment.forcomment)
    end
  end


  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def correct_user?
    @comment = Comment.find(params[:id])
    unless @comment.user == current_user
      flash[:danger] = "他のユーザーのコメントは削除できません"
      redirect_to comment_path(@comment)
    end
  end

end
