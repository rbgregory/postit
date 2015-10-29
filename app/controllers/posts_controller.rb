class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update]
  def index
    @posts = Post.all
  end

  def show 
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.creator = User.first #TODO: change once we have authentication... this is just
                               #to make sure our post does not have a nil foreign key for
                               #the user.

    if @post.save
      flash[:notice] = "Your post was created."
      redirect_to posts_path
    else
      render :new
    end

  end

  def edit; end

  def update
    if @post.update(post_params)
      flash[:notice] = "The post was updated."
      redirect_to post_path
    else
      render :edit
    end
  end

private

#strong parameters to expose the fields we want
#to mass assign
  def post_params
    params.require(:post).permit(:title, :url, :description)
  end

  def set_post
    @post = Post.find(params[:id])
  end

end
