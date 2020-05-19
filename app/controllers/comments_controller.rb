class CommentsController < ApplicationController
  before_action :user_logged_in?, only: [:create, :destroy, :new]

  def new
    @comment = Comment.new(discovery_id: params[:discovery_id])
  end

  def create
    @comment = current_user.comments.new(comment_params)
    @comment.discovery_id = params[:discovery_id]
    if @comment.save
      redirect_to discovery_path(@comment.discovery_id)
    else
      render "new"
    end
  end

  def show
    @comment = Comment.find(params[:id])
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

end
