class UsersController < ApplicationController
  def show
    if !logged_in?
      redirect_to root_path
    else
      @posts = Post.all
      @comments = Comment.all
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = "You are registered."
      session[:user_id] = @user.id
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    if logged_in?
      @user = current_user
    else
      redirect_to login_path
    end
  end

  def update
    if @user.update(user_params)      #mass assignment
      flash[:notice] = "User was updated."
      redirect_to post_path
    else
      render :edit
    end
  end

private

  def user_params
    params.require(:user).permit(:username, :password)
  end

end
