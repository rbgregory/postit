class CommentsController < ApplicationController
  before_action :require_user

  def create
    @post = Post.find(params[:post_id])
    #@comment = Comment.new(params.require(:comment).permit(:comment))
    #@comment.post = @post
    @comment = @post.comments.build(params.require(:comment).permit(:comment)) #this line replace the above two
    @comment.creator = current_user#User.first #need to fix this after authentication

    if @comment.save
      flash[:notice] = 'Your comment was added.'
      redirect_to post_path(@post)
    else
      render 'posts/show'
    end
  end

  def vote
    require_user
    @comment = Comment.find(params[:id])
    @vote = Vote.create(voteable: @comment, creator: current_user, vote: params[:vote])
    respond_to do |format|
      format.html do
        if @vote.valid?
          flash[:notice] = "Your vote was counted."
        else
          flash[:error] = "You can only vote once."
        end
        redirect_to :back #wherever you came from...
      end
      format.js
    end
  end
end
