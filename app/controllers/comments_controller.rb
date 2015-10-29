class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    #@comment = Comment.new(params.require(:comment).permit(:comment))
    #@comment.post = @post
    @comment = @post.comments.build(params.require(:comment).permit(:comment)) #this line replace the above two
    @comment.creator = User.first #need to fix this after authentication

    if @comment.save
      flash[:notice] = 'Your comment was added.'
      redirect_to post_path(@post)
    else
      render 'posts/show'
    end
  end
end
