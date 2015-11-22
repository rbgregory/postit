class PostsController < ApplicationController
  # purpose of before_action:
  # 1. set up something
  # 2. redirect away from action
  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:index, :show]

  def index
    @posts = Post.all.sort_by{|x| x.total_votes}.reverse
  end

  def show
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.creator = current_user  #User.first #TODO: change once we have authentication... this is just
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
    if @post.update(post_params)      #mass assignment
      flash[:notice] = "The post was updated."
      redirect_to post_path
    else
      render :edit
    end
  end

  def vote
    require_user
      @vote = Vote.create(voteable: @post, creator: current_user, vote: params[:vote])

      if @vote.valid?
        flash[:notice] = "Your vote was counted."
      else
        flash[:error] = "You can only vote once."
      end
      redirect_to :back #wherever you came from...
  end

private

#strong parameters to expose the fields we want
#to mass assign
  def post_params
    params.require(:post).permit(:title, :url, :description, category_ids: [])  #notice special syntax for virtual attribute that is an array
  end

  def set_post
    @post = Post.find(params[:id])
  end

end
